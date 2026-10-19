package com.google.android.inputmethod.pinyin.pairdeletefixture;

import android.accessibilityservice.AccessibilityServiceInfo;
import android.app.Activity;
import android.app.Instrumentation;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.SystemClock;
import android.text.InputType;
import android.view.InputDevice;
import android.view.MotionEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.accessibility.AccessibilityWindowInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

/** Uses only a new fixture editor and an isolated, empty-dictionary audit IME. */
public final class PairedPunctuationDeviceTest extends Instrumentation {
    public static final class Editor extends Activity {
        EditText input;
        @Override public void onCreate(Bundle state) {
            super.onCreate(state);
            input = new EditText(this);
            input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE);
            setContentView(input);
            input.requestFocus();
            input.post(() -> ((InputMethodManager) getSystemService(INPUT_METHOD_SERVICE))
                    .showSoftInput(input, InputMethodManager.SHOW_IMPLICIT));
        }
    }

    private String capturePath;

    @Override public void onCreate(Bundle arguments) {
        super.onCreate(arguments);
        capturePath = arguments.getString("capture_path");
        start();
    }

    private void captureFailure(Bundle result) {
        if (capturePath == null) return;
        try (android.os.ParcelFileDescriptor descriptor = getUiAutomation().executeShellCommand(
                "screencap -p " + capturePath);
             java.io.InputStream stream = new android.os.ParcelFileDescriptor.AutoCloseInputStream(descriptor)) {
            byte[] buffer = new byte[4096];
            while (stream.read(buffer) != -1) { }
            result.putString("capture", "OK");
        } catch (Exception failure) {
            result.putString("capture", failure.getClass().getSimpleName());
        }
    }

    private AccessibilityNodeInfo key(AccessibilityNodeInfo node, String label) {
        if (node == null) return null;
        CharSequence description = node.getContentDescription();
        CharSequence text = node.getText();
        boolean matches = label.equalsIgnoreCase(String.valueOf(description))
                || label.equalsIgnoreCase(String.valueOf(text));
        if (label.equals("DEL")) {
            String value = String.valueOf(description);
            matches = value.equals("删除") || value.equals("退格") || value.equals("删除键")
                    || value.equalsIgnoreCase("delete") || value.equalsIgnoreCase("backspace")
                    || value.equals("⌫");
        }
        if (matches && node.isVisibleToUser()) return node;
        for (int i = 0; i < node.getChildCount(); i++) {
            AccessibilityNodeInfo found = key(node.getChild(i), label);
            if (found != null) return found;
        }
        return null;
    }

    private AccessibilityNodeInfo imeRoot() {
        for (AccessibilityWindowInfo window : getUiAutomation().getWindows()) {
            if (window.getType() != AccessibilityWindowInfo.TYPE_INPUT_METHOD) continue;
            AccessibilityNodeInfo root = window.getRoot();
            if (root != null && "com.google.android.inputmethod.pinyin.pairdeleteaudit"
                    .equals(String.valueOf(root.getPackageName()))) return root;
        }
        return null;
    }

    private void selectQwertyLayout() {
        // Test-only coordinate from the authorized screenshot observation:
        // the fresh-install chooser's QWERTY preview is centered at (257,750)
        // on a normalized 1000x1000 screen. Not product geometry; this fixture
        // requires the observed portrait chooser and must change if it moves.
        android.util.DisplayMetrics metrics = new android.util.DisplayMetrics();
        ((android.view.WindowManager) getTargetContext().getSystemService(android.content.Context.WINDOW_SERVICE))
                .getDefaultDisplay().getRealMetrics(metrics);
        tap(metrics.widthPixels * 0.257f, metrics.heightPixels * 0.750f);
    }

    private void tap(float x, float y) {
        long now = SystemClock.uptimeMillis();
        MotionEvent down = MotionEvent.obtain(now, now, MotionEvent.ACTION_DOWN, x, y, 0);
        down.setSource(InputDevice.SOURCE_TOUCHSCREEN);
        getUiAutomation().injectInputEvent(down, true);
        MotionEvent up = MotionEvent.obtain(now, now + 40, MotionEvent.ACTION_UP, x, y, 0);
        up.setSource(InputDevice.SOURCE_TOUCHSCREEN);
        getUiAutomation().injectInputEvent(up, true);
        down.recycle();
        up.recycle();
        SystemClock.sleep(250);
    }

    private void press(String label) {
        long deadline = SystemClock.uptimeMillis() + 6000;
        while (SystemClock.uptimeMillis() < deadline) {
            AccessibilityNodeInfo found = key(imeRoot(), label);
            if (found != null) {
                Rect bounds = new Rect();
                found.getBoundsInScreen(bounds);
                tap(bounds.centerX(), bounds.centerY());
                return;
            }
            SystemClock.sleep(150);
        }
        throw new AssertionError("Soft key unavailable: " + label);
    }

    private String text(Editor editor) {
        final String[] value = new String[1];
        runOnMainSync(() -> value[0] = editor.input.getText().toString());
        return value[0];
    }

    private void pairRetained(Editor editor, String stage) {
        String value = text(editor);
        if (!value.equals("（）")) {
            throw new AssertionError(stage + ": editor changed before pending pinyin cleared");
        }
    }

    @Override public void onStart() {
        Bundle result = new Bundle();
        Editor editor = null;
        try {
            AccessibilityServiceInfo info = getUiAutomation().getServiceInfo();
            info.flags |= AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS
                    | AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS;
            getUiAutomation().setServiceInfo(info);
            Intent intent = new Intent(getTargetContext(), Editor.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            editor = (Editor) startActivitySync(intent);
            final Editor active = editor;
            SystemClock.sleep(1500);
            selectQwertyLayout();
            // Paired deletion is deliberately stateless: manually supplied and
            // auto-completed pairs share this exact editor/caret state.
            runOnMainSync(() -> { active.input.setText("（）"); active.input.setSelection(1); });
            for (String letter : new String[]{"n", "i", "h", "a", "o"}) press(letter);
            // Native pinyin is shown in the IME rather than an editor composing
            // span. Its visible row was independently confirmed by the delegated
            // screenshot observer; the accessibility tree does not expose it.
            // Assert the user's editor and backspace order, not a hidden view.
            pairRetained(active, "Pinyin remains uncommitted");
            press("DEL"); pairRetained(active, "Correcting first letter");
            press("DEL"); pairRetained(active, "Correcting second letter");
            press("a"); press("o"); pairRetained(active, "Retyping letters");
            for (int i = 0; i < 5; i++) {
                press("DEL"); pairRetained(active, "Clearing composition");
            }
            press("DEL");
            if (!text(active).isEmpty()) throw new AssertionError("Empty pair deletion did not resume");
            result.putString("paired_delete", "PASS");
            finish(Activity.RESULT_OK, result);
        } catch (Throwable failure) {
            // Output only fixed test stages, never editor/candidate contents.
            result.putString("paired_delete", "FAIL");
            result.putString("reason", failure.getClass().getSimpleName() + ": " + failure.getMessage());
            captureFailure(result);
            finish(Activity.RESULT_CANCELED, result);
        } finally {
            if (editor != null) {
                final Editor active = editor;
                runOnMainSync(active::finish);
            }
        }
    }
}
