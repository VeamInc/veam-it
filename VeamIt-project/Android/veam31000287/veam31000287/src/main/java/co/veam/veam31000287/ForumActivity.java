package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Layout;
import android.text.TextPaint;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.facebook.Session;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.NativeExpressAdView;

import co.veam.veam31000287.FollowAdapter.FollowAdapterActivityInterface;


public class ForumActivity extends VeamActivity implements OnClickListener, OnItemClickListener, OnTouchListener, FollowAdapterActivityInterface{
	/*
	private DatabaseHelper helper ;
	SQLiteDatabase mDb ;
	*/
	private RelativeLayout rootLayout ;
	private RelativeLayout mainView ;
	private RelativeLayout commentView ;
	private ListView forumListView ;
	private ForumAdapter forumAdapter ;
	private EditText commentEditText ;
	
	private int currentFollowKind = 0 ;

	InterstitialAd mInterstitialAd;


	/*
	private boolean pictureListDragging = false ;
	private float dragPreviousY = 0 ;
	private int pictureListOriginalBottom = 0 ;
	*/
	
	private EditText reportEditText ;
	
	private int pendingOperation ;
	private ImageView pendingImageView ;
	private static int PENDING_OPERATION_NONE				= 0 ;
	private static int PENDING_OPERATION_LIKE				= 1 ;
	private static int PENDING_OPERATION_COMMENT			= 2 ;
	private static int PENDING_OPERATION_DELETE			= 3 ;
	private static int PENDING_OPERATION_CAMERA			= 4 ;
	private static int PENDING_OPERATION_MY_POSTS			= 5 ;
	//private static int PENDING_OPERATION_ADD_FORUM_GROUP	= 6 ;
	
	//private String currentForumName ;
	
	public static int VIEWID_COMMENT_TEXT		= 0x10001 ;
	public static int VIEWID_POST_BUTTON		= 0x10002 ;
	
	private int currentView ;
	private static int VIEW_FORUM_LIST 				= 1 ;
	private static int VIEW_PICTURE_LIST 				= 2 ;
	private static int VIEW_COMMENT		 			= 3 ;
	private static int VIEW_PICTURE_LIKER 			= 4 ;
	//private static int VIEW_FORUM_GROUP_CATEGORY_LIST	= 5 ;
	//private static int VIEW_FORUM_GROUP_LIST			= 6 ;
	
	private static int REQUEST_CAMERA_ACTIVITY		= 1 ;

	private static final int TEMPLATE_ID = 2 ;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_forum);

		/*
		helper = new DatabaseHelper(this) ;
		mDb = helper.getReadableDatabase() ;
		*/

		this.pageName = "ForumList" ;

		mInterstitialAd = new InterstitialAd(this);
		mInterstitialAd.setAdUnitId(this.getString(R.string.admob_id_postpicture));
		requestNewInterstitial();

		mInterstitialAd.setAdListener(new AdListener() {
			@Override
			public void onAdClosed() {
				requestNewInterstitial();
			}
		});


		RelativeLayout.LayoutParams layoutParams ;
		
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		
		this.addBaseBackground(rootLayout) ;
		this.addTab(rootLayout, TEMPLATE_ID,true) ;
		mainView = this.addMainView(rootLayout,View.VISIBLE) ;
		
		forumListView = new ListView(this) ;
		//categoryListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
		forumListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
		forumListView.setBackgroundColor(Color.TRANSPARENT) ;
		forumListView.setCacheColorHint(Color.TRANSPARENT) ;
		forumListView.setVerticalScrollBarEnabled(false) ;
		forumListView.setOnItemClickListener(this) ;
		//categoryListView.setOnScrollListener(this) ;
		forumListView.setPadding(0, 0, 0, 0) ;
		forumListView.setDivider(null) ;
		layoutParams = createParam(deviceWidth, viewHeight) ;
		mainView.addView(forumListView,layoutParams) ;
		
		this.addTopBar(mainView, this.getString(R.string.forum),false,true) ;
		
		ForumObject[] forumObjects = VeamUtil.getForumObjects(mDb) ;
		ForumGroupXml forumGroupXml = ForumGroupXml.getCachedInstance(this) ;
		forumAdapter = new ForumAdapter(this,forumObjects,forumGroupXml.getForumGroups(),deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_forumcategory), AdSize.SMART_BANNER) ;
		forumListView.setAdapter(forumAdapter) ;
		
		pictureView = null ;
		currentView = VIEW_FORUM_LIST ;
		pendingOperation = PENDING_OPERATION_NONE ;
		
		//mainView.setVisibility(View.GONE) ;
		
		//this.loadEntryForumGroup() ;

		//this.showFollowingPictures() ;

		this.createFloatingMenu(rootLayout);
		setSwipeView(forumListView) ;

		/*
		NativeExpressAdView adView = new NativeExpressAdView(this);
		//adView.setId(VIEWID_NATIVE_AD);
		adView.setAdSize(new AdSize(360, 320));
		//VeamUtil.log("debug", "setAdUnit " + adUnitId) ;
		adView.setAdUnitId(this.getString(R.string.admob_id_forum_native));


		layoutParams = createParam(720, 640) ;
		layoutParams.setMargins(0,100,0,0);
		mainView.addView(adView, layoutParams);
		adView.loadAd(VeamUtil.getAdRequest());
		*/


	}
	
	public void showFollowingPictures()	{
		currentForumObject = new ForumObject(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS,this.getString(R.string.following),"0","0","0",false,0) ;
		this.operateForumButton() ;
	}
	
	@Override
	public void onBackButtonClicked(){
		//VeamUtil.log("debug","back button tapped") ;
		if(currentView == VIEW_PICTURE_LIST){
            /*
			if((this.currentForumObject != null) && (currentForumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS))){
				this.showForumList() ;
				// reverse
				this.doTranslateAnimation(mainView, 300, deviceWidth, 0, 0, 0, "showForumList", null) ;
				this.doTranslateAnimation(pictureView, 300, 0, -deviceWidth, 0, 0, "removePictureList", null) ;
			} else {
				this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showForumList", null) ;
				this.doTranslateAnimation(pictureView, 300, 0, deviceWidth, 0, 0, "removePictureList", null) ;
			}
			*/
            this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showForumList", null) ;
            this.doTranslateAnimation(pictureView, 300, 0, deviceWidth, 0, 0, "removePictureList", null) ;
			currentView = VIEW_FORUM_LIST ;
			this.showFloatingMenu();
		} else if(currentView == VIEW_FORUM_LIST){
			// show following
			// this.showFollowingPictures() ;
		} else if(currentView == VIEW_COMMENT){
			this.finishCommentView() ;
		} else if(currentView == VIEW_PICTURE_LIKER){
			this.doTranslateAnimation(pictureView, 300, -deviceWidth, 0, 0, 0, "showPictureList", null) ;
			this.doTranslateAnimation(followView, 300, 0, deviceWidth, 0, 0, "removeFollowView", null) ;
			currentView = VIEW_PICTURE_LIST ;
			this.hideFloatingMenu();
		}
	}
	
	@Override
	public void finishCommentView(){
		if(currentView == VIEW_COMMENT) {
			InputMethodManager inputMethodManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
			inputMethodManager.hideSoftInputFromWindow(commentEditText.getWindowToken(), 0);
			this.doTranslateAnimation(pictureView, 300, -deviceWidth, 0, 0, 0, "showPictureList", null);
			this.doTranslateAnimation(commentView, 300, 0, deviceWidth, 0, 0, "removePostComment", null);
			currentView = VIEW_PICTURE_LIST;
			this.hideFloatingMenu();
			if (currentForumObject != null) {
				this.trackPageView(String.format("Forum/%s/%s", currentForumObject.getId(), currentForumObject.getName()));
			}

			// ad
			if (mInterstitialAd.isLoaded()) {
				mInterstitialAd.show();
			}
		}
	}
	
	
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
		} else if(pendingOperation == PENDING_OPERATION_CAMERA){
			//VeamUtil.log("debug","pending : camera ") ;
			this.operateCameraButton() ;
		} else if(pendingOperation == PENDING_OPERATION_MY_POSTS){
			//VeamUtil.log("debug","pending : camera ") ;
			this.operateForumButton() ;
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
			imageView.setImageBitmap(VeamUtil.getThemeImage(this,"forum_like_button_on",1)) ;
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
            //imageView.setImageResource(R.drawable.add_on) ;
            imageView.setImageBitmap(VeamUtil.getThemeImage(this,"add_on",1)) ;

			//VeamUtil.kickKiip(this,"PictureFavorite");
		}
	}
	
	public void operateDeleteButton(){
		DeletePictureTask deletePictureTask = new DeletePictureTask(this,currentPictureObject) ;
		deletePictureTask.execute("") ;
	}
	
	public void operateCommentButton(){
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
		
		commentEditText.requestFocus() ;
		InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
		inputMethodManager.showSoftInput(commentEditText, 0);
		
		this.doTranslateAnimation(pictureView, 300, 0, -deviceWidth, 0, 0, "hidePictureList", null) ;
		this.doTranslateAnimation(commentView, 300, deviceWidth, 0, 0, 0, null, null) ;
		currentView = VIEW_COMMENT ;
		this.hideFloatingMenu();
		if(currentPictureObject != null){
			this.trackPageView(String.format("PostComment/%s",currentPictureObject.getId())) ;
		}
	}
	
	public void operateCameraButton(){
		Intent cameraIntent = new Intent(this,CameraActivity.class) ;
		cameraIntent.putExtra("forum_id", currentForumObject.getId()) ;
		startActivityForResult(cameraIntent,REQUEST_CAMERA_ACTIVITY) ;
		overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
	}
	
	public void operatePostComment(){
		String comment = commentEditText.getText().toString() ;
		if(VeamUtil.isEmpty(comment)){
			VeamUtil.showMessage(this, this.getString(R.string.please_input_comment)) ;
		} else {
			PostCommentTask postCommentTask = new PostCommentTask(this,currentPictureObject.getId(),comment) ;
			postCommentTask.execute("") ;
			postProgressBar.setVisibility(View.VISIBLE) ;
			postTextView.setVisibility(View.GONE);
		}
	}
	
	public void showProfileActivity(String socialUserId,String socialUserName){
		Intent profileIntent = new Intent(this,ProfileActivity.class) ;
		profileIntent.putExtra("TAB_INDEX", tabNo-1) ;
		profileIntent.putExtra("SOCIAL_USER_ID", socialUserId) ;
		profileIntent.putExtra("SOCIAL_USER_NAME", socialUserName) ;
		startActivityForResult(profileIntent,0) ;
		overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out) ;
	}
	
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","ForumActivity::onClick") ;
		if(view.getId() == this.VIEWID_TOP_BAR_BACK_BUTTON){
			this.onBackButtonClicked() ;
		} else if(view.getId() == PictureAdapter.VIEWID_USER_NAME){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.showProfileActivity(pictureObject.getSocialUserId(), pictureObject.getUserName()) ;
		} else if(view.getId() == PictureAdapter.VIEWID_USER_ICON){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.showProfileActivity(pictureObject.getSocialUserId(), pictureObject.getUserName()) ;
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
		} else if(view.getId() == PictureAdapter.VIEWID_LIKE_COUNT_VIEW){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			currentFollowKind = LoadFollowTask.FOLLOW_KIND_PICTURE_LIKERS ;
			//VeamUtil.log("debug","like count tapped : " + position + " num=" + pictureObject.getLikes()) ;
			int numberOfLikes = VeamUtil.parseInt(pictureObject.getLikes()) ;
			if(numberOfLikes > 0){
				this.showFollowView(rootLayout, pictureView, true,false,"", "Who likes", null, this,false) ;
				currentView = VIEW_PICTURE_LIKER;
				this.hideFloatingMenu();
			}
		} else if (view.getId() == PictureAdapter.VIEWID_FAVORITE_BUTTON){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.operateFavorite(pictureObject, (ImageView) view);
		} else if(view.getId() == PictureAdapter.VIEWID_REPORT_BUTTON){
			Integer position = (Integer)view.getTag() ;
			PictureObject pictureObject = (PictureObject)this.pictureAdapter.getItem(position) ;
			currentPictureObject = pictureObject ;
			this.operateReport(pictureObject) ;
		} else if(view.getId() == VIEWID_POST_BUTTON){
			this.operatePostComment() ;
		} else if(view.getId() == VIEWID_CAMERA_BUTTON){
			if(VeamUtil.isLogin(this)){
				this.operateCameraButton();
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
		} else if(view.getId() == PictureAdapter.VIEWID_COMMENT){
			PictureCommentObject commentObject = (PictureCommentObject)view.getTag() ;
			this.showProfileActivity(commentObject.getSocialUserId(), VeamUtil.htmlUnescape(commentObject.getUserName())) ;
		} else if(view.getId() == PictureAdapter.VIEWID_COMMENT_BUTTON){
			//VeamUtil.log("debug","forumListView") ;
			if(currentView == VIEW_PICTURE_LIST){
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
			if(currentView == VIEW_PICTURE_LIST){
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
	
	public void removePictureList(){
		if(pictureView != null){
			pictureView.removeAllViews() ;
			this.rootLayout.removeView(pictureView) ;
			pictureView = null ;
		}
	}

	public void removeFollowView(){
		if(followView != null){
			followView.removeAllViews() ;
			this.rootLayout.removeView(followView) ;
			followView = null ;
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
	
	public void operateForumButton(){
		boolean forward = true ;
        /*
		if((this.currentForumObject != null) && (currentForumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS))){
			forward = false ;
		}
		*/
		this.showPictureView(rootLayout, mainView,forward,true,this,true) ;
		currentView = VIEW_PICTURE_LIST ;
		this.hideFloatingMenu();
		if(currentForumObject != null){
			this.trackPageView(String.format("Forum/%s/%s", currentForumObject.getId(), currentForumObject.getName())) ;
		}
	}
	
	@Override
	public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
		//VeamUtil.log("debug","onItemClick") ;
		if(listView == this.forumListView){
			//VeamUtil.log("debug","forumListView") ;
			if(VeamUtil.isConnected(this)){
				if(currentView == VIEW_FORUM_LIST){
					int viewType = forumAdapter.getItemViewType(position) ;
					if(viewType == ForumAdapter.TYPE_FORUM){
						ForumObject forumObject = (ForumObject)forumAdapter.getItem((Integer)view.getTag()) ;
						if(forumObject != null){
							if(forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_MY_PROFILE)){
								VeamUtil.setHasNewNotification(this, false) ;
								this.onSettingsButtonClick() ;
							} else {
								currentForumObject = forumObject ;
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
						}
					}
				}
			} else {
				VeamUtil.showMessage(this,this.getString(R.string.not_connected)) ;
			}
		} else if(listView == followListView){
			FollowObject followObject = (FollowObject)followAdapter.getItem(position) ;
			if(followObject != null){
				//VeamUtil.log("debug","user "+followObject.getSocialUserId()) ;
				this.showProfileActivity(followObject.getSocialUserId(),followObject.getSocialUserName()) ;
			}
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
				//VeamUtil.kickKiip(this, "1 Picture");
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
	        		ReportPictureTask reportPictureTask = new ReportPictureTask(ForumActivity.this,currentPictureObject.getId(),reportEditText.getText().toString()) ;
	        		reportPictureTask.execute("") ;
	            }
	        });

        builder.setNegativeButton(this.getString(R.string.cancel), null) ;
        AlertDialog dialog = builder.create() ;
	    dialog.show();
	}

	public void executeLoadFollowTask(){
		if(currentFollowKind == LoadFollowTask.FOLLOW_KIND_PICTURE_LIKERS){
			String socialUserId = VeamUtil.getSocialUserId(this) ;
			LoadFollowTask loadFollowTask = new LoadFollowTask(this,this,LoadFollowTask.FOLLOW_KIND_PICTURE_LIKERS,currentPageNo,socialUserId,currentPictureObject.getId(),"","") ;
			loadFollowTask.execute("") ;
		}
	}

	@Override
	public void reloadFollow(){
		currentPageNo = 1 ;
		this.executeLoadFollowTask() ;
	}
	
	public void updateFollow(FollowXml followXml,int pageNo){
		if(currentFollowKind == LoadFollowTask.FOLLOW_KIND_PICTURE_LIKERS){
			if(followProgressBar != null){
				followProgressBar.setVisibility(View.GONE) ;
			}
	
			loadMoreArea.setVisibility(View.GONE) ;
			//VeamUtil.log("debug","updateFollow") ;
			if(pageNo == 1){
				followAdapter.setFollows(followXml) ;
			} else {
				followAdapter.addFollows(followXml) ;
			}
			
			followListView.setScrollStateNormal() ;
			followAdapter.notifyDataSetChanged() ;
		}
	}
	
	public void loadMoreFollow(){
		loadMoreArea.setVisibility(View.VISIBLE) ;
		currentPageNo++ ;
		this.executeLoadFollowTask() ;
	}


	public void onFollowLoadFailed(){
		//VeamUtil.log("debug","onPictureLoadFailed") ;
		this.onBackButtonClicked() ;
	}

	@Override
	public void resetProfileButton(){
		super.resetProfileButton() ;
		boolean hasNewNotification = VeamUtil.hasNewNotification(this) ;
		resetProfileButtonForView(mainView,hasNewNotification) ;
		resetProfileButtonForView(commentView, hasNewNotification) ;

	}

	private void requestNewInterstitial() {
		if(VeamUtil.isActiveAdmob) {
			mInterstitialAd.loadAd(VeamUtil.getAdRequest());
		}
	}

	@Override
	protected int getFloatingMenuKind(){
		return FLOATING_MENU_KIND_EDIT_AND_TUTORIAL ;
	}

	@Override
	protected boolean startEditModeActivity(){
		VeamUtil.log("debug", "startEditModeActivity") ;
		if(!super.startEditModeActivity()) {
			Intent intent = new Intent(this, ConsoleForumActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.forum_theme));
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 3);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, TEMPLATE_ID);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		}
		return true ;
	}

	@Override
	protected void startTutorialActivity(){
		VeamUtil.log("debug", "startTutorialActivity") ;
		Intent intent = new Intent(this,ConsoleTutorialActivity.class) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.forum_tutorial)) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,3) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,2) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND,ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM) ;
		startActivity(intent);
		overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
	}

	@Override
	public void onContentsUpdated(){
		VeamUtil.log("debug", "ForumActivity::onContentsUpdated") ;
		if(forumListView != null) {
			ForumObject[] forumObjects = VeamUtil.getForumObjects(mDb) ;
			ForumGroupXml forumGroupXml = ForumGroupXml.getCachedInstance(this) ;
			forumAdapter = new ForumAdapter(this,forumObjects,forumGroupXml.getForumGroups(),deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_forumcategory), AdSize.SMART_BANNER) ;
			forumListView.setAdapter(forumAdapter) ;
		}
	}


}

