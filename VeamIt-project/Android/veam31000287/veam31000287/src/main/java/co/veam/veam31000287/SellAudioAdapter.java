package co.veam.veam31000287;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.text.Layout;
import android.text.TextPaint;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

public class SellAudioAdapter extends BaseAdapter {

	private SellItemCategoryActivity audioCategoryActivity ;

	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
    private SellAudioObject[] sellAudioObjects ;
    private AudioObject[] audioObjects ;
	private static int VIEWID_TITLE			= 0x50001 ;
	private static int VIEWID_IMAGE			= 0x50002 ;
	private static int VIEWID_DURATION		= 0x50003 ;
    private static int VIEWID_MASK_IMAGE	= 0x50004 ;
	private static int VIEWID_STATUS    	= 0x50005 ;
	private static int VIEWID_PRICE    		= 0x50006 ;

	public SellAudioAdapter(SellItemCategoryActivity activity, SellAudioObject[] sellAudioObjects, AudioObject[] audioObjects, int width, int topMargin, float scaledDensity)
	{
		this.audioCategoryActivity = activity ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
        this.sellAudioObjects = sellAudioObjects ;
        this.audioObjects = audioObjects ;
	}

	@Override
	public int getCount() {
		int retValue = 0 ;
		if(sellAudioObjects != null){
			retValue = sellAudioObjects.length+1 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		SellAudioObject retValue = null ;
		if(position > 0){
			retValue = sellAudioObjects[position-1] ;
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
		
		SellAudioObject sellAudioObject = (SellAudioObject)this.getItem(position) ;
		AudioObject audioObject = null ;
        if(sellAudioObject != null){
            audioObject = this.getAudioObject(sellAudioObject.getAudioId());
        }
		int imageWidth = listWidth*4/15 ; // listWidth*20*4/3/100
		int imageHeight = listWidth*3/15 ; // listWidth*20/100
		String title = "" ;
		
		
		if(position > 0){
			if(audioObject != null){
				title = audioObject.getTitle() ;
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
		//LinearLayout view = (LinearLayout)convertView ;
		LinearLayout view = null ;
		if(tag != 0){
			view = (LinearLayout)convertView ;
		}
		
		if(position == 0){
			view = new LinearLayout(audioCategoryActivity) ;
			view.setTag(Integer.valueOf(position)) ;
			//view.setOnClickListener(audioCategoryActivity) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			view.setPadding(0, topMargin, 0, 0) ;
			return view ;
		}

		Typeface typeface = Typeface.createFromAsset(this.audioCategoryActivity.getAssets(), "Roboto-Light.ttf");

		if(view == null){
			view = new LinearLayout(audioCategoryActivity) ;
			view.setId(audioCategoryActivity.VIEWID_SELL_AUDIO) ;
			view.setTag(Integer.valueOf(0)) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
			
			LinearLayout.LayoutParams layoutParams ;
			
			int cellHeight = this.listWidth*25/100 ;
			
			RelativeLayout contentLayout = new RelativeLayout(audioCategoryActivity) ;
			contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
			layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
			view.addView(contentLayout, layoutParams) ;
			
			LinearLayout textArea = new LinearLayout(audioCategoryActivity) ;
			textArea.setOrientation(LinearLayout.VERTICAL) ;
			RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*54/100, cellHeight) ;
			relativeLayoutParams.setMargins(this.listWidth*35/100,0, 0, 0) ;
			contentLayout.addView(textArea, relativeLayoutParams) ;

			View spacer = new View(this.audioCategoryActivity) ;
			LinearLayout.LayoutParams linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,1.0f) ; 
			textArea.addView(spacer, linearLayoutParams) ;

			
			TextView textView = new TextView(audioCategoryActivity) ;
			textView.setId(VIEWID_TITLE) ;
			textView.setBackgroundColor(Color.TRANSPARENT) ;
			textView.setGravity(Gravity.CENTER_VERTICAL) ;
			textView.setPadding(0, 0, 0, 0) ;
			textView.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity) ;
			textView.setTypeface(typeface) ;
			textView.setMaxLines(2) ;
			/*
			RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*54/100, cellHeight*66/100) ;
			relativeLayoutParams.setMargins(this.listWidth*35/100,cellHeight*7/100, 0, 0) ;
			*/
			linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ; 
			textArea.addView(textView, linearLayoutParams) ;


            LinearLayout statusArea = new LinearLayout(audioCategoryActivity) ;
            statusArea.setOrientation(LinearLayout.HORIZONTAL) ;
            linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ;
            textArea.addView(statusArea, linearLayoutParams) ;


            textView = new TextView(audioCategoryActivity) ;
            textView.setId(VIEWID_DURATION) ;
            textView.setBackgroundColor(Color.TRANSPARENT) ;
            textView.setGravity(Gravity.CENTER_VERTICAL) ;
            textView.setPadding(0, cellHeight * 5 / 100, 0, 0) ;
            textView.setTextSize((float) listWidth * 3.2f / 100 / scaledDensity) ;
            textView.setTypeface(typeface) ;
            textView.setMaxLines(1) ;
            textView.setText("00:00") ;
            linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ;
            statusArea.addView(textView, linearLayoutParams) ;

            textView = new TextView(audioCategoryActivity) ;
            textView.setId(VIEWID_STATUS) ;
            textView.setBackgroundColor(Color.TRANSPARENT) ;
            textView.setGravity(Gravity.CENTER_VERTICAL) ;
            textView.setPadding(cellHeight * 5 / 100, cellHeight * 5 / 100, 0, 0) ;
            textView.setTextSize((float) listWidth * 3.2f / 100 / scaledDensity) ;
            textView.setTypeface(typeface) ;
            textView.setMaxLines(1) ;
            textView.setText(audioCategoryActivity.getString(R.string.purchased)) ;
            textView.setTextColor(VeamUtil.getLinkTextColor(audioCategoryActivity)) ;
            linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ;
            statusArea.addView(textView, linearLayoutParams) ;


            spacer = new View(this.audioCategoryActivity) ;
			linearLayoutParams = new TableRow.LayoutParams(this.listWidth*54/100, LinearLayout.LayoutParams.WRAP_CONTENT,1.0f) ;
			textArea.addView(spacer,linearLayoutParams) ;
			
			
	
			ImageView imageView ;
			imageView = new ImageView(audioCategoryActivity) ;
			imageView.setImageResource(R.drawable.setting_arrow) ;
			imageView.setScaleType(ScaleType.FIT_START) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
			relativeLayoutParams.setMargins(this.listWidth * 90 / 100, this.listWidth * 10 / 100, 0, 0) ;
			contentLayout.addView(imageView, relativeLayoutParams) ;
			
			
			imageView = new ImageView(audioCategoryActivity) ;
			imageView.setId(VIEWID_IMAGE) ;
			//imageView.setImageResource(R.drawable.ic_launcher) ;
			imageView.setScaleType(ScaleType.CENTER_CROP) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(imageWidth,imageHeight) ;
			relativeLayoutParams.setMargins(this.listWidth * 5 / 100, this.listWidth * 5 / 200, 0, 0) ;
			contentLayout.addView(imageView, relativeLayoutParams) ;

            imageView = new ImageView(audioCategoryActivity) ;
            imageView.setId(VIEWID_MASK_IMAGE) ;
            imageView.setScaleType(ScaleType.CENTER_CROP) ;
            relativeLayoutParams = new RelativeLayout.LayoutParams(imageWidth,imageHeight) ;
            relativeLayoutParams.setMargins(this.listWidth * 5 / 100, this.listWidth * 5 / 200, 0, 0) ;
            contentLayout.addView(imageView, relativeLayoutParams) ;

			String priceText = sellAudioObject.getPriceText() ;
			float priceSize = (float) listWidth * 3.9f / 100 / scaledDensity ;
			int priceHeight  = (int)(imageHeight * 27 /100) ;
			textView = new TextView(audioCategoryActivity) ;
			textView.setId(VIEWID_PRICE) ;
			textView.setText(priceText) ;
			textView.setBackgroundColor(Color.TRANSPARENT) ;
			textView.setBackgroundResource(R.drawable.textline_blue);
			((GradientDrawable)textView.getBackground()).setColor(VeamUtil.getLinkTextColor(audioCategoryActivity));
			textView.setGravity(Gravity.CENTER_HORIZONTAL);
			textView.setPadding(0, 0, 0, 0);
			textView.setTextSize(priceSize) ;
			textView.setTypeface(typeface) ;
			textView.setMaxLines(1) ;
			textView.setTextColor(Color.WHITE) ;
			TextPaint paint = textView.getPaint() ;
			int priceWidth = (int) Layout.getDesiredWidth(priceText, paint) * 28 / 20 ;
			if(priceWidth > imageWidth){
				priceWidth = imageWidth ;
			}
			relativeLayoutParams = new RelativeLayout.LayoutParams(priceWidth,priceHeight) ;
			relativeLayoutParams.setMargins(this.listWidth * 5 / 100 + (imageWidth - priceWidth)/2, this.listWidth * 5 / 200 + (imageHeight-priceHeight)/2, 0, 0) ;
			contentLayout.addView(textView,relativeLayoutParams) ;

            View lineView = new View(audioCategoryActivity) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
			relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
			contentLayout.addView(lineView,relativeLayoutParams) ;
		}
		
        TextView titleTextView = (TextView)view.findViewById(VIEWID_TITLE) ;
        titleTextView.setText(title);

		String durationString = audioObject.getDuration() ;
		Integer duration = Integer.parseInt(durationString) ;
		String text = String.format("%02d:%02d", duration/60,duration%60) ;
		TextView durationTextView = (TextView)view.findViewById(VIEWID_DURATION) ;
		durationTextView.setText(text);

		ImageView thumbnailImageView = (ImageView)view.findViewById(VIEWID_IMAGE) ;
        thumbnailImageView.setTag(Integer.valueOf(position)) ;
		String imageUrl = audioObject.getRectangleThumbnailUrl() ;
		if(!VeamUtil.isEmpty(imageUrl)) {
			Bitmap bitmap = VeamUtil.getCachedFileBitmapWithWidth(audioCategoryActivity, imageUrl, imageWidth, 2, false);
			if (bitmap == null) {
				thumbnailImageView.setImageDrawable(new ColorDrawable(Color.argb(0, 0, 0, 0)));
				LoadImageTask loadImageTask = new LoadImageTask(audioCategoryActivity, imageUrl, thumbnailImageView, imageWidth, position, null);
				loadImageTask.execute("");
			} else {
				thumbnailImageView.setImageBitmap(bitmap);
				bitmap = null;
			}
		}

		TextView statusTextView = (TextView) view.findViewById(VIEWID_STATUS);
		TextView priceTextView = (TextView) view.findViewById(VIEWID_PRICE);
        ImageView maskImageView = (ImageView) view.findViewById(VIEWID_MASK_IMAGE);
		//VeamUtil.log("debug", "sellAudioObject.getId()=" + sellaudioObject.getId()) ;
        if(VeamUtil.getSellAudioIsBought(audioCategoryActivity, sellAudioObject.getId())) { // purchased
			//VeamUtil.log("debug", "bought") ;
			statusTextView.setVisibility(View.VISIBLE);
			priceTextView.setVisibility(View.GONE);
            maskImageView.setVisibility(View.GONE);
        } else {
			//VeamUtil.log("debug", "not bought") ;
			statusTextView.setVisibility(View.GONE) ;
			priceTextView.setVisibility(View.VISIBLE) ;
            maskImageView.setVisibility(View.VISIBLE) ;
            maskImageView.setImageResource(R.drawable.exclusive_99c_65) ;
        }

		view.setTag(Integer.valueOf(position)) ;
	
		return view ;	
	}

    AudioObject getAudioObject(String audioId){
        AudioObject retValue = null ;
		if(audioObjects != null) {
			for (int index = 0; index < audioObjects.length; index++) {
				if (audioId.equals(audioObjects[index].getId())) {
					retValue = audioObjects[index];
					break;
				}
			}
		}
        return retValue ;
    }
}
