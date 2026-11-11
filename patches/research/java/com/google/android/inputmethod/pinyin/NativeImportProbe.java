package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.net.Uri;
import android.util.Log;

import java.io.InputStream;
import java.lang.reflect.Array;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * Research only, never merged into the product: runs the original import pipeline on a backup file
 * and logs every entry it hands to the native dictionary, so the fields can be compared with the
 * ones this project builds itself.
 *
 * <p>Everything is reflective so the class needs nothing but the platform jar to compile.
 */
final class NativeImportProbe {

    private static final String TAG = "NativeProbe";
    private static final String FACTORY =
            "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory";
    private static final String ACCESSOR =
            "com.google.android.apps.inputmethod.libs.hmm.DictionaryAccessor";
    private static final String ENTRY_SINK =
            "com.google.android.apps.inputmethod.libs.hmm.userdictionary.DictionaryFormat$DictionaryEntrySink";
    private static final String TEXT_SINK =
            "com.google.android.apps.inputmethod.libs.hmm.userdictionary.DictionaryFormat$TextEntrySink";
    private static final String ENTRY =
            "com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface$Entry";
    private static final String IMPORTER =
            "com.google.android.apps.inputmethod.libs.hmm.userdictionary.DictionaryImporter";
    private static final String READER =
            "com.google.android.apps.inputmethod.libs.hmm.userdictionary.TsvFileReader";

    private NativeImportProbe() {}

    static void run(Context context, Uri uri) {
        Object accessor = null;
        try {
            Object format = Class.forName("bea").getDeclaredConstructor().newInstance();
            Object parser = call(format, "getParser");
            String encoding = (String) call(format, "getNativeCharacterEncoding");
            Object factory = Class.forName("bdt").getMethod("a", Context.class).invoke(null, context);
            Class<?> accessorType = Class.forName(ACCESSOR);
            Class<?> typeEnum = Class.forName(FACTORY + "$MutableDictionaryType");
            Object userDictionary = null;
            for (Object constant : typeEnum.getEnumConstants()) {
                if ("USER_DICTIONARY".equals(((Enum<?>) constant).name())) userDictionary = constant;
            }
            accessor = accessorType
                    .getConstructor(Context.class, Class.forName(FACTORY), typeEnum)
                    .newInstance(context, factory, userDictionary);
            final Object importer = Class.forName(IMPORTER)
                    .getConstructor(accessorType).newInstance(accessor);
            final Method write = importer.getClass()
                    .getMethod("write", Class.forName(ENTRY));

            Class<?> sinkType = Class.forName(ENTRY_SINK);
            Object loggingSink = Proxy.newProxyInstance(sinkType.getClassLoader(),
                    new Class<?>[] {sinkType}, new InvocationHandler() {
                        @Override public Object invoke(Object proxy, Method method, Object[] args) {
                            if (args == null || args.length != 1) return Boolean.FALSE;
                            logEntry("native", args[0]);
                            try {
                                Object accepted = write.invoke(importer, args[0]);
                                Log.i(TAG, "importer.write returned " + accepted);
                                return accepted;
                            } catch (Throwable failure) {
                                Log.e(TAG, "importer.write threw", failure);
                                return Boolean.FALSE;
                            }
                        }
                    });

            call(parser, "connect", sinkType, loggingSink);
            InputStream input = context.getContentResolver().openInputStream(uri);
            Object reader = Class.forName(READER)
                    .getConstructor(InputStream.class, String.class)
                    .newInstance(input, encoding);
            call(reader, "connect", Class.forName(TEXT_SINK), parser);
            Class<?> callbackType = Class.forName("bya");
            Object callback = Proxy.newProxyInstance(callbackType.getClassLoader(),
                    new Class<?>[] {callbackType}, new InvocationHandler() {
                        @Override public Object invoke(Object proxy, Method method, Object[] args) {
                            return null;
                        }
                    });
            Object processed = reader.getClass().getMethod("load", callbackType)
                    .invoke(reader, callback);
            Log.i(TAG, "reader.load processed " + processed + " lines");
            call(reader, "close");

            Log.i(TAG, "after import size=" + call(accessor, "getDictionarySize")
                    + " count=" + call(accessor, "getDictionaryCount"));
            Object all = call(accessor, "getAllEntries");
            int length = all == null ? 0 : Array.getLength(all);
            Log.i(TAG, "after import exportAllEntries=" + length);
            for (int index = 0; index < length && index < 5; index++) {
                logEntry("stored", Array.get(all, index));
            }

            Object persisted = call(accessor, "persist");
            Log.i(TAG, "persist returned " + persisted);
            call(accessor, "close");
            accessor = reopen(context, factory, userDictionary);
            Log.i(TAG, "after reload size=" + call(accessor, "getDictionarySize")
                    + " count=" + call(accessor, "getDictionaryCount"));
            Object reloaded = call(accessor, "getAllEntries");
            int reloadedLength = reloaded == null ? 0 : Array.getLength(reloaded);
            Log.i(TAG, "after reload getAllEntries=" + reloadedLength);
            for (int index = 0; index < reloadedLength && index < 5; index++) {
                logEntry("reloaded", Array.get(reloaded, index));
            }
        } catch (Throwable failure) {
            Log.e(TAG, "probe failed", failure);
        } finally {
            if (accessor != null) {
                try {
                    call(accessor, "close");
                } catch (Throwable ignored) {
                    // Closing a research probe is best effort.
                }
            }
        }
    }

    /**
     * Runs the task the shipped app used to schedule, so the original failure can be reproduced
     * next to the pipeline above.
     */
    static void runTask(final Context context, final Uri uri) {
        try {
            Class<?> listenerType = Class.forName(
                    "com.google.android.apps.inputmethod.libs.framework.core.TaskListener");
            Object listener = Proxy.newProxyInstance(listenerType.getClassLoader(),
                    new Class<?>[] {listenerType}, new InvocationHandler() {
                        @Override public Object invoke(Object proxy, Method method, Object[] args) {
                            Log.i(TAG, "task listener " + method.getName()
                                    + (args == null ? "" : " " + join(args)));
                            if ("onTaskFinished".equals(method.getName())) {
                                reportDictionary(context);
                            }
                            return null;
                        }
                    });
            Object factory = Class.forName("beh")
                    .getConstructor(Context.class, listenerType, Uri.class)
                    .newInstance(context, listener, uri);
            Class<?> managerClass = Class.forName("aib");
            Object manager = managerClass.getMethod("a").invoke(null);
            managerClass.getMethod("a", String.class,
                            Class.forName("com.google.android.apps.inputmethod.libs.framework.core.TaskFactory"),
                            Long.TYPE)
                    .invoke(manager, "user_dict_import", factory, 0L);
            Log.i(TAG, "user_dict_import scheduled");
        } catch (Throwable failure) {
            Log.e(TAG, "task probe failed", failure);
        }
    }

    private static void reportDictionary(Context context) {
        try {
            Object factory = Class.forName("bdt").getMethod("a", Context.class).invoke(null, context);
            Class<?> typeEnum = Class.forName(FACTORY + "$MutableDictionaryType");
            Object userDictionary = null;
            for (Object constant : typeEnum.getEnumConstants()) {
                if ("USER_DICTIONARY".equals(((Enum<?>) constant).name())) userDictionary = constant;
            }
            Object accessor = reopen(context, factory, userDictionary);
            Log.i(TAG, "task result size=" + call(accessor, "getDictionarySize")
                    + " count=" + call(accessor, "getDictionaryCount"));
            Object all = call(accessor, "getAllEntries");
            int length = all == null ? 0 : Array.getLength(all);
            Log.i(TAG, "task result getAllEntries=" + length);
            for (int index = 0; index < length && index < 5; index++) {
                logEntry("task", Array.get(all, index));
            }
            call(accessor, "close");
        } catch (Throwable failure) {
            Log.e(TAG, "reportDictionary failed", failure);
        }
    }

    /**
     * Damages the live dictionary file by truncation and reports what the engine does next, with
     * and without a refresh: this is the fingerprint the 2026-11-11 incident left behind.
     */
    static void runDamage(Context context, Uri uri, final long keep) {
        try {
            String path = uri.getPath();
            java.io.RandomAccessFile file = new java.io.RandomAccessFile(path, "rw");
            long original = file.length();
            file.setLength(Math.min(keep, original));
            file.close();
            Log.i(TAG, "damage: truncated " + original + " -> " + Math.min(keep, original) + " bytes");

            Class<?> typeEnum = Class.forName(FACTORY + "$MutableDictionaryType");
            Object userDictionary = null;
            for (Object constant : typeEnum.getEnumConstants()) {
                if ("USER_DICTIONARY".equals(((Enum<?>) constant).name())) userDictionary = constant;
            }
            Object factory = Class.forName("bdt").getMethod("a", Context.class).invoke(null, context);
            Object accessor = reopen(context, factory, userDictionary);
            report("damage/enroll", accessor);
            call(accessor, "refreshData");
            report("damage/refresh", accessor);
            call(accessor, "close");
            describeFiles(context);
        } catch (Throwable failure) {
            Log.e(TAG, "damage probe failed", failure);
        }
    }

    /**
     * Answers whether refreshData() re-reads the file: opens the dictionary, swaps a different file
     * in place by rename, and reports the counts before and after a refresh.
     */
    static void runRefresh(Context context, Uri uri) {
        Object accessor = null;
        try {
            Class<?> typeEnum = Class.forName(FACTORY + "$MutableDictionaryType");
            Object userDictionary = null;
            for (Object constant : typeEnum.getEnumConstants()) {
                if ("USER_DICTIONARY".equals(((Enum<?>) constant).name())) userDictionary = constant;
            }
            Object factory = Class.forName("bdt").getMethod("a", Context.class).invoke(null, context);
            accessor = reopen(context, factory, userDictionary);
            report("refresh/before", accessor);

            java.io.File target = new java.io.File(context.getFilesDir(), "user_dict_3_3");
            java.io.File swap = new java.io.File(uri.getPath());
            Log.i(TAG, "refresh: swapping in " + swap.length() + " bytes");
            if (!swap.renameTo(target)) {
                Log.e(TAG, "refresh: rename failed");
                return;
            }
            report("refresh/stale", accessor);
            Class<?> typeClass = Class.forName(FACTORY + "$MutableDictionaryType");
            factory.getClass().getMethod("refreshMutableDictionaryData", typeClass)
                    .invoke(factory, userDictionary);
            Log.i(TAG, "refresh: refreshMutableDictionaryData returned");
            report("refresh/after", accessor);
            call(accessor, "close");
            accessor = reopen(context, factory, userDictionary);
            report("refresh/reopened", accessor);
        } catch (Throwable failure) {
            Log.e(TAG, "refresh probe failed", failure);
        } finally {
            if (accessor != null) {
                try {
                    call(accessor, "close");
                } catch (Throwable ignored) {
                    // Best effort on a research probe.
                }
            }
        }
    }

    private static void report(String label, Object accessor) throws Exception {
        Log.i(TAG, label + " size=" + call(accessor, "getDictionarySize")
                + " count=" + call(accessor, "getDictionaryCount"));
        Object all = call(accessor, "getAllEntries");
        int length = all == null ? 0 : Array.getLength(all);
        Log.i(TAG, label + " getAllEntries=" + length);
        for (int index = 0; index < length && index < 3; index++) {
            logEntry(label, Array.get(all, index));
        }
    }

    private static void describeFiles(Context context) {
        java.io.File files = context.getFilesDir();
        for (String name : new String[] {"user_dict_3_3", "user_dict_3_3_bak",
                "user_dict_3_3_tmp", "user_dict_3_3_unreadable"}) {
            java.io.File file = new java.io.File(files, name);
            Log.i(TAG, "file " + name + " exists=" + file.exists() + " size="
                    + (file.exists() ? file.length() : -1));
        }
    }

    private static Object reopen(Context context, Object factory, Object type) throws Exception {
        Class<?> accessorType = Class.forName(ACCESSOR);
        return accessorType
                .getConstructor(Context.class, Class.forName(FACTORY), Class.forName(FACTORY + "$MutableDictionaryType"))
                .newInstance(context, factory, type);
    }

    private static Object call(Object target, String name, Class<?> parameter, Object argument)
            throws Exception {
        Method method = target.getClass().getMethod(name, parameter);
        return method.invoke(target, argument);
    }

    private static Object call(Object target, String name) throws Exception {
        return target.getClass().getMethod(name).invoke(target);
    }

    private static void logEntry(String origin, Object entry) {
        try {
            Class<?> type = entry.getClass();
            Object tokens = type.getField("tokens").get(entry);
            Object languages = type.getField("languageIds").get(entry);
            Log.i(TAG, origin + " value=" + type.getField("value").get(entry)
                    + " tokens=" + join(tokens) + " languages=" + join(languages)
                    + " count=" + type.getField("count").get(entry)
                    + " modified=" + type.getField("isModified").get(entry)
                    + " normalized=" + type.getField("isNormalizedToken").get(entry)
                    + " expansion=" + type.getField("tokenExpansionType").get(entry));
        } catch (Throwable failure) {
            Log.e(TAG, "logEntry failed", failure);
        }
    }

    private static String join(Object[] values) {
        if (values == null) return "[]";
        StringBuilder builder = new StringBuilder("[");
        for (int index = 0; index < values.length; index++) {
            if (index > 0) builder.append(',');
            builder.append(values[index]);
        }
        return builder.append(']').toString();
    }

    private static String join(Object array) {
        if (array == null) return "null";
        int length = Array.getLength(array);
        StringBuilder builder = new StringBuilder("[");
        for (int index = 0; index < length; index++) {
            if (index > 0) builder.append(',');
            builder.append(Array.get(array, index));
        }
        return builder.append(']').toString();
    }
}
