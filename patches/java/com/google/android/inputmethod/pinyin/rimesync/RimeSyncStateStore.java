package com.google.android.inputmethod.pinyin.rimesync;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.io.Closeable;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

/** Private durable baseline and recovery journal for one configured Rime sync profile. */
public final class RimeSyncStateStore extends SQLiteOpenHelper {
    private static final String DATABASE_NAME = "rime_dictionary_sync.db";
    private static final int DATABASE_VERSION = 4;
    private static final int PROFILE_ID = 1;
    private static final Charset UTF_8 = Charset.forName("UTF-8");

    public static final int PHASE_IDLE = 0;
    public static final int PHASE_PLANNED = 1;
    public static final int PHASE_GOOGLE_APPLIED = 2;
    public static final int PHASE_SNAPSHOT_PUBLISHED = 3;

    public static final int NATIVE_FAILURE_NONE = 0;
    public static final int NATIVE_FAILURE_PERSISTENCE = 1;
    public static final int NATIVE_FAILURE_IO = 2;
    public static final int NATIVE_FAILURE_MEMORY = 3;
    public static final int NATIVE_FAILURE_RUNTIME = 4;

    public RimeSyncStateStore(Context context) {
        super(context.getApplicationContext(), DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE profile (id INTEGER PRIMARY KEY, root_uri TEXT NOT NULL, "
                + "device_dir TEXT NOT NULL, snapshot_file TEXT NOT NULL, "
                + "bridge_user_id TEXT NOT NULL, hash_salt BLOB NOT NULL, "
                + "protocol_version INTEGER NOT NULL, generation INTEGER NOT NULL, "
                + "phase INTEGER NOT NULL, last_success INTEGER NOT NULL, "
                + "native_expected_count INTEGER NOT NULL DEFAULT 0, "
                + "native_actual_count INTEGER NOT NULL DEFAULT 0, "
                + "native_missing_count INTEGER NOT NULL DEFAULT 0, "
                + "native_failure_fingerprint BLOB, "
                + "native_failure_repeated INTEGER NOT NULL DEFAULT 0, "
                + "native_failure_kind INTEGER NOT NULL DEFAULT 0)");
        db.execSQL("CREATE TABLE baseline (key_hash BLOB PRIMARY KEY, history TEXT NOT NULL, "
                + "google_projection TEXT NOT NULL, rime_abs_count INTEGER NOT NULL)");
        db.execSQL("CREATE TABLE staged_baseline (key_hash BLOB PRIMARY KEY, "
                + "history TEXT NOT NULL, google_projection TEXT NOT NULL, "
                + "rime_abs_count INTEGER NOT NULL)");
        db.execSQL("CREATE TABLE pending_operation (sequence INTEGER PRIMARY KEY AUTOINCREMENT, "
                + "code TEXT NOT NULL, phrase TEXT NOT NULL, google_action TEXT NOT NULL, "
                + "rime_action TEXT NOT NULL, rime_commit_value INTEGER NOT NULL)");
    }

    @Override public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion < 1 || newVersion != DATABASE_VERSION) {
            throw new IllegalStateException(
                    "Rime synchronization state requires an explicit migration");
        }
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE profile ADD COLUMN "
                    + "native_expected_count INTEGER NOT NULL DEFAULT 0");
            db.execSQL("ALTER TABLE profile ADD COLUMN "
                    + "native_actual_count INTEGER NOT NULL DEFAULT 0");
            db.execSQL("ALTER TABLE profile ADD COLUMN "
                    + "native_missing_count INTEGER NOT NULL DEFAULT 0");
            db.execSQL("ALTER TABLE profile ADD COLUMN native_failure_fingerprint BLOB");
            db.execSQL("ALTER TABLE profile ADD COLUMN "
                    + "native_failure_repeated INTEGER NOT NULL DEFAULT 0");
        }
        if (oldVersion < 3) {
            db.execSQL("ALTER TABLE profile ADD COLUMN "
                    + "native_failure_kind INTEGER NOT NULL DEFAULT 0");
        }
        if (oldVersion < 4) {
            db.execSQL("ALTER TABLE baseline ADD COLUMN google_projection "
                    + "TEXT NOT NULL DEFAULT 'SUPPORTED'");
            db.execSQL("ALTER TABLE staged_baseline ADD COLUMN google_projection "
                    + "TEXT NOT NULL DEFAULT 'SUPPORTED'");
        }
    }

    /** Configure exactly one profile. A changed identity starts with an empty safe baseline. */
    public synchronized Profile configure(String rootUri, RimeSyncConfiguration configuration,
            int protocolVersion, String recoveredBridgeUserId)
            throws RimeSyncCore.IdentityConflictException {
        if (rootUri == null || rootUri.length() == 0 || configuration == null
                || protocolVersion <= 0) {
            throw new IllegalArgumentException("Rime synchronization profile is invalid");
        }
        SQLiteDatabase db = getWritableDatabase();
        Profile current = readProfile(db);
        if (current != null
                && current.deviceDirectoryName.equals(configuration.deviceDirectoryName)
                && current.snapshotFileName.equals(configuration.snapshotFileName)
                && current.protocolVersion == protocolVersion) {
            if (recoveredBridgeUserId != null
                    && !current.bridgeUserId.equals(recoveredBridgeUserId)) {
                throw new RimeSyncCore.IdentityConflictException();
            }
            if (current.rootUri.equals(rootUri)) return current;
            if (current.phase != PHASE_IDLE) {
                throw new IllegalStateException(
                        "unfinished Rime synchronization must be recovered before relocation");
            }
            // A storage location is not a synchronization identity. Keep the complete
            // baseline (including RIME_ONLY), salt, generation and successful-sync time.
            db.execSQL("UPDATE profile SET root_uri=? WHERE id=?",
                    new Object[] {rootUri, PROFILE_ID});
            return readProfile(db);
        }
        if (current != null && current.phase != PHASE_IDLE) {
            throw new IllegalStateException(
                    "unfinished Rime synchronization must be recovered before reconfiguration");
        }
        byte[] salt = new byte[32];
        new SecureRandom().nextBytes(salt);
        String bridgeUserId = UUID.randomUUID().toString();
        if (recoveredBridgeUserId != null) {
            try {
                if (!UUID.fromString(recoveredBridgeUserId).toString()
                        .equals(recoveredBridgeUserId)) {
                    throw new IllegalArgumentException("non-canonical UUID");
                }
                bridgeUserId = recoveredBridgeUserId;
            } catch (IllegalArgumentException failure) {
                throw new IllegalArgumentException(
                        "recovered Bridge snapshot identity is invalid", failure);
            }
        }
        Profile replacement = new Profile(rootUri, configuration.deviceDirectoryName,
                configuration.snapshotFileName, bridgeUserId, salt,
                protocolVersion, 0L, PHASE_IDLE, 0L,
                0, 0, 0, null, false, NATIVE_FAILURE_NONE);
        db.beginTransaction();
        try {
            clearSyncData(db);
            db.insertOrThrow("profile", null, profileValues(replacement));
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
        return replacement;
    }

    public synchronized Profile profile() {
        return readProfile(getReadableDatabase());
    }

    public static final class BaselineCounts {
        public final int shared;
        public final int rimeOnly;
        BaselineCounts(int shared, int rimeOnly) {
            this.shared = shared; this.rimeOnly = rimeOnly;
        }
    }

    /** Counts committed metadata, without loading dictionary words or SAF snapshots. */
    public synchronized BaselineCounts baselineCounts() {
        Cursor cursor = getReadableDatabase().rawQuery(
                "SELECT google_projection, COUNT(*) FROM baseline WHERE history=? "
                + "GROUP BY google_projection",
                new String[] {RimeSyncPlanner.History.PRESENT.name()});
        int shared = 0;
        int rimeOnly = 0;
        try {
            while (cursor.moveToNext()) {
                RimeSyncPlanner.GoogleProjection projection =
                        RimeSyncPlanner.GoogleProjection.valueOf(cursor.getString(0));
                if (projection == RimeSyncPlanner.GoogleProjection.RIME_ONLY) {
                    rimeOnly = cursor.getInt(1);
                } else {
                    shared = cursor.getInt(1);
                }
            }
            return new BaselineCounts(shared, rimeOnly);
        } finally {
            cursor.close();
        }
    }

    public synchronized Baseline baseline(byte[] keyHash) {
        requireHash(keyHash);
        Cursor cursor = getReadableDatabase().rawQuery(
                "SELECT history, google_projection, rime_abs_count FROM baseline "
                        + "WHERE key_hash=X'" + hex(keyHash) + "'", null);
        try {
            return cursor.moveToFirst()
                    ? new Baseline(RimeSyncPlanner.History.valueOf(cursor.getString(0)),
                            RimeSyncPlanner.GoogleProjection.valueOf(cursor.getString(1)),
                            cursor.getInt(2))
                    : new Baseline(RimeSyncPlanner.History.UNKNOWN,
                            RimeSyncPlanner.GoogleProjection.SUPPORTED, 0);
        } finally {
            cursor.close();
        }
    }

    /** Hashes private dictionary keys with a per-profile random salt before durable storage. */
    public byte[] keyHash(String canonicalKey) {
        if (canonicalKey == null) throw new IllegalArgumentException("canonical key is required");
        Profile current = profile();
        if (current == null) throw new IllegalStateException("Rime profile is not configured");
        return keyHash(current.hashSalt, canonicalKey);
    }

    /** Loads the complete hashed baseline once, avoiding one SQLite query per dictionary entry. */
    public synchronized RimeSyncSessionPlan.BaselineLookup baselineLookup() {
        final Profile current = readProfile(getReadableDatabase());
        if (current == null) throw new IllegalStateException("Rime profile is not configured");
        Cursor cursor = getReadableDatabase().query("baseline",
                new String[] {"key_hash", "history", "google_projection", "rime_abs_count"},
                null, null, null, null, "key_hash");
        final int count = cursor.getCount();
        final byte[] hashes = new byte[count * 32];
        final byte[] histories = new byte[count];
        final byte[] projections = new byte[count];
        final int[] rimeAbsCounts = new int[count];
        int index = 0;
        try {
            while (cursor.moveToNext()) {
                byte[] hash = cursor.getBlob(0);
                requireHash(hash);
                System.arraycopy(hash, 0, hashes, index * 32, 32);
                histories[index] = (byte) RimeSyncPlanner.History.valueOf(
                        cursor.getString(1)).ordinal();
                projections[index] = (byte) RimeSyncPlanner.GoogleProjection.valueOf(
                        cursor.getString(2)).ordinal();
                rimeAbsCounts[index] = cursor.getInt(3);
                index++;
            }
        } finally {
            cursor.close();
        }
        final byte[] salt = current.hashSalt.clone();
        final RimeSyncSessionPlan.Baseline unknown = new RimeSyncSessionPlan.Baseline(
                RimeSyncPlanner.History.UNKNOWN,
                RimeSyncPlanner.GoogleProjection.SUPPORTED, 0);
        final RimeSyncPlanner.History[] historyValues = RimeSyncPlanner.History.values();
        final RimeSyncPlanner.GoogleProjection[] projectionValues =
                RimeSyncPlanner.GoogleProjection.values();
        return new RimeSyncSessionPlan.BaselineLookup() {
            @Override public RimeSyncSessionPlan.Baseline get(String canonicalKey) {
                int found = findHash(hashes, count, keyHash(salt, canonicalKey));
                return found < 0 ? unknown : new RimeSyncSessionPlan.Baseline(
                        historyValues[histories[found]], projectionValues[projections[found]],
                        rimeAbsCounts[found]);
            }
        };
    }

    public synchronized Stage beginStage() {
        SQLiteDatabase db = getWritableDatabase();
        Profile current = readProfile(db);
        if (current == null) throw new IllegalStateException("Rime profile is not configured");
        if (current.phase != PHASE_IDLE) {
            throw new IllegalStateException("an unfinished Rime synchronization must be recovered");
        }
        db.beginTransaction();
        db.delete("staged_baseline", null, null);
        db.delete("pending_operation", null, null);
        return new Stage(db, current.generation + 1L, current.hashSalt);
    }

    public synchronized List<PendingOperation> pendingOperations() {
        List<PendingOperation> result = new ArrayList<PendingOperation>();
        Cursor cursor = getReadableDatabase().query("pending_operation",
                new String[] {"code", "phrase", "google_action", "rime_action",
                        "rime_commit_value"}, null, null, null, null, "sequence");
        try {
            while (cursor.moveToNext()) {
                result.add(new PendingOperation(cursor.getString(0), cursor.getString(1),
                        RimeSyncPlanner.GoogleAction.valueOf(cursor.getString(2)),
                        RimeSyncPlanner.RimeAction.valueOf(cursor.getString(3)),
                        cursor.getInt(4)));
            }
        } finally {
            cursor.close();
        }
        return result;
    }

    /** Stores privacy-safe counts and a salted fingerprint for one Native verification failure. */
    public synchronized void recordNativePersistenceFailure(
            GoogleNativeDictionaryBridge.PersistenceVerificationException failure) {
        if (failure == null) throw new IllegalArgumentException("Native failure is required");
        Profile current = profile();
        if (current == null || current.phase != PHASE_PLANNED) {
            throw new IllegalStateException("Native failure requires a planned synchronization");
        }
        byte[] fingerprint = nativeFailureFingerprint(current.hashSalt, failure);
        boolean repeated = current.nativeFailureFingerprint != null
                && Arrays.equals(current.nativeFailureFingerprint, fingerprint);
        getWritableDatabase().execSQL("UPDATE profile SET native_expected_count=?, "
                        + "native_actual_count=?, native_missing_count=?, "
                        + "native_failure_fingerprint=?, native_failure_repeated=?, "
                        + "native_failure_kind=? WHERE id=?",
                new Object[] {failure.expectedNativeCount, failure.actualNativeCount,
                        failure.missingCount, fingerprint, repeated ? 1 : 0,
                        NATIVE_FAILURE_PERSISTENCE, PROFILE_ID});
    }

    /** Stores only a rejection count and salted set fingerprint, never dictionary text. */
    public synchronized void recordNativeRejectedEntriesFailure(
            GoogleNativeDictionaryBridge.RejectedEntriesException failure) {
        if (failure == null) throw new IllegalArgumentException("Native rejection is required");
        Profile current = profile();
        if (current == null || current.phase != PHASE_PLANNED) {
            throw new IllegalStateException("Native rejection requires a planned synchronization");
        }
        byte[] fingerprint = nativeRejectedFingerprint(current.hashSalt, failure.rejectedKeys);
        boolean repeated = current.nativeFailureKind ==
                GoogleNativeDictionaryBridge.FAILURE_INSERT
                && current.nativeFailureFingerprint != null
                && Arrays.equals(current.nativeFailureFingerprint, fingerprint);
        getWritableDatabase().execSQL("UPDATE profile SET native_expected_count=0, "
                        + "native_actual_count=0, native_missing_count=?, "
                        + "native_failure_fingerprint=?, native_failure_repeated=?, "
                        + "native_failure_kind=? WHERE id=?",
                new Object[] {failure.rejectedCount, fingerprint, repeated ? 1 : 0,
                        GoogleNativeDictionaryBridge.FAILURE_INSERT, PROFILE_ID});
    }

    /** Verifies that a fresh rejection probe matches the locked privacy-safe fingerprint. */
    public synchronized void verifyRecordedRejectedEntries(
            GoogleNativeDictionaryBridge.RejectedEntriesException failure) {
        if (failure == null) throw new IllegalArgumentException("Native rejection is required");
        Profile current = profile();
        byte[] fingerprint = current == null ? null
                : nativeRejectedFingerprint(current.hashSalt, failure.rejectedKeys);
        if (current == null || current.phase != PHASE_PLANNED
                || current.nativeFailureKind != GoogleNativeDictionaryBridge.FAILURE_INSERT
                || !current.nativeFailureRepeated
                || current.nativeMissingCount != failure.rejectedCount
                || current.nativeFailureFingerprint == null
                || !Arrays.equals(current.nativeFailureFingerprint, fingerprint)) {
            throw new IllegalStateException("Native rejected entry set changed");
        }
    }

    /** Stores only a generic Native failure category and bounded no-progress state. */
    public synchronized void recordNativeOperationFailure(int failureKind) {
        if (failureKind < NATIVE_FAILURE_IO
                || failureKind > GoogleNativeDictionaryBridge.FAILURE_STALE) {
            throw new IllegalArgumentException("Native failure kind is invalid");
        }
        Profile current = profile();
        if (current == null || current.phase != PHASE_PLANNED) {
            throw new IllegalStateException("Native failure requires a planned synchronization");
        }
        boolean repeated = current.nativeFailureKind == failureKind;
        getWritableDatabase().execSQL("UPDATE profile SET native_expected_count=0, "
                        + "native_actual_count=0, native_missing_count=0, "
                        + "native_failure_fingerprint=NULL, native_failure_repeated=?, "
                        + "native_failure_kind=? WHERE id=?",
                new Object[] {repeated ? 1 : 0, failureKind, PROFILE_ID});
    }

    public synchronized void markGoogleApplied() {
        requirePhase(PHASE_PLANNED);
        clearNativeFailureAndSetGoogleApplied(getWritableDatabase());
    }

    /** Marks a verified rejected set as Rime-only and advances the journal atomically. */
    public synchronized void markGoogleAppliedWithRimeOnly(
            GoogleNativeDictionaryBridge.RejectedEntriesException failure) {
        verifyRecordedRejectedEntries(failure);
        SQLiteDatabase db = getWritableDatabase();
        Profile current = readProfile(db);
        db.beginTransaction();
        try {
            ContentValues values = new ContentValues();
            values.put("google_projection", RimeSyncPlanner.GoogleProjection.RIME_ONLY.name());
            for (String key : failure.rejectedKeys) {
                byte[] hash = keyHash(current.hashSalt, key);
                int updated = db.update("staged_baseline", values,
                        "key_hash=X'" + hex(hash) + "'", null);
                if (updated != 1) {
                    throw new IllegalStateException("rejected entry is absent from staged baseline");
                }
            }
            clearNativeFailureAndSetGoogleApplied(db);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    private static void clearNativeFailureAndSetGoogleApplied(SQLiteDatabase db) {
        db.execSQL("UPDATE profile SET phase=?, "
                        + "native_expected_count=0, native_actual_count=0, "
                        + "native_missing_count=0, native_failure_fingerprint=NULL, "
                        + "native_failure_repeated=0, native_failure_kind=0 "
                        + "WHERE id=?",
                new Object[] {PHASE_GOOGLE_APPLIED, PROFILE_ID});
    }

    public synchronized void markSnapshotPublished() {
        requirePhase(PHASE_GOOGLE_APPLIED);
        setPhase(PHASE_SNAPSHOT_PUBLISHED);
    }

    public synchronized void commitStage(long generation, long completedAt) {
        requirePhase(PHASE_SNAPSHOT_PUBLISHED);
        Profile current = profile();
        if (current == null || generation != current.generation + 1L) {
            throw new IllegalArgumentException("Rime synchronization generation is invalid");
        }
        SQLiteDatabase db = getWritableDatabase();
        db.beginTransaction();
        try {
            db.delete("baseline", null, null);
            db.execSQL("INSERT INTO baseline(key_hash, history, google_projection, "
                    + "rime_abs_count) SELECT key_hash, history, google_projection, "
                    + "rime_abs_count FROM staged_baseline");
            db.delete("staged_baseline", null, null);
            db.delete("pending_operation", null, null);
            db.execSQL("UPDATE profile SET generation=?, phase=?, last_success=? WHERE id=?",
                    new Object[] {generation, PHASE_IDLE, completedAt, PROFILE_ID});
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    public synchronized void resetBaseline() {
        SQLiteDatabase db = getWritableDatabase();
        Profile current = readProfile(db);
        if (current == null) return;
        if (current.phase != PHASE_IDLE) {
            throw new IllegalStateException("unfinished Rime synchronization cannot be reset");
        }
        db.delete("baseline", null, null);
        db.execSQL("UPDATE profile SET generation=0, last_success=0 WHERE id=?",
                new Object[] {PROFILE_ID});
    }

    private void requirePhase(int expected) {
        Profile current = profile();
        if (current == null || current.phase != expected) {
            throw new IllegalStateException("unexpected Rime synchronization phase");
        }
    }

    private void setPhase(int phase) {
        getWritableDatabase().execSQL("UPDATE profile SET phase=? WHERE id=?",
                new Object[] {phase, PROFILE_ID});
    }

    private static void clearSyncData(SQLiteDatabase db) {
        db.delete("pending_operation", null, null);
        db.delete("staged_baseline", null, null);
        db.delete("baseline", null, null);
        db.delete("profile", null, null);
    }

    private static ContentValues profileValues(Profile profile) {
        ContentValues values = new ContentValues();
        values.put("id", PROFILE_ID);
        values.put("root_uri", profile.rootUri);
        values.put("device_dir", profile.deviceDirectoryName);
        values.put("snapshot_file", profile.snapshotFileName);
        values.put("bridge_user_id", profile.bridgeUserId);
        values.put("hash_salt", profile.hashSalt);
        values.put("protocol_version", profile.protocolVersion);
        values.put("generation", profile.generation);
        values.put("phase", profile.phase);
        values.put("last_success", profile.lastSuccess);
        values.put("native_expected_count", profile.nativeExpectedCount);
        values.put("native_actual_count", profile.nativeActualCount);
        values.put("native_missing_count", profile.nativeMissingCount);
        values.put("native_failure_fingerprint", profile.nativeFailureFingerprint);
        values.put("native_failure_repeated", profile.nativeFailureRepeated ? 1 : 0);
        values.put("native_failure_kind", profile.nativeFailureKind);
        return values;
    }

    private static Profile readProfile(SQLiteDatabase db) {
        Cursor cursor = db.query("profile", new String[] {"root_uri", "device_dir",
                "snapshot_file", "bridge_user_id", "hash_salt", "protocol_version",
                "generation", "phase", "last_success", "native_expected_count",
                "native_actual_count", "native_missing_count",
                "native_failure_fingerprint", "native_failure_repeated",
                "native_failure_kind"}, "id=?",
                new String[] {Integer.toString(PROFILE_ID)}, null, null, null);
        try {
            if (!cursor.moveToFirst()) return null;
            return new Profile(cursor.getString(0), cursor.getString(1), cursor.getString(2),
                    cursor.getString(3), cursor.getBlob(4), cursor.getInt(5), cursor.getLong(6),
                    cursor.getInt(7), cursor.getLong(8), cursor.getInt(9), cursor.getInt(10),
                    cursor.getInt(11), cursor.getBlob(12), cursor.getInt(13) != 0,
                    cursor.getInt(14));
        } finally {
            cursor.close();
        }
    }

    private static byte[] nativeRejectedFingerprint(byte[] salt, List<String> rejectedKeys) {
        List<String> digests = new ArrayList<String>();
        for (String key : rejectedKeys) {
            digests.add(hex(keyHash(salt, "rejected\u0000" + key)));
        }
        Collections.sort(digests);
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.update(Integer.toString(rejectedKeys.size()).getBytes(UTF_8));
            for (String item : digests) {
                digest.update((byte) 0);
                digest.update(item.getBytes(UTF_8));
            }
            return digest.digest();
        } catch (Exception unavailable) {
            throw new IllegalStateException("SHA-256 is unavailable", unavailable);
        }
    }

    private static byte[] nativeFailureFingerprint(byte[] salt,
            GoogleNativeDictionaryBridge.PersistenceVerificationException failure) {
        List<String> digests = new ArrayList<String>();
        for (String key : failure.missingKeys) {
            digests.add(hex(keyHash(salt, "missing\u0000" + key)));
        }
        for (String key : failure.unexpectedKeys) {
            digests.add(hex(keyHash(salt, "unexpected\u0000" + key)));
        }
        Collections.sort(digests);
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.update(Integer.toString(failure.expectedNativeCount).getBytes(UTF_8));
            digest.update((byte) 0);
            digest.update(Integer.toString(failure.actualNativeCount).getBytes(UTF_8));
            for (String item : digests) {
                digest.update((byte) 0);
                digest.update(item.getBytes(UTF_8));
            }
            return digest.digest();
        } catch (Exception unavailable) {
            throw new IllegalStateException("SHA-256 is unavailable", unavailable);
        }
    }

    private static byte[] keyHash(byte[] salt, String canonicalKey) {
        if (canonicalKey == null) throw new IllegalArgumentException("canonical key is required");
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.update(salt);
            return digest.digest(canonicalKey.getBytes(UTF_8));
        } catch (Exception failure) {
            throw new IllegalStateException("SHA-256 is unavailable", failure);
        }
    }

    private static void requireHash(byte[] value) {
        if (value == null || value.length != 32) {
            throw new IllegalArgumentException("Rime synchronization key hash is invalid");
        }
    }

    private static String hex(byte[] value) {
        requireHash(value);
        StringBuilder result = new StringBuilder(value.length * 2);
        for (byte item : value) result.append(String.format("%02X", item & 0xff));
        return result.toString();
    }

    private static int findHash(byte[] hashes, int count, byte[] target) {
        int low = 0;
        int high = count - 1;
        while (low <= high) {
            int middle = (low + high) >>> 1;
            int comparison = compareHash(hashes, middle * 32, target);
            if (comparison < 0) low = middle + 1;
            else if (comparison > 0) high = middle - 1;
            else return middle;
        }
        return -1;
    }

    private static int compareHash(byte[] hashes, int offset, byte[] target) {
        for (int index = 0; index < 32; index++) {
            int left = hashes[offset + index] & 0xff;
            int right = target[index] & 0xff;
            if (left != right) return left < right ? -1 : 1;
        }
        return 0;
    }

    public static final class Stage implements Closeable {
        private final SQLiteDatabase db;
        private final byte[] hashSalt;
        public final long generation;
        private boolean closed;

        Stage(SQLiteDatabase db, long generation, byte[] hashSalt) {
            this.db = db;
            this.generation = generation;
            this.hashSalt = hashSalt.clone();
        }

        public void putBaseline(String canonicalKey, RimeSyncPlanner.History history,
                RimeSyncPlanner.GoogleProjection googleProjection, int rimeAbsCount) {
            putBaseline(keyHash(hashSalt, canonicalKey), history,
                    googleProjection, rimeAbsCount);
        }

        public void putBaseline(byte[] hash, RimeSyncPlanner.History history,
                RimeSyncPlanner.GoogleProjection googleProjection, int rimeAbsCount) {
            ensureOpen();
            requireHash(hash);
            if (history == null || googleProjection == null || rimeAbsCount < 0) {
                throw new IllegalArgumentException("staged baseline is invalid");
            }
            ContentValues values = new ContentValues();
            values.put("key_hash", hash);
            values.put("history", history.name());
            values.put("google_projection", googleProjection.name());
            values.put("rime_abs_count", rimeAbsCount);
            db.insertWithOnConflict("staged_baseline", null, values,
                    SQLiteDatabase.CONFLICT_REPLACE);
        }

        public void putOperation(PendingOperation operation) {
            ensureOpen();
            if (operation == null) throw new IllegalArgumentException("operation is required");
            ContentValues values = new ContentValues();
            values.put("code", operation.code);
            values.put("phrase", operation.phrase);
            values.put("google_action", operation.googleAction.name());
            values.put("rime_action", operation.rimeAction.name());
            values.put("rime_commit_value", operation.rimeCommitValue);
            db.insertOrThrow("pending_operation", null, values);
        }

        public void finish() {
            ensureOpen();
            db.execSQL("UPDATE profile SET phase=? WHERE id=?",
                    new Object[] {PHASE_PLANNED, PROFILE_ID});
            db.setTransactionSuccessful();
            close();
        }

        @Override public void close() {
            if (closed) return;
            closed = true;
            db.endTransaction();
        }

        private void ensureOpen() {
            if (closed) throw new IllegalStateException("Rime synchronization stage is closed");
        }
    }

    public static final class Profile {
        public final String rootUri;
        public final String deviceDirectoryName;
        public final String snapshotFileName;
        public final String bridgeUserId;
        private final byte[] hashSalt;
        public final int protocolVersion;
        public final long generation;
        public final int phase;
        public final long lastSuccess;
        public final int nativeExpectedCount;
        public final int nativeActualCount;
        public final int nativeMissingCount;
        private final byte[] nativeFailureFingerprint;
        public final boolean nativeFailureRepeated;
        public final int nativeFailureKind;

        Profile(String rootUri, String deviceDirectoryName, String snapshotFileName,
                String bridgeUserId, byte[] hashSalt, int protocolVersion, long generation,
                int phase, long lastSuccess, int nativeExpectedCount, int nativeActualCount,
                int nativeMissingCount, byte[] nativeFailureFingerprint,
                boolean nativeFailureRepeated, int nativeFailureKind) {
            this.rootUri = rootUri;
            this.deviceDirectoryName = deviceDirectoryName;
            this.snapshotFileName = snapshotFileName;
            this.bridgeUserId = bridgeUserId;
            this.hashSalt = hashSalt.clone();
            this.protocolVersion = protocolVersion;
            this.generation = generation;
            this.phase = phase;
            this.lastSuccess = lastSuccess;
            this.nativeExpectedCount = nativeExpectedCount;
            this.nativeActualCount = nativeActualCount;
            this.nativeMissingCount = nativeMissingCount;
            this.nativeFailureFingerprint = nativeFailureFingerprint == null
                    ? null : nativeFailureFingerprint.clone();
            this.nativeFailureRepeated = nativeFailureRepeated;
            this.nativeFailureKind = nativeFailureKind;
        }
    }

    public static final class Baseline {
        public final RimeSyncPlanner.History history;
        public final RimeSyncPlanner.GoogleProjection googleProjection;
        public final int rimeAbsCount;

        Baseline(RimeSyncPlanner.History history,
                RimeSyncPlanner.GoogleProjection googleProjection, int rimeAbsCount) {
            this.history = history;
            this.googleProjection = googleProjection;
            this.rimeAbsCount = rimeAbsCount;
        }
    }

    public static final class PendingOperation {
        public final String code;
        public final String phrase;
        public final RimeSyncPlanner.GoogleAction googleAction;
        public final RimeSyncPlanner.RimeAction rimeAction;
        public final int rimeCommitValue;

        public PendingOperation(String code, String phrase,
                RimeSyncPlanner.GoogleAction googleAction,
                RimeSyncPlanner.RimeAction rimeAction, int rimeCommitValue) {
            if (code == null || phrase == null || googleAction == null || rimeAction == null) {
                throw new IllegalArgumentException("pending operation is invalid");
            }
            this.code = code;
            this.phrase = phrase;
            this.googleAction = googleAction;
            this.rimeAction = rimeAction;
            this.rimeCommitValue = rimeCommitValue;
        }
    }
}
