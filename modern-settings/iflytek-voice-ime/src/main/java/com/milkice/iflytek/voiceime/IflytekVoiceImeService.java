package com.milkice.iflytek.voiceime;

import android.Manifest;
import android.content.Intent;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.content.pm.PackageManager;
import android.content.res.ColorStateList;
import android.inputmethodservice.InputMethodService;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.widget.TextView;
import android.widget.Toast;
import android.graphics.Color;

import com.google.android.material.button.MaterialButton;

public final class IflytekVoiceImeService extends InputMethodService {
    private final Handler mainHandler = new Handler(Looper.getMainLooper());
    private View inputView;
    private TextView statusView;
    private TextView transcriptView;
    private MaterialButton actionButton;
    private MaterialButton backButton;
    private IflytekRecognizer recognizer;
    private boolean recognizing;

    @Override
    public View onCreateInputView() {
        ContextThemeWrapper themedContext = new ContextThemeWrapper(
                this, R.style.Theme_IflytekVoiceIme);
        inputView = LayoutInflater.from(themedContext).inflate(R.layout.voice_input_view, null);
        statusView = inputView.findViewById(R.id.voice_status);
        transcriptView = inputView.findViewById(R.id.voice_transcript);
        actionButton = inputView.findViewById(R.id.voice_action);
        backButton = inputView.findViewById(R.id.voice_back);
        backButton.setOnClickListener(view -> returnToPreviousInputMethod());
        actionButton.setOnClickListener(view -> {
            if (recognizing) stopRecognition();
            else startRecognition();
        });
        resetRecognitionUi();
        return inputView;
    }

    @Override
    public void onStartInput(EditorInfo attribute, boolean restarting) {
        super.onStartInput(attribute, restarting);
        stopRecognition();
        if (transcriptView != null) transcriptView.setText("");
    }

    private void startRecognition() {
        if (Build.VERSION.SDK_INT >= 23
                && checkSelfPermission(Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            Intent intent = new Intent(this, SettingsActivity.class)
                    .putExtra("request_record_audio", true)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            setStatus(getString(R.string.settings_permission_title));
            return;
        }
        VoiceSettings settings = VoiceSettings.load(this);
        if (!settings.isComplete()) {
            startActivity(new Intent(this, SettingsActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            Toast.makeText(this, R.string.settings_missing_config, Toast.LENGTH_LONG).show();
            return;
        }
        recognizing = true;
        setStatus(getString(R.string.voice_recording));
        setRecordingButton(true);
        recognizer = new IflytekRecognizer(this, settings, new IflytekRecognizer.Listener() {
            @Override
            public void onReady() {
                post(() -> setStatus(getString(R.string.voice_recording)));
            }

            @Override
            public void onPartial(String text) {
                post(() -> {
                    if (!recognizing) return;
                    if (transcriptView != null) transcriptView.setText(text);
                    InputConnection connection = getCurrentInputConnection();
                    if (connection != null) connection.setComposingText(text, 1);
                    setStatus(getString(R.string.voice_recognizing));
                });
            }

            @Override
            public void onFinal(String text) {
                post(() -> {
                    if (!recognizing) return;
                    InputConnection connection = getCurrentInputConnection();
                    if (connection != null && text != null && !text.isEmpty()) {
                        // Replace the in-progress composing text and commit it once.
                        connection.setComposingText(text, 1);
                        connection.finishComposingText();
                    }
                    finishRecognition();
                });
            }

            @Override
            public void onError(String message) {
                post(() -> {
                    recognizer = null;
                    resetRecognitionUi();
                    setStatus(message == null ? getString(R.string.voice_error) : message);
                });
            }
        });
        recognizer.start();
    }

    private void stopRecognition() {
        if (recognizer != null) {
            recognizer.stop();
            recognizer = null;
        }
        if (recognizing) finishRecognition();
    }

    private void finishRecognition() {
        resetRecognitionUi();
    }

    private void returnToPreviousInputMethod() {
        stopRecognition();
        InputConnection connection = getCurrentInputConnection();
        if (connection != null) {
            // Cancel, rather than commit, any in-progress composing text.
            connection.setComposingText("", 1);
            connection.finishComposingText();
        }
        if (Build.VERSION.SDK_INT >= 28) switchToPreviousInputMethod();
    }

    private void resetRecognitionUi() {
        recognizing = false;
        setRecordingButton(false);
        if (statusView != null) statusView.setText(R.string.voice_start);
    }

    private void setRecordingButton(boolean recording) {
        if (actionButton == null) return;
        actionButton.setContentDescription(getString(
                recording ? R.string.voice_cancel : R.string.voice_start));
        actionButton.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor(
                recording ? "#C62828" : "#3F51B5")));
    }

    private void setStatus(String text) {
        if (statusView != null) statusView.setText(text);
    }

    private void post(Runnable runnable) {
        mainHandler.post(runnable);
    }

    @Override
    public void onFinishInput() {
        stopRecognition();
        super.onFinishInput();
    }

    @Override
    public void onDestroy() {
        stopRecognition();
        super.onDestroy();
    }
}
