package co.veam.veam31000287;

import android.app.AlertDialog;
import android.app.NotificationManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.text.InputType;
import android.text.Layout;
import android.text.TextPaint;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.facebook.Session;

import java.util.ArrayList;

import co.veam.veam31000287.FollowAdapter.FollowAdapterActivityInterface;
import co.veam.veam31000287.MessageAdapter.MessageAdapterActivityInterface;
import co.veam.veam31000287.MessageSummaryAdapter.MessageSummaryAdapterActivityInterface;
import co.veam.veam31000287.OverScrollListView.OnOverScrollListViewSizeChangedListener;
//import com.google.analytics.tracking.android.Log;


public class ProfileActivity extends VeamActivity implements OnClickListener, OnItemClickListener, OnTouchListener, FollowAdapterActivityInterface, MessageAdapterActivityInterface, MessageSummaryAdapterActivityInterface, OnOverScrollListViewSizeChangedListener, OnFocusChangeListener {
	/*
	private DatabaseHelper helper ;
	SQLiteDatabase mDb ;
	*/
	private RelativeLayout rootLayout ;
	private RelativeLayout mainView ;
	private RelativeLayout commentView ;
	private EditText commentEditText ;
	private boolean isCommentViewShown ;
	private TextView postTextView ;
	private ProgressBar postProgressBar ;
	private ProgressBar sendMessageProgressBar ;
	/*
	private boolean pictureListDragging = false ;
	private float dragPreviousY = 0 ;
	private int pictureListOriginalBottom = 0 ;
	*/
	
	private EditText reportEditText ;

	
	private int tabNo ;
	
	private int pendingOperation ;
	private PictureObject currentPictureObject ;
	private ImageView pendingImageView ;
	private static int PENDING_OPERATION_NONE				= 0 ;
	private static int PENDING_OPERATION_LIKE				= 1 ;
	private static int PENDING_OPERATION_COMMENT			= 2 ;
	private static int PENDING_OPERATION_DELETE				= 3 ;
	private static int PENDING_OPERATION_CAMERA				= 4 ;
	private static int PENDING_OPERATION_MY_POSTS			= 5 ;
	private static int PENDING_OPERATION_DESCRIPTION		= 6 ;
	private static int PENDING_OPERATION_FOLLOW				= 7 ;
	private static int PENDING_OPERATION_MESSAGE			= 8 ;
	private static int PENDING_OPERATION_MESSAGE_SUMMARY	= 9 ;
	
	//private String currentForumName ;
	
	public static int VIEWID_USER_DESCRIPTION_TEXT	= 0x10001 ;
	public static int VIEWID_POST_BUTTON			= 0x10002 ;
	public static int VIEWID_USER_NAME				= 0x10003 ;
	public static int VIEWID_USER_IMAGE				= 0x10005 ;
	public static int VIEWID_ACTION_IMAGE			= 0x10006 ;
	public static int VIEWID_ACTION_LABEL			= 0x10007 ;
	public static int VIEWID_POSTS_NUM				= 0x10008 ;
	public static int VIEWID_FOLLOWERS_NUM			= 0x10009 ;
	public static int VIEWID_FOLLOWINGS_NUM			= 0x1000A ;
	public static int VIEWID_POSTS_BAR				= 0x1000B ;
	public static int VIEWID_FOLLOWERS_BAR			= 0x1000C ;
	public static int VIEWID_FOLLOWINGS_BAR			= 0x1000D ;
	public static int VIEWID_USER_DESCRIPTION_SCROLL= 0x1000F ;
	public static int VIEWID_FIND_USER_BUTTON		= 0x10010 ;
	public static int VIEWID_MAP_BUTTON				= 0x10011 ;
	public static int VIEWID_MESSAGE_IMAGE			= 0x10012 ;
	public static int VIEWID_MESSAGE_SEND_TEXT		= 0x10013 ;
	public static int VIEWID_TOP_BAR_BLOCK_BUTTON	= 0x10014 ;
	
	public ProfileScreen currentScreen ;
	public ProfileScreen previousScreen ;
	
	private static int VIEW_FORUM_LIST 				= 1 ;
	private static int VIEW_PICTURE_LIST 			= 2 ;
	private static int VIEW_COMMENT		 			= 3 ;
	
	private static int REQUEST_CAMERA_ACTIVITY		= 1 ;
	
	private RelativeLayout profileView ;
	protected OverScrollListView profileListView ;
	protected ProfileAdapter profileAdapter ;
	private ProfileDataXml currentProfileDataXml ;
	
	protected RelativeLayout messageSummaryView ;
	protected OverScrollListView messageSummaryListView ;
	protected MessageSummaryAdapter messageSummaryAdapter ;
	protected ProgressBar messageSummaryProgressBar ;

	protected RelativeLayout messageView ;
	protected OverScrollListView messageListView ;
	protected MessageAdapter messageAdapter ;
	protected ProgressBar messageProgressBar ;
	private EditText messageEditText ;
	private boolean isBlockedUser = false ;

	
	
	private ArrayList<ProfileScreen> screenStack ;
	private ProgressBar profileProgressBar ;
	
	private boolean isSendingMessage = false ;
	RelativeLayout messageInputView ;

    private Handler handler = new Handler();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_forum);

		this.pageName = "Profile" ;
		screenStack = new ArrayList<ProfileScreen>() ;
		
		RelativeLayout.LayoutParams layoutParams ;
		
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		
		Intent intent = this.getIntent() ;
		boolean isNotification = intent.getBooleanExtra("IS_NOTIFICATION", false) ;
		if(isNotification){
	        NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE) ;
	        notificationManager.cancel(1);
		}

		tabNo = intent.getIntExtra("TAB_INDEX", 0) ;
		String socialUserId = intent.getStringExtra("SOCIAL_USER_ID") ;
		String socialUserName = intent.getStringExtra("SOCIAL_USER_NAME") ;
		String notificationKind = intent.getStringExtra("NOTIFICATION_KIND") ;
		String pictureId = intent.getStringExtra("PICTURE_ID") ;
		//VeamUtil.log("debug","profile activity intent " + isNotification + " "+notificationKind+" "+socialUserId + " "+ pictureId) ;


		int templateId = -1 ;
		String[] templateIds = VeamUtil.getTemplateIds(this) ;
		if((templateIds != null) && (0 <= tabNo) && (tabNo < templateIds.length)){
			templateId = VeamUtil.parseInt(templateIds[tabNo]) ;
		}
		this.addBaseBackground(rootLayout) ;
		this.addTab(rootLayout, templateId,true) ;
		mainView = this.addMainView(rootLayout,View.VISIBLE) ;

		this.addTopBar(mainView, this.getString(R.string.profile),true,false) ;

        /* Find Not Supported
		RelativeLayout topBarView = (RelativeLayout)mainView.findViewById(VIEWID_TOP_BAR) ;
		ImageView findIconImageView = new ImageView(this) ;
		findIconImageView.setId(VIEWID_FIND_USER_BUTTON) ;
		findIconImageView.setOnClickListener(this) ;
		findIconImageView.setImageResource(R.drawable.top_search) ;
		RelativeLayout.LayoutParams relativeLayoutParams = createParam(topBarHeight, topBarHeight) ;
		relativeLayoutParams.setMargins(deviceWidth-topBarHeight, 0, 0, 0) ;
		topBarView.addView(findIconImageView,relativeLayoutParams) ;
		*/

		
		profileView = null ;
		pictureView = null ;
		pendingOperation = PENDING_OPERATION_NONE ;
		
		//VeamUtil.log("debug","profile "+socialUserName) ;
		if(isNotification){
			if(	notificationKind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_LIKE_PICTURE) ||
				notificationKind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_COMMENT_PICTURE)){
				setCurrentScreen(this.getPostsScreen(socialUserId, "",pictureId)) ;
				currentForumObject = new ForumObject(String.format("f:%s",pictureId),"My post","0","","",false,0) ;
				this.showPictureView(rootLayout, mainView, true, true, this,false) ;
			} else if(notificationKind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_FOLLOW)){
				setCurrentScreen(this.getProfileScreen(socialUserId,socialUserName)) ;
				this.showProfileView(rootLayout, mainView,true) ;
				/*
			} else if(notificationKind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_MESSAGE)){
				setCurrentScreen(this.getMessageScreen(socialUserId,socialUserName)) ;
				this.showMessageView(rootLayout, mainView, true, "", this) ;
				getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN) ;
				*/
			}
		} else {
			setCurrentScreen(this.getProfileScreen(socialUserId,socialUserName)) ;
			this.showProfileView(rootLayout, mainView,true) ;
		}

	}
	
	public void setCurrentScreen(ProfileScreen profileScreen){
		previousScreen = currentScreen ;
		currentScreen = profileScreen ;
	}
	
	/*
	@Override
	public void onBackButtonClicked(){
		//VeamUtil.log("debug","back button tapped") ;
		int screenKind = currentScreen.getKind() ;
		switch(screenKind){
		case ProfileScreen.SCREEN_KIND_FOLLOWERS:
		case ProfileScreen.SCREEN_KIND_FOLLOWINGS:
			this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showForumList", null) ;
			this.doTranslateAnimation(pictureView, 300, 0, deviceWidth, 0, 0, "removePictureList", null) ;
			break ;
		case ProfileScreen.SCREEN_KIND_POSTS:
			this.finishCommentView() ;
			break ;
		}
	}
	*/
	
	/*
	public void finishCommentView(){
		if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_COMMENT){
			InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
			inputMethodManager.hideSoftInputFromWindow(commentEditText.getWindowToken(), 0) ;
			this.doTranslateAnimation(pictureView, 300, -deviceWidth, 0, 0, 0, "showPictureList", null) ;
			this.doTranslateAnimation(commentView, 300, 0, deviceWidth, 0, 0, "removePostComment", null) ;
			if(currentForumObject != null){
				this.trackPageView(String.format("Forum/%s/%s",currentForumObject.getId(),currentForumObject.getName())) ;
			}
		}
	}
	*/
	
	
	public void loginFacebook(){
		//VeamUtil.log("debug","loginFacebook") ;
		this.facebookLogin() ;
	}
	
	public void loginTwitter(){
		//VeamUtil.log("debug","loginTwitter") ;
		this.twitterLogin() ;
	}
	
	public void doPendingOperation(){
		if(pictureAdapter != null){
			pictureAdapter.setSocialUserId() ;
		}
		if(pendingOperation == PENDING_OPERATION_LIKE){
			//VeamUtil.log("debug","pending : like " + currentPictureObject.getId()) ;
			this.operateLike(currentPictureObject, pendingImageView) ;
		} else if(pendingOperation == PENDING_OPERATION_COMMENT){
			//VeamUtil.log("debug","pending : comment " + currentPictureObject.getId()) ;
			this.operateCommentButton() ;
		} else if(pendingOperation == PENDING_OPERATION_FOLLOW){
			//VeamUtil.log("debug","pending : comment " + currentPictureObject.getId()) ;
			this.operateFollow() ;
		} else if(pendingOperation == PENDING_OPERATION_DESCRIPTION){
			//VeamUtil.log("debug","pending : camera ") ;
			String socialUserId = VeamUtil.getSocialUserId(this) ;
			String socialUserName = VeamUtil.getSocialUserName(this) ;
			currentScreen.setSocialUserId(socialUserId) ;
			currentScreen.setSocialUserName(socialUserName) ;
			this.operateDescriptionButton() ;
		}
	}
	
	public void onLoginFinished(Integer resultCode) {
		//VeamUtil.log("debug","ForumActivity::onLoginFinished") ;
		this.doPendingOperation() ;
	}
	

	
	public void clearPendingOperation(){
		this.pendingOperation = PENDING_OPERATION_NONE ;
	}
	
	public void login(){
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        // アラートダイアログのタイトルを設定します
        alertDialogBuilder.setTitle(this.getString(R.string.login));
        // アラートダイアログのメッセージを設定します
        alertDialogBuilder.setMessage(this.getString(R.string.login_selection));
        // アラートダイアログの肯定ボタンがクリックされた時に呼び出されるコールバックリスナーを登録します
        alertDialogBuilder.setPositiveButton("Facebook",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                    	loginFacebook() ;
                    }
                });
        alertDialogBuilder.setNeutralButton("Twitter",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                    	loginTwitter() ;
                    }
                });
        // アラートダイアログの否定ボタンがクリックされた時に呼び出されるコールバックリスナーを登録します
        alertDialogBuilder.setNegativeButton(this.getString(R.string.cancel),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                    }
                });
        alertDialogBuilder.setCancelable(true);
        AlertDialog alertDialog = alertDialogBuilder.create();
        // アラートダイアログを表示します
        alertDialog.show();
		
	}
	
	public void operateMessage(){
		if(this.isValidSocialUserId(currentScreen.getSocialUserId())){
			this.goForward(this.getMessageScreen(currentScreen.getSocialUserId(),currentScreen.getSocialUserName())) ;
		}
	}

	public void operateMessageSummary(){
		if(this.isValidSocialUserId(currentScreen.getSocialUserId())){
			this.goForward(this.getMessageSummaryScreen(currentScreen.getSocialUserId(),currentScreen.getImageUrl())) ;
		}
	}

	public void operateFollow(){
		//VeamUtil.log("debug","operateLike") ;
		pendingOperation = PENDING_OPERATION_NONE ;
		this.profileProgressBar.setVisibility(View.VISIBLE) ;
		
		boolean follow = true ;
		if((currentProfileDataXml != null) && currentProfileDataXml.isFollowing){
			follow = false ;
		}
		
		SendFollowTask sendFollowTask = new SendFollowTask(this,currentScreen.getSocialUserId(),follow) ;
		sendFollowTask.execute("") ;
	}
		

	public void operateLike(PictureObject pictureObject,ImageView imageView){
		//VeamUtil.log("debug","operateLike") ;
		
		pendingOperation = PENDING_OPERATION_NONE ;
		pendingImageView = null ;
		
		String pictureId = pictureObject.getId() ;
		boolean isLike = pictureAdapter.isLike(pictureId) ;
		if(isLike){
			//VeamUtil.log("debug","is like") ;
			pictureAdapter.setLike(pictureId,false) ;
			imageView.setImageResource(R.drawable.forum_like_button_off) ;
		} else {
			//VeamUtil.log("debug","is not like") ;
			pictureAdapter.setLike(pictureId,true) ;
			imageView.setImageBitmap(VeamUtil.getThemeImage(this,"forum_like_button_on",1)); ;
		}
		
		isLike = !isLike ;
		
		SendLikeTask sendLikeTask = new SendLikeTask(this,pictureObject,isLike) ;
		sendLikeTask.execute("") ;
	}
	
	public void operateFavorite(PictureObject pictureObject,ImageView imageView){
		//VeamUtil.log("debug","operateLike") ;
		
		pendingOperation = PENDING_OPERATION_NONE ;
		pendingImageView = null ;
		
		String pictureId = pictureObject.getId() ;
		
		if(VeamUtil.isFavoritePicture(this, pictureId)){
			VeamUtil.deleteFavoritePicture(this, pictureId) ;
            imageView.setImageBitmap(VeamUtil.getThemeImage(this,"add_off",1)) ;
		} else {
			VeamUtil.addFavoritePicture(this, pictureId) ;
			imageView.setImageBitmap(VeamUtil.getThemeImage(this,"add_on",1)) ;
		}
	}
	
	public void operateDeleteButton(){
		pendingOperation = PENDING_OPERATION_NONE ;
		DeletePictureTask deletePictureTask = new DeletePictureTask(this,currentPictureObject) ;
		deletePictureTask.execute("") ;
	}
	
	public void operateDescriptionButton(){
		pendingOperation = PENDING_OPERATION_NONE ;
		this.goForward(this.getUserCommentScreen(currentScreen.getSocialUserId())) ;
	}

	
	public void operateCommentButton(){
		pendingOperation = PENDING_OPERATION_NONE ;
		this.goForward(this.getPictureCommentScreen(this.currentPictureObject.getId())) ;
		/*
		
		if(commentView != null){
			commentView.removeAllViews() ;
			this.rootLayout.removeView(commentView) ;
			commentView = null ;
		}
		
		Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

		
		commentView = this.addFullView(rootLayout, View.VISIBLE) ;
		
		commentEditText = new EditText(this) ;
		commentEditText.setId(VIEWID_COMMENT_TEXT) ;
		commentEditText.setBackgroundColor(Color.argb(0x77,0xFF,0xFF,0xFF)) ;
		commentEditText.setGravity(Gravity.TOP) ;
		commentEditText.setTypeface(typefaceRobotoLight) ;
		RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(deviceWidth*94/100,deviceWidth * 45 / 100) ;
		layoutParams.setMargins(deviceWidth*3/100, topBarHeight+deviceWidth*3/100, 0, 0) ;
		commentView.addView(commentEditText,layoutParams) ;

		this.addTopBar(commentView, this.getString(R.string.comment),true,false) ;
		
		postTextView = new TextView(this) ;
		postTextView.setOnClickListener(this) ;
		postTextView.setId(VIEWID_POST_BUTTON) ;
		postTextView.setText(this.getString(R.string.post)) ;
		postTextView.setTextColor(Color.argb(0xFF,0xFF,0x62,0xBD)) ;
		postTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		postTextView.setPadding(0, 0, 0, 0) ;
		postTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*16/100,topBarHeight) ;
		relativeLayoutParams.setMargins(deviceWidth*84/100, 0, 0, 0) ;
		commentView.addView(postTextView, relativeLayoutParams) ;

		postProgressBar = new ProgressBar(this) ;
		postProgressBar.setIndeterminate(true) ;
		postProgressBar.setVisibility(View.GONE) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
		layoutParams.setMargins(deviceWidth * 84 / 100, deviceWidth * 2 / 100, 0, 0) ;
		commentView.addView(postProgressBar,layoutParams) ;
		
		commentEditText.requestFocus() ;
		InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
		inputMethodManager.showSoftInput(commentEditText, 0);
		
		this.doTranslateAnimation(pictureView, 300, 0, -deviceWidth, 0, 0, "hidePictureList", null) ;
		this.doTranslateAnimation(commentView, 300, deviceWidth, 0, 0, 0, null, null) ;
		if(currentPictureObject != null){
			this.trackPageView(String.format("PostComment/%s",currentPictureObject.getId())) ;
		}
		*/
	}
	
	public void operateCameraButton(){
		Intent cameraIntent = new Intent(this,CameraActivity.class) ;
		cameraIntent.putExtra("forum_id", currentForumObject.getId()) ;
		startActivityForResult(cameraIntent,REQUEST_CAMERA_ACTIVITY) ;
		overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
	}
	
	public void operatePostComment(){
		if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_PICTURE_COMMENT){
			String comment = commentEditText.getText().toString() ;
			if(VeamUtil.isEmpty(comment)){
				VeamUtil.showMessage(this, this.getString(R.string.please_input_comment)) ;
			} else {
				PostCommentTask postCommentTask = new PostCommentTask(this,currentPictureObject.getId(),comment) ;
				postCommentTask.execute("") ;
				postProgressBar.setVisibility(View.VISIBLE) ;
				postTextView.setVisibility(View.GONE);
			}
		} else if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_USER_DESCRIPTION){
			String comment = commentEditText.getText().toString() ;
			if(VeamUtil.isEmpty(comment)){
				VeamUtil.showMessage(this, this.getString(R.string.please_input_comment)) ;
			} else {
				PostUserDescriptionTask postUserDescriptionTask = new PostUserDescriptionTask(this,currentScreen.getSocialUserId(),comment) ;
				postUserDescriptionTask.execute("") ;
				postProgressBar.setVisibility(View.VISIBLE) ;
				postTextView.setVisibility(View.GONE);
			}
		}
	}
	
	public void pushScreen(ProfileScreen profileScreen){
		this.screenStack.add(profileScreen) ;
	}
	
	public ProfileScreen popScreen(){
		ProfileScreen profileScreen = null ;
		int size = screenStack.size() ; 
		if(size > 0){
			int lastIndex = size - 1 ;
			profileScreen = screenStack.get(lastIndex) ;
			screenStack.remove(lastIndex) ;
		}
		return profileScreen ;
	}
	
	public RelativeLayout getCurrentView(){
		RelativeLayout currentView = null ;
		switch(currentScreen.getKind()){
		case ProfileScreen.SCREEN_KIND_PROFILE:
			currentView = profileView ;
			break ;
		case ProfileScreen.SCREEN_KIND_POSTS:
			currentView = pictureView ;
			break ;
		case ProfileScreen.SCREEN_KIND_FOLLOWERS:
		case ProfileScreen.SCREEN_KIND_FOLLOWINGS:
		case ProfileScreen.SCREEN_KIND_PICTURE_LIKERS:
		case ProfileScreen.SCREEN_KIND_FIND_USER:
			currentView = followView ;
			break ;
		case ProfileScreen.SCREEN_KIND_USER_DESCRIPTION:
		case ProfileScreen.SCREEN_KIND_PICTURE_COMMENT:
			currentView = commentView ;
			break ;
		case ProfileScreen.SCREEN_KIND_MESSAGE:
			currentView = messageView ;
			break ;
		case ProfileScreen.SCREEN_KIND_MESSAGE_SUMMARY:
			currentView = messageSummaryView ;
			break ;
		}
		return currentView ;
	}
	
	
	public void showCurrentView(RelativeLayout previousView,boolean forward){
		switch(currentScreen.getKind()){
		case ProfileScreen.SCREEN_KIND_PROFILE:
			if((previousScreen != null) && (previousScreen.getKind() == ProfileScreen.SCREEN_KIND_FIND_USER)){
				InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
				inputMethodManager.hideSoftInputFromWindow(this.findUserNameEditText.getWindowToken(), 0) ;
			}

			this.showProfileView(rootLayout, previousView,forward) ;
			this.trackPageView(String.format("Profile/%s",currentScreen.getSocialUserId())) ;
			break ;
		case ProfileScreen.SCREEN_KIND_POSTS:
			currentProfileSocialUserId = currentScreen.getSocialUserId() ;
			String pictureId = currentScreen.getPictureId() ;
			if(VeamUtil.isEmpty(pictureId)){
				currentForumObject = new ForumObject(VeamUtil.SPECIAL_FORUM_ID_USER_POST,currentScreen.getSocialUserName(),"0","","",false,0) ;
			} else {
				currentForumObject = new ForumObject(String.format("f:%s",pictureId),"My post","0","","",false,0) ;
			}
			
			boolean recreate = true ;
			if((previousScreen != null) && (previousScreen.getKind() == ProfileScreen.SCREEN_KIND_PICTURE_COMMENT)){
				recreate = false ;
				InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
				inputMethodManager.hideSoftInputFromWindow(commentEditText.getWindowToken(), 0) ;
				this.removeCommentView() ;
			}
			
			this.showPictureView(rootLayout, previousView,forward,recreate,this,false) ;
			this.trackPageView("Forum") ;
			break ;
		case ProfileScreen.SCREEN_KIND_FOLLOWERS:
		case ProfileScreen.SCREEN_KIND_FOLLOWINGS:
		case ProfileScreen.SCREEN_KIND_PICTURE_LIKERS:
			String title = "" ;
			String imageUrl = null ;
			if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_FOLLOWERS){
				imageUrl = currentScreen.getImageUrl() ;
				title = this.getString(R.string.followers) ;
			} else if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_FOLLOWINGS){
				imageUrl = currentScreen.getImageUrl() ;
				title = this.getString(R.string.following) ;
			} else if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_PICTURE_LIKERS){
				title = "Who likes" ;
			}
			this.showFollowView(rootLayout, previousView, forward,false,"",title,imageUrl,this,false) ;
			this.trackPageView(String.format("FollowList")) ;
			break ;
		case ProfileScreen.SCREEN_KIND_FIND_USER:
			this.showFollowView(rootLayout, previousView, forward,true,currentScreen.getFindUserName(),"Search friends",null,this,false) ;
			this.trackPageView(String.format("FindUser")) ;
			break ;
		case ProfileScreen.SCREEN_KIND_USER_DESCRIPTION:
			String defaultString = "" ;
			if(currentProfileDataXml != null){
				defaultString = currentProfileDataXml.getDescription() ;
			}
			this.showCommentView(rootLayout, previousView, forward,defaultString,this.getString(R.string.done)) ;
			this.trackPageView(String.format("PostProfileComment")) ;
			break ;
		case ProfileScreen.SCREEN_KIND_PICTURE_COMMENT:
			this.showCommentView(rootLayout, previousView, forward,"",this.getString(R.string.post)) ;
			this.trackPageView("PostComment") ;
			break ;
		case ProfileScreen.SCREEN_KIND_MESSAGE:
			String userName = currentScreen.getSocialUserName() ;
			this.showMessageView(rootLayout, previousView, forward,userName,this) ;
			this.trackPageView(String.format("MessageList")) ;
			break ;
		case ProfileScreen.SCREEN_KIND_MESSAGE_SUMMARY:
			this.showMessageSummaryView(rootLayout, previousView, forward,currentScreen.getImageUrl(),this) ;
			this.trackPageView(String.format("MessageSummary")) ;
			break ;
		}
	}
	
	public void goForward(ProfileScreen nextScreen){
		RelativeLayout previousView = getCurrentView() ;
		pushScreen(currentScreen) ;
		
		setCurrentScreen(nextScreen) ;
		this.showCurrentView(previousView,true) ;
	}
	
	public void goBackward(){
		RelativeLayout previousView = getCurrentView() ;
		setCurrentScreen(popScreen()) ;
		if(currentScreen == null){
			this.finish() ;
			//overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
			overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out) ;
		} else {
			this.showCurrentView(previousView,false) ;
		}
	}
	
	public boolean isValidSocialUserId(String socialUserId){
		return (!VeamUtil.isEmpty(socialUserId) && !socialUserId.equals("0")) ;
	}
	
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","ProfileActivity::onClick "+view.getId()) ;
		if(view.getId() == this.VIEWID_TOP_BAR_BACK_BUTTON){
			this.goBackward() ;
			//this.onBackButtonClicked() ;
		} else if(view.getId() ==  VIEWID_POSTS_BAR){
			if(this.isValidSocialUserId(currentScreen.getSocialUserId())){
				//VeamUtil.log("debug","username:"+currentScreen.getSocialUserName()) ;
				this.goForward(this.getPostsScreen(currentScreen.getSocialUserId(), currentScreen.getSocialUserName(),"")) ;
			}
		} else if(view.getId() ==  VIEWID_FOLLOWERS_BAR){
			if(this.isValidSocialUserId(currentScreen.getSocialUserId())){
				this.goForward(this.getFollowersScreen(currentScreen.getSocialUserId(), currentScreen.getImageUrl())) ;
			}
		} else if(view.getId() ==  VIEWID_FOLLOWINGS_BAR){
			if(this.isValidSocialUserId(currentScreen.getSocialUserId())){
				this.goForward(this.getFollowingsScreen(currentScreen.getSocialUserId(), currentScreen.getImageUrl())) ;
			}
		} else if(view.getId() ==  VIEWID_FIND_USER_BUTTON){
            /* Find Not Supported
			this.goForward(this.getFindUserScreen()) ;
			*/
		} else if(view.getId() ==  VIEWID_FIND_USER_TEXT){
			if(!isSendingFindUser){
				String findUserName = this.findUserNameEditText.getText().toString() ;
				if(!VeamUtil.isEmpty(findUserName)){
					this.currentScreen.setFindUserName(findUserName) ;
					this.reloadFollow() ;
				}
			}
		} else if(view.getId() ==  VIEWID_MESSAGE_SEND_TEXT){
			String message = this.messageEditText.getText().toString() ;
			if(!VeamUtil.isEmpty(message)){
				this.currentScreen.setMessage(message) ;
				this.sendMessage() ;
			}
		} else if(view.getId() ==  VIEWID_MAP_BUTTON){
            /* MAP NOT SUPPORTED
			String latitude = "0" ;
			String longitude = "0" ;
			ProfileDataXml workProfileDataXml = currentScreen.getProfileDataXml() ;
			if(workProfileDataXml != null){
				latitude = workProfileDataXml.getLatitude() ;
				longitude = workProfileDataXml.getLongitude() ;
			}

			if(	this.isMyProfile() || 
				(!VeamUtil.isEmpty(latitude) && !VeamUtil.isEmpty(longitude) && !(latitude.equals("0") && longitude.equals("0")))){
			
				//VeamUtil.log("debug","map:lat="+latitude + " lng="+longitude) ;
	
				Intent mapIntent = new Intent(this,MapActivity.class) ;
				mapIntent.putExtra("TAB_INDEX", tabNo) ;
				if(VeamUtil.isLogin(this)){
					mapIntent.putExtra("SOCIAL_USER_ID", VeamUtil.getSocialUserId(this)) ;
				} else {
					mapIntent.putExtra("SOCIAL_USER_ID", "0") ;
				}
				mapIntent.putExtra("LATITUDE", latitude) ;
				mapIntent.putExtra("LONGITUDE", longitude) ;
				
				startActivity(mapIntent) ;
				overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out) ;
			}
            */
		} else if(view.getId() == PictureAdapter.VIEWID_COMMENT){
			PictureCommentObject commentObject = (PictureCommentObject)view.getTag() ;
			this.goForward(this.getProfileScreen(commentObject.getSocialUserId(),VeamUtil.htmlUnescape(commentObject.getUserName()))) ;
			
		} else if(view.getId() == PictureAdapter.VIEWID_LIKE_COUNT_VIEW){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			if(pictureObject != null){
				String likes = pictureObject.getLikes() ;
				if(!VeamUtil.isEmpty(likes) && !likes.equals("0")){
					this.goForward(this.getPictureLikersScreen(pictureObject.getId())) ;
				}
			}
		} else if(view.getId() == VIEWID_USER_DESCRIPTION_SCROLL){
			if(this.isMyProfile()){
				if(VeamUtil.isLogin(this)){
					this.operateDescriptionButton() ;
				} else {
					pendingOperation = PENDING_OPERATION_DESCRIPTION ;
					this.login() ;
				}
			}
		} else if(view.getId() == VIEWID_ACTION_IMAGE){
			if(this.isMyProfile()){
				Intent settingsIntent = new Intent(this,SettingsActivity.class) ;
				startActivityForResult(settingsIntent,0) ;
				overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
			} else {
				if(VeamUtil.isLogin(this)){
					this.operateFollow() ;
				} else {
					pendingOperation = PENDING_OPERATION_FOLLOW ;
					pendingImageView = (ImageView)view ;
					this.login() ;
				}
			}
			
		} else if(view.getId() == VIEWID_MESSAGE_IMAGE){
			if(this.isMyProfile()){
				// message summary
				if(VeamUtil.isLogin(this)){
					this.operateMessageSummary() ;
				} else {
					pendingOperation = PENDING_OPERATION_MESSAGE_SUMMARY ;
					this.login() ;
				}
			} else {
				if(VeamUtil.isLogin(this)){
					this.operateMessage() ;
				} else {
					pendingOperation = PENDING_OPERATION_MESSAGE ;
					this.login() ;
				}
			}
			
		} else if(view.getId() == PictureAdapter.VIEWID_USER_NAME){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.goForward(this.getProfileScreen(pictureObject.getSocialUserId(),pictureObject.getUserName())) ;
		} else if(view.getId() == PictureAdapter.VIEWID_USER_ICON){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.goForward(this.getProfileScreen(pictureObject.getSocialUserId(),pictureObject.getUserName())) ;
		} else if(view.getId() == PictureAdapter.VIEWID_LIKE_BUTTON){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			if(VeamUtil.isLogin(this)){
				this.operateLike(pictureObject, (ImageView)view) ;
			} else {
				pendingOperation = PENDING_OPERATION_LIKE ;
				pendingImageView = (ImageView)view ;
				this.login() ;
			}
		} else if(view.getId() == PictureAdapter.VIEWID_FAVORITE_BUTTON){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.operateFavorite(pictureObject, (ImageView)view) ;
		} else if(view.getId() == PictureAdapter.VIEWID_REPORT_BUTTON){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.operateReport(pictureObject) ;
		} else if(view.getId() == VIEWID_POST_BUTTON){
			this.operatePostComment() ;
		} else if(view.getId() == VIEWID_CAMERA_BUTTON){
			if(VeamUtil.isLogin(this)){
				this.operateCameraButton() ;
			} else {
				pendingOperation = PENDING_OPERATION_CAMERA ;
				this.login() ;
			}
		} else if(view.getId() == PictureAdapter.VIEWID_FOLD_COMMENT){
			PictureObject pictureObject = (PictureObject)view.getTag() ;
			pictureObject.setShowAllComments(!pictureObject.isShowAllComments()) ;
			if(pictureAdapter != null){
				pictureAdapter.notifyDataSetChanged() ;
			}
		} else if(view.getId() == PictureAdapter.VIEWID_COMMENT_BUTTON){
			//VeamUtil.log("debug","forumListView") ;
			if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_POSTS){
				PictureObject pictureObject = (PictureObject)pictureAdapter.getItem((Integer)view.getTag()) ;
				if(pictureObject != null){
					//VeamUtil.log("debug","tap comment "+pictureObject.getId()) ;
					currentPictureObject = pictureObject ;
					if(VeamUtil.isLogin(this)){
						this.operateCommentButton() ;
					} else {
						pendingOperation = PENDING_OPERATION_COMMENT ;
						this.login() ;
					}
				}
			}
		} else if(view.getId() == PictureAdapter.VIEWID_DELETE_BUTTON){
			//VeamUtil.log("debug","VIEWID_DELETE_BUTTON") ;
			if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_POSTS){
				PictureObject pictureObject = (PictureObject)pictureAdapter.getItem((Integer)view.getTag()) ;
				if(pictureObject != null){
					//VeamUtil.log("debug","tap delete "+pictureObject.getId()) ;
					String socialUserId = VeamUtil.getSocialUserId(this) ;
					if(!VeamUtil.isEmpty(socialUserId)){
						if(socialUserId.equals(pictureObject.getSocialUserId())){
							currentPictureObject = pictureObject ;
							
							
							AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
					        alertDialogBuilder.setTitle(this.getString(R.string.confirmation));
					        // アラートダイアログのメッセージを設定します
					        alertDialogBuilder.setMessage(this.getString(R.string.are_you_sure_you_want_to_remove));
					        // アラートダイアログの肯定ボタンがクリックされた時に呼び出されるコールバックリスナーを登録します
					        alertDialogBuilder.setPositiveButton(this.getString(R.string.yes),
					                new DialogInterface.OnClickListener() {
					                    @Override
					                    public void onClick(DialogInterface dialog, int which) {
											operateDeleteButton() ;
					                    }
					                });
					        alertDialogBuilder.setNegativeButton(this.getString(R.string.no),
					                new DialogInterface.OnClickListener() {
					                    @Override
					                    public void onClick(DialogInterface dialog, int which) {
					                    }
					                });
					        alertDialogBuilder.setCancelable(false);
					        AlertDialog alertDialog = alertDialogBuilder.create();
					        alertDialog.show();

							
						}
					}
				}
			}
		}
	}
	

	@Override
	public void onSettingsButtonClick(){
		String socialUserId = "" ;
		String socialUserName = "" ;
		if(VeamUtil.isLogin(this)){
			socialUserId = VeamUtil.getSocialUserId(this) ;
			socialUserName = VeamUtil.getSocialUserName(this) ;
		} else {
			socialUserId = "0" ;
			socialUserName = this.getString(R.string.not_logged_in) ;
		}
		this.goForward(this.getProfileScreen(socialUserId,socialUserName)) ;
	}

	
	public void removePictureList(){
		if(pictureView != null){
			pictureView.removeAllViews() ;
			this.rootLayout.removeView(pictureView) ;
			pictureView = null ;
		}
	}

	public void removePostComment(){
		this.commentEditText = null ;
		this.postProgressBar = null ;
		this.postTextView = null ;

		if(commentView != null){
			commentView.removeAllViews() ;
			rootLayout.removeView(commentView) ;
			commentView = null ;
		}
	}

	public void hideForumList(){
		if(mainView != null){
			mainView.setVisibility(View.GONE) ;
		}
	}

	public void showForumList(){
		if(mainView != null){
			mainView.setVisibility(View.VISIBLE) ;
		}
	}

	public void hidePictureList(){
		if(pictureView != null){
			pictureView.setVisibility(View.GONE) ;
		}
	}

	public void showPictureList(){
		if(pictureView != null){
			pictureView.setVisibility(View.VISIBLE) ;
			if(pictureAdapter != null){
				pictureAdapter.notifyDataSetChanged() ;
			}
		}
	}


	
	@Override
	public void onDestroy() {
		/*
	    if(mDb != null){
	    	mDb.close() ;
	    	mDb = null ;
	    }
	    */
	    super.onDestroy();
	}
	
	/*
	public void operateForumButton(){
		this.showPictureView(rootLayout, mainView,false) ;
		if(currentForumObject != null){
			this.trackPageView(String.format("Forum/%s/%s",currentForumObject.getId(),currentForumObject.getName())) ;
		}
	}
	*/
	
	@Override
	public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
		//VeamUtil.log("debug","onItemClick") ;
		if(listView == followListView){
			FollowObject followObject = (FollowObject)followAdapter.getItem(position) ;
			if(followObject != null){
				//VeamUtil.log("debug","user "+followObject.getSocialUserId()) ;
				this.goForward(this.getProfileScreen(followObject.getSocialUserId(),followObject.getSocialUserName())) ;
			}
		} else if(listView == messageSummaryListView){
			MessageObject messageObject = (MessageObject)messageSummaryAdapter.getItem(position) ;
			if(messageObject != null){
				MessageUserObject messageUserObject = messageSummaryAdapter.getMessageUserForId(messageObject.getFromUserId()) ;
				if(messageUserObject != null){
					this.goForward(this.getMessageScreen(messageObject.getFromUserId(),messageUserObject.getName())) ;
				}
			}
		} else if(listView == profileListView){
            /*
			UserNotificationObject userNotificationObject = (UserNotificationObject)profileAdapter.getItem(position) ;
			if(userNotificationObject != null){
				if(userNotificationObject.getKind().equals(UserNotificationObject.USER_NOTIFICATION_KIND_FOLLOW)){
					MessageUserObject messageUserObject = profileAdapter.getMessageUserForId(userNotificationObject.getFromUserId()) ;
					if(messageUserObject != null){
						this.goForward(this.getProfileScreen(userNotificationObject.getFromUserId(),messageUserObject.getName())) ;
					}
				} else if(userNotificationObject.getKind().equals(UserNotificationObject.USER_NOTIFICATION_KIND_COMMENT_PICTURE) ||
							userNotificationObject.getKind().equals(UserNotificationObject.USER_NOTIFICATION_KIND_LIKE_PICTURE)){
					this.goForward(this.getPostsScreen(currentScreen.getSocialUserId(), currentScreen.getSocialUserName(),userNotificationObject.getPictureId())) ;
				}
				
				// mark user notification
        		SendMarkUserNotificationTask sendMarkUserNotificationTask = new SendMarkUserNotificationTask(this,this,userNotificationObject.getId()) ;
        		sendMarkUserNotificationTask.execute("") ;
			}
			*/
		}
		
		/*
		if(listView == this.forumListView){
			//VeamUtil.log("debug","forumListView") ;
			if(VeamUtil.isConnected(this)){
				if(currentView == VIEW_FORUM_LIST){
					currentForumObject = (ForumObject)forumAdapter.getItem((Integer)view.getTag()) ;
					if(currentForumObject != null){
						if(currentForumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_MY_POSTS)){
							if(VeamUtil.isLogin(this)){
								this.operateForumButton() ;
							} else {
								pendingOperation = PENDING_OPERATION_MY_POSTS ;
								this.login() ;
							}
						} else {
							this.operateForumButton() ;
						}
					}
				}
			} else {
				VeamUtil.showMessage(this,this.getString(R.string.not_connected)) ;
			}
		}
		*/
	}
	
	@Override
	public void onPostCommentFinished(PictureCommentObject pictureCommentObject){
		//VeamUtil.log("debug","onPostCommentFinished") ;
		postProgressBar.setVisibility(View.GONE) ;
		postTextView.setVisibility(View.VISIBLE); 
		if(pictureCommentObject != null){
			if(currentPictureObject != null){
				currentPictureObject.addComment(pictureCommentObject) ;
			}
			this.goBackward() ;
		} else {
			
		}
	}

	@Override
	public boolean onTouch(View view, MotionEvent motionEvent) {
		//VeamUtil.log("debug","onTouch") ;
		/*
		if(view == pictureListView){
			int action = motionEvent.getAction() ;
			float x = motionEvent.getX() ;
			float y = motionEvent.getY() ;
			int position = pictureListView.getFirstVisiblePosition();  
			//VeamUtil.log("debug","pictureListView position:" + position + " x:" + x + " y:" + y + " action:" + action) ;
			
			if((position == 0) && (action == MotionEvent.ACTION_DOWN)){
				pictureListDragging = true ;
				pictureListOriginalBottom = pictureListView.getBottom() ;
				dragPreviousY = y ;
			} else if(pictureListDragging && (action == MotionEvent.ACTION_MOVE)){
				float diff = y - dragPreviousY ;
				if(diff > 0){
					int bottom = pictureListView.getBottom() ;
					int top = pictureListView.getTop() +(int)diff ;
					if(top > topBarHeight){
						top = topBarHeight ;
					}
					pictureListView.layout(0, top, deviceWidth, bottom) ;
				}
				dragPreviousY = y ;
			} else if(action == MotionEvent.ACTION_UP){
				pictureListDragging = false ;
				int bottom = pictureListView.getBottom() ;
				pictureListView.layout(0, 0, deviceWidth, pictureListOriginalBottom) ;
			}
				
		}
		*/
		return false;
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		//VeamUtil.log("debug","ForumActivity::onActivityResult resultCode:"+resultCode) ;
		if(requestCode == REQUEST_CAMERA_ACTIVITY){
	    	if(resultCode == 1){
	    		this.reloadPicture() ;
	    	}
		} else if(requestCode == REQUEST_CODE_TWITTER_AUTH){
			//VeamUtil.log("debug","REQUEST_CODE_TWITTER_AUTH") ;
			this.doPendingOperation() ;
		} else {
			Session session = Session.getActiveSession() ;
			if(session != null){
				session.onActivityResult(this, requestCode, resultCode, data);
			}
		}
	}
	
	public void operateReport(PictureObject pictureObject){
		//VeamUtil.log("debug","operateReport") ;
		
		pendingOperation = PENDING_OPERATION_NONE ;
		pendingImageView = null ;
		
		//テキスト入力を受け付けるビューを作成します。
		reportEditText = new EditText(this) ;
		AlertDialog.Builder builder = new AlertDialog.Builder(this) ;
	    builder.setTitle(this.getString(R.string.report_inappropriate_photo)) ;
	    builder.setMessage(this.getString(R.string.why_are_you_reporting_this_photo)) ;
	    builder.setView(reportEditText) ;
        builder.setPositiveButton(this.getString(R.string.report),
	        new DialogInterface.OnClickListener() {
	            @Override
	            public void onClick(DialogInterface dialog, int which) {
	            	//VeamUtil.log("debug","report "+currentPictureObject.getId()+" "+reportEditText.getText().toString()) ;
	        		ReportPictureTask reportPictureTask = new ReportPictureTask(ProfileActivity.this,currentPictureObject.getId(),reportEditText.getText().toString()) ;
	        		reportPictureTask.execute("") ;
	            }
	        });

        builder.setNegativeButton(this.getString(R.string.cancel),null) ;
        AlertDialog dialog = builder.create() ;
	    dialog.show();
	}
	
	public void removeCommentView(){
		if(commentView != null){
			commentView.removeAllViews() ;
			this.rootLayout.removeView(commentView) ;
			commentView = null ;
		}
	}
	
	
	public void showCommentView(RelativeLayout rootLayout,RelativeLayout previousView,boolean forward,String defaultString,String postButtonText){
		//VeamUtil.log("debug","showCommentView") ;
		this.removeCommentView() ;
	
		Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

	
		commentView = this.addFullView(rootLayout, View.VISIBLE) ;
		
		commentEditText = new EditText(this) ;
		commentEditText.setId(VIEWID_USER_DESCRIPTION_TEXT) ;
		commentEditText.setBackgroundColor(Color.argb(0x77,0xFF,0xFF,0xFF)) ;
		commentEditText.setGravity(Gravity.TOP) ;
		commentEditText.setTypeface(typefaceRobotoLight) ;
		if(defaultString != null){
			commentEditText.setText(defaultString) ;
		}
		RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(deviceWidth*94/100,deviceWidth * 45 / 100) ;
		layoutParams.setMargins(deviceWidth*3/100, topBarHeight+deviceWidth*3/100, 0, 0) ;
		commentView.addView(commentEditText,layoutParams) ;
	
		String title = "" ;
		if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_USER_DESCRIPTION){
			title = this.getString(R.string.edit) ;
		} else if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_PICTURE_COMMENT){
			title = this.getString(R.string.comment) ;
		}
		this.addTopBar(commentView, title,true,false) ;
		
		postTextView = new TextView(this) ;
		postTextView.setOnClickListener(this) ;
		postTextView.setId(VIEWID_POST_BUTTON) ;
		postTextView.setText(postButtonText) ;
		postTextView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
		postTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		postTextView.setPadding(0, 0, 0, 0) ;
		postTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*16/100,topBarHeight) ;
		relativeLayoutParams.setMargins(deviceWidth*84/100, 0, 0, 0) ;
		commentView.addView(postTextView, relativeLayoutParams) ;
	
		postProgressBar = new ProgressBar(this) ;
		postProgressBar.setIndeterminate(true) ;
		postProgressBar.setVisibility(View.GONE) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
		layoutParams.setMargins(deviceWidth * 84 / 100, deviceWidth * 2 / 100, 0, 0) ;
		commentView.addView(postProgressBar,layoutParams) ;

		/*
		commentEditText.requestFocus() ;
		InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
		inputMethodManager.showSoftInput(commentEditText, 0);
		*/
		
		if(forward){
			this.doTranslateAnimation(previousView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(commentView, 300, deviceWidth, 0, 0, 0, "doFocusCommentEditText", null) ;
		} else {
			this.doTranslateAnimation(previousView, 300, 0, deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(commentView, 300, -deviceWidth, 0, 0, 0, "doFocusCommentEditText", null) ;
		}
	}
	
	
	public void doFocusCommentEditText(){
		commentEditText.requestFocus() ;
		InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
		inputMethodManager.showSoftInput(commentEditText, 0);
	}


	


	
	
	public void executeLoadFollowTask(){
		int kind = 0 ;
		String userName = "" ;
		String pictureId = "" ;
		if(this.currentScreen.getKind() == ProfileScreen.SCREEN_KIND_FOLLOWINGS){
			kind = LoadFollowTask.FOLLOW_KIND_FOLLOWINGS ;
		} else if(this.currentScreen.getKind() == ProfileScreen.SCREEN_KIND_FOLLOWERS){
			kind = LoadFollowTask.FOLLOW_KIND_FOLLOWERS ;
		} else if(this.currentScreen.getKind() == ProfileScreen.SCREEN_KIND_PICTURE_LIKERS){
			kind = LoadFollowTask.FOLLOW_KIND_PICTURE_LIKERS ;
			pictureId = this.currentScreen.getPictureId() ;
		} else if(this.currentScreen.getKind() == ProfileScreen.SCREEN_KIND_FIND_USER){
			isSendingFindUser = true ;
			kind = LoadFollowTask.FOLLOW_KIND_FIND_USER ;
			userName = this.findUserNameEditText.getText().toString() ;
			findUserProgressBar.setVisibility(View.VISIBLE) ;
			//VeamUtil.log("debug","loadFollowTask to find user") ;
		}
		LoadFollowTask loadFollowTask = new LoadFollowTask(this,this,kind,currentPageNo,currentScreen.getSocialUserId(),pictureId,userName,"") ;
		loadFollowTask.execute("") ;
	}

	@Override
	public void reloadFollow(){
		currentPageNo = 1 ;
		this.executeLoadFollowTask() ;
	}
	
	public void updateFollow(FollowXml followXml,int pageNo){
		
		if((currentScreen != null) && (currentScreen.getKind() == ProfileScreen.SCREEN_KIND_FIND_USER)){
			if(findUserNameEditText != null){
				InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
				inputMethodManager.hideSoftInputFromWindow(this.findUserNameEditText.getWindowToken(), 0) ;
			}
		}
		
		if(followProgressBar != null){
			followProgressBar.setVisibility(View.GONE) ;
		}

		if(findUserProgressBar != null){
			findUserProgressBar.setVisibility(View.GONE) ;
		}
		
		isSendingFindUser = false ;

		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.GONE) ;
		}
		//VeamUtil.log("debug","updateFollow") ;
		if(pageNo == 1){
			followAdapter.setFollows(followXml) ;
		} else {
			followAdapter.addFollows(followXml) ;
		}
		
		followListView.setScrollStateNormal() ;
		followAdapter.notifyDataSetChanged() ;
	}
	
	public void loadMoreFollow(){
		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.VISIBLE) ;
		}
		currentPageNo++ ;
		this.executeLoadFollowTask() ;
	}


	public void onFollowLoadFailed(){
		//VeamUtil.log("debug","onPictureLoadFailed") ;
		this.onBackButtonClicked() ;
	}



	
	
	public void showProfileView(RelativeLayout rootLayout,RelativeLayout previousView,boolean forward){
		
		RelativeLayout.LayoutParams relativeLayoutParams ;  
		LinearLayout.LayoutParams linearLayoutParams ;
		
		boolean recreate = true ;
		if((previousScreen != null) && (previousScreen.getKind() == ProfileScreen.SCREEN_KIND_USER_DESCRIPTION)){
			recreate = false ;
			InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
			inputMethodManager.hideSoftInputFromWindow(commentEditText.getWindowToken(), 0) ;
			this.removeCommentView() ;
			this.updateProfileData(currentProfileDataXml) ;
		}
		
		if(recreate){
			if(profileView != null){
				profileView.removeAllViews() ;
				rootLayout.removeView(profileView) ;
				profileView = null ;
			}
			
			Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");
			
			profileView = this.addMainView(rootLayout, View.VISIBLE) ;
			
			
			
			
			profileListView = new OverScrollListView(this,topBarHeight) ;
			//recipeListView.setVerticalFadingEdgeEnabled(false) ;
			//recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
			profileListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
			profileListView.setOnItemClickListener(this) ;
			profileListView.setBackgroundColor(Color.TRANSPARENT) ;
			profileListView.setCacheColorHint(Color.TRANSPARENT) ;
			profileListView.setVerticalScrollBarEnabled(false) ;
			profileListView.setPadding(0, 0, 0, 0) ;
			profileListView.setDivider(null) ;
			RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
			profileView.addView(profileListView,layoutParams) ;
			
			int findViewHeight = deviceWidth * 14 / 100 ;
			int topMargin = topBarHeight ;
			profileAdapter = new ProfileAdapter(this,this,null,deviceWidth,topMargin,scaledDensity) ;
			profileListView.setAdapter(profileAdapter) ;
			
	
			
			profileProgressBar = new ProgressBar(this) ;
			profileProgressBar.setIndeterminate(true) ;
			profileProgressBar.setVisibility(View.VISIBLE) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
			relativeLayoutParams.setMargins(deviceWidth * 45 / 100, deviceHeight / 2, 0, 0) ;
			profileView.addView(profileProgressBar,relativeLayoutParams) ;
			
	
			this.addTopBar(profileView, this.getString(R.string.profile),true,false) ;
			
			/* Find Not Supported
			RelativeLayout topBarView = (RelativeLayout)profileView.findViewById(VIEWID_TOP_BAR) ;
			ImageView findIconImageView = new ImageView(this) ;
			findIconImageView.setId(VIEWID_FIND_USER_BUTTON) ;
			findIconImageView.setOnClickListener(this) ;
			findIconImageView.setImageResource(R.drawable.top_search) ;
			relativeLayoutParams = createParam(topBarHeight, topBarHeight) ;
			relativeLayoutParams.setMargins(deviceWidth-topBarHeight, 0, 0, 0) ;
			topBarView.addView(findIconImageView,relativeLayoutParams) ;
			*/

		}

		if(forward){
			this.doTranslateAnimation(previousView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(profileView, 300, deviceWidth, 0, 0, 0, "doReloadProfile", null) ;
		} else {
			String nextAction = null ;
			if(previousScreen != null){
				if(previousScreen.getKind() == ProfileScreen.SCREEN_KIND_MESSAGE){
					nextAction = "removeMessageView" ;
				}
			}
			this.doTranslateAnimation(previousView, 300, 0, deviceWidth, 0, 0, nextAction, null) ;
			this.doTranslateAnimation(profileView, 300, -deviceWidth, 0, 0, 0, "doReloadProfile", null) ;
		}

		//this.reloadProfile() ;
	}
	
	public void doReloadProfile(){
		//VeamUtil.log("debug","doReloadProfile") ;
		this.reloadProfile() ;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public void showMessageSummaryView(
			RelativeLayout rootLayout,RelativeLayout previousView,boolean forward,String iconUrl,MessageSummaryAdapter.MessageSummaryAdapterActivityInterface messageSummaryActivity){
		Typeface typefaceRobotoLight= Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");
		
		String screenTitle = "Messages" ;

		if(messageSummaryView != null){
			messageSummaryView.removeAllViews() ;
			rootLayout.removeView(messageSummaryView) ;
			messageSummaryView = null ;
		}
		
		messageSummaryView = this.addMainView(rootLayout, View.VISIBLE) ;

		messageSummaryListView = new OverScrollListView(this,topBarHeight) ;
		//recipeListView.setVerticalFadingEdgeEnabled(false) ;
		//recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
		messageSummaryListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
		messageSummaryListView.setOnItemClickListener(this) ;
		messageSummaryListView.setBackgroundColor(Color.TRANSPARENT) ;
		messageSummaryListView.setCacheColorHint(Color.TRANSPARENT) ;
		messageSummaryListView.setVerticalScrollBarEnabled(false) ;
		messageSummaryListView.setPadding(0, 0, 0, 0) ;
		messageSummaryListView.setDivider(null) ;
		RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
		messageSummaryView.addView(messageSummaryListView,layoutParams) ;
		
		int findViewHeight = deviceWidth * 14 / 100 ;
		int topMargin = topBarHeight ;
		messageSummaryAdapter = new MessageSummaryAdapter(messageSummaryActivity,this,null,deviceWidth,topMargin,scaledDensity) ;
		messageSummaryListView.setAdapter(messageSummaryAdapter) ;
		
		messageSummaryProgressBar = new ProgressBar(this) ;
		messageSummaryProgressBar.setIndeterminate(true) ;
		messageSummaryProgressBar.setVisibility(View.VISIBLE) ;

		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
		layoutParams.setMargins(deviceWidth * 45 / 100, deviceHeight / 2, 0, 0) ;
		messageSummaryView.addView(messageSummaryProgressBar,layoutParams) ;
		
		this.addTopBar(messageSummaryView, screenTitle,true,false) ;
		
		RelativeLayout topBarView = (RelativeLayout)messageSummaryView.findViewById(VIEWID_TOP_BAR) ;
		TextView topBarTitleTextView = (TextView)messageSummaryView.findViewById(VIEWID_TOP_BAR_TITLE) ;
		
		TextPaint paint = topBarTitleTextView.getPaint() ;
		int titleTextWidth = (int)Layout.getDesiredWidth(screenTitle, paint) ;
		//VeamUtil.log("debug","titleTextWidth="+titleTextWidth) ;
		int titleLeft = (deviceWidth - titleTextWidth) / 2 ;
		
		int iconSize = deviceWidth*8/100 ;
		if(!VeamUtil.isEmpty(iconUrl)){
			Bitmap iconBitmap = VeamUtil.getCachedFileBitmapWithWidth(this, iconUrl, iconSize,1, false) ;
			if(iconBitmap != null){
				CircleImageView userIconImageView = new CircleImageView(this) ;
				userIconImageView.setImageBitmap(iconBitmap) ;
				RelativeLayout.LayoutParams relativeLayoutParams = createParam(iconSize, iconSize) ;
				relativeLayoutParams.setMargins(titleLeft-iconSize-deviceWidth*2/100, (topBarHeight-iconSize)/2, 0, 0) ;
				topBarView.addView(userIconImageView,relativeLayoutParams) ;
			}
		}
		
		this.trackPageView(String.format("MessageSummaryList")) ;
		
		loadMoreArea = new LinearLayout(this) ;
		loadMoreArea.setOrientation(LinearLayout.HORIZONTAL) ;
		layoutParams = createParam(deviceWidth, deviceWidth*10/100) ;
		layoutParams.setMargins(0, viewHeight-deviceWidth*10/100, 0, 0) ;
		messageSummaryView.addView(loadMoreArea,layoutParams) ;
		
		TableRow.LayoutParams linearLayoutParams ;

		TextView spacer = new TextView(this) ;
		spacer.setBackgroundColor(Color.TRANSPARENT);
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,1.0f) ;
		loadMoreArea.addView(spacer,linearLayoutParams) ;

		ProgressBar progress = new ProgressBar(this) ;
		progress.setIndeterminate(true) ;
		int progressPadding = deviceWidth*2/100 ;
		progress.setPadding(progressPadding,progressPadding,progressPadding,progressPadding) ;
		linearLayoutParams = new TableRow.LayoutParams(deviceWidth*10/100, deviceWidth*10/100,0.0f) ;
		loadMoreArea.addView(progress,linearLayoutParams) ;
		
		
		loadMoreTextView = new TextView(this) ;
		loadMoreTextView.setText(this.getString(R.string.updating)) ;
		loadMoreTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		loadMoreTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		loadMoreTextView.setTypeface(typefaceRobotoLight) ;
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,0.0f) ;
		loadMoreArea.addView(loadMoreTextView,linearLayoutParams) ;

		spacer = new TextView(this) ;
		spacer.setBackgroundColor(Color.TRANSPARENT);
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,1.0f) ;
		loadMoreArea.addView(spacer,linearLayoutParams) ;
		
		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.GONE) ;
		}

		if(forward){
			this.doTranslateAnimation(previousView, 300, 0, -deviceWidth, 0, 0, "removeProfileView", null) ;
			this.doTranslateAnimation(messageSummaryView, 300, deviceWidth, 0, 0, 0, "doReloadMessageSummary", null) ;
		} else {
			this.doTranslateAnimation(previousView, 300, 0, deviceWidth, 0, 0, "removeMessageView", null) ;
			this.doTranslateAnimation(messageSummaryView, 300, -deviceWidth, 0, 0, 0, "doReloadMessageSummary", null) ;
		}
		
		//messageSummaryActivity.reloadMessageSummary() ;
	}
	
	public void removeMessageView(){
        handler.post( new Runnable() {
            public void run() {
            	doRemoveMessageView() ;
            }
        });
	}

    public void doRemoveMessageView(){ 
		if(messageView != null){
			messageView.removeAllViews() ;
			this.rootLayout.removeView(messageView) ;
			messageView = null ;
		}
	}
	
	public void removeProfileView(){
        handler.post( new Runnable() {
            public void run() {
            	doRemoveProfileView() ;
            }
        });
	}

    public void doRemoveProfileView(){ 
		if(profileView != null){
			profileView.removeAllViews() ;
			this.rootLayout.removeView(profileView) ;
			profileView = null ;
		}
	}
	
	public void doReloadMessageSummary(){
		//VeamUtil.log("debug","doReloadMessageSummary()") ;
		this.reloadMessageSummary() ;
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public void showMessageView(RelativeLayout rootLayout,RelativeLayout previousView,boolean forward,String screenTitle,MessageAdapter.MessageAdapterActivityInterface messageActivity){
		Typeface typefaceRobotoLight= Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");
		
		String title = screenTitle ;
		if(title == null){
			title = "" ;
		}

		if(messageView != null){
			messageView.removeAllViews() ;
			rootLayout.removeView(messageView) ;
			messageView = null ;
		}
		
		//messageView = this.addMainView(rootLayout, View.VISIBLE) ;
		messageView = this.addFullView(rootLayout, View.VISIBLE) ;
		
		/*
		LinearLayout messageResizableView = new LinearLayout(this) ;
		messageResizableView.setOrientation(LinearLayout.VERTICAL) ;
		RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, RelativeLayout.LayoutParams.MATCH_PARENT) ;
		messageView.addView(messageResizableView,layoutParams) ;
		*/

		messageListView = new OverScrollListView(this,topBarHeight) ;
		//recipeListView.setVerticalFadingEdgeEnabled(false) ;
		//recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
		messageListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
		messageListView.setOnItemClickListener(this) ;
		messageListView.setOnOverScrollListViewSizeChangedListener(this) ;
		messageListView.setBackgroundColor(Color.TRANSPARENT) ;
		messageListView.setCacheColorHint(Color.TRANSPARENT) ;
		messageListView.setVerticalScrollBarEnabled(false) ;
		messageListView.setPadding(0, 0, 0, tabHeight) ;
		messageListView.setDivider(null) ;
		RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
		//TableRow.LayoutParams messageLayoutParams = new TableRow.LayoutParams(deviceWidth,viewHeight-tabHeight,1) ; 
		messageView.addView(messageListView,layoutParams) ;
				
		messageInputView = new RelativeLayout(this) ;
		messageInputView.setBackgroundColor(Color.WHITE) ; // FFD5D5D5
		messageInputView.setBackgroundResource(R.drawable.message_input_area) ;
		messageInputView.setVisibility(View.VISIBLE) ;
		layoutParams = createParam(deviceWidth, tabHeight) ;
		layoutParams.setMargins(0,viewHeight-tabHeight, 0, 0) ;
		//messageLayoutParams = new TableRow.LayoutParams(deviceWidth,tabHeight,1) ; 
		messageView.addView(messageInputView,layoutParams) ;


		int editHeight = deviceWidth * 10 / 100 ;
		messageEditText = new EditText(this) ;
		messageEditText.setInputType(InputType.TYPE_CLASS_TEXT);
		messageEditText.setMaxLines(1) ;
		messageEditText.setBackgroundColor(Color.argb(0xFF,0xFF,0xFF,0xFF)) ;
		messageEditText.setBackgroundResource(R.drawable.message_send_text) ;
		messageEditText.setGravity(Gravity.TOP) ;
		messageEditText.setTypeface(typefaceRobotoLight) ;
		messageEditText.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		messageEditText.setOnFocusChangeListener(this) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*80/100,editHeight) ;
		layoutParams.setMargins(deviceWidth*3/100, (tabHeight-editHeight)/2, 0, 0) ;
		messageInputView.addView(messageEditText,layoutParams) ;

		int messageTextHeight = tabHeight ;
		int messageTextWidth = deviceWidth*14/100 ;
		int messageTextX = deviceWidth*86/100 ;
		
		TextView messageSendTextView = new TextView(this) ;
		messageSendTextView.setId(VIEWID_MESSAGE_SEND_TEXT) ;
		messageSendTextView.setOnClickListener(this) ;
		messageSendTextView.setText("Send") ;
		messageSendTextView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
		messageSendTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		messageSendTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		messageSendTextView.setTypeface(typefaceRobotoLight) ;
		layoutParams = new RelativeLayout.LayoutParams(messageTextWidth,messageTextHeight) ;
		layoutParams.setMargins(messageTextX, 0, 0, 0) ;
		messageInputView.addView(messageSendTextView,layoutParams) ;

		
		sendMessageProgressBar = new ProgressBar(this) ;
		sendMessageProgressBar.setIndeterminate(true) ;
		sendMessageProgressBar.setVisibility(View.GONE) ;
		layoutParams = new RelativeLayout.LayoutParams(messageTextHeight,messageTextHeight) ;
		layoutParams.setMargins(messageTextX + (messageTextWidth - messageTextHeight)/2, 0, 0, 0) ;
		messageInputView.addView(sendMessageProgressBar,layoutParams) ;

		
		
		
		
		
		
		
		
		int findViewHeight = deviceWidth * 14 / 100 ;
		int topMargin = topBarHeight ;
		messageAdapter = new MessageAdapter(messageActivity,this,null,deviceWidth,topMargin,scaledDensity) ;
		messageListView.setAdapter(messageAdapter) ;
		
		messageProgressBar = new ProgressBar(this) ;
		messageProgressBar.setIndeterminate(true) ;
		messageProgressBar.setVisibility(View.VISIBLE) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
		layoutParams.setMargins(deviceWidth * 45 / 100, deviceHeight / 2, 0, 0) ;
		messageView.addView(messageProgressBar,layoutParams) ;
		
		this.addTopBar(messageView, title,true,false) ;
		
		ImageView imageView = new ImageView(this) ;
		imageView.setImageResource(R.drawable.message_block_off) ;
		imageView.setId(VIEWID_TOP_BAR_BLOCK_BUTTON) ;
		imageView.setOnClickListener(this) ;
		imageView.setScaleType(ImageView.ScaleType.FIT_XY);
		layoutParams = createParam(topBarHeight, topBarHeight) ;
		layoutParams.setMargins(deviceWidth-topBarHeight, 0, 0, 0) ;
		topBarView.addView(imageView,layoutParams) ;

		
		
		
		RelativeLayout topBarView = (RelativeLayout)messageView.findViewById(VIEWID_TOP_BAR) ;
		TextView topBarTitleTextView = (TextView)messageView.findViewById(VIEWID_TOP_BAR_TITLE) ;
		
		TextPaint paint = topBarTitleTextView.getPaint() ;
		int titleTextWidth = (int)Layout.getDesiredWidth(title, paint) ;
		//VeamUtil.log("debug","titleTextWidth="+titleTextWidth) ;
		int titleLeft = (deviceWidth - titleTextWidth) / 2 ;
		
		this.trackPageView(String.format("MessageList")) ;

		loadMoreArea = new LinearLayout(this) ;
		loadMoreArea.setOrientation(LinearLayout.HORIZONTAL) ;
		layoutParams = createParam(deviceWidth, deviceWidth*10/100) ;
		layoutParams.setMargins(0, viewHeight-deviceWidth*10/100, 0, 0) ;
		messageView.addView(loadMoreArea,layoutParams) ;
		
		TableRow.LayoutParams linearLayoutParams ;

		TextView spacer = new TextView(this) ;
		spacer.setBackgroundColor(Color.TRANSPARENT);
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,1.0f) ;
		loadMoreArea.addView(spacer,linearLayoutParams) ;

		ProgressBar progress = new ProgressBar(this) ;
		progress.setIndeterminate(true) ;
		int progressPadding = deviceWidth*2/100 ;
		progress.setPadding(progressPadding,progressPadding,progressPadding,progressPadding) ;
		linearLayoutParams = new TableRow.LayoutParams(deviceWidth*10/100, deviceWidth*10/100,0.0f) ;
		loadMoreArea.addView(progress,linearLayoutParams) ;
		
		
		loadMoreTextView = new TextView(this) ;
		loadMoreTextView.setText(this.getString(R.string.updating)) ;
		loadMoreTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		loadMoreTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		loadMoreTextView.setTypeface(typefaceRobotoLight) ;
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,0.0f) ;
		loadMoreArea.addView(loadMoreTextView,linearLayoutParams) ;

		spacer = new TextView(this) ;
		spacer.setBackgroundColor(Color.TRANSPARENT);
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,1.0f) ;
		loadMoreArea.addView(spacer,linearLayoutParams) ;
		
		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.GONE) ;
		}

		if(forward){
			this.doTranslateAnimation(previousView, 300, 0, -deviceWidth, 0, 0, "removeAllViewExceptMessageView", null) ;
			this.doTranslateAnimation(messageView, 300, deviceWidth, 0, 0, 0, "doReloadMessage", null) ;
		} else {
			this.doTranslateAnimation(previousView, 300, 0, deviceWidth, 0, 0, "removeAllViewExceptMessageView", null) ;
			this.doTranslateAnimation(messageView, 300, -deviceWidth, 0, 0, 0, "doReloadMessage", null) ;
		}
		
		//messageActivity.reloadMessage() ;
	}
	
	
	public void removeAllViewExceptMessageView(){
        handler.post( new Runnable() {
            public void run() {
            	doRemoveAllViewExceptMessageView() ;
            }
        });
	}

    public void doRemoveAllViewExceptMessageView(){ 
		if(profileView != null){
			profileView.removeAllViews() ;
			this.rootLayout.removeView(profileView) ;
			profileView = null ;
		}
		if(mainView != null){
			mainView.removeAllViews() ;
			this.rootLayout.removeView(mainView) ;
			mainView = null ;
		}
		if(commentView != null){
			commentView.removeAllViews() ;
			this.rootLayout.removeView(commentView) ;
			commentView = null ;
		}
		if(pictureView != null){
			pictureView.removeAllViews() ;
			this.rootLayout.removeView(pictureView) ;
			pictureView = null ;
		}
		if(followView != null){
			followView.removeAllViews() ;
			this.rootLayout.removeView(followView) ;
			followView = null ;
		}
		if(messageSummaryView != null){
			messageSummaryView.removeAllViews() ;
			this.rootLayout.removeView(messageSummaryView) ;
			messageSummaryView = null ;
		}
	}
	

	
	public void doReloadMessage(){
		//VeamUtil.log("debug", "doReloadMessage") ;
		this.reloadMessage() ;
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public boolean isMyProfile(){
		boolean retValue = false ;
		if(currentScreen != null){
			if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_PROFILE){
				String targetSocialUserId = currentScreen.getSocialUserId() ;
				if(VeamUtil.isEmpty(targetSocialUserId) || targetSocialUserId.equals("0")){
					retValue = true ;
				} else {
					if(VeamUtil.isLogin(this)){
						if(targetSocialUserId.equals(VeamUtil.getSocialUserId(this))){
							retValue = true ;
						}
					}
				}
			}
		}
		return retValue ;
	}
	
	public void reloadProfile(){
		String socialUserId = currentScreen.getSocialUserId() ;
		if(!VeamUtil.isEmpty(socialUserId) && !socialUserId.equals("0")){
			LoadProfileDataTask loadProfileDataTask = new LoadProfileDataTask(this,socialUserId) ;
			loadProfileDataTask.execute("") ;
		} else {
			profileProgressBar.setVisibility(View.GONE) ;
		}
	}
	
	public void onProfileDataLoadFailed(){
		
	}
	
	public void updateProfileData(ProfileDataXml profileDataXml){
		currentProfileDataXml = profileDataXml ;
		profileProgressBar.setVisibility(View.GONE) ;
		if(profileDataXml != null){
			if(currentScreen != null){
				currentScreen.setProfileDataXml(profileDataXml) ;
				String userName = currentScreen.getSocialUserName() ;
				if(VeamUtil.isEmpty(userName)){
					currentScreen.setSocialUserName(profileDataXml.getName()) ;
				}
			}
			if(profileView != null){
				profileAdapter.setProfileDataXml(profileDataXml) ;
				profileAdapter.notifyDataSetChanged() ;
				
				String imageUrl = profileDataXml.getImageUrl() ;
				if(!VeamUtil.isEmpty(imageUrl)){
					if((currentScreen != null) && (currentScreen.getKind() == ProfileScreen.SCREEN_KIND_PROFILE)){
						currentScreen.setImageUrl(imageUrl) ;
					}
				}
			}
		}
	}




	public ProfileScreen getProfileScreen(String socialUserId,String socialUserName){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsProfile(socialUserId, socialUserName) ;
		return profileScreen ;
	}

	public ProfileScreen getPostsScreen(String socialUserId,String socialUserName,String pictureId){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsPosts(socialUserId, socialUserName,pictureId) ;
		return profileScreen ;
	}

	public ProfileScreen getFollowingsScreen(String socialUserId,String imageUrl){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsFollowings(socialUserId, imageUrl) ;
		return profileScreen ;
	}

	public ProfileScreen getFollowersScreen(String socialUserId,String imageUrl){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsFollowers(socialUserId, imageUrl) ;
		return profileScreen ;
	}

	public ProfileScreen getPictureLikersScreen(String pictureId){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsPictureLiker(VeamUtil.getSocialUserId(this),pictureId) ;
		return profileScreen ;
	}

	public ProfileScreen getFindUserScreen(){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsFindUser() ;
		return profileScreen ;
	}

	public ProfileScreen getMessageScreen(String socialUserId,String socialUserName){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsMessage(socialUserId,socialUserName) ;
		return profileScreen ;
	}

	public ProfileScreen getMessageSummaryScreen(String socialUserId,String imageUrl){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsMessageSummary(socialUserId,imageUrl) ;
		return profileScreen ;
	}

	public ProfileScreen getPictureCommentScreen(String pictureId){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsPictureComment(pictureId) ;
		return profileScreen ;
	}

	public ProfileScreen getUserCommentScreen(String socialUserId){
		ProfileScreen profileScreen = new ProfileScreen() ;
		profileScreen.setAsUserComment(socialUserId) ;
		return profileScreen ;
	}

	
	public class ProfileScreen {
		public static final int SCREEN_KIND_PROFILE		 	= 0x0001 ;
		public static final int SCREEN_KIND_POSTS		 	= 0x0002 ;
		public static final int SCREEN_KIND_FOLLOWERS	 	= 0x0003 ;
		public static final int SCREEN_KIND_FOLLOWINGS	 	= 0x0004 ;
		public static final int SCREEN_KIND_USER_DESCRIPTION= 0x0005 ;
		public static final int SCREEN_KIND_PICTURE_COMMENT	= 0x0006 ;
		public static final int SCREEN_KIND_FIND_USER	 	= 0x0007 ;
		public static final int SCREEN_KIND_MESSAGE		 	= 0x0008 ;
		public static final int SCREEN_KIND_MESSAGE_SUMMARY	= 0x0009 ;
		public static final int SCREEN_KIND_PICTURE_LIKERS 	= 0x000A ;
		
		private int kind ;
		private String socialUserId ;
		private String socialUserName ;
		private String findUserName ;
		private String message ;
		private String imageUrl ;
		private String pictureId ;
		private ProfileDataXml profileDataXml ;
		
		public ProfileDataXml getProfileDataXml() {
			return profileDataXml;
		}

		public void setProfileDataXml(ProfileDataXml profileDataXml) {
			this.profileDataXml = profileDataXml;
		}

		public void setAsProfile(String socialUserId,String socialUserName){
			this.kind = SCREEN_KIND_PROFILE ;
			this.socialUserId = socialUserId;
			this.socialUserName = socialUserName;
		}

		public void setAsPosts(String socialUserId,String socialUserName,String pictureId){
			this.kind = SCREEN_KIND_POSTS ;
			this.socialUserId = socialUserId;
			this.socialUserName = socialUserName;
			this.pictureId = pictureId ;
		}

		public void setAsFollowings(String socialUserId,String imageUrl){
			this.kind = SCREEN_KIND_FOLLOWINGS ;
			this.socialUserId = socialUserId;
			this.imageUrl = imageUrl;
		}

		public void setAsFollowers(String socialUserId,String imageUrl){
			this.kind = SCREEN_KIND_FOLLOWERS ;
			this.socialUserId = socialUserId;
			this.imageUrl = imageUrl;
		}

		public void setAsPictureLiker(String socialUserId,String pictureId){
			this.kind = SCREEN_KIND_PICTURE_LIKERS ;
			this.pictureId = pictureId;
			this.socialUserId = socialUserId ;
		}

		public void setAsFindUser(){
			this.kind = SCREEN_KIND_FIND_USER ;
		}

		public void setAsMessage(String socialUserId,String socialUserName){
			this.kind = SCREEN_KIND_MESSAGE ;
			this.socialUserId = socialUserId;
			this.socialUserName = socialUserName ;
		}

		public void setAsMessageSummary(String socialUserId,String imageUrl){
			this.kind = SCREEN_KIND_MESSAGE_SUMMARY ;
			this.socialUserId = socialUserId;
			this.imageUrl = imageUrl ;
		}

		public void setAsPictureComment(String pictureId){
			this.kind = SCREEN_KIND_PICTURE_COMMENT ;
			this.pictureId = pictureId;
		}

		public void setAsUserComment(String socialUserId){
			this.kind = SCREEN_KIND_USER_DESCRIPTION ;
			this.socialUserId = socialUserId ;
		}

		public String getSocialUserId() {
			return socialUserId;
		}

		public void setSocialUserId(String socialUserId) {
			this.socialUserId = socialUserId;
		}

		public String getSocialUserName() {
			return socialUserName;
		}

		public void setSocialUserName(String socialUserName) {
			this.socialUserName = socialUserName;
		}

		public String getFindUserName() {
			return findUserName;
		}

		public String getMessage() {
			return message;
		}

		public void setFindUserName(String FindUserName) {
			this.findUserName = FindUserName;
		}

		public void setMessage(String message) {
			this.message = message;
		}

		public int getKind() {
			return kind;
		}

		public void setKind(int kind) {
			this.kind = kind;
		}

		public String getImageUrl() {
			return imageUrl;
		}

		public void setImageUrl(String imageUrl) {
			this.imageUrl = imageUrl;
		}

		public String getPictureId() {
			return pictureId;
		}

		public void setPictureId(String pictureId) {
			this.pictureId = pictureId;
		}
		
		
		
	}


	public void onPostUserDescriptionFinished(Integer result) {
		postProgressBar.setVisibility(View.VISIBLE) ;
		postTextView.setVisibility(View.GONE);
		if(result == 1){
			String comment = commentEditText.getText().toString() ;
			if(currentProfileDataXml != null){
				currentProfileDataXml.setDescription(comment) ;
			}
			this.goBackward() ;
		}
	}
	
	

	public void sendFollowDone(Integer resultCode) {
		if(resultCode == 1){
			this.reloadProfile() ;
		} else {
			profileProgressBar.setVisibility(View.GONE) ;
		}
		//VeamUtil.kickKiip(this,"UserFollow");
	}

	
	
	
	public void sendMessage(){
		if(!isSendingMessage){
			isSendingMessage = true ;
			sendMessageProgressBar.setVisibility(View.VISIBLE) ;
			SendMessageTask sendMessageTask = new SendMessageTask(this,this,VeamUtil.getSocialUserId(this),currentScreen.getSocialUserId(),currentScreen.getMessage()) ;
			sendMessageTask.execute("") ;
		}
	}

	
	
	public void executeLoadMessageTask(){
		LoadMessageTask loadMessageTask = new LoadMessageTask(this,this,currentPageNo,VeamUtil.getSocialUserId(this),currentScreen.getSocialUserId()) ;
		loadMessageTask.execute("") ;
	}

	@Override
	public void reloadMessage() {
		currentPageNo = 1 ;
		this.executeLoadMessageTask() ;
	}
	

	@Override
	public void onMessageSend(Integer result) {
		isSendingMessage = false ;
		sendMessageProgressBar.setVisibility(View.GONE) ;
		if(result == 1){
			messageEditText.setText("") ;
			messageListView.requestFocus() ;
			this.reloadMessage() ;
		}
	}

	@Override
	public void loadMoreMessage() {
		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.VISIBLE) ;
		}
		currentPageNo++ ;
		this.executeLoadMessageTask() ;
	}

	@Override
	public void onMessageLoadFailed() {
		
	}
	
	public void setBlockImage(boolean isBlocked){
		if(messageView != null){
			ImageView imageView = (ImageView)messageView.findViewById(VIEWID_TOP_BAR_BLOCK_BUTTON) ;
			if(imageView != null){
				if(isBlocked){
					imageView.setImageResource(R.drawable.message_block_on) ;
					isBlockedUser = true ;
				} else {
					imageView.setImageResource(R.drawable.message_block_off) ;
					isBlockedUser = false ;
				}
			}
		}
	}

	@Override
	public void updateMessage(MessageXml messageXml, int pageNo) {
		if(messageProgressBar != null){
			messageProgressBar.setVisibility(View.GONE) ;
		}

		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.GONE) ;
		}
		//VeamUtil.log("debug","updatemessage") ;

		setBlockImage(messageXml.isBlocked) ;
		
		if(pageNo == 1){
			messageAdapter.setMessages(messageXml) ;
		} else {
			messageAdapter.addMessages(messageXml) ;
		}
		
		messageListView.setScrollStateNormal() ;
		messageAdapter.notifyDataSetChanged() ;
		
		messageListView.setSelection(messageAdapter.getCount()-1) ;
		
		TextView topBarTitleTextView = (TextView)messageView.findViewById(VIEWID_TOP_BAR_TITLE) ;
		if(topBarTitleTextView != null){
			String title = topBarTitleTextView.getText().toString() ;
			if(VeamUtil.isEmpty(title)){
				String targetSocialUserId = this.currentScreen.getSocialUserId() ;
				MessageUserObject messageUser = messageAdapter.getMessageUserForId(targetSocialUserId) ;
				if(messageUser != null){
					topBarTitleTextView.setText(messageUser.getName()) ;
				}
			}
		}
	}

	
	public void executeLoadMessageSummaryTask(){
		LoadMessageSummaryTask loadMessageSummaryTask = new LoadMessageSummaryTask(this,this,currentPageNo,VeamUtil.getSocialUserId(this)) ;
		loadMessageSummaryTask.execute("") ;
	}

	@Override
	public void reloadMessageSummary() {
		currentPageNo = 1 ;
		this.executeLoadMessageSummaryTask() ;
	}

	@Override
	public void loadMoreMessageSummary() {
		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.VISIBLE) ;
		}
		currentPageNo++ ;
		this.executeLoadMessageSummaryTask() ;
	}

	@Override
	public void onMessageSummaryLoadFailed() {
		
	}

	@Override
	public void updateMessageSummary(MessageXml messageXml, int pageNo) {
		if(messageSummaryProgressBar != null){
			messageSummaryProgressBar.setVisibility(View.GONE) ;
		}

		if(loadMoreArea != null){
			loadMoreArea.setVisibility(View.GONE) ;
		}
		//VeamUtil.log("debug","updatemessage") ;
		if(pageNo == 1){
			messageSummaryAdapter.setMessages(messageXml) ;
		} else {
			messageSummaryAdapter.addMessages(messageXml) ;
		}
		
		messageSummaryListView.setScrollStateNormal() ;
		messageSummaryAdapter.notifyDataSetChanged() ;
	}

	@Override
	public void resetProfileButton(){
		super.resetProfileButton() ;
		boolean hasNewNotification = VeamUtil.hasNewNotification(this) ;
		resetProfileButtonForView(mainView,hasNewNotification) ;
		resetProfileButtonForView(commentView,hasNewNotification) ;
		resetProfileButtonForView(profileView,hasNewNotification) ;
		resetProfileButtonForView(messageSummaryView,hasNewNotification) ;
		resetProfileButtonForView(messageView,hasNewNotification) ;
	}
	
	@Override
	public void operateNewProfileNotification(){
		if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_PROFILE){
			if(this.isMyProfile()){
				this.reloadProfile() ;
			}
		}
	}
	
	@Override
	public void operateNewMessage(){
		if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_MESSAGE){
			this.reloadMessage() ;
		} else if(currentScreen.getKind() == ProfileScreen.SCREEN_KIND_MESSAGE_SUMMARY){
			this.reloadMessageSummary() ;
		}
	}

	@Override
	public void onOverScrollListViewSizeChanged(int w, int h, int oldw, int oldh) {
		//VeamUtil.log("debug","onOverScrollListViewSizeChanged h="+h) ;
	}

	@Override
	public void onOverScrollListViewHeightChanged(int newHeight, int oldHeight) {
		//VeamUtil.log("debug","onOverScrollListViewHeightChanged h="+newHeight) ;
		final int targetHeight = newHeight ;
		if(messageInputView != null){
			RelativeLayout.LayoutParams relativeLayoutParams = (RelativeLayout.LayoutParams)messageInputView.getLayoutParams() ;
			relativeLayoutParams.setMargins(0, targetHeight-tabHeight, 0, 0) ;
			messageInputView.setLayoutParams(relativeLayoutParams) ;
			messageInputView.invalidate() ;
			messageInputView.requestLayout() ;
		}
		if(baseBackgroundImageView != null){
			if(newHeight < (viewHeight - tabHeight)){
				//VeamUtil.log("debug","CENTER_CROP") ;
				baseBackgroundImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
			} else {
				//VeamUtil.log("debug","FIT_XY") ;
				baseBackgroundImageView.setScaleType(ImageView.ScaleType.FIT_XY);
			}
		}


		/*
        handler.post( new Runnable() {
            public void run() {
        		if(messageInputView != null){
        			RelativeLayout.LayoutParams relativeLayoutParams = (RelativeLayout.LayoutParams)messageInputView.getLayoutParams() ;
        			relativeLayoutParams.setMargins(0, targetHeight-tabHeight, 0, 0) ;
        			messageInputView.setLayoutParams(relativeLayoutParams) ;
        			messageInputView.invalidate() ;
        			messageInputView.requestLayout() ;
        		}
            }
        });
        */

	}

	@Override
	public void onFocusChange(View view, boolean hasFocus) {
		//VeamUtil.log("debug","onFocusChange") ;
		if (hasFocus == false) {
            // ソフトキーボードを非表示にする
            InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }		
	}
	

	
    @Override  
    protected void onNewIntent(Intent intent) {  
        super.onNewIntent(intent);  

		boolean isNotification = intent.getBooleanExtra("IS_NOTIFICATION", false) ;
		if(isNotification){
	        NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE) ;
	        notificationManager.cancel(1);
		}
		tabNo = intent.getIntExtra("TAB_INDEX", 0) ;
		/*
		String socialUserId = intent.getStringExtra("SOCIAL_USER_ID") ;
		String socialUserName = intent.getStringExtra("SOCIAL_USER_NAME") ;
		String notificationKind = intent.getStringExtra("NOTIFICATION_KIND") ;
		String pictureId = intent.getStringExtra("PICTURE_ID") ;
		//VeamUtil.log("debug","profile activity new intent " + isNotification + " "+notificationKind+" "+socialUserId + " "+ pictureId) ;
		*/
    }

	



}
