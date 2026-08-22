package com.milkice.iflytek.voiceime;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.Handler;
import android.os.Looper;
import android.util.Base64;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.TreeMap;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;

final class IflytekRecognizer {
    interface Listener {
        void onReady();
        void onPartial(String text);
        void onFinal(String text);
        void onError(String message);
    }

    private static final String HOST = "iat-api.xfyun.cn";
    private static final String TAG = "IflytekRecognizer";
    private static final String PATH = "/v2/iat";
    private static final int SAMPLE_RATE = 16000;
    private final android.content.Context context;
    private final VoiceSettings settings;
    private final Listener listener;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());
    private final AtomicBoolean stopping = new AtomicBoolean();
    private final TreeMap<Integer, String> pages = new TreeMap<>();
    private volatile WebSocket socket;
    private volatile AudioRecord recorder;
    private Thread audioThread;
    private boolean firstFrame = true;

    IflytekRecognizer(android.content.Context context, VoiceSettings settings, Listener listener) {
        this.context = context.getApplicationContext();
        this.settings = settings;
        this.listener = listener;
    }

    void start() {
        try {
            Request request = new Request.Builder().url(authUrl()).build();
            new OkHttpClient().newWebSocket(request, new WebSocketListener() {
                @Override
                public void onOpen(WebSocket webSocket, Response response) {
                    Log.i(TAG, "websocket opened");
                    socket = webSocket;
                    post(listener::onReady);
                    startRecorder();
                }

                @Override
                public void onMessage(WebSocket webSocket, String text) {
                    handleMessage(text);
                }

                @Override
                public void onFailure(WebSocket webSocket, Throwable t, Response response) {
                    Log.e(TAG, "websocket failed", t);
                    fail(t.getMessage());
                }

                @Override
                public void onClosing(WebSocket webSocket, int code, String reason) {
                    webSocket.close(1000, "done");
                }
            });
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    void stop() {
        if (!stopping.compareAndSet(false, true)) return;
        AudioRecord localRecorder = recorder;
        if (localRecorder != null) {
            try {
                localRecorder.stop();
            } catch (IllegalStateException ignored) {
            }
        }
        WebSocket localSocket = socket;
        if (localSocket != null) {
            sendFrame(2, new byte[0]);
            localSocket.close(1000, "done");
        }
        releaseRecorder();
    }

    private void startRecorder() {
        int minimum = AudioRecord.getMinBufferSize(
                SAMPLE_RATE, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
        if (minimum <= 0) {
            Log.e(TAG, "invalid microphone buffer size: " + minimum);
            fail("无法初始化麦克风");
            return;
        }
        try {
            recorder = new AudioRecord(
                    MediaRecorder.AudioSource.VOICE_RECOGNITION,
                    SAMPLE_RATE,
                    AudioFormat.CHANNEL_IN_MONO,
                    AudioFormat.ENCODING_PCM_16BIT,
                    Math.max(minimum, 4096));
            recorder.startRecording();
        } catch (RuntimeException e) {
            Log.e(TAG, "cannot start microphone", e);
            fail("无法开始录音");
            return;
        }
        final AudioRecord activeRecorder = recorder;
        audioThread = new Thread(() -> {
            byte[] buffer = new byte[3200];
            try {
                while (!stopping.get()) {
                    int count = activeRecorder.read(buffer, 0, buffer.length);
                    if (count > 0) {
                        byte[] audio = new byte[count];
                        System.arraycopy(buffer, 0, audio, 0, count);
                        sendFrame(firstFrame ? 0 : 1, audio);
                        firstFrame = false;
                    }
                }
            } catch (RuntimeException e) {
                if (!stopping.get()) fail("录音失败");
            }
        }, "iflytek-audio");
        audioThread.start();
    }

    private synchronized void sendFrame(int status, byte[] audio) {
        WebSocket localSocket = socket;
        if (localSocket == null) return;
        try {
            JSONObject root = new JSONObject();
            if (status == 0) {
                JSONObject common = new JSONObject();
                common.put("app_id", settings.appId);
                root.put("common", common);
                JSONObject business = new JSONObject();
                business.put("language", settings.language);
                business.put("domain", "iat");
                business.put("accent", "mandarin");
                business.put("vad_eos", 5000);
                root.put("business", business);
            }
            JSONObject data = new JSONObject();
            data.put("status", status);
            data.put("format", "audio/L16;rate=16000");
            data.put("encoding", "raw");
            data.put("audio", Base64.encodeToString(audio, Base64.NO_WRAP));
            root.put("data", data);
            localSocket.send(root.toString());
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    private void handleMessage(String text) {
        try {
            JSONObject root = new JSONObject(text);
            if (root.optInt("code", -1) != 0) {
                String message = root.optString("message", "讯飞服务返回错误");
                Log.e(TAG, "server error code=" + root.optInt("code") + ": " + message);
                fail(message);
                return;
            }
            JSONObject result = root.optJSONObject("data");
            if (result == null) return;
            result = result.optJSONObject("result");
            if (result == null) return;
            String current = words(result.optJSONArray("ws"));
            int serial = result.optInt("sn", pages.size());
            if ("rpl".equals(result.optString("pgs"))) {
                JSONArray range = result.optJSONArray("rg");
                if (range != null && range.length() >= 2) {
                    for (int i = range.optInt(0); i <= range.optInt(1); i++) pages.remove(i);
                }
            }
            pages.put(serial, current);
            String combined = joinPages();
            boolean last = result.optBoolean("ls", false);
            post(() -> listener.onPartial(combined));
            if (last) {
                post(() -> listener.onFinal(combined));
                stop();
            }
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    private String words(JSONArray words) {
        StringBuilder builder = new StringBuilder();
        if (words == null) return "";
        for (int i = 0; i < words.length(); i++) {
            JSONObject item = words.optJSONObject(i);
            JSONArray candidates = item == null ? null : item.optJSONArray("cw");
            if (candidates != null && candidates.length() > 0) {
                builder.append(candidates.optJSONObject(0).optString("w"));
            }
        }
        return builder.toString();
    }

    private String joinPages() {
        StringBuilder builder = new StringBuilder();
        for (Map.Entry<Integer, String> entry : pages.entrySet()) builder.append(entry.getValue());
        return builder.toString();
    }

    private String authUrl() throws Exception {
        String date = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss z", Locale.US) {
            {
                setTimeZone(TimeZone.getTimeZone("GMT"));
            }
        }.format(new Date());
        String signatureOrigin = "host: " + HOST + "\n"
                + "date: " + date + "\n"
                + "GET " + PATH + " HTTP/1.1";
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(settings.apiSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        String signature = Base64.encodeToString(
                mac.doFinal(signatureOrigin.getBytes(StandardCharsets.UTF_8)), Base64.NO_WRAP);
        String authorization = "api_key=\"" + settings.apiKey
                + "\", algorithm=\"hmac-sha256\", headers=\"host date request-line\", signature=\""
                + signature + "\"";
        return "wss://" + HOST + PATH
                + "?authorization=" + encode(Base64.encodeToString(
                authorization.getBytes(StandardCharsets.UTF_8), Base64.NO_WRAP))
                + "&date=" + encode(date)
                + "&host=" + encode(HOST);
    }

    private static String encode(String value) throws UnsupportedEncodingException {
        return URLEncoder.encode(value, "UTF-8");
    }

    private void releaseRecorder() {
        AudioRecord localRecorder = recorder;
        recorder = null;
        if (localRecorder != null) localRecorder.release();
    }

    private void fail(String message) {
        if (stopping.compareAndSet(false, true)) {
            releaseRecorder();
            post(() -> listener.onError(message == null ? "识别失败" : message));
        }
    }

    private void post(Runnable runnable) {
        mainHandler.post(runnable);
    }
}
