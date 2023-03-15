package co.veam.veam31000287;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

public class OverScrollListView extends ListView {

    private Context context ;

	private static int SCROLL_STATE_NORMAL		= 0x01 ;
	private static int SCROLL_STATE_NOTIFY		= 0x02 ;
	private static int SCROLL_STATE_UPDATING	= 0x03 ;
	private static int SCROLL_STATE_LOAD_MORE	= 0x04 ;
	
	private int mOverscrollDistance = 200;
	private int state = SCROLL_STATE_NORMAL;
	
	private OnOverScrollListViewSizeChangedListener onOverScrollListViewSizeChangedListener ;

	public OverScrollListView(Context context,int overscrollDistance) {
		super(context);
        this.context = context ;
		mOverscrollDistance = overscrollDistance * 2 ;
	}

	public OverScrollListView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public OverScrollListView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	@Override
	protected boolean overScrollBy(int deltaX, int deltaY, int scrollX,int scrollY, int scrollRangeX, int scrollRangeY,int maxOverScrollX, int maxOverScrollY, boolean isTouchEvent) {
		return super.overScrollBy(deltaX, deltaY, scrollX, scrollY,scrollRangeX, scrollRangeY, maxOverScrollX,mOverscrollDistance, isTouchEvent) ;
	}
	
	//オーバースクロール発生時
	@Override
	protected void onOverScrolled(int scrollX, int scrollY, boolean clampedX,boolean clampedY) {
		//VeamUtil.log("debug", "scrollX:" + scrollX + " scrollY:" + scrollY+ " clampedX:" + clampedX + " clampedY:" + clampedX);
	    if((state == SCROLL_STATE_NORMAL) && (scrollY <= -mOverscrollDistance)){
	    	LoadMoreAdapter loadMoreAdapter = (LoadMoreAdapter)this.getAdapter() ;
	    	loadMoreAdapter.setTopText(context.getString(R.string.release_to_refresh)) ;
	    	state = SCROLL_STATE_NOTIFY ;
	    } else if((state == SCROLL_STATE_NORMAL) && (mOverscrollDistance <= scrollY)){
	    	//VeamUtil.log("debug","load more") ;
	    	LoadMoreAdapter loadMoreAdapter = (LoadMoreAdapter)this.getAdapter() ;
	    	loadMoreAdapter.setLoadingMore() ;
	    	state = SCROLL_STATE_LOAD_MORE ;
	    }
	    
	    if((state == SCROLL_STATE_NOTIFY) && (-mOverscrollDistance < scrollY)){
	    	//VeamUtil.log("debug","do update") ;
	    	LoadMoreAdapter loadMoreAdapter = (LoadMoreAdapter)this.getAdapter() ;
	    	loadMoreAdapter.setUpdating() ;
	    	state = SCROLL_STATE_UPDATING ;
	    }
	    
	    super.onOverScrolled(scrollX, scrollY, clampedX, clampedY);
	}
	
	public void setScrollStateNormal(){
    	state = SCROLL_STATE_NORMAL ;
	}
	
	@Override
	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		//VeamUtil.log("debug","OverScrollListView::onMeasure") ;
		if (onOverScrollListViewSizeChangedListener != null) {
	        final int newHeight = MeasureSpec.getSize(heightMeasureSpec) ; 
	        final int oldHeight = getMeasuredHeight() ;
	        if(oldHeight == newHeight){
	    		//VeamUtil.log("debug","no difference") ;
	        } else {
	    		//VeamUtil.log("debug","keyboard changed "+oldHeight + "->"+newHeight) ;
	        	onOverScrollListViewSizeChangedListener.onOverScrollListViewHeightChanged(newHeight,oldHeight) ;
	        }
	        	/*
	        } else if(oldSpec > newSpec){
	            //onSoftKeyboardListener.onShown();
	    		//VeamUtil.log("debug","keyboard shown "+oldSpec + "->"+newSpec) ;
	        } else {
	            //onSoftKeyboardListener.onHidden();
	    		//VeamUtil.log("debug","keyboard "+oldSpec + "->"+newSpec) ;
	        }
	        */
	    }
		
		super.onMeasure(widthMeasureSpec, heightMeasureSpec) ; // this should be last line
	}
	
	@Override
	protected void onSizeChanged (int w, int h, int oldw, int oldh){
		//VeamUtil.log("debug","OverScrollListView::onSizeChanged") ;
		if(onOverScrollListViewSizeChangedListener != null){
			onOverScrollListViewSizeChangedListener.onOverScrollListViewSizeChanged(w, h, oldw, oldh) ;
		}
		super.onSizeChanged(w, h, oldw, oldh) ;
	}
	
	public void setOnOverScrollListViewSizeChangedListener(OnOverScrollListViewSizeChangedListener onOverScrollListViewSizeChangedListener) {
		this.onOverScrollListViewSizeChangedListener = onOverScrollListViewSizeChangedListener;
	}

	public interface OnOverScrollListViewSizeChangedListener {
		public void onOverScrollListViewHeightChanged(int newHeight,int oldHeight) ;
		public void onOverScrollListViewSizeChanged(int w, int h, int oldw, int oldh) ;
	}
}