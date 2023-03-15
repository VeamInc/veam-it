package co.veam.veam31000287;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.text.Layout;
import android.text.TextPaint;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

public class MessageAdapter extends LoadMoreAdapter {

	private static int VIEWID_TITLE			= 0x50001 ;
	//private static int VIEWID_IMAGE			= 0x50002 ;
	private static int VIEWID_DURATION		= 0x50003 ;
	public  static int VIEWID_TEXT			= 0x50004 ;
	//private static int VIEWID_PROGRESS		= 0x50005 ;
	private static int VIEWID_ARROW			= 0x50006 ;
	//private static int VIEWID_DELETE		= 0x50007 ;
	private static int VIEWID_YEAR			= 0x50008 ;
	public static int VIEWID_USER_ICON		= 0x50009 ;
	public static int VIEWID_USER_NAME		= 0x5000A ;

	private MessageAdapterActivityInterface messageActivity ;
	private Context context ;
	
	ArrayList<MessageObject> messages ;
	ArrayList<MessageUserObject> messageUsers ;
	
	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private String socialUserId ;
	private TextView topTextView = null ;
	private RelativeLayout topContentView = null ;
	private boolean updating = false ;
	private boolean loadingMore = false ;
	
	
	public MessageAdapter(MessageAdapterActivityInterface activity,Context context,MessageXml messageXml,int width,int topMargin,float scaledDensity)
	{
		this.messageActivity = activity ;
		this.context = context ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.setMessages(messageXml) ;
		this.setSocialUserId() ;
	}
	
	public void setSocialUserId(){
		this.socialUserId = VeamUtil.getSocialUserId(context) ; 
	}
	
	public void setMessages(MessageXml messageXml){
		if(messageXml != null){
			this.messages = messageXml.getMessages() ;
			this.messageUsers = messageXml.getMessageUsers() ;
		}
		updating = false ;
	}
	
	public boolean hasMessage(String messageId){
		boolean retBool = false ;
		if(messages != null){
			int count = messages.size() ;
			for(int index = 0 ; index < count ; index++){
				MessageObject message = messages.get(index) ;
				if(messageId.equals(message.getId())){
					retBool = true ;
					break ;
				}
			}
		}
		return retBool ;
	}
	
	public boolean hasMessageUser(String socialUserId){
		boolean retBool = false ;
		if(this.getMessageUserForId(socialUserId) != null){
			retBool = true ;
		}
		return retBool ;
	}
	
	public MessageUserObject getMessageUserForId(String socialUserId){
		MessageUserObject retValue = null ;
		if(messageUsers != null){
			int count = messageUsers.size() ;
			for(int index = 0 ; index < count ; index++){
				MessageUserObject messageUser = messageUsers.get(index) ;
				if(socialUserId.equals(messageUser.getSocialUserId())){
					retValue = messageUser ;
					break ;
				}
			}
		}
		return retValue ;
	}

	
	public void addMessages(MessageXml messageXml){
		loadingMore = false ;
		if(messages == null){
			messages = new ArrayList<MessageObject>() ;
		}
		ArrayList<MessageObject> workMessages = messageXml.getMessages() ;
		int count = workMessages.size() ;
		for(int index = 0 ; index < count ; index++){
			MessageObject message = workMessages.get(index) ;
			if(!this.hasMessage(message.getId())){
				messages.add(message) ;
			}
		}
		
		if(messageUsers == null){
			messageUsers = new ArrayList<MessageUserObject>() ;
		}
		ArrayList<MessageUserObject> workMessageUsers = messageXml.getMessageUsers() ;
		count = workMessageUsers.size() ;
		for(int index = 0 ; index < count ; index++){
			MessageUserObject messageUser = workMessageUsers.get(index) ;
			if(!this.hasMessageUser(messageUser.getSocialUserId())){
				messageUsers.add(messageUser) ;
			}
		}

	}
	
	public void deleteMessageObject(MessageObject messageObject){
		messages.remove(messageObject) ;
	}
	


	@Override
	public int getCount() {
		int retValue = 0 ; 
		if(messages != null){
			retValue = messages.size()+1 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		MessageObject retValue = null ;
		if(position > 0){
			retValue = messages.get(position-1) ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}
	
	public void setTopText(String text){
		if(topTextView != null){
			topTextView.setText(text) ;
		}
	}
	
	public void setUpdating(){
		if(!loadingMore){
			loadingMore = true ;
			this.notifyDataSetChanged() ;
			messageActivity.loadMoreMessage() ;
		}
	}

	@Override
	public void setLoadingMore(){
		updating = true ;
		this.notifyDataSetChanged() ;
		messageActivity.reloadMessage() ;
	}

	
	
	
	
	
	
	
	
	
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//VeamUtil.log("debug","getView:"+position) ;
		
		MessageObject messageObject = (MessageObject)this.getItem(position) ;
		if(messageObject == null){
			//VeamUtil.log("debug","messageObject==null position="+position) ;
		}
		

		//int imageWidth = listWidth*4/15 ; // listWidth*20*4/3/100
		//int imageHeight = listWidth*3/15 ; // listWidth*20/100
		String title = "" ;
		
		
		boolean isMyMessage = false ;
		if(messageObject != null){
			isMyMessage = messageObject.getFromUserId().equals(socialUserId) ;
		}

		if(position > 0){
			if(messageObject != null){
				MessageUserObject messageUserObject = this.getMessageUserForId(messageObject.getFromUserId()) ;
				if(messageUserObject != null){
					if(isMyMessage){
						title = String.format("%s   ", messageUserObject.getName()) ;
					} else {
						title = messageUserObject.getName() ;
					}
				}
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
		/*
		if(tag != 0){
			view = (LinearLayout)convertView ;
		}
		*/
		
		if(position == 0){
			view = new LinearLayout(context) ;
			view.setTag(Integer.valueOf(position)) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			view.setPadding(0, topMargin, 0, 0) ;
			return view ;
		}

		//VeamUtil.log("debug","position="+position) ;

		Typeface typeface = Typeface.createFromAsset(context.getAssets(), "Roboto-Light.ttf") ;

		int margin = listWidth * 3 / 100 ;
		int yearMargin = listWidth * 5 / 1000 ;
		int arrowWidth = listWidth * 3 / 100 ;
		int dateWidth = listWidth * 12 / 100 ;
		int iconWidth = listWidth * 12 / 100 ;
		int textWidth = listWidth-(margin*2+arrowWidth+dateWidth+iconWidth) ;
		int textPadding = listWidth * 2 / 100 ;
		int leftTextPadding = listWidth * 3 / 100 ;
		
		if(view == null){

			view = new LinearLayout(context) ;
			view.setTag(Integer.valueOf(0)) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setPadding(margin, 0, margin, 0) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			
			//LinearLayout.LayoutParams layoutParams ;
			
			//int cellHeight = this.listWidth*25/100 ;
			
			LinearLayout.LayoutParams linearLayoutParams ;
			
			TextView textView = new TextView(context) ;
			textView.setId(VIEWID_YEAR) ;
			textView.setBackgroundColor(Color.TRANSPARENT) ;
			textView.setGravity(Gravity.CENTER) ;
			textView.setPadding(0, yearMargin, 0, yearMargin) ;
			textView.setTextSize((float)listWidth * 3.5f / 100 / scaledDensity) ;
			textView.setTypeface(typeface) ;
			textView.setMaxLines(1) ;
			textView.setText("Year") ;
			textView.setTextColor(VeamUtil.getColorFromArgbString("FF000000")) ;
			textView.setBackgroundResource(R.drawable.textline_gray) ;
			linearLayoutParams = new LinearLayout.LayoutParams(listWidth*30/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
			linearLayoutParams.gravity = Gravity.CENTER_HORIZONTAL ;
			linearLayoutParams.setMargins(0, listWidth*2/100, 0, listWidth*2/100) ;
			view.addView(textView,linearLayoutParams) ;
			
			LinearLayout messageArea = new LinearLayout(context) ;
			messageArea.setOrientation(LinearLayout.HORIZONTAL) ;
			messageArea.setBackgroundColor(Color.TRANSPARENT) ;
			view.addView(messageArea) ;
			
			CircleImageView userIconImageView = new CircleImageView(context) ;
			userIconImageView.setId(VIEWID_USER_ICON) ;
			userIconImageView.setScaleType(ScaleType.CENTER_CROP) ;
			linearLayoutParams = new LinearLayout.LayoutParams(iconWidth, iconWidth) ;
			linearLayoutParams.setMargins(0, listWidth*1/100, 0,0) ;
			messageArea.addView(userIconImageView,linearLayoutParams) ;

			if(isMyMessage){
				LinearLayout messageRightArea = new LinearLayout(context) ;
				messageRightArea.setOrientation(LinearLayout.VERTICAL) ;
				messageRightArea.setBackgroundColor(Color.TRANSPARENT) ;
				messageRightArea.setGravity(Gravity.RIGHT) ;
				linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
				messageArea.addView(messageRightArea) ;
	
				textView = new TextView(context) ;
				textView.setId(VIEWID_TITLE) ;
				textView.setBackgroundColor(Color.TRANSPARENT) ;
				textView.setGravity(Gravity.CENTER_VERTICAL|Gravity.RIGHT) ;
				textView.setPadding(listWidth*2/100, 0, 0, 0) ;
				textView.setTextSize((float)listWidth * 3.5f / 100 / scaledDensity) ;
				textView.setTypeface(typeface) ;
				textView.setMaxLines(1) ;
				textView.setTextColor(VeamUtil.getColorFromArgbString("FF6D6D6D")) ;
				linearLayoutParams = new LinearLayout.LayoutParams(this.listWidth, LinearLayout.LayoutParams.WRAP_CONTENT) ; 
				messageRightArea.addView(textView,linearLayoutParams) ;
	
				LinearLayout textArea = new LinearLayout(context) ;
				textArea.setOrientation(LinearLayout.HORIZONTAL) ;
				textArea.setBackgroundColor(Color.TRANSPARENT) ;
				linearLayoutParams = new LinearLayout.LayoutParams(this.listWidth, LinearLayout.LayoutParams.WRAP_CONTENT) ;
				linearLayoutParams.setMargins(0, 0, 0, listWidth*6/100) ;
				messageRightArea.addView(textArea,linearLayoutParams) ;
				
				textView = new TextView(context) ;
				textView.setId(VIEWID_DURATION) ;
				textView.setBackgroundColor(Color.TRANSPARENT) ;
				textView.setGravity(Gravity.BOTTOM|Gravity.RIGHT) ;
				textView.setPadding(listWidth*1/100, 0, 0, 0) ;
				textView.setTextSize((float)listWidth * 3.2f / 100 / scaledDensity) ;
				textView.setTypeface(typeface) ;
				textView.setMaxLines(1) ;
				textView.setText("00:00") ;
				textView.setTextColor(VeamUtil.getColorFromArgbString("FF6D6D6D")) ;
				linearLayoutParams = new TableRow.LayoutParams(dateWidth, LinearLayout.LayoutParams.WRAP_CONTENT,1.0f) ;
				linearLayoutParams.gravity = Gravity.BOTTOM | Gravity.RIGHT ;
				textArea.addView(textView,linearLayoutParams) ;

				final TextView copyTextView = new TextView(context) ;
				copyTextView.setId(VIEWID_TEXT) ;
				//copyTextView.setOnClickListener(context) ;
				copyTextView.setBackgroundColor(Color.TRANSPARENT) ;
				copyTextView.setGravity(Gravity.CENTER_VERTICAL) ;
				copyTextView.setPadding(leftTextPadding,textPadding,textPadding,textPadding) ;
				copyTextView.setTextSize((float)listWidth * 4.3f / 100 / scaledDensity) ;
				copyTextView.setTypeface(typeface) ;
				linearLayoutParams = new TableRow.LayoutParams(textWidth, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ; 
				textArea.addView(copyTextView,linearLayoutParams) ;
	
				ImageView imageView ;
				imageView = new ImageView(context) ;
				imageView.setId(VIEWID_ARROW) ;
				imageView.setImageResource(R.drawable.pick_blue) ;
				imageView.setScaleType(ScaleType.FIT_START) ;
				linearLayoutParams = new LinearLayout.LayoutParams(arrowWidth, LinearLayout.LayoutParams.WRAP_CONTENT) ;
				linearLayoutParams.setMargins(-5, 0, 0, 0) ;
				textArea.addView(imageView,linearLayoutParams) ;
	
				
			} else {
				LinearLayout messageRightArea = new LinearLayout(context) ;
				messageRightArea.setOrientation(LinearLayout.VERTICAL) ;
				messageRightArea.setBackgroundColor(Color.TRANSPARENT) ;
				linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
				messageArea.addView(messageRightArea) ;
	
				textView = new TextView(context) ;
				textView.setId(VIEWID_TITLE) ;
				textView.setBackgroundColor(Color.TRANSPARENT) ;
				textView.setGravity(Gravity.CENTER_VERTICAL) ;
				textView.setPadding(listWidth*2/100, 0, 0, 0) ;
				textView.setTextSize((float)listWidth * 3.5f / 100 / scaledDensity) ;
				textView.setTypeface(typeface) ;
				textView.setMaxLines(1) ;
				textView.setTextColor(VeamUtil.getColorFromArgbString("FF6D6D6D")) ;
				linearLayoutParams = new LinearLayout.LayoutParams(this.listWidth, LinearLayout.LayoutParams.WRAP_CONTENT) ; 
				messageRightArea.addView(textView,linearLayoutParams) ;
	
				LinearLayout textArea = new LinearLayout(context) ;
				textArea.setOrientation(LinearLayout.HORIZONTAL) ;
				textArea.setBackgroundColor(Color.TRANSPARENT) ;
				linearLayoutParams = new LinearLayout.LayoutParams(this.listWidth, LinearLayout.LayoutParams.WRAP_CONTENT) ;
				linearLayoutParams.setMargins(0, 0, 0, listWidth*6/100) ;
				messageRightArea.addView(textArea,linearLayoutParams) ;
				
				ImageView imageView ;
				imageView = new ImageView(context) ;
				imageView.setId(VIEWID_ARROW) ;
				imageView.setImageResource(R.drawable.pick_blue) ;
				imageView.setScaleType(ScaleType.FIT_START) ;
				linearLayoutParams = new LinearLayout.LayoutParams(arrowWidth, LinearLayout.LayoutParams.WRAP_CONTENT) ; 
				textArea.addView(imageView,linearLayoutParams) ;
	
				final TextView copyTextView = new TextView(context) ;
				copyTextView.setId(VIEWID_TEXT) ;
				//copyTextView.setOnClickListener(context) ;
				copyTextView.setBackgroundColor(Color.TRANSPARENT) ;
				copyTextView.setGravity(Gravity.CENTER_VERTICAL) ;
				copyTextView.setPadding(leftTextPadding,textPadding,textPadding,textPadding) ;
				copyTextView.setTextSize((float)listWidth * 4.3f / 100 / scaledDensity) ;
				copyTextView.setTypeface(typeface) ;
				linearLayoutParams = new TableRow.LayoutParams(textWidth, LinearLayout.LayoutParams.WRAP_CONTENT,0.0f) ; 
				textArea.addView(copyTextView,linearLayoutParams) ;
	
				textView = new TextView(context) ;
				textView.setId(VIEWID_DURATION) ;
				textView.setBackgroundColor(Color.TRANSPARENT) ;
				textView.setGravity(Gravity.BOTTOM) ;
				textView.setPadding(listWidth*1/100, 0, 0, 0) ;
				textView.setTextSize((float)listWidth * 3.2f / 100 / scaledDensity) ;
				textView.setTypeface(typeface) ;
				textView.setMaxLines(1) ;
				textView.setText("00:00") ;
				textView.setTextColor(VeamUtil.getColorFromArgbString("FF6D6D6D")) ;
				linearLayoutParams = new TableRow.LayoutParams(dateWidth, LinearLayout.LayoutParams.WRAP_CONTENT,1.0f) ;
				linearLayoutParams.gravity = Gravity.BOTTOM ;
				textArea.addView(textView,linearLayoutParams) ;
			}
		}
		
		
		
		TextView yearTextView = (TextView)view.findViewById(VIEWID_YEAR) ;
		String year = this.getDisplayDate(position) ;
		if(VeamUtil.isEmpty(year)){
			yearTextView.setVisibility(View.GONE) ; 
		} else {
			yearTextView.setVisibility(View.VISIBLE) ;
			yearTextView.setText(year) ; 
		}
		
		TextView titleTextView = (TextView)view.findViewById(VIEWID_TITLE) ;
		titleTextView.setText(title);

		TextView textTextView = (TextView)view.findViewById(VIEWID_TEXT) ;
		String messageText = messageObject.getText() ;
		textTextView.setText(messageText);
		TextPaint paint = textTextView.getPaint() ;
		int resizeTextWidth = (int)Layout.getDesiredWidth(messageObject.getText(), paint) + (leftTextPadding + textPadding) ;
		resizeTextWidth = resizeTextWidth * 105 / 100 ;
		if(resizeTextWidth > textWidth){
			resizeTextWidth = textWidth ;
		}
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(resizeTextWidth, LinearLayout.LayoutParams.WRAP_CONTENT) ; 
		textTextView.setLayoutParams(linearLayoutParams) ;
		
		ImageView imageView = (ImageView)view.findViewById(VIEWID_ARROW) ;

		
		if(isMyMessage){
			textTextView.setBackgroundResource(R.drawable.textline_gray) ;
			imageView.setImageResource(R.drawable.pick_right_gray) ;
		} else {
			imageView.setImageResource(R.drawable.pick_blue) ;
			textTextView.setBackgroundResource(R.drawable.textline_blue) ;
			
			CircleImageView userIconImageView = (CircleImageView)view.findViewById(VIEWID_USER_ICON) ;
			userIconImageView.setTag(Integer.valueOf(position)) ;
			MessageUserObject messageUserObject = this.getMessageUserForId(messageObject.getFromUserId()) ;
			String imageUrl = "" ;
			if(messageUserObject != null){
				imageUrl = messageUserObject.getImageUrl() ;
			}
			Bitmap icomBitmap = VeamUtil.getCachedFileBitmapWithWidth(context, imageUrl, iconWidth,1, false) ;
			if(icomBitmap == null){
				userIconImageView.setImageDrawable(new ColorDrawable(Color.argb(0,0,0,0))) ;
				LoadImageTask loadImageTask = new LoadImageTask(context,imageUrl,userIconImageView,iconWidth,position,null) ;
				loadImageTask.execute("") ;
			} else {
				userIconImageView.setImageBitmap(icomBitmap) ;
				icomBitmap = null ;
			}
		}


		String text = VeamUtil.getMessageTimeString(messageObject.getCreatedAt()) ;
		if(isMyMessage){
			text = String.format("%s ", text) ;
		}
		TextView durationTextView = (TextView)view.findViewById(VIEWID_DURATION) ;
		durationTextView.setText(text);
		


		/*
		ImageView thumbnailImageView = (ImageView)view.findViewById(VIEWID_IMAGE) ;
		thumbnailImageView.setTag(Integer.valueOf(position)) ;
		String imageUrl = videoObject.getImageUrl() ;
		//VeamUtil.log("debug","imageUrl:"+imageUrl) ;
		Bitmap bitmap = VeamUtil.getCachedFileBitmapWithWidth(textlineActivity, imageUrl, imageWidth,2, false) ;
		if(bitmap == null){
			thumbnailImageView.setImageDrawable(new ColorDrawable(Color.argb(0,0,0,0))) ;
			LoadImageTask loadImageTask = new LoadImageTask(textlineActivity,videoObject.getImageUrl(),thumbnailImageView,imageWidth,position,null) ;
			loadImageTask.execute("") ;
		} else {
			thumbnailImageView.setImageBitmap(bitmap) ;
			bitmap = null ;
		}
		*/
		
		
		view.setTag(Integer.valueOf(position)) ;
	
		return view ;	
	}
	
	public String getDisplayDate(int position){
		String retValue = null ; 
		MessageObject messageObject = (MessageObject)getItem(position) ;
		if(messageObject != null){
			String currentDate = VeamUtil.getMessageDateString(messageObject.getCreatedAt()) ;
			MessageObject previousMessageObject = (MessageObject)getItem(position-1) ;
			String previousYear = "" ;
			if(previousMessageObject != null){
				previousYear = VeamUtil.getMessageDateString(previousMessageObject.getCreatedAt()) ;
			}
			if(!currentDate.equals(previousYear)){
				retValue = currentDate ;
			}
		}
		
		return retValue ;
	}

	
	
	
	
	
	
	public interface  MessageAdapterActivityInterface {
		public void reloadMessage() ;
		public void loadMoreMessage() ;
		public void onMessageLoadFailed() ;
		public void updateMessage(MessageXml messageXml,int pageNo) ;
		public void onMessageSend(Integer result) ;
	}


}
