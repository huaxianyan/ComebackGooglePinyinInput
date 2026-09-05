#!/usr/bin/env python3
"""Compile and exercise the Rime snapshot and synchronization protocol APIs."""

from __future__ import annotations

import argparse
from pathlib import Path
import shutil
import subprocess

from rime_sync_build_support import write_stubs

ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "patches/java/com/google/android/inputmethod/pinyin/rimesync"
SOURCES = [
    SOURCE_DIR / "RimeUserDbSnapshot.java",
    SOURCE_DIR / "RimeSyncPlanner.java",
    SOURCE_DIR / "RimeSyncConfiguration.java",
    SOURCE_DIR / "RimeSyncCore.java",
]
ANDROID_SOURCES = [
    SOURCE_DIR / "RimeSyncStateStore.java",
    SOURCE_DIR / "RimeSyncSafStore.java",
]
NATIVE_BRIDGE_SOURCE = SOURCE_DIR / "GoogleNativeDictionaryBridge.java"
SESSION_PLAN_SOURCE = SOURCE_DIR / "RimeSyncSessionPlan.java"
COORDINATOR_SOURCE = SOURCE_DIR / "RimeSyncCoordinator.java"
SETTINGS_SOURCE = SOURCE_DIR / "RimeSyncSettingsCompat.java"

TEST_SOURCE = r'''
import android.content.Context;
import com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory;
import com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface;
import com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface.Entry;
import com.google.android.inputmethod.pinyin.rimesync.GoogleNativeDictionaryBridge;
import com.google.android.inputmethod.pinyin.rimesync.RimeSyncConfiguration;
import com.google.android.inputmethod.pinyin.rimesync.RimeSyncCore;
import com.google.android.inputmethod.pinyin.rimesync.RimeSyncPlanner;
import com.google.android.inputmethod.pinyin.rimesync.RimeSyncSessionPlan;
import com.google.android.inputmethod.pinyin.rimesync.RimeUserDbSnapshot;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public final class RimeUserDbSnapshotTest {
  private static RimeUserDbSnapshot read(String body) throws Exception {
    return RimeUserDbSnapshot.read(new StringReader(body));
  }

  private static void require(boolean condition, String message) {
    if (!condition) throw new AssertionError(message);
  }

  private static MutableDictionaryAccessorInterface.Entry nativeEntry(
      String[] tokens, String phrase, int count) {
    int[] languageIds = new int[tokens.length];
    Arrays.fill(languageIds, 16);
    return new MutableDictionaryAccessorInterface.Entry(
        tokens, languageIds, phrase, count, false, true, 0);
  }

  private static final class FakeContext extends Context {}

  private static final class FakeFactory extends AbstractHmmEngineFactory {
    final FakeDictionary dictionary;
    int notifications;

    FakeFactory(List<MutableDictionaryAccessorInterface.Entry> entries, int reportedCount) {
      dictionary = new FakeDictionary(entries, reportedCount);
    }

    @Override public MutableDictionaryAccessorInterface createMutableDictionaryAccessor(
        MutableDictionaryType type) {
      return dictionary;
    }

    @Override public void notifyMutableDictionaryDataChanged(MutableDictionaryType type) {
      notifications++;
    }
  }

  private static final class FakeDictionary implements MutableDictionaryAccessorInterface {
    List<Entry> durable;
    List<Entry> staged;
    final int reportedCount;
    boolean failInsert;
    int insertAttempts;
    boolean dropLastOnPersist;
    boolean persisted;

    FakeDictionary(List<Entry> entries, int reportedCount) {
      durable = new ArrayList<Entry>(entries);
      this.reportedCount = reportedCount;
    }

    @Override public boolean duplicateDictionary() {
      staged = new ArrayList<Entry>(durable);
      persisted = false;
      return true;
    }

    @Override public boolean clear() {
      staged.clear();
      return true;
    }

    @Override public Entry[] exportAllEntries() {
      List<Entry> source = staged == null ? durable : staged;
      return source.toArray(new Entry[source.size()]);
    }

    @Override public int getDictionaryCount() {
      return Math.max(reportedCount, exportAllEntries().length);
    }

    @Override public boolean insertOrUpdate(String[] tokens, int[] languageIds, String value,
        int count, boolean isModified, boolean isNormalizedToken) {
      insertAttempts++;
      if (failInsert) return false;
      staged.add(new Entry(tokens, languageIds, value, count,
          isModified, isNormalizedToken, 0));
      return true;
    }

    @Override public boolean remove(String[] tokens, int[] languageIds, String value) {
      return false;
    }

    @Override public boolean persist(String path) {
      durable = new ArrayList<Entry>(staged);
      if (dropLastOnPersist && !durable.isEmpty()) {
        durable.remove(durable.size() - 1);
      }
      persisted = true;
      return true;
    }

    @Override public void close() {
      if (!persisted) staged = null;
    }
  }

  public static void main(String[] args) throws Exception {
    String own = "# Rime user dictionary\n"
        + "#@/db_name\tpinyin_simp\n"
        + "#@/db_type\tuserdb\n"
        + "#@/rime_version\t1.0\n"
        + "#@/tick\t100\n"
        + "#@/user_id\tbridge\n"
        + "ce shi\tfixture-alpha\tc=8 d=4.0 t=80\n"
        + "ping ju\tfixture-beta\tc=5 d=2.0 t=100\n";
    String peer = "# Rime user dictionary\n"
        + "#@/db_name\tpinyin_simp\n"
        + "#@/db_type\tuserdb\n"
        + "#@/rime_version\t1.0\n"
        + "#@/tick\t120\n"
        + "#@/user_id\tpeer\n"
        + "ce shi \tfixture-alpha\tc=7 d=6.0 t=120\n"
        + "ping ju \tfixture-beta\tc=-5 d=1.0 t=120\n"
        + "xin ci \tfixture-gamma\tc=3 d=1.5 t=120\n";

    RimeUserDbSnapshot merged = read(own);
    require(merged.entries().containsKey("ce shi \tfixture-alpha"),
        "parser must normalize the trailing code separator");
    merged.mergeFrom(read(peer), true);

    RimeUserDbSnapshot.Entry alpha = merged.entries().get("ce shi \tfixture-alpha");
    require(alpha.commits == 8, "larger absolute commit count must win");
    require(Math.abs(alpha.dee - 6.0) < 0.0000001,
        "dynamic strength must decay on each source timeline and keep the maximum");
    require(alpha.tick == 120, "merged entries must advance to the maximum tick");

    RimeUserDbSnapshot.Entry beta = merged.entries().get("ping ju \tfixture-beta");
    require(beta.commits == -5, "a tombstone must win an equal-magnitude tie");
    require(merged.entries().get("xin ci \tfixture-gamma").commits == 3,
        "a peer-only phrase must be added");

    StringWriter output = new StringWriter();
    merged.write(output);
    RimeUserDbSnapshot roundTrip = read(output.toString());
    require(roundTrip.tick() == 120, "writer must preserve the merged tick");
    require(roundTrip.entries().size() == 3, "writer must preserve every merged entry");
    require(roundTrip.entries().get("ping ju \tfixture-beta").commits == -5,
        "writer must preserve tombstones");

    RimeSyncConfiguration configuration = new RimeSyncConfiguration(
        "bridge-device", "pinyin_simp.userdb.txt");
    String recoverableBridge = own
        .replace("#@/rime_version\t1.0", "#@/rime_version\tgoogle-pinyin-bridge")
        .replace("#@/user_id\tbridge",
            "#@/user_id\t123e4567-e89b-12d3-a456-426614174000");
    require("123e4567-e89b-12d3-a456-426614174000".equals(
            RimeSyncCore.recoverBridgeUserId(read(recoverableBridge))),
        "a new Profile must recover the stable identity from its existing Bridge snapshot");
    boolean foreignBridgeRejected = false;
    try {
      RimeSyncCore.recoverBridgeUserId(read(own));
    } catch (java.io.IOException expected) {
      foreignBridgeRejected = true;
    }
    require(foreignBridgeRejected,
        "a snapshot without the Google Pinyin Bridge marker must not supply Profile identity");
    boolean malformedBridgeIdentityRejected = false;
    try {
      RimeSyncCore.recoverBridgeUserId(read(recoverableBridge.replace(
          "123e4567-e89b-12d3-a456-426614174000", "not-a-uuid")));
    } catch (java.io.IOException expected) {
      malformedBridgeIdentityRejected = true;
    }
    require(malformedBridgeIdentityRejected,
        "a malformed Bridge identity must not be adopted after local state loss");

    RimeUserDbSnapshot bridgeMerged = RimeSyncCore.merge(Arrays.asList(
        new RimeSyncCore.DeviceSnapshot("Bridge-Device", true, read(own)),
        new RimeSyncCore.DeviceSnapshot("Peer-Device", false, read(peer))),
        configuration, "bridge");
    require(bridgeMerged.tick() == 120 && bridgeMerged.entries().size() == 3,
        "Bridge must merge its own state with every peer snapshot");
    RimeUserDbSnapshot previewSnapshot = RimeSyncCore.merge(Arrays.asList(
        new RimeSyncCore.DeviceSnapshot("Peer-Device", false, read(peer))),
        configuration, "bridge");
    java.lang.reflect.Method previewTranslation = RimeSyncCore.class.getDeclaredMethod(
        "translationEntriesForPreview", RimeUserDbSnapshot.class);
    previewTranslation.setAccessible(true);
    Map<String, RimeSyncCore.CanonicalEntry> previewEntries =
        (Map<String, RimeSyncCore.CanonicalEntry>) previewTranslation.invoke(
            null, previewSnapshot);
    require(previewSnapshot.entries().isEmpty() && previewEntries.size() == 3
            && previewEntries.get("xin ci\tfixture-gamma").commits == 3,
        "preview translation must consume its temporary snapshot and retain commit state");
    bridgeMerged.put(new RimeUserDbSnapshot.Entry("dan", "X", 100, 9.0, 120));
    require(RimeSyncCore.translationEntries(bridgeMerged).size() == 3,
        "single-code-point entries must remain in the full snapshot but leave translation");
    RimeSyncCore.apply(bridgeMerged, new RimeSyncCore.RimeChange(
        "xin ci", "fixture-gamma", RimeSyncPlanner.RimeAction.DELETE, -4));
    require(bridgeMerged.entries().get("xin ci \tfixture-gamma").commits == -4,
        "Rime changes must update the Bridge full snapshot");

    RimeSyncPlanner.Plan initialRimeWord = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.UNKNOWN, RimeSyncPlanner.GoogleProjection.SUPPORTED, false,
        RimeSyncPlanner.RimeState.PRESENT, 12);
    require(initialRimeWord.googleAction == RimeSyncPlanner.GoogleAction.ADD,
        "an initial Rime-only phrase must be added to Google");

    RimeSyncPlanner.Plan initialGoogleWord = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.UNKNOWN, RimeSyncPlanner.GoogleProjection.SUPPORTED, true,
        RimeSyncPlanner.RimeState.ABSENT, 0);
    require(initialGoogleWord.rimeAction == RimeSyncPlanner.RimeAction.ADD,
        "an initial Google-only phrase must be added to Rime");

    RimeSyncPlanner.Plan rimeDeletion = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.PRESENT, RimeSyncPlanner.GoogleProjection.SUPPORTED, true,
        RimeSyncPlanner.RimeState.TOMBSTONE, -8);
    require(rimeDeletion.googleAction == RimeSyncPlanner.GoogleAction.DELETE,
        "a Rime tombstone must delete a previously synchronized Google phrase");

    RimeSyncPlanner.Plan googleDeletion = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.PRESENT, RimeSyncPlanner.GoogleProjection.SUPPORTED, false,
        RimeSyncPlanner.RimeState.PRESENT, 8);
    require(googleDeletion.rimeAction == RimeSyncPlanner.RimeAction.DELETE
            && googleDeletion.rimeCommitValue == -9,
        "a Google deletion must create a dominating Rime tombstone");

    RimeSyncPlanner.Plan googleResurrection = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.DELETED, RimeSyncPlanner.GoogleProjection.SUPPORTED, true,
        RimeSyncPlanner.RimeState.TOMBSTONE, -9);
    require(googleResurrection.rimeAction == RimeSyncPlanner.RimeAction.RESURRECT
            && googleResurrection.rimeCommitValue == 10,
        "a later Google addition must dominate and resurrect a Rime tombstone");

    RimeSyncPlanner.Plan rimeResurrection = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.DELETED, RimeSyncPlanner.GoogleProjection.SUPPORTED, false,
        RimeSyncPlanner.RimeState.PRESENT, 10);
    require(rimeResurrection.googleAction == RimeSyncPlanner.GoogleAction.ADD,
        "a later Rime addition must restore the phrase to Google");

    RimeSyncPlanner.Plan rimeOnlyPresent = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.PRESENT, RimeSyncPlanner.GoogleProjection.RIME_ONLY,
        false, RimeSyncPlanner.RimeState.PRESENT, 10);
    require(rimeOnlyPresent.googleAction == RimeSyncPlanner.GoogleAction.NONE
            && rimeOnlyPresent.nextGoogleProjection
                == RimeSyncPlanner.GoogleProjection.RIME_ONLY,
        "a Rime-only phrase must remain available without repeated Google insertion");
    RimeSyncPlanner.Plan rimeOnlyNowInGoogle = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.PRESENT, RimeSyncPlanner.GoogleProjection.RIME_ONLY,
        true, RimeSyncPlanner.RimeState.PRESENT, 10);
    require(rimeOnlyNowInGoogle.nextGoogleProjection
            == RimeSyncPlanner.GoogleProjection.SUPPORTED,
        "a Rime-only phrase found in Google must return to ordinary synchronization");
    RimeSyncPlanner.Plan deletedRimeOnly = RimeSyncPlanner.plan(
        RimeSyncPlanner.History.PRESENT, RimeSyncPlanner.GoogleProjection.RIME_ONLY,
        false, RimeSyncPlanner.RimeState.TOMBSTONE, 10);
    require(deletedRimeOnly.nextHistory == RimeSyncPlanner.History.DELETED
            && deletedRimeOnly.nextGoogleProjection
                == RimeSyncPlanner.GoogleProjection.SUPPORTED,
        "deleting a Rime-only phrase must allow a later explicit addition to retry Google");

    RimeSyncConfiguration validatedConfiguration = new RimeSyncConfiguration(
        "pixel_10_pro", "pinyin_simp.userdb.txt");
    require("pinyin_simp".equals(validatedConfiguration.databaseName),
        "a Weasel snapshot uses the dictionary name without .userdb.txt");
    RimeUserDbSnapshot standardPeer = read(peer);
    RimeSyncCore.normalizeSnapshotDatabase(standardPeer, validatedConfiguration, false);
    require("pinyin_simp".equals(standardPeer.dbName()),
        "a standard Weasel snapshot is accepted unchanged");
    RimeUserDbSnapshot legacyBridge = read(own);
    legacyBridge.putMetadata("db_name", "pinyin_simp.userdb");
    legacyBridge.putMetadata("rime_version", "google-pinyin-bridge");
    legacyBridge.putMetadata("user_id", "11111111-2222-3333-4444-555555555555");
    boolean foreignLegacyRejected = false;
    try {
      RimeSyncCore.normalizeSnapshotDatabase(legacyBridge, validatedConfiguration, false);
    } catch (java.io.IOException expected) {
      foreignLegacyRejected = true;
    }
    require(foreignLegacyRejected,
        "another device's mismatched database is not migrated by this Bridge");
    RimeSyncCore.normalizeSnapshotDatabase(legacyBridge, validatedConfiguration, true);
    require("pinyin_simp".equals(legacyBridge.dbName())
            && "11111111-2222-3333-4444-555555555555".equals(
                RimeSyncCore.recoverBridgeUserId(legacyBridge))
            && legacyBridge.entries().size() == 2 && legacyBridge.tick() == 100,
        "the old Bridge name migrates while identity, entries, and tick survive");
    RimeUserDbSnapshot ordinaryLegacy = read(own);
    ordinaryLegacy.putMetadata("db_name", "pinyin_simp.userdb");
    boolean unmarkedRejected = false;
    try {
      RimeSyncCore.normalizeSnapshotDatabase(ordinaryLegacy, validatedConfiguration, true);
    } catch (java.io.IOException expected) {
      unmarkedRejected = true;
    }
    require(unmarkedRejected,
        "an unmarked snapshot in the Bridge directory is not migrated");
    require("pixel_10_pro".equals(
            RimeSyncConfiguration.defaultDeviceName("Pixel 10 Pro")),
        "the default device name must normalize the Android model");
    require(RimeSyncConfiguration.isValidDeviceName("pixel_10-pro")
            && !RimeSyncConfiguration.isValidDeviceName("Pixel 10 Pro")
            && !RimeSyncConfiguration.isValidDeviceName("pixel.10"),
        "device names must use only lowercase letters, numbers, underscores, and hyphens");
    boolean unsafeRejected = false;
    try {
      new RimeSyncConfiguration("../peer", "pinyin_simp.userdb.txt");
    } catch (IllegalArgumentException expected) {
      unsafeRejected = true;
    }
    require(unsafeRejected, "a device directory must not escape the selected SAF root");

    List<MutableDictionaryAccessorInterface.Entry> nativeEntries =
        new ArrayList<MutableDictionaryAccessorInterface.Entry>();
    nativeEntries.add(nativeEntry(new String[] {"ce", "shi"}, "fixture-delta", 9));
    nativeEntries.add(nativeEntry(new String[] {"dan"}, "X", 100));
    FakeFactory nativeFactory = new FakeFactory(nativeEntries, nativeEntries.size());
    GoogleNativeDictionaryBridge.Snapshot nativeSnapshot =
        GoogleNativeDictionaryBridge.read(new FakeContext(), nativeFactory);
    require(nativeSnapshot.totalEntryCount == 2 && nativeSnapshot.entries.size() == 1,
        "native export must count every entry while translating only multi-character pinyin");
    require(nativeSnapshot.entries.containsKey("ce shi\tfixture-delta"),
        "native tokens and phrase must use the shared canonical key");

    List<GoogleNativeDictionaryBridge.Change> nativeChanges = Arrays.asList(
        new GoogleNativeDictionaryBridge.Change("ce shi", "fixture-delta",
            RimeSyncPlanner.GoogleAction.DELETE),
        new GoogleNativeDictionaryBridge.Change("xin ci", "fixture-epsilon",
            RimeSyncPlanner.GoogleAction.ADD));
    GoogleNativeDictionaryBridge.Result nativeResult = GoogleNativeDictionaryBridge.apply(
        new FakeContext(), nativeFactory, nativeChanges);
    require(nativeResult.addedCount == 1 && nativeResult.deletedCount == 1
            && nativeResult.persisted && nativeFactory.notifications == 1,
        "native changes must persist once and refresh the engine once");
    require(nativeFactory.dictionary.durable.size() == 2,
        "native deletion rebuild must preserve unrelated and untranslatable entries");
    GoogleNativeDictionaryBridge.Result recoveredNative =
        GoogleNativeDictionaryBridge.recover(new FakeContext(), nativeFactory, nativeChanges);
    require(!recoveredNative.persisted && nativeFactory.notifications == 1,
        "native recovery must accept already-applied operations without rewriting the dictionary");
    Entry inserted = nativeFactory.dictionary.durable.get(1);
    require(inserted.count == 1 && Arrays.equals(inserted.tokens,
            new String[] {"xin", "ci"}),
        "Rime words must enter Google with count one and normalized pinyin tokens");

    FakeFactory failingFactory = new FakeFactory(nativeFactory.dictionary.durable, 2);
    failingFactory.dictionary.failInsert = true;
    List<GoogleNativeDictionaryBridge.Change> rejectedChanges = Arrays.asList(
        new GoogleNativeDictionaryBridge.Change(
            "shi bai", "fixture-zeta", RimeSyncPlanner.GoogleAction.ADD),
        new GoogleNativeDictionaryBridge.Change(
            "ju jue", "fixture-theta", RimeSyncPlanner.GoogleAction.ADD));
    GoogleNativeDictionaryBridge.RejectedEntriesException rejectedEntries = null;
    try {
      GoogleNativeDictionaryBridge.apply(
          new FakeContext(), failingFactory, rejectedChanges);
    } catch (GoogleNativeDictionaryBridge.RejectedEntriesException expected) {
      rejectedEntries = expected;
    }
    require(rejectedEntries != null && rejectedEntries.rejectedCount == 2
            && failingFactory.dictionary.insertAttempts == 2
            && !failingFactory.dictionary.persisted
            && failingFactory.dictionary.durable.size() == 2
            && failingFactory.notifications == 0,
        "rejected native entries must all be counted without persistence or refresh");
    failingFactory.dictionary.failInsert = false;
    GoogleNativeDictionaryBridge.Result keptInRime =
        GoogleNativeDictionaryBridge.recoverKeepingRejected(
            new FakeContext(), failingFactory, rejectedChanges, rejectedEntries);
    require(!keptInRime.persisted && failingFactory.dictionary.durable.size() == 2
            && failingFactory.notifications == 0,
        "verified Rime-only entries must be skipped without changing the Google dictionary");

    FakeFactory lossyFactory = new FakeFactory(nativeFactory.dictionary.durable, 2);
    lossyFactory.dictionary.dropLastOnPersist = true;
    GoogleNativeDictionaryBridge.PersistenceVerificationException lossyFailure = null;
    try {
      GoogleNativeDictionaryBridge.apply(new FakeContext(), lossyFactory,
          Arrays.asList(new GoogleNativeDictionaryBridge.Change(
              "chi jiu", "fixture-persistence", RimeSyncPlanner.GoogleAction.ADD)));
    } catch (GoogleNativeDictionaryBridge.PersistenceVerificationException expected) {
      lossyFailure = expected;
    }
    require(lossyFailure != null && lossyFactory.notifications == 1
            && lossyFailure.expectedNativeCount == 3
            && lossyFailure.actualNativeCount == 2
            && lossyFailure.missingCount == 1
            && lossyFailure.unexpectedCount == 0,
        "a silent Native loss must report privacy-safe counts without committing the baseline");

    FakeFactory fullFactory = new FakeFactory(nativeFactory.dictionary.durable, 500000);
    boolean capacityRejected = false;
    try {
      GoogleNativeDictionaryBridge.apply(new FakeContext(), fullFactory,
          Arrays.asList(new GoogleNativeDictionaryBridge.Change(
              "rong liang", "fixture-eta", RimeSyncPlanner.GoogleAction.ADD)));
    } catch (GoogleNativeDictionaryBridge.CapacityException expected) {
      capacityRejected = true;
    }
    require(capacityRejected && !fullFactory.dictionary.persisted,
        "capacity preflight must reject a transaction before native mutation");

    final RimeSyncSessionPlan.Baseline unknown = new RimeSyncSessionPlan.Baseline(
        RimeSyncPlanner.History.UNKNOWN, RimeSyncPlanner.GoogleProjection.SUPPORTED, 0);
    RimeSyncSessionPlan sessionPlan = RimeSyncSessionPlan.build(
        RimeSyncCore.translationEntries(bridgeMerged), nativeSnapshot,
        new RimeSyncSessionPlan.BaselineLookup() {
          @Override public RimeSyncSessionPlan.Baseline get(String key) {
            return unknown;
          }
        });
    require(sessionPlan.googleAdditionCount == 1
            && sessionPlan.rimeAdditionCount == 1,
        "session planning must form a non-destructive first-run union");
    require(!sessionPlan.requiresDeletionConfirmation()
            && sessionPlan.confirmationToken.length() == 64,
        "a first union must have a stable confirmation token without deletions");
    RimeSyncSessionPlan previewPlan = RimeSyncSessionPlan.buildPreview(
        RimeSyncCore.translationEntries(bridgeMerged), nativeSnapshot,
        new RimeSyncSessionPlan.BaselineLookup() {
          @Override public RimeSyncSessionPlan.Baseline get(String key) {
            return unknown;
          }
        });
    require(previewPlan.entries.isEmpty()
            && previewPlan.googleAdditionCount == sessionPlan.googleAdditionCount
            && previewPlan.rimeAdditionCount == sessionPlan.rimeAdditionCount
            && previewPlan.confirmationToken.equals(sessionPlan.confirmationToken),
        "preview planning must retain the full result without retaining entry plans");

    RimeSyncSessionPlan deletePlan = RimeSyncSessionPlan.build(
        RimeSyncCore.translationEntries(bridgeMerged), nativeSnapshot,
        new RimeSyncSessionPlan.BaselineLookup() {
          @Override public RimeSyncSessionPlan.Baseline get(String key) {
            return new RimeSyncSessionPlan.Baseline(
                RimeSyncPlanner.History.PRESENT,
                RimeSyncPlanner.GoogleProjection.SUPPORTED, 20);
          }
        });
    require(deletePlan.googleDeletionCount == 1
            && deletePlan.rimeDeletionCount == 1
            && deletePlan.requiresDeletionConfirmation(),
        "session planning must expose all deletion counts for confirmation");
    boolean dominatingDeleteFound = false;
    for (RimeSyncSessionPlan.EntryPlan entry : deletePlan.entries) {
      if (entry.rimeAction == RimeSyncPlanner.RimeAction.DELETE) {
        require(entry.rimeCommitValue == -21,
            "a deletion must dominate both current and baseline Rime counts");
        dominatingDeleteFound = true;
      }
    }
    require(dominatingDeleteFound, "the deletion fixture must produce a Rime tombstone");
  }
}
'''


def verify_native_api(decoded: Path) -> None:
    expected = {
        decoded / "smali/com/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor.smali": [
            ".method public clearAllEntries()Z",
            ".method public duplicateDictionary()Z",
            ".method public getAllEntries()[Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;",
            ".method public getDictionaryCount()I",
            ".method public insertOrUpdate(Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)Z",
            ".method public persist()Z",
            ".method public remove(Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)Z",
        ],
        decoded / "smali/com/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory.smali": [
            ".field public static final USER_DICTIONARY_CAPACITY:I = 0x7a120",
            ".method public final notifyMutableDictionaryDataChanged(Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;)V",
        ],
        decoded / "smali/com/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask.smali": [
            ".field public static final sSaveLock:Ljava/lang/Object;",
        ],
        decoded / "smali/com/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry.smali": [
            ".method public constructor <init>([Ljava/lang/String;[ILjava/lang/String;IZZI)V",
        ],
        decoded / "smali/com/google/android/apps/inputmethod/libs/hmm/userdictionary/UserDictExportTask.smali": [
            "SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;",
            ":try_start_export_lock",
            "monitor-enter",
        ],
        decoded / "smali/com/google/android/apps/inputmethod/libs/hmm/userdictionary/UserDictImportTask.smali": [
            "SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;",
            ":try_start_import_lock",
            "monitor-enter",
        ],
    }
    for path, needles in expected.items():
        text = path.read_text(encoding="utf-8")
        for needle in needles:
            if needle not in text:
                raise AssertionError(f"native API contract missing from {path}: {needle}")


def verify_smali(decoded: Path | None) -> None:
    patch_dir = ROOT / "patches/smali/rimesync"
    patch_files = sorted(patch_dir.glob("*.smali"))
    if len(patch_files) != 65:
        raise AssertionError(f"expected 65 generated Rime Smali files, found {len(patch_files)}")
    required = {
        "GoogleNativeDictionaryBridge.smali",
        "RimeSyncCoordinator.smali",
        "RimeSyncEngineFactoryProvider.smali",
        "RimeSyncSettingsCompat.smali",
        "RimeSyncStateStore.smali",
    }
    if not required.issubset({path.name for path in patch_files}):
        raise AssertionError("generated Rime Smali set is incomplete")
    provider = (patch_dir / "RimeSyncEngineFactoryProvider.smali").read_text(encoding="utf-8")
    if "Lbdt;->a(Landroid/content/Context;)Lbdt;" not in provider:
        raise AssertionError("Rime synchronization must use the Chinese Pinyin engine factory")
    if decoded is None:
        return
    deployed = decoded / "smali/com/google/android/inputmethod/pinyin/rimesync"
    deployed_files = sorted(deployed.glob("*.smali"))
    if [path.name for path in deployed_files] != [path.name for path in patch_files]:
        raise AssertionError("decoded APK does not contain the complete Primary DEX Rime classes")
    for patch in patch_files:
        expected = patch.read_text(encoding="utf-8").splitlines()
        actual = (deployed / patch.name).read_text(encoding="utf-8").splitlines()
        if expected != actual:
            raise AssertionError(f"decoded Rime Smali differs from patch artifact: {patch.name}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--jdk", type=Path, default=ROOT / "work/android-sdk-16kb/jdk")
    parser.add_argument("--sdk", type=Path, default=ROOT / "work/android-sdk-16kb")
    parser.add_argument("--decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve() if args.decoded else ROOT / "work/decoded"
    verify_native_api(decoded)
    verify_smali(decoded if args.decoded else None)
    javac = args.jdk.resolve() / "bin/javac.exe"
    java = args.jdk.resolve() / "bin/java.exe"
    android_jar = args.sdk.resolve() / "platforms/android-36/android.jar"
    for path in (*SOURCES, *ANDROID_SOURCES, NATIVE_BRIDGE_SOURCE,
                 SESSION_PLAN_SOURCE, COORDINATOR_SOURCE, SETTINGS_SOURCE,
                 javac, java, android_jar):
        if not path.exists():
            raise FileNotFoundError(path)

    work = ROOT / "work/rime-userdb-snapshot-test"
    if work.exists():
        shutil.rmtree(work)
    classes = work / "classes"
    classes.mkdir(parents=True)
    test = work / "RimeUserDbSnapshotTest.java"
    test.write_text(TEST_SOURCE, encoding="utf-8")
    stubs = work / "stubs"
    stub_paths = write_stubs(stubs, include_android_context=True)
    subprocess.run(
        [str(javac), "-encoding", "UTF-8", "-source", "7", "-target", "7",
         "-d", str(classes), *(str(source) for source in SOURCES),
         str(NATIVE_BRIDGE_SOURCE), str(SESSION_PLAN_SOURCE),
         *(str(path) for path in stub_paths), str(test)],
        cwd=ROOT,
        check=True,
    )
    subprocess.run([str(java), "-cp", str(classes), "RimeUserDbSnapshotTest"], check=True)

    android_classes = work / "android-classes"
    android_classes.mkdir()
    android_stub_paths = write_stubs(
        work / "android-stubs", include_android_context=False
    )
    subprocess.run(
        [str(javac), "-encoding", "UTF-8", "-source", "7", "-target", "7",
         "-bootclasspath", str(android_jar), "-d", str(android_classes),
         *(str(source) for source in SOURCES),
         *(str(source) for source in ANDROID_SOURCES), str(NATIVE_BRIDGE_SOURCE),
         str(SESSION_PLAN_SOURCE), str(COORDINATOR_SOURCE), str(SETTINGS_SOURCE),
         *(str(path) for path in android_stub_paths)],
        cwd=ROOT,
        check=True,
    )
    print("Rime snapshot, protocol, state store, SAF, native bridge, and coordinator verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
