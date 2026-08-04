# ADB LAN Forwarder

A small Windows tray application that forwards a USB-connected phone from the local ADB server (`127.0.0.1:5037`) to explicitly configured ZeroTier/LAN addresses.

## Security model

ADB server access grants extensive control over every device visible to that ADB server. This application therefore:

- binds only the addresses listed in `ListenAddresses`;
- accepts only exact IP addresses listed in `AllowedClients`;
- does not modify Windows Firewall, `netsh portproxy`, startup tasks, registry, ADB authorization, or the phone;
- stops all exposure when **Stop and exit** is selected;
- does not provide encryption—use it only over a trusted LAN or encrypted overlay such as ZeroTier.

Never configure `ListenAddresses=0.0.0.0` or `AllowedClients=*` on an untrusted network.

## Device-connected computer

1. Put `AdbLanForwarder.exe` and `AdbLanForwarder.ini` in the same folder.
2. Ensure `adb.exe` is either on `PATH` or set its full path in `AdbPath`.
3. Edit the listen addresses and client allowlist.
4. Double-click `AdbLanForwarder.exe`. It starts forwarding immediately and remains in the notification area when the window is closed.
5. Use **Stop and exit** when remote access is no longer needed.

The supplied defaults match the current ZeroTier setup:

```ini
ListenAddresses=192.168.17.77,192.168.27.77
ListenPort=15037
AllowedClients=192.168.17.78,192.168.27.78
AdbHost=127.0.0.1
AdbPort=5037
AdbPath=adb.exe
```

If one configured listen address is not currently assigned, the app logs that failure and continues on any other available configured address.

## Remote computer

Use one of the forwarded addresses as the ADB server socket:

```cmd
set ADB_SERVER_SOCKET=tcp:192.168.17.77:15037
adb devices -l
```

`OpenRemoteAdbShell.cmd` sets this variable only for its own command window, avoiding a persistent machine-wide environment change.

Android Studio or another program must be launched from a process that has the same `ADB_SERVER_SOCKET` environment variable if it should use the remote ADB server.

## Firewall

The application deliberately does not create a persistent firewall rule. If Windows Firewall blocks the listener, allow the executable only on the appropriate private/ZeroTier network profile, or use an existing narrowly scoped rule for TCP 15037. Do not expose the port on public interfaces.
