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

public class YoutubeCategoryAdapter extends BaseAdapter {

	private VideosActivity videosActivity ;
	
	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private YoutubeCategoryObject[] youtubeCategoryObjects ;
	private AdSize adSize ;
	private String adUnitId ;
	//private AdView adView ;

	public YoutubeCategoryAdapter(VideosActivity activity,YoutubeCategoryObject[] youtubeCategoryObjects,int width,int topMargin,float scaledDensity,String adUnitId,AdSize adSize)
	{
		this.videosActivity = activity ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.youtubeCategoryObjects = youtubeCategoryObjects ;
		this.adUnitId = adUnitId ;
		this.adSize = adSize ;
	}

	@Override
	public int getCount() {
		int retValue = 0 ; 
		if(youtubeCategoryObjects != null){
			retValue = youtubeCategoryObjects.length + 3 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		YoutubeCategoryObject retValue = null ;
		if(position == 2){
			retValue = new YoutubeCategoryObject(VeamUtil.SPECIAL_YOUTUBE_CATEGORY_ID_FAVORITES,videosActivity.getString(R.string.my_favorites),"","") ;
		} else if((position > 2) && (youtubeCategoryObjects != null)){
			retValue = youtubeCategoryObjects[position-3] ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		//VeamUtil.log("debug","YoutubeCategoryAdapter::getView "+position) ;
		
		YoutubeCategoryObject youtubeCategoryObject = (YoutubeCategoryObject)this.getItem(position) ;
		String categoryName = "" ;
		if(position > 1){
			if(position == 2){
				categoryName = videosActivity.getString(R.string.my_favorites) ;
			} else if(youtubeCategoryObject != null){
				categoryName = youtubeCategoryObject.getName() ;
			}
		}

		if(position == 1){
			if(VeamUtil.isActiveAdmob) {
				if (convertView instanceof AdView) {
					// Don’t instantiate new AdView, reuse old one
					return convertView;
				} else {
					// Create a new AdView
					AdView adView = new AdView(videosActivity);
					adView.setAdSize(adSize);
					adView.setAdUnitId(adUnitId);
					//int height = Math.round(adSize.getHeight() * listWidth / adSize.getWidth());
					android.widget.AbsListView.LayoutParams params = new android.widget.AbsListView.LayoutParams(listWidth, AbsListView.LayoutParams.WRAP_CONTENT);
					adView.setLayoutParams(params);
					adView.loadAd(VeamUtil.getAdRequest());
					return adView;
				}
			} else {
				LinearLayout view = new LinearLayout(videosActivity) ;
				view.setTag(position) ;
				view.setOrientation(LinearLayout.VERTICAL) ;
				view.setBackgroundColor(Color.TRANSPARENT) ;
				view.setPadding(0, 1, 0, 0) ;
				return view ;
			}
		}

		LinearLayout.LayoutParams layoutParams ;

		LinearLayout view = new LinearLayout(videosActivity) ;
		view.setId(VideosActivity.VIEWID_YOUTUBE_CATEGORY) ;
		view.setTag(Integer.valueOf(position)) ;
		view.setOrientation(LinearLayout.HORIZONTAL) ;
		if(position == 0){
			view.setBackgroundColor(Color.TRANSPARENT) ;
			view.setPadding(0, topMargin, 0, 0) ;
			
			Typeface typefaceRobotoLightItalic = Typeface.createFromAsset(this.videosActivity.getAssets(), "Roboto-LightItalic.ttf");
			FontFitTextView bulletinTextView = new FontFitTextView(videosActivity,scaledDensity) ;
            bulletinTextView.setBackgroundColor(VeamUtil.getColorFromArgbString("FFFF8ACF")) ;


            /*
			int padding = listWidth*3/100 ;
			bulletinTextView.setPadding(padding,padding,padding,0) ;
			bulletinTextView.setTypeface(typefaceRobotoLightItalic) ;
			layoutParams = new LinearLayout.LayoutParams(listWidth/2,listWidth/2) ;
			view.addView(bulletinTextView,layoutParams) ;
			*/
			
			//VeamUtil.log("debug","fontsize:" + bulletinTextView.getTextSize()) ;

            ImageView headerLeftImageView = new ImageView(videosActivity) ;
            //headerRightImageView.setImageResource(R.drawable.t1_top_right) ;
            headerLeftImageView.setImageBitmap(VeamUtil.getThemeImage(videosActivity,"t1_top_left",1)) ;
            headerLeftImageView.setScaleType(ScaleType.FIT_XY) ;
            layoutParams = new LinearLayout.LayoutParams(listWidth/2,listWidth/2) ;
            view.addView(headerLeftImageView,layoutParams) ;

            ImageView headerRightImageView = new ImageView(videosActivity) ;
            //headerRightImageView.setImageResource(R.drawable.t1_top_right) ;
            headerRightImageView.setImageBitmap(VeamUtil.getThemeImage(videosActivity,"t1_top_right",1)) ;
            headerRightImageView.setScaleType(ScaleType.FIT_XY) ;
            layoutParams = new LinearLayout.LayoutParams(listWidth/2,listWidth/2) ;
            view.addView(headerRightImageView,layoutParams) ;


            return view ;
		}
		
		view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
		
		
		
		int cellHeight = this.listWidth*14/100 ;
		
		Typeface typeface = Typeface.createFromAsset(this.videosActivity.getAssets(), "Roboto-Light.ttf");
		
		RelativeLayout contentLayout = new RelativeLayout(videosActivity) ;
		contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
		layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
		view.addView(contentLayout,layoutParams) ;

		if(position == 2) {
			View lineView = new View(videosActivity);
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00));
			RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth * 95 / 100, 1);
			relativeLayoutParams.setMargins(this.listWidth * 5 / 100, 0, 0, 0);
			contentLayout.addView(lineView, relativeLayoutParams);
		}



		LinearLayout nameView = new LinearLayout(videosActivity) ;
		nameView.setOrientation(LinearLayout.HORIZONTAL) ;
		nameView.setPadding(0, 0, 0, 0) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*84/100, cellHeight) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,0, 0, 0) ;
		contentLayout.addView(nameView,relativeLayoutParams) ;
		
		TextView textView = new TextView(videosActivity) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText(categoryName) ;
		if(position == 2){
            //textView.setTextColor(VeamUtil.getColorFromArgbString("FFFF91D1")) ;
            textView.setTextColor(VeamUtil.getLinkTextColor(videosActivity)) ;
		}
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)listWidth * 5.2f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;
		
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, cellHeight) ;
		nameView.addView(textView,linearLayoutParams) ;
		
		if(position == 2){
			ImageView imageView ;
			imageView = new ImageView(videosActivity) ;
            /*
			imageView.setImageResource(R.drawable.list_clip) ; // 50x80
			imageView.setScaleType(ScaleType.FIT_XY) ;
			linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*562/1000,cellHeight*90/100) ;
			linearLayoutParams.setMargins(listWidth*5/1000, cellHeight*5/100, 0, 0) ;
			nameView.addView(imageView,linearLayoutParams) ;
            */
            imageView.setImageBitmap(VeamUtil.getThemeImage(videosActivity,"list_clip",1));
            imageView.setScaleType(ScaleType.FIT_XY) ;
            linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*36/100,cellHeight*50/100) ;
            linearLayoutParams.setMargins(listWidth*1/100, cellHeight*25/100, 0, 0) ;
            nameView.addView(imageView,linearLayoutParams) ;

        }

		ImageView imageView ;
		imageView = new ImageView(videosActivity) ;
		imageView.setImageResource(R.drawable.setting_arrow) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
		relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*4/100, 0, 0) ;
		contentLayout.addView(imageView,relativeLayoutParams) ;
		
		View lineView = new View(videosActivity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		return view ;	
	}

}
