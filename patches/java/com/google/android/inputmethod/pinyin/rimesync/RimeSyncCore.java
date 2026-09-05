package com.google.android.inputmethod.pinyin.rimesync;

import java.io.IOException;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

/** Rime-side merge and translation view; full snapshots retain entries excluded from translation. */
public final class RimeSyncCore {
    public static final double NEW_ENTRY_DEE = 1.0e-8;

    private RimeSyncCore() {}

    /** Returns the stable identity from a snapshot previously published by this Bridge. */
    public static String recoverBridgeUserId(RimeUserDbSnapshot snapshot) throws IOException {
        if (snapshot == null
                || !"google-pinyin-bridge".equals(snapshot.metadata().get("rime_version"))) {
            throw new IOException("existing device snapshot is not a Google Pinyin Bridge");
        }
        String userId = snapshot.metadata().get("user_id");
        try {
            if (userId == null || !UUID.fromString(userId).toString().equals(userId)) {
                throw new IllegalArgumentException("non-canonical UUID");
            }
        } catch (IllegalArgumentException failure) {
            throw new IOException("existing Bridge snapshot identity is invalid", failure);
        }
        return userId;
    }

    public static RimeUserDbSnapshot merge(List<DeviceSnapshot> devices,
            RimeSyncConfiguration configuration, String bridgeUserId) throws IOException {
        if (devices == null || configuration == null || bridgeUserId == null
                || bridgeUserId.length() == 0) {
            throw new IllegalArgumentException("Rime merge identity is required");
        }
        RimeUserDbSnapshot result = null;
        List<DeviceSnapshot> peers = new ArrayList<DeviceSnapshot>();
        for (DeviceSnapshot device : devices) {
            if (device.bridgeOwned) {
                if (result != null) throw new IOException("multiple Bridge snapshots were found");
                if (!bridgeUserId.equals(device.snapshot.metadata().get("user_id"))) {
                    throw new IOException("Bridge snapshot user identity changed");
                }
                result = device.snapshot;
            } else {
                peers.add(device);
            }
        }
        Collections.sort(peers);
        if (result == null && !peers.isEmpty()) {
            result = peers.remove(0).snapshot;
            result.mergeFromEmpty(true);
            result.putMetadata("rime_version", "google-pinyin-bridge");
            result.putMetadata("user_id", bridgeUserId);
        } else if (result == null) {
            result = new RimeUserDbSnapshot();
            result.putMetadata("db_name", configuration.databaseName);
            result.putMetadata("db_type", "userdb");
            result.putMetadata("rime_version", "google-pinyin-bridge");
            result.putMetadata("tick", "0");
            result.putMetadata("user_id", bridgeUserId);
        }
        for (DeviceSnapshot peer : peers) result.mergeFrom(peer.snapshot, true);
        result.putMetadata("user_id", bridgeUserId);
        return result;
    }

    /** Returns every multi-code-point key, including tombstones needed for delete propagation. */
    public static Map<String, CanonicalEntry> translationEntries(RimeUserDbSnapshot snapshot)
            throws IOException {
        return translationEntries(snapshot, true);
    }

    /** Builds the same canonical presence and commit view without retaining duplicate details. */
    static Map<String, CanonicalEntry> translationEntriesForPreview(
            RimeUserDbSnapshot snapshot) throws IOException {
        return translationEntries(snapshot, false);
    }

    private static Map<String, CanonicalEntry> translationEntries(
            RimeUserDbSnapshot snapshot, boolean retainDetails) throws IOException {
        Map<String, CanonicalEntry> result = new LinkedHashMap<String, CanonicalEntry>();
        for (RimeUserDbSnapshot.Entry entry : snapshot.entries().values()) {
            String phrase = normalizePhrase(entry.phrase);
            if (phrase.codePointCount(0, phrase.length()) < 2) continue;
            String code = normalizeCode(entry.code);
            String key = code + '\t' + phrase;
            CanonicalEntry canonical = retainDetails
                    ? new CanonicalEntry(key, code, phrase, entry)
                    : new CanonicalEntry(null, null, null, entry);
            CanonicalEntry previous = result.put(key, canonical);
            if (previous != null) throw new IOException("duplicate normalized Rime entry");
        }
        return result;
    }

    public static void apply(RimeUserDbSnapshot snapshot, RimeChange change) throws IOException {
        if (snapshot == null || change == null) {
            throw new IllegalArgumentException("Rime change is required");
        }
        String code = normalizeCode(change.code);
        String phrase = normalizePhrase(change.phrase);
        CanonicalEntry canonical = translationEntries(snapshot).get(code + '\t' + phrase);
        RimeUserDbSnapshot.Entry current = canonical == null ? null : canonical.source;
        double dee = current == null ? NEW_ENTRY_DEE : current.dee;
        long tick = current == null ? 0L : current.tick;
        int commits;
        if (change.action == RimeSyncPlanner.RimeAction.ADD) {
            commits = 0;
            dee = NEW_ENTRY_DEE;
            tick = 0L;
        } else if (change.action == RimeSyncPlanner.RimeAction.DELETE
                || change.action == RimeSyncPlanner.RimeAction.RESURRECT) {
            commits = change.commitValue;
        } else {
            return;
        }
        if (current != null && !current.key().equals(code + " \t" + phrase)) {
            snapshot.remove(current.key());
        }
        snapshot.put(new RimeUserDbSnapshot.Entry(code, phrase, commits, dee, tick));
    }

    private static String normalizeCode(String value) throws IOException {
        String trimmed = value.trim().toLowerCase(Locale.US);
        if (trimmed.length() == 0) throw new IOException("Rime entry has an empty code");
        StringBuilder result = new StringBuilder(trimmed.length());
        boolean separator = false;
        for (int index = 0; index < trimmed.length(); index++) {
            char character = trimmed.charAt(index);
            if (Character.isWhitespace(character)) {
                separator = result.length() > 0;
            } else {
                if (character < 'a' || character > 'z') {
                    throw new IOException("Rime entry code is not supported");
                }
                if (separator) result.append(' ');
                result.append(character);
                separator = false;
            }
        }
        return result.toString();
    }

    private static String normalizePhrase(String value) throws IOException {
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFC);
        if (normalized.length() == 0 || !normalized.equals(normalized.trim())) {
            throw new IOException("Rime phrase is empty or has surrounding whitespace");
        }
        for (int index = 0; index < normalized.length();) {
            int codePoint = normalized.codePointAt(index);
            if (Character.isISOControl(codePoint)) {
                throw new IOException("Rime phrase contains a control character");
            }
            index += Character.charCount(codePoint);
        }
        return normalized;
    }

    public static final class DeviceSnapshot implements Comparable<DeviceSnapshot> {
        public final String stableId;
        public final boolean bridgeOwned;
        public final RimeUserDbSnapshot snapshot;

        public DeviceSnapshot(String stableId, boolean bridgeOwned,
                RimeUserDbSnapshot snapshot) {
            if (stableId == null || snapshot == null) {
                throw new IllegalArgumentException("Rime device snapshot is invalid");
            }
            this.stableId = stableId;
            this.bridgeOwned = bridgeOwned;
            this.snapshot = snapshot;
        }

        @Override public int compareTo(DeviceSnapshot other) {
            return stableId.compareTo(other.stableId);
        }
    }

    public static final class CanonicalEntry {
        public final String key;
        public final String code;
        public final String phrase;
        public final RimeUserDbSnapshot.Entry source;

        CanonicalEntry(String key, String code, String phrase,
                RimeUserDbSnapshot.Entry source) {
            this.key = key;
            this.code = code;
            this.phrase = phrase;
            this.source = source;
        }
    }

    public static final class RimeChange {
        public final String code;
        public final String phrase;
        public final RimeSyncPlanner.RimeAction action;
        public final int commitValue;

        public RimeChange(String code, String phrase, RimeSyncPlanner.RimeAction action,
                int commitValue) {
            if (code == null || phrase == null || action == null) {
                throw new IllegalArgumentException("Rime change is invalid");
            }
            this.code = code;
            this.phrase = phrase;
            this.action = action;
            this.commitValue = commitValue;
        }
    }
}
