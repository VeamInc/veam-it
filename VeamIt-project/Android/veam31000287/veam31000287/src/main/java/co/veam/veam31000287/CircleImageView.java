package co.veam.veam31000287;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;

public class CircleImageView extends ImageView {

	public CircleImageView(Context context) {
		this(context, null);
	}

	public CircleImageView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}


	@Override
	protected void onDraw(Canvas canvas) {

		Drawable d = getDrawable();

		if(d == null) {
			return;
		}

		if(d.getIntrinsicHeight() == 0 || d.getIntrinsicWidth() == 0) {
			return;
		}

		int radius = getWidth();
		Bitmap bitmap = null ;
		try {
			bitmap = ((BitmapDrawable)d).getBitmap();
		} catch(ClassCastException e){
		}

		if(bitmap != null){
			Bitmap b = createCroppedBitmap(radius, bitmap);
			canvas.drawBitmap(b, 0, 0, null);
		}
	}

	private Bitmap createCroppedBitmap(int radius, Bitmap bitmap) {

		//VeamUtil.log("debug","createCroppedBitmap r="+radius+" w=" + bitmap.getWidth() + " h=" + bitmap.getHeight()) ;
		if(radius != bitmap.getWidth() || radius != bitmap.getHeight()) {
//			bitmap = Bitmap.createScaledBitmap(bitmap, radius, radius, false);
		}

		//Bitmap b = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);
		Bitmap b = Bitmap.createBitmap(radius, radius, Config.ARGB_8888);
		Canvas cvs = new Canvas(b);

		//Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
		Rect rect = new Rect(0, 0, radius,radius);
		RectF rectF = new RectF(rect);
		Rect bitmapRect = new Rect(0,0,bitmap.getWidth(),bitmap.getHeight()) ;

		final Paint paint = new Paint();

		paint.setAntiAlias(true);
		paint.setColor(Color.WHITE);
		paint.setFilterBitmap(true);
		
		cvs.drawOval(rectF, paint);
		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));

		cvs.drawBitmap(bitmap, bitmapRect, rect, paint);
		return b;
	}

}