package com.google.android.inputmethod.pinyin.headerplatform;

import android.view.inputmethod.EditorInfo;

/** Sanitized editor metadata shared with modules; no surrounding or entered text is exposed. */
public final class HeaderEditorContext {
    private final int inputType;
    private final int imeOptions;
    private final String packageName;
    private final boolean disableAutoPaste;

    private HeaderEditorContext(int inputType, int imeOptions, String packageName,
            boolean disableAutoPaste) {
        this.inputType = inputType;
        this.imeOptions = imeOptions;
        this.packageName = packageName == null ? "" : packageName;
        this.disableAutoPaste = disableAutoPaste;
    }

    public static HeaderEditorContext from(EditorInfo editor) {
        if (editor == null) return new HeaderEditorContext(0, 0, "", false);
        boolean disableAutoPaste = editor.privateImeOptions != null
                && editor.privateImeOptions.contains("disableAutoPaste");
        return new HeaderEditorContext(editor.inputType, editor.imeOptions,
                editor.packageName, disableAutoPaste);
    }

    public int getInputType() { return inputType; }
    public int getImeOptions() { return imeOptions; }
    public String getPackageName() { return packageName; }
    public boolean isAutoPasteDisabled() { return disableAutoPaste; }
}
