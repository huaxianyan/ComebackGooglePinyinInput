package com.google.android.inputmethod.pinyin.rimesync;

import java.io.IOException;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

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
        this.entries = Collections.unmodifiableList(new ArrayList<EntryPlan>(entries));
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
        if (rimeEntries == null || googleSnapshot == null || baselines == null) {
            throw new IllegalArgumentException("synchronization plan inputs are required");
        }
        Set<String> keys = new TreeSet<String>();
        keys.addAll(rimeEntries.keySet());
        keys.addAll(googleSnapshot.entries.keySet());
        List<EntryPlan> plans = new ArrayList<EntryPlan>(keys.size());
        int googleAdds = 0;
        int googleDeletes = 0;
        int rimeAdds = 0;
        int rimeDeletes = 0;
        int rimeResurrections = 0;
        MessageDigest digest = sha256();
        for (String key : keys) {
            RimeSyncCore.CanonicalEntry rime = rimeEntries.get(key);
            GoogleNativeDictionaryBridge.GoogleEntry google = googleSnapshot.entries.get(key);
            Baseline baseline = baselines.get(key);
            if (baseline == null || baseline.history == null
                    || baseline.googleProjection == null || baseline.rimeAbsCount < 0) {
                throw new IllegalArgumentException("synchronization baseline is invalid");
            }
            int currentRimeCount = rime == null ? 0 : rime.source.commits;
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
            String code = rime != null ? rime.code : google.code;
            String phrase = rime != null ? rime.phrase : google.phrase;
            int nextMagnitude = decision.rimeAction == RimeSyncPlanner.RimeAction.DELETE
                            || decision.rimeAction == RimeSyncPlanner.RimeAction.RESURRECT
                    ? checkedMagnitude(decision.rimeCommitValue)
                    : decision.rimeAction == RimeSyncPlanner.RimeAction.ADD
                            ? 0 : planningMagnitude;
            EntryPlan plan = new EntryPlan(key, code, phrase, decision.googleAction,
                    decision.rimeAction, decision.rimeCommitValue,
                    decision.nextHistory, decision.nextGoogleProjection, nextMagnitude);
            plans.add(plan);
            if (decision.googleAction == RimeSyncPlanner.GoogleAction.ADD) googleAdds++;
            if (decision.googleAction == RimeSyncPlanner.GoogleAction.DELETE) googleDeletes++;
            if (decision.rimeAction == RimeSyncPlanner.RimeAction.ADD) rimeAdds++;
            if (decision.rimeAction == RimeSyncPlanner.RimeAction.DELETE) rimeDeletes++;
            if (decision.rimeAction == RimeSyncPlanner.RimeAction.RESURRECT) {
                rimeResurrections++;
            }
            updateDigest(digest, plan);
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

    private static void updateDigest(MessageDigest digest, EntryPlan plan) {
        updateDigest(digest, plan.key);
        updateDigest(digest, plan.googleAction.name());
        updateDigest(digest, plan.rimeAction.name());
        updateDigest(digest, Integer.toString(plan.rimeCommitValue));
        updateDigest(digest, plan.nextHistory.name());
        updateDigest(digest, plan.nextGoogleProjection.name());
        updateDigest(digest, Integer.toString(plan.nextRimeAbsCount));
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
