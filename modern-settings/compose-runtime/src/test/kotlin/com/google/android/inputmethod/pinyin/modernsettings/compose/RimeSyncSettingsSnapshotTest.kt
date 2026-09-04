package com.google.android.inputmethod.pinyin.modernsettings.compose

import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class RimeSyncSettingsSnapshotTest {
    @Test
    fun nativePersistenceDiagnosticsIncludeTotalCountMismatch() {
        assertTrue(
            RimeSyncSettingsSnapshot(
                nativeExpectedCount = 10,
                nativeActualCount = 9,
                nativeMissingCount = 0,
            ).hasNativePersistenceDiagnostics,
        )
    }

    @Test
    fun rejectedEntriesAreSeparateFromPersistenceDiagnostics() {
        val snapshot = RimeSyncSettingsSnapshot(
            nativeMissingCount = 2,
            nativeFailureKind = NativeFailureKind.Insert,
        )

        assertFalse(snapshot.hasNativePersistenceDiagnostics)
        assertTrue(snapshot.nativeRejectedCount == 2)
    }

    @Test
    fun emptyNativePersistenceDiagnosticsAreNotReported() {
        assertFalse(RimeSyncSettingsSnapshot().hasNativePersistenceDiagnostics)
    }
}
