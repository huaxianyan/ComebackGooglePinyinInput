package comeback.recovered;

import java.io.File;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;

/** One Windows-JDK/WSL1 integration flow; all paths are caller-owned project fixtures. */
public final class DictionaryFilePersistenceTest {
    private static void require(boolean condition, String action) {
        if (!condition) throw new AssertionError(action);
    }

    private static boolean nativePersist(String executable, String source, String destination) {
        ProcessBuilder command = source == null
                ? new ProcessBuilder("wsl.exe", "-e", executable, "uninitialized", destination)
                : new ProcessBuilder("wsl.exe", "-e", executable, "persist", source, destination);
        try {
            int status = command.inheritIO().start().waitFor();
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
        DictionaryFilePersistence.PersistOperation writeFirst = path -> nativePersist(executable,
                wslRoot + "/generation1.bin", wslRoot + "/" + new File(path).getName());
        DictionaryFilePersistence.PersistOperation writeSecond = path -> nativePersist(executable,
                wslRoot + "/generation2.bin", wslRoot + "/" + new File(path).getName());
        require(DictionaryFilePersistence.persist(main.toFile(), writeFirst) &&
                Arrays.equals(Files.readAllBytes(main), first),
                "save the first real dictionary through Java and the actual C++ file entry");
        require(DictionaryFilePersistence.persist(main.toFile(), writeSecond) &&
                Arrays.equals(Files.readAllBytes(main), second) &&
                !Files.exists(backup) && !Files.exists(temporary),
                "replace the main dictionary with the shorter second generation and clear staging files");

        // Frozen DEX boundary: a stale nonempty temporary directory fails BEFORE
        // try/finally. Do not silently turn this branch into a new recovery rule.
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
        DictionaryFilePersistence.PersistOperation invalidModel = path -> nativePersist(executable,
                null, wslRoot + "/" + new File(path).getName());
        require(!DictionaryFilePersistence.persist(main.toFile(), invalidModel) &&
                Arrays.equals(Files.readAllBytes(main), second) &&
                !Files.exists(backup) && !Files.exists(temporary),
                "a real failed save cleans its partial temporary file and restores the retained backup");
        Files.delete(main);
        System.out.println("PASS: Java replacement plus actual C++ persistence, pre-finally failure and backup restoration");
    }
}
