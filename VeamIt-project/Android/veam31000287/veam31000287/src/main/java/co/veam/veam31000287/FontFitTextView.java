package co.veam.veam31000287;

import android.content.Context;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.util.Log;
import android.util.TypedValue;
import android.widget.TextView;

public class FontFitTextView extends TextView {
	
	private float scaledDensity ;

    public FontFitTextView(Context context,	float scaledDensity) {
        super(context);
        initialise();
        this.scaledDensity = scaledDensity ;
    }

    public FontFitTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initialise();
    }

    private void initialise() {
        mTestPaint = new Paint();
        mTestPaint.set(this.getPaint());
        //max size defaults to the initially specified text size unless it is too small
    }

    /* Re size the font so the specified text fits in the text box
     * assuming the text box is the specified width.
     */
    private void refitText(String text, int textWidth,int textHeight) 
    { 
        if (textWidth <= 0){
            return;
        }
        
        int targetWidth = textWidth - this.getPaddingLeft() - this.getPaddingRight();
        int targetHeight = textHeight - this.getPaddingTop() - this.getPaddingBottom();
        float hi = 100;
        float lo = 2;
        final float threshold = 0.5f; // How close we have to be

        mTestPaint.set(this.getPaint());

        while((hi - lo) > threshold) {
            float size = (hi+lo)/2;
            mTestPaint.setTextSize(size);
            //int numberOfLines = (int)((float)targetHeight / size) - 1 ;
            float effectiveWidth = (float)targetWidth * (float)targetHeight / size ;
            effectiveWidth *= 0.50 ; // ワードラップがあるので余裕を持たせる
            float measuredWidth = mTestPaint.measureText(text) ;
          //VeamUtil.log("debug","textWidth:"+targetWidth+"textHeight:"+targetHeight+"measuredWidth:"+measuredWidth) ;
            //measuredWidth *= scaledDensity ;
            if(measuredWidth >= effectiveWidth) {
                hi = size; // too big
            } else {
                lo = size; // too small
            }
        }
      //VeamUtil.log("debug","text size lo:"+lo) ;
        // Use lo so that we undershoot rather than overshoot
        this.setTextSize(TypedValue.COMPLEX_UNIT_PX, lo);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec)
    {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        int parentWidth = MeasureSpec.getSize(widthMeasureSpec);
        int parentHeight = MeasureSpec.getSize(heightMeasureSpec);
        int height = getMeasuredHeight();
        refitText(this.getText().toString(), parentWidth,parentHeight);
        this.setMeasuredDimension(parentWidth, height);
    }

    @Override
    protected void onTextChanged(final CharSequence text, final int start, final int before, final int after) {
        refitText(text.toString(), this.getWidth(),this.getHeight());
    }

    @Override
    protected void onSizeChanged (int w, int h, int oldw, int oldh) {
        if (w != oldw) {
            refitText(this.getText().toString(), w,h);
        }
    }

    //Attributes
    private Paint mTestPaint;
}