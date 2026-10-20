// Recovered DictionaryAccessor.persist() file protocol; Google-derived, see NOTICE.
package comeback.recovered;

import java.io.File;

public final class DictionaryFilePersistence {
    private DictionaryFilePersistence() {}

    @FunctionalInterface
    public interface PersistOperation {
        boolean persist(String absolutePath);
    }

    // The caller resolves the main file with Context.getFileStreamPath and
    // supplies the actual native persistence operation and its synchronization.
    // Original diagnostic logging is not reproduced by this research component.
    public static boolean persist(File main, PersistOperation operation) {
        if (operation == null) return false;
        File backup = new File(main.getPath() + "_bak");
        File temporary = new File(main.getPath() + "_tmp");
        // This early return is outside the native method's try/finally region.
        if (temporary.exists() && !temporary.delete()) return false;
        try {
            if (!operation.persist(temporary.getAbsolutePath())) return false;
            if (main.exists()) {
                if (backup.exists() && !backup.delete()) return false;
                if (!main.renameTo(backup)) return false;
            }
            if (!temporary.renameTo(main)) return false;
            backup.delete(); // Native failure is diagnostic only, not a failed save.
            return true;
        } finally {
            if (temporary.exists()) temporary.delete();
            if (backup.exists() && !main.exists()) backup.renameTo(main);
        }
    }
}
