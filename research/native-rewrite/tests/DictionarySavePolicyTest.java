package comeback.recovered;

/** Literal inputs/outputs for recovered scalar decisions, not an AsyncTask fake. */
public final class DictionarySavePolicyTest {
    private static final class EngineFactory {}

    private static void require(boolean value, String action) {
        if (!value) throw new AssertionError(action);
    }

    public static void main(String[] args) {
        require(!DictionarySavePolicy.shouldLaunch(false, 14400000L, 0L) &&
                DictionarySavePolicy.shouldLaunch(false, 14400001L, 0L),
                "a scheduled save becomes due only after the four-hour interval");
        require(!DictionarySavePolicy.shouldLaunch(true, 14400001L, 0L),
                "an engine already saving does not launch another scheduled task");
        require(DictionarySavePolicy.shouldLaunch(false, 0L, 14400001L),
                "the original wall-clock gate also admits a sufficiently future saved timestamp");
        require(DictionarySavePolicy.timePreferenceKey(EngineFactory.class).equals("save_dict_time_EngineFactory"),
                "save timestamps remain keyed by the engine factory's simple class name");
        require(DictionarySavePolicy.compactionTarget(DictionarySavePolicy.USER_DICTIONARY_CAPACITY) == 450000 &&
                DictionarySavePolicy.compactionTarget(DictionarySavePolicy.NEW_WORDS_DICTIONARY_CAPACITY) == 9000,
                "user and new-word dictionaries retain their original ninety-percent compaction targets");
        System.out.println("PASS: scheduled-save admission, factory timestamp key and literal compaction targets");
    }
}
