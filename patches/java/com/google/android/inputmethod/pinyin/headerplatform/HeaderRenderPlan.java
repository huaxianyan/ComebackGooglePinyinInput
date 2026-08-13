package com.google.android.inputmethod.pinyin.headerplatform;

/** Immutable result of arbitration. Renderers apply a plan atomically. */
public final class HeaderRenderPlan {
    private static final HeaderRenderPlan NATIVE_OWNED =
            new HeaderRenderPlan(true, null, null, null, 0L);
    private static final HeaderRenderPlan IDLE =
            new HeaderRenderPlan(false, null, null, null, 0L);

    private final boolean nativeOwned;
    private final HeaderContribution center;
    private final HeaderContribution leading;
    private final HeaderContribution trailing;
    private final long renderGeneration;

    public HeaderRenderPlan(boolean nativeOwned, HeaderContribution center,
            HeaderContribution leading, HeaderContribution trailing) {
        this(nativeOwned, center, leading, trailing, 0L);
    }

    public HeaderRenderPlan(boolean nativeOwned, HeaderContribution center,
            HeaderContribution leading, HeaderContribution trailing, long renderGeneration) {
        this.nativeOwned = nativeOwned;
        this.center = center;
        this.leading = leading;
        this.trailing = trailing;
        this.renderGeneration = renderGeneration;
    }

    public static HeaderRenderPlan nativeOwned() { return NATIVE_OWNED; }
    public static HeaderRenderPlan idle() { return IDLE; }
    public boolean isNativeOwned() { return nativeOwned; }
    public HeaderContribution getCenter() { return center; }
    public HeaderContribution getLeading() { return leading; }
    public HeaderContribution getTrailing() { return trailing; }
    public long getRenderGeneration() { return renderGeneration; }
    public boolean isIdle() {
        return !nativeOwned && center == null && leading == null && trailing == null;
    }
}
