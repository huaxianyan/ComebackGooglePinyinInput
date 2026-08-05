# 16 KiB native page-size compatibility

## Scope

This stage starts from the accepted Android 16 / target SDK 36 baseline at
`b0ea63b`. It is intentionally separate from predictive Back, the MD3 rewrite,
and Android 17 work.

The release gate is **native 16 KiB compatibility**, not merely successful APK
installation or Android's legacy page-size compatibility mode.

## Baseline finding

The accepted V19 APK contains five AArch64 shared libraries. Four already use
`PT_LOAD p_align = 0x10000`; one does not:

| Library | PT_LOAD alignment | Static ELF result |
|---|---:|---|
| `liben_data_bundle.so` | `0x10000` | ready |
| `libgnustl_shared.so` | `0x10000` | ready |
| `libhmm_gesture_hwr_zh.so` | `0x1000` | **not ready** |
| `libhwrword.so` | `0x10000` | ready |
| `libpinyin_data_bundle.so` | `0x10000` | ready |

The libraries are compressed in the APK, so their ZIP data offsets are not the
current blocker. Android extracts them before loading. `zipalign -P 16` cannot
repair `libhmm_gesture_hwr_zh.so` because its ELF load segments themselves have
4 KiB alignment. More importantly, its writable load segment has
`p_offset=0x6767f0` and `p_vaddr=0x6777f0`: these are congruent modulo 4 KiB but
**not modulo 16 KiB**. Merely changing the two displayed `p_align` fields would
therefore produce an invalid 16 KiB mapping rather than a repaired library.

Run the dependency-free audit with:

```bash
python scripts/audit_elf_page_size.py path/to/app.apk
```

The tool checks every AArch64 ELF `PT_LOAD`, offset/vaddr congruence, and APK
storage alignment. It deliberately does not modify binaries or imply that
editing `p_align` alone is safe.

## Pixel 10 Pro test-device status

The current Pixel 10 Pro is hardware/build capable of a 16 KiB developer mode:

```text
ro.product.cpu.pagesize.max=16384
```

It is **currently running a 4 KiB kernel**, however:

```text
getconf PAGESIZE=4096
ro.boot.hardware.cpu.pagesize=4096
kernel build suffix=-4k
```

It therefore cannot currently provide 16 KiB runtime acceptance.

The installed Settings build includes the `Boot with 16 KB page size`
developer option. Its own confirmation text states that the bootloader must be
unlocked. On this device the current state is:

```text
ro.boot.flash.locked=1
ro.boot.vbmeta.device_state=locked
ro.boot.verifiedbootstate=green
```

The data partition currently uses F2FS. The Settings confirmation specifically
states that this device must convert `/data` to ext4 for the 16 KiB developer
option and that this conversion erases the device. Unlocking the bootloader and
later relocking it are also factory-reset boundaries.

Consequently, this phone **could technically become** a 16 KiB runtime test
device, but only after a destructive migration. The project decision is not to
use this daily device for 16 KiB testing merely because it can be converted.
No bootloader, filesystem, OEM-unlock, root/module, or phone-setting change will
be made for this stage. The phone remains the authoritative 4 KiB regression
device only.

## Emulator test environment

The Google SDK repository currently provides stable API 36 revision 7 images
specifically tagged `16 KB Page Size`:

```text
system-images;android-36;google_apis_ps16k;arm64-v8a
system-images;android-36;google_apis_ps16k;x86_64
```

Both require Android Emulator 35.4.9 or newer. The AArch64 image is preferred
for final native acceptance because the application ships only AArch64 native
libraries. An x86_64 image, even if it offers ARM translation, is secondary
diagnostic evidence and must not silently replace native AArch64 execution.

The current Windows host does not yet have an Android SDK/emulator installed.
Its Intel Core i7-8700K supports VT-x and SLAT, but firmware virtualization is
currently disabled and no hypervisor is active. Emulator provisioning therefore
requires the user to enable CPU virtualization in firmware first; tooling must
not alter firmware or Windows virtualization features silently.

Every emulator acceptance capture must verify the guest rather than infer its
page size from the image name:

```bash
adb shell getconf PAGESIZE
adb shell getprop ro.boot.hardware.cpu.pagesize
```

The runtime page size must report `16384`.

## Runtime acceptance boundary

Android 16 can expose per-app page-size compatibility behavior. A successful
launch under that compatibility path is useful for regression diagnosis but is
not proof that the shipped native libraries are natively 16 KiB-ready.

Final acceptance therefore requires all of the following:

1. Static audit passes for every packaged `.so` without patching only the
   displayed `p_align` value.
2. The APK packaging audit passes for the chosen extraction/storage model.
3. Runtime reports a genuine 16 KiB kernel page size.
4. Strict/native execution is tested separately from any per-app legacy
   compatibility mode.
5. The IME initializes and exercises Pinyin, candidates, gesture decoding,
   handwriting, dictionary load/save, themes, clipboard candidates, and process
   restart without linker errors, native aborts, or data loss.
6. A 4 KiB runtime regression pass still succeeds with the same APK.

## Investigation order

1. Inventory dynamic dependencies, exported JNI entry points, imports,
   relocations, RELRO, and consumers of `libhmm_gesture_hwr_zh.so`.
2. Identify the library's provenance and whether matching source/object files
   exist.
3. Prefer a reproducible relink with a modern linker and an appropriate maximum
   page size.
4. If source is unavailable, evaluate only ABI-compatible and legally usable
   replacement binaries. Do not assume a similarly named later Google library
   is data- or JNI-compatible.
5. Treat binary segment rewriting as experimental until load layout,
   relocations, RELRO, dynamic tables, and both 4 KiB/16 KiB runtimes pass.
6. Use an isolated audit package for every native experiment; never fault-inject
   the formal package.

## Explicit non-fixes

The following do not establish compatibility by themselves:

- `zipalign -P 16` on an ELF with `PT_LOAD Align 0x1000`;
- changing only an ELF program-header `p_align` field;
- hexadecimal replacement of `0x1000` with `0x4000`;
- successful operation on the current 4 KiB Pixel kernel;
- successful operation only through Android 16's legacy compatibility mode.
