package com.google.android.inputmethod.pinyin.rimesync;

import java.io.IOException;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/** Immutable full-session plan shared by preview, execution, and crash recovery. */
public final class RimeSyncSessionPlan {
    private static final Charset UTF_8 = Charset.forName("UTF-8");

    public final List<EntryPlan> entries;
    public final int googleAdditionCount;
    public final int googleDeletionCount;
    public final int rimeAdditionCount;
    public final int rimeDeletionCount;
    public final int rimeResurrectionCount;
    public final int projectedGoogleEntryCount;
    public final String confirmationToken;

    private RimeSyncSessionPlan(List<EntryPlan> entries, int googleAdditionCount,
            int googleDeletionCount, int rimeAdditionCount, int rimeDeletionCount,
            int rimeResurrectionCount, int projectedGoogleEntryCount,
            String confirmationToken) {
        // buildInternal owns this list; wrapping it avoids a second full-size backing array.
        this.entries = Collections.unmodifiableList(entries);
        this.googleAdditionCount = googleAdditionCount;
        this.googleDeletionCount = googleDeletionCount;
        this.rimeAdditionCount = rimeAdditionCount;
        this.rimeDeletionCount = rimeDeletionCount;
        this.rimeResurrectionCount = rimeResurrectionCount;
        this.projectedGoogleEntryCount = projectedGoogleEntryCount;
        this.confirmationToken = confirmationToken;
    }

    public static RimeSyncSessionPlan build(
            Map<String, RimeSyncCore.CanonicalEntry> rimeEntries,
            GoogleNativeDictionaryBridge.Snapshot googleSnapshot,
            BaselineLookup baselines) throws IOException {
        return buildInternal(rimeEntries, googleSnapshot, baselines, true);
    }

    /** Builds the same counts and token without retaining one EntryPlan per unchanged key. */
    public static RimeSyncSessionPlan buildPreview(
            Map<String, RimeSyncCore.CanonicalEntry> rimeEntries,
            GoogleNativeDictionaryBridge.Snapshot googleSnapshot,
            BaselineLookup baselines) throws IOException {
        return buildInternal(rimeEntries, googleSnapshot, baselines, false);
    }

    private static RimeSyncSessionPlan buildInternal(
            Map<String, RimeSyncCore.CanonicalEntry> rimeEntries,
            GoogleNativeDictionaryBridge.Snapshot googleSnapshot,
            BaselineLookup baselines, boolean retainEntries) throws IOException {
        if (rimeEntries == null || googleSnapshot == null || baselines == null) {
            throw new IllegalArgumentException("synchronization plan inputs are required");
        }
        // Two sorted reference arrays are cheaper than one TreeSet node per dictionary key.
        List<String> rimeKeys = new ArrayList<String>(rimeEntries.keySet());
        List<String> googleKeys = new ArrayList<String>(googleSnapshot.entries.keySet());
        Collections.sort(rimeKeys);
        Collections.sort(googleKeys);
        List<EntryPlan> plans = retainEntries
                ? new ArrayList<EntryPlan>(rimeKeys.size() + googleKeys.size())
                : Collections.<EntryPlan>emptyList();
        int googleAdds = 0;
        int googleDeletes = 0;
        int rimeAdds = 0;
        int rimeDeletes = 0;
        int rimeResurrections = 0;
        int rimeIndex = 0;
        int googleIndex = 0;
        MessageDigest digest = sha256();
        while (rimeIndex < rimeKeys.size() || googleIndex < googleKeys.size()) {
            String rimeKey = rimeIndex < rimeKeys.size() ? rimeKeys.get(rimeIndex) : null;
            String googleKey = googleIndex < googleKeys.size()
                    ? googleKeys.get(googleIndex) : null;
            String key;
            if (googleKey == null || (rimeKey != null && rimeKey.compareTo(googleKey) < 0)) {
                key = rimeKey;
                rimeIndex++;
            } else if (rimeKey == null || googleKey.compareTo(rimeKey) < 0) {
                key = googleKey;
                googleIndex++;
            } else {
                key = rimeKey;
                rimeIndex++;
                googleIndex++;
            }
            RimeSyncCore.CanonicalEntry rime = rimeEntries.get(key);
            GoogleNativeDictionaryBridge.GoogleEntry google = googleSnapshot.entries.get(key);
            Baseline baseline = baselines.get(key);
            if (baseline == null || baseline.history == null
                    || baseline.googleProjection == null || baseline.rimeAbsCount < 0) {
                throw new IllegalArgumentException("synchronization baseline is invalid");
            }
            int currentRimeCount = rime == null ? 0 : rime.commits;
            int planningMagnitude = Math.max(checkedMagnitude(currentRimeCount),
                    baseline.rimeAbsCount);
            RimeSyncPlanner.RimeState rimeState = rime == null
                    ? RimeSyncPlanner.RimeState.ABSENT
                    : currentRimeCount < 0
                            ? RimeSyncPlanner.RimeState.TOMBSTONE
                            : RimeSyncPlanner.RimeState.PRESENT;
            RimeSyncPlanner.Plan decision = RimeSyncPlanner.plan(
                    baseline.history, baseline.googleProjection,
                    google != null, rimeState, planningMagnitude);
            int nextMagnitude = decision.rimeAction == RimeSyncPlanner.RimeAction.DELETE
                            || decision.rimeAction == RimeSyncPlanner.RimeAction.RESURRECT
                    ? checkedMagnitude(decision.rimeCommitValue)
                    : decision.rimeAction == RimeSyncPlanner.RimeAction.ADD
                            ? 0 : planningMagnitude;
            if (retainEntries) {
                String code = rime != null ? rime.code : google.code;
                String phrase = rime != null ? rime.phrase : google.phrase;
                plans.add(new EntryPlan(key, code, phrase, decision.googleAction,
                        decision.rimeAction, decision.rimeCommitValue,
                        decision.nextHistory, decision.nextGoogleProjection, nextMagnitude));
            }
            if (decision.googleAction == RimeSyncPlanner.GoogleAction.ADD) googleAdds++;
            if (decision.googleAction == RimeSyncPlanner.GoogleAction.DELETE) googleDeletes++;
            if (decision.rimeAction == RimeSyncPlanner.RimeAction.ADD) rimeAdds++;
            if (decision.rimeAction == RimeSyncPlanner.RimeAction.DELETE) rimeDeletes++;
            if (decision.rimeAction == RimeSyncPlanner.RimeAction.RESURRECT) {
                rimeResurrections++;
            }
            updateDigest(digest, key, decision, nextMagnitude);
        }
        int projectedCount = googleSnapshot.totalEntryCount - googleDeletes + googleAdds;
        if (projectedCount > GoogleNativeDictionaryBridge.USER_DICTIONARY_CAPACITY) {
            throw new GoogleNativeDictionaryBridge.CapacityException(
                    googleSnapshot.totalEntryCount, googleAdds, googleDeletes);
        }
        return new RimeSyncSessionPlan(plans, googleAdds, googleDeletes, rimeAdds,
                rimeDeletes, rimeResurrections, projectedCount, hex(digest.digest()));
    }

    public boolean requiresDeletionConfirmation() {
        return googleDeletionCount > 0 || rimeDeletionCount > 0;
    }

    public List<GoogleNativeDictionaryBridge.Change> googleChanges() {
        List<GoogleNativeDictionaryBridge.Change> result =
                new ArrayList<GoogleNativeDictionaryBridge.Change>();
        for (EntryPlan entry : entries) {
            if (entry.googleAction != RimeSyncPlanner.GoogleAction.NONE) {
                result.add(new GoogleNativeDictionaryBridge.Change(
                        entry.code, entry.phrase, entry.googleAction));
            }
        }
        return result;
    }

    public List<RimeSyncCore.RimeChange> rimeChanges() {
        List<RimeSyncCore.RimeChange> result = new ArrayList<RimeSyncCore.RimeChange>();
        for (EntryPlan entry : entries) {
            if (entry.rimeAction != RimeSyncPlanner.RimeAction.NONE) {
                result.add(new RimeSyncCore.RimeChange(entry.code, entry.phrase,
                        entry.rimeAction, entry.rimeCommitValue));
            }
        }
        return result;
    }

    private static int checkedMagnitude(int value) {
        if (value == Integer.MIN_VALUE) {
            throw new IllegalArgumentException("Rime commit magnitude cannot be represented");
        }
        return Math.abs(value);
    }

    private static MessageDigest sha256() {
        try {
            return MessageDigest.getInstance("SHA-256");
        } catch (Exception failure) {
            throw new IllegalStateException("SHA-256 is unavailable", failure);
        }
    }

    private static void updateDigest(MessageDigest digest, String key,
            RimeSyncPlanner.Plan decision, int nextRimeAbsCount) {
        updateDigest(digest, key);
        updateDigest(digest, decision.googleAction.name());
        updateDigest(digest, decision.rimeAction.name());
        updateDigest(digest, Integer.toString(decision.rimeCommitValue));
        updateDigest(digest, decision.nextHistory.name());
        updateDigest(digest, decision.nextGoogleProjection.name());
        updateDigest(digest, Integer.toString(nextRimeAbsCount));
    }

    private static void updateDigest(MessageDigest digest, String value) {
        byte[] bytes = value.getBytes(UTF_8);
        digest.update((byte) (bytes.length >>> 24));
        digest.update((byte) (bytes.length >>> 16));
        digest.update((byte) (bytes.length >>> 8));
        digest.update((byte) bytes.length);
        digest.update(bytes);
    }

    private static String hex(byte[] value) {
        StringBuilder result = new StringBuilder(value.length * 2);
        for (byte item : value) result.append(String.format("%02x", item & 0xff));
        return result.toString();
    }

    public interface BaselineLookup {
        Baseline get(String canonicalKey);
    }

    public static final class Baseline {
        public final RimeSyncPlanner.History history;
        public final RimeSyncPlanner.GoogleProjection googleProjection;
        public final int rimeAbsCount;

        public Baseline(RimeSyncPlanner.History history,
                RimeSyncPlanner.GoogleProjection googleProjection, int rimeAbsCount) {
            if (history == null || googleProjection == null || rimeAbsCount < 0) {
                throw new IllegalArgumentException("synchronization baseline is invalid");
            }
            this.history = history;
            this.googleProjection = googleProjection;
            this.rimeAbsCount = rimeAbsCount;
        }
    }

    public static final class EntryPlan {
        public final String key;
        public final String code;
        public final String phrase;
        public final RimeSyncPlanner.GoogleAction googleAction;
        public final RimeSyncPlanner.RimeAction rimeAction;
        public final int rimeCommitValue;
        public final RimeSyncPlanner.History nextHistory;
        public final RimeSyncPlanner.GoogleProjection nextGoogleProjection;
        public final int nextRimeAbsCount;

        EntryPlan(String key, String code, String phrase,
                RimeSyncPlanner.GoogleAction googleAction,
                RimeSyncPlanner.RimeAction rimeAction, int rimeCommitValue,
                RimeSyncPlanner.History nextHistory,
                RimeSyncPlanner.GoogleProjection nextGoogleProjection,
                int nextRimeAbsCount) {
            this.key = key;
            this.code = code;
            this.phrase = phrase;
            this.googleAction = googleAction;
            this.rimeAction = rimeAction;
            this.rimeCommitValue = rimeCommitValue;
            this.nextHistory = nextHistory;
            this.nextGoogleProjection = nextGoogleProjection;
            this.nextRimeAbsCount = nextRimeAbsCount;
        }
    }
}
