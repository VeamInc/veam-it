package co.veam.veam31000287;

import java.util.GregorianCalendar;

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

public class SellItemCategoryAdapter extends BaseAdapter {

	private int listWidth ;

	private SellItemCategoryActivity activity ;
	private int topMargin ;
	private float scaledDensity ;
	private SellItemCategoryObject[] sellItemCategoryObjects ;
	private GregorianCalendar today ;


	public SellItemCategoryAdapter(SellItemCategoryActivity activity, SellItemCategoryObject[] sellItemCategoryObjects, int width, int topMargin, float scaledDensity)
	{
		this.activity = activity ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.sellItemCategoryObjects = sellItemCategoryObjects ;
		this.today = new GregorianCalendar() ;
	}

	@Override
	public int getCount() {
		int retValue = 0 ;
		if(sellItemCategoryObjects != null){
			retValue = sellItemCategoryObjects.length + 1 ; // + top
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		SellItemCategoryObject retValue = null ;

		if((position > 0) && (sellItemCategoryObjects != null)){
			retValue = sellItemCategoryObjects[position-1] ;
		}

		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {

		//VeamUtil.log("debug","SellItemCategoryAdapter::getView "+position) ;

		SellItemCategoryObject sellItemCategoryObject = (SellItemCategoryObject)this.getItem(position) ;
		String categoryName = "" ;
		if(position > 0){
			if(sellItemCategoryObject != null){
				categoryName = this.getCategoryName(sellItemCategoryObject) ;
			}
		}

		LinearLayout.LayoutParams layoutParams ;

		LinearLayout view = new LinearLayout(activity) ;
		view.setId(activity.VIEWID_VIDEO_CATEGORY) ;
		view.setTag(Integer.valueOf(position)) ;
		view.setOrientation(LinearLayout.HORIZONTAL) ;

		//VeamUtil.log("debug", "before typeface:" + System.currentTimeMillis()) ;
		Typeface typeface = Typeface.createFromAsset(this.activity.getAssets(), "Roboto-Light.ttf");
		//VeamUtil.log("debug","after typeface:"+System.currentTimeMillis()) ;

		if(position == 0){
			view.setBackgroundColor(Color.TRANSPARENT) ;
			view.setPadding(0, topMargin, 0, 0) ;

			/*
			RelativeLayout calendarArea = new RelativeLayout(this.activity) ;
			//calendarArea.setBackgroundColor(VeamUtil.getColorFromArgbString("FFFF61BC")) ;
			calendarArea.setBackgroundColor(VeamUtil.getLinkTextColor(activity)) ;
			//calendarArea.setOrientation(LinearLayout.VERTICAL) ;
			layoutParams = new LinearLayout.LayoutParams(listWidth/2,listWidth/2) ;
			view.addView(calendarArea,layoutParams) ;

			RelativeLayout.LayoutParams relativeLayoutParams ;
			Typeface typefaceRobotoThin = Typeface.createFromAsset(this.activity.getAssets(), "Roboto-Thin.ttf");
			Typeface typefaceRobotoLight = Typeface.createFromAsset(this.activity.getAssets(), "Roboto-Light.ttf");
			Typeface typefaceRobotoItalic = Typeface.createFromAsset(this.activity.getAssets(), "Roboto-Italic.ttf");

			String weekdayString = VeamUtil.getShorthandForWeekday(today.get(Calendar.DAY_OF_WEEK), VeamUtil.VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL) ;
			TextView textView = new TextView(this.activity);
			textView.setText(weekdayString);
			textView.setTypeface(typefaceRobotoLight);
			textView.setTextColor(Color.WHITE);
			textView.setGravity(Gravity.BOTTOM|Gravity.CENTER_HORIZONTAL) ;
			textView.setTextSize((float) listWidth * 5.5f / 100 / scaledDensity) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth/2,listWidth*14/100);
			relativeLayoutParams.setMargins(0, 0, 0, 0) ;
			calendarArea.addView(textView, relativeLayoutParams) ;


			textView = new TextView(this.activity);
			textView.setText(String.format("%d", today.get(Calendar.DAY_OF_MONTH)));
			textView.setTextColor(Color.WHITE);
			textView.setTypeface(typefaceRobotoThin);
			textView.setGravity(Gravity.CENTER) ;
			textView.setTextSize((float) listWidth * 20.0f / 100 / scaledDensity) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth/2,listWidth*26/100);
			relativeLayoutParams.setMargins(0, listWidth * 12 / 100, 0, 0) ;
			calendarArea.addView(textView, relativeLayoutParams) ;

			String monthString = VeamUtil.getNameForMonth(today.get(Calendar.MONTH)+1) ;
			textView = new TextView(this.activity) ;
			textView.setText(monthString);
			textView.setTypeface(typefaceRobotoItalic);
			textView.setTextColor(Color.WHITE);
			textView.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL) ;
			textView.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth/2,listWidth*12/100);
			relativeLayoutParams.setMargins(0, listWidth * 38 / 100, 0, 0);
			calendarArea.addView(textView, relativeLayoutParams) ;

			*/

			ImageView headerLeftImageView = new ImageView(activity);
			headerLeftImageView.setImageBitmap(VeamUtil.getThemeImage(activity, "video_left", 1)) ;
			headerLeftImageView.setScaleType(ScaleType.FIT_XY) ;
			layoutParams = new LinearLayout.LayoutParams(listWidth/2,listWidth/2) ;
			view.addView(headerLeftImageView,layoutParams) ;

			ImageView headerRightImageView = new ImageView(activity);
			headerRightImageView.setImageBitmap(VeamUtil.getThemeImage(activity,"t8_top_right",1)) ;
			headerRightImageView.setScaleType(ScaleType.FIT_XY) ;
			layoutParams = new LinearLayout.LayoutParams(listWidth/2,listWidth/2) ;
			view.addView(headerRightImageView,layoutParams) ;

			return view ;
		}

		view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;





		int cellHeight = this.listWidth*14/100 ;


		RelativeLayout contentLayout = new RelativeLayout(activity) ;
		contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
		layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
		view.addView(contentLayout,layoutParams) ;


		LinearLayout nameView = new LinearLayout(activity) ;
		nameView.setOrientation(LinearLayout.HORIZONTAL) ;
		nameView.setPadding(0, 0, 0, 0) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*84/100, cellHeight) ;
		relativeLayoutParams.setMargins(this.listWidth * 5 / 100, 0, 0, 0) ;
		contentLayout.addView(nameView, relativeLayoutParams) ;

		TextView textView = new TextView(activity) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText(categoryName) ;
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)listWidth * 5.2f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;

		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, cellHeight) ;
		nameView.addView(textView,linearLayoutParams) ;

		ImageView imageView ;
		imageView = new ImageView(activity) ;
		imageView.setImageResource(R.drawable.setting_arrow) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
		relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*4/100, 0, 0) ;
		contentLayout.addView(imageView,relativeLayoutParams) ;

		View lineView = new View(activity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		return view ;
	}


	public String getCategoryName(SellItemCategoryObject sellItemCategoryObject){
		String name = "" ;
		String kind = sellItemCategoryObject.getKind() ;
		if(kind.equals(SellItemCategoryObject.KIND_VIDEO_CATEGORY)){
			VideoCategoryObject videoCategoryObject = VeamUtil.getVideoCategoryObject(activity.getDb(),sellItemCategoryObject.getTargetCategoryId()) ;
			if(videoCategoryObject != null){
				name = videoCategoryObject.getName() ;
			}
		} else if(kind.equals(SellItemCategoryObject.KIND_PDF_CATEGORY)) {
			PdfCategoryObject pdfCategoryObject = VeamUtil.getPdfCategoryObject(activity.getDb(), sellItemCategoryObject.getTargetCategoryId());
			if (pdfCategoryObject != null) {
				name = pdfCategoryObject.getName();
			}
		} else if(kind.equals(SellItemCategoryObject.KIND_AUDIO_CATEGORY)) {
			AudioCategoryObject audioCategoryObject = VeamUtil.getAudioCategoryObject(activity.getDb(), sellItemCategoryObject.getTargetCategoryId());
			if (audioCategoryObject != null) {
				name = audioCategoryObject.getName();
			}
		}

		return name ;
	}

}
