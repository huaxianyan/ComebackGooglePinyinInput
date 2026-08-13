package com.google.android.inputmethod.pinyin.headerplatform;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Service-scoped module registry, identity owner, publication store, and arbiter. */
public final class HeaderPlatformController implements HeaderPlatformContext {
    private final HeaderSessionController sessions = new HeaderSessionController();
    private final HeaderArbiter arbiter = new HeaderArbiter();
    private final Map<String, HeaderModule> modules =
            new LinkedHashMap<String, HeaderModule>();
    private final Map<String, HeaderContribution> contributions =
            new LinkedHashMap<String, HeaderContribution>();
    private HeaderRenderPlanListener listener;
    private boolean initialized;
    private boolean nativeCandidatesActive;
    private long headerGeneration;
    private long activeHeaderToken;
    private Integer currentCandidateTextColor;
    private long renderGeneration = 1L;

    public synchronized void register(HeaderModule module) {
        if (initialized) throw new IllegalStateException("modules must be registered before init");
        if (module == null || module.getModuleId() == null
                || module.getModuleId().length() == 0) {
            throw new IllegalArgumentException("module and moduleId must not be empty");
        }
        if (modules.containsKey(module.getModuleId())) {
            throw new IllegalArgumentException("duplicate moduleId: " + module.getModuleId());
        }
        modules.put(module.getModuleId(), module);
    }

    /** Initializes module lifecycles independently of input-view creation order. */
    public synchronized HeaderModule getRegisteredModule(String moduleId) {
        return moduleId == null ? null : modules.get(moduleId);
    }

    public synchronized void initialize() {
        if (initialized) return;
        initialized = true;
        for (HeaderModule module : snapshotModules()) module.onAttach(this);
    }

    /** Binds exactly one concrete Header host and gives it a new opaque identity. */
    public synchronized HeaderHandle bindHost(HeaderRenderPlanListener planListener,
            Integer candidateTextColor) {
        ensureInitialized();
        if (planListener == null) throw new IllegalArgumentException("listener must not be null");
        if (listener != null) unbindHost(listener);
        headerGeneration++;
        if (headerGeneration <= 0L) headerGeneration = 1L;
        activeHeaderToken = headerGeneration;
        currentCandidateTextColor = candidateTextColor;
        renderGeneration++;
        if (renderGeneration <= 0L) renderGeneration = 1L;
        listener = planListener;
        HeaderHandle handle = new HeaderHandle(activeHeaderToken);
        for (HeaderModule module : snapshotModules()) module.onHeaderAvailable(handle);
        dispatchPlan();
        return handle;
    }

    /** Invalidates all publications tied to the detached host. */
    public synchronized void unbindHost(HeaderRenderPlanListener planListener) {
        if (listener == null || listener != planListener) return;
        long oldToken = activeHeaderToken;
        activeHeaderToken = 0L;
        currentCandidateTextColor = null;
        contributions.clear();
        nativeCandidatesActive = false;
        for (HeaderModule module : snapshotModules()) module.onHeaderUnavailable(oldToken);
        listener.onHeaderRenderPlanChanged(HeaderRenderPlan.idle());
        listener = null;
    }

    public synchronized long startInput(HeaderEditorContext editor) {
        ensureInitialized();
        contributions.clear();
        nativeCandidatesActive = false;
        long token = sessions.startSession();
        HeaderEditorContext safeEditor = editor == null
                ? HeaderEditorContext.from(null) : editor;
        for (HeaderModule module : snapshotModules()) {
            module.onStartInput(safeEditor, token);
        }
        dispatchPlan();
        return token;
    }

    public synchronized void setNativeCandidatesActive(boolean active) {
        setNativeCandidateState(active, false);
    }

    public synchronized void setNativeCandidateState(boolean active, boolean clipboardOnly) {
        if (!initialized) return;
        nativeCandidatesActive = active;
        for (HeaderModule module : snapshotModules()) {
            if (module instanceof HeaderNativeCandidateStateAware) {
                ((HeaderNativeCandidateStateAware) module).onNativeCandidateStateChanged(
                        active, clipboardOnly);
            } else {
                module.onNativeCandidateStateChanged(active);
            }
        }
        dispatchPlan();
    }

    public synchronized void onThemeChanged(long themeToken) {
        if (!initialized) return;
        renderGeneration++;
        if (renderGeneration <= 0L) renderGeneration = 1L;
        for (HeaderModule module : snapshotModules()) module.onThemeChanged(themeToken);
        dispatchPlan();
    }

    public synchronized void finishInput() {
        if (!initialized) return;
        long token = sessions.getActiveToken();
        sessions.invalidate();
        contributions.clear();
        nativeCandidatesActive = false;
        if (token > 0L) {
            for (HeaderModule module : snapshotModules()) module.onFinishInput(token);
        }
        dispatchPlan();
    }

    public synchronized void destroy() {
        if (!initialized) return;
        finishInput();
        if (listener != null) unbindHost(listener);
        for (HeaderModule module : snapshotModules()) module.onDetach();
        initialized = false;
    }

    @Override
    public synchronized long getCurrentSessionToken() {
        return sessions.getActiveToken();
    }

    @Override
    public synchronized long getCurrentHeaderToken() {
        return activeHeaderToken;
    }

    @Override
    public synchronized Integer getCurrentCandidateTextColor() {
        return currentCandidateTextColor;
    }

    @Override
    public synchronized boolean publish(HeaderContribution contribution) {
        if (!initialized || contribution == null
                || !sessions.isActive(contribution.getSessionToken())
                || contribution.getHeaderToken() != activeHeaderToken
                || activeHeaderToken <= 0L) return false;
        if (!modules.containsKey(contribution.getModuleId())) return false;
        contributions.put(key(contribution.getModuleId(), contribution.getStableId()), contribution);
        dispatchPlan();
        return true;
    }

    @Override
    public synchronized void withdraw(String moduleId, String stableId) {
        if (moduleId == null || stableId == null) return;
        if (contributions.remove(key(moduleId, stableId)) != null) dispatchPlan();
    }

    @Override
    public synchronized void withdrawModule(String moduleId) {
        if (moduleId == null) return;
        boolean changed = false;
        List<String> keys = new ArrayList<String>(contributions.keySet());
        String prefix = moduleId + '\u0000';
        for (String contributionKey : keys) {
            if (contributionKey.startsWith(prefix)) {
                contributions.remove(contributionKey);
                changed = true;
            }
        }
        if (changed) dispatchPlan();
    }

    private List<HeaderModule> snapshotModules() {
        return new ArrayList<HeaderModule>(modules.values());
    }

    private String key(String moduleId, String stableId) {
        return moduleId + '\u0000' + stableId;
    }

    private void ensureInitialized() {
        if (!initialized) throw new IllegalStateException("Header platform is not initialized");
    }

    private void dispatchPlan() {
        if (listener == null) return;
        renderGeneration++;
        if (renderGeneration <= 0L) renderGeneration = 1L;
        HeaderRenderPlan plan = arbiter.resolve(contributions.values(),
                sessions.getActiveToken(), activeHeaderToken, nativeCandidatesActive,
                renderGeneration);
        listener.onHeaderRenderPlanChanged(plan);
    }
}
