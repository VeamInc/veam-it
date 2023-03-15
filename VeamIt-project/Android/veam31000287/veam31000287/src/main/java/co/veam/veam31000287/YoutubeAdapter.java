package co.veam.veam31000287;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;

public class YoutubeAdapter extends BaseAdapter {

	private VideosActivity videosActivity ;
	
	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private YoutubeObject[] youtubeObjects ;

	private AdSize adSize ;
	private String adUnitId ;

	private static int VIEWID_TITLE			= 0x50001 ;
	private static int VIEWID_IMAGE			= 0x50002 ;
	private static int VIEWID_DURATION		= 0x50003 ;
	
	public YoutubeAdapter(VideosActivity activity,YoutubeObject[] youtubeObjects,int width,int topMargin,float scaledDensity,String adUnitId,AdSize adSize)
	{
		this.videosActivity = activity ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.youtubeObjects = youtubeObjects ;
		this.adUnitId = adUnitId ;
		this.adSize = adSize ;
	}

	@Override
	public int getCount() {
		int retValue = 0 ;
		if(youtubeObjects != null){
			retValue = youtubeObjects.length+2 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		YoutubeObject retValue = null ;
		if(position > 1){
			retValue = youtubeObjects[position-2] ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//VeamUtil.log("debug","getView:"+position) ;
		
		
		YoutubeObject youtubeObject = (YoutubeObject)this.getItem(position) ;
		int imageWidth = listWidth*4/15 ; // listWidth*20*4/3/100
		int imageHeight = listWidth*3/15 ; // listWidth*20/100
		String title = "" ;
		
		
		if(position > 1){
			if(youtubeObject != null){
				title = youtubeObject.getTitle() ;
			}
		}
		Integer tag = 0 ;
		if(convertView != null){
			tag = (Integer)convertView.getTag() ;
			//VeamUtil.log("debug","convertView tag:"+tag) ;
			if((tag == 0) && (position == 0)){
				return convertView ;
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
					adView.setTag(Integer.valueOf(position));
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


		//LinearLayout view = (LinearLayout)convertView ;
		LinearLayout view = null ;
		if((tag != 0) && (tag != 1)){
			view = (LinearLayout)convertView ;
		}
		
		if(position == 0){
			view = new LinearLayout(videosActivity) ;
			view.setTag(Integer.valueOf(position)) ;
			//view.setOnClickListener(videosActivity) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			view.setPadding(0, topMargin, 0, 0) ;
			return view ;
		}


		Typeface typeface = Typeface.createFromAsset(this.videosActivity.getAssets(), "Roboto-Light.ttf");

		if(view == null){
			view = new LinearLayout(videosActivity) ;
			view.setId(VideosActivity.VIEWID_YOUTUBE) ;
			view.setTag(Integer.valueOf(0)) ;
			//view.setOnClickListener(videosActivity) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
			
			LinearLayout.LayoutParams layoutParams ;
			
			int cellHeight = this.listWidth*25/100 ;
			
			RelativeLayout contentLayout = new RelativeLayout(videosActivity) ;
			contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
			layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
			view.addView(contentLayout,layoutParams) ;

			LinearLayout textArea = new LinearLayout(videosActivity) ;
			textArea.setOrientation(LinearLayout.VERTICAL) ;
			RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*54/100, cellHeight) ;
			relativeLayoutParams.setMargins(this.listWidth*35/100,0, 0, 0) ;
			contentLayout.addView(textArea,relativeLayoutParams) ;

			View spacer = new View(this.videosActivity) ;
			LinearLayout.LayoutParams linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,1.0f) ; 
			textArea.addView(spacer,linearLayoutParams) ;

			
			TextView textView = new TextView(videosActivity) ;
			textView.setId(VIEWID_TITLE) ;
			textView.setBackgroundColor(Color.TRANSPARENT) ;
			textView.setGravity(Gravity.CENTER_VERTICAL) ;
			textView.setPadding(0, 0, 0, 0) ;
			textView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
			textView.setTypeface(typeface) ;
			textView.setMaxLines(2) ;
			/*
			RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*54/100, cellHeight*66/100) ;
			relativeLayoutParams.setMargins(this.listWidth*35/100,cellHeight*7/100, 0, 0) ;
			*/
			linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ; 
			textArea.addView(textView,linearLayoutParams) ;
			
			textView = new TextView(videosActivity) ;
			textView.setId(VIEWID_DURATION) ;
			textView.setBackgroundColor(Color.TRANSPARENT) ;
			textView.setGravity(Gravity.CENTER_VERTICAL) ;
			textView.setPadding(0, cellHeight*5/100, 0, 0) ;
			textView.setTextSize((float)listWidth * 3.2f / 100 / scaledDensity) ;
			textView.setTypeface(typeface) ;
			textView.setMaxLines(1) ;
			textView.setText("00:00") ;
			/*
			relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*54/100, cellHeight*18/100) ;
			relativeLayoutParams.setMargins(this.listWidth*35/100,cellHeight*70/100, 0, 0) ;
			*/
			linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ; 
			textArea.addView(textView,linearLayoutParams) ;
			
			spacer = new View(this.videosActivity) ;
			linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,1.0f) ; 
			textArea.addView(spacer,linearLayoutParams) ;
			
			
	
			ImageView imageView ;
			imageView = new ImageView(videosActivity) ;
			imageView.setImageResource(R.drawable.setting_arrow) ;
			imageView.setScaleType(ScaleType.FIT_START) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
			relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*10/100, 0, 0) ;
			contentLayout.addView(imageView,relativeLayoutParams) ;
			
			
			imageView = new ImageView(videosActivity) ;
			imageView.setId(VIEWID_IMAGE) ;
			//imageView.setImageResource(R.drawable.ic_launcher) ;
			imageView.setScaleType(ScaleType.CENTER_CROP) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(imageWidth,imageHeight) ;
			relativeLayoutParams.setMargins(this.listWidth*5/100,this.listWidth*5/200, 0, 0) ;
			contentLayout.addView(imageView,relativeLayoutParams) ;
			
			View lineView = new View(videosActivity) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
			relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
			contentLayout.addView(lineView,relativeLayoutParams) ;

			lineView = new View(videosActivity);
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00));
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth * 95 / 100, 1);
			relativeLayoutParams.setMargins(this.listWidth * 5 / 100, 0, 0, 0);
			contentLayout.addView(lineView, relativeLayoutParams);
		}
		
		if(position != (Integer)view.getTag()){
			TextView titleTextView = (TextView)view.findViewById(VIEWID_TITLE) ;
			titleTextView.setText(title);

			String durationString = youtubeObject.getDuration() ;
			Integer duration = Integer.parseInt(durationString) ;
			String text = String.format("%02d:%02d", duration/60,duration%60) ;
			TextView durationTextView = (TextView)view.findViewById(VIEWID_DURATION) ;
			durationTextView.setText(text);

			ImageView thumbnailImageView = (ImageView)view.findViewById(VIEWID_IMAGE) ;
			thumbnailImageView.setTag(Integer.valueOf(position)) ;
			Bitmap bitmap = VeamUtil.getCachedFileBitmapWithWidth(videosActivity, VeamUtil.getYoutubeImageUrl(videosActivity,youtubeObject.getYoutubeVideoId()), imageWidth,2, false) ;
			if(bitmap == null){
				thumbnailImageView.setImageDrawable(new ColorDrawable(Color.argb(0,0,0,0))) ;
				LoadImageTask loadImageTask = new LoadImageTask(videosActivity,VeamUtil.getYoutubeImageUrl(videosActivity,youtubeObject.getYoutubeVideoId()),thumbnailImageView,imageWidth,position,null) ;
				loadImageTask.execute("") ;
			} else {
				thumbnailImageView.setImageBitmap(bitmap) ;
				bitmap = null ;
			}
		}
	
		view.setTag(Integer.valueOf(position)) ;
	
		return view ;	
	}

}
