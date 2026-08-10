package com.google.android.inputmethod.pinyin;

import android.content.ClipDescription;
import android.os.Build;
import android.os.PersistableBundle;
import android.view.inputmethod.EditorInfo;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/** Old-ART-safe policy helpers for masked clipboard candidates. */
public final class SensitiveClipboardCompat {
    private static final String EXTRA_IS_SENSITIVE = "android.content.extra.IS_SENSITIVE";
    private static final int MAX_MASK_CODE_UNITS = 32;

    private SensitiveClipboardCompat() {}

    /**
     * Returns the source application's structured sensitivity signal.
     * ClipDescription extras were added in API 24.
     */
    public static boolean isSourceSensitive(ClipDescription description) {
        if (description == null || Build.VERSION.SDK_INT < 24) {
            return false;
        }
        PersistableBundle extras = description.getExtras();
        return extras != null && extras.getBoolean(EXTRA_IS_SENSITIVE, false);
    }

    /** Matches Gboard's forced-mask destination set, excluding visible-password text. */
    public static boolean isPasswordEditor(EditorInfo editorInfo) {
        if (editorInfo == null) {
            return false;
        }
        return isPasswordInputType(editorInfo.inputType);
    }

    /** Exposed separately so the exact platform inputType matrix is host-testable. */
    public static boolean isPasswordInputType(int inputType) {
        int inputClass = inputType & 0x0f;
        int variation = inputType & 0x0ff0;
        if (inputClass == 0x01) {
            return variation == 0x80 || variation == 0xe0;
        }
        return inputClass == 0x02 && variation == 0x10;
    }

    /** Gboard-equivalent UTF-16-length bullets with a bounded legacy-candidate cap. */
    public static String mask(String text) {
        int count = Math.min(text == null ? 0 : text.length(), MAX_MASK_CODE_UNITS);
        StringBuilder masked = new StringBuilder(count);
        for (int index = 0; index < count; index++) {
            masked.append('\u2022');
        }
        return masked.toString();
    }

    /** Produces a dismissal identity that never contains clipboard plaintext. */
    public static String makeOpaqueKey(String text, long timestamp) {
        String digest;
        try {
            MessageDigest sha256 = MessageDigest.getInstance("SHA-256");
            byte[] bytes = sha256.digest(text.getBytes("UTF-8"));
            StringBuilder encoded = new StringBuilder(bytes.length * 2);
            for (int index = 0; index < bytes.length; index++) {
                int value = bytes[index] & 0xff;
                if (value < 0x10) {
                    encoded.append('0');
                }
                encoded.append(Integer.toHexString(value));
            }
            digest = encoded.toString();
        } catch (NoSuchAlgorithmException ignored) {
            digest = Integer.toHexString(text.hashCode());
        } catch (UnsupportedEncodingException ignored) {
            digest = Integer.toHexString(text.hashCode());
        }
        return digest + '\u001f' + text.length() + '\u001f' + timestamp;
    }
}
