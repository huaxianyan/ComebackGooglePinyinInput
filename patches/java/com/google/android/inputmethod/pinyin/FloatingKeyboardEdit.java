package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.graphics.Path;
import android.graphics.RectF;
import android.view.MotionEvent;
import android.view.View;

/**
 * Overlay shown while the card is in edit mode.
 *
 * <p>It copies the look of the stock floating-keyboard editor: an accent-coloured outline, L-shaped
 * corner marks, a translucent disc in each corner for resizing, a solid disc in the middle with a
 * four-way arrow, and two action discs left and right. Everything is drawn with the current keyboard
 * theme accent, so the same code looks teal on a teal theme and blue on a blue one.
 *
 * <p>The overlay covers the whole card and takes every touch: in edit mode the keys are frozen, so
 * a press anywhere means "move the card" unless it lands on a corner or an action disc.
 */
public final class FloatingKeyboardEdit extends View {

    interface Listener {
        /** @param finished true on release, where the coordinates are the lift point */
        void onEditDrag(float screenX, float screenY, boolean finished);

        /** @param corner 0 top-left, 1 top-right, 2 bottom-right, 3 bottom-left */
        void onEditScale(int corner, float screenX, float screenY, boolean finished);

        void onEditReset();

        void onEditDone();
    }

    private static final float STROKE_DP = 2f;
    private static final float CORNER_LEN_DP = 13f;
    private static final float CORNER_STROKE_DP = 3.5f;
    /** Diameter of the translucent corner disc. Doubles as the resize touch target. */
    private static final float ZONE_DP = 48f;
    private static final float MOVE_DP = 42f;
    private static final float ACTION_DP = 36f;
    /** Half-size of the square that accepts a corner press; larger than the disc. */
    private static final float CORNER_HIT_DP = 34f;
    private static final float DISC_HIT_DP = 26f;

    private final Paint fill = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint line = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint glyph = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Drawable resetIcon;
    private final Drawable moveIcon;
    private final Drawable doneIcon;
    private final Path path = new Path();
    private final RectF rect = new RectF();
    private final float density;
    private final int accent;
    private final int accentSoft;

    private Listener listener;
    /** -1 none, 0..3 a corner, 4 the move disc, 5 reset, 6 done. */
    private int active = -1;
    private boolean movePressed;

    public FloatingKeyboardEdit(Context context, int accent) {
        super(context);
        density = context.getResources().getDisplayMetrics().density;
        this.accent = accent;
        this.accentSoft = (accent & 0x00FFFFFF) | 0x21000000;

        line.setStyle(Paint.Style.STROKE);
        line.setStrokeWidth(STROKE_DP * density);
        line.setColor(accent);

        glyph.setStyle(Paint.Style.STROKE);
        glyph.setStrokeWidth(2f * density);
        glyph.setStrokeCap(Paint.Cap.ROUND);
        glyph.setStrokeJoin(Paint.Join.ROUND);
        glyph.setColor(accent);

        // Standard Material glyphs instead of hand-drawn paths: the shapes are already the ones
        // users know, and a hand-drawn arc plus arrow head reads wrong at this size.
        resetIcon = loadIcon(context, "ic_floating_edit_reset", accent);
        doneIcon = loadIcon(context, "ic_floating_edit_done", accent);
        moveIcon = loadIcon(context, "ic_floating_edit_move", 0xFFFFFFFF);

        setClickable(true);
        setFocusable(false);
    }

    void setListener(Listener listener) {
        this.listener = listener;
    }

    // --------------------------- drawing ---------------------------

    @Override
    protected void onDraw(Canvas canvas) {
        float w = getWidth();
        float h = getHeight();
        if (w <= 0 || h <= 0) return;

        // Wash the keys out: the card is an object now, not a keyboard.
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(0x73FFFFFF);
        rect.set(0f, 0f, w, h);
        canvas.drawRect(rect, fill);

        // Corner discs first: they sit under the outline so the L marks stay crisp.
        float zone = ZONE_DP * density;
        fill.setColor(accentSoft);
        for (float[] c : cornerCenters()) {
            canvas.drawCircle(c[0], c[1], zone / 2f, fill);
        }

        // Outline, inset so the stroke stays inside the card edge.
        float inset = STROKE_DP * density / 2f;
        rect.set(inset, inset, w - inset, h - inset);
        canvas.drawRect(rect, line);

        drawCorners(canvas);

        // Centre disc with the four-way arrow.
        float cx = w / 2f;
        float cy = h / 2f;
        float moveR = MOVE_DP * density / 2f;
        fill.setColor(movePressed ? darken(accent) : accent);
        canvas.drawCircle(cx, cy, moveR, fill);
        drawIcon(canvas, moveIcon, cx, cy, moveR * 1.30f);

        // Left: reset. Right: done.
        float actionR = ACTION_DP * density / 2f;
        float offset = moveR + 20f * density + actionR;
        fill.setColor(accentSoft);
        canvas.drawCircle(cx - offset, cy + 6f * density, actionR, fill);
        canvas.drawCircle(cx + offset, cy + 6f * density, actionR, fill);
        drawIcon(canvas, resetIcon, cx - offset, cy + 6f * density, actionR * 1.30f);
        drawIcon(canvas, doneIcon, cx + offset, cy + 6f * density, actionR * 1.30f);
    }

    private float[][] cornerCenters() {
        float w = getWidth();
        float h = getHeight();
        return new float[][] {{0, 0}, {w, 0}, {w, h}, {0, h}};
    }

    private void drawCorners(Canvas canvas) {
        float len = CORNER_LEN_DP * density;
        float w = getWidth();
        float h = getHeight();
        line.setStrokeWidth(CORNER_STROKE_DP * density);
        line.setStrokeCap(Paint.Cap.BUTT);
        // top-left
        canvas.drawLine(0f, len, 0f, 0f, line);
        canvas.drawLine(0f, 0f, len, 0f, line);
        // top-right
        canvas.drawLine(w - len, 0f, w, 0f, line);
        canvas.drawLine(w, 0f, w, len, line);
        // bottom-right
        canvas.drawLine(w, h - len, w, h, line);
        canvas.drawLine(w, h, w - len, h, line);
        // bottom-left
        canvas.drawLine(len, h, 0f, h, line);
        canvas.drawLine(0f, h, 0f, h - len, line);
        line.setStrokeWidth(STROKE_DP * density);
        line.setStrokeCap(Paint.Cap.ROUND);
    }

    /** Draws a themed glyph centred on the point, at the given box size. */
    private void drawIcon(Canvas canvas, Drawable icon, float cx, float cy, float size) {
        if (icon == null) return;
        int half = Math.max(1, Math.round(size / 2f));
        int x = Math.round(cx);
        int y = Math.round(cy);
        icon.setBounds(x - half, y - half, x + half, y + half);
        icon.draw(canvas);
    }

    /** Loads a glyph by name and tints it; a missing resource simply draws nothing. */
    private static Drawable loadIcon(Context context, String name, int tint) {
        try {
            int id = context.getResources().getIdentifier(name, "drawable", context.getPackageName());
            if (id == 0) return null;
            Drawable drawable = context.getDrawable(id);
            if (drawable == null) return null;
            drawable = drawable.mutate();
            drawable.setTint(tint);
            return drawable;
        } catch (Throwable ignored) {
            return null;
        }
    }

    private static int darken(int color) {
        int r = (int) (((color >> 16) & 0xFF) * 0.82f);
        int g = (int) (((color >> 8) & 0xFF) * 0.82f);
        int b = (int) ((color & 0xFF) * 0.82f);
        return 0xFF000000 | (r << 16) | (g << 8) | b;
    }

    // --------------------------- touch ---------------------------

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getActionMasked()) {
            case MotionEvent.ACTION_DOWN: {
                active = regionAt(event.getX(), event.getY());
                if (active == 4) movePressed = true;
                if (getParent() != null) getParent().requestDisallowInterceptTouchEvent(true);
                float[] screen = screenOf(event);
                if (active >= 0 && active <= 3) {
                    reportScale(active, screen, false);
                } else if (active == 4) {
                    invalidate();
                    reportDrag(screen, false);
                }
                return true;
            }
            case MotionEvent.ACTION_MOVE: {
                if (active < 0) return true;
                float[] screen = screenOf(event);
                if (active <= 3) {
                    reportScale(active, screen, false);
                } else if (active == 4) {
                    reportDrag(screen, false);
                }
                return true;
            }
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL: {
                int finished = active;
                active = -1;
                movePressed = false;
                invalidate();
                float[] screen = screenOf(event);
                if (finished >= 0 && finished <= 3) {
                    reportScale(finished, screen, true);
                } else if (finished == 4) {
                    reportDrag(screen, true);
                } else if (finished == 5) {
                    if (listener != null) listener.onEditReset();
                } else if (finished == 6) {
                    if (listener != null) listener.onEditDone();
                }
                return true;
            }
            default:
                return true;
        }
    }

    /** -1 miss, 0..3 corner, 4 move disc, 5 reset, 6 done. */
    private int regionAt(float x, float y) {
        float w = getWidth();
        float h = getHeight();
        float hit = CORNER_HIT_DP * density;
        float[][] corners = {{0, 0}, {w, 0}, {w, h}, {0, h}};
        for (int i = 0; i < corners.length; i++) {
            if (Math.abs(x - corners[i][0]) <= hit && Math.abs(y - corners[i][1]) <= hit) {
                return i;
            }
        }
        float cx = w / 2f;
        float cy = h / 2f;
        float discHit = DISC_HIT_DP * density;
        if (distance(x, y, cx, cy) <= discHit) return 4;

        float moveR = MOVE_DP * density / 2f;
        float offset = moveR + 20f * density + ACTION_DP * density / 2f;
        if (distance(x, y, cx - offset, cy + 6f * density) <= discHit) return 5;
        if (distance(x, y, cx + offset, cy + 6f * density) <= discHit) return 6;

        // Everything else moves the card.
        return 4;
    }

    private float[] screenOf(MotionEvent event) {
        int[] location = new int[2];
        getLocationOnScreen(location);
        return new float[] {location[0] + event.getX(), location[1] + event.getY()};
    }

    private void reportDrag(float[] screen, boolean finished) {
        if (listener != null) listener.onEditDrag(screen[0], screen[1], finished);
    }

    private void reportScale(int corner, float[] screen, boolean finished) {
        if (listener != null) listener.onEditScale(corner, screen[0], screen[1], finished);
    }

    private static float distance(float x1, float y1, float x2, float y2) {
        float dx = x1 - x2;
        float dy = y1 - y2;
        return (float) Math.sqrt(dx * dx + dy * dy);
    }
}
