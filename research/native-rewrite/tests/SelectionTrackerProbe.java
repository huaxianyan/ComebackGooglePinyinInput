// Source-only module contract observations; no Android InputConnection mock.
import comeback.recovered.SelectionTracker;
import comeback.recovered.SelectionTracker.Reason;
import comeback.recovered.SelectionTracker.Update;

public final class SelectionTrackerProbe {
    private static void expect(Update update, Reason reason, int end, int extent,
                               int composingLength, int cursorInComposition, int before, int after) {
        if (update.reason != reason || update.state.selectionEnd != end
                || update.state.selectionExtent != extent || update.state.composingLength != composingLength
                || update.state.cursorInComposition != cursorInComposition
                || update.composingBeforeSelection != before || update.composingAfterSelection != after) {
            throw new AssertionError("Unexpected selection-state result");
        }
    }

    public static void main(String[] args) {
        SelectionTracker tracker = new SelectionTracker();
        tracker.reset(0, 0);
        Update initial = tracker.onFrameworkSelection(-1, -1, 0, 0, -1, -1);
        expect(initial, Reason.IME, 0, 0, 0, 0, 0, 0);
        if (!initial.atStartWithoutPositiveComposingEndpoint) {
            throw new AssertionError("Expected zero selection coordinates without positive composing endpoints");
        }
        tracker.reset(3, 3);
        tracker.predictComposing("ni", 1);
        SelectionTracker.State predicted = tracker.expectedState();
        if (predicted.selectionStart() != 5 || predicted.composingStart() != 3 || predicted.composingEnd() != 5) {
            throw new AssertionError("Unexpected predicted selection/composing coordinates");
        }
        expect(tracker.onFrameworkSelection(3, 3, 5, 5, 3, 5), Reason.IME, 5, 0, 2, 2, 2, 0);
        // The app moves the caret inside the existing composition.
        expect(tracker.onFrameworkSelection(5, 5, 4, 4, 3, 5), Reason.OTHER, 4, 0, 2, 1, 1, 1);
        tracker.predictCommit("你", 1);
        expect(tracker.onFrameworkSelection(4, 4, 4, 4, -1, -1), Reason.IME, 4, 0, 0, 0, 0, 0);

        // An intermediate framework callback arrives during an outstanding batch.
        tracker.reset(10, 10);
        tracker.beginBatch();
        tracker.predictComposing("a", 1);
        tracker.predictCommit("A", 1);
        expect(tracker.onFrameworkSelection(10, 10, 11, 11, 10, 11), Reason.IME, 11, 0, 1, 1, 1, 0);
        tracker.endBatch();
        expect(tracker.onFrameworkSelection(11, 11, 11, 11, -1, -1), Reason.IME, 11, 0, 0, 0, 0, 0);

        // Android cursor offsets use UTF-16 code units, including a surrogate pair.
        tracker.reset(0, 0);
        tracker.predictCommit("\uD83D\uDE00", 1);
        expect(tracker.onFrameworkSelection(0, 0, 2, 2, -1, -1), Reason.IME, 2, 0, 0, 0, 0, 0);
        System.out.println("PASS: composing, app caret movement, commit, batched callbacks, UTF-16 cursor positions");
    }
}
