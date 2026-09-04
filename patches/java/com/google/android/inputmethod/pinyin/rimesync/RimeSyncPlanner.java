package com.google.android.inputmethod.pinyin.rimesync;

/** Pure per-entry state machine for manual Google Pinyin and Rime synchronization. */
public final class RimeSyncPlanner {
    public enum History {
        UNKNOWN,
        PRESENT,
        DELETED
    }

    public enum RimeState {
        ABSENT,
        PRESENT,
        TOMBSTONE
    }

    public enum GoogleProjection {
        SUPPORTED,
        RIME_ONLY
    }

    public enum GoogleAction {
        NONE,
        ADD,
        DELETE
    }

    public enum RimeAction {
        NONE,
        ADD,
        DELETE,
        RESURRECT
    }

    public static final class Plan {
        public final GoogleAction googleAction;
        public final RimeAction rimeAction;
        public final History nextHistory;
        public final GoogleProjection nextGoogleProjection;
        public final int rimeCommitValue;

        Plan(GoogleAction googleAction, RimeAction rimeAction,
                History nextHistory, GoogleProjection nextGoogleProjection,
                int rimeCommitValue) {
            this.googleAction = googleAction;
            this.rimeAction = rimeAction;
            this.nextHistory = nextHistory;
            this.nextGoogleProjection = nextGoogleProjection;
            this.rimeCommitValue = rimeCommitValue;
        }
    }

    private RimeSyncPlanner() {}

    /**
     * Plan one canonical multi-character key. A committed baseline represents the
     * result after both stores and the Bridge snapshot were durably published.
     */
    public static Plan plan(History history, GoogleProjection googleProjection,
            boolean googlePresent, RimeState rimeState, int rimeCommitValue) {
        if (history == null || googleProjection == null || rimeState == null) {
            throw new IllegalArgumentException("synchronization state is required");
        }
        int magnitude = checkedMagnitude(rimeCommitValue);
        if (googleProjection == GoogleProjection.RIME_ONLY && !googlePresent) {
            return rimeState == RimeState.PRESENT
                    ? new Plan(GoogleAction.NONE, RimeAction.NONE, History.PRESENT,
                            GoogleProjection.RIME_ONLY, 0)
                    : new Plan(GoogleAction.NONE, RimeAction.NONE, History.DELETED,
                            GoogleProjection.SUPPORTED, 0);
        }
        if (history == History.UNKNOWN) {
            return initial(googlePresent, rimeState, magnitude);
        }
        if (history == History.PRESENT) {
            return fromPresent(googlePresent, rimeState, magnitude);
        }
        return fromDeleted(googlePresent, rimeState, magnitude);
    }

    private static Plan initial(boolean googlePresent, RimeState rimeState, int magnitude) {
        if (rimeState == RimeState.TOMBSTONE) {
            return new Plan(
                    googlePresent ? GoogleAction.DELETE : GoogleAction.NONE,
                    RimeAction.NONE,
                    History.DELETED,
                    GoogleProjection.SUPPORTED,
                    0);
        }
        if (googlePresent && rimeState == RimeState.ABSENT) {
            return new Plan(GoogleAction.NONE, RimeAction.ADD, History.PRESENT,
                    GoogleProjection.SUPPORTED, 0);
        }
        if (!googlePresent && rimeState == RimeState.PRESENT) {
            return new Plan(GoogleAction.ADD, RimeAction.NONE, History.PRESENT,
                    GoogleProjection.SUPPORTED, 0);
        }
        return new Plan(GoogleAction.NONE, RimeAction.NONE,
                googlePresent ? History.PRESENT : History.DELETED,
                GoogleProjection.SUPPORTED, 0);
    }

    private static Plan fromPresent(boolean googlePresent,
            RimeState rimeState, int magnitude) {
        boolean rimePresent = rimeState == RimeState.PRESENT;
        if (googlePresent && rimePresent) {
            return new Plan(GoogleAction.NONE, RimeAction.NONE, History.PRESENT,
                    GoogleProjection.SUPPORTED, 0);
        }
        GoogleAction googleAction = googlePresent ? GoogleAction.DELETE : GoogleAction.NONE;
        RimeAction rimeAction = !googlePresent && rimePresent
                ? RimeAction.DELETE : RimeAction.NONE;
        int commitValue = rimeAction == RimeAction.DELETE
                ? -nextMagnitude(magnitude) : 0;
        return new Plan(googleAction, rimeAction, History.DELETED,
                GoogleProjection.SUPPORTED, commitValue);
    }

    private static Plan fromDeleted(boolean googlePresent,
            RimeState rimeState, int magnitude) {
        boolean rimePresent = rimeState == RimeState.PRESENT;
        if (!googlePresent && !rimePresent) {
            return new Plan(GoogleAction.NONE, RimeAction.NONE, History.DELETED,
                    GoogleProjection.SUPPORTED, 0);
        }
        GoogleAction googleAction = !googlePresent && rimePresent
                ? GoogleAction.ADD : GoogleAction.NONE;
        RimeAction rimeAction = RimeAction.NONE;
        int commitValue = 0;
        if (googlePresent && rimeState == RimeState.ABSENT) {
            rimeAction = RimeAction.ADD;
        } else if (googlePresent && rimeState == RimeState.TOMBSTONE) {
            rimeAction = RimeAction.RESURRECT;
            commitValue = nextMagnitude(magnitude);
        }
        return new Plan(googleAction, rimeAction, History.PRESENT,
                GoogleProjection.SUPPORTED, commitValue);
    }

    private static int checkedMagnitude(int value) {
        if (value == Integer.MIN_VALUE) {
            throw new IllegalArgumentException("Rime commit magnitude cannot be represented");
        }
        return Math.abs(value);
    }

    private static int nextMagnitude(int magnitude) {
        if (magnitude == Integer.MAX_VALUE) {
            throw new IllegalArgumentException("Rime commit magnitude is exhausted");
        }
        return magnitude + 1;
    }
}
