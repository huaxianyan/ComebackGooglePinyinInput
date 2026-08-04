using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Windows.Forms;

namespace AdbLanForwarder
{
    internal sealed class Config
    {
        public string ListenAddresses = "192.168.17.77,192.168.27.77";
        public int ListenPort = 15037;
        public string AllowedClients = "192.168.17.78,192.168.27.78";
        public string AdbHost = "127.0.0.1";
        public int AdbPort = 5037;
        public string AdbPath = "adb.exe";

        public static Config Load(string path)
        {
            var c = new Config();
            if (!File.Exists(path))
            {
                File.WriteAllText(path,
                    "# ADB LAN Forwarder configuration\r\n" +
                    "# Bind only trusted LAN/ZeroTier interfaces. Never use 0.0.0.0 on an untrusted network.\r\n" +
                    "ListenAddresses=" + c.ListenAddresses + "\r\n" +
                    "ListenPort=" + c.ListenPort + "\r\n" +
                    "AllowedClients=" + c.AllowedClients + "\r\n" +
                    "AdbHost=" + c.AdbHost + "\r\n" +
                    "AdbPort=" + c.AdbPort + "\r\n" +
                    "AdbPath=" + c.AdbPath + "\r\n");
                return c;
            }

            foreach (var raw in File.ReadAllLines(path))
            {
                var line = raw.Trim();
                if (line.Length == 0 || line.StartsWith("#")) continue;
                var p = line.IndexOf('=');
                if (p <= 0) continue;
                var key = line.Substring(0, p).Trim();
                var value = line.Substring(p + 1).Trim();
                int n;
                switch (key.ToLowerInvariant())
                {
                    case "listenaddresses": c.ListenAddresses = value; break;
                    case "listenport": if (int.TryParse(value, out n)) c.ListenPort = n; break;
                    case "allowedclients": c.AllowedClients = value; break;
                    case "adbhost": c.AdbHost = value; break;
                    case "adbport": if (int.TryParse(value, out n)) c.AdbPort = n; break;
                    case "adbpath": c.AdbPath = value; break;
                }
            }
            return c;
        }

        public IEnumerable<IPAddress> BindAddresses()
        {
            return ListenAddresses.Split(',').Select(x => x.Trim()).Where(x => x.Length > 0).Select(IPAddress.Parse);
        }

        public HashSet<string> ClientAllowlist()
        {
            return new HashSet<string>(AllowedClients.Split(',').Select(x => x.Trim()).Where(x => x.Length > 0), StringComparer.OrdinalIgnoreCase);
        }
    }

    internal sealed class Forwarder : IDisposable
    {
        private readonly Config config;
        private readonly Action<string> log;
        private readonly List<TcpListener> listeners = new List<TcpListener>();
        private readonly List<Thread> threads = new List<Thread>();
        private readonly HashSet<string> allowed;
        private volatile bool stopping;

        public Forwarder(Config config, Action<string> log)
        {
            this.config = config;
            this.log = log;
            allowed = config.ClientAllowlist();
        }

        public int Start()
        {
            StartAdbServer();
            int started = 0;
            foreach (var address in config.BindAddresses())
            {
                try
                {
                    var listener = new TcpListener(address, config.ListenPort);
                    listener.Start();
                    listeners.Add(listener);
                    var thread = new Thread(() => AcceptLoop(listener)) { IsBackground = true, Name = "ADB accept " + address };
                    threads.Add(thread);
                    thread.Start();
                    started++;
                    log("Listening on " + address + ":" + config.ListenPort);
                }
                catch (Exception ex)
                {
                    log("Cannot bind " + address + ":" + config.ListenPort + " — " + ex.Message);
                }
            }
            if (started == 0) throw new InvalidOperationException("No configured listen address is available on this computer.");
            return started;
        }

        private void StartAdbServer()
        {
            try
            {
                var psi = new ProcessStartInfo(config.AdbPath, "start-server")
                {
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true
                };
                using (var p = Process.Start(psi))
                {
                    if (!p.WaitForExit(10000)) p.Kill();
                    var output = (p.StandardOutput.ReadToEnd() + " " + p.StandardError.ReadToEnd()).Trim();
                    log("Local ADB server ready" + (output.Length > 0 ? ": " + output : "."));
                }
            }
            catch (Exception ex)
            {
                log("Could not run adb start-server: " + ex.Message + ". Continuing in case ADB is already running.");
            }
        }

        private void AcceptLoop(TcpListener listener)
        {
            while (!stopping)
            {
                try
                {
                    var client = listener.AcceptTcpClient();
                    ThreadPool.QueueUserWorkItem(_ => HandleClient(client));
                }
                catch (SocketException) { if (!stopping) log("Listener socket stopped unexpectedly."); }
                catch (ObjectDisposedException) { }
            }
        }

        private void HandleClient(TcpClient incoming)
        {
            var remote = incoming.Client.RemoteEndPoint as IPEndPoint;
            var ip = remote == null ? "unknown" : remote.Address.ToString();
            if (!allowed.Contains(ip))
            {
                log("Rejected client " + ip + " (not in AllowedClients).");
                incoming.Close();
                return;
            }

            TcpClient adb = null;
            try
            {
                adb = new TcpClient();
                adb.Connect(config.AdbHost, config.AdbPort);
                log("Connected " + ip + " to local ADB server.");
                var a = incoming.GetStream();
                var b = adb.GetStream();
                var done = new ManualResetEvent(false);
                ThreadPool.QueueUserWorkItem(_ => Pump(a, b, done));
                ThreadPool.QueueUserWorkItem(_ => Pump(b, a, done));
                done.WaitOne();
            }
            catch (Exception ex)
            {
                log("Connection " + ip + " failed: " + ex.Message);
            }
            finally
            {
                try { incoming.Close(); } catch { }
                try { if (adb != null) adb.Close(); } catch { }
                log("Disconnected " + ip + ".");
            }
        }

        private static void Pump(Stream input, Stream output, ManualResetEvent done)
        {
            try { input.CopyTo(output); output.Flush(); } catch { }
            finally { done.Set(); }
        }

        public void Dispose()
        {
            stopping = true;
            foreach (var listener in listeners) try { listener.Stop(); } catch { }
            listeners.Clear();
        }
    }

    internal sealed class MainForm : Form
    {
        private readonly TextBox logBox = new TextBox();
        private readonly Label status = new Label();
        private readonly NotifyIcon tray = new NotifyIcon();
        private Forwarder forwarder;
        private bool exiting;

        public MainForm()
        {
            Text = "ADB LAN Forwarder";
            Width = 720;
            Height = 430;
            StartPosition = FormStartPosition.CenterScreen;
            Icon = SystemIcons.Application;

            status.Dock = DockStyle.Top;
            status.Height = 44;
            status.Font = new Font(Font.FontFamily, 11, FontStyle.Bold);
            status.TextAlign = ContentAlignment.MiddleLeft;
            status.Padding = new Padding(10, 0, 0, 0);

            logBox.Dock = DockStyle.Fill;
            logBox.Multiline = true;
            logBox.ReadOnly = true;
            logBox.ScrollBars = ScrollBars.Vertical;
            logBox.Font = new Font("Consolas", 9);

            var panel = new FlowLayoutPanel { Dock = DockStyle.Bottom, Height = 48, FlowDirection = FlowDirection.LeftToRight, Padding = new Padding(8) };
            var openConfig = new Button { Text = "Open configuration", AutoSize = true };
            openConfig.Click += (s, e) => Process.Start("notepad.exe", ConfigPath());
            var restart = new Button { Text = "Restart forwarding", AutoSize = true };
            restart.Click += (s, e) => Restart();
            var exit = new Button { Text = "Stop and exit", AutoSize = true };
            exit.Click += (s, e) => { exiting = true; Close(); };
            panel.Controls.Add(openConfig);
            panel.Controls.Add(restart);
            panel.Controls.Add(exit);

            Controls.Add(logBox);
            Controls.Add(status);
            Controls.Add(panel);

            tray.Icon = SystemIcons.Application;
            tray.Text = "ADB LAN Forwarder";
            tray.Visible = true;
            tray.DoubleClick += (s, e) => { Show(); WindowState = FormWindowState.Normal; Activate(); };
            var menu = new ContextMenuStrip();
            menu.Items.Add("Open", null, (s, e) => { Show(); WindowState = FormWindowState.Normal; Activate(); });
            menu.Items.Add("Stop and exit", null, (s, e) => { exiting = true; Close(); });
            tray.ContextMenuStrip = menu;

            Shown += (s, e) => Restart();
            FormClosing += OnClosing;
        }

        private static string ConfigPath() { return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "AdbLanForwarder.ini"); }

        private void Restart()
        {
            if (forwarder != null) { forwarder.Dispose(); forwarder = null; }
            try
            {
                var config = Config.Load(ConfigPath());
                forwarder = new Forwarder(config, Log);
                var count = forwarder.Start();
                status.Text = "Running — " + count + " listener(s). Close this window to minimize to tray.";
                status.BackColor = Color.Honeydew;
                tray.Text = "ADB LAN Forwarder — running";
            }
            catch (Exception ex)
            {
                Log("START FAILED: " + ex.Message);
                status.Text = "Not running — check configuration and network addresses.";
                status.BackColor = Color.MistyRose;
                tray.Text = "ADB LAN Forwarder — stopped";
            }
        }

        private void Log(string message)
        {
            if (InvokeRequired) { BeginInvoke(new Action<string>(Log), message); return; }
            logBox.AppendText(DateTime.Now.ToString("HH:mm:ss") + "  " + message + Environment.NewLine);
        }

        private void OnClosing(object sender, FormClosingEventArgs e)
        {
            if (!exiting && e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
                tray.ShowBalloonTip(1500, "ADB LAN Forwarder", "Forwarding continues while the tray icon is running.", ToolTipIcon.Info);
                return;
            }
            if (forwarder != null) forwarder.Dispose();
            tray.Visible = false;
        }
    }

    internal static class Program
    {
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}
