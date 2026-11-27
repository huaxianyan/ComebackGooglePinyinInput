package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
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

    /** The keyboard's own reset icon, so the control does not carry a hand-made shape. */
    private static final int RESET_ICON = 0x7f020182;
    /** Half-size of the square that accepts a corner press; larger than the disc. */
    private static final float CORNER_HIT_DP = 34f;
    private static final float DISC_HIT_DP = 26f;

    private final Paint fill = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint line = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint glyph = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Path path = new Path();
    private final RectF rect = new RectF();
    private final float density;
    private final int accent;
    private final int accentSoft;
    /** Stock reset icon, tinted with the theme accent; null when the resource is missing. */
    private final Drawable resetIcon;

    private Listener listener;
    /** -1 none, 0..3 a corner, 4 the move disc, 5 reset, 6 done. */
    private int active = -1;
    private boolean movePressed;

    public FloatingKeyboardEdit(Context context, int accent) {
        super(context);
        density = context.getResources().getDisplayMetrics().density;
        this.accent = accent;
        this.accentSoft = (accent & 0x00FFFFFF) | 0x21000000;
        resetIcon = stockIcon(context, RESET_ICON);
        if (resetIcon != null) resetIcon.setTint(accent);

        line.setStyle(Paint.Style.STROKE);
        line.setStrokeWidth(STROKE_DP * density);
        line.setColor(accent);

        glyph.setStyle(Paint.Style.STROKE);
        glyph.setStrokeWidth(2f * density);
        glyph.setStrokeCap(Paint.Cap.ROUND);
        glyph.setStrokeJoin(Paint.Join.ROUND);
        glyph.setColor(accent);

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
        drawMoveArrow(canvas, cx, cy, moveR);

        // Left: reset. Right: done.
        float actionR = ACTION_DP * density / 2f;
        float offset = moveR + 20f * density + actionR;
        fill.setColor(accentSoft);
        canvas.drawCircle(cx - offset, cy + 6f * density, actionR, fill);
        canvas.drawCircle(cx + offset, cy + 6f * density, actionR, fill);
        drawReset(canvas, cx - offset, cy + 6f * density, actionR);
        drawDone(canvas, cx + offset, cy + 6f * density, actionR);
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

    private void drawMoveArrow(Canvas canvas, float cx, float cy, float radius) {
        float arm = radius * 0.52f;
        float head = radius * 0.20f;
        glyph.setColor(0xFFFFFFFF);
        glyph.setStrokeWidth(2f * density);
        path.reset();
        path.moveTo(cx, cy - arm);
        path.lineTo(cx, cy + arm);
        path.moveTo(cx - arm, cy);
        path.lineTo(cx + arm, cy);
        canvas.drawPath(path, glyph);

        // Four solid heads.
        fill.setColor(0xFFFFFFFF);
        fill.setStyle(Paint.Style.FILL);
        float tipY = cy - radius * 0.66f;
        float tipX = cx + radius * 0.66f;
        path.reset();
        path.moveTo(cx, tipY);
        path.lineTo(cx - head, tipY + head * 1.5f);
        path.lineTo(cx + head, tipY + head * 1.5f);
        path.close();
        canvas.drawPath(path, fill);

        path.reset();
        path.moveTo(cx, cy + radius * 0.66f);
        path.lineTo(cx - head, cy + radius * 0.66f - head * 1.5f);
        path.lineTo(cx + head, cy + radius * 0.66f - head * 1.5f);
        path.close();
        canvas.drawPath(path, fill);

        path.reset();
        path.moveTo(tipX, cy);
        path.lineTo(tipX - head * 1.5f, cy - head);
        path.lineTo(tipX - head * 1.5f, cy + head);
        path.close();
        canvas.drawPath(path, fill);

        path.reset();
        path.moveTo(cx - radius * 0.66f, cy);
        path.lineTo(cx - radius * 0.66f + head * 1.5f, cy - head);
        path.lineTo(cx - radius * 0.66f + head * 1.5f, cy + head);
        path.close();
        canvas.drawPath(path, fill);
    }

    /**
     * The stock reset icon, tinted with the theme accent.
     *
     * <p>The bitmap carries its own padding: its ink covers about 42% of the canvas, which is why
     * {@link #drawReset} gives it bounds the size of the whole disc. Sized any smaller the glyph
     * comes out visibly smaller than the arc it replaced.
     */
    private static Drawable stockIcon(Context context, int resId) {
        try {
            Drawable drawable = context.getDrawable(resId);
            return drawable == null ? null : drawable.mutate();
        } catch (Throwable ignored) {
            return null;
        }
    }

    private void drawReset(Canvas canvas, float cx, float cy, float radius) {
        if (resetIcon != null) {
            resetIcon.setBounds(Math.round(cx - radius), Math.round(cy - radius),
                    Math.round(cx + radius), Math.round(cy + radius));
            resetIcon.draw(canvas);
            return;
        }
        float r = radius * 0.42f;
        rect.set(cx - r, cy - r, cx + r, cy + r);
        path.reset();
        path.addArc(rect, -60f, 280f);
        glyph.setColor(accent);
        canvas.drawPath(path, glyph);
        // Arrow head at the open end.
        float ax = cx + r * (float) Math.cos(Math.toRadians(-60f));
        float ay = cy + r * (float) Math.sin(Math.toRadians(-60f));
        path.reset();
        path.moveTo(ax - r * 0.5f, ay - r * 0.1f);
        path.lineTo(ax, ay);
        path.lineTo(ax - r * 0.15f, ay + r * 0.55f);
        canvas.drawPath(path, glyph);
    }

    private void drawDone(Canvas canvas, float cx, float cy, float radius) {
        float k = radius * 0.46f;
        path.reset();
        path.moveTo(cx - k * 0.9f, cy + k * 0.05f);
        path.lineTo(cx - k * 0.2f, cy + k * 0.7f);
        path.lineTo(cx + k, cy - k * 0.7f);
        glyph.setColor(accent);
        glyph.setStrokeWidth(2.4f * density);
        canvas.drawPath(path, glyph);
        glyph.setStrokeWidth(2f * density);
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
