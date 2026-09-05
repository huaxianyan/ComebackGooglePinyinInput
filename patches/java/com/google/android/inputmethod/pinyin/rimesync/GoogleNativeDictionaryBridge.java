package com.google.android.inputmethod.pinyin.rimesync;

import android.content.Context;
import com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory;
import com.google.android.apps.inputmethod.libs.hmm.DictionaryAccessor;
import com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface;
import com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask;
import java.io.IOException;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.IdentityHashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/** Narrow transactional adapter for the existing Google Pinyin native user dictionary. */
public final class GoogleNativeDictionaryBridge {
    public static final int USER_DICTIONARY_CAPACITY = 500000;
    public static final int FAILURE_DUPLICATE = 5;
    public static final int FAILURE_INSERT = 6;
    public static final int FAILURE_PERSIST = 7;
    public static final int FAILURE_REBUILD = 8;
    public static final int FAILURE_EXPORT = 9;
    public static final int FAILURE_DATA = 10;
    public static final int FAILURE_STALE = 11;
    private static final int PINYIN_LANGUAGE_ID = 16;
    private static final int NEW_ENTRY_COUNT = 1;
    private static final GoogleEntry PRESENT = new GoogleEntry("", "", "", 0, null);

    private GoogleNativeDictionaryBridge() {}

    /**
     * Reads a stable native dictionary copy. Callers must use the same factory when applying a
     * plan. Entries that cannot be represented by the Rime protocol remain counted for capacity
     * purposes but are not exposed as translatable entries.
     */
    public static Snapshot read(Context context, AbstractHmmEngineFactory engineFactory)
            throws IOException {
        return readSnapshot(context, engineFactory, false);
    }

    /** Reads only canonical presence for a preview that will not retain executable entries. */
    static Snapshot readPresence(Context context, AbstractHmmEngineFactory engineFactory)
            throws IOException {
        return readSnapshot(context, engineFactory, true);
    }

    private static Snapshot readSnapshot(Context context,
            AbstractHmmEngineFactory engineFactory, boolean presenceOnly) throws IOException {
        requireArguments(context, engineFactory);
        synchronized (SaveDictionaryTask.sSaveLock) {
            DictionaryAccessor accessor = open(context, engineFactory);
            try {
                if (!accessor.duplicateDictionary()) {
                    throw nativeFailure(FAILURE_DUPLICATE,
                            "Google user dictionary could not be duplicated");
                }
                return snapshot(accessor, false, presenceOnly);
            } finally {
                accessor.close();
            }
        }
    }

    /**
     * Applies a plan to a fresh native dictionary copy and publishes it only after every mutation
     * succeeds. Expected presence is checked again so a stale preview cannot overwrite learning or
     * another dictionary operation.
     */
    public static Result apply(Context context, AbstractHmmEngineFactory engineFactory,
            List<Change> changes) throws IOException {
        return applyInternal(context, engineFactory, changes, false,
                Collections.<String>emptySet());
    }

    /** Idempotently converges pending operations after an interrupted synchronization. */
    public static Result recover(Context context, AbstractHmmEngineFactory engineFactory,
            List<Change> changes) throws IOException {
        return applyInternal(context, engineFactory, changes, true,
                Collections.<String>emptySet());
    }

    /** Applies the supported subset after the caller verifies one exact rejected set. */
    public static Result recoverKeepingRejected(Context context,
            AbstractHmmEngineFactory engineFactory, List<Change> changes,
            RejectedEntriesException rejected) throws IOException {
        if (rejected == null) throw new IllegalArgumentException("rejected entries are required");
        return applyInternal(context, engineFactory, changes, true,
                new HashSet<String>(rejected.rejectedKeys));
    }

    private static Result applyInternal(Context context,
            AbstractHmmEngineFactory engineFactory, List<Change> changes,
            boolean tolerateAppliedChanges, Set<String> skippedAdditionKeys) throws IOException {
        requireArguments(context, engineFactory);
        if (changes == null) throw new IllegalArgumentException("Google changes are required");
        synchronized (SaveDictionaryTask.sSaveLock) {
            DictionaryAccessor accessor = open(context, engineFactory);
            try {
                if (!accessor.duplicateDictionary()) {
                    throw nativeFailure(FAILURE_DUPLICATE,
                            "Google user dictionary could not be duplicated");
                }
                Snapshot before = snapshot(accessor, true, false);
                PreparedChanges prepared = prepare(
                        before, changes, tolerateAppliedChanges);
                if (!skippedAdditionKeys.isEmpty()) {
                    List<Change> supportedAdds = new ArrayList<Change>();
                    Set<String> pendingAddKeys = new HashSet<String>();
                    for (Change addition : prepared.adds) {
                        pendingAddKeys.add(addition.key);
                        if (!skippedAdditionKeys.contains(addition.key)) {
                            supportedAdds.add(addition);
                        }
                    }
                    if (!pendingAddKeys.containsAll(skippedAdditionKeys)) {
                        throw nativeFailure(FAILURE_STALE,
                                "rejected Google entries changed before continuation");
                    }
                    prepared = new PreparedChanges(prepared.deletes, supportedAdds);
                }
                if (prepared.deletes.isEmpty() && prepared.adds.isEmpty()) {
                    return new Result(before.totalEntryCount, 0, 0, false);
                }
                int projectedCount = before.totalEntryCount
                        - prepared.deletes.size() + prepared.adds.size();
                if (projectedCount > USER_DICTIONARY_CAPACITY) {
                    throw new CapacityException(before.totalEntryCount,
                            prepared.adds.size(), prepared.deletes.size());
                }
                if (!prepared.deletes.isEmpty()) {
                    rebuildWithoutDeletedEntries(accessor, before, prepared.deletes);
                }
                List<String> rejectedKeys = new ArrayList<String>();
                for (Change addition : prepared.adds) {
                    if (!accessor.insertOrUpdate(newEntry(addition.code, addition.phrase))) {
                        rejectedKeys.add(addition.key);
                    }
                }
                if (!rejectedKeys.isEmpty()) {
                    throw new RejectedEntriesException(rejectedKeys);
                }
                if (!accessor.persist()) {
                    throw nativeFailure(FAILURE_PERSIST,
                            "Google user dictionary persistence failed");
                }
                accessor.close();
                accessor = null;
                // Reload the durable data before taking another copy. Listener delivery remains
                // on the main thread, but verification never waits for that thread under the lock.
                engineFactory.refreshMutableDictionaryData(
                        AbstractHmmEngineFactory.MutableDictionaryType.USER_DICTIONARY);
                Snapshot persisted = readComplete(context, engineFactory);
                verifyPersisted(before, persisted, prepared);
                return new Result(projectedCount, prepared.adds.size(),
                        prepared.deletes.size(), true);
            } finally {
                // Closing an unpersisted duplicate discards its native in-memory mutations.
                if (accessor != null) accessor.close();
            }
        }
    }

    private static void verifyPersisted(Snapshot before, Snapshot persisted,
            PreparedChanges changes) throws IOException {
        Set<String> expectedKeys = new HashSet<String>(before.entries.keySet());
        for (GoogleEntry deletion : changes.deletes) expectedKeys.remove(deletion.key);
        for (Change addition : changes.adds) expectedKeys.add(addition.key);
        int expectedNativeCount = before.allEntries.size()
                - changes.deletes.size() + changes.adds.size();
        Set<String> missingKeys = new HashSet<String>(expectedKeys);
        missingKeys.removeAll(persisted.entries.keySet());
        Set<String> unexpectedKeys = new HashSet<String>(persisted.entries.keySet());
        unexpectedKeys.removeAll(expectedKeys);
        if (!missingKeys.isEmpty() || !unexpectedKeys.isEmpty()
                || persisted.allEntries.size() != expectedNativeCount) {
            throw new PersistenceVerificationException(
                    expectedNativeCount, persisted.allEntries.size(),
                    missingKeys, unexpectedKeys);
        }
    }

    private static void rebuildWithoutDeletedEntries(DictionaryAccessor accessor,
            Snapshot before, List<GoogleEntry> deletions) throws IOException {
        Set<MutableDictionaryAccessorInterface.Entry> removed =
                Collections.newSetFromMap(
                        new IdentityHashMap<MutableDictionaryAccessorInterface.Entry, Boolean>());
        for (GoogleEntry deletion : deletions) removed.add(deletion.source);
        if (!accessor.clearAllEntries()) {
            throw nativeFailure(FAILURE_REBUILD,
                    "Google user dictionary rebuild could not start");
        }
        for (MutableDictionaryAccessorInterface.Entry entry : before.allEntries) {
            if (!removed.contains(entry) && !accessor.insertOrUpdate(entry)) {
                throw nativeFailure(FAILURE_REBUILD,
                        "Google user dictionary rebuild failed");
            }
        }
    }

    private static DictionaryAccessor open(Context context,
            AbstractHmmEngineFactory engineFactory) {
        return new DictionaryAccessor(context, engineFactory,
                AbstractHmmEngineFactory.MutableDictionaryType.USER_DICTIONARY);
    }

    private static Snapshot readComplete(Context context,
            AbstractHmmEngineFactory engineFactory) throws IOException {
        synchronized (SaveDictionaryTask.sSaveLock) {
            DictionaryAccessor accessor = open(context, engineFactory);
            try {
                if (!accessor.duplicateDictionary()) {
                    throw nativeFailure(FAILURE_DUPLICATE,
                            "Google user dictionary could not be duplicated");
                }
                return snapshot(accessor, true, false);
            } finally {
                accessor.close();
            }
        }
    }

    private static Snapshot snapshot(DictionaryAccessor accessor, boolean retainSources,
            boolean presenceOnly) throws IOException {
        MutableDictionaryAccessorInterface.Entry[] nativeEntries = accessor.getAllEntries();
        if (nativeEntries == null) {
            throw nativeFailure(FAILURE_EXPORT,
                    "Google user dictionary export failed");
        }
        Map<String, GoogleEntry> entries = new LinkedHashMap<String, GoogleEntry>();
        int exportedEntryCount = nativeEntries.length;
        for (int index = 0; index < nativeEntries.length; index++) {
            MutableDictionaryAccessorInterface.Entry source = nativeEntries[index];
            GoogleEntry entry = canonicalEntry(source, retainSources);
            if (!retainSources) nativeEntries[index] = null;
            if (entry == null) continue;
            GoogleEntry previous = entries.put(entry.key, presenceOnly ? PRESENT : entry);
            if (previous != null) {
                throw nativeFailure(FAILURE_DATA,
                        "Google user dictionary has a duplicate normalized key");
            }
        }
        int nativeCount = accessor.getDictionaryCount();
        int totalCount = Math.max(exportedEntryCount, nativeCount);
        List<MutableDictionaryAccessorInterface.Entry> allEntries = retainSources
                ? Arrays.asList(nativeEntries)
                : Collections.<MutableDictionaryAccessorInterface.Entry>emptyList();
        return new Snapshot(totalCount, entries, allEntries, true);
    }

    private static PreparedChanges prepare(Snapshot before, List<Change> changes,
            boolean tolerateAppliedChanges) throws IOException {
        Map<String, Change> unique = new LinkedHashMap<String, Change>();
        for (Change change : changes) {
            if (change == null) throw new IllegalArgumentException("Google change is null");
            Change normalized = new Change(change.code, change.phrase, change.action);
            if (unique.put(normalized.key, normalized) != null) {
                throw new IllegalArgumentException("duplicate Google change");
            }
        }
        List<GoogleEntry> deletes = new ArrayList<GoogleEntry>();
        List<Change> adds = new ArrayList<Change>();
        for (Change change : unique.values()) {
            GoogleEntry existing = before.entries.get(change.key);
            if (change.action == RimeSyncPlanner.GoogleAction.DELETE) {
                if (existing == null) {
                    if (!tolerateAppliedChanges) {
                        throw nativeFailure(FAILURE_STALE,
                                "Google synchronization preview is stale");
                    }
                } else {
                    deletes.add(existing);
                }
            } else if (change.action == RimeSyncPlanner.GoogleAction.ADD) {
                if (existing != null) {
                    if (!tolerateAppliedChanges) {
                        throw nativeFailure(FAILURE_STALE,
                                "Google synchronization preview is stale");
                    }
                } else {
                    adds.add(change);
                }
            }
        }
        return new PreparedChanges(deletes, adds);
    }

    private static GoogleEntry canonicalEntry(
            MutableDictionaryAccessorInterface.Entry source) throws IOException {
        return canonicalEntry(source, true);
    }

    private static GoogleEntry canonicalEntry(
            MutableDictionaryAccessorInterface.Entry source, boolean retainSource)
            throws IOException {
        if (source == null || source.tokens == null || source.tokens.length == 0
                || source.languageIds == null
                || source.languageIds.length != source.tokens.length
                || source.value == null) {
            return null;
        }
        String phrase;
        try {
            phrase = normalizePhrase(source.value);
        } catch (IllegalArgumentException unsupported) {
            return null;
        }
        if (phrase.codePointCount(0, phrase.length()) < 2) return null;
        StringBuilder code = new StringBuilder();
        for (int index = 0; index < source.tokens.length; index++) {
            if (source.languageIds[index] != PINYIN_LANGUAGE_ID) return null;
            String token;
            try {
                token = normalizeToken(source.tokens[index]);
            } catch (IllegalArgumentException unsupported) {
                return null;
            }
            if (code.length() > 0) code.append(' ');
            code.append(token);
        }
        String normalizedCode = code.toString();
        return new GoogleEntry(normalizedCode + '\t' + phrase,
                normalizedCode, phrase, source.count, retainSource ? source : null);
    }

    private static MutableDictionaryAccessorInterface.Entry newEntry(String code, String phrase) {
        String normalizedCode = normalizeCode(code);
        String normalizedPhrase = normalizePhrase(phrase);
        String[] tokens = normalizedCode.split(" ");
        int[] languageIds = new int[tokens.length];
        for (int index = 0; index < languageIds.length; index++) {
            languageIds[index] = PINYIN_LANGUAGE_ID;
        }
        return new MutableDictionaryAccessorInterface.Entry(tokens, languageIds,
                normalizedPhrase, NEW_ENTRY_COUNT, false, true,
                MutableDictionaryAccessorInterface.Entry.NO_EXPANSION);
    }

    private static String normalizeCode(String value) {
        if (value == null) throw new IllegalArgumentException("Google pinyin is required");
        String trimmed = value.trim().toLowerCase(Locale.US);
        if (trimmed.length() == 0) {
            throw new IllegalArgumentException("Google pinyin is empty");
        }
        StringBuilder normalized = new StringBuilder(trimmed.length());
        boolean separator = false;
        for (int index = 0; index < trimmed.length(); index++) {
            char character = trimmed.charAt(index);
            if (Character.isWhitespace(character)) {
                separator = normalized.length() > 0;
            } else {
                if (character < 'a' || character > 'z') {
                    throw new IllegalArgumentException("Google pinyin is not supported");
                }
                if (separator) normalized.append(' ');
                normalized.append(character);
                separator = false;
            }
        }
        return normalized.toString();
    }

    private static String normalizeToken(String token) {
        String normalized = normalizeCode(token);
        if (normalized.indexOf(' ') >= 0) {
            throw new IllegalArgumentException("Google pinyin token contains a separator");
        }
        return normalized;
    }

    private static String normalizePhrase(String value) {
        if (value == null) throw new IllegalArgumentException("Google phrase is required");
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFC);
        if (normalized.length() == 0 || !normalized.equals(normalized.trim())) {
            throw new IllegalArgumentException("Google phrase has invalid whitespace");
        }
        for (int index = 0; index < normalized.length();) {
            int codePoint = normalized.codePointAt(index);
            if (Character.isISOControl(codePoint)) {
                throw new IllegalArgumentException("Google phrase contains a control character");
            }
            index += Character.charCount(codePoint);
        }
        return normalized;
    }

    private static NativeOperationException nativeFailure(int failureKind, String message) {
        return new NativeOperationException(failureKind, message);
    }

    private static void requireArguments(Context context,
            AbstractHmmEngineFactory engineFactory) {
        if (context == null || engineFactory == null) {
            throw new IllegalArgumentException("Google dictionary context and factory are required");
        }
    }

    public static class NativeOperationException extends IOException {
        public final int failureKind;

        NativeOperationException(int failureKind, String message) {
            super(message);
            this.failureKind = failureKind;
        }
    }

    public static final class RejectedEntriesException extends NativeOperationException {
        public final int rejectedCount;
        final List<String> rejectedKeys;

        RejectedEntriesException(List<String> rejectedKeys) {
            super(FAILURE_INSERT, "Google user dictionary rejected synchronized entries");
            List<String> sortedKeys = new ArrayList<String>(rejectedKeys);
            Collections.sort(sortedKeys);
            this.rejectedKeys = Collections.unmodifiableList(sortedKeys);
            this.rejectedCount = sortedKeys.size();
        }
    }

    public static final class PersistenceVerificationException extends IOException {
        public final int expectedNativeCount;
        public final int actualNativeCount;
        public final int missingCount;
        public final int unexpectedCount;
        final List<String> missingKeys;
        final List<String> unexpectedKeys;

        PersistenceVerificationException(int expectedNativeCount, int actualNativeCount,
                Set<String> missingKeys, Set<String> unexpectedKeys) {
            super("Google user dictionary persistence verification failed");
            this.expectedNativeCount = expectedNativeCount;
            this.actualNativeCount = actualNativeCount;
            List<String> missing = new ArrayList<String>(missingKeys);
            List<String> unexpected = new ArrayList<String>(unexpectedKeys);
            Collections.sort(missing);
            Collections.sort(unexpected);
            this.missingKeys = Collections.unmodifiableList(missing);
            this.unexpectedKeys = Collections.unmodifiableList(unexpected);
            this.missingCount = missing.size();
            this.unexpectedCount = unexpected.size();
        }
    }

    public static final class Snapshot {
        public final int totalEntryCount;
        public final Map<String, GoogleEntry> entries;
        private final List<MutableDictionaryAccessorInterface.Entry> allEntries;

        Snapshot(int totalEntryCount, Map<String, GoogleEntry> entries,
                List<MutableDictionaryAccessorInterface.Entry> allEntries) {
            this(totalEntryCount, new LinkedHashMap<String, GoogleEntry>(entries),
                    new ArrayList<MutableDictionaryAccessorInterface.Entry>(allEntries), true);
        }

        Snapshot(int totalEntryCount, Map<String, GoogleEntry> entries,
                List<MutableDictionaryAccessorInterface.Entry> allEntries,
                boolean ownedContainers) {
            this.totalEntryCount = totalEntryCount;
            // snapshot() owns both containers; wrapping avoids duplicate full-size storage.
            this.entries = Collections.unmodifiableMap(entries);
            this.allEntries = Collections.unmodifiableList(allEntries);
        }
    }

    public static final class GoogleEntry {
        public final String key;
        public final String code;
        public final String phrase;
        public final int count;
        private final MutableDictionaryAccessorInterface.Entry source;

        GoogleEntry(String key, String code, String phrase, int count,
                MutableDictionaryAccessorInterface.Entry source) {
            this.key = key;
            this.code = code;
            this.phrase = phrase;
            this.count = count;
            this.source = source;
        }
    }

    public static final class Change {
        public final String key;
        public final String code;
        public final String phrase;
        public final RimeSyncPlanner.GoogleAction action;

        public Change(String code, String phrase, RimeSyncPlanner.GoogleAction action) {
            if (action == null || action == RimeSyncPlanner.GoogleAction.NONE) {
                throw new IllegalArgumentException("Google mutation action is required");
            }
            this.code = normalizeCode(code);
            this.phrase = normalizePhrase(phrase);
            if (this.phrase.codePointCount(0, this.phrase.length()) < 2) {
                throw new IllegalArgumentException("single-character Google entries are excluded");
            }
            this.key = this.code + '\t' + this.phrase;
            this.action = action;
        }
    }

    public static final class Result {
        public final int totalEntryCount;
        public final int addedCount;
        public final int deletedCount;
        public final boolean persisted;

        Result(int totalEntryCount, int addedCount, int deletedCount, boolean persisted) {
            this.totalEntryCount = totalEntryCount;
            this.addedCount = addedCount;
            this.deletedCount = deletedCount;
            this.persisted = persisted;
        }
    }

    public static final class CapacityException extends IOException {
        public final int currentCount;
        public final int additionCount;
        public final int deletionCount;

        CapacityException(int currentCount, int additionCount, int deletionCount) {
            super("Google user dictionary capacity would be exceeded");
            this.currentCount = currentCount;
            this.additionCount = additionCount;
            this.deletionCount = deletionCount;
        }
    }

    private static final class PreparedChanges {
        final List<GoogleEntry> deletes;
        final List<Change> adds;

        PreparedChanges(List<GoogleEntry> deletes, List<Change> adds) {
            this.deletes = deletes;
            this.adds = adds;
        }
    }
}
