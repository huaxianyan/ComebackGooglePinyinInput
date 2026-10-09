package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context

/**
 * The first-run completion marker, which lives in the primary DEX.
 *
 * `FirstRunStateCompat` is a legacy-side helper: it owns the marker file, the
 * launch claim that keeps two guides from opening at once, and the migration
 * that reads the historical `HAD_FIRST_RUN` key. This module cannot compile
 * against it, so the calls go through reflection and the runtime gate asserts
 * the names against the legacy source instead of a shared constant.
 *
 * Every lookup passes its parameter types, and the boolean lookup checks the
 * return type before using the result. `getMethod` matches on name and
 * parameters only, and this class has same-parameter overloads that differ only
 * in what they return - picking one of those would throw on the cast and leave
 * the caller reading a default value forever.
 *
 * All four calls swallow a missing class. The guide degrades to "already
 * complete" rather than crashing on startup, which is also what an apktool-only
 * audit build without the Compose runtime should see.
 */
internal object FirstRunStateBridge {
    private const val STATE_COMPAT =
        "com.google.android.inputmethod.pinyin.firstrun.FirstRunStateCompat"

    private val stateType: Class<*>? by lazy {
        runCatching { Class.forName(STATE_COMPAT) }.getOrNull()
    }

    fun isComplete(context: Context): Boolean = runCatching {
        val method = requireNotNull(stateType).getMethod("isComplete", Context::class.java)
        check(method.returnType == Boolean::class.javaPrimitiveType) {
            "isComplete does not return a boolean"
        }
        method.invoke(null, context) as Boolean
    }.getOrDefault(false)

    /** Claims the guide for this process, matching the legacy activity's own claim. */
    fun activityCreated() {
        runCatching { stateType?.getMethod("activityCreated")?.invoke(null) }
    }

    /** Releases the claim while the guide is still unfinished, so it can be shown again. */
    fun activityDestroyed(context: Context) {
        runCatching {
            stateType?.getMethod("releaseGuideLaunch", Context::class.java)?.invoke(null, context)
        }
    }

    /**
     * Records completion and marks the keyboard dashboard pending, in one commit.
     *
     * The write is synchronous on the legacy side because the guide's task is
     * removed right after it, and IME startup must not be able to enqueue the
     * guide again in between.
     */
    fun complete(context: Context) {
        runCatching { stateType?.getMethod("complete", Context::class.java)?.invoke(null, context) }
    }
}
