// Released DictionaryAccessor.persist() and DictionaryRecoveryCompat, see NOTICE.
package comeback.recovered;

import java.io.File;

public final class DictionaryFilePersistence {
    private DictionaryFilePersistence() {}

    @FunctionalInterface
    public interface PersistOperation {
        boolean persist(String absolutePath);
    }

    private static final class Paths {
        final File main;
        final File backup;
        final File temporary;
        final File unreadable;

        Paths(File main) {
            this.main = main;
            backup = new File(main.getPath() + "_bak");
            temporary = new File(main.getPath() + "_tmp");
            unreadable = new File(main.getPath() + "_unreadable");
        }
    }

    // Caller owns Context path resolution and native synchronization. Original
    // diagnostic logging is omitted. Keep the released rolling-backup policy,
    // not the original APK's post-success backup deletion.
    public static boolean persist(File main, PersistOperation operation) {
        if (operation == null) return false;
        Paths paths = new Paths(main);
        if (paths.temporary.exists() && !paths.temporary.delete()) return false;
        try {
            if (!operation.persist(paths.temporary.getAbsolutePath())) return false;
            if (main.exists()) {
                if (paths.backup.exists() && !paths.backup.delete()) return false;
                if (!main.renameTo(paths.backup)) return false;
            }
            if (!paths.temporary.renameTo(main)) return false;
            return true;
        } finally {
            if (paths.temporary.exists()) paths.temporary.delete();
            if (paths.backup.exists() && !main.exists()) paths.backup.renameTo(main);
        }
    }

    // Released enrollment calls this before attempting native loading.
    public static void prepareForLoad(File main) {
        Paths paths = new Paths(main);
        if (main.exists()) return;
        if (paths.backup.exists() && paths.backup.renameTo(main)) return;
        if (paths.temporary.exists()) paths.temporary.renameTo(main);
    }

    private static boolean replaceFailedMain(Paths paths, File candidate) {
        if (paths.main.exists()) {
            if (!paths.unreadable.exists()) {
                if (!paths.main.renameTo(paths.unreadable)) return false;
            } else if (!paths.main.delete()) {
                return false;
            }
        }
        return candidate.renameTo(paths.main);
    }

    // Native loading remains the validator; caller retries after a successful
    // candidate move. Each call consumes at most one backup/temporary candidate.
    public static boolean recoverAfterLoadFailure(File main) {
        Paths paths = new Paths(main);
        if (paths.backup.exists()) return replaceFailedMain(paths, paths.backup);
        if (paths.temporary.exists()) return replaceFailedMain(paths, paths.temporary);
        if (main.exists() && !paths.unreadable.exists()) main.renameTo(paths.unreadable);
        return false;
    }

    // Explicit clear/disable uses this path; ordinary learning retains backup.
    public static void purgeSidecars(File main) {
        Paths paths = new Paths(main);
        paths.backup.delete();
        paths.temporary.delete();
        paths.unreadable.delete();
    }
}
