package com.google.android.inputmethod.pinyin.rimesync;

import java.util.Locale;

/** Validated names used beneath a user-authorized Rime synchronization root. */
public final class RimeSyncConfiguration {
    private static final String SNAPSHOT_SUFFIX = ".userdb.txt";

    public final String deviceDirectoryName;
    public final String snapshotFileName;
    public final String databaseName;

    public RimeSyncConfiguration(String deviceDirectoryName, String snapshotFileName) {
        if (!isValidDeviceName(deviceDirectoryName)) {
            throw new IllegalArgumentException("device name contains an invalid character");
        }
        this.deviceDirectoryName = deviceDirectoryName;
        this.snapshotFileName = requireSafeName(snapshotFileName, "snapshot file");
        if (!this.snapshotFileName.endsWith(SNAPSHOT_SUFFIX)
                || this.snapshotFileName.length() == SNAPSHOT_SUFFIX.length()) {
            throw new IllegalArgumentException("Rime snapshot must end with .userdb.txt");
        }
        this.databaseName = this.snapshotFileName.substring(0,
                this.snapshotFileName.length() - ".txt".length());
    }

    public static boolean isValidDeviceName(String value) {
        if (value == null || value.length() == 0) return false;
        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);
            if (!((character >= 'a' && character <= 'z')
                    || (character >= '0' && character <= '9')
                    || character == '_' || character == '-')) {
                return false;
            }
        }
        return true;
    }

    public static String defaultDeviceName(String model) {
        if (model == null) return "";
        String value = model.toLowerCase(Locale.ROOT).replace(' ', '_');
        return isValidDeviceName(value) ? value : "";
    }

    private static String requireSafeName(String value, String label) {
        if (value == null || value.length() == 0 || ".".equals(value) || "..".equals(value)) {
            throw new IllegalArgumentException(label + " name is invalid");
        }
        if (!value.equals(value.trim())) {
            throw new IllegalArgumentException(label + " name has surrounding whitespace");
        }
        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);
            if (character == '/' || character == '\\' || character < 0x20 || character == 0x7f) {
                throw new IllegalArgumentException(label + " name contains an invalid character");
            }
        }
        return value;
    }
}
