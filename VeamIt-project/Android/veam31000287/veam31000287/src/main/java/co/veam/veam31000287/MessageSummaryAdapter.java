package co.veam.veam31000287;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.text.Html;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MessageSummaryAdapter extends LoadMoreAdapter {

	private MessageSummaryAdapterActivityInterface messageSummaryActivity ;
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
	
	public static int VIEWID_USER_ICON			= 0x50001 ;
	public static int VIEWID_USER_NAME			= 0x50002 ;
	public static int VIEWID_TIME				= 0x50003 ;
	public static int VIEWID_READ_MARK			= 0x50004 ;
	
	public MessageSummaryAdapter(MessageSummaryAdapterActivityInterface activity,Context context,MessageXml messageXml,int width,int topMargin,float scaledDensity)
	{
		this.messageSummaryActivity = activity ;
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
		updating = true ;
		this.notifyDataSetChanged() ;
		messageSummaryActivity.reloadMessageSummary() ;
	}

	@Override
	public void setLoadingMore(){
		if(!loadingMore){
			loadingMore = true ;
			this.notifyDataSetChanged() ;
			messageSummaryActivity.loadMoreMessageSummary() ;
		}
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//VeamUtil.log("debug","getView:"+position) ;
		
		MessageObject messageObject = (MessageObject)this.getItem(position) ;
		String userName = "" ;
		MessageUserObject messageUserObject = null ;
		if(messageObject != null){
			messageUserObject = this.getMessageUserForId(messageObject.getFromUserId()) ;
		}

		
		if(position > 0){
			if(messageObject != null){
				if(messageUserObject != null){
					userName = messageUserObject.getName() ;
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
		if(tag != 0){
			view = (LinearLayout)convertView ;
		}
		
		LinearLayout.LayoutParams linearLayoutParams ;
		RelativeLayout.LayoutParams relativeLayoutParams ;
		Typeface typefaceRobotoLight= Typeface.createFromAsset(context.getAssets(), "Roboto-Light.ttf");

		if(position == 0){
			view = new LinearLayout(context) ;
			view.setTag(Integer.valueOf(position)) ;
			//view.setOnClickListener(context) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			
			topContentView = new RelativeLayout(context) ;
			topContentView.setBackgroundColor(Color.TRANSPARENT) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, topMargin) ;
			view.addView(topContentView,linearLayoutParams) ;

			topTextView = new TextView(context) ;
			if(updating){
				view.setPadding(0, topMargin, 0, 0) ;
				topTextView.setText(context.getString(R.string.updating)) ;
			} else {
				view.setPadding(0, 0, 0, 0) ;
			}
			topTextView.setGravity(Gravity.CENTER) ;
			topTextView.setTextSize((float)listWidth * 5.8f / 100 / scaledDensity) ;
			topTextView.setTypeface(typefaceRobotoLight) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,topMargin) ;
			relativeLayoutParams.setMargins(0,0,0,0) ;
			topContentView.addView(topTextView,relativeLayoutParams) ;

			return view ;
		}
		
		int userIconSize = listWidth * 10 / 100 ;
		int cellHeight = listWidth * 14 / 100 ;
		
		if(view == null){
			view = new LinearLayout(context) ;
			view.setTag(Integer.valueOf(0)) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
			int margin = listWidth*3/100 ;
			view.setPadding(0, 0, 0, 0) ;
			
			
			RelativeLayout contentLayout = new RelativeLayout(context) ;
			contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
			view.addView(contentLayout,linearLayoutParams) ;
			
			View readMarkView = new View(context) ; 
			readMarkView.setId(VIEWID_READ_MARK) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*15/1000,LinearLayout.LayoutParams.MATCH_PARENT) ;
			relativeLayoutParams.setMargins(0,0,0,0) ;
			contentLayout.addView(readMarkView,relativeLayoutParams) ;
			
			CircleImageView userIconImageView = new CircleImageView(context) ;
			userIconImageView.setId(VIEWID_USER_ICON) ;
			userIconImageView.setScaleType(ScaleType.CENTER_CROP) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(userIconSize,userIconSize) ;
			relativeLayoutParams.setMargins(margin,(cellHeight-userIconSize)/2,0,0) ;
			contentLayout.addView(userIconImageView,relativeLayoutParams) ;
			
			TextView userNameTextView = new TextView(context) ;
			userNameTextView.setId(VIEWID_USER_NAME) ;
			userNameTextView.setBackgroundColor(Color.TRANSPARENT) ;
			userNameTextView.setTextColor(Color.rgb(0x00, 0x00, 0x00)) ;
			userNameTextView.setGravity(Gravity.CENTER_VERTICAL) ;
			userNameTextView.setPadding(0, 0, 0, 0) ;
			userNameTextView.setTextSize((float)listWidth * 4.3f / 100 / scaledDensity) ;
			userNameTextView.setTypeface(typefaceRobotoLight) ;
			userNameTextView.setMaxLines(1) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*75/100, cellHeight/2) ;
			relativeLayoutParams.setMargins(margin+this.listWidth*15/100,listWidth*6/1000, 0, 0) ;
			contentLayout.addView(userNameTextView,relativeLayoutParams) ;
			
			TextView timeTextView = new TextView(context) ;
			timeTextView.setId(VIEWID_TIME) ;
			timeTextView.setBackgroundColor(Color.TRANSPARENT) ;
			timeTextView.setTextColor(Color.rgb(0x00, 0x00, 0x00)) ;
			timeTextView.setGravity(Gravity.CENTER_VERTICAL) ;
			timeTextView.setPadding(0, 0, 0, 0) ;
			timeTextView.setTextSize((float)listWidth * 4.3f / 100 / scaledDensity) ;
			timeTextView.setTypeface(typefaceRobotoLight) ;
			timeTextView.setMaxLines(1) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*75/100, cellHeight/2) ;
			relativeLayoutParams.setMargins(margin+this.listWidth*15/100,cellHeight/2-listWidth*14/1000, 0, 0) ;
			contentLayout.addView(timeTextView,relativeLayoutParams) ;

			
			int arrowHeight = cellHeight * 30 / 100 ;
			int arrowWidth = arrowHeight * 16 / 26  ;

			ImageView arrowImageView = new ImageView(context) ;
			arrowImageView.setImageResource(R.drawable.setting_arrow) ;
			arrowImageView.setScaleType(ScaleType.FIT_XY) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(arrowWidth,arrowHeight) ;
			relativeLayoutParams.setMargins(listWidth-margin*2-arrowWidth,(cellHeight-arrowHeight)/2, 0, 0) ;
			contentLayout.addView(arrowImageView,relativeLayoutParams) ;
			
			View lineView = new View(context) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-margin,1) ;
			relativeLayoutParams.setMargins(margin,cellHeight-1, 0, 0) ;
			contentLayout.addView(lineView,relativeLayoutParams) ;


		}
		
		//if(position != (Integer)view.getTag()){
		String htmlString = null ;
		htmlString = String.format("<font color=\"#FF80BD\"><b>%s</b></font> <font color=\"#333333\">%s</font>", userName,messageObject.getText()) ;

		TextView userNameTextView = (TextView)view.findViewById(VIEWID_USER_NAME) ;
		userNameTextView.setText(Html.fromHtml(htmlString));

		TextView timeTextView = (TextView)view.findViewById(VIEWID_TIME) ;
		//timeTextView.setText(VeamUtil.getSinceFromNowString(messageObject.getCreatedAt()));

		String iconImageUrl = "" ;
		if(messageUserObject != null){
			iconImageUrl = messageUserObject.getImageUrl() ;
		}

		CircleImageView userIconImageView = (CircleImageView)view.findViewById(VIEWID_USER_ICON) ;
		userIconImageView.setTag(Integer.valueOf(position)) ;
		Bitmap icomBitmap = VeamUtil.getCachedFileBitmapWithWidth(context, iconImageUrl, userIconSize,1, false) ;
		if(icomBitmap == null){
			userIconImageView.setImageDrawable(new ColorDrawable(Color.argb(0,0,0,0))) ;
			LoadImageTask loadImageTask = new LoadImageTask(context,iconImageUrl,userIconImageView,userIconSize,position,null) ;
			loadImageTask.execute("") ;
		} else {
			userIconImageView.setImageBitmap(icomBitmap) ;
			icomBitmap = null ;
		}
		
		View readMarkView = (View)view.findViewById(VIEWID_READ_MARK) ;
		if(readMarkView != null){
			if(messageObject.getReadFlag().equals("0")){
				readMarkView.setBackgroundColor(VeamUtil.getColorFromArgbString("FFFF80BD")) ;
			} else {
				readMarkView.setBackgroundColor(Color.TRANSPARENT) ;
			}
		}

		//}
	
		view.setTag(Integer.valueOf(position)) ;
		
		return view ;	
	}
	
	public interface  MessageSummaryAdapterActivityInterface {
		public void reloadMessageSummary() ;
		public void loadMoreMessageSummary() ;
		public void onMessageSummaryLoadFailed() ;
		public void updateMessageSummary(MessageXml messageXml,int pageNo) ;
	}


}
