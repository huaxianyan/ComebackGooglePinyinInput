// Recovered from the fixed Google Pinyin selection tracker and its actual callers.
// Google-derived rights remain as stated in NOTICE. This is not an InputConnection stub.
package comeback.recovered;

import java.util.ArrayDeque;
import java.util.Deque;

/** Pure state/queue logic; the Android adapter still owns the real connection. */
public final class SelectionTracker {
    public enum Reason { IME, DELETE, OTHER }

    public static final class State {
        public final int selectionEnd;
        // EditorInfo reset preserves the original signed end-minus-start value.
        public final int selectionExtent;
        public final int composingLength;
        public final int cursorInComposition;

        public State(int selectionEnd, int selectionExtent, int composingLength, int cursorInComposition) {
            this.selectionEnd = selectionEnd;
            this.selectionExtent = selectionExtent;
            this.composingLength = composingLength;
            this.cursorInComposition = cursorInComposition;
        }

        public int selectionStart() { return selectionEnd - selectionExtent; }
        public int composingStart() { return selectionStart() - cursorInComposition; }
        public int composingEnd() { return composingStart() + composingLength; }

        private boolean sameCoordinates(State other) {
            return selectionEnd == other.selectionEnd && selectionExtent == other.selectionExtent
                    && composingLength == other.composingLength
                    && cursorInComposition == other.cursorInComposition;
        }
    }

    public static final class Update {
        public final Reason reason;
        public final State state;
        public final int composingBeforeSelection;
        public final int composingAfterSelection;
        // Computed from callback coordinates, not from the application's text contents.
        public final boolean atStartWithoutPositiveComposingEndpoint;

        private Update(Reason reason, State state, int before, int after, boolean atStart) {
            this.reason = reason;
            this.state = state;
            this.composingBeforeSelection = before;
            this.composingAfterSelection = after;
            this.atStartWithoutPositiveComposingEndpoint = atStart;
        }
    }

    private static final class Expected {
        final Reason reason;
        final State state;
        Expected(Reason reason, State state) { this.reason = reason; this.state = state; }
    }

    private final Deque<Expected> expected = new ArrayDeque<>();
    private State actual = new State(0, 0, 0, 0);
    private int batchDepth;
    private boolean receivedSelectionCallback;
    private boolean committedSinceReset;

    public void reset(int initialSelectionStart, int initialSelectionEnd) {
        expected.clear();
        receivedSelectionCallback = false;
        committedSinceReset = false;
        batchDepth = 0;
        actual = new State(initialSelectionEnd, initialSelectionEnd - initialSelectionStart, 0, 0);
    }

    public State expectedState() {
        return expected.isEmpty() ? actual : expected.getLast().state;
    }

    // This is the original prediction entry, also used by deletion/output adapters.
    public void recordPrediction(Reason reason, State state) {
        if (batchDepth > 0) expected.removeLast();
        expected.addLast(new Expected(reason, state));
    }

    public void beginBatch() {
        if (batchDepth == 0) recordPrediction(Reason.IME, expectedState());
        batchDepth++;
    }

    public void endBatch() {
        batchDepth--;
        if (batchDepth < 0) {
            throw new IllegalStateException("A batch end requires a matching batch start");
        }
        if (batchDepth == 0) {
            Expected last = expected.removeLast();
            if (!last.state.sameCoordinates(expectedState())) expected.addLast(last);
        }
    }

    /** Predict the existing setComposingText path; text is the caller's non-null text. */
    public void predictComposing(CharSequence text, int newCursorPosition) {
        State before = expectedState();
        int endAfterReplace = before.selectionEnd - before.selectionExtent
                - before.cursorInComposition + text.length();
        int composingStart = endAfterReplace - text.length();
        int cursor = newCursorPosition > 0 ? endAfterReplace + newCursorPosition - 1
                : Math.max(0, composingStart + newCursorPosition);
        recordPrediction(Reason.IME, new State(cursor, 0, text.length(), cursor - composingStart));
    }

    /** Predict commitText, including collapsing an existing selection first. */
    public void predictCommit(CharSequence text, int newCursorPosition) {
        State before = expectedState();
        if (before.selectionExtent != 0) {
            recordPrediction(Reason.IME, new State(before.selectionStart(), 0,
                    before.composingLength, before.cursorInComposition));
        }
        before = expectedState();
        int endAfterReplace = before.selectionEnd + text.length() - before.cursorInComposition;
        int cursor = newCursorPosition > 0 ? endAfterReplace + newCursorPosition - 1
                : Math.max(0, endAfterReplace - text.length() + newCursorPosition);
        committedSinceReset = true;
        recordPrediction(Reason.IME, new State(cursor, 0, 0, 0));
    }

    /** Reconcile the six Android onUpdateSelection coordinates, after connection checks. */
    public Update onFrameworkSelection(int oldStart, int oldEnd, int newStart, int newEnd,
                                       int composingStart, int composingEnd) {
        int previousStart = Math.min(oldStart, oldEnd);
        int previousEnd = Math.max(oldStart, oldEnd);
        int selectionStart = Math.min(newStart, newEnd);
        int selectionEnd = Math.max(newStart, newEnd);
        int compositionStart = Math.min(composingStart, composingEnd);
        int compositionEnd = Math.max(composingStart, composingEnd);
        int extent = selectionEnd - selectionStart;
        boolean bothComposingEndpointsValid = compositionStart >= 0 && compositionEnd >= 0;
        int compositionLength = bothComposingEndpointsValid ? compositionEnd - compositionStart : 0;
        int cursorInComposition = bothComposingEndpointsValid ? selectionStart - compositionStart : 0;
        int before = compositionStart >= 0 ? selectionStart - compositionStart : -extent;
        int after = compositionEnd >= 0 ? compositionEnd - selectionEnd : 0;
        State next = new State(selectionEnd, extent, compositionLength, cursorInComposition);

        // This special callback clears predictions without setting the ordinary first-callback flag.
        if (compositionStart == compositionEnd && compositionEnd > 0) {
            expected.clear();
            actual = next;
            return new Update(Reason.IME, next, before, after, false);
        }
        boolean hadCallback = receivedSelectionCallback;
        receivedSelectionCallback = true;
        Reason reason = Reason.OTHER;
        if (previousStart == -1 && previousEnd == -1) {
            expected.clear();
            reason = Reason.IME;
        } else {
            while (!expected.isEmpty() && (batchDepth == 0 || expected.size() != 1)) {
                Expected pending = expected.removeFirst();
                if (pending.state.selectionEnd == selectionEnd
                        && pending.state.selectionExtent == extent
                        && pending.state.composingLength == compositionLength) {
                    reason = pending.reason;
                    break;
                }
            }
            if (!hadCallback && committedSinceReset) reason = Reason.IME;
        }
        actual = next;
        boolean atStart = selectionStart == 0 && selectionEnd == 0
                && compositionStart <= 0 && compositionEnd <= 0;
        return new Update(reason, next, before, after, atStart);
    }
}
