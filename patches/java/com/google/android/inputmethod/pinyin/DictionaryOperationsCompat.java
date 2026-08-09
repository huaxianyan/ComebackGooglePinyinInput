package com.google.android.inputmethod.pinyin;

import android.Manifest;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import java.lang.reflect.Proxy;

/**
 * Primary-DEX bridge for modern dictionary presentation.
 *
 * Contact suggestions retain the original Boolean preference and native contact
 * model. User-dictionary clearing delegates to the original bdz controller and
 * UserDictClearTask; this class does not inspect contacts or dictionary data.
 */
public final class DictionaryOperationsCompat {
  public interface ClearCallback {
    void onClearStarted();
    void onClearFinished(boolean success);
  }

  private static boolean clearInProgress;
  private static Object clearController;
  private static ClearCallback clearCallback;
  private static Boolean pendingClearResult;

  private DictionaryOperationsCompat() {}

  public static boolean hasContactsPermission(Context context) {
    return context.checkCallingOrSelfPermission(Manifest.permission.READ_CONTACTS)
        == PackageManager.PERMISSION_GRANTED;
  }

  public static boolean isContactSuggestionsEnabled(Context context) {
    return hasContactsPermission(context)
        && preferences(context).getBoolean("import_user_contacts", false);
  }

  public static boolean setContactSuggestionsEnabled(Context context, boolean enabled) {
    if (enabled && !hasContactsPermission(context)) return false;
    preferences(context).edit().putBoolean("import_user_contacts", enabled).apply();
    return true;
  }

  public static synchronized boolean isClearInProgress() {
    return clearInProgress;
  }

  public static synchronized void setClearCallback(ClearCallback callback) {
    clearCallback = callback;
    if (callback == null) return;
    if (pendingClearResult != null) {
      boolean success = pendingClearResult;
      pendingClearResult = null;
      callback.onClearFinished(success);
    } else if (clearInProgress) {
      callback.onClearStarted();
    }
  }

  public static synchronized void clearClearCallback(ClearCallback callback) {
    if (clearCallback == callback) clearCallback = null;
  }

  /** Reuses the original bdz controller without exposing its obfuscated type to Compose. */
  public static synchronized boolean startClear(Context context, ClearCallback callback) {
    if (clearInProgress) return false;
    Object controller = null;
    try {
      Context app = context.getApplicationContext();
      // Account dictionary sync was removed; preserve the legacy page's forced-off state
      // so the authoritative clear task remains local and never revives that obsolete path.
      preferences(app).edit().putBoolean("sync", false).apply();
      Class<?> controllerType = Class.forName("bdz");
      Class<?> delegateType = Class.forName(
          "com.google.android.apps.inputmethod.libs.dataservice.preference."
              + "IDictionarySyncControllerDelegate");
      controller = controllerType.getConstructor(Context.class).newInstance(app);
      final Object activeController = controller;
      Object delegate = Proxy.newProxyInstance(
          delegateType.getClassLoader(),
          new Class<?>[] {delegateType},
          (proxy, method, arguments) -> {
            if ("onSyncStatusUpdated".equals(method.getName())) {
              int event = (Integer) arguments[0];
              boolean success = (Boolean) arguments[1];
              if (event == 3) notifyClearStarted();
              if (event == 4) {
                try {
                  controllerType.getMethod("onDestroy").invoke(activeController);
                } catch (Exception ignored) {
                  // Completion still must release bridge state and reach the UI.
                }
                notifyClearFinished(activeController, success);
              }
            }
            return null;
          });
      controllerType.getMethod("onCreate", delegateType).invoke(controller, delegate);
      clearController = controller;
      clearCallback = callback;
      pendingClearResult = null;
      clearInProgress = true;
      controllerType.getMethod("startClearUserDict").invoke(controller);
      return true;
    } catch (Exception failure) {
      if (controller != null) {
        try {
          controller.getClass().getMethod("onDestroy").invoke(controller);
        } catch (Exception ignored) {
          // No controller registration is allowed to survive a failed start.
        }
      }
      clearController = null;
      clearCallback = null;
      clearInProgress = false;
      return false;
    }
  }

  static synchronized void notifyClearStarted() {
    clearInProgress = true;
    if (clearCallback != null) clearCallback.onClearStarted();
  }

  static void notifyClearFinished(Object controller, boolean success) {
    final ClearCallback callback;
    synchronized (DictionaryOperationsCompat.class) {
      if (clearController != controller) return;
      clearInProgress = false;
      clearController = null;
      callback = clearCallback;
      if (callback == null) pendingClearResult = success;
    }
    if (callback != null) callback.onClearFinished(success);
  }

  private static SharedPreferences preferences(Context context) {
    Context app = context.getApplicationContext();
    return app.getSharedPreferences(app.getPackageName() + "_preferences", Context.MODE_PRIVATE);
  }
}
