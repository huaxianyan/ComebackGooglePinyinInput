# 16 KiB native page-size compatibility

## Scope

This stage starts from the accepted Android 16 / target SDK 36 baseline at
`b0ea63b`. It is intentionally separate from predictive Back, the MD3 rewrite,
and Android 17 work.

The release gate is **native 16 KiB compatibility**, not merely successful APK
installation or Android's legacy page-size compatibility mode.

## Baseline finding

The accepted V19 APK contains five AArch64 shared libraries. The first audit
found one obvious `PT_LOAD` failure, but runtime work exposed a second class of
problem: three nominally 64 KiB-aligned libraries place mutable `.data`/`.bss`
immediately after a `PT_GNU_RELRO` end that is not 16 KiB-aligned.

| Library | PT_LOAD alignment | Original 16 KiB result |
|---|---:|---|
| `liben_data_bundle.so` | `0x10000` | RELRO/data page collision |
| `libgnustl_shared.so` | `0x10000` | RELRO/data page collision |
| `libhmm_gesture_hwr_zh.so` | `0x1000` | non-congruent LOAD plus RELRO/data collision |
| `libhwrword.so` | `0x10000` | RELRO/data page collision |
| `libpinyin_data_bundle.so` | `0x10000` | ready without rewriting |

The libraries are compressed in the APK, so Android extracts them before
loading and their ZIP data offsets are not the blocker. `zipalign -P 16` cannot
repair ELF load mappings.

`libhmm_gesture_hwr_zh.so` originally has a writable load segment with
`p_offset=0x6767f0` and `p_vaddr=0x6777f0`. They are congruent modulo 4 KiB but
not modulo 16 KiB. A first experiment inserted file padding and changed
`p_align`; it passed the initial static check and got past `dlopen`, but then
crashed in a global constructor with `SIGSEGV/SEGV_ACCERR`. The 16 KiB RELRO
page had made post-RELRO writable data read-only. This confirms that changing
only program-header alignment is not a valid repair.

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

A project-local test environment now exists under `work/android-sdk-16kb`:

```text
Temurin JDK 17.0.20+8
Android Emulator 37.1.11
Platform Tools 37.0.1
API 36 ps16k x86_64 revision 7
API 36 ps16k arm64-v8a revision 7
API 36 4 KiB x86_64 revision 7
```

Intel VT-x and Windows Hypervisor Platform are enabled. No Android SDK, JDK or
AVD was installed globally. The AVD and SDK state remain disposable project
workspace data.

The x86_64 ps16k guest reports:

```text
getconf PAGESIZE=16384
ro.product.cpu.abi=x86_64
ro.product.cpu.abilist=x86_64,arm64-v8a
ro.dalvik.vm.native.bridge=libndk_translation.so
```

The arm64-v8a ps16k image is installed, but Android Emulator refuses to run an
ARM64 AVD on this x86_64 host (`System image must match the host architecture`).
Consequently, current local runtime evidence uses Android's ARM64 translation
bridge. It is useful and genuine 16 KiB-kernel evidence, but it is not native
AArch64 execution and does not complete final acceptance.

Every emulator acceptance capture must verify the guest rather than infer its
page size from the image name:

```bash
adb shell getconf PAGESIZE
adb shell getprop ro.boot.hardware.cpu.pagesize
```

The runtime page size must report `16384`.

## Implemented binary transformation

`scripts/rewrite_elf_16kb.py` performs a dependency-free, fail-closed rewrite
of four exact source binaries. Every accepted source and result is pinned by
size and SHA-256; unknown input aborts the build.

For `libhmm_gesture_hwr_zh.so`, it first inserts `0x1000` bytes before the
writable `PT_LOAD`, updates all affected file offsets, and raises both LOAD
alignments to `0x4000`. For all four affected libraries it then inserts padding
between the original RELRO range and post-RELRO mutable data, moves `.data` and
`.bss` to the next 16 KiB page, and updates:

- program and section headers;
- dynamic and regular symbol values;
- relocation destinations and AArch64 relative addends;
- AArch64 `ADRP` references in executable sections.

The original RELRO range is preserved. An abandoned experiment that shortened
RELRO loaded successfully but weakened protection of `.data.rel.ro`; it is not
the implementation.

| Library | Original SHA-256 | Rewritten SHA-256 |
|---|---|---|
| `liben_data_bundle.so` | `c96feea4652afcf1ae5f89d2bc2aa3542c02e78d690f0ed8f4bd75ac727a7d72` | `cd1eab5650dca5886c829a1c1f7e007ae336484d3606d4091b369b81c0cfcfa2` |
| `libgnustl_shared.so` | `dd5b244c523dc6f25a9ec985bc4d2d79a7af3fc7a0ac2cbf9f63ebd18abb0607` | `13cf67db74ee9cb1ef11206e372e7be939bbe803c2704bc95c9d0f739b7b9f03` |
| `libhmm_gesture_hwr_zh.so` | `273c69c25124fbdbdc80a44acfd74b057494dcb91e563e5df511986566deadcf` | `6a1c28be99ce3c43ef9bcc295089af020f3fc8303e5ef0b6f943a3e07c0c2fea` |
| `libhwrword.so` | `2e83a783516bed796e4700cb9587433330b287c53005de830f11783d6922544f` | `557ae6f6dca2d5d9cf33bb70629be3272954ee78d86749304b5f175999202158` |

`scripts/audit_elf_page_size.py` now checks LOAD alignment and congruence as
well as RELRO rounding against writable sections. The integrated audit APK
passes all five libraries. The same gate is part of the release workflow and
passed on branch commit `c666f79`:

```text
Actions run=31073195893
Artifact=8956430162 (ComebackGooglePinyinInput-native16kbaudit-c666f79)
APK SHA-256=1234e674165601ffc4ddd4412394e321d52b237f498cdfab851d6f39f9cffdef
package=com.google.android.inputmethod.pinyin.native16kbaudit
versionName=2.0.0
versionCode=4520385
targetSdkVersion=36
debuggable=false
certificate SHA-256=985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F
```

The downloaded Actions APK independently passed the five-library audit, and
all transformed library hashes matched the pinned outputs above. This branch
run uploaded only an Actions Artifact; it did not create a GitHub Release.

## Current runtime evidence

An isolated, release-like package uses:

```text
com.google.android.inputmethod.pinyin.native16kbaudit
```

On the API 36 x86_64 ps16k guest, the integrated APK was installed and pulled
back byte-for-byte (`SHA-256 b6323a54f829e82d863cb25b67ffbde85ac5e6acf3e79b48f1bbddd752b663ec`).
With `getconf PAGESIZE=16384`, the ARM64 translation bridge
loaded the rewritten HMM and data libraries, displayed the IME, and processed a
synthetic Pinyin input/commit sequence. A temporary probe also explicitly
loaded rewritten `libhwrword.so`. Observed counts were:

```text
FATAL EXCEPTION=0
UnsatisfiedLinkError=0
program alignment=0
SIGSEGV=0
SIGABRT=0
VerifyError=0
```

The same transformed payload passed the equivalent synthetic IME sequence on
an API 36 4 KiB x86_64 guest, and the temporary probe loaded `libhwrword.so`
there as well.

The Actions audit APK was subsequently installed on the physical Pixel 10 Pro
without replacing the formal package. The installed `base.apk` matched the
Actions APK byte-for-byte (`SHA-256
1234e674165601ffc4ddd4412394e321d52b237f498cdfab851d6f39f9cffdef`). The
runtime reported:

```text
getconf PAGESIZE=4096
ro.product.cpu.abi=arm64-v8a
ro.dalvik.vm.native.bridge=0
```

The project maintainer completed a broad manual pass covering nearly all
available functions and reported no defect. A post-test objective check found
the audit IME selected and its process alive, with no package match in the
crash buffer and no `FATAL EXCEPTION`, `UnsatisfiedLinkError`, `SIGSEGV`,
`SIGABRT`, `VerifyError`, `SEGV_ACCERR`, or program-alignment error. This is the
required native AArch64 4 KiB backward-compatibility evidence; it does not
replace native AArch64 16 KiB acceptance.

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
