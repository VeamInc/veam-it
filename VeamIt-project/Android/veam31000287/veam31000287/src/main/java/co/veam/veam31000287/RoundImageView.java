package co.veam.veam31000287;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.widget.ImageView;

/**
 * Created by veam on 3/8/17.
 */
public class RoundImageView extends ImageView {

    Paint mMaskedPaint;
    Paint mCopyPaint;
    Drawable mMaskDrawable;

    public RoundImageView(Context context) {
        this(context, null);
    }

    public RoundImageView(Context context, AttributeSet attrs) {
        super(context, attrs);

        mMaskedPaint = new Paint();
        mMaskedPaint.setXfermode(new PorterDuffXfermode(
                PorterDuff.Mode.SRC_ATOP));

        mCopyPaint = new Paint();
        mMaskDrawable = getResources().getDrawable(R.drawable.rounded_corner_mask);
    }

    public void setRadius(float radius){
        if(mMaskDrawable != null) {
            GradientDrawable drawable = (GradientDrawable) mMaskDrawable;
            drawable.setCornerRadius(radius);
        }
    }

    Rect mBounds;
    RectF mBoundsF;

    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        mBounds = new Rect(0, 0, w, h);
        mBoundsF = new RectF(mBounds);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        int sc = canvas.saveLayer(mBoundsF, mCopyPaint,
                Canvas.HAS_ALPHA_LAYER_SAVE_FLAG
                        | Canvas.FULL_COLOR_LAYER_SAVE_FLAG);

        mMaskDrawable.setBounds(mBounds);
        mMaskDrawable.draw(canvas);

        canvas.saveLayer(mBoundsF, mMaskedPaint, 0);

        super.onDraw(canvas);

        canvas.restoreToCount(sc);
    }
}