// Export selected functions from an analyzed Ghidra program for research.
// Arguments: NEW_OUTPUT_DIRECTORY IMAGE_RELATIVE_HEX_OFFSET...
// @category Comeback.NativeResearch

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.GsonBuilder;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;

public class ExportNativeFunctions extends GhidraScript {
    @Override
    public void run() throws Exception {
        String[] arguments = getScriptArgs();
        if (arguments.length < 2) {
            throw new IllegalArgumentException(
                "Expected a new output directory followed by image-relative hex offsets");
        }
        Path output = Files.createDirectory(Path.of(arguments[0]));
        Map<String, Object> report = new LinkedHashMap<>();
        report.put("program", currentProgram.getName());
        report.put("executable_sha256", currentProgram.getExecutableSHA256());
        report.put("language", currentProgram.getLanguageID().toString());
        report.put("compiler", currentProgram.getCompilerSpec().getCompilerSpecID().toString());
        report.put("image_base", currentProgram.getImageBase().toString());
        List<Map<String, Object>> functions = new ArrayList<>();
        DecompInterface decompiler = new DecompInterface();
        try {
            if (!decompiler.openProgram(currentProgram)) {
                throw new IOException(decompiler.getLastMessage());
            }
            for (int index = 1; index < arguments.length; index++) {
                monitor.checkCancelled();
                var address = currentProgram.getImageBase().add(
                    Long.parseUnsignedLong(arguments[index], 16));
                Function function = getFunctionAt(address);
                if (function == null) {
                    throw new IOException("No function entry at " + address
                        + " (image base " + currentProgram.getImageBase() + ")");
                }
                DecompileResults result = decompiler.decompileFunction(function, 30, monitor);
                if (!result.decompileCompleted() || result.getDecompiledFunction() == null) {
                    throw new IOException("Decompilation failed at " + arguments[index]
                        + ": " + result.getErrorMessage());
                }
                String filename = function.getEntryPoint().toString() + ".c";
                Files.writeString(output.resolve(filename),
                    result.getDecompiledFunction().getC(), StandardCharsets.UTF_8);
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("entry_point", function.getEntryPoint().toString());
                item.put("name", function.getName());
                item.put("prototype", result.getDecompiledFunction().getSignature());
                item.put("diagnostics", result.getErrorMessage());
                item.put("source_file", filename);
                functions.add(item);
            }
            report.put("functions", functions);
            Files.writeString(output.resolve("manifest.json"),
                new GsonBuilder().setPrettyPrinting().create().toJson(report),
                StandardCharsets.UTF_8);
            println("Exported " + functions.size() + " native function views to " + output);
        } finally {
            decompiler.dispose();
        }
    }
}
