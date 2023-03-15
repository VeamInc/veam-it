package co.veam.veam31000287;

import java.util.ArrayList;

import co.veam.veam31000287.ProfileActivity.ProfileScreen;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.text.Html;
import android.text.Layout;
import android.text.TextPaint;
import android.text.TextUtils.TruncateAt;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class ProfileAdapter extends LoadMoreAdapter {

	public static final int TYPE_PROFILE 		= 0 ;
	public static final int TYPE_NOTIFICATION	= 1 ;
	public static final int TYPE_MAX_COUNT 		= 2 ;

	private ProfileActivity profileActivity ;
	private Context context ;
	ProfileDataXml profileDataXml ;
	
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
	
	public ProfileAdapter(ProfileActivity profileActivity,Context context,ProfileDataXml profileDataXml,int width,int topMargin,float scaledDensity)
	{
		this.profileActivity = profileActivity ;
		this.context = context ;
		this.profileDataXml = profileDataXml ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.setSocialUserId() ;
	}
	
	public void setSocialUserId(){
		this.socialUserId = VeamUtil.getSocialUserId(context) ; 
	}
	
	public void setProfileDataXml(ProfileDataXml profileDataXml){
		if(profileDataXml != null){
			this.profileDataXml = profileDataXml ;
		}
		updating = false ;
	}
	
	/*
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
	
	*/

	@Override
	public int getCount() {
		int retValue = 1 ; 
		if(profileDataXml != null){
			retValue = profileDataXml.userNotifications.size()+1 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		UserNotificationObject retValue = null ;
		if(position > 0){
			retValue = profileDataXml.userNotifications.get(position-1) ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}
	
	@Override
    public int getItemViewType(int position) {
        int itemViewType = 0 ;
		if(position == 0){
        	itemViewType = TYPE_PROFILE ;
		} else {
			itemViewType = TYPE_NOTIFICATION ;
		}

        return itemViewType ;
    }

	@Override
    public int getViewTypeCount() {
        return TYPE_MAX_COUNT ;
    }

	public void setTopText(String text){
		if(topTextView != null){
			topTextView.setText(text) ;
		}
	}
	
	public void setUpdating(){
		updating = true ;
		this.notifyDataSetChanged() ;
		profileActivity.reloadProfile() ;
	}

	@Override
	public void setLoadingMore(){
		/* ページングはしない
		if(!loadingMore){
			loadingMore = true ;
			this.notifyDataSetChanged() ;
			profileActivity.loadMoreMessageSummary() ;
		}
		*/
	}

	public MessageUserObject getMessageUserForId(String socialUserId){
		MessageUserObject retValue = null ;
		if(profileDataXml != null){
			ArrayList<MessageUserObject> messageUsers = profileDataXml.getMessageUsers() ;
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
		}
		return retValue ;
	}

	
	public View getProfileView(int position){
		//VeamUtil.log("debug","getProfileView "+position) ;
		Typeface typefaceRobotoLight = Typeface.createFromAsset(context.getAssets(), "Roboto-Light.ttf");

		int padding = listWidth * 4 / 100 ;
		int currentY = 0 ; 
		
		RelativeLayout profileView = new RelativeLayout(context) ;
		profileView.setBackgroundColor(Color.TRANSPARENT) ;
		
		LinearLayout contentView = new LinearLayout(context) ;
		contentView.setOrientation(LinearLayout.VERTICAL) ;
		contentView.setPadding(0,0,0,0) ;
		
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT) ;
		relativeLayoutParams.setMargins(0,0,0,0) ;
		profileView.addView(contentView,relativeLayoutParams) ;

		View spacerView = new View(context) ;
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(listWidth,topMargin) ;
		contentView.addView(spacerView, linearLayoutParams) ;
		currentY += topMargin ;
		
		RelativeLayout mapArea = new RelativeLayout(context) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.setMargins(padding, 0, padding, 0) ;
		contentView.addView(mapArea, linearLayoutParams) ;
		
		/*
		int mapImageSize = listWidth * 95 / 1000 ;
		int mapY = listWidth * 6 / 100 ;
		ImageView mapImageView = new ImageView(context) ;
		mapImageView.setId(ProfileActivity.VIEWID_MAP_BUTTON) ;
		mapImageView.setOnClickListener(profileActivity) ;
		mapImageView.setScaleType(ScaleType.FIT_XY) ;
		mapImageView.setImageResource(R.drawable.checkin_off) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(mapImageSize,mapImageSize) ;
		relativeLayoutParams.setMargins(0,mapY, 0, 0) ;
		mapArea.addView(mapImageView,relativeLayoutParams) ;
		*/

		int userNameHeight = listWidth*15/100 ;
		//VeamUtil.log("debug","set user name " + currentScreen.getSocialUserName()) ;
		TextView userNameTextView = new TextView(context) ;
		userNameTextView.setId(ProfileActivity.VIEWID_USER_NAME) ;
		if(profileDataXml != null){
			userNameTextView.setText(profileDataXml.getName()) ;
		} else {
			userNameTextView.setText(profileActivity.currentScreen.getSocialUserName()) ;
		}
		userNameTextView.setGravity(Gravity.BOTTOM) ;
		userNameTextView.setPadding(0, 0, 0, 0) ;
		userNameTextView.setTextSize((float)listWidth * 7.0f / 100 / scaledDensity) ;
		userNameTextView.setTypeface(typefaceRobotoLight) ;
		userNameTextView.setMaxLines(1) ;
		userNameTextView.setEllipsize(TruncateAt.END) ;
		userNameTextView.setTextColor(VeamUtil.getColorFromArgbString("FF454545")) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,userNameHeight) ;
		relativeLayoutParams.setMargins(0, 0, 0, 0) ;
		mapArea.addView(userNameTextView, relativeLayoutParams) ;
		currentY += userNameHeight ;
		
		RelativeLayout descriptionArea = new RelativeLayout(context) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.setMargins(padding, 0, padding, 0) ;
		contentView.addView(descriptionArea, linearLayoutParams) ;
		
		int userImageSize = listWidth * 25 / 100 ;
		int descriptionImageWidth = listWidth - padding*2 - userImageSize ;
		int descriptionImageHeight = descriptionImageWidth * 160 / 420 ;
		int descriptionY = listWidth * 2 / 100 ;
		ImageView descriptionImageView = new ImageView(context) ;
		descriptionImageView.setScaleType(ScaleType.FIT_XY) ;
		descriptionImageView.setImageResource(R.drawable.pro_description) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(descriptionImageWidth,descriptionImageHeight) ;
		relativeLayoutParams.setMargins(0,descriptionY, 0, 0) ;
		descriptionArea.addView(descriptionImageView,relativeLayoutParams) ;
		currentY += descriptionImageHeight + descriptionY ;
		
		int scrollWidth = descriptionImageWidth*85/100 ;
		ClickableScrollView textScrollView = new ClickableScrollView(context,profileActivity) ;
		textScrollView.setId(ProfileActivity.VIEWID_USER_DESCRIPTION_SCROLL) ;
		textScrollView.setVerticalScrollBarEnabled(false) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(scrollWidth,descriptionImageHeight*90/100) ;
		relativeLayoutParams.setMargins(descriptionImageWidth*5/100,descriptionY+descriptionImageHeight*5/100, 0, 0) ;
		descriptionArea.addView(textScrollView,relativeLayoutParams) ;
		
		TextView descriptionTextView = new TextView(context) ;
		descriptionTextView.setId(ProfileActivity.VIEWID_USER_DESCRIPTION_TEXT) ;
		if(profileActivity.isMyProfile()){
			descriptionTextView.setText(profileActivity.getString(R.string.tap_to_edit_your_message)) ;
		} else {
			descriptionTextView.setText("") ;
		}
		descriptionTextView.setClickable(false) ;
		descriptionTextView.setPadding(0, 0, 0, 0) ;
		descriptionTextView.setBackgroundColor(Color.TRANSPARENT) ;
		descriptionTextView.setTextSize((float)listWidth * 3.8f / 100 / scaledDensity) ;
		linearLayoutParams = new LinearLayout.LayoutParams(scrollWidth,LinearLayout.LayoutParams.WRAP_CONTENT) ;
		textScrollView.addView(descriptionTextView,linearLayoutParams) ;
		
		/*
		scrollView.setOnTouchListener(new View.OnTouchListener() {
	        @Override
	        public boolean onTouch(View v, MotionEvent event) {
		        //VeamUtil.log("debug", "PARENT TOUCH");
		        findViewById(ProfileActivity.VIEWID_USER_DESCRIPTION_SCROLL).getParent().requestDisallowInterceptTouchEvent(false);
		        return false;
		    }
		});
		*/

		textScrollView.setOnTouchListener(new View.OnTouchListener() {
	        @Override
	        public boolean onTouch(View v, MotionEvent event) {
		        //VeamUtil.log("debug", "CHILD TOUCH");
		        // Disallow the touch request for parent scroll on touch of  child view
		        v.getParent().requestDisallowInterceptTouchEvent(true);
		        return false;
		    }
		});
		
		CircleImageView userImageView = new CircleImageView(context) ;
		userImageView.setId(ProfileActivity.VIEWID_USER_IMAGE) ;
		userImageView.setScaleType(ScaleType.FIT_XY) ;
		userImageView.setImageResource(R.drawable.pro_no_image) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(userImageSize,userImageSize) ;
		relativeLayoutParams.setMargins(descriptionImageWidth,0, 0, 0) ;
		descriptionArea.addView(userImageView,relativeLayoutParams) ;
		
		int actionAreaWidth = listWidth - padding * 2 ;
		int actionImageWidth = actionAreaWidth ;
		int actionImageHeight = actionImageWidth * 70 / 590 ;
		int messageImageWidth = actionImageHeight * 112 / 70 ;

		RelativeLayout actionAreaView = new RelativeLayout(context) ;
		linearLayoutParams = new LinearLayout.LayoutParams(actionAreaWidth,actionImageHeight) ;
		linearLayoutParams.setMargins(padding,listWidth*4/100, 0, 0) ;
		contentView.addView(actionAreaView,linearLayoutParams) ;

		/*
		View actionView = new View(context) ;
		actionView.setBackgroundResource(R.drawable.profile_base) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(actionImageWidth,actionImageHeight) ;
		relativeLayoutParams.setMargins(0,0, 0, 0) ;
		actionAreaView.addView(actionView,relativeLayoutParams) ;
		*/
		
		ImageView actionImageView = new ImageView(context) ;
		actionImageView.setId(ProfileActivity.VIEWID_ACTION_IMAGE) ;
		actionImageView.setOnClickListener(profileActivity) ;
		actionImageView.setScaleType(ScaleType.FIT_XY) ;
		if(profileActivity.isMyProfile()){
            //actionImageView.setImageResource(R.drawable.pro_settings) ;
            actionImageView.setImageBitmap(VeamUtil.getThemeImage(profileActivity,"pro_settings_nolabel",1)) ;
		} else {
			//actionImageView.setImageResource(R.drawable.pro_base) ;
		}
		relativeLayoutParams = new RelativeLayout.LayoutParams(actionImageWidth,actionImageHeight) ;
		relativeLayoutParams.setMargins(0,0, 0, 0) ;
		actionAreaView.addView(actionImageView,relativeLayoutParams) ;
		
		int actionTextWidth = actionImageWidth * 93 / 100 ;
		int actionTextX = actionImageWidth - actionTextWidth ;
		TextView actionTextView = new TextView(context) ;
		actionTextView.setId(ProfileActivity.VIEWID_ACTION_LABEL) ;
		actionTextView.setGravity(Gravity.CENTER) ;
		actionTextView.setTextColor(Color.WHITE) ;
		if(profileActivity.isMyProfile()){
			actionTextView.setTextColor(VeamUtil.getColorFromArgbString("FF424242")) ;
            actionTextView.setText(profileActivity.getString(R.string.go_to_settings)) ;
			//actionTextView.setText("") ;
		}
		actionTextView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(actionTextWidth,actionImageHeight) ;
		relativeLayoutParams.setMargins(actionTextX,0, 0, 0) ;
		actionAreaView.addView(actionTextView,relativeLayoutParams) ;

        /*
		ImageView messageImageView = new ImageView(context) ;
		messageImageView.setId(ProfileActivity.VIEWID_MESSAGE_IMAGE) ;
		messageImageView.setOnClickListener(profileActivity) ;
		messageImageView.setScaleType(ScaleType.FIT_XY) ;
		messageImageView.setImageResource(R.drawable.pro_message) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(messageImageWidth,actionImageHeight) ;
		relativeLayoutParams.setMargins(actionAreaWidth-messageImageWidth,0, 0, 0) ;
		actionAreaView.addView(messageImageView,relativeLayoutParams) ;
		*/

		
		currentY += listWidth*3/100 ;
		if(profileDataXml != null){
			String badgeNumber = profileDataXml.getUnreadMessageCount() ;
			if(!VeamUtil.isEmpty(badgeNumber) && !badgeNumber.equals("0")){
				TextView badgeTextView = new TextView(context) ;
				badgeTextView.setText(badgeNumber) ;
				badgeTextView.setTextColor(Color.WHITE) ;
				badgeTextView.setBackgroundResource(R.drawable.profile_badge) ;
				badgeTextView.setGravity(Gravity.CENTER) ;
				badgeTextView.setTextSize((float)listWidth * 3.0f / 100 / scaledDensity) ;
				badgeTextView.setMaxLines(1) ;
				
				TextPaint paint = badgeTextView.getPaint() ;
				int textPadding = listWidth*3/100 ;
				int badgeRightMargin = listWidth*3/100 ;
				int resizeTextWidth = (int)Layout.getDesiredWidth(badgeNumber, paint) + textPadding ;
				resizeTextWidth = resizeTextWidth * 105 / 100 ;
				relativeLayoutParams = new RelativeLayout.LayoutParams(resizeTextWidth,listWidth*5/100) ;
				relativeLayoutParams.setMargins(listWidth-resizeTextWidth-badgeRightMargin,currentY, 0, 0) ;
				profileView.addView(badgeTextView, relativeLayoutParams) ;
			}
		}
		

		
		
		TextView forumTextView = new TextView(context) ;
		forumTextView.setText(profileActivity.getString(R.string.forum)) ;
		forumTextView.setGravity(Gravity.BOTTOM) ;
		forumTextView.setTextSize((float)listWidth * 4.5f / 100 / scaledDensity) ;
		forumTextView.setMaxLines(1) ;
		forumTextView.setTextColor(VeamUtil.getColorFromArgbString("FF696969")) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,listWidth*12/100) ;
		linearLayoutParams.setMargins(padding, 0, padding, 0) ;
		contentView.addView(forumTextView, linearLayoutParams) ;
		
		View lineView = new View(context) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		linearLayoutParams = new LinearLayout.LayoutParams(listWidth,1) ;
		linearLayoutParams.setMargins(0,listWidth*2/100,0, 0) ;
		contentView.addView(lineView,linearLayoutParams) ;
		
		int barHeight = listWidth * 14 / 100 ;
		RelativeLayout barAreaView = new RelativeLayout(context) ;
		barAreaView.setBackgroundColor(Color.argb(0x77,0xff,0xff,0xff));
		linearLayoutParams = new LinearLayout.LayoutParams(listWidth,barHeight*3) ;
		linearLayoutParams.setMargins(0, 0, 0, 0) ;
		contentView.addView(barAreaView,linearLayoutParams) ;
		
		int arrowHeight = barHeight * 30 / 100 ;
		int arrowWidth = arrowHeight * 16 / 26  ;
		int numAreaWidth = listWidth * 50 / 100 ;
		int numAreaMargin = listWidth * 4 / 100 ;

		///////////////////////////////
		// Posts
		TextView postsTextView = new TextView(context) ;
		postsTextView.setId(ProfileActivity.VIEWID_POSTS_BAR) ;
		postsTextView.setOnClickListener(profileActivity) ;
		postsTextView.setText(profileActivity.getString(R.string.posts)) ;
		postsTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		postsTextView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
		//postsTextView.setTypeface(typefaceRobotoLight) ;
		postsTextView.setMaxLines(1) ;
		postsTextView.setTextColor(VeamUtil.getColorFromArgbString("FF585858")) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-padding*2,barHeight) ;
		relativeLayoutParams.setMargins(padding,0, 0, 0) ;
		barAreaView.addView(postsTextView,relativeLayoutParams) ;

		LinearLayout numAreaView = new LinearLayout(context) ;
		numAreaView.setOrientation(LinearLayout.HORIZONTAL) ;
		numAreaView.setGravity(Gravity.RIGHT|Gravity.CENTER_VERTICAL) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*50/100,barHeight) ;
		relativeLayoutParams.setMargins(listWidth-padding-arrowWidth-numAreaMargin-numAreaWidth,0, 0, 0) ;
		barAreaView.addView(numAreaView,relativeLayoutParams) ;
		
		ImageView iconImage = new ImageView(context) ;
        //iconImage.setImageResource(R.drawable.pro_post_icon) ; // 44x50
        iconImage.setImageBitmap(VeamUtil.getThemeImage(profileActivity,"pro_post_icon",1)) ; // 44x50
		int iconHeight = barHeight * 50 / 100 ;
		int iconWidth = iconHeight * 44 / 50 ;
		linearLayoutParams = new LinearLayout.LayoutParams(iconWidth,iconHeight) ;
		numAreaView.addView(iconImage,linearLayoutParams) ;

		TextView postsNumTextView = new TextView(context) ;
		postsNumTextView.setId(ProfileActivity.VIEWID_POSTS_NUM) ;
		postsNumTextView.setText("-") ;
		postsNumTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		postsNumTextView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
		//postsNumTextView.setTypeface(typefaceRobotoLight) ;
		postsNumTextView.setMaxLines(1) ;
		postsNumTextView.setTextColor(VeamUtil.getColorFromArgbString("FF3F3F3F")) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,barHeight) ;
		linearLayoutParams.setMargins(listWidth*2/100,0,0,0) ;
		numAreaView.addView(postsNumTextView,linearLayoutParams) ;

		ImageView arrowImageView = new ImageView(context) ;
		arrowImageView.setImageResource(R.drawable.setting_arrow) ;
		arrowImageView.setScaleType(ScaleType.FIT_XY) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(arrowWidth,arrowHeight) ;
		relativeLayoutParams.setMargins(listWidth-padding-arrowWidth,(barHeight-arrowHeight)/2, 0, 0) ;
		barAreaView.addView(arrowImageView,relativeLayoutParams) ;
		
		lineView = new View(context) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-padding,1) ;
		relativeLayoutParams.setMargins(padding,barHeight, 0, 0) ;
		barAreaView.addView(lineView,relativeLayoutParams) ;

		///////////////////////////////
		// Followers
		TextView followersTextView = new TextView(context) ;
		followersTextView.setId(ProfileActivity.VIEWID_FOLLOWERS_BAR) ;
		followersTextView.setOnClickListener(profileActivity) ;
		followersTextView.setText(profileActivity.getString(R.string.followers)) ;
		followersTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		followersTextView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
		//postsTextView.setTypeface(typefaceRobotoLight) ;
		followersTextView.setMaxLines(1) ;
		followersTextView.setTextColor(VeamUtil.getColorFromArgbString("FF585858")) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-padding*2,barHeight) ;
		relativeLayoutParams.setMargins(padding,barHeight, 0, 0) ;
		barAreaView.addView(followersTextView,relativeLayoutParams) ;

		numAreaView = new LinearLayout(context) ;
		numAreaView.setOrientation(LinearLayout.HORIZONTAL) ;
		numAreaView.setGravity(Gravity.RIGHT|Gravity.CENTER_VERTICAL) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*50/100,barHeight) ;
		relativeLayoutParams.setMargins(listWidth-padding-arrowWidth-numAreaMargin-numAreaWidth,barHeight, 0, 0) ;
		barAreaView.addView(numAreaView,relativeLayoutParams) ;
		
		iconImage = new ImageView(context) ;
        //iconImage.setImageResource(R.drawable.pro_person_icon) ; // 42x42
        iconImage.setImageBitmap(VeamUtil.getThemeImage(profileActivity,"pro_person_icon",1)) ; // 42x42
		iconHeight = barHeight * 42 / 100 ;
		iconWidth = iconHeight ;
		linearLayoutParams = new LinearLayout.LayoutParams(iconWidth,iconHeight) ;
		numAreaView.addView(iconImage,linearLayoutParams) ;

		TextView followersNumTextView = new TextView(context) ;
		followersNumTextView.setId(ProfileActivity.VIEWID_FOLLOWERS_NUM) ;
		followersNumTextView.setText("-") ;
		followersNumTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		followersNumTextView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
		//followersNumTextView.setTypeface(typefaceRobotoLight) ;
		followersNumTextView.setMaxLines(1) ;
		followersNumTextView.setTextColor(VeamUtil.getColorFromArgbString("FF3F3F3F")) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,barHeight) ;
		linearLayoutParams.setMargins(listWidth*2/100,0,0,0) ;
		numAreaView.addView(followersNumTextView,linearLayoutParams) ;

		arrowImageView = new ImageView(context) ;
		arrowImageView.setImageResource(R.drawable.setting_arrow) ;
		arrowImageView.setScaleType(ScaleType.FIT_XY) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(arrowWidth,arrowHeight) ;
		relativeLayoutParams.setMargins(listWidth-padding-arrowWidth,barHeight+(barHeight-arrowHeight)/2, 0, 0) ;
		barAreaView.addView(arrowImageView,relativeLayoutParams) ;
		
		lineView = new View(context) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-padding,1) ;
		relativeLayoutParams.setMargins(padding,barHeight*2, 0, 0) ;
		barAreaView.addView(lineView,relativeLayoutParams) ;

		
		///////////////////////////////
		// Followings
		TextView followingsTextView = new TextView(context) ;
		followingsTextView.setId(ProfileActivity.VIEWID_FOLLOWINGS_BAR) ;
		followingsTextView.setOnClickListener(profileActivity) ;
		followingsTextView.setText(profileActivity.getString(R.string.following)) ;
		followingsTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		followingsTextView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
		//followingsTextView.setTypeface(typefaceRobotoLight) ;
		followingsTextView.setMaxLines(1) ;
		followingsTextView.setTextColor(VeamUtil.getColorFromArgbString("FF585858")) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-padding*2,barHeight) ;
		relativeLayoutParams.setMargins(padding,barHeight*2, 0, 0) ;
		barAreaView.addView(followingsTextView,relativeLayoutParams) ;

		numAreaView = new LinearLayout(context) ;
		numAreaView.setOrientation(LinearLayout.HORIZONTAL) ;
		numAreaView.setGravity(Gravity.RIGHT|Gravity.CENTER_VERTICAL) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*50/100,barHeight) ;
		relativeLayoutParams.setMargins(listWidth-padding-arrowWidth-numAreaMargin-numAreaWidth,barHeight*2, 0, 0) ;
		barAreaView.addView(numAreaView,relativeLayoutParams) ;
		
		iconImage = new ImageView(context) ;
		//iconImage.setImageResource(R.drawable.pro_person_icon) ; // 42x42
        iconImage.setImageBitmap(VeamUtil.getThemeImage(profileActivity,"pro_person_icon",1)) ; // 42x42
		iconHeight = barHeight * 42 / 100 ;
		iconWidth = iconHeight ;
		linearLayoutParams = new LinearLayout.LayoutParams(iconWidth,iconHeight) ;
		numAreaView.addView(iconImage,linearLayoutParams) ;

		TextView followingsNumTextView = new TextView(context) ;
		followingsNumTextView.setId(ProfileActivity.VIEWID_FOLLOWINGS_NUM) ;
		followingsNumTextView.setText("-") ;
		followingsNumTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		followingsNumTextView.setTextSize((float)listWidth * 5.0f / 100 / scaledDensity) ;
		//followingsNumTextView.setTypeface(typefaceRobotoLight) ;
		followingsNumTextView.setMaxLines(1) ;
		followingsNumTextView.setTextColor(VeamUtil.getColorFromArgbString("FF3F3F3F")) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,barHeight) ;
		linearLayoutParams.setMargins(listWidth*2/100,0,0,0) ;
		numAreaView.addView(followingsNumTextView,linearLayoutParams) ;

		arrowImageView = new ImageView(context) ;
		arrowImageView.setImageResource(R.drawable.setting_arrow) ;
		arrowImageView.setScaleType(ScaleType.FIT_XY) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(arrowWidth,arrowHeight) ;
		relativeLayoutParams.setMargins(listWidth-padding-arrowWidth,barHeight*2+(barHeight-arrowHeight)/2, 0, 0) ;
		barAreaView.addView(arrowImageView,relativeLayoutParams) ;

		
		lineView = new View(context) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		linearLayoutParams = new LinearLayout.LayoutParams(listWidth,1) ;
		linearLayoutParams.setMargins(0,0,0, 0) ;
		contentView.addView(lineView,linearLayoutParams) ;
		
		
		TextView notificationTextView = new TextView(context) ;
		notificationTextView.setText("") ;
		notificationTextView.setGravity(Gravity.BOTTOM) ;
		notificationTextView.setTextSize((float)listWidth * 4.5f / 100 / scaledDensity) ;
		notificationTextView.setMaxLines(1) ;
		notificationTextView.setTextColor(VeamUtil.getColorFromArgbString("FF696969")) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,listWidth*12/100) ;
		linearLayoutParams.setMargins(padding, 0, padding, 0) ;
		contentView.addView(notificationTextView, linearLayoutParams) ;
		
		View notificationTopLineView = new View(context) ;
		notificationTopLineView.setBackgroundColor(Color.TRANSPARENT) ;
		linearLayoutParams = new LinearLayout.LayoutParams(listWidth,1) ;
		linearLayoutParams.setMargins(0,listWidth*2/100,0, 0) ;
		contentView.addView(notificationTopLineView,linearLayoutParams) ;

		
		
		
		
		///////////// set values ////////////
		if(profileDataXml != null){
			userNameTextView.setText(profileDataXml.getName()) ;
			
			String imageUrl = profileDataXml.getImageUrl() ;
			if(!VeamUtil.isEmpty(imageUrl)){
				userImageView.setTag(Integer.valueOf(0)) ;
				LoadImageTask loadImageTask = new LoadImageTask(profileActivity,imageUrl,userImageView,listWidth*25/100,0,null) ;
				loadImageTask.execute("") ;
			}

            /*
			String latitude = profileDataXml.getLatitude() ;
			String longitude = profileDataXml.getLongitude() ;
			if(!VeamUtil.isEmpty(latitude) && !VeamUtil.isEmpty(longitude) && !(latitude.equals("0") && longitude.equals("0"))){
				mapImageView.setImageResource(R.drawable.checkin_on) ;
			} else {
				mapImageView.setImageResource(R.drawable.checkin_off) ;
			}
			*/
			
			String description = profileDataXml.getDescription() ;
			if(profileActivity.isMyProfile() && VeamUtil.isEmpty(description)){
				descriptionTextView.setText(profileActivity.getString(R.string.tap_to_edit_your_message)) ;
			} else {
				descriptionTextView.setText(profileDataXml.getDescription()) ;
			}
	
			if(!profileActivity.isMyProfile()) {
				if(profileDataXml.isFollowing()){
					actionTextView.setText(profileActivity.getString(R.string.i_am_following)) ;
					//actionImageView.setImageResource(R.drawable.pro_unfollow) ;
                    actionImageView.setImageBitmap(VeamUtil.getThemeImage(profileActivity,"pro_follow",1)) ;
				} else {
					actionTextView.setText(profileActivity.getString(R.string.do_follow)) ;
                    //actionImageView.setImageResource(R.drawable.pro_follow) ;
                    actionImageView.setImageBitmap(VeamUtil.getThemeImage(profileActivity,"pro_follow",1)) ;
				}
			}
			
			postsNumTextView.setText(String.format("%d", profileDataXml.getNumberOfPosts())) ;
	
			followersNumTextView.setText(String.format("%d", profileDataXml.getNumberOfFollowers())) ;
	
			followingsNumTextView.setText(String.format("%d", profileDataXml.getNumberOfFollowings())) ;

            /*
			if(profileDataXml.userNotifications.size() > 0){
				notificationTextView.setText("Notification") ;
				notificationTopLineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			}
			*/
		}
		
		return profileView ;
	}

	public View getNotificationView(int position){
		
		UserNotificationObject userNotificationObject = (UserNotificationObject)this.getItem(position) ;
		String userName = "" ;
		MessageUserObject messageUserObject = null ;
		if(userNotificationObject != null){
			messageUserObject = this.getMessageUserForId(userNotificationObject.getFromUserId()) ;
		}

		
		if(position > 0){
			if(userNotificationObject != null){
				if(messageUserObject != null){
					userName = messageUserObject.getName() ;
				}
			}
		}

		
		LinearLayout.LayoutParams linearLayoutParams ;
		RelativeLayout.LayoutParams relativeLayoutParams ;
		Typeface typefaceRobotoLight= Typeface.createFromAsset(context.getAssets(), "Roboto-Light.ttf");

		int userIconSize = listWidth * 10 / 100 ;
		int cellHeight = listWidth * 14 / 100 ;
		
		LinearLayout view = new LinearLayout(context) ;
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
		relativeLayoutParams.setMargins(margin+listWidth*1/100,(cellHeight-userIconSize)/2,0,0) ;
		contentLayout.addView(userIconImageView,relativeLayoutParams) ;
		
		TextView userNameTextView = new TextView(context) ;
		userNameTextView.setId(VIEWID_USER_NAME) ;
		userNameTextView.setBackgroundColor(Color.TRANSPARENT) ;
		userNameTextView.setTextColor(Color.rgb(0x00, 0x00, 0x00)) ;
		userNameTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		userNameTextView.setPadding(0, 0, 0, 0) ;
		userNameTextView.setTextSize((float)listWidth * 4.0f / 100 / scaledDensity) ;
		userNameTextView.setTypeface(typefaceRobotoLight) ;
		userNameTextView.setMaxLines(1) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*75/100, cellHeight/2) ;
		relativeLayoutParams.setMargins(margin+this.listWidth*15/100,listWidth*6/1000, 0, 0) ;
		contentLayout.addView(userNameTextView,relativeLayoutParams) ;
		
		TextView timeTextView = new TextView(context) ;
		timeTextView.setId(VIEWID_TIME) ;
		timeTextView.setBackgroundColor(Color.TRANSPARENT) ;
		timeTextView.setTextColor(Color.rgb(0x59, 0x59, 0x59)) ;
		timeTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		timeTextView.setPadding(0, 0, 0, 0) ;
		timeTextView.setTextSize((float)listWidth * 4.0f / 100 / scaledDensity) ;
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
		relativeLayoutParams.setMargins(0,cellHeight-1, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		
		
		
		
		String htmlString = null ;
		String notificationText = userNotificationObject.getText() ;
		if(VeamUtil.isEmpty(notificationText)){
			htmlString = String.format("<font color=\"#FF80BD\"><b>%s</b></font> <font color=\"#595959\">%s</font>", userName,userNotificationObject.getMessage()) ;
		} else {
			htmlString = String.format("<font color=\"#FF80BD\"><b>%s</b></font> <font color=\"#595959\">%s</font> : <font color=\"#FF80BD\"><i>%s</i></font>", userName,userNotificationObject.getMessage(),notificationText) ;
		}
		userNameTextView.setText(Html.fromHtml(htmlString));
		
		//timeTextView.setText(VeamUtil.getSinceFromNowString(userNotificationObject.getCreatedAt())) ;

		String iconImageUrl = "" ;
		if(messageUserObject != null){
			iconImageUrl = messageUserObject.getImageUrl() ;
		}

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
		
		//View readMarkView = (View)view.findViewById(VIEWID_READ_MARK) ;
		if(readMarkView != null){
			if(userNotificationObject.getReadFlag().equals("0")){
				readMarkView.setBackgroundColor(VeamUtil.getColorFromArgbString("FFFF80BD")) ;
			} else {
				readMarkView.setBackgroundColor(Color.TRANSPARENT) ;
			}
		}

		view.setTag(Integer.valueOf(position)) ;

		return view ;
	}



	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//VeamUtil.log("debug","getView:"+position) ;
		
		int itemViewType = getItemViewType(position) ;
		
		View view = null ;
		if(itemViewType == TYPE_PROFILE){
			view = this.getProfileView(position) ;
		} else if(itemViewType == TYPE_NOTIFICATION){
			view = this.getNotificationView(position) ;
		}

		return view ;	
	}

}
