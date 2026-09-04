package com.google.android.inputmethod.pinyin.rimesync;

import android.content.Context;
import com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/** Manual synchronization coordinator with durable, resumable external-store phases. */
public final class RimeSyncCoordinator {
    public static final int PREVIEW_STAGE_SOURCE_LIST = 1;
    public static final int PREVIEW_STAGE_SOURCE_OPEN = 2;
    public static final int PREVIEW_STAGE_SOURCE_PARSE = 3;
    public static final int PREVIEW_STAGE_SOURCE_DATABASE = 4;
    public static final int PREVIEW_STAGE_SOURCE_CLOSE = 5;
    public static final int PREVIEW_STAGE_RIME_MERGE = 6;
    public static final int PREVIEW_STAGE_GOOGLE_EXPORT = 7;
    public static final int PREVIEW_STAGE_SESSION_PLAN = 8;

    private final Context context;
    private final AbstractHmmEngineFactory engineFactory;
    private final RimeSyncSafStore safStore;
    private final RimeSyncStateStore stateStore;
    private final RimeSyncConfiguration configuration;

    public RimeSyncCoordinator(Context context, AbstractHmmEngineFactory engineFactory,
            RimeSyncSafStore safStore, RimeSyncStateStore stateStore,
            RimeSyncConfiguration configuration) {
        if (context == null || engineFactory == null || safStore == null
                || stateStore == null || configuration == null) {
            throw new IllegalArgumentException("Rime synchronization coordinator is invalid");
        }
        this.context = context.getApplicationContext();
        this.engineFactory = engineFactory;
        this.safStore = safStore;
        this.stateStore = stateStore;
        this.configuration = configuration;
    }

    /** Builds an in-memory preview without changing SQLite, Google, or Rime. */
    public Preview preview() throws IOException {
        RimeSyncStateStore.Profile profile = requireProfile();
        if (profile.phase != RimeSyncStateStore.PHASE_IDLE) {
            throw new IllegalStateException(
                    "unfinished Rime synchronization must be recovered before preview");
        }
        Session session = buildSession(profile);
        return new Preview(session.plan);
    }

    /** Rebuilds and verifies the preview before creating the durable operation journal. */
    public Result execute(String confirmationToken, boolean deletionConfirmed)
            throws IOException {
        if (confirmationToken == null) {
            throw new IllegalArgumentException("Rime synchronization confirmation is required");
        }
        RimeSyncStateStore.Profile profile = requireProfile();
        if (profile.phase != RimeSyncStateStore.PHASE_IDLE) {
            throw new IllegalStateException(
                    "unfinished Rime synchronization must be recovered before execution");
        }
        Session session = buildSession(profile);
        if (!confirmationToken.equals(session.plan.confirmationToken)) {
            throw new PreviewChangedException();
        }
        if (session.plan.requiresDeletionConfirmation() && !deletionConfirmed) {
            throw new DeletionConfirmationException(
                    session.plan.googleDeletionCount, session.plan.rimeDeletionCount);
        }
        long generation = stage(session.plan);
        GoogleNativeDictionaryBridge.Result googleResult;
        try {
            googleResult = GoogleNativeDictionaryBridge.apply(
                    context, engineFactory, session.plan.googleChanges());
        } catch (GoogleNativeDictionaryBridge.PersistenceVerificationException failure) {
            stateStore.recordNativePersistenceFailure(failure);
            throw failure;
        } catch (GoogleNativeDictionaryBridge.RejectedEntriesException failure) {
            stateStore.recordNativeRejectedEntriesFailure(failure);
            throw failure;
        } catch (GoogleNativeDictionaryBridge.NativeOperationException failure) {
            stateStore.recordNativeOperationFailure(failure.failureKind);
            throw failure;
        } catch (IOException failure) {
            stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_IO);
            throw failure;
        } catch (OutOfMemoryError failure) {
            stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_MEMORY);
            throw failure;
        } catch (RuntimeException failure) {
            stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_RUNTIME);
            throw failure;
        }
        stateStore.markGoogleApplied();
        applyRimeChanges(session.snapshot, session.plan.rimeChanges());
        safStore.publish(session.snapshot, profile.bridgeUserId);
        stateStore.markSnapshotPublished();
        stateStore.commitStage(generation, System.currentTimeMillis());
        return new Result(generation, googleResult.addedCount, googleResult.deletedCount,
                session.plan.rimeAdditionCount, session.plan.rimeDeletionCount,
                session.plan.rimeResurrectionCount, false);
    }

    /** Completes a locked transaction while retaining one verified rejected set in Rime. */
    public Result recoverKeepingRejected() throws IOException {
        RimeSyncStateStore.Profile profile = requireProfile();
        if (profile.phase != RimeSyncStateStore.PHASE_PLANNED
                || profile.nativeFailureKind != GoogleNativeDictionaryBridge.FAILURE_INSERT
                || !profile.nativeFailureRepeated || profile.nativeMissingCount <= 0) {
            throw new IllegalStateException("Rime-only continuation is unavailable");
        }
        List<RimeSyncStateStore.PendingOperation> pending = stateStore.pendingOperations();
        List<GoogleNativeDictionaryBridge.Change> googleChanges =
                new ArrayList<GoogleNativeDictionaryBridge.Change>();
        for (RimeSyncStateStore.PendingOperation operation : pending) {
            if (operation.googleAction != RimeSyncPlanner.GoogleAction.NONE) {
                googleChanges.add(new GoogleNativeDictionaryBridge.Change(operation.code,
                        operation.phrase, operation.googleAction));
            }
        }
        GoogleNativeDictionaryBridge.RejectedEntriesException rejected = null;
        try {
            GoogleNativeDictionaryBridge.recover(context, engineFactory, googleChanges);
        } catch (GoogleNativeDictionaryBridge.RejectedEntriesException failure) {
            rejected = failure;
        } catch (GoogleNativeDictionaryBridge.PersistenceVerificationException failure) {
            stateStore.recordNativePersistenceFailure(failure);
            throw failure;
        } catch (GoogleNativeDictionaryBridge.NativeOperationException failure) {
            stateStore.recordNativeOperationFailure(failure.failureKind);
            throw failure;
        } catch (IOException failure) {
            stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_IO);
            throw failure;
        }
        if (rejected == null) {
            stateStore.markGoogleApplied();
            return recover();
        }
        stateStore.verifyRecordedRejectedEntries(rejected);
        try {
            GoogleNativeDictionaryBridge.recoverKeepingRejected(
                    context, engineFactory, googleChanges, rejected);
        } catch (GoogleNativeDictionaryBridge.PersistenceVerificationException failure) {
            stateStore.recordNativePersistenceFailure(failure);
            throw failure;
        } catch (GoogleNativeDictionaryBridge.NativeOperationException failure) {
            stateStore.recordNativeOperationFailure(failure.failureKind);
            throw failure;
        } catch (IOException failure) {
            stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_IO);
            throw failure;
        }
        stateStore.markGoogleAppliedWithRimeOnly(rejected);
        return recover();
    }

    /** Resumes any phase. PLANNED is converged idempotently because persistence may have finished. */
    public Result recover() throws IOException {
        RimeSyncStateStore.Profile profile = requireProfile();
        if (profile.phase == RimeSyncStateStore.PHASE_IDLE) {
            return new Result(profile.generation, 0, 0, 0, 0, 0, true);
        }
        if (profile.phase == RimeSyncStateStore.PHASE_PLANNED
                && profile.nativeFailureRepeated) {
            throw new PersistenceStalledException(profile.nativeMissingCount);
        }
        long generation = profile.generation + 1L;
        List<RimeSyncStateStore.PendingOperation> pending = stateStore.pendingOperations();
        int googleAdds = 0;
        int googleDeletes = 0;
        int rimeAdds = 0;
        int rimeDeletes = 0;
        int rimeResurrections = 0;
        if (profile.phase == RimeSyncStateStore.PHASE_PLANNED) {
            List<GoogleNativeDictionaryBridge.Change> googleChanges =
                    new ArrayList<GoogleNativeDictionaryBridge.Change>();
            for (RimeSyncStateStore.PendingOperation operation : pending) {
                if (operation.googleAction == RimeSyncPlanner.GoogleAction.NONE) continue;
                googleChanges.add(new GoogleNativeDictionaryBridge.Change(operation.code,
                        operation.phrase, operation.googleAction));
                if (operation.googleAction == RimeSyncPlanner.GoogleAction.ADD) googleAdds++;
                if (operation.googleAction == RimeSyncPlanner.GoogleAction.DELETE) googleDeletes++;
            }
            try {
                GoogleNativeDictionaryBridge.recover(
                        context, engineFactory, googleChanges);
            } catch (GoogleNativeDictionaryBridge.PersistenceVerificationException failure) {
                stateStore.recordNativePersistenceFailure(failure);
                throw failure;
            } catch (GoogleNativeDictionaryBridge.RejectedEntriesException failure) {
                stateStore.recordNativeRejectedEntriesFailure(failure);
                throw failure;
            } catch (GoogleNativeDictionaryBridge.NativeOperationException failure) {
                stateStore.recordNativeOperationFailure(failure.failureKind);
                throw failure;
            } catch (IOException failure) {
                stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_IO);
                throw failure;
            } catch (OutOfMemoryError failure) {
                stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_MEMORY);
                throw failure;
            } catch (RuntimeException failure) {
                stateStore.recordNativeOperationFailure(RimeSyncStateStore.NATIVE_FAILURE_RUNTIME);
                throw failure;
            }
            stateStore.markGoogleApplied();
            profile = requireProfile();
        }
        if (profile.phase == RimeSyncStateStore.PHASE_GOOGLE_APPLIED) {
            RimeUserDbSnapshot snapshot = loadMergedSnapshot(profile);
            List<RimeSyncCore.RimeChange> rimeChanges =
                    new ArrayList<RimeSyncCore.RimeChange>();
            for (RimeSyncStateStore.PendingOperation operation : pending) {
                if (operation.rimeAction == RimeSyncPlanner.RimeAction.NONE) continue;
                rimeChanges.add(new RimeSyncCore.RimeChange(operation.code,
                        operation.phrase, operation.rimeAction,
                        operation.rimeCommitValue));
                if (operation.rimeAction == RimeSyncPlanner.RimeAction.ADD) rimeAdds++;
                if (operation.rimeAction == RimeSyncPlanner.RimeAction.DELETE) rimeDeletes++;
                if (operation.rimeAction == RimeSyncPlanner.RimeAction.RESURRECT) {
                    rimeResurrections++;
                }
            }
            applyRimeChanges(snapshot, rimeChanges);
            safStore.publish(snapshot, profile.bridgeUserId);
            stateStore.markSnapshotPublished();
            profile = requireProfile();
        }
        if (profile.phase != RimeSyncStateStore.PHASE_SNAPSHOT_PUBLISHED) {
            throw new IllegalStateException("Rime synchronization recovery phase is invalid");
        }
        stateStore.commitStage(generation, System.currentTimeMillis());
        return new Result(generation, googleAdds, googleDeletes,
                rimeAdds, rimeDeletes, rimeResurrections, true);
    }

    private Session buildSession(RimeSyncStateStore.Profile profile) throws IOException {
        RimeUserDbSnapshot snapshot = loadMergedSnapshot(profile);
        GoogleNativeDictionaryBridge.Snapshot google;
        try {
            google = GoogleNativeDictionaryBridge.read(context, engineFactory);
        } catch (IOException failure) {
            throw new PreviewStageException(PREVIEW_STAGE_GOOGLE_EXPORT, failure);
        }
        RimeSyncSessionPlan plan;
        try {
            plan = RimeSyncSessionPlan.build(
                    RimeSyncCore.translationEntries(snapshot), google,
                    stateStore.baselineLookup());
        } catch (IOException failure) {
            throw new PreviewStageException(PREVIEW_STAGE_SESSION_PLAN, failure);
        }
        return new Session(snapshot, plan);
    }

    private RimeUserDbSnapshot loadMergedSnapshot(RimeSyncStateStore.Profile profile)
            throws IOException {
        List<RimeSyncSafStore.SnapshotDocument> documents;
        try {
            documents = safStore.listSnapshots();
        } catch (IOException failure) {
            throw new PreviewStageException(PREVIEW_STAGE_SOURCE_LIST, failure);
        }
        List<RimeSyncCore.DeviceSnapshot> devices =
                new ArrayList<RimeSyncCore.DeviceSnapshot>();
        for (RimeSyncSafStore.SnapshotDocument document : documents) {
            try {
                devices.add(new RimeSyncCore.DeviceSnapshot(document.deviceDirectoryName,
                        document.bridgeOwned, safStore.readSnapshot(document)));
            } catch (RimeSyncSafStore.SnapshotReadException failure) {
                int stage = PREVIEW_STAGE_SOURCE_CLOSE;
                if (failure.kind == RimeSyncSafStore.SNAPSHOT_READ_OPEN) {
                    stage = PREVIEW_STAGE_SOURCE_OPEN;
                } else if (failure.kind == RimeSyncSafStore.SNAPSHOT_READ_PARSE) {
                    stage = PREVIEW_STAGE_SOURCE_PARSE;
                } else if (failure.kind == RimeSyncSafStore.SNAPSHOT_READ_DATABASE) {
                    stage = PREVIEW_STAGE_SOURCE_DATABASE;
                }
                throw new PreviewStageException(stage, failure);
            } catch (IOException failure) {
                throw new PreviewStageException(PREVIEW_STAGE_SOURCE_CLOSE, failure);
            }
        }
        try {
            return RimeSyncCore.merge(devices, configuration, profile.bridgeUserId);
        } catch (IOException failure) {
            throw new PreviewStageException(PREVIEW_STAGE_RIME_MERGE, failure);
        }
    }

    private long stage(RimeSyncSessionPlan plan) {
        RimeSyncStateStore.Stage stage = stateStore.beginStage();
        boolean finished = false;
        try {
            for (RimeSyncSessionPlan.EntryPlan entry : plan.entries) {
                stage.putBaseline(entry.key, entry.nextHistory,
                        entry.nextGoogleProjection, entry.nextRimeAbsCount);
                if (entry.googleAction != RimeSyncPlanner.GoogleAction.NONE
                        || entry.rimeAction != RimeSyncPlanner.RimeAction.NONE) {
                    stage.putOperation(new RimeSyncStateStore.PendingOperation(
                            entry.code, entry.phrase, entry.googleAction,
                            entry.rimeAction, entry.rimeCommitValue));
                }
            }
            long generation = stage.generation;
            stage.finish();
            finished = true;
            return generation;
        } finally {
            if (!finished) stage.close();
        }
    }

    private static void applyRimeChanges(RimeUserDbSnapshot snapshot,
            List<RimeSyncCore.RimeChange> changes) throws IOException {
        for (RimeSyncCore.RimeChange change : changes) {
            RimeSyncCore.apply(snapshot, change);
        }
    }

    private RimeSyncStateStore.Profile requireProfile() {
        RimeSyncStateStore.Profile profile = stateStore.profile();
        if (profile == null
                || !profile.deviceDirectoryName.equals(configuration.deviceDirectoryName)
                || !profile.snapshotFileName.equals(configuration.snapshotFileName)) {
            throw new IllegalStateException("Rime synchronization profile does not match");
        }
        return profile;
    }

    private static final class Session {
        final RimeUserDbSnapshot snapshot;
        final RimeSyncSessionPlan plan;

        Session(RimeUserDbSnapshot snapshot, RimeSyncSessionPlan plan) {
            this.snapshot = snapshot;
            this.plan = plan;
        }
    }

    public static final class Preview {
        public final int googleAdditionCount;
        public final int googleDeletionCount;
        public final int rimeAdditionCount;
        public final int rimeDeletionCount;
        public final int rimeResurrectionCount;
        public final int projectedGoogleEntryCount;
        public final boolean requiresDeletionConfirmation;
        public final String confirmationToken;

        Preview(RimeSyncSessionPlan plan) {
            googleAdditionCount = plan.googleAdditionCount;
            googleDeletionCount = plan.googleDeletionCount;
            rimeAdditionCount = plan.rimeAdditionCount;
            rimeDeletionCount = plan.rimeDeletionCount;
            rimeResurrectionCount = plan.rimeResurrectionCount;
            projectedGoogleEntryCount = plan.projectedGoogleEntryCount;
            requiresDeletionConfirmation = plan.requiresDeletionConfirmation();
            confirmationToken = plan.confirmationToken;
        }
    }

    public static final class Result {
        public final long generation;
        public final int googleAdditionCount;
        public final int googleDeletionCount;
        public final int rimeAdditionCount;
        public final int rimeDeletionCount;
        public final int rimeResurrectionCount;
        public final boolean recovered;

        Result(long generation, int googleAdditionCount, int googleDeletionCount,
                int rimeAdditionCount, int rimeDeletionCount,
                int rimeResurrectionCount, boolean recovered) {
            this.generation = generation;
            this.googleAdditionCount = googleAdditionCount;
            this.googleDeletionCount = googleDeletionCount;
            this.rimeAdditionCount = rimeAdditionCount;
            this.rimeDeletionCount = rimeDeletionCount;
            this.rimeResurrectionCount = rimeResurrectionCount;
            this.recovered = recovered;
        }
    }

    public static final class PreviewStageException extends IOException {
        public final int stage;

        public PreviewStageException(int stage, IOException cause) {
            super("Rime synchronization preview failed", cause);
            this.stage = stage;
        }
    }

    public static final class PersistenceStalledException extends IOException {
        public final int missingCount;

        PersistenceStalledException(int missingCount) {
            super("Google user dictionary persistence did not converge");
            this.missingCount = missingCount;
        }
    }

    public static final class PreviewChangedException extends IOException {
        PreviewChangedException() {
            super("Rime synchronization preview changed");
        }
    }

    public static final class DeletionConfirmationException extends IOException {
        public final int googleDeletionCount;
        public final int rimeDeletionCount;

        DeletionConfirmationException(int googleDeletionCount, int rimeDeletionCount) {
            super("Rime synchronization deletion confirmation is required");
            this.googleDeletionCount = googleDeletionCount;
            this.rimeDeletionCount = rimeDeletionCount;
        }
    }
}
