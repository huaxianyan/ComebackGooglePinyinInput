import com.android.tools.smali.dexlib2.AccessFlags;
import com.android.tools.smali.dexlib2.DexFileFactory;
import com.android.tools.smali.baksmali.BaksmaliOptions;
import com.android.tools.smali.baksmali.Adaptors.ClassDefinition;
import com.android.tools.smali.baksmali.formatter.BaksmaliWriter;
import com.android.tools.smali.util.ClassFileNameHandler;
import com.android.tools.smali.dexlib2.iface.ClassDef;
import com.android.tools.smali.dexlib2.iface.Method;
import com.android.tools.smali.dexlib2.iface.instruction.Instruction;
import com.android.tools.smali.dexlib2.iface.instruction.ReferenceInstruction;
import com.android.tools.smali.dexlib2.iface.reference.MethodReference;
import java.io.BufferedWriter;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/** Static DEX declarations and invoke sites; uses the existing apktool's dexlib2. */
class DexInventory {
    private static String prototype(MethodReference method) {
        StringBuilder result = new StringBuilder("(");
        for (Object parameter : method.getParameterTypes()) result.append(parameter);
        return result.append(')').append(method.getReturnType()).toString();
    }

    private static String identity(MethodReference method) {
        return method.getDefiningClass() + "->" + method.getName() + prototype(method);
    }

    private static void row(BufferedWriter output, Object... values) throws Exception {
        for (int i = 0; i < values.length; i++) {
            if (i != 0) output.write('\t');
            output.write(values[i].toString().replace("\\", "\\\\")
                    .replace("\t", "\\t").replace("\r", "\\r").replace("\n", "\\n"));
        }
        output.newLine();
    }

    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            throw new IllegalArgumentException("Usage: DexInventory.java APK OUTPUT.tsv | APK OUTPUT_DIRECTORY smali [CLASS_DESCRIPTOR...]");
        }
        // A null opcode selection lets dexlib2 select from each DEX version.
        var container = DexFileFactory.loadDexContainer(new File(args[0]), null);
        List<String> entries = new ArrayList<>(container.getDexEntryNames());
        entries.sort(Comparator.naturalOrder());
        if (args.length >= 3) {
            if (!args[2].equals("smali")) throw new IllegalArgumentException("Unknown operation: " + args[2]);
            BaksmaliOptions options = new BaksmaliOptions();
            options.localsDirective = true;
            options.debugInfo = true;
            Set<String> requested = new HashSet<>();
            for (int index = 3; index < args.length; index++) requested.add(args[index]);
            Set<String> found = new HashSet<>();
            int exported = 0;
            for (String entryName : entries) {
                File destination = Path.of(args[1], entryName.replace(".dex", "")).toFile();
                ClassFileNameHandler names = new ClassFileNameHandler(destination);
                var dex = container.getEntry(entryName).getDexFile();
                for (Object rawDefinition : (List<?>) dex.classSection) {
                    ClassDef definition = (ClassDef) rawDefinition;
                    if (!requested.isEmpty() && !requested.contains(definition.getType())) continue;
                    Path output = names.getUniqueFilenameForClass(definition.getType()).toPath();
                    Files.createDirectories(output.getParent());
                    try (BufferedWriter writer = Files.newBufferedWriter(output, StandardCharsets.UTF_8)) {
                        new ClassDefinition(options, definition).writeTo(new BaksmaliWriter(writer));
                    }
                    found.add(definition.getType());
                    exported++;
                }
            }
            requested.removeAll(found);
            if (!requested.isEmpty()) throw new IllegalArgumentException("DEX classes not found: " + requested);
            System.out.printf("Disassembled %d selected classes across %d DEX entries%n", exported, entries.size());
            return;
        }
        int nativeFlag = AccessFlags.valueOf("NATIVE").value;
        Path destination = Path.of(args[1]);
        Files.createDirectories(destination.toAbsolutePath().getParent());
        int methods = 0, natives = 0, invokes = 0;
        try (BufferedWriter output = Files.newBufferedWriter(destination, StandardCharsets.UTF_8)) {
            row(output, "SCHEMA", 1, "DEX code-unit offsets; static invoke references, not runtime dispatch");
            for (String entryName : entries) {
                var dex = container.getEntry(entryName).getDexFile();
                List<ClassDef> classes = new ArrayList<>();
                for (Object definition : (List<?>) dex.classSection) classes.add((ClassDef) definition);
                classes.sort(Comparator.comparing(ClassDef::getType));
                row(output, "DEX", entryName, classes.size());
                for (var definition : classes) {
                    List<Method> classMethods = new ArrayList<>();
                    for (Object method : definition.getDirectMethods()) classMethods.add((Method) method);
                    for (Object method : definition.getVirtualMethods()) classMethods.add((Method) method);
                    for (Method method : classMethods) {
                        methods++;
                        boolean nativeMethod = (method.getAccessFlags() & nativeFlag) != 0;
                        row(output, nativeMethod ? "NATIVE" : "METHOD", entryName,
                                method.getDefiningClass(), method.getName(), prototype(method), method.getAccessFlags());
                        if (nativeMethod) natives++;
                        var implementation = method.getImplementation();
                        if (implementation == null) continue;
                        int offset = 0;
                        for (Object rawInstruction : implementation.getInstructions()) {
                            Instruction instruction = (Instruction) rawInstruction;
                            if (instruction instanceof ReferenceInstruction reference
                                    && reference.getReference() instanceof MethodReference target
                                    && instruction.getOpcode().name.startsWith("invoke-")) {
                                row(output, "CALL", entryName, identity(method), offset,
                                        instruction.getOpcode().name, identity(target));
                                invokes++;
                            }
                            offset += instruction.getCodeUnits();
                        }
                    }
                }
            }
        }
        System.out.printf("%d DEX entries, %d methods, %d native declarations, %d static invoke sites%n",
                entries.size(), methods, natives, invokes);
    }
}
