package com.google.android.inputmethod.pinyin.rimesync;

import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

/** Reflection-friendly asynchronous settings boundary for manual Rime synchronization. */
public final class RimeSyncSettingsCompat {
    private static final String PREFERENCES = "rime_dictionary_sync_preferences";
    private static final String KEY_ROOT_URI = "rime_sync_root_uri";
    private static final String KEY_ROOT_LABEL = "rime_sync_root_label";
    private static final String KEY_DEVICE_DIRECTORY = "rime_sync_device_directory";
    private static final String KEY_SNAPSHOT_FILE = "rime_sync_snapshot_file";
    private static final String DEFAULT_SNAPSHOT_FILE = "pinyin_simp.userdb.txt";
    private static final int PROTOCOL_VERSION = 1;

    public static final int ERROR_NONE = 0;
    public static final int ERROR_CONFIGURATION_REQUIRED = 1;
    public static final int ERROR_LOCATION_UNAVAILABLE = 2;
    public static final int ERROR_OPERATION_IN_PROGRESS = 3;
    public static final int ERROR_PREVIEW_CHANGED = 4;
    public static final int ERROR_DELETION_CONFIRMATION_REQUIRED = 5;
    public static final int ERROR_CAPACITY_EXCEEDED = 6;
    public static final int ERROR_OPERATION_FAILED = 7;
    public static final int ERROR_NATIVE_PERSISTENCE = 8;
    public static final int ERROR_PREVIEW_SOURCE_LIST = 9;
    public static final int ERROR_PREVIEW_SOURCE_OPEN = 10;
    public static final int ERROR_PREVIEW_SOURCE_PARSE = 11;
    public static final int ERROR_PREVIEW_SOURCE_DATABASE = 12;
    public static final int ERROR_PREVIEW_SOURCE_CLOSE = 13;
    public static final int ERROR_PREVIEW_RIME_MERGE = 14;
    public static final int ERROR_PREVIEW_GOOGLE_EXPORT = 15;
    public static final int ERROR_PREVIEW_SESSION_PLAN = 16;

    public static final int NATIVE_FAILURE_NONE = RimeSyncStateStore.NATIVE_FAILURE_NONE;
    public static final int NATIVE_FAILURE_PERSISTENCE =
            RimeSyncStateStore.NATIVE_FAILURE_PERSISTENCE;
    public static final int NATIVE_FAILURE_IO = RimeSyncStateStore.NATIVE_FAILURE_IO;
    public static final int NATIVE_FAILURE_MEMORY = RimeSyncStateStore.NATIVE_FAILURE_MEMORY;
    public static final int NATIVE_FAILURE_RUNTIME = RimeSyncStateStore.NATIVE_FAILURE_RUNTIME;
    public static final int NATIVE_FAILURE_DUPLICATE =
            GoogleNativeDictionaryBridge.FAILURE_DUPLICATE;
    public static final int NATIVE_FAILURE_INSERT = GoogleNativeDictionaryBridge.FAILURE_INSERT;
    public static final int NATIVE_FAILURE_PERSIST = GoogleNativeDictionaryBridge.FAILURE_PERSIST;
    public static final int NATIVE_FAILURE_REBUILD = GoogleNativeDictionaryBridge.FAILURE_REBUILD;
    public static final int NATIVE_FAILURE_EXPORT = GoogleNativeDictionaryBridge.FAILURE_EXPORT;
    public static final int NATIVE_FAILURE_DATA = GoogleNativeDictionaryBridge.FAILURE_DATA;
    public static final int NATIVE_FAILURE_STALE = GoogleNativeDictionaryBridge.FAILURE_STALE;

    private static final ExecutorService IO = Executors.newSingleThreadExecutor();
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final AtomicBoolean BUSY = new AtomicBoolean();
    private static final java.util.concurrent.CopyOnWriteArraySet<StateListener> LISTENERS =
            new java.util.concurrent.CopyOnWriteArraySet<StateListener>();
    private static final Runnable STATE_CHANGED = new Runnable() {
        @Override public void run() {
            for (StateListener listener : LISTENERS) listener.onChanged();
        }
    };

    public interface StateListener { void onChanged(); }

    public static void addStateListener(StateListener listener) { LISTENERS.add(listener); }
    public static void removeStateListener(StateListener listener) { LISTENERS.remove(listener); }

    static synchronized void notifyStateChanged() {
        MAIN.removeCallbacks(STATE_CHANGED);
        MAIN.post(STATE_CHANGED);
    }

    private RimeSyncSettingsCompat() {}

    public interface Callback {
        void onFinished(Result result);
    }

    public static Settings read(Context source) {
        Context context = source.getApplicationContext();
        SharedPreferences preferences = preferences(context);
        String root = preferences.getString(KEY_ROOT_URI, "");
        String device = deviceName(preferences);
        String file = preferences.getString(KEY_SNAPSHOT_FILE, DEFAULT_SNAPSHOT_FILE);
        long lastSuccess = 0L;
        int phase = RimeSyncStateStore.PHASE_IDLE;
        int nativeExpectedCount = 0;
        int nativeActualCount = 0;
        int nativeMissingCount = 0;
        boolean nativeFailureRepeated = false;
        int nativeFailureKind = RimeSyncStateStore.NATIVE_FAILURE_NONE;
        RimeSyncStateStore store = new RimeSyncStateStore(context);
        try {
            RimeSyncStateStore.Profile profile = store.profile();
            if (profile != null) {
                lastSuccess = profile.lastSuccess;
                phase = profile.phase;
                nativeExpectedCount = profile.nativeExpectedCount;
                nativeActualCount = profile.nativeActualCount;
                nativeMissingCount = profile.nativeMissingCount;
                nativeFailureRepeated = profile.nativeFailureRepeated;
                nativeFailureKind = profile.nativeFailureKind;
            }
        } finally {
            store.close();
        }
        return new Settings(context, root, preferences.getString(KEY_ROOT_LABEL, ""),
                device, file, hasPersistedAccess(context, root), lastSuccess,
                phase, BUSY.get(), nativeExpectedCount, nativeActualCount,
                nativeMissingCount, nativeFailureRepeated, nativeFailureKind);
    }

    public static void readAsync(final Context source, final Callback callback) {
        final Context context = source.getApplicationContext();
        // Reading state does not begin a synchronization or emit another state change.
        IO.execute(new Runnable() {
            @Override public void run() {
                try {
                    RimeAutoSync.reconcile(context);
                    deliver(callback, Result.success(read(context)));
                } catch (RuntimeException failure) {
                    deliver(callback, Result.error(read(context), ERROR_OPERATION_FAILED));
                }
            }
        });
    }

    public static void configureAutomaticAsync(final Context source, final boolean enabled,
            final int intervalHours, final Callback callback) {
        RimeAutoSyncPolicy.intervalMillis(intervalHours);
        if (!enabled) {
            RimeAutoSync.configure(source, false, intervalHours);
            IO.execute(new Runnable() {
                @Override public void run() {
                    deliver(callback, Result.success(read(source)));
                }
            });
            return;
        }
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) {
                Settings settings = read(context);
                if (!settings.canEnableAutomatic) {
                    return Result.error(settings, ERROR_CONFIGURATION_REQUIRED);
                }
                if (!RimeAutoSync.configure(context, true, intervalHours)) {
                    return Result.error(read(context), ERROR_OPERATION_FAILED);
                }
                return Result.success(read(context));
            }
        });
    }

    public static void runAutomaticAsync(final Context source, final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) throws Exception {
                Settings settings = read(context);
                if (!settings.automatic.enabled) return Result.success(settings);
                if (settings.nativeFailureKind != NATIVE_FAILURE_NONE) {
                    return Result.error(settings, ERROR_NATIVE_PERSISTENCE);
                }
                CoordinatorHandle handle = coordinator(context);
                try {
                    if (settings.phase != RimeSyncStateStore.PHASE_IDLE) {
                        RimeSyncCoordinator.Result recovered = handle.coordinator.recover();
                        return Result.completed(read(context), recovered);
                    }
                    RimeSyncCoordinator.Preview preview = handle.coordinator.preview();
                    if (!RimeAutoSync.read(context).enabled) return Result.success(read(context));
                    RimeSyncCoordinator.Result result = handle.coordinator.execute(
                            preview.confirmationToken, true);
                    return Result.completed(read(context), result);
                } finally {
                    handle.close();
                }
            }
        });
    }

    public static void saveConfigurationAsync(final Context source,
            final String deviceDirectory, final String snapshotFile,
            final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) throws Exception {
                RimeSyncConfiguration configuration =
                        new RimeSyncConfiguration(deviceDirectory, snapshotFile);
                SharedPreferences preferences = preferences(context);
                String root = preferences.getString(KEY_ROOT_URI, "");
                RimeSyncStateStore store = new RimeSyncStateStore(context);
                try {
                    if (root.length() > 0) {
                        try {
                            RimeSyncSafStore saf = new RimeSyncSafStore(
                                    context, Uri.parse(root), configuration);
                            configureState(store, root, configuration, saf);
                        } catch (java.io.IOException failure) {
                            throw new LocationException(failure);
                        }
                    }
                    if (!configuration.deviceDirectoryName.equals(deviceName(preferences))
                            || !configuration.snapshotFileName.equals(
                                    preferences.getString(KEY_SNAPSHOT_FILE, DEFAULT_SNAPSHOT_FILE))) {
                        RimeAutoSync.configure(context, false,
                                RimeAutoSync.read(context).intervalHours);
                    }
                    preferences.edit()
                            .putString(KEY_DEVICE_DIRECTORY,
                                    configuration.deviceDirectoryName)
                            .putString(KEY_SNAPSHOT_FILE,
                                    configuration.snapshotFileName)
                            .apply();
                } finally {
                    store.close();
                }
                return Result.success(read(context));
            }
        });
    }

    public static void acceptRootAsync(final Context source, final Uri root,
            final String label, final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) throws Exception {
                RimeSyncConfiguration configuration = configuration(context);
                RimeSyncSafStore saf;
                try {
                    saf = new RimeSyncSafStore(context, root, configuration);
                    saf.listSnapshots();
                } catch (java.io.IOException failure) {
                    throw new LocationException(failure);
                }
                RimeSyncStateStore store = new RimeSyncStateStore(context);
                try {
                    configureState(store, root.toString(), configuration, saf);
                } catch (java.io.IOException failure) {
                    throw new LocationException(failure);
                } finally {
                    store.close();
                }
                if (!root.toString().equals(preferences(context).getString(KEY_ROOT_URI, ""))) {
                    RimeAutoSync.configure(context, false,
                            RimeAutoSync.read(context).intervalHours);
                }
                preferences(context).edit()
                        .putString(KEY_ROOT_URI, root.toString())
                        .putString(KEY_ROOT_LABEL, label == null ? "" : label)
                        .apply();
                return Result.success(read(context));
            }
        });
    }

    public static void previewAsync(final Context source, final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) throws Exception {
                CoordinatorHandle handle = coordinator(context);
                try {
                    RimeSyncCoordinator.Preview preview = handle.coordinator.preview();
                    return Result.preview(read(context), preview);
                } finally {
                    handle.close();
                }
            }
        });
    }

    public static void executeAsync(final Context source, final String confirmationToken,
            final boolean deletionConfirmed, final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) throws Exception {
                CoordinatorHandle handle = coordinator(context);
                try {
                    RimeSyncCoordinator.Result result = handle.coordinator.execute(
                            confirmationToken, deletionConfirmed);
                    return Result.completed(read(context), result);
                } finally {
                    handle.close();
                }
            }
        });
    }

    public static void recoverAsync(final Context source, final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) throws Exception {
                CoordinatorHandle handle = coordinator(context);
                try {
                    RimeSyncCoordinator.Result result = handle.coordinator.recover();
                    return Result.completed(read(context), result);
                } finally {
                    handle.close();
                }
            }
        });
    }

    public static void recoverKeepingRejectedAsync(
            final Context source, final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) throws Exception {
                CoordinatorHandle handle = coordinator(context);
                try {
                    RimeSyncCoordinator.Result result =
                            handle.coordinator.recoverKeepingRejected();
                    return Result.completed(read(context), result);
                } finally {
                    handle.close();
                }
            }
        });
    }

    public static void resetBaselineAsync(final Context source, final Callback callback) {
        submit(source, callback, new Operation() {
            @Override public Result run(Context context) {
                RimeSyncStateStore store = new RimeSyncStateStore(context);
                try {
                    RimeAutoSync.configure(context, false,
                            RimeAutoSync.read(context).intervalHours);
                    store.resetBaseline();
                } finally {
                    store.close();
                }
                return Result.success(read(context));
            }
        });
    }

    private static void submit(Context source, final Callback callback,
            final Operation operation) {
        if (source == null || callback == null || operation == null) {
            throw new IllegalArgumentException("Rime synchronization callback is required");
        }
        final Context context = source.getApplicationContext();
        if (!BUSY.compareAndSet(false, true)) {
            IO.execute(new Runnable() {
                @Override public void run() {
                    deliver(callback, Result.error(read(context), ERROR_OPERATION_IN_PROGRESS));
                }
            });
            return;
        }
        IO.execute(new Runnable() {
            @Override public void run() {
                Result result;
                try {
                    result = operation.run(context);
                } catch (RimeSyncCoordinator.PreviewStageException failure) {
                    result = Result.error(read(context), previewError(failure.stage));
                } catch (RimeSyncCoordinator.DeletionConfirmationException failure) {
                    result = Result.error(read(context),
                            ERROR_DELETION_CONFIRMATION_REQUIRED);
                } catch (RimeSyncCoordinator.PreviewChangedException failure) {
                    result = Result.error(read(context), ERROR_PREVIEW_CHANGED);
                } catch (GoogleNativeDictionaryBridge.CapacityException failure) {
                    result = Result.error(read(context), ERROR_CAPACITY_EXCEEDED);
                } catch (GoogleNativeDictionaryBridge.RejectedEntriesException failure) {
                    result = Result.error(read(context), ERROR_NATIVE_PERSISTENCE);
                } catch (GoogleNativeDictionaryBridge.PersistenceVerificationException failure) {
                    result = Result.error(read(context), ERROR_NATIVE_PERSISTENCE);
                } catch (RimeSyncCoordinator.PersistenceStalledException failure) {
                    result = Result.error(read(context), ERROR_NATIVE_PERSISTENCE);
                } catch (IllegalArgumentException failure) {
                    result = Result.error(read(context), ERROR_CONFIGURATION_REQUIRED);
                } catch (IllegalStateException failure) {
                    result = Result.error(read(context), ERROR_OPERATION_IN_PROGRESS);
                } catch (LocationException failure) {
                    result = Result.error(read(context), ERROR_LOCATION_UNAVAILABLE);
                } catch (java.io.IOException failure) {
                    result = Result.error(read(context), ERROR_OPERATION_FAILED);
                } catch (Throwable failure) {
                    result = Result.error(read(context), ERROR_OPERATION_FAILED);
                }
                BUSY.set(false);
                notifyStateChanged();
                deliver(callback, result.withSettings(read(context)));
            }
        });
    }

    private static int previewError(int stage) {
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_SOURCE_LIST) {
            return ERROR_PREVIEW_SOURCE_LIST;
        }
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_SOURCE_OPEN) {
            return ERROR_PREVIEW_SOURCE_OPEN;
        }
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_SOURCE_PARSE) {
            return ERROR_PREVIEW_SOURCE_PARSE;
        }
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_SOURCE_DATABASE) {
            return ERROR_PREVIEW_SOURCE_DATABASE;
        }
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_SOURCE_CLOSE) {
            return ERROR_PREVIEW_SOURCE_CLOSE;
        }
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_RIME_MERGE) {
            return ERROR_PREVIEW_RIME_MERGE;
        }
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_GOOGLE_EXPORT) {
            return ERROR_PREVIEW_GOOGLE_EXPORT;
        }
        if (stage == RimeSyncCoordinator.PREVIEW_STAGE_SESSION_PLAN) {
            return ERROR_PREVIEW_SESSION_PLAN;
        }
        return ERROR_OPERATION_FAILED;
    }

    private static void deliver(final Callback callback, final Result result) {
        MAIN.post(new Runnable() {
            @Override public void run() {
                callback.onFinished(result);
            }
        });
    }

    private static CoordinatorHandle coordinator(Context context) throws Exception {
        SharedPreferences preferences = preferences(context);
        String rootValue = preferences.getString(KEY_ROOT_URI, "");
        if (rootValue.length() == 0) {
            throw new IllegalArgumentException("Rime synchronization root is required");
        }
        RimeSyncConfiguration configuration = configuration(context);
        Uri root = Uri.parse(rootValue);
        RimeSyncStateStore state = new RimeSyncStateStore(context);
        try {
            RimeSyncSafStore saf;
            try {
                saf = new RimeSyncSafStore(context, root, configuration);
            } catch (java.io.IOException failure) {
                throw new LocationException(failure);
            }
            configureState(state, rootValue, configuration, saf);
            AbstractHmmEngineFactory factory = RimeSyncEngineFactoryProvider.get(context);
            return new CoordinatorHandle(state, new RimeSyncCoordinator(
                    context, factory, saf, state, configuration));
        } catch (Exception failure) {
            state.close();
            throw failure;
        }
    }

    private static RimeSyncStateStore.Profile configureState(RimeSyncStateStore state,
            String root, RimeSyncConfiguration configuration, RimeSyncSafStore saf)
            throws java.io.IOException {
        String recoveredBridgeUserId = state.profile() == null
                ? saf.recoverBridgeUserId() : null;
        return state.configure(root, configuration, PROTOCOL_VERSION,
                recoveredBridgeUserId);
    }

    private static RimeSyncConfiguration configuration(Context context) {
        SharedPreferences preferences = preferences(context);
        return new RimeSyncConfiguration(
                deviceName(preferences),
                preferences.getString(KEY_SNAPSHOT_FILE, DEFAULT_SNAPSHOT_FILE));
    }

    private static String deviceName(SharedPreferences preferences) {
        if (preferences.contains(KEY_DEVICE_DIRECTORY)) {
            return preferences.getString(KEY_DEVICE_DIRECTORY, "");
        }
        return RimeSyncConfiguration.defaultDeviceName(Build.MODEL);
    }

    private static SharedPreferences preferences(Context context) {
        return context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE);
    }

    private static boolean hasPersistedAccess(Context context, String value) {
        if (value == null || value.length() == 0) return false;
        Uri expected;
        try {
            expected = Uri.parse(value);
            for (android.content.UriPermission permission
                    : context.getContentResolver().getPersistedUriPermissions()) {
                if (expected.equals(permission.getUri()) && permission.isReadPermission()
                        && permission.isWritePermission()) return true;
            }
        } catch (RuntimeException ignored) {
        }
        return false;
    }

    private interface Operation {
        Result run(Context context) throws Exception;
    }

    private static final class LocationException extends Exception {
        LocationException(Throwable cause) {
            super(cause);
        }
    }

    private static final class CoordinatorHandle {
        final RimeSyncStateStore stateStore;
        final RimeSyncCoordinator coordinator;

        CoordinatorHandle(RimeSyncStateStore stateStore, RimeSyncCoordinator coordinator) {
            this.stateStore = stateStore;
            this.coordinator = coordinator;
        }

        void close() {
            stateStore.close();
        }
    }

    public static final class Settings {
        public final RimeAutoSync.Settings automatic;
        public final boolean canEnableAutomatic;
        public final String rootUri;
        public final String rootLabel;
        public final String deviceDirectory;
        public final String snapshotFile;
        public final boolean locationAccessible;
        public final long lastSuccess;
        public final int phase;
        public final boolean operationInProgress;
        public final int nativeExpectedCount;
        public final int nativeActualCount;
        public final int nativeMissingCount;
        public final boolean nativeFailureRepeated;
        public final int nativeFailureKind;

        Settings(Context context, String rootUri, String rootLabel, String deviceDirectory,
                String snapshotFile, boolean locationAccessible, long lastSuccess,
                int phase, boolean operationInProgress, int nativeExpectedCount,
                int nativeActualCount, int nativeMissingCount, boolean nativeFailureRepeated,
                int nativeFailureKind) {
            this.automatic = RimeAutoSync.read(context);
            this.canEnableAutomatic = locationAccessible && lastSuccess > 0L
                    && phase == RimeSyncStateStore.PHASE_IDLE;
            this.rootUri = rootUri;
            this.rootLabel = rootLabel;
            this.deviceDirectory = deviceDirectory;
            this.snapshotFile = snapshotFile;
            this.locationAccessible = locationAccessible;
            this.lastSuccess = lastSuccess;
            this.phase = phase;
            this.operationInProgress = operationInProgress;
            this.nativeExpectedCount = nativeExpectedCount;
            this.nativeActualCount = nativeActualCount;
            this.nativeMissingCount = nativeMissingCount;
            this.nativeFailureRepeated = nativeFailureRepeated;
            this.nativeFailureKind = nativeFailureKind;
        }
    }

    public static final class Result {
        public final Settings settings;
        public final boolean success;
        public final int errorCode;
        public final boolean preview;
        public final String confirmationToken;
        public final int googleAdditionCount;
        public final int googleDeletionCount;
        public final int rimeAdditionCount;
        public final int rimeDeletionCount;
        public final int rimeResurrectionCount;
        public final int projectedGoogleEntryCount;
        public final boolean requiresDeletionConfirmation;

        private Result(Settings settings, boolean success, int errorCode, boolean preview,
                String confirmationToken, int googleAdditionCount, int googleDeletionCount,
                int rimeAdditionCount, int rimeDeletionCount, int rimeResurrectionCount,
                int projectedGoogleEntryCount, boolean requiresDeletionConfirmation) {
            this.settings = settings;
            this.success = success;
            this.errorCode = errorCode;
            this.preview = preview;
            this.confirmationToken = confirmationToken;
            this.googleAdditionCount = googleAdditionCount;
            this.googleDeletionCount = googleDeletionCount;
            this.rimeAdditionCount = rimeAdditionCount;
            this.rimeDeletionCount = rimeDeletionCount;
            this.rimeResurrectionCount = rimeResurrectionCount;
            this.projectedGoogleEntryCount = projectedGoogleEntryCount;
            this.requiresDeletionConfirmation = requiresDeletionConfirmation;
        }

        static Result success(Settings settings) {
            return new Result(settings, true, ERROR_NONE, false, "",
                    0, 0, 0, 0, 0, 0, false);
        }

        static Result error(Settings settings, int errorCode) {
            return new Result(settings, false, errorCode, false, "",
                    0, 0, 0, 0, 0, 0, false);
        }

        static Result preview(Settings settings, RimeSyncCoordinator.Preview preview) {
            return new Result(settings, true, ERROR_NONE, true, preview.confirmationToken,
                    preview.googleAdditionCount, preview.googleDeletionCount,
                    preview.rimeAdditionCount, preview.rimeDeletionCount,
                    preview.rimeResurrectionCount, preview.projectedGoogleEntryCount,
                    preview.requiresDeletionConfirmation);
        }

        static Result completed(Settings settings, RimeSyncCoordinator.Result result) {
            return new Result(settings, true, ERROR_NONE, false, "",
                    result.googleAdditionCount, result.googleDeletionCount,
                    result.rimeAdditionCount, result.rimeDeletionCount,
                    result.rimeResurrectionCount, 0, false);
        }

        Result withSettings(Settings replacement) {
            return new Result(replacement, success, errorCode, preview,
                    confirmationToken, googleAdditionCount, googleDeletionCount,
                    rimeAdditionCount, rimeDeletionCount, rimeResurrectionCount,
                    projectedGoogleEntryCount, requiresDeletionConfirmation);
        }
    }
}
