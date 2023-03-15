package co.veam.veam31000287;

import android.content.Context;
import android.util.Log;
import android.view.MotionEvent;
import android.widget.ScrollView;

public class ClickableScrollView extends ScrollView {
	
	private float downX ; 
	private float downY ; 
	OnClickListener onClickListener ;

    public ClickableScrollView(Context context,OnClickListener onClickListener) {
         super(context);
         this.onClickListener = onClickListener ;
    }
   
	@Override
	public boolean onTouchEvent (MotionEvent event){
        Log.v("ClickableScrollView", "onTouchEvent "+event.getAction());
        if(event.getAction() == MotionEvent.ACTION_DOWN){
        	downX = event.getX() ;
        	downY = event.getY() ;
        } else if(event.getAction() == MotionEvent.ACTION_UP){
        	float upX = event.getX() ;
        	float upY = event.getY() ;
        	float distanceX = (downX - upX) ;
        	float distanceY = (downY - upY) ;
        	double distance = Math.sqrt(distanceX*distanceX +distanceY*distanceY) ;
        	
			long start = event.getDownTime(); // [ms]
			long now = event.getEventTime(); // [ms]
			long duration = now - start ;
            Log.v("debug", "distance "+distance + " duration "+(now-start));
            if((duration < 200) && (distance < 10)){
            	onClickListener.onClick(this) ;
            }
        }
		return super.onTouchEvent(event) ;
	}
}
