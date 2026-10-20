package comeback.recovered;

import java.io.File;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;

/** One Windows-JDK/WSL1 integration flow; all paths are caller-owned project fixtures. */
public final class DictionaryFilePersistenceTest {
    private static void require(boolean condition, String action) {
        if (!condition) throw new AssertionError(action);
    }

    private static boolean runNative(String executable, String... operation) {
        ArrayList<String> command = new ArrayList<>(Arrays.asList("wsl.exe", "-e", executable));
        command.addAll(Arrays.asList(operation));
        try {
            int status = new ProcessBuilder(command).inheritIO().start().waitFor();
            require(status == 0 || status == 1, "native transport/input error is not a persistence failure");
            return status == 0;
        } catch (IOException error) {
            throw new UncheckedIOException(error);
        } catch (InterruptedException error) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException(error);
        }
    }

    public static void main(String[] args) throws Exception {
        require(args.length == 3, "provide Windows fixture directory, WSL fixture directory and WSL driver path");
        Path root = Path.of(args[0]);
        String wslRoot = args[1];
        String executable = args[2];
        Path main = root.resolve("dictionary");
        Path backup = root.resolve("dictionary_bak");
        Path temporary = root.resolve("dictionary_tmp");
        byte[] first = Files.readAllBytes(root.resolve("generation1.bin"));
        byte[] second = Files.readAllBytes(root.resolve("generation2.bin"));
        DictionaryFilePersistence.PersistOperation writeFirst = path -> runNative(executable, "persist",
                wslRoot + "/generation1.bin", wslRoot + "/" + new File(path).getName());
        DictionaryFilePersistence.PersistOperation writeSecond = path -> runNative(executable, "persist",
                wslRoot + "/generation2.bin", wslRoot + "/" + new File(path).getName());
        require(DictionaryFilePersistence.persist(main.toFile(), writeFirst) &&
                Arrays.equals(Files.readAllBytes(main), first),
                "save the first real dictionary through Java and the actual C++ file entry");
        require(DictionaryFilePersistence.persist(main.toFile(), writeSecond) &&
                Arrays.equals(Files.readAllBytes(main), second) &&
                Arrays.equals(Files.readAllBytes(backup), first) && !Files.exists(temporary),
                "replace the main dictionary while retaining the previous complete generation as backup");

        // Frozen DEX boundary: a stale nonempty temporary directory fails BEFORE
        // try/finally. Do not silently turn this branch into a new recovery rule.
        Files.delete(backup);
        Files.move(main, backup);
        Files.createDirectory(temporary);
        Path blocker = temporary.resolve("blocker");
        Files.write(blocker, first);
        require(!DictionaryFilePersistence.persist(main.toFile(), writeSecond) &&
                !Files.exists(main) && Arrays.equals(Files.readAllBytes(backup), second),
                "an undeletable staging directory preserves the original pre-finally failure boundary");
        Files.delete(blocker);
        Files.delete(temporary);

        // An explicit uninitialized model invokes actual serialization failure.
        // The test constructs a file state, not a process-crash simulation.
        DictionaryFilePersistence.PersistOperation invalidModel = path -> runNative(executable,
                "uninitialized", wslRoot + "/" + new File(path).getName());
        require(!DictionaryFilePersistence.persist(main.toFile(), invalidModel) &&
                Arrays.equals(Files.readAllBytes(main), second) &&
                !Files.exists(backup) && !Files.exists(temporary),
                "a real failed save cleans its partial temporary file and restores the retained backup");
        // Reconstruct interrupted on-disk states; no process is killed here.
        Files.move(main, backup);
        Files.copy(root.resolve("generation1.bin"), temporary);
        DictionaryFilePersistence.prepareForLoad(main.toFile());
        require(Arrays.equals(Files.readAllBytes(main), second) && Files.exists(temporary) &&
                runNative(executable, "validate", wslRoot + "/dictionary"),
                "startup restores the retained backup before considering an unfinished temporary image");

        // Create a genuinely unreadable main and backup via the actual encoder's
        // invalid-model path, then allow the real parser to select the valid tmp.
        require(!runNative(executable, "uninitialized", wslRoot + "/dictionary"),
                "an uninitialized model produces an actual failed serialization");
        byte[] failedMain = Files.readAllBytes(main);
        Files.copy(main, backup);
        require(!runNative(executable, "validate", wslRoot + "/dictionary") &&
                DictionaryFilePersistence.recoverAfterLoadFailure(main.toFile()) &&
                !runNative(executable, "validate", wslRoot + "/dictionary") &&
                DictionaryFilePersistence.recoverAfterLoadFailure(main.toFile()) &&
                runNative(executable, "validate", wslRoot + "/dictionary") &&
                Arrays.equals(Files.readAllBytes(main), first),
                "a rejected backup is consumed before the valid temporary dictionary is loaded");
        Path unreadable = root.resolve("dictionary_unreadable");
        require(Arrays.equals(Files.readAllBytes(unreadable), failedMain),
                "recovery retains the first unreadable main as the diagnostic file");
        DictionaryFilePersistence.purgeSidecars(main.toFile());
        require(!Files.exists(unreadable) && !Files.exists(backup) && !Files.exists(temporary) &&
                Arrays.equals(Files.readAllBytes(main), first),
                "explicit sidecar cleanup removes recoverable old copies and preserves the current main");
        Files.delete(main);
        System.out.println("PASS: released rolling backup, real failed saves, startup recovery and explicit cleanup");
    }
}
