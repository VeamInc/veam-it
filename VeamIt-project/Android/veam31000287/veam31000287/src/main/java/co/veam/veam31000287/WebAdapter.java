package co.veam.veam31000287;

import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;

public class WebAdapter extends BaseAdapter {

	private WebActivity webActivity ;
	
	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private WebObject[] webObjects ;

	private AdSize adSize ;
	private String adUnitId ;



	public WebAdapter(WebActivity activity,WebObject[] webObjects,int width,int topMargin,float scaledDensity,String adUnitId,AdSize adSize)
	{
		this.webActivity = activity ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.webObjects = webObjects ;

		this.adUnitId = adUnitId ;
		this.adSize = adSize ;

	}

	@Override
	public int getCount() {
		int retValue = 0 ; 
		if(webObjects != null){
			retValue = webObjects.length+2 ;
		}
		//VeamUtil.log("debug","getCount : " + retValue) ;
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		WebObject retValue = null ;
		if((position > 1) && (webObjects != null)){
			retValue = webObjects[position-2] ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {


		if(position == 1){
			if(VeamUtil.isActiveAdmob) {
				if (convertView instanceof AdView) {
					// Don’t instantiate new AdView, reuse old one
					return convertView;
				} else {
					// Create a new AdView
					AdView adView = new AdView(webActivity);
					adView.setAdSize(adSize);
					adView.setAdUnitId(adUnitId);
					//int height = Math.round(adSize.getHeight() * listWidth / adSize.getWidth());
					android.widget.AbsListView.LayoutParams params = new android.widget.AbsListView.LayoutParams(listWidth, AbsListView.LayoutParams.WRAP_CONTENT);
					adView.setLayoutParams(params);
					adView.loadAd(VeamUtil.getAdRequest());
					adView.setTag(Integer.valueOf(position));
					return adView;
				}
			} else {
				LinearLayout view = new LinearLayout(webActivity) ;
				view.setTag(position) ;
				view.setOrientation(LinearLayout.VERTICAL) ;
				view.setBackgroundColor(Color.TRANSPARENT) ;
				view.setPadding(0, 1, 0, 0) ;
				return view ;
			}
		}

		WebObject webObject = (WebObject)this.getItem(position) ;
		String categoryName = "" ;
		if(position > 0){
			if(webObject != null){
				categoryName = webObject.getTitle() ;
			}
		}
		
		LinearLayout view = new LinearLayout(webActivity) ;
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
		
		RelativeLayout contentLayout = new RelativeLayout(webActivity) ;
		contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
		layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
		view.addView(contentLayout,layoutParams) ;
		
		Typeface typeface = Typeface.createFromAsset(this.webActivity.getAssets(), "Roboto-Light.ttf");
		
		TextView textView = new TextView(webActivity) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText(categoryName);
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float) listWidth * 5.2f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;
		
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*84/100, cellHeight) ;
		relativeLayoutParams.setMargins(this.listWidth * 5 / 100, 0, 0, 0) ;
		contentLayout.addView(textView, relativeLayoutParams) ;
		

		ImageView imageView ;
		imageView = new ImageView(webActivity) ;
		imageView.setImageResource(R.drawable.setting_arrow) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
		relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*4/100, 0, 0) ;
		contentLayout.addView(imageView, relativeLayoutParams) ;

		View lineView = new View(webActivity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		lineView = new View(webActivity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,0, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		return view ;
	}

}
