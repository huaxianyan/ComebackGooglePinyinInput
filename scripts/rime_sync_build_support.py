#!/usr/bin/env python3
"""Shared compile-time contracts for generating and testing Rime synchronization code."""

from __future__ import annotations

NATIVE_STUB_SOURCES = {
    "android/content/Context.java": r'''
package android.content;
public abstract class Context {}
''',
    "com/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface.java": r'''
package com.google.android.apps.inputmethod.libs.hmm;
public interface MutableDictionaryAccessorInterface {
  final class Entry {
    public static final int NO_EXPANSION = 0;
    public final String[] tokens;
    public final int[] languageIds;
    public final String value;
    public final int count;
    public final boolean isModified;
    public final boolean isNormalizedToken;
    public final int tokenExpansionType;
    public Entry(String[] tokens, int[] languageIds, String value, int count,
        boolean isModified, boolean isNormalizedToken, int tokenExpansionType) {
      this.tokens = tokens;
      this.languageIds = languageIds;
      this.value = value;
      this.count = count;
      this.isModified = isModified;
      this.isNormalizedToken = isNormalizedToken;
      this.tokenExpansionType = tokenExpansionType;
    }
  }
  boolean duplicateDictionary();
  boolean clear();
  Entry[] exportAllEntries();
  int getDictionaryCount();
  boolean insertOrUpdate(String[] tokens, int[] languageIds, String value, int count,
      boolean isModified, boolean isNormalizedToken);
  boolean remove(String[] tokens, int[] languageIds, String value);
  boolean persist(String path);
  void close();
}
''',
    "com/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory.java": r'''
package com.google.android.apps.inputmethod.libs.hmm;
public abstract class AbstractHmmEngineFactory {
  public enum MutableDictionaryType { USER_DICTIONARY }
  public abstract MutableDictionaryAccessorInterface createMutableDictionaryAccessor(
      MutableDictionaryType type);
  public abstract void refreshMutableDictionaryData(MutableDictionaryType type);
}
''',
    "com/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor.java": r'''
package com.google.android.apps.inputmethod.libs.hmm;
import android.content.Context;
public final class DictionaryAccessor {
  private final MutableDictionaryAccessorInterface delegate;
  public DictionaryAccessor(Context context, AbstractHmmEngineFactory factory,
      AbstractHmmEngineFactory.MutableDictionaryType type) {
    delegate = factory.createMutableDictionaryAccessor(type);
  }
  public boolean duplicateDictionary() { return delegate.duplicateDictionary(); }
  public boolean clearAllEntries() { return delegate.clear(); }
  public MutableDictionaryAccessorInterface.Entry[] getAllEntries() {
    return delegate.exportAllEntries();
  }
  public int getDictionaryCount() { return delegate.getDictionaryCount(); }
  public boolean insertOrUpdate(MutableDictionaryAccessorInterface.Entry entry) {
    return delegate.insertOrUpdate(entry.tokens, entry.languageIds, entry.value, entry.count,
        entry.isModified, entry.isNormalizedToken);
  }
  public boolean remove(MutableDictionaryAccessorInterface.Entry entry) {
    return delegate.remove(entry.tokens, entry.languageIds, entry.value);
  }
  public boolean persist() { return delegate.persist("fixture"); }
  public void close() { delegate.close(); }
}
''',
    "com/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask.java": r'''
package com.google.android.apps.inputmethod.libs.hmm;
public final class SaveDictionaryTask {
  public static final Object sSaveLock = new Object();
}
''',
    "com/google/android/inputmethod/pinyin/rimesync/RimeSyncEngineFactoryProvider.java": r'''
package com.google.android.inputmethod.pinyin.rimesync;
import android.content.Context;
import com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory;
public final class RimeSyncEngineFactoryProvider {
  public static AbstractHmmEngineFactory get(Context context) { return null; }
}
''',
}


def write_stubs(root, include_android_context):
    """Write shared stubs and return their paths in deterministic order."""
    paths = []
    for relative_path in sorted(NATIVE_STUB_SOURCES):
        if not include_android_context and relative_path == "android/content/Context.java":
            continue
        path = root / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(NATIVE_STUB_SOURCES[relative_path].strip() + "\n", encoding="utf-8")
        paths.append(path)
    return paths
