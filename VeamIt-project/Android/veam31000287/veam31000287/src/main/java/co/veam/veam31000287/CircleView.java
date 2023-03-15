package co.veam.veam31000287;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.view.View;

public class CircleView extends View {

	private Paint paint ;
	/*
	private int centerX ;
	private int centerY ;
	private int radius ;
	*/
	private RectF oval ;
	private float percentage ;
	private int color ;
	private boolean revert = false ;
	private int strokeWidth = 5 ;
	private boolean fill = true ;

	
	public int getColor() {
		return color;
	}


	public void setColor(int color) {
		this.color = color;
	}


	public float getPercentage() {
		return percentage;
	}


	public void setPercentage(float percentage) {
		this.percentage = percentage;
		this.invalidate() ;
	}

	public CircleView(Context context){
		super(context) ;
		paint = new Paint();
	}
	
	
	public RectF getOval() {
		return oval;
	}

	public void setOval(RectF oval) {
		this.oval = oval;
	}

	/*
	public int getCenterX() {
		return centerX;
	}

	public void setCenterX(int centerX) {
		this.centerX = centerX;
	}

	public int getCenterY() {
		return centerY;
	}

	public void setCenterY(int centerY) {
		this.centerY = centerY;
	}

	public int getRadius() {
		return radius;
	}

	public void setRadius(int radius) {
		this.radius = radius;
	}
	*/

	public boolean isRevert() {
		return revert;
	}

	public void setRevert(boolean revert) {
		this.revert = revert;
	}

	public int getStrokeWidth() {
		return strokeWidth;
	}

	public void setStrokeWidth(int strokeWidth) {
		this.strokeWidth = strokeWidth;
	}

	public boolean isFill() {
		return fill;
	}

	public void setFill(boolean fill) {
		this.fill = fill;
	}

	@Override
	protected void onDraw(Canvas canvas) {
		canvas.drawColor(Color.TRANSPARENT);
		paint.setColor(color);
		paint.setStrokeWidth(strokeWidth);
		paint.setAntiAlias(true);

		boolean useCenter ;
		if(fill) {
			paint.setStyle(Paint.Style.FILL);
			useCenter = true ;
		} else {
			paint.setStyle(Paint.Style.STROKE);
			useCenter = false ;
		}
		//canvas.drawCircle(centerX, centerY, radius, paint);
		int start = (int) (360f * percentage - 90);
		int swipe = 270 - start;
		if(revert){
			start = -90 ;
			swipe = (int)(360f*percentage) ;
		}
		canvas.drawArc(oval, start, swipe, useCenter, paint);
	}
}
