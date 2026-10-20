// SaveDictionaryTask scalar decisions from released DEX; Google-derived, see NOTICE.
package comeback.recovered;

public final class DictionarySavePolicy {
    private DictionarySavePolicy() {}

    public static final int USER_DICTIONARY_CAPACITY = 500000;
    public static final int NEW_WORDS_DICTIONARY_CAPACITY = 10000;
    private static final long TASK_TIME_INTERVAL = 14400000L;
    private static final String TIME_KEY_PREFIX = "save_dict_time_";

    public static boolean shouldLaunch(boolean alreadyRunning, long now, long lastSave) {
        // Keep Java subtraction/Math.abs and the strict comparison from DEX;
        // this is not a monotonic-clock or elapsed-time rewrite.
        return !alreadyRunning && Math.abs(now - lastSave) > TASK_TIME_INTERVAL;
    }

    public static String timePreferenceKey(Class<?> factoryType) {
        return TIME_KEY_PREFIX + factoryType.getSimpleName();
    }

    public static int compactionTarget(int capacity) {
        // Original int-to-double, double multiplication, then double-to-int.
        return (int) (((double) capacity) * 0.9d);
    }
}
