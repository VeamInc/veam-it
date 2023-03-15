package co.veam.veam31000287;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class ForumGroupCategoryAdapter extends BaseAdapter {

	private Context context ;
	
	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private ForumGroupCategoryObject[] forumGroupCategoryObjects ;
	
	public ForumGroupCategoryAdapter(Context context,ForumGroupCategoryObject[] forumGroupCategoryObjects,int width,int topMargin,float scaledDensity)
	{
		this.context = context ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.forumGroupCategoryObjects = forumGroupCategoryObjects ;
	}

	@Override
	public int getCount() {
		int retValue = 0 ; 
		if(forumGroupCategoryObjects != null){
			retValue = forumGroupCategoryObjects.length+1 ;
		}
		//VeamUtil.log("debug","getCount : " + retValue) ;
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		ForumGroupCategoryObject retValue = null ;
		if((position > 0) && (forumGroupCategoryObjects != null)){
			retValue = forumGroupCategoryObjects[position-1] ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		ForumGroupCategoryObject forumGroupCategoryObject = (ForumGroupCategoryObject)this.getItem(position) ;
		String categoryName = "" ;
		if(position > 0){
			if(forumGroupCategoryObject != null){
				categoryName = forumGroupCategoryObject.getName() ;
			}
		}
		
		LinearLayout view = new LinearLayout(context) ;
		view.setTag(Integer.valueOf(position)) ;
		view.setOrientation(LinearLayout.VERTICAL) ;
		if(position == 0){
			view.setBackgroundColor(Color.TRANSPARENT) ;
			view.setPadding(0, topMargin, 0, 0) ;
			return view ;
		}
		
		view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
		
		LinearLayout.LayoutParams layoutParams ;
		
		
		int cellHeight = this.listWidth*14/100 ;
		
		RelativeLayout contentLayout = new RelativeLayout(context) ;
		contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
		layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
		view.addView(contentLayout,layoutParams) ;
		
		Typeface typeface = Typeface.createFromAsset(this.context.getAssets(), "Roboto-Light.ttf");
		
		TextView textView = new TextView(context) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText(categoryName);
		//textView.setMovementMethod(LinkMovementMethod.getInstance());
		//textView.setAutoLinkMask(Linkify.WEB_URLS);
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)listWidth * 5.2f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;
		
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*84/100, cellHeight) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,0, 0, 0) ;
		contentLayout.addView(textView,relativeLayoutParams) ;
		

		ImageView imageView ;
		imageView = new ImageView(context) ;
		imageView.setImageResource(R.drawable.setting_arrow) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
		relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*4/100, 0, 0) ;
		contentLayout.addView(imageView,relativeLayoutParams) ;
		
		View lineView = new View(context) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		return view ;	
	}

}
