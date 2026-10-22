// Export selected functions from an analyzed Ghidra program for research.
// Arguments: NEW_OUTPUT_DIRECTORY [--unwind-ranges CPP_TYPES_JSON] IMAGE_RELATIVE_HEX_OFFSET...
// @category Comeback.NativeResearch

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.HexFormat;
import java.util.zip.ZipFile;
import java.security.MessageDigest;

import com.google.gson.GsonBuilder;
import com.google.gson.JsonParser;
import ghidra.app.cmd.disassemble.DisassembleCommand;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import ghidra.program.model.address.Address;
import ghidra.program.model.address.AddressSet;
import ghidra.program.model.symbol.SourceType;

public class ExportNativeFunctions extends GhidraScript {
    private Map<Long, Long> readUnwindRanges(Path input) throws Exception {
        var metadata = JsonParser.parseString(Files.readString(input, StandardCharsets.UTF_8))
            .getAsJsonObject();
        try (var apk = new ZipFile(metadata.get("apk").getAsString())) {
            var library = apk.getEntry(metadata.get("library").getAsString());
            if (library == null) throw new IOException("Unwind source library is absent from APK");
            try (var bytes = apk.getInputStream(library)) {
                var digest = MessageDigest.getInstance("SHA-256").digest(bytes.readAllBytes());
                if (!HexFormat.of().formatHex(digest).equalsIgnoreCase(
                        currentProgram.getExecutableSHA256())) {
                    throw new IOException("Unwind source does not match the analyzed executable");
                }
            }
        }
        Map<Long, Long> ranges = new LinkedHashMap<>();
        for (var entry : metadata.getAsJsonArray("unwind_function_ranges")) {
            var range = entry.getAsJsonObject();
            ranges.put(range.get("start").getAsLong(), range.get("end").getAsLong());
        }
        return ranges;
    }

    private Function defineUnwindFunction(Address address, long endOffset) throws Exception {
        if (getFunctionContaining(address) != null) {
            throw new IOException("Unwind entry overlaps an existing function at " + address);
        }
        var end = currentProgram.getImageBase().add(endOffset - 1);
        if (end.compareTo(address) < 0) throw new IOException("Invalid unwind range at " + address);
        var body = new AddressSet(address, end);
        if (getInstructionAt(address) == null) {
            var command = new DisassembleCommand(address, body, true);
            command.enableCodeAnalysis(false);
            command.applyTo(currentProgram, monitor);
            if (getInstructionAt(address) == null) {
                throw new IOException("Cannot disassemble unwind entry at " + address);
            }
        }
        return currentProgram.getFunctionManager().createFunction(
            null, address, body, SourceType.ANALYSIS);
    }

    @Override
    public void run() throws Exception {
        String[] arguments = getScriptArgs();
        if (arguments.length < 2) {
            throw new IllegalArgumentException(
                "Expected a new output directory followed by image-relative hex offsets");
        }
        int firstOffset = 1;
        Map<Long, Long> unwindRanges = Map.of();
        if (arguments[1].equals("--unwind-ranges")) {
            if (arguments.length < 4) throw new IllegalArgumentException("Missing unwind file or offsets");
            unwindRanges = readUnwindRanges(Path.of(arguments[2]));
            firstOffset = 3;
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
            for (int index = firstOffset; index < arguments.length; index++) {
                monitor.checkCancelled();
                long offset = Long.parseUnsignedLong(arguments[index], 16);
                var address = currentProgram.getImageBase().add(offset);
                Function function = getFunctionAt(address);
                boolean definedFromUnwind = function == null && unwindRanges.containsKey(offset);
                if (definedFromUnwind) {
                    function = defineUnwindFunction(address, unwindRanges.get(offset));
                }
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
                item.put("defined_from_unwind", definedFromUnwind);
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
