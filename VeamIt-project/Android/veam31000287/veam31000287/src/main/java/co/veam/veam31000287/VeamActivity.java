package co.veam.veam31000287;

import java.io.Console;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.text.Editable;
import android.text.InputType;
import android.text.Layout;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.TextUtils.TruncateAt;
import android.text.TextWatcher;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.Interpolator;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.webkit.WebSettings.PluginState;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;
import co.veam.veam31000287.SocialLoginTask.SocialLoginTaskActivityInterface;

/*
import me.kiip.sdk.Kiip;
import me.kiip.sdk.KiipFragment;
import me.kiip.sdk.KiipFragmentCompat;
import me.kiip.sdk.Poptart;
*/

import com.facebook.Request;
import com.facebook.Response;
import com.facebook.Session;
import com.facebook.SessionState;
import com.facebook.model.GraphUser;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.youtube.player.YouTubeBaseActivity;
import com.google.android.youtube.player.YouTubeInitializationResult;
import com.google.android.youtube.player.YouTubePlayer;
import com.google.android.youtube.player.YouTubePlayer.OnInitializedListener;
import com.google.android.youtube.player.YouTubePlayer.Provider;
import com.google.android.youtube.player.YouTubePlayerView;

import com.google.android.gms.analytics.Tracker;


//public class VeamActivity extends FragmentActivity implements OnClickListener {
public class VeamActivity extends YouTubeBaseActivity implements OnClickListener, OnInitializedListener, OnItemClickListener, SocialLoginTaskActivityInterface, TextWatcher, OnFocusChangeListener {


	/*
	private final static String KIIP_TAG = "kiip_fragment_tag";
	private KiipFragment mKiipFragment;
	*/


	private DatabaseHelper helper;
	SQLiteDatabase mDb;

	protected Handler handler = null ;

	public static final int VIEWID_TAB_BUTTON = 0x30000;
	public static final int VIEWID_TOP_BAR_BACK_BUTTON = 0x30001;
	public static final int VIEWID_TOP_BAR_SETTINGS_BUTTON = 0x30002;
	public static final int VIEWID_BROWSER_BACKWARD_BUTTON = 0x30003;
	public static final int VIEWID_BROWSER_FORWARD_BUTTON = 0x30004;
	public static final int VIEWID_ADD_FAVORITE_VIDEO = 0x30005;
	public static final int VIEWID_CAMERA_BUTTON = 0x30006;
	public static final int VIEWID_TOP_BAR = 0x30007;
	public static final int VIEWID_TOP_BAR_TITLE = 0x30008;
	public static final int VIEWID_FIND_USER_TEXT = 0x30009;
	public static final int VIEWID_FORUM_GROUP_SEGMENT_POST = 0x3000a;
	public static final int VIEWID_FORUM_GROUP_SEGMENT_NUMBER = 0x3000b;
	public static final int VIEWID_FIND_USER_EDIT_TEXT = 0x3000c;
	public static final int VIEWID_SIGN_OUT_BUTTON = 0x3000d;
	public static final int VIEWID_SIDE_MENU_VIEW = 0x3000e;
	public static final int VIEWID_SIDE_MENU_SCROLL_VIEW = 0x3000f;

	public static final int VIEWID_SIDE_MENU_GOTO_PREVIEW = 0x30010;
	public static final int VIEWID_SIDE_MENU_GOTO_HOME = 0x30011;
	public static final int VIEWID_SIDE_MENU_CUSTOMIZE = 0x30012;
	public static final int VIEWID_SIDE_MENU_PAYMENT_TYPE = 0x30013;
	public static final int VIEWID_SIDE_MENU_APP_STORE = 0x30014;
	public static final int VIEWID_SIDE_MENU_TERMS = 0x30015;
	public static final int VIEWID_SIDE_MENU_SUBMIT = 0x30016;
	public static final int VIEWID_SIDE_MENU_HELP = 0x30017;
	public static final int VIEWID_SIDE_MENU_FAQ = 0x30018;
	public static final int VIEWID_SIDE_MENU_SIGN_OUT = 0x30019;
	public static final int VIEWID_SIDE_MENU_PUBLISH = 0x3001a;
	private static final int VIEWID_FLOATING_TEXT1      = 0x3001b ;
	private static final int VIEWID_FLOATING_TEXT2      = 0x3001c ;
	private static final int VIEWID_FLOATING_TEXT3      = 0x3001d ;
	public static final int VIEWID_SIDE_MENU_ESCAPE = 0x3001e;
	public static final int VIEWID_INITIAL_TUTORIAL_NEXT = 0x3001f;

	protected static final int FLOATING_MENU_KIND_NONE                    = 0 ;
	protected static final int FLOATING_MENU_KIND_EDIT                    = 2 ;
	protected static final int FLOATING_MENU_KIND_EDIT_AND_TUTORIAL       = 3 ;



	public static int REQUEST_CODE_TWITTER_AUTH = 0x30001;


	protected int deviceWidth;
	protected int deviceHeight;
	protected int tabHeight = 0;
	protected float scaledDensity;
	protected int circleSize;
	protected int circleLeft;
	protected int circleTop;
	protected int circleBoundaryLeft;
	protected int circleBoundaryRight;
	protected int circleBoundaryTop;
	protected int circleBoundaryBottom;
	protected boolean isCircleMoving;
	protected ImageView animationCircleImageView;
	protected ImageView titleCircleImageView;
	protected String pageName = "";
	protected ImageView tabBackImageView;
	protected ImageView tabSelectedImageView;
	protected ImageView[] tabImageViews;
	protected TextView[] tabTitleViews;
	protected View[] tabButtonViews;
	protected int numberOfTabs;
	protected int viewHeight = 0;
	protected int topBarHeight = 0;
	protected ImageView backwardImageView;
	protected ImageView forwardImageView;
	protected RelativeLayout webView;
	protected WebView webPageView;
	protected ProgressBar browserProgress;
	protected RelativeLayout youtubeDetailView;
	protected YouTubePlayer currentYoutubePlayer;
	protected String printableId;
	protected RelativeLayout pictureView;
	protected OverScrollListView pictureListView;
	protected OverScrollListView groupMemberListView;
	protected PictureAdapter pictureAdapter;
	protected ProgressBar pictureProgressBar;
	protected TextView loadMoreTextView;
	protected LinearLayout loadMoreArea;
	protected ProgressBar postProgressBar;
	protected TextView postTextView;
	protected ImageView cameraButtonImageView;
	protected RelativeLayout veamItMenuView;
	View veamItMenuBackView ;

	protected ProgressBar updateProgress ;


	protected int currentPageNo = 1;
	protected int currentTitleNo;
	protected String currentYoutubeVideoId;
	protected YoutubeObject currentYoutubeObject;
	protected ForumObject currentForumObject;
	protected String currentProfileSocialUserId;
	protected PictureObject currentPictureObject;


	protected RelativeLayout followView;
	protected OverScrollListView followListView;
	protected FollowAdapter followAdapter;
	protected ProgressBar followProgressBar;
	protected ProgressBar findUserProgressBar;
	boolean isSendingFindUser = false;

	protected EditText findUserNameEditText;

	protected ImageView forumGroupSegmentImageView;
	protected TextView forumGroupSegmentLeftTextView;
	protected TextView forumGroupSegmentRightTextView;
	protected OverScrollListView forumGroupMemberListView;
	protected FollowAdapter forumGroupMemberAdapter;
	protected ProgressBar forumGroupMemberProgressBar;

	protected TextView noFollowTextView;


	protected RelativeLayout topBarView;


	protected ImageView favoriteVideoImageView;

	protected int tabNo = 0;


	protected ImageView baseBackgroundImageView;

	Typeface typefaceRobotoLight;

	protected RelativeLayout floatingMenuView ;

	protected RelativeLayout progressBaseView ;



	/*
	private Tracker mGaTracker = null ;
	private GoogleAnalytics mGaInstance;
	*/

	private IntentFilter mIntentFilter;

	protected boolean isPreventSignoutButton = false;

	protected boolean preventUpdateOnResume = false ;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);


		//this.showHeapSize("") ;

		/*
		mKiipFragment = new KiipFragment();
		getFragmentManager().beginTransaction().add(mKiipFragment, KIIP_TAG).commit();
		*/

		helper = DatabaseHelper.getInstance(this);
		mDb = helper.getReadableDatabase();

		handler = new Handler();

		mReceiver = new OperationCompletionReceiver();
		mIntentFilter = new IntentFilter();
		mIntentFilter.addAction("co.veam.veam31000287.OPERATION_COMPLETED");
		mIntentFilter.addAction(String.format("co.veam.veam31000287.%s", VeamUtil.NOTICE_NEW_NOTIFICATION_CHANGED));
		mIntentFilter.addAction(String.format("co.veam.veam31000287.%s", VeamUtil.NOTICE_NEW_MESSAGE));
		mIntentFilter.addAction(String.format("co.veam.veam31000287.%s", VeamUtil.NOTICE_NEW_PROFILE_NOTIFICATION));

		registerReceiver(mReceiver, mIntentFilter);

		DisplayMetrics metrics = new DisplayMetrics();
		this.getWindowManager().getDefaultDisplay().getMetrics(metrics);

	    /*
	    //VeamUtil.log("test", "density=" + metrics.density);
	    //VeamUtil.log("test", "densityDpi=" + metrics.densityDpi);
	    //VeamUtil.log("test", "scaledDensity=" + metrics.scaledDensity);
	    //VeamUtil.log("test", "widthPixels=" + metrics.widthPixels);
	    //VeamUtil.log("test", "heightPixels=" + metrics.heightPixels);
	    //VeamUtil.log("test", "xDpi=" + metrics.xdpi);
	    //VeamUtil.log("test", "yDpi=" + metrics.ydpi);
	    */

		scaledDensity = metrics.scaledDensity;
		deviceWidth = metrics.widthPixels;
		deviceHeight = metrics.heightPixels;
		circleSize = deviceWidth * 22 / 50;
		circleLeft = deviceWidth / 2 - circleSize / 2;
		circleTop = deviceHeight / 2 - circleSize / 2;
		circleBoundaryLeft = deviceWidth / 10;
		circleBoundaryRight = deviceWidth * 9 / 10 - circleSize;
		circleBoundaryTop = (deviceHeight / 2) - (deviceWidth * 4 / 10);
		circleBoundaryBottom = (deviceHeight / 2) + (deviceWidth * 4 / 10) - circleSize;
		isCircleMoving = false;

		Intent intent = getIntent();
		currentTitleNo = intent.getIntExtra("TITLE_NO", 1);

		// Get the GoogleAnalytics singleton. Note that the SDK uses
		// the application context to avoid leaking the current context.
		/*
		mGaInstance = GoogleAnalytics.getInstance(this);
		
		if(mGaInstance != null){
			mGaTracker = mGaInstance.getDefaultTracker() ;
			if(mGaTracker == null){
				// Use the GoogleAnalytics singleton to get a Tracker.
				mGaTracker = mGaInstance.getTracker("__GA_PROPERTY_ID__");
			}
		}
		*/

		topBarHeight = deviceWidth * 14 / 100;

	}

	public void showHeapSize(String message) {
		/*
	//VeamUtil.log("debug","class:"+this.getClass().getName() + " "+message) ;
	//VeamUtil.log("debug","Debug.getNativeHeapSize():"+Debug.getNativeHeapSize());
	//VeamUtil.log("debug","Debug.getNativeHeapAllocatedSize():"+Debug.getNativeHeapAllocatedSize());
	//VeamUtil.log("debug","Debug.getNativeHeapFreeSize():"+Debug.getNativeHeapFreeSize());
	//VeamUtil.log("debug","Runtime.getRuntime().totalMemory():"+Runtime.getRuntime().totalMemory());
	//VeamUtil.log("debug","Runtime.getRuntime().maxMemory():"+Runtime.getRuntime().maxMemory());
	//VeamUtil.log("debug","Runtime.getRuntime().freeMemory():"+Runtime.getRuntime().freeMemory());
	//VeamUtil.log("debug","usage:"+(Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()));
		*/
	}


	protected void trackPageView() {
		String name = String.format("/31000287/tab%d/%s", tabNo, pageName);
		this.doTrack(name);
	}

	protected void trackPageView(String target) {
		String name = String.format("/31000287/tab%d/%s", tabNo, target);
		this.doTrack(name);
	}

	protected void doTrack(String name) {
		//VeamUtil.log("debug","track : "+name) ;

		// Get tracker.
		Tracker tracker = ((AnalyticsApplication) getApplication()).getTracker();

		if (tracker != null) {
			String advertisingId = AdvertisingIdHelper.getInstance(this).getAdvertisingId();
			// Set screen name.
			// Where path is a String representing the screen name.
			tracker.setScreenName(name);
			// Send the custom dimension value with a screen view.
			// Note that the value only needs to be sent once.
			tracker.send(new HitBuilders.ScreenViewBuilder()
							.setCustomDimension(1, advertisingId)
							.build()
			);


		}

		/*
		if(mGaTracker != null){
			String advertisingId = AdvertisingIdHelper.getInstance(this).getAdvertisingId() ;
			if(!VeamUtil.isEmpty(advertisingId)){
				mGaTracker.setCustomDimension(1, advertisingId) ;
				//VeamUtil.log("debug","set ad id : "+advertisingId) ;
			}
			mGaTracker.sendView(name);
		}
		*/
	}
	
	
	
	/*
	Animation#setInterpolator(Interpolator)
	AccelerateDecelerateInterpolator 	加速と減速
	AccelerateInterpolator 	加速
	AnticipateInterpolator 	開始時に逆方向に溜める
	AnticipateOvershootInterpolator 	開始時に逆方向に溜め、終了時にはみ出す
	BounceInterpolator 	終了時にバウンド
	CycleInterpolator 	設定したアニメーションの負の方向も使用しながら繰り返す
	DecelerateInterpolator 	減速
	LinearInterpolator 	変化を加えない
	OvershootInterpolator 	終了時にはみ出す
	*/

	protected void doExpandAndFadeAnimation(View view, long duration, float fromX, float toX, float fromY, float toY, float pivotX, float pivotY, float fromAlpha, float toAlpha, String nextAction, Interpolator interpolator) {
		AnimationSet animationSet = new AnimationSet(true);
		ScaleAnimation scaleAnimation = new ScaleAnimation(fromX, toX, fromY, toY, pivotX, pivotY);
		animationSet.addAnimation(scaleAnimation);
		AlphaAnimation alphaAnimation = new AlphaAnimation(fromAlpha, toAlpha);
		animationSet.addAnimation(alphaAnimation);

		this.doAnimation(animationSet, view, duration, nextAction);
	}


	protected void doExpandAnimation(View view, long duration, float fromX, float toX, float fromY, float toY, float pivotX, float pivotY, String nextAction, Interpolator interpolator) {
		ScaleAnimation animation = new ScaleAnimation(fromX, toX, fromY, toY, pivotX, pivotY);
		this.doAnimation(animation, view, duration, nextAction);
	}

	protected void doFadeAnimation(View view, long duration, float fromAlpha, float toAlpha, String nextAction, Interpolator interpolator) {
		AlphaAnimation animation = new AlphaAnimation(fromAlpha, toAlpha);
		this.doAnimation(animation, view, duration, nextAction);
	}


	protected void doFadeInAnimation(View view, long duration, String nextAction, Interpolator interpolator) {
		AlphaAnimation animation = new AlphaAnimation(0.0f, 1.0f);
		this.doAnimation(animation, view, duration, nextAction);
	}

	protected void doFadeOutAnimation(View view, long duration, String nextAction, Interpolator interpolator) {
		AlphaAnimation animation = new AlphaAnimation(1.0f, 0.0f);
		this.doAnimation(animation, view, duration, nextAction);
	}

	protected void doTranslateAnimation(View view, long duration, float fromX, float toX, float fromY, float toY, String nextAction, Interpolator interpolator) {
		TranslateAnimation animation = new TranslateAnimation(fromX, toX, fromY, toY);
		if (interpolator != null) {
			animation.setInterpolator(interpolator);
		}
		this.doAnimation(animation, view, duration, nextAction);
	}

	protected void doTranslateAndFadeAnimation(View view, long duration, float fromX, float toX, float fromY, float toY, float fromAlpha, float toAlpha, String nextAction, Interpolator interpolator) {
		AnimationSet animationSet = new AnimationSet(true);
		TranslateAnimation translateAnimation = new TranslateAnimation(fromX, toX, fromY, toY);
		animationSet.addAnimation(translateAnimation);
		AlphaAnimation alphaAnimation = new AlphaAnimation(fromAlpha, toAlpha);
		animationSet.addAnimation(alphaAnimation);

		this.doAnimation(animationSet, view, duration, nextAction);
	}


	protected void doAnimation(Animation animation, View view, long duration, String nextAction) {
		final VeamActivity veamActivity = this;
		final Method method;
		if (nextAction == null) {
			method = null;
		} else {
			try {
				method = this.getClass().getMethod(nextAction, (Class<?>[]) null);
			} catch (SecurityException e) {
				throw new RuntimeException(e);
			} catch (NoSuchMethodException e) {
				throw new RuntimeException(e);
			}
		}

		animation.setDuration(duration);
		animation.setFillAfter(true);
		animation.setFillEnabled(true);
		animation.setAnimationListener(new Animation.AnimationListener() {
			@Override
			public void onAnimationEnd(Animation animation) {
				//initialActivity.nextAction() ;
				if (method != null) {
					try {
						method.invoke(veamActivity, (Object[]) null);
					} catch (IllegalArgumentException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						e.printStackTrace();
					}
				}
			}

			@Override
			public void onAnimationRepeat(Animation animation) {
			}

			@Override
			public void onAnimationStart(Animation animation) {
			}

		});
		view.startAnimation(animation);
	}


	protected void setCircleInitialState() {
		isCircleMoving = false;
		this.titleCircleImageView.clearAnimation();
		this.titleCircleImageView.layout(deviceWidth / 2 - circleSize / 2, deviceHeight / 2 - circleSize / 2, deviceWidth / 2 + circleSize / 2, deviceHeight / 2 + circleSize / 2);
		this.animationCircleImageView.clearAnimation();
	}

	private boolean isSignOutButtonAdded = false;
	private ImageView signOutImageView;

	@Override
	public void onStart() {
		super.onStart();
		// Send a screen view when the Activity is displayed to the user.
		this.trackPageView();

		/*
		if (VeamUtil.isPreviewMode()) {
			if (!isPreventSignoutButton) {
				if (!isSignOutButtonAdded) {
					isSignOutButtonAdded = true;
					FrameLayout rootLayout = (FrameLayout) findViewById(android.R.id.content);
					if (rootLayout != null) {
						int iconSize = deviceWidth * 10 / 100;
						signOutImageView = new ImageView(this);
						signOutImageView.setId(VIEWID_SIGN_OUT_BUTTON);
						signOutImageView.setImageResource(R.drawable.c_top_veam);
						signOutImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
						signOutImageView.setVisibility(View.VISIBLE);
						signOutImageView.setOnClickListener(this);
						FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(iconSize, iconSize);
						layoutParams.setMargins(deviceWidth * 90 / 100, (deviceHeight - iconSize) / 2, 0, 0);
						rootLayout.addView(signOutImageView, layoutParams);
					}
				}
			}
		}
		*/

		/*
		Kiip.getInstance().startSession(new Kiip.Callback() {
			@Override
			public void onFailed(Kiip kiip, Exception exception) {
				// handle failure
			}

			@Override
			public void onFinished(Kiip kiip, Poptart poptart) {
				onPoptart(poptart);
			}
		});
		*/
	}

	@Override
	public void onStop() {
		super.onStop();
		//EasyTracker.getInstance().activityStop(this) ;

		/*
		Kiip.getInstance().endSession(new Kiip.Callback() {
			@Override
			public void onFailed(Kiip kiip, Exception exception) {
				// handle failure
			}

			@Override
			public void onFinished(Kiip kiip, Poptart poptart) {
				onPoptart(poptart);
			}
		}) ;
		*/

	}

	/*
	public void onPoptart(Poptart poptart) {
		VeamUtil.log("debug","VeamActivity::onPoptart") ;
		//mKiipFragment.showPoptart(poptart);
	}
	*/


	protected RelativeLayout.LayoutParams createParam(int w, int h) {
		return new RelativeLayout.LayoutParams(w, h);
	}

	protected void addBaseBackground(RelativeLayout rootLayout) {
		try {
			/*
			BitmapFactory.Options options = new BitmapFactory.Options() ;
			options.inJustDecodeBounds = false ;
			options.inSampleSize = 1 ;
			options.inInputShareable = true ;
			options.inPurgeable = true ;
			//options.inPreferredConfig = Bitmap.Config.RGB_565 ;
			options.inPreferredConfig = Bitmap.Config.ARGB_8888 ;
			//options.inPreferredConfig = Bitmap.Config.ARGB_4444 ;
			Bitmap bitmap = BitmapFactory.decodeResource(this.getResources(), R.drawable.background, options) ;
			*/

			baseBackgroundImageView = new ImageView(this);
			//baseBackgroundImageView.setImageResource(R.drawable.background);
			baseBackgroundImageView.setImageBitmap(VeamUtil.getThemeImage(this, "background", 4));

			//baseBackgroundImageView.setImageBitmap(bitmap) ;
			baseBackgroundImageView.setScaleType(ScaleType.CENTER_CROP);
			baseBackgroundImageView.setVisibility(View.VISIBLE);
			rootLayout.addView(baseBackgroundImageView, createParam(deviceWidth, deviceHeight));
		} catch (OutOfMemoryError e) {
			//VeamUtil.log("debug","OutOfMemory") ;
		}
	}

	public void addTab(RelativeLayout rootLayout, int templateId, boolean considerStatusBar) {

		int selectedIndex = VeamUtil.getTemplateIndex(this, templateId);
		tabNo = selectedIndex + 1;

		viewHeight = deviceHeight;
		if (considerStatusBar) {
			viewHeight -= this.getStatusBarHeight();
		}

		String[] templateIds = VeamUtil.getTemplateIds(this);

		//String[] titles = {"Calendar","Videos","Forum","Recipes","Shop"} ;
		String[] titles = {this.getString(R.string.exclusive), this.getString(R.string.youtube), this.getString(R.string.forum), this.getString(R.string.links)};
		tabHeight = deviceWidth * 98 / 640;
		if (templateIds != null) {
			numberOfTabs = templateIds.length;
		} else {
			numberOfTabs = 0;
		}
		VeamUtil.log("debug", "numberOfTabs=" + numberOfTabs);
		int tabWidth = deviceWidth / numberOfTabs;
		int imageHeight = tabHeight * 60 / 100;
		int imageWidth = tabHeight;
		this.tabBackImageView = new ImageView(this);
		this.tabBackImageView.setImageResource(R.drawable.tab_back);
		this.tabBackImageView.setScaleType(ScaleType.FIT_XY);
		this.tabBackImageView.setVisibility(View.VISIBLE);
		RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, tabHeight);
		layoutParams.setMargins(0, viewHeight - tabHeight, 0, 0);
		rootLayout.addView(this.tabBackImageView, layoutParams);

		int margin = (tabWidth - imageWidth) / 2;
		int imageY = viewHeight - (tabHeight * 90 / 100);
		int titleY = viewHeight - (tabHeight * 35 / 100);
		int buttonY = viewHeight - tabHeight;
		this.tabImageViews = new ImageView[numberOfTabs];
		this.tabTitleViews = new TextView[numberOfTabs];
		this.tabButtonViews = new View[numberOfTabs];
		for (int index = 0; index < numberOfTabs; index++) {
			int workTemplateId = VeamUtil.parseInt(templateIds[index]);
			VeamUtil.log("debug", "workTemplateId=" + workTemplateId);
			this.tabImageViews[index] = new ImageView(this);
			if (selectedIndex == index) {
				this.tabImageViews[index].setImageResource(VeamUtil.getDrawableId(this, String.format("tab_icon_t%d_on", workTemplateId)));
				this.tabSelectedImageView = new ImageView(this);
				//this.tabSelectedImageView.setImageResource(R.drawable.tab_selected_back) ;
				this.tabSelectedImageView.setImageBitmap(VeamUtil.getThemeImage(this, "tab_selected_back", 1));
				this.tabSelectedImageView.setScaleType(ScaleType.FIT_XY);
				this.tabSelectedImageView.setVisibility(View.VISIBLE);
				layoutParams = createParam(tabWidth, tabHeight);
				layoutParams.setMargins(index * tabWidth, viewHeight - tabHeight, 0, 0);
				rootLayout.addView(this.tabSelectedImageView, layoutParams);
			} else {
				this.tabImageViews[index].setImageResource(VeamUtil.getDrawableId(this, String.format("tab_icon_t%d_off", workTemplateId)));
			}
			this.tabImageViews[index].setScaleType(ScaleType.FIT_CENTER);
			this.tabImageViews[index].setVisibility(View.VISIBLE);
			layoutParams = createParam(imageWidth, imageHeight);
			layoutParams.setMargins(tabWidth * index + margin, imageY, 0, 0);
			rootLayout.addView(this.tabImageViews[index], layoutParams);


			this.tabTitleViews[index] = new TextView(this);
			this.tabTitleViews[index].setText(VeamUtil.getTemplateTitle(this, workTemplateId));
			this.tabTitleViews[index].setGravity(Gravity.CENTER);
			this.tabTitleViews[index].setVisibility(View.VISIBLE);
			this.tabTitleViews[index].setTextSize((float) deviceWidth * 3.0f / 100 / scaledDensity);
			this.tabTitleViews[index].setTypeface(getTypefaceRobotoLight());
			layoutParams = createParam(tabWidth, tabHeight * 30 / 100);
			layoutParams.setMargins(tabWidth * index, titleY, 0, 0);
			rootLayout.addView(this.tabTitleViews[index], layoutParams);

			this.tabButtonViews[index] = new View(this);
			this.tabButtonViews[index].setBackgroundColor(Color.TRANSPARENT);
			this.tabButtonViews[index].setVisibility(View.VISIBLE);
			this.tabButtonViews[index].setId(this.VIEWID_TAB_BUTTON);
			this.tabButtonViews[index].setTag(Integer.valueOf(workTemplateId));
			this.tabButtonViews[index].setOnClickListener(this);
			//this.tabButtonViews[index].setOnTouchListener(this);
			layoutParams = createParam(tabWidth, tabHeight);
			layoutParams.setMargins(tabWidth * index, buttonY, 0, 0);
			rootLayout.addView(this.tabButtonViews[index], layoutParams);
		}
	}

	public int getStatusBarHeight() {
		int result = 0;
		int resourceId = getResources().getIdentifier("status_bar_height", "dimen", "android");
		if (resourceId > 0) {
			result = getResources().getDimensionPixelSize(resourceId);
		}
		return result;
	}

	protected RelativeLayout addMainView(RelativeLayout rootLayout, int visibility) {
		return this.addView(rootLayout, visibility, true);
	}

	protected RelativeLayout addFullView(RelativeLayout rootLayout, int visibility) {
		return this.addView(rootLayout, visibility, false);
	}

	protected RelativeLayout addView(RelativeLayout rootLayout, int visibility, boolean considerTab) {
		RelativeLayout contentView = new RelativeLayout(this);
		if (considerTab) {
			viewHeight = deviceHeight - this.getStatusBarHeight() - tabHeight;
		} else {
			viewHeight = deviceHeight - this.getStatusBarHeight();
		}
		contentView.setBackgroundColor(Color.TRANSPARENT);
		contentView.setVisibility(visibility);
		rootLayout.addView(contentView, createParam(deviceWidth, viewHeight));
		if(floatingMenuView != null){
			floatingMenuView.bringToFront();
		}
		return contentView;
	}

	protected void setTopBarTitleRight(RelativeLayout targetView,int right){
		VeamUtil.log("Debug","setTopBarTitleRight "+right);
		TextView topBarTitleTextView = (TextView)targetView.findViewById(VIEWID_TOP_BAR_TITLE) ;
		if(topBarTitleTextView != null){
			int margin = deviceWidth - right ;
			int titleWidth = deviceWidth - margin * 2 ;
			RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams)topBarTitleTextView.getLayoutParams() ;
			VeamUtil.log("Debug","titleWidth "+titleWidth);
			topBarTitleTextView.setWidth(titleWidth);
			//topBarTitleTextView.setLayoutParams(para);
		}
	}


	protected void addTopBar(RelativeLayout targetView, String title, boolean showBackButton, boolean showSettingsButton) {
		int titleWidth = deviceWidth * 55 / 100;
		this.addTopBar(targetView,title,showBackButton,showSettingsButton,titleWidth) ;
	}

	protected void addTopBar(RelativeLayout targetView, String title, boolean showBackButton, boolean showSettingsButton,int titleWidth) {

		//VeamUtil.log("debug","addTopBar title:"+title) ;
		topBarView = new RelativeLayout(this);
		topBarView.setId(VIEWID_TOP_BAR);
		topBarView.setBackgroundColor(VeamUtil.getTopBarColor(this));
		topBarView.setVisibility(View.VISIBLE);
		targetView.addView(topBarView, createParam(deviceWidth, topBarHeight));

		Typeface typefaceRobotoItalic = Typeface.createFromAsset(this.getAssets(), "Roboto-Italic.ttf");

		//int titleWidth = deviceWidth * 55 / 100;
		TextView titleTextView = new TextView(this);
		titleTextView.setId(VIEWID_TOP_BAR_TITLE);
		titleTextView.setText(title);
		titleTextView.setTextColor(Color.WHITE);
		titleTextView.setGravity(Gravity.CENTER);
		titleTextView.setVisibility(View.VISIBLE);
		titleTextView.setTextSize((float) deviceWidth * 5.0f / 100 / scaledDensity);
		titleTextView.setSingleLine();
		titleTextView.setEllipsize(TruncateAt.END);
		titleTextView.setTypeface(typefaceRobotoItalic);
		RelativeLayout.LayoutParams layoutParams = createParam(titleWidth, topBarHeight);
		layoutParams.setMargins((deviceWidth - titleWidth) / 2, 0, 0, 0);
		targetView.addView(titleTextView, layoutParams);

		if (showBackButton) {
			ImageView imageView = new ImageView(this);
			imageView.setImageResource(R.drawable.top_bar_back);
			imageView.setId(this.VIEWID_TOP_BAR_BACK_BUTTON);
			imageView.setOnClickListener(this);
			imageView.setScaleType(ScaleType.FIT_XY);
			layoutParams = createParam(topBarHeight, topBarHeight);
			targetView.addView(imageView, layoutParams);
		}

		int rightMargin = 0 ;
		if(VeamUtil.isPreviewMode()) {
			if (!isPreventSignoutButton) {
				int iconSize = deviceWidth * 10 / 100;
				signOutImageView = new ImageView(this);
				signOutImageView.setId(VIEWID_SIGN_OUT_BUTTON);
				signOutImageView.setImageResource(R.drawable.c_top_veam);
				signOutImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
				signOutImageView.setVisibility(View.VISIBLE);
				signOutImageView.setOnClickListener(this);
				layoutParams = createParam(iconSize, iconSize);
				layoutParams.setMargins(deviceWidth * 90 / 100, (topBarHeight - iconSize) / 2, 0, 0);
				targetView.addView(signOutImageView, layoutParams);
				rightMargin += iconSize;
			}
		}


		if (showSettingsButton) {
			int settingsButtonHeight = topBarHeight * 90 / 100;
			int settingsButtonWidth = settingsButtonHeight * 60 / 80;
			ImageView imageView = new ImageView(this);
			//imageView.setImageResource(R.drawable.settings_button) ;
			if (VeamUtil.hasNewNotification(this)) {
				imageView.setImageResource(R.drawable.top_profile_n);
			} else {
				imageView.setImageResource(R.drawable.top_profile);
			}
			imageView.setId(VIEWID_TOP_BAR_SETTINGS_BUTTON);
			imageView.setOnClickListener(this);
			imageView.setScaleType(ScaleType.FIT_XY);
			layoutParams = createParam(settingsButtonWidth, settingsButtonHeight);
			layoutParams.setMargins(deviceWidth * 98 / 100 - rightMargin - settingsButtonWidth, (topBarHeight - settingsButtonHeight) / 2, 0, 0);
			targetView.addView(imageView, layoutParams);
		}
	}

	public void launchExclusiveActivity() {
		String subscriptionKind = VeamUtil.getPreferenceString(this, VeamUtil.PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_KIND);
		if (subscriptionKind.equals("5")) {
			// Sell Video
			//VeamUtil.log("debug","sell video") ;
			Intent videoCategoryIntent = new Intent(this, SellItemCategoryActivity.class);
			startActivityForResult(videoCategoryIntent, 0);
			overridePendingTransition(R.anim.fadein, R.anim.fadeout);
		} else if (subscriptionKind.equals("6")) {
			// Sell Section
			//VeamUtil.log("debug","sell section") ;
			Intent sellSectionCategoryIntent = new Intent(this, SellSectionCategoryActivity.class);
			startActivityForResult(sellSectionCategoryIntent, 0);
			overridePendingTransition(R.anim.fadein, R.anim.fadeout);
		} else {
			Intent exclusiveGridIntent = new Intent(this, ExclusiveGridActivity.class);
			startActivityForResult(exclusiveGridIntent, 0);
			overridePendingTransition(R.anim.fadein, R.anim.fadeout);
		}
	}


	@Override
	public void onClick(View view) {
		VeamUtil.log("debug", "VeamActivity::onClick");
		if (view.getId() == this.VIEWID_TAB_BUTTON) {
			Integer templateId = (Integer) view.getTag();
			//VeamUtil.log("debug","tap tab : " + index) ;
			switch (templateId) {
				case 8:
					// Exclusive
					this.launchExclusiveActivity();
					break;
				case 1: {
					// Videos
					Intent videosIntent = new Intent(this, VideosActivity.class);
					startActivityForResult(videosIntent, 0);
					overridePendingTransition(R.anim.fadein, R.anim.fadeout);
				}
				break;
				case 2: {
					// Forum
					Intent forumIntent = new Intent(this, ForumActivity.class);
					startActivityForResult(forumIntent, 0);
					overridePendingTransition(R.anim.fadein, R.anim.fadeout);
				}
				break;
				case 3: {
					// Links
					Intent linksIntent = new Intent(this, WebActivity.class);
					linksIntent.putExtra("TEMPLATE_ID", 3);
					startActivityForResult(linksIntent, 0);
					overridePendingTransition(R.anim.fadein, R.anim.fadeout);
				}
				break;
				case 9: {
					// Links Category 1
					Intent linksIntent = new Intent(this, WebActivity.class);
					linksIntent.putExtra("TEMPLATE_ID", 9);
					startActivityForResult(linksIntent, 0);
					overridePendingTransition(R.anim.fadein, R.anim.fadeout);
				}
				break;
			}
		} else if (view.getId() == this.VIEWID_TOP_BAR_SETTINGS_BUTTON) {
			VeamUtil.setHasNewNotification(this, false);
			this.onSettingsButtonClick();
		} else if (view.getId() == VIEWID_BROWSER_BACKWARD_BUTTON) {
			//VeamUtil.log("debug","back button tapped") ;
			if (webPageView.canGoBack()) {
				webPageView.goBack();
			}
		} else if (view.getId() == VIEWID_BROWSER_FORWARD_BUTTON) {
			//VeamUtil.log("debug","forward button tapped") ;
			if (webPageView.canGoForward()) {
				webPageView.goForward();
			}
		} else if (view.getId() == VIEWID_ADD_FAVORITE_VIDEO) {
			if (this.currentYoutubeObject != null) {
				if (VeamUtil.isFavoriteVideo(this, currentYoutubeObject.getId())) {
					VeamUtil.deleteFavoriteVideo(this, currentYoutubeObject.getId());
					this.favoriteVideoImageView.setImageBitmap(VeamUtil.getThemeImage(this, "add_off", 1));
				} else {
					VeamUtil.addFavoriteVideo(this, currentYoutubeObject.getId());
					this.favoriteVideoImageView.setImageBitmap(VeamUtil.getThemeImage(this, "add_on", 1));
				}
			}
		} else if (view.getId() == VIEWID_SIGN_OUT_BUTTON) {
			//final String[] items = {"Sign out", "Back to Home", "cancel"};

			VeamUtil.log("debug", "AppStatus:" + ConsoleUtil.getAppStatus());
			this.createVeamItMenuView();

			/*
			final String[] items = {"Sign out", "Back to Home","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test","Test", "cancel"};
			new AlertDialog.Builder(this)
					.setTitle("")
					.setItems(items, new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							// item_which pressed
							//VeamUtil.log("debug", "click : " + which);
							if (which == 0) {
								VeamUtil.setPreferenceString(VeamActivity.this, VeamUtil.USERDEFAULT_KEY_PREVIEW_APP_ID,"");
								Intent intent = new Intent(VeamActivity.this, PreviewLoginActivity.class);
								intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK) ;
								startActivity(intent);
							} else if (which == 1) {
								Intent intent = new Intent(VeamActivity.this, PreviewHomeActivity.class);
								intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK) ;
								startActivity(intent);
							}
						}
					})
					.show();
					*/
		} else if (view.getId() == VIEWID_SIDE_MENU_GOTO_PREVIEW) {
			VeamUtil.log("debug", "SideMenu goto preview tapped");
			if(getCurrentFloatingMenuPosition() == 0) {
				this.removeVeamItMenuView();
			} else {
				this.finishHorizontal();
			}
		} else if (view.getId() == VIEWID_SIDE_MENU_ESCAPE) {
			VeamUtil.log("debug", "SideMenu escape tapped");
			this.removeVeamItMenuView() ;
		} else if (view.getId() == VIEWID_SIDE_MENU_GOTO_HOME) {
			this.removeVeamItMenuView() ;
			Intent previewHomeIntent = new Intent(this, PreviewHomeActivity.class);
			startActivity(previewHomeIntent);
		} else if (view.getId() == VIEWID_SIDE_MENU_PAYMENT_TYPE) {
			//this.removeVeamItMenuView() ;
			Intent intent = new Intent(this, ConsoleChangePaymentTypeActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.customize_feature_caption)) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else if(view.getId() == VIEWID_SIDE_MENU_CUSTOMIZE){
			//this.removeVeamItMenuView() ;
			Intent intent = new Intent(this, ConsoleCustomizeDesignActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,true) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.customize_design_caption)) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else if(view.getId() == VIEWID_SIDE_MENU_APP_STORE){

			Intent intent = new Intent(this, ConsoleAppStoreActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else if(view.getId() == VIEWID_SIDE_MENU_TERMS) {
			Intent intent = new Intent(this, ConsoleTermsActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.accept_the_terms));
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 0);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 0);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else if(view.getId() == VIEWID_SIDE_MENU_SUBMIT) {
			if (VeamUtil.isPreviewMode()) {
				final ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
				if(consoleContents != null){
					ArrayList<String> requiredOperations = consoleContents.getRequiredOperationsToSubmit() ;
					int count = requiredOperations.size() ;
					if (count > 0) {
						String message =  "";
						for (int index = 0; index < count; index++) {
							String operationString =requiredOperations.get(index) ;
							//NSLog(@"%@",operationString) ;
							message += operationString + "\n" ;
						}
						new AlertDialog.Builder(this)
								.setTitle(getString(R.string.required_operations))
								.setMessage(message)
								.setPositiveButton("OK", null)
								.show();
					} else {
						// submit
						VeamUtil.log("debug", "Submit") ;
						new AlertDialog.Builder(this)
								.setTitle(this.getString(R.string.submit_confirmation_title))
								.setMessage(this.getString(R.string.submit_confirmation))
										.setPositiveButton(this.getString(R.string.submit_ok), new DialogInterface.OnClickListener() {
											@Override
											public void onClick(DialogInterface dialog, int which) {
												// OK button pressed
												showFullscreenProgress();
												consoleContents.submitToMcn();
												handler.postDelayed(new Runnable() {
													public void run() {
														backToPreviewHomeScreen();
													}
												}, 3000);
											}
										})
										.setNegativeButton(this.getString(R.string.submit_cancel), null)
												.show();
					}

				}
			}
		} else  if(view.getId() == VIEWID_SIDE_MENU_PUBLISH) {
			if (VeamUtil.isPreviewMode()) {
				ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
				if(consoleContents != null){
					this.showFullscreenProgress();
					consoleContents.deployContents();
					handler.postDelayed(new Runnable() {
						public void run() {
							backToPreviewHomeScreen();
						}
					}, 3000);

				}
			}
		} else if(view.getId() == VIEWID_SIDE_MENU_HELP) {
			Intent intent = new Intent(this, ConsoleMessageActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, this.getString(R.string.notification_title));
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 0);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 0);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else if(view.getId() == VIEWID_SIDE_MENU_FAQ) {
			Intent intent = new Intent(this, ConsoleFaqActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, this.getString(R.string.inquiry_title));
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 0);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 0);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else  if(view.getId() == VIEWID_SIDE_MENU_SIGN_OUT) {
			VeamUtil.setPreferenceString(VeamActivity.this, VeamUtil.USERDEFAULT_KEY_PREVIEW_APP_ID,"");
			Intent intent = new Intent(VeamActivity.this, PreviewLoginActivity.class);
			intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK) ;
			startActivity(intent);
		} else  if(view.getId() == VIEWID_FLOATING_TEXT1) {
			VeamUtil.log("debug","VIEWID_FLOATING_TEXT1 " + getCurrentFloatingMenuPosition()) ;
			if(this.getCurrentFloatingMenuPosition() == 1){
				this.finishHorizontal();
			}
		} else  if(view.getId() == VIEWID_FLOATING_TEXT2) {
			this.startEditModeActivity();
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else  if(view.getId() == VIEWID_FLOATING_TEXT3) {
			VeamUtil.log("debug","VIEWID_FLOATING_TEXT3 " + getCurrentFloatingMenuPosition()) ;
			this.startTutorialActivity();
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		} else  if(view.getId() == VIEWID_INITIAL_TUTORIAL_NEXT) {
			int tutorialIndex = this.getVeamItTutorialIndex() ;
			if(tutorialIndex == 0){
				this.setVeamItTutorialIndex(1);
				this.hideVeamItTutorial();
				this.startEditModeActivity() ;
			} else if(tutorialIndex == 1){
				this.setVeamItTutorialIndex(2);
				this.createVeamItMenuView();
				this.hideVeamItTutorial();
				this.showVeamItTutorial(2);
			} else if(tutorialIndex == 2){
				this.hideVeamItTutorial();
				this.finish() ;
			}
		}
	}

	public void onSettingsButtonClick() {
		//VeamUtil.log("debug","tap settings") ;
		// Settings
		/*
		Intent settingsIntent = new Intent(this,SettingsActivity.class) ;
		startActivityForResult(settingsIntent,0) ;
		overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
		*/
		//VeamUtil.log("debug","tab no : "+tabNo) ;
		Intent profileIntent = new Intent(this, ProfileActivity.class);
		profileIntent.putExtra("TAB_INDEX", tabNo - 1);
		if (VeamUtil.isLogin(this)) {
			profileIntent.putExtra("SOCIAL_USER_ID", VeamUtil.getSocialUserId(this));
			profileIntent.putExtra("SOCIAL_USER_NAME", VeamUtil.getSocialUserName(this));
		} else {
			profileIntent.putExtra("SOCIAL_USER_ID", "0");
			profileIntent.putExtra("SOCIAL_USER_NAME", this.getString(R.string.not_logged_in));
		}
		startActivity(profileIntent);
		overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		//overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
	}

	OperationCompletionReceiver mReceiver;

	/*
	@Override
	public boolean onTouch(View view, MotionEvent event) {
		VeamUtil.log("debug","VeamActivity::onTouch") ;
		boolean consume = false ;
		if(event.getAction() == MotionEvent.ACTION_DOWN) {
			VeamUtil.log("debug","ACTION_DOWN") ;
			if (view.getId() == this.VIEWID_TAB_BUTTON) {
				Integer templateId = (Integer) view.getTag();
				VeamUtil.log("debug","tap tab : " + templateId) ;
				switch (templateId) {
					case 8:
						// Exclusive
						this.launchExclusiveActivity();
						break;
					case 1: {
						// Videos
						Intent videosIntent = new Intent(this, VideosActivity.class);
						startActivityForResult(videosIntent, 0);
						overridePendingTransition(R.anim.fadein, R.anim.fadeout);
					}
					break;
					case 2: {
						// Forum
						Intent forumIntent = new Intent(this, ForumActivity.class);
						startActivityForResult(forumIntent, 0);
						overridePendingTransition(R.anim.fadein, R.anim.fadeout);
					}
					break;
					case 3: {
						// Links
						Intent linksIntent = new Intent(this, WebActivity.class);
						linksIntent.putExtra("TEMPLATE_ID", 3);
						startActivityForResult(linksIntent, 0);
						overridePendingTransition(R.anim.fadein, R.anim.fadeout);
					}
					break;
					case 9: {
						// Links Category 1
						Intent linksIntent = new Intent(this, WebActivity.class);
						linksIntent.putExtra("TEMPLATE_ID", 9);
						startActivityForResult(linksIntent, 0);
						overridePendingTransition(R.anim.fadein, R.anim.fadeout);
					}
					break;
				}
				consume = true ;
			}
		}
		return consume;
	}
	*/

	public void onContentsUpdated(){
		VeamUtil.log("debug","VeamActivity::onContentsUpdated") ;
	}

	private class OperationCompletionReceiver extends BroadcastReceiver {
		@Override
		public void onReceive(Context context, Intent intent) {
			String kind = intent.getStringExtra("KIND");
			//VeamUtil.log("debug","OperationCompletionReceiver::onReceive " + kind) ;

			if (kind.equals(VeamUtil.NOTICE_UPDATE_FINISHED)) {
				VeamUtil.log("debug","OperationCompletionReceiver::onReceive NOTICE_UPDATE_FINISHED") ;
				if(VeamUtil.isPreviewMode()){
					hideUpdateProgress();
				}
				onContentsUpdated();
			} else if (kind.equals(VeamUtil.NOTICE_NEW_NOTIFICATION_CHANGED)) {
				resetProfileButton();
			} else if (kind.equals(VeamUtil.NOTICE_NEW_PROFILE_NOTIFICATION)) {
				operateNewProfileNotification();
			} else if (kind.equals(VeamUtil.NOTICE_NEW_MESSAGE)) {
				operateNewMessage();
			}
		}
	}

	public void operateNewProfileNotification() {
		// should be overwritten by child if needed
	}

	public void operateNewMessage() {
		// should be overwritten by child if needed
	}

	public void resetProfileButton() {
		boolean hasNewNotification = VeamUtil.hasNewNotification(VeamActivity.this);
		resetProfileButtonForView(webView, hasNewNotification);
		resetProfileButtonForView(youtubeDetailView, hasNewNotification);
		resetProfileButtonForView(pictureView, hasNewNotification);
		resetProfileButtonForView(followView, hasNewNotification);
	}

	public void resetProfileButtonForView(View targetView, boolean hasNewNotification) {
		if (targetView != null) {
			ImageView imageView = (ImageView) targetView.findViewById(VIEWID_TOP_BAR_SETTINGS_BUTTON);
			if (imageView != null) {
				if (hasNewNotification) {
					imageView.setImageResource(R.drawable.top_profile_n);
				} else {
					imageView.setImageResource(R.drawable.top_profile);
				}
			}
		}
	}

	@Override
	public void onDestroy() {
		if (mReceiver != null) {
			unregisterReceiver(mReceiver);
			mReceiver = null;
		}
		super.onDestroy();
	}

	public void onLoginFinished(Integer resultCode) {
		//VeamUtil.log("debug","onLoginFinished:"+resultCode) ;
	}

	public void sendLikeDone(Integer resultCode) {
		//VeamUtil.log("debug","ForumActivity::sendLikeDone:"+resultCode) ;
		if (pictureAdapter != null) {
			pictureAdapter.notifyDataSetChanged();
		}
		//VeamUtil.kickKiip(this, "PictureLike");

	}

	public void facebookLogin() {
		// start facebook login
		Session.openActiveSession(this, true, new Session.StatusCallback() {
			@Override
			public void call(Session session, SessionState state, Exception exception) {
				//VeamUtil.log("debug","SessionState:"+state) ;
				if (state == SessionState.CLOSED_LOGIN_FAILED) {
					//VeamUtil.log("debug","CLOSED_LOGIN_FAILED") ;
					VeamUtil.showMessage(VeamActivity.this, VeamActivity.this.getString(R.string.login_failed));
					return;
				}
				if (session.isOpened()) {
					//VeamUtil.log("debug","isOpened") ;
					// get user info
					Request.executeMeRequestAsync(session, new Request.GraphUserCallback() {
						@Override
						public void onCompleted(GraphUser user, Response response) {
							//VeamUtil.log("debug","onCompleted") ;
							if (user != null) {
								//VeamUtil.log("debug","name:" + user.getName() + " id:"+user.getId());
								SocialLoginTask socialLoginTask = new SocialLoginTask(VeamActivity.this, VeamActivity.this, user.getId(), user.getName());
								socialLoginTask.execute();
							}
						}
					});
				} else {
					//VeamUtil.log("debug","not opened") ;
				}
			}
		});
	}

	public void twitterLogin() {
		// login
		Intent twitterAuthlIntent = new Intent(this, TwitterAuthActivity.class);
		startActivityForResult(twitterAuthlIntent, REQUEST_CODE_TWITTER_AUTH);
		this.overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
	}


	public void activateFacebookSession(Session.StatusCallback callback) {
		// start facebook login
		Session.openActiveSession(this, true, callback);
		
		/*
		new Session.StatusCallback() {
			@Override
			public void call(Session session, SessionState state, Exception exception) {
				//VeamUtil.log("debug","SessionState:"+state) ;
				if(state == SessionState.CLOSED_LOGIN_FAILED){
					//VeamUtil.log("debug","CLOSED_LOGIN_FAILED") ;
					VeamUtil.showMessage(VeamActivity.this, Zthis.getString(R.string.login_failed)) ;
					return ;
				}
				if (session.isOpened()) {
					//VeamUtil.log("debug","isOpened") ;
					// get user info
					Request.executeMeRequestAsync(session, new Request.GraphUserCallback() {
						@Override
						public void onCompleted(GraphUser user, Response response) {
							//VeamUtil.log("debug","onCompleted") ;
							if (user != null) {
								//VeamUtil.log("debug","name:" + user.getName() + " id:"+user.getId());
							}
						}
					});
				} else {
					//VeamUtil.log("debug","not opened") ;
				}
			}
		});			
		*/
	}

	public void createWebView(RelativeLayout rootLayout, String url, String title, boolean isImage, boolean showSettingsButton, boolean whiteBackgorund) {
		webView = this.addMainView(rootLayout, View.VISIBLE);

		if (showSettingsButton) {
			this.addTopBar(webView, title, true, true);
		} else {
			this.addTopBar(webView, title, true, false);
		}

		webPageView = new WebView(this);


		if (whiteBackgorund) {
			webPageView.setBackgroundColor(Color.argb(0xFF, 0xFF, 0xFF, 0xFF));
		} else {
			webPageView.setBackgroundColor(Color.argb(0, 0, 0, 0));
		}
		webPageView.getSettings().setJavaScriptEnabled(true);
		webPageView.getSettings().setPluginState(PluginState.ON);
		webPageView.getSettings().setBuiltInZoomControls(true);
		webPageView.getSettings().setSupportZoom(true);
		webPageView.getSettings().setDomStorageEnabled(true);
		webPageView.setVerticalScrollbarOverlay(true);

		webPageView.getSettings().setLoadWithOverviewMode(true);
		webPageView.getSettings().setUseWideViewPort(true);

		webPageView.setWebViewClient(new WebViewClient() {
			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon) {
				//System.out.println("onPageStarted") ;
				browserProgress.setVisibility(View.VISIBLE);
				super.onPageStarted(view, url, favicon);
			}

			@Override
			public void onPageFinished(WebView view, String url) {
				//System.out.println("onPageFinished") ;
				browserProgress.setVisibility(View.GONE);
				if (view.canGoBack()) {
					//VeamUtil.log("debug","can go back") ;
					backwardImageView.setImageResource(R.drawable.br_backward_on);
					backwardImageView.setVisibility(View.VISIBLE);
					forwardImageView.setVisibility(View.VISIBLE);
				} else {
					backwardImageView.setImageResource(R.drawable.br_backward_off);
				}

				if (view.canGoForward()) {
					//VeamUtil.log("debug","can go forward") ;
					forwardImageView.setImageResource(R.drawable.br_forward_on);
					backwardImageView.setVisibility(View.VISIBLE);
					forwardImageView.setVisibility(View.VISIBLE);
				} else {
					forwardImageView.setImageResource(R.drawable.br_forward_off);
				}

				super.onPageFinished(view, url);
			}

			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				//System.out.println("url=" + url) ;
				return super.shouldOverrideUrlLoading(view, url);
			}

			@Override
			public void onLoadResource(WebView webview, String url) {
				//VeamUtil.log("debug","onLoadResource : " + url) ;

				if (url.startsWith("http://m.youtube.com/watch")) {
					Uri uri = Uri.parse(url);
					Intent varintent = new Intent(Intent.ACTION_VIEW);
					varintent.setData(Uri.parse("vnd.youtube:" + uri.getQueryParameter("v")));
					startActivity(varintent);
				}
			}
		});

		if (isImage) {
			String htmlString = String.format("<html><body><img src=\"%s\" width=\"100%%\"></body></html>", url);
			webPageView.loadData(URLEncoder.encode(htmlString).replaceAll("\\+", " "), "text/html", "utf-8");
			//webPageView.loadData(htmlString, "text/html", "UTF-8") ;
		} else {
			webPageView.loadUrl(url);
		}

		RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight - topBarHeight);
		layoutParams.setMargins(0, topBarHeight, 0, 0);
		webView.addView(webPageView, layoutParams);

		browserProgress = new ProgressBar(this);
		browserProgress.setIndeterminate(true);
		int progressSize = deviceWidth * 10 / 100;
		layoutParams = createParam(progressSize, progressSize);
		layoutParams.setMargins(deviceWidth * 45 / 100, topBarHeight + (viewHeight - progressSize) / 2, 0, 0);
		browserProgress.setVisibility(View.GONE);
		webView.addView(browserProgress, layoutParams);

		int buttonWidth = deviceWidth * 15 / 100;
		int buttonHeight = buttonWidth * 102 / 90;

		backwardImageView = new ImageView(this);
		backwardImageView.setId(VIEWID_BROWSER_BACKWARD_BUTTON);
		backwardImageView.setOnClickListener(this);
		backwardImageView.setImageResource(R.drawable.br_backward_off);
		backwardImageView.setScaleType(ScaleType.FIT_XY);
		backwardImageView.setVisibility(View.GONE);
		layoutParams = createParam(buttonWidth, buttonHeight);
		layoutParams.setMargins(deviceWidth / 2 - buttonWidth, viewHeight - buttonHeight - deviceWidth * 3 / 100, 0, 0);
		webView.addView(backwardImageView, layoutParams);

		forwardImageView = new ImageView(this);
		forwardImageView.setId(VIEWID_BROWSER_FORWARD_BUTTON);
		forwardImageView.setOnClickListener(this);
		forwardImageView.setImageResource(R.drawable.br_forward_off);
		forwardImageView.setScaleType(ScaleType.FIT_XY);
		forwardImageView.setVisibility(View.GONE);
		layoutParams = createParam(buttonWidth, buttonHeight);
		layoutParams.setMargins(deviceWidth / 2, viewHeight - buttonHeight - deviceWidth * 3 / 100, 0, 0);
		webView.addView(forwardImageView, layoutParams);
	}

	public void createYoutubeDetailView(RelativeLayout rootLayout, YoutubeObject youtubeObject) {


		currentYoutubeObject = youtubeObject;
		currentYoutubeVideoId = youtubeObject.getYoutubeVideoId();
		if (youtubeDetailView != null) {
			youtubeDetailView.removeAllViews();
			rootLayout.removeView(youtubeDetailView);
			youtubeDetailView = null;
		}

		youtubeDetailView = this.addMainView(rootLayout, View.VISIBLE);

		ScrollView scrollView = new ScrollView(this);
		scrollView.setVerticalScrollBarEnabled(false);
		youtubeDetailView.addView(scrollView);
		LinearLayout contentView = new LinearLayout(this);
		scrollView.addView(contentView);
		contentView.setOrientation(LinearLayout.VERTICAL);
		int padding = 0;
		contentView.setPadding(padding, padding, padding, padding);

		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth, topBarHeight);

		View spacerView = new View(this);
		contentView.addView(spacerView, linearLayoutParams);

		int margin = deviceWidth * 6 / 100;
		LinearLayout youtubeBackView = new LinearLayout(this);
		youtubeBackView.setBackgroundColor(Color.argb(0x50, 0xFF, 0xFF, 0xFF));
		youtubeBackView.setPadding(0, margin, 0, margin);
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth, deviceWidth * 9 / 16 + margin * 2);
		contentView.addView(youtubeBackView, linearLayoutParams);

		YouTubePlayerView youtubePlayerView = new YouTubePlayerView(this);
		youtubePlayerView.initialize(VeamUtil.YOUTUBE_DEVELOPER_KEY, this);
		youtubePlayerView.setPadding(0, 0, 0, 0);
		youtubePlayerView.setBackgroundColor(Color.TRANSPARENT);
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth, deviceWidth * 9 / 16);
		//linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,800) ;
		youtubeBackView.addView(youtubePlayerView, linearLayoutParams);

		int sideMargin = deviceWidth * 3 / 100;
		int topMargin = deviceWidth * 3 / 100;
		int bottomMargin = deviceWidth * 5 / 100;
		LinearLayout bottomBackView = new LinearLayout(this);
		bottomBackView.setBackgroundColor(Color.argb(0x50, 0xFF, 0xFF, 0xFF));
		bottomBackView.setPadding(sideMargin, topMargin, sideMargin, bottomMargin);
		bottomBackView.setOrientation(LinearLayout.VERTICAL);
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth, LinearLayout.LayoutParams.WRAP_CONTENT);
		linearLayoutParams.setMargins(0, margin, 0, 0);
		contentView.addView(bottomBackView, linearLayoutParams);

		LinearLayout bottomHeadView = new LinearLayout(this);
		bottomHeadView.setBackgroundColor(Color.TRANSPARENT);
		bottomHeadView.setPadding(0, 0, 0, 0);
		bottomHeadView.setOrientation(LinearLayout.HORIZONTAL);
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		linearLayoutParams.setMargins(0, 0, 0, 0);
		bottomBackView.addView(bottomHeadView, linearLayoutParams);

		LinearLayout bottomTextView = new LinearLayout(this);
		bottomTextView.setBackgroundColor(Color.TRANSPARENT);
		bottomTextView.setPadding(0, 0, 0, 0);
		bottomTextView.setOrientation(LinearLayout.VERTICAL);
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth * 80 / 100, LinearLayout.LayoutParams.WRAP_CONTENT);
		linearLayoutParams.setMargins(0, 0, 0, 0);
		bottomHeadView.addView(bottomTextView, linearLayoutParams);


		TextView textView = new TextView(this);
		textView.setText(youtubeObject.getTitle());
		textView.setTextSize((float) deviceWidth * 5.9f / 100 / scaledDensity);
		textView.setPadding(0, 0, 0, 0);
		textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000"));
		textView.setTypeface(getTypefaceRobotoLight());
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		bottomTextView.addView(textView, linearLayoutParams);


		int durationInSec = Integer.parseInt(youtubeObject.getDuration());
		String durationString = String.format("%02d:%02d", durationInSec / 60, durationInSec % 60);
		textView = new TextView(this);
		textView.setText(durationString);
		textView.setTextSize((float) deviceWidth * 3.0f / 100 / scaledDensity);
		textView.setPadding(0, deviceWidth * 2 / 100, 0, 0);
		textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000"));
		textView.setTypeface(getTypefaceRobotoLight());
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		bottomTextView.addView(textView, linearLayoutParams);

		String videoId = youtubeObject.getId();
		favoriteVideoImageView = new ImageView(this);
		favoriteVideoImageView.setId(VIEWID_ADD_FAVORITE_VIDEO);
		favoriteVideoImageView.setOnClickListener(this);
		if (VeamUtil.isFavoriteVideo(this, videoId)) {
			//favoriteVideoImageView.setImageResource(R.drawable.add_on);
			favoriteVideoImageView.setImageBitmap(VeamUtil.getThemeImage(this, "add_on", 1));
		} else {
			favoriteVideoImageView.setImageBitmap(VeamUtil.getThemeImage(this, "add_off", 1));
		}
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth * 12 / 100, deviceWidth * 12 / 100);
		linearLayoutParams.setMargins(deviceWidth * 1 / 100, 0, 0, 0);
		bottomHeadView.addView(favoriteVideoImageView, linearLayoutParams);

		View lineView = new View(this);
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00));
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth * 90 / 100, 1);
		linearLayoutParams.setMargins(0, deviceWidth * 3 / 100, 0, deviceWidth * 3 / 100);
		bottomBackView.addView(lineView, linearLayoutParams);

		textView = new TextView(this);


		//Spanned html = Html.fromHtml(VeamUtil.convertUrlLink(youtubeObject.getDescription())) ;
		String description = youtubeObject.getDescription();

		description = description.replaceAll("&amp;", "&");

		Matcher printableMatcher = VeamUtil.convPrintableLinkPtn.matcher(description);
		if (printableMatcher.find()) {
			int count = printableMatcher.groupCount();
			if (count > 0) {
				printableId = printableMatcher.group(1);
			}
		}

		description = description.replaceAll(VeamUtil.printableReg, "<Printable>");


		SpannableString spannable = new SpannableString(description);
		Matcher matcher1 = VeamUtil.convURLLinkPtn.matcher(description);
		while (matcher1.find()) {
			spannable.setSpan(new TextClickEventHandler(matcher1.group(0), textView, this), matcher1.start(0), matcher1.end(0), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
		}

		Pattern printablePattern = Pattern.compile("<Printable>", Pattern.CASE_INSENSITIVE);
		Matcher matcher2 = printablePattern.matcher(description);
		if (matcher2.find()) {
			spannable.setSpan(new PrintableClickEventHandler(matcher2.group(0), textView, this, printableId), matcher2.start(0), matcher2.end(0), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			//spannable.setSpan(new ForegroundColorSpan(Color.GREEN),  matcher2.start(0), matcher2.end(0), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
		}

		textView.setText(spannable);
		textView.setTextSize((float) deviceWidth * 3.9f / 100 / scaledDensity);
		textView.setPadding(0, 0, 0, 0);
		textView.setMovementMethod(LinkMovementMethod.getInstance());
		textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000"));
		textView.setTypeface(getTypefaceRobotoLight());
		//textView.setAutoLinkMask(Linkify.WEB_URLS) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		bottomBackView.addView(textView, linearLayoutParams);


		this.addTopBar(youtubeDetailView, this.getString(R.string.youtube), true, true);


	}


	public void addVeamItMenuElement(LinearLayout layout, int imageResourceId, String text, int textColor, int viewId) {

		int elementHeight = deviceWidth / 6;
		int iconSize = deviceWidth / 10;
		LinearLayout.LayoutParams params;

		LinearLayout elementLayout = new LinearLayout(this);
		elementLayout.setOrientation(LinearLayout.HORIZONTAL);
		elementLayout.setOnClickListener(this);
		elementLayout.setId(viewId);

		ImageView imageView = new ImageView(this);
		imageView.setImageResource(imageResourceId);
		imageView.setScaleType(ScaleType.FIT_XY);
		params = new LinearLayout.LayoutParams(iconSize, iconSize);
		elementLayout.addView(imageView, params);

		TextView textView = new TextView(this);
		textView.setText(text);
		textView.setTypeface(getTypefaceRobotoLight());
		textView.setTextColor(textColor);
		textView.setTextSize((float) deviceWidth * 3.5f / 100 / scaledDensity);
		textView.setGravity(Gravity.CENTER_VERTICAL);
		params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, iconSize);
		elementLayout.addView(textView, params);

		params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, elementHeight);
		layout.addView(elementLayout, params);
	}

	public void addVeamItMenuLine(LinearLayout layout) {

		int spacerHeight = deviceWidth / 20;
		int lineWidth = deviceWidth * 13 / 20;
		LinearLayout.LayoutParams params;

		LinearLayout spacerLayout = new LinearLayout(this);
		params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, spacerHeight);
		layout.addView(spacerLayout, params);

		LinearLayout lineLayout = new LinearLayout(this);
		lineLayout.setBackgroundColor(VeamUtil.getColorFromArgbString("FFFFFFFF"));
		params = new LinearLayout.LayoutParams(lineWidth, 1);
		layout.addView(lineLayout, params);

		spacerLayout = new LinearLayout(this);
		params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, spacerHeight);
		layout.addView(spacerLayout, params);

	}

	public void addVeamItMenuStatus(LinearLayout layout) {

		String text = "";
		int textColor = VeamUtil.getColorFromArgbString("FF000000");
		int leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
		int rightColor = VeamUtil.getColorFromArgbString("FF404040");
		int percentage = 0;

		ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();

		// 0:released 1:setting 2:veamreview 3:applereview 4:initialized 5:building
		if (consoleContents.appInfo.getStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_SETTING)) {
			Float completeRatio = consoleContents.getSettingCompletionRatio();
			percentage = (int) (completeRatio * 100);
			if (completeRatio < 1.0) {
				text = String.format("%d%% Complete", percentage);
				textColor = VeamUtil.getColorFromArgbString("FFFFFFFF");
				leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
				rightColor = VeamUtil.getColorFromArgbString("FF404040");
			} else {
				text = "Required app submit";
				textColor = VeamUtil.getColorFromArgbString("FFFFFFFF");
				leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
				rightColor = VeamUtil.getColorFromArgbString("FF404040");
			}
		} else if (consoleContents.appInfo.getStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_MCN_REVIEW)) {
			text = "Data Checking";
			textColor = VeamUtil.getColorFromArgbString("FFFF0000");
			leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
			rightColor = VeamUtil.getColorFromArgbString("FFEEEEEE");
			percentage = 0;
		} else if (consoleContents.appInfo.getStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_BUILDING)) {
			text = "App Building";
			textColor = VeamUtil.getColorFromArgbString("FFFF0000");
			leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
			rightColor = VeamUtil.getColorFromArgbString("FFEEEEEE");
			percentage = 0;
		} else if (consoleContents.appInfo.getStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_APPLE_REVIEW)) {
			text = "Submitting";
			textColor = VeamUtil.getColorFromArgbString("FFFF0000");
			leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
			rightColor = VeamUtil.getColorFromArgbString("FFEEEEEE");
			percentage = 0;
		} else if (consoleContents.appInfo.getStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_RELEASED)) {
			if (consoleContents.appInfo.getModified().equals("1")) {
				text = "Required app upload";
				textColor = VeamUtil.getColorFromArgbString("FFFFFFFF");
				leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
				rightColor = VeamUtil.getColorFromArgbString("FF404040");
				percentage = 100;
			} else {
				text = "Released";
				textColor = VeamUtil.getColorFromArgbString("FFFFFFFF");
				leftColor = VeamUtil.getColorFromArgbString("FFFF0000");
				rightColor = VeamUtil.getColorFromArgbString("FF404040");
				percentage = 0;
			}
		}


		int elementHeight = deviceWidth / 7;
		int lineWidth = deviceWidth * 13 / 20;
		LinearLayout.LayoutParams params;
		RelativeLayout.LayoutParams relativeParams;

		RelativeLayout elementLayout = new RelativeLayout(this);
		elementLayout.setBackgroundColor(Color.RED);
		params = new LinearLayout.LayoutParams(lineWidth, elementHeight);
		layout.addView(elementLayout, params);

		int leftWidth = lineWidth * percentage / 100;
		int rightWidth = lineWidth - leftWidth;

		if (leftWidth > 0) {
			LinearLayout leftLayout = new LinearLayout(this);
			leftLayout.setBackgroundColor(leftColor);
			relativeParams = createParam(leftWidth, elementHeight);
			relativeParams.setMargins(0, 0, 0, 0);
			elementLayout.addView(leftLayout, relativeParams);
		}

		if (rightWidth > 0) {
			LinearLayout rightLayout = new LinearLayout(this);
			rightLayout.setBackgroundColor(rightColor);
			relativeParams = createParam(rightWidth, elementHeight);
			relativeParams.setMargins(leftWidth, 0, 0, 0);
			elementLayout.addView(rightLayout, relativeParams);
		}

		TextView textView = new TextView(this);
		textView.setText(text);
		textView.setTypeface(getTypefaceRobotoLight());
		textView.setTextColor(textColor);
		textView.setTextSize((float) deviceWidth * 4.5f / 100 / scaledDensity);
		textView.setGravity(Gravity.CENTER);
		relativeParams = createParam(lineWidth, elementHeight);
		relativeParams.setMargins(0, 0, 0, 0);
		elementLayout.addView(textView, relativeParams);
	}

	public void addVeamItMenuSpacer(LinearLayout layout, int height) {
		int lineWidth = deviceWidth * 13 / 20;
		LinearLayout.LayoutParams params;
		LinearLayout spacerLayout = new LinearLayout(this);
		params = new LinearLayout.LayoutParams(lineWidth, height);
		layout.addView(spacerLayout, params);
	}


	public void removeVeamItMenuView() {
		VeamUtil.log("debug","removeVeamItMenuView") ;
		ViewGroup rootView = (ViewGroup)this.findViewById(android.R.id.content) ;

		if(veamItMenuBackView != null) {
			VeamUtil.log("debug","start animation veamItMenuBackView") ;
			veamItMenuBackView.bringToFront();
			this.doTranslateAnimation(veamItMenuBackView, 300, -deviceWidth * 3 / 4, 0, 0, 0, null, null);
			veamItMenuBackView = null ;
		}

		if(veamItMenuView != null){
			this.doExpandAnimation(veamItMenuView, 300, 1.0f, 0.8f , 1.0f, 0.8f,deviceWidth/2,deviceHeight/2, "doRemoveVeamItMenuView", null); ;
		}
	}

	public void doRemoveVeamItMenuView(){
		veamItMenuView.removeAllViews() ;
		ViewGroup rootView = (ViewGroup)this.findViewById(android.R.id.content) ;
		rootView.removeView(veamItMenuView) ;
		veamItMenuView = null ;
		rootView.setBackgroundColor(Color.WHITE) ;

	}


	public void createVeamItMenuView(){

		if(VeamUtil.isPreviewMode()) {
			ViewGroup rootView = (ViewGroup) this.findViewById(android.R.id.content);

			String appStatus = ConsoleUtil.getAppStatus();
			if (veamItMenuView != null) {
				veamItMenuView.removeAllViews();
				rootView.removeView(veamItMenuView);
				veamItMenuView = null;
			}

			veamItMenuBackView = rootView.getChildAt(0) ;

			veamItMenuView = new RelativeLayout(this);
			int viewHeight = deviceHeight;
			veamItMenuView.setBackgroundColor(Color.TRANSPARENT);
			//veamItMenuView.setBackgroundColor(Color.RED) ;
			veamItMenuView.setVisibility(View.VISIBLE);
			veamItMenuView.setOnClickListener(this);
			veamItMenuView.setTag(this.VIEWID_SIDE_MENU_VIEW);
			rootView.addView(veamItMenuView, 0,createParam(deviceWidth, viewHeight));


			ScrollView scrollView = new ScrollView(this);
			scrollView.setPadding(deviceWidth / 4, 0, 0, 0);
			scrollView.setVerticalScrollBarEnabled(false);
			scrollView.setOnClickListener(this);
			scrollView.setTag(this.VIEWID_SIDE_MENU_SCROLL_VIEW);
			veamItMenuView.addView(scrollView);
			LinearLayout contentView = new LinearLayout(this);
			contentView.setBackgroundColor(VeamUtil.getColorFromArgbString("FF171717"));
			scrollView.addView(contentView);
			contentView.setOrientation(LinearLayout.VERTICAL);
			int padding = 0;
			contentView.setPadding(deviceWidth / 20, padding, padding, padding);

			LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth, topBarHeight);
			View spacerView = new View(this);
			contentView.addView(spacerView, linearLayoutParams);


			int iconSize = deviceWidth * 10 / 100;
			ImageView imageView = new ImageView(this);
			imageView.setImageResource(R.drawable.c_top_veam);
			imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
			imageView.setVisibility(View.VISIBLE);
			veamItMenuView.addView(imageView, ConsoleUtil.getRelativeLayoutPrams(deviceWidth/4-iconSize,(topBarHeight - iconSize) / 2,iconSize,iconSize));


			/*
			TextView textView = new TextView(this) ;
			textView.setText("TEST") ;
			contentView.addView(textView) ;
			*/
			ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();

			if (appStatus.equals(ConsoleUtil.VEAM_APP_INFO_STATUS_SETTING) || appStatus.equals(ConsoleUtil.VEAM_APP_INFO_STATUS_INITIALIZED)) {
				//this.setMenuForSettingStatus() ;
				// Back to Preview
				// Back to Home
				// ----
				// Status
				// Customize Your App Design
				// Change Payment Type
				// Preparing for App Submission
				// Accept the terms
				// App Submit
				// ----
				// Help and Support
				// FAQ
				// ----
				// Sign out

				boolean termsCompleted = true;
				if (VeamUtil.isEmpty(consoleContents.appInfo.getTermsAcceptedAt())) {
					termsCompleted = false;
				}

				boolean storeInfoCompleted = true;
				if (VeamUtil.isEmpty(consoleContents.appInfo.getKeyword())) {
					storeInfoCompleted = false;
				}
				if (VeamUtil.isEmpty(consoleContents.appInfo.getCategory())) {
					storeInfoCompleted = false;
				}

				if (!consoleContents.isRatingCompleted()) {
					storeInfoCompleted = false;
				}

				/*
				boolean bankCompleted = true ;
				if(![consoleContents isBankCompleted]){
					bankCompleted = false ;
				}
				*/


				this.addVeamItMenuElement(contentView, R.drawable.side_icon_preview, this.getString(R.string.SIDE_MENU_TITLE_PREVIEW), Color.WHITE, this.VIEWID_SIDE_MENU_GOTO_PREVIEW);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_preview, this.getString(R.string.SIDE_MENU_TITLE_HOME), Color.WHITE, this.VIEWID_SIDE_MENU_GOTO_HOME);
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuStatus(contentView);
				this.addVeamItMenuSpacer(contentView, deviceWidth / 12);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_customize, this.getString(R.string.SIDE_MENU_TITLE_DESIGN), Color.WHITE, this.VIEWID_SIDE_MENU_CUSTOMIZE);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_features, this.getString(R.string.SIDE_MENU_TITLE_FEATURE), Color.WHITE, this.VIEWID_SIDE_MENU_PAYMENT_TYPE);
				if (storeInfoCompleted) {
					this.addVeamItMenuElement(contentView, R.drawable.side_icon_information_off, this.getString(R.string.SIDE_MENU_TITLE_APP_INFO), Color.WHITE, this.VIEWID_SIDE_MENU_APP_STORE);
				} else {
					this.addVeamItMenuElement(contentView, R.drawable.side_icon_information, this.getString(R.string.SIDE_MENU_TITLE_APP_INFO), Color.RED, this.VIEWID_SIDE_MENU_APP_STORE);
				}
				if (termsCompleted) {
					this.addVeamItMenuElement(contentView, R.drawable.side_icon_terms_off, this.getString(R.string.SIDE_MENU_TITLE_TERMS), Color.WHITE, this.VIEWID_SIDE_MENU_TERMS);
				} else {
					this.addVeamItMenuElement(contentView, R.drawable.side_icon_terms, this.getString(R.string.SIDE_MENU_TITLE_TERMS), Color.RED, this.VIEWID_SIDE_MENU_TERMS);
				}
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_submit_off, this.getString(R.string.SIDE_MENU_TITLE_SUBMIT), Color.WHITE, this.VIEWID_SIDE_MENU_SUBMIT);
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_helper, this.getString(R.string.SIDE_MENU_TITLE_HELP), Color.WHITE, this.VIEWID_SIDE_MENU_HELP);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_faq, this.getString(R.string.SIDE_MENU_TITLE_FAQ), Color.WHITE, this.VIEWID_SIDE_MENU_FAQ);
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuElement(contentView, 0, this.getString(R.string.SIDE_MENU_TITLE_SIGN_OUT), Color.WHITE, this.VIEWID_SIDE_MENU_SIGN_OUT);
				this.addVeamItMenuSpacer(contentView, deviceHeight / 2);
			} else if (appStatus.equals(ConsoleUtil.VEAM_APP_INFO_STATUS_MCN_REVIEW) || appStatus.equals(ConsoleUtil.VEAM_APP_INFO_STATUS_BUILDING) || appStatus.equals(ConsoleUtil.VEAM_APP_INFO_STATUS_APPLE_REVIEW)) {
				// this.setMenuForReviewStatus() ;
				// Back to Preview
				// Back to Home
				// ----
				// Status
				// Help and Support
				// FAQ
				// ----
				// Sign out

				this.addVeamItMenuElement(contentView, R.drawable.side_icon_preview, this.getString(R.string.SIDE_MENU_TITLE_PREVIEW), Color.WHITE, this.VIEWID_SIDE_MENU_GOTO_PREVIEW);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_preview, this.getString(R.string.SIDE_MENU_TITLE_HOME), Color.WHITE, this.VIEWID_SIDE_MENU_GOTO_HOME);
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuStatus(contentView);
				this.addVeamItMenuSpacer(contentView, deviceWidth / 12);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_helper, this.getString(R.string.SIDE_MENU_TITLE_HELP), Color.WHITE, this.VIEWID_SIDE_MENU_HELP);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_faq, this.getString(R.string.SIDE_MENU_TITLE_FAQ), Color.WHITE, this.VIEWID_SIDE_MENU_FAQ);
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuElement(contentView, 0, this.getString(R.string.SIDE_MENU_TITLE_SIGN_OUT), Color.WHITE, this.VIEWID_SIDE_MENU_SIGN_OUT);
				this.addVeamItMenuSpacer(contentView, deviceHeight / 2);
			} else {
				//this.setMenuForReleasedStatus() ;

				this.addVeamItMenuElement(contentView, R.drawable.side_icon_preview, this.getString(R.string.SIDE_MENU_TITLE_PREVIEW), Color.WHITE, this.VIEWID_SIDE_MENU_GOTO_PREVIEW);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_preview, this.getString(R.string.SIDE_MENU_TITLE_HOME), Color.WHITE, this.VIEWID_SIDE_MENU_GOTO_HOME);
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuStatus(contentView);
				this.addVeamItMenuSpacer(contentView, deviceWidth / 12);
				if (consoleContents.appInfo.getModified().equals("1")) {
					this.addVeamItMenuElement(contentView, R.drawable.side_icon_submit, this.getString(R.string.SIDE_MENU_TITLE_DEPLOY), Color.RED, this.VIEWID_SIDE_MENU_PUBLISH);
				} else {
					this.addVeamItMenuElement(contentView, R.drawable.side_icon_submit_off, this.getString(R.string.SIDE_MENU_TITLE_DEPLOY), Color.WHITE, this.VIEWID_SIDE_MENU_PUBLISH);
				}
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_helper, this.getString(R.string.SIDE_MENU_TITLE_HELP), Color.WHITE, this.VIEWID_SIDE_MENU_HELP);
				this.addVeamItMenuElement(contentView, R.drawable.side_icon_faq, this.getString(R.string.SIDE_MENU_TITLE_FAQ), Color.WHITE, this.VIEWID_SIDE_MENU_FAQ);
				this.addVeamItMenuLine(contentView);
				this.addVeamItMenuElement(contentView, 0, this.getString(R.string.SIDE_MENU_TITLE_SIGN_OUT), Color.WHITE, this.VIEWID_SIDE_MENU_SIGN_OUT);
				this.addVeamItMenuSpacer(contentView, deviceHeight / 2);
			}


			View escapeView = new View(this);
			escapeView.setId(VIEWID_SIDE_MENU_ESCAPE);
			escapeView.setBackgroundColor(Color.TRANSPARENT);
			escapeView.setOnClickListener(this);
			veamItMenuView.addView(escapeView,ConsoleUtil.getRelativeLayoutPrams(0,0,deviceWidth/4,deviceHeight));

			/*



			int margin = deviceWidth * 6 / 100 ;
			LinearLayout youtubeBackView = new LinearLayout(this) ;
			youtubeBackView.setBackgroundColor(Color.argb(0x50, 0xFF, 0xFF, 0xFF)) ;
			youtubeBackView.setPadding(0, margin, 0, margin) ;
			linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth,deviceWidth*9/16+margin*2) ;
			contentView.addView(youtubeBackView,linearLayoutParams) ;

			YouTubePlayerView youtubePlayerView = new YouTubePlayerView(this) ;
			youtubePlayerView.initialize(VeamUtil.YOUTUBE_DEVELOPER_KEY, this) ;
			youtubePlayerView.setPadding(0, 0, 0, 0) ;
			youtubePlayerView.setBackgroundColor(Color.TRANSPARENT) ;
			linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth,deviceWidth*9/16) ;
			//linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,800) ;
			youtubeBackView.addView(youtubePlayerView,linearLayoutParams) ;

			int sideMargin = deviceWidth * 3 / 100 ;
			int topMargin = deviceWidth * 3 / 100 ;
			int bottomMargin = deviceWidth * 5 / 100 ;
			LinearLayout bottomBackView = new LinearLayout(this) ;
			bottomBackView.setBackgroundColor(Color.argb(0x50, 0xFF, 0xFF, 0xFF)) ;
			bottomBackView.setPadding(sideMargin, topMargin, sideMargin, bottomMargin) ;
			bottomBackView.setOrientation(LinearLayout.VERTICAL) ;
			linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			linearLayoutParams.setMargins(0, margin, 0, 0) ;
			contentView.addView(bottomBackView,linearLayoutParams) ;

			LinearLayout bottomHeadView = new LinearLayout(this) ;
			bottomHeadView.setBackgroundColor(Color.TRANSPARENT) ;
			bottomHeadView.setPadding(0,0,0,0) ;
			bottomHeadView.setOrientation(LinearLayout.HORIZONTAL) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			linearLayoutParams.setMargins(0, 0, 0, 0) ;
			bottomBackView.addView(bottomHeadView,linearLayoutParams) ;

			LinearLayout bottomTextView = new LinearLayout(this) ;
			bottomTextView.setBackgroundColor(Color.TRANSPARENT) ;
			bottomTextView.setPadding(0,0,0,0) ;
			bottomTextView.setOrientation(LinearLayout.VERTICAL) ;
			linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*80/100,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			linearLayoutParams.setMargins(0, 0, 0, 0) ;
			bottomHeadView.addView(bottomTextView,linearLayoutParams) ;


			TextView textView = new TextView(this) ;
			textView.setText(youtubeObject.getTitle()) ;
			textView.setTextSize((float)deviceWidth * 5.9f / 100 / scaledDensity) ;
			textView.setPadding(0, 0, 0, 0) ;
			textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000")) ;
			textView.setTypeface(getTypefaceRobotoLight()) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			bottomTextView.addView(textView,linearLayoutParams) ;


			int durationInSec = Integer.parseInt(youtubeObject.getDuration()) ;
			String durationString = String.format("%02d:%02d", durationInSec/60,durationInSec%60) ;
			textView = new TextView(this) ;
			textView.setText(durationString) ;
			textView.setTextSize((float)deviceWidth * 3.0f / 100 / scaledDensity) ;
			textView.setPadding(0, deviceWidth*2/100, 0, 0) ;
			textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000")) ;
			textView.setTypeface(getTypefaceRobotoLight()) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			bottomTextView.addView(textView,linearLayoutParams) ;

			String videoId = youtubeObject.getId() ;
			favoriteVideoImageView = new ImageView(this) ;
			favoriteVideoImageView.setId(VIEWID_ADD_FAVORITE_VIDEO) ;
			favoriteVideoImageView.setOnClickListener(this) ;
			if(VeamUtil.isFavoriteVideo(this, videoId)){
				//favoriteVideoImageView.setImageResource(R.drawable.add_on);
				favoriteVideoImageView.setImageBitmap(VeamUtil.getThemeImage(this,"add_on",1));
			} else {
				favoriteVideoImageView.setImageBitmap(VeamUtil.getThemeImage(this,"add_off",1)) ;
			}
			linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*12/100,deviceWidth*12/100) ;
			linearLayoutParams.setMargins(deviceWidth*1/100, 0, 0, 0) ;
			bottomHeadView.addView(favoriteVideoImageView,linearLayoutParams) ;

			View lineView = new View(this) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*90/100,1) ;
			linearLayoutParams.setMargins(0, deviceWidth*3/100, 0, deviceWidth*3/100) ;
			bottomBackView.addView(lineView,linearLayoutParams) ;

			textView = new TextView(this) ;


			//Spanned html = Html.fromHtml(VeamUtil.convertUrlLink(youtubeObject.getDescription())) ;
			String description = youtubeObject.getDescription() ;

			description = description.replaceAll("&amp;", "&") ;

			Matcher printableMatcher = VeamUtil.convPrintableLinkPtn.matcher(description);
			if(printableMatcher.find()){
				int count = printableMatcher.groupCount() ;
				if(count > 0){
					printableId = printableMatcher.group(1) ;
				}
			}

			description = description.replaceAll(VeamUtil.printableReg, "<Printable>") ;


			SpannableString spannable = new SpannableString(description);
			Matcher matcher1 = VeamUtil.convURLLinkPtn.matcher(description);
			while(matcher1.find()){
				spannable.setSpan(new TextClickEventHandler(matcher1.group(0), textView,this), matcher1.start(0), matcher1.end(0), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			}

			Pattern printablePattern = Pattern.compile("<Printable>",Pattern.CASE_INSENSITIVE) ;
			Matcher matcher2 = printablePattern.matcher(description) ;
			if(matcher2.find()){
				spannable.setSpan(new PrintableClickEventHandler(matcher2.group(0), textView,this,printableId), matcher2.start(0), matcher2.end(0), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				//spannable.setSpan(new ForegroundColorSpan(Color.GREEN),  matcher2.start(0), matcher2.end(0), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			}

			textView.setText(spannable) ;
			textView.setTextSize((float)deviceWidth * 3.9f / 100 / scaledDensity) ;
			textView.setPadding(0, 0, 0, 0) ;
			textView.setMovementMethod(LinkMovementMethod.getInstance());
			textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000")) ;
			textView.setTypeface(getTypefaceRobotoLight()) ;
			//textView.setAutoLinkMask(Linkify.WEB_URLS) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			bottomBackView.addView(textView,linearLayoutParams) ;


			this.addTopBar(youtubeDetailView, this.getString(R.string.youtube),true,true) ;

			*/

			rootView.setBackgroundColor(Color.BLACK);
			this.doTranslateAnimation(veamItMenuBackView, 300, 0, -deviceWidth * 3 / 4, 0, 0, "bringVeamItMenuToFront", null) ;
			this.doExpandAnimation(veamItMenuView, 300, 0.8f, 1.0f , 0.8f, 1.0f,deviceWidth/2,deviceHeight/2, null, null); ;
			//this.doTranslateAnimation(pictureView, 300, deviceWidth, 0, 0, 0, "doReloadPicture", null) ;
		}
	}

	public void bringVeamItMenuToFront(){
		if(veamItMenuView != null){
			veamItMenuView.bringToFront();
			if(veamitTutorialBaseView != null){
				veamitTutorialBaseView.bringToFront();
			}
		}
	}


	@Override
	public void onInitializationFailure(Provider arg0,YouTubeInitializationResult errorReason) {
		//VeamUtil.log("debug","onInitializationFailure") ;
		Toast.makeText(this, errorReason.toString(), Toast.LENGTH_LONG).show();
	}

	@Override
	public void onInitializationSuccess(Provider provider, YouTubePlayer player,boolean wasRestored) {
		//VeamUtil.log("debug","onInitializationSuccess") ;
		if (!wasRestored) {
			//player.addFullscreenControlFlag(YouTubePlayer.FULLSCREEN_FLAG_CUSTOM_LAYOUT) ;
			//player.setShowFullscreenButton(true) ;
			//player.setPlaybackEventListener(this) ;
			currentYoutubePlayer = player ;
			player.addFullscreenControlFlag(YouTubePlayer.FULLSCREEN_FLAG_ALWAYS_FULLSCREEN_IN_LANDSCAPE) ;
	        player.cueVideo(this.currentYoutubeVideoId);
	        //player.loadVideo(this.currentYoutubeVideoId) ;
	    }
	}
	
	//ClickableSpanクラスを継承したクラス
	public class TextClickEventHandler extends ClickableSpan {
		TextView textView ;
		String text ;
		VeamActivity veamActivity ;

		public TextClickEventHandler(String url, TextView tvPost,VeamActivity veamActivity) {
			super() ;
			this.text = url ;
			this.textView = tvPost ;
			this.veamActivity  = veamActivity ;
		}

		@Override
		public void onClick(View view) {
			/*
			//以下の三行を書く事で背景色が黒に戻るようになる
			Spannable spannable = (Spannable)tvPost.getText();
			//カラーコード0xAARRGGBB(AAアルファは透明度)
			spannable.setSpan(new BackgroundColorSpan(0xFF000000), 0, 0, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
			tvPost.setText(spannable);
			*/
			//Log.v("debug", "textClickEventHandler event occur : " + this.text);
			veamActivity.onUrlClick(this.text) ;
		}
		
		@Override
	    public void updateDrawState(TextPaint ds) {
	        super.updateDrawState(ds);
	        ds.setUnderlineText(false);
	        //ds.setTypeface(Typeface.create(ds.getTypeface(), Typeface.BOLD));
	        ds.setColor(VeamUtil.getLinkTextColor(VeamActivity.this));
	    }
	}
	
	//ClickableSpanクラスを継承したクラス
	public class PrintableClickEventHandler extends ClickableSpan {
		TextView textView ;
		String text ;
		VeamActivity veamActivity ;

		public PrintableClickEventHandler(String url, TextView tvPost,VeamActivity veamActivity,String printableId) {
			super() ;
			this.text = url ;
			this.textView = tvPost ;
			this.veamActivity  = veamActivity ;
		}

		@Override
		public void onClick(View view) {
			/*
			//以下の三行を書く事で背景色が黒に戻るようになる
			Spannable spannable = (Spannable)tvPost.getText();
			//カラーコード0xAARRGGBB(AAアルファは透明度)
			spannable.setSpan(new BackgroundColorSpan(0xFF000000), 0, 0, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
			tvPost.setText(spannable);
			*/
			Log.v("debug", "textClickEventHandler event occur : " + this.text);
			veamActivity.onPrintableClick(printableId) ;
		}
		
		@Override
	    public void updateDrawState(TextPaint ds) {
	        super.updateDrawState(ds);
	        ds.setUnderlineText(false);
	        //ds.setTypeface(Typeface.create(ds.getTypeface(), Typeface.BOLD));
	        ds.setColor(0xFFFF69C0);
	    }
	}
	
	public void onUrlClick(String url) {
		//VeamUtil.log("debug","VeamActivity::onUrlClick") ;
	}
	
	public void onPrintableClick(String printableId) {
		//VeamUtil.log("debug","VeamActivity::onPrintableClick") ;
	}

	
	
	public void showPictureView(
			RelativeLayout rootLayout,
			RelativeLayout previousView,
			boolean forward,
			boolean recreate,
			FollowAdapter.FollowAdapterActivityInterface followActivity,
			boolean showSettingsButton
			){
		

		if(recreate){
			String forumId = currentForumObject.getId() ;
			String forumKind = currentForumObject.getKind() ;
			boolean isForumGroup = currentForumObject.isForumGroup() ;
			int numberOfMembers = currentForumObject.getNumberOfMembers() ;
			
			boolean shouldShowForumName = false ;
			if(VeamUtil.isSpecialForumId(forumId)){
				shouldShowForumName = true ;
			}

			//currentForumName = currentForumObject.getName() ;
			//VeamUtil.log("debug","tap "+currentForumObject.getName()) ;
			if(pictureView != null){
				pictureView.removeAllViews() ;
				rootLayout.removeView(pictureView) ;
				pictureView = null ;
			}
			
			pictureView = this.addMainView(rootLayout, View.VISIBLE) ;
	
			pictureListView = new OverScrollListView(this,topBarHeight) ;
			//pictureListView.setOnTouchListener(this) ;
			//recipeListView.setVerticalFadingEdgeEnabled(false) ;
			//recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
			pictureListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
			//pictureListView.setOnItemClickListener(this) ;
			pictureListView.setBackgroundColor(Color.TRANSPARENT) ;
			pictureListView.setCacheColorHint(Color.TRANSPARENT) ;
			pictureListView.setVerticalScrollBarEnabled(false) ;
			pictureListView.setPadding(0, 0, 0, 0) ;
			pictureListView.setDivider(null) ;
			RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
			pictureView.addView(pictureListView,layoutParams) ;
			
			int segmentHeight = deviceWidth * 14 / 100 ;
			int topMargin = topBarHeight ;
			if(isForumGroup){
				topMargin += segmentHeight ;
			}
			pictureAdapter = new PictureAdapter(this,null,deviceWidth,topMargin,scaledDensity,shouldShowForumName,this.getString(R.string.admob_id_forum_native), AdSize.SMART_BANNER) ;
			pictureListView.setAdapter(pictureAdapter) ;
			
			pictureProgressBar = new ProgressBar(this) ;
			pictureProgressBar.setIndeterminate(true) ;
			pictureProgressBar.setVisibility(View.VISIBLE) ;
			layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
			layoutParams.setMargins(deviceWidth * 45 / 100, deviceHeight / 2, 0, 0) ;
			pictureView.addView(pictureProgressBar,layoutParams) ;
			
			
			if(isForumGroup){
				forumGroupMemberListView = new OverScrollListView(this,topBarHeight) ;
				//recipeListView.setVerticalFadingEdgeEnabled(false) ;
				//recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
				forumGroupMemberListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
				forumGroupMemberListView.setOnItemClickListener(this) ;
				forumGroupMemberListView.setBackgroundColor(Color.TRANSPARENT) ;
				forumGroupMemberListView.setCacheColorHint(Color.TRANSPARENT) ;
				forumGroupMemberListView.setVerticalScrollBarEnabled(false) ;
				forumGroupMemberListView.setPadding(0, 0, 0, 0) ;
				forumGroupMemberListView.setDivider(null) ;
				layoutParams = createParam(deviceWidth, viewHeight) ;
				pictureView.addView(forumGroupMemberListView,layoutParams) ;
				
				topMargin = topBarHeight ;
				topMargin += segmentHeight ;
				forumGroupMemberAdapter = new FollowAdapter(followActivity,this,null,deviceWidth,topMargin,scaledDensity) ;
				forumGroupMemberListView.setAdapter(forumGroupMemberAdapter) ;
				
				forumGroupMemberProgressBar = new ProgressBar(this) ;
				forumGroupMemberProgressBar.setIndeterminate(true) ;
				forumGroupMemberProgressBar.setVisibility(View.INVISIBLE) ;
				layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
				layoutParams.setMargins(deviceWidth * 45 / 100, deviceHeight / 2, 0, 0) ;
				pictureView.addView(forumGroupMemberProgressBar,layoutParams) ;
				
				forumGroupMemberListView.setVisibility(View.GONE); 
			}
			
	
			//this.reloadPicture() ;
	
			if(forumId.equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS)){
				this.addTopBar(pictureView, currentForumObject.getName(),true,showSettingsButton) ;
                /*
				ImageView imageView = new ImageView(this) ;
				imageView.setImageResource(R.drawable.forum_menu) ;
				imageView.setId(this.VIEWID_TOP_BAR_BACK_BUTTON) ;
				imageView.setOnClickListener(this) ;
				imageView.setScaleType(ImageView.ScaleType.FIT_XY);
				layoutParams = createParam(topBarHeight, topBarHeight) ;
				topBarView.addView(imageView,layoutParams) ;
				*/

				int noFollowTextHeight = deviceWidth * 15 / 100 ;
				noFollowTextView = new TextView(this) ;
				noFollowTextView.setText(this.getString(R.string.no_following)) ;
				noFollowTextView.setTypeface(getTypefaceRobotoLight()) ;
				noFollowTextView.setTextColor(VeamUtil.getColorFromArgbString("FF818181")) ;
				noFollowTextView.setTextSize((float)deviceWidth * 4.5f / 100 / scaledDensity) ;
				noFollowTextView.setGravity(Gravity.CENTER) ;
				noFollowTextView.setVisibility(View.GONE) ;
				layoutParams = new RelativeLayout.LayoutParams(deviceWidth,noFollowTextHeight) ;
				layoutParams.setMargins(0, deviceHeight / 2 - noFollowTextHeight, 0, 0) ;
				pictureView.addView(noFollowTextView,layoutParams) ;
				
			} else {
				if(currentForumObject.getKind().equals("2")) { // Hot Topics
					this.addTopBar(pictureView, this.getString(R.string.forum_name_hot_topics), true, showSettingsButton);
				} else {

					int iconSize = 0 ;
					if(VeamUtil.isPreviewMode()) {
						if (!isPreventSignoutButton) {
							iconSize = deviceWidth * 10 / 100;
						}
					}

					int cameraButtonWidth = topBarHeight * 70 / 100 ;
					int cameraButtonX = deviceWidth-topBarHeight-cameraButtonWidth-iconSize ;
					int titleWidth = deviceWidth - (deviceWidth - cameraButtonX) * 2 ;

					this.addTopBar(pictureView, currentForumObject.getName(), true, showSettingsButton,titleWidth);
				}
			}
	
			if(!VeamUtil.isSpecialForumId(forumId) && !currentForumObject.getKind().equals("2")){
				int iconSize = 0 ;
				if(VeamUtil.isPreviewMode()) {
					if (!isPreventSignoutButton) {
						iconSize = deviceWidth * 10 / 100;
					}
				}

				int cameraButtonWidth = topBarHeight * 70 / 100 ;
				cameraButtonImageView = new ImageView(this) ;
                //imageView.setImageResource(R.drawable.camera_button) ;
				cameraButtonImageView.setImageBitmap(VeamUtil.getThemeImage(this, "camera_button", 1)) ;
				cameraButtonImageView.setId(VIEWID_CAMERA_BUTTON) ;
				cameraButtonImageView.setOnClickListener(this) ;
				cameraButtonImageView.setScaleType(ScaleType.FIT_XY);
				layoutParams = createParam(cameraButtonWidth, cameraButtonWidth) ;
				int cameraButtonX = deviceWidth-topBarHeight-cameraButtonWidth-iconSize ;
				layoutParams.setMargins(cameraButtonX, topBarHeight * 20 /100, 0, 0) ;
				pictureView.addView(cameraButtonImageView, layoutParams) ;

				if(!VeamUtil.isEmpty(forumKind) && forumKind.equals("6")){
					cameraButtonImageView.setVisibility(View.GONE) ;
				}
			}
			
			loadMoreArea = new LinearLayout(this) ;
			loadMoreArea.setOrientation(LinearLayout.HORIZONTAL) ;
			layoutParams = createParam(deviceWidth, deviceWidth*10/100) ;
			layoutParams.setMargins(0, viewHeight-deviceWidth*10/100, 0, 0) ;
			pictureView.addView(loadMoreArea,layoutParams) ;
			
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
			loadMoreTextView.setTypeface(getTypefaceRobotoLight()) ;
			linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,0.0f) ;
			loadMoreArea.addView(loadMoreTextView,linearLayoutParams) ;
	
			spacer = new TextView(this) ;
			spacer.setBackgroundColor(Color.TRANSPARENT);
			linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,1.0f) ;
			loadMoreArea.addView(spacer,linearLayoutParams) ;
			
			loadMoreArea.setVisibility(View.GONE) ;
			
			if(isForumGroup){
				RelativeLayout segmentView = new RelativeLayout(this) ;
				segmentView.setBackgroundColor(Color.argb(0xE0, 0x00, 0x00, 0x00)) ;
				segmentView.setVisibility(View.VISIBLE) ;
				layoutParams = createParam(deviceWidth, segmentHeight) ;
				layoutParams.setMargins(0,topBarHeight, 0, 0) ;
				pictureView.addView(segmentView,layoutParams) ;

				int imageHeight = segmentHeight * 67 / 100 ;
				int imageY = (segmentHeight - imageHeight) / 2 ;
				forumGroupSegmentImageView = new ImageView(this) ;
				forumGroupSegmentImageView.setImageResource(R.drawable.forum_group_segment_left);
				forumGroupSegmentImageView.setScaleType(ScaleType.CENTER_CROP);
				forumGroupSegmentImageView.setVisibility(View.VISIBLE) ;
				layoutParams = createParam(deviceWidth, imageHeight) ;
				layoutParams.setMargins(0, imageY, 0, 0) ;
				segmentView.addView(forumGroupSegmentImageView,layoutParams) ;
				
				forumGroupSegmentLeftTextView = new TextView(this) ;
				forumGroupSegmentLeftTextView.setId(VIEWID_FORUM_GROUP_SEGMENT_POST) ;
				forumGroupSegmentLeftTextView.setOnClickListener(this) ;
				forumGroupSegmentLeftTextView.setText("Posts") ;
				forumGroupSegmentLeftTextView.setTextColor(VeamUtil.getColorFromArgbString("FF2F2F2F")) ;
				forumGroupSegmentLeftTextView.setGravity(Gravity.CENTER) ;
				forumGroupSegmentLeftTextView.setVisibility(View.VISIBLE) ;
				forumGroupSegmentLeftTextView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
				forumGroupSegmentLeftTextView.setSingleLine() ;
				forumGroupSegmentLeftTextView.setEllipsize(TruncateAt.END);
				forumGroupSegmentLeftTextView.setTypeface(getTypefaceRobotoLight()) ;
				layoutParams = createParam(deviceWidth/2, segmentHeight) ;
				layoutParams.setMargins(0 , 0, 0, 0) ;
				segmentView.addView(forumGroupSegmentLeftTextView,layoutParams) ;
				
				forumGroupSegmentRightTextView = new TextView(this) ;
				forumGroupSegmentRightTextView.setId(VIEWID_FORUM_GROUP_SEGMENT_NUMBER) ;
				forumGroupSegmentRightTextView.setOnClickListener(this) ;
				forumGroupSegmentRightTextView.setText(String.format("Members(%d)", currentForumObject.getNumberOfMembers())) ;
				forumGroupSegmentRightTextView.setTextColor(VeamUtil.getColorFromArgbString("FFFFFFFF")) ;
				forumGroupSegmentRightTextView.setGravity(Gravity.CENTER) ;
				forumGroupSegmentRightTextView.setVisibility(View.VISIBLE) ;
				forumGroupSegmentRightTextView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
				forumGroupSegmentRightTextView.setSingleLine() ;
				forumGroupSegmentRightTextView.setEllipsize(TruncateAt.END);
				forumGroupSegmentRightTextView.setTypeface(getTypefaceRobotoLight()) ;
				layoutParams = createParam(deviceWidth/2, segmentHeight) ;
				layoutParams.setMargins(deviceWidth/2 , 0, 0, 0) ;
				segmentView.addView(forumGroupSegmentRightTextView,layoutParams) ;
			}
		}

		if(forward){
			this.doTranslateAnimation(previousView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(pictureView, 300, deviceWidth, 0, 0, 0, "doReloadPicture", null) ;
		} else {
			this.doTranslateAnimation(previousView, 300, 0, deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(pictureView, 300, -deviceWidth, 0, 0, 0, "doReloadPicture", null) ;
		}
	}
	
	public void doReloadPicture(){
		this.reloadPicture() ;
	}
	
	public void showFollowView(
			RelativeLayout rootLayout,
			RelativeLayout previousView,
			boolean forward,
			boolean isFindUser,
			String findUserName,
			String screenTitle,
			String iconUrl,
			FollowAdapter.FollowAdapterActivityInterface followActivity,
			boolean showSettingsButton
			){
		

		if(followView != null){
			followView.removeAllViews() ;
			rootLayout.removeView(followView) ;
			followView = null ;
		}
		
		followView = this.addMainView(rootLayout, View.VISIBLE) ;

		followListView = new OverScrollListView(this,topBarHeight) ;
		//recipeListView.setVerticalFadingEdgeEnabled(false) ;
		//recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
		followListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
		followListView.setOnItemClickListener(this) ;
		followListView.setBackgroundColor(Color.TRANSPARENT) ;
		followListView.setCacheColorHint(Color.TRANSPARENT) ;
		followListView.setVerticalScrollBarEnabled(false) ;
		followListView.setPadding(0, 0, 0, 0) ;
		followListView.setDivider(null) ;
		RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
		followView.addView(followListView,layoutParams) ;
		
		int findViewHeight = deviceWidth * 14 / 100 ;
		int topMargin = topBarHeight ;
		if(isFindUser){
			topMargin += findViewHeight ;
		}
		followAdapter = new FollowAdapter(followActivity,this,null,deviceWidth,topMargin,scaledDensity) ;
		followListView.setAdapter(followAdapter) ;
		
		followProgressBar = new ProgressBar(this) ;
		followProgressBar.setIndeterminate(true) ;
		if(isFindUser){
			followProgressBar.setVisibility(View.INVISIBLE) ;
		} else {
			followProgressBar.setVisibility(View.VISIBLE) ;
		}
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
		layoutParams.setMargins(deviceWidth * 45 / 100, deviceHeight / 2, 0, 0) ;
		followView.addView(followProgressBar,layoutParams) ;
		
		this.addTopBar(followView, screenTitle,true,showSettingsButton) ;
		
		RelativeLayout topBarView = (RelativeLayout)followView.findViewById(VIEWID_TOP_BAR) ;
		TextView topBarTitleTextView = (TextView)followView.findViewById(VIEWID_TOP_BAR_TITLE) ;
		
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
		
		this.trackPageView(String.format("FollowList")) ;
		
		if(isFindUser){
			RelativeLayout findView = new RelativeLayout(this) ;
			findView.setBackgroundColor(Color.argb(0xFF, 0xD5, 0xD5, 0xD5)) ; // FFD5D5D5
			findView.setVisibility(View.VISIBLE) ;
			layoutParams = createParam(deviceWidth, findViewHeight) ;
			layoutParams.setMargins(0,topBarHeight, 0, 0) ;
			followView.addView(findView,layoutParams) ;
			
			findUserNameEditText = new EditText(this) ;
			findUserNameEditText.setId(VIEWID_FIND_USER_EDIT_TEXT) ;
			findUserNameEditText.setInputType(InputType.TYPE_CLASS_TEXT);
			findUserNameEditText.setMaxLines(1) ;
			//userNameEditText.setId(VIEWID_USER_DESCRIPTION_TEXT) ;
			findUserNameEditText.setBackgroundColor(Color.argb(0xFF,0xFF,0xFF,0xFF)) ;
			findUserNameEditText.setBackgroundResource(R.drawable.find_user_text) ;
			findUserNameEditText.setGravity(Gravity.TOP) ;
			findUserNameEditText.setTypeface(getTypefaceRobotoLight()) ;
			findUserNameEditText.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
			findUserNameEditText.addTextChangedListener(this) ;
			findUserNameEditText.setOnFocusChangeListener(this) ;
			if(!VeamUtil.isEmpty(findUserName)){
				findUserNameEditText.setText(findUserName) ;
			}
			layoutParams = new RelativeLayout.LayoutParams(deviceWidth*80/100,deviceWidth * 10 / 100) ;
			layoutParams.setMargins(deviceWidth*3/100, deviceWidth*2/100, 0, 0) ;
			findView.addView(findUserNameEditText,layoutParams) ;

			int findTextWidth = deviceWidth*14/100 ;
			int findTextX = deviceWidth*86/100 ;
			TextView findTextView = new TextView(this) ;
			findTextView.setId(VIEWID_FIND_USER_TEXT) ;
			findTextView.setOnClickListener(this) ;
			findTextView.setText("FIND") ;
			findTextView.setTextColor(VeamUtil.getColorFromArgbString("FF989898")) ;
			findTextView.setGravity(Gravity.CENTER_VERTICAL) ;
			findTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
			findTextView.setTypeface(getTypefaceRobotoLight()) ;
			layoutParams = new RelativeLayout.LayoutParams(findTextWidth,findViewHeight) ;
			layoutParams.setMargins(findTextX, 0, 0, 0) ;
			findView.addView(findTextView,layoutParams) ;
			
			int findProgressSize = findViewHeight * 70 / 100 ;
			int findProgressX = findTextX + (findTextWidth-findProgressSize) / 4 ;
			findUserProgressBar = new ProgressBar(this) ;
			findUserProgressBar.setIndeterminate(true) ;
			findUserProgressBar.setVisibility(View.INVISIBLE) ;
			layoutParams = new RelativeLayout.LayoutParams(findProgressSize,findProgressSize) ;
			layoutParams.setMargins(findProgressX, (findViewHeight-findProgressSize)/2, 0, 0) ;
			findView.addView(findUserProgressBar,layoutParams) ;
		}

		loadMoreArea = new LinearLayout(this) ;
		loadMoreArea.setOrientation(LinearLayout.HORIZONTAL) ;
		layoutParams = createParam(deviceWidth, deviceWidth*10/100) ;
		layoutParams.setMargins(0, viewHeight-deviceWidth*10/100, 0, 0) ;
		followView.addView(loadMoreArea,layoutParams) ;
		
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
		loadMoreTextView.setTypeface(getTypefaceRobotoLight()) ;
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,0.0f) ;
		loadMoreArea.addView(loadMoreTextView,linearLayoutParams) ;

		spacer = new TextView(this) ;
		spacer.setBackgroundColor(Color.TRANSPARENT);
		linearLayoutParams = new TableRow.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, deviceWidth*10/100,1.0f) ;
		loadMoreArea.addView(spacer,linearLayoutParams) ;
		
		loadMoreArea.setVisibility(View.GONE) ;

		String postCommand = null ;
		if(!isFindUser || !VeamUtil.isEmpty(findUserName)){
			postCommand = "doReloadFollow" ;
		}
		if(forward){
			this.doTranslateAnimation(previousView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(followView, 300, deviceWidth, 0, 0, 0, postCommand, null) ;
		} else {
			this.doTranslateAnimation(previousView, 300, 0, deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(followView, 300, -deviceWidth, 0, 0, 0, postCommand, null) ;
		}
		
	}
	
	
	public void doReloadFollow(){
		this.reloadFollow() ;
	}
	
	public void reloadFollow(){
		// should be overridden
	}
	
	public void showNoFollowText(){
		if(noFollowTextView != null){
			noFollowTextView.setVisibility(View.VISIBLE) ;
		}
		if(pictureProgressBar != null){
			pictureProgressBar.setVisibility(View.GONE) ;
		}
	}
	
	public void executeLoadPictureTask(){
		String socialUserId = "" ;
		if(currentForumObject != null){
			if(currentForumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_USER_POST)){
				socialUserId = currentProfileSocialUserId ;
			} else {
				if(VeamUtil.isLogin(this)){
					socialUserId = VeamUtil.getSocialUserId(this) ;
				}
			} 
			
			if(currentForumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS) && !VeamUtil.isLogin(this)){
				this.showNoFollowText() ;
			} else {
				LoadPictureTask loadPictureTask = new LoadPictureTask(this,currentForumObject.getId(),currentPageNo,socialUserId) ;
				loadPictureTask.execute("") ;
			}
		}
	}

	public void reloadPicture(){
		currentPageNo = 1 ;
		this.executeLoadPictureTask() ;
	}

	public void loadMorePicture(){
		loadMoreArea.setVisibility(View.VISIBLE) ;
		currentPageNo++ ;
		this.executeLoadPictureTask() ;
	}

	public void updatePicture(PictureXml pictureXml,int pageNo){
		if(pictureProgressBar != null){
			pictureProgressBar.setVisibility(View.GONE) ;
		}

		loadMoreArea.setVisibility(View.GONE) ;
		//VeamUtil.log("debug","updatePicture") ;
		if(pageNo == 1){
			pictureAdapter.setPictures(pictureXml) ;
			if(pictureXml.getNumberOfPictures() == 0){
				if(currentForumObject != null){
					if(currentForumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS)){
						this.showNoFollowText() ;
					}
				}
			}
		} else {
			pictureAdapter.addPictures(pictureXml) ;
		}
		pictureListView.setScrollStateNormal() ;
		pictureAdapter.notifyDataSetChanged() ;
		if(pictureAdapter.getForumUserPermission()){
			if(cameraButtonImageView != null){
				cameraButtonImageView.setVisibility(View.VISIBLE) ;
			}
		}
	}

	public void onPictureLoadFailed(){
		//VeamUtil.log("debug","onPictureLoadFailed") ;
		this.onBackButtonClicked() ;
	}
	
	public void onBackButtonClicked(){
		// should be overridden
	}

	public void deletePictureDone(Integer resultCode,PictureObject pictureObject) {
		//VeamUtil.log("debug","ForumActivity::deletePictureDone:"+resultCode) ;
		if(pictureAdapter != null){
			pictureAdapter.deletePictureObject(pictureObject) ;
			pictureAdapter.notifyDataSetChanged() ;
		}
	}

	public void onPictureReportFinished(){
		//VeamUtil.log("debug","onPictureReportFinished") ;
		AlertDialog.Builder alertDialog = new AlertDialog.Builder(this) ;
	    alertDialog.setTitle(this.getString(R.string.message_sent)) ;
	    alertDialog.setPositiveButton("OK", null) ;
	    alertDialog.create() ;
	    alertDialog.show() ;
	}

	public void onPictureReportFailed(Integer result){
		//VeamUtil.log("debug","onPictureReportFailed "+result) ;
		AlertDialog.Builder alertDialog = new AlertDialog.Builder(this) ;
	    alertDialog.setTitle(this.getString(R.string.failed_to_send_message)) ;
	    alertDialog.setPositiveButton("OK", null) ;
	    alertDialog.create() ;
	    alertDialog.show() ;
	}

	public void onPostCommentFinished(PictureCommentObject pictureCommentObject){
		//VeamUtil.log("debug","onPostCommentFinished") ;
		postProgressBar.setVisibility(View.GONE) ;
		postTextView.setVisibility(View.VISIBLE); 
		if(pictureCommentObject != null){
			if(currentPictureObject != null){
				currentPictureObject.addComment(pictureCommentObject) ;
			}
			this.finishCommentView() ;
		} else {
			
		}
		//VeamUtil.kickKiip(this,"PictureComment");
	}

	public void finishCommentView(){
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
	}

	@Override
	public void afterTextChanged(Editable editable) {
		// nothing to do
	}

	@Override
	public void beforeTextChanged(CharSequence s, int start, int count,int after) {
		// nothing to do
	}

	@Override
	public void onTextChanged(CharSequence s, int start, int before, int count) {
		// nothing to do
		// findUserName 決め打ち。（複数のEditText を処理する場合は対処必要　http://stackoverflow.com/questions/5702771/how-to-use-single-textwatcher-for-multiple-edittexts）
		if(this.followView != null){
			TextView findTextView = (TextView)followView.findViewById(VIEWID_FIND_USER_TEXT) ;
			if(findTextView != null){
				String string = s.toString() ;
				if(VeamUtil.isEmpty(string)){
					findTextView.setTextColor(VeamUtil.getColorFromArgbString("FF989898")) ;
				} else {
					findTextView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
				}
			}
		}
	}
	
	public void releaseImageView(ImageView imageView){
		//VeamUtil.log("debug","releaseImageView") ;
		if(imageView != null){
			//VeamUtil.log("debug","imageView != null") ;
			BitmapDrawable bitmapDrawable = (BitmapDrawable)imageView.getDrawable() ;
			if(bitmapDrawable != null){
				//VeamUtil.log("debug","bitmapDrawable != null") ;
				Bitmap bitmap = bitmapDrawable.getBitmap() ;
				if(bitmap != null){
					//VeamUtil.log("debug","bitmap != null") ;
					bitmap.recycle();
				}
			}
			imageView.setImageBitmap(null) ;
			imageView.setImageDrawable(null) ;
		}
	}

	@Override
	public void onFocusChange(View v, boolean hasFocus) {
		// should be overridden
	}
	
	public SQLiteDatabase getDb(){
		return mDb ;
	}


	/*
	// オプションメニューが最初に呼び出される時に1度だけ呼び出されます
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// メニューアイテムを追加します
		menu.add(Menu.NONE, 1, Menu.NONE, "Menu1");
		menu.add(Menu.NONE, 2, Menu.NONE, "Menu2");
		return super.onCreateOptionsMenu(menu);
	}
	*/

	@Override
	protected void onPause() {
		//VeamUtil.log("debug","onPause()") ;
		super.onPause();
		if(webPageView != null) {
			//VeamUtil.log("debug", "call WebView::reload()") ;
			// to stop youtube background playback
			webPageView.reload();
		}
	}

	@Override
	protected void onResume(){
		VeamUtil.log("debug", "VeamActivity::onResume()") ;
		super.onResume() ;

		if(VeamUtil.isPreviewMode()){
			VeamUtil.log("debug", "isPreviewMode");
			if(!preventUpdateOnResume) {
				VeamUtil.log("debug", "not prevented");
				if (ConsoleUtil.isContentsChanged()) {
					VeamUtil.log("debug", "isContentsChanged");
					ConsoleUtil.setContentsChanged(false);
					if (VeamUtil.isConnected(this)) {
						VeamUtil.log("debug", "satart update");
						showUpdateProgress();
						Intent intent = new Intent(this, UpdateService.class);
						this.startService(intent);
					}
				}
			}

			if(floatingMenuView != null) {
				int tutorialIndex = this.getVeamItTutorialIndex() ;
				if (tutorialIndex == 0) {
					VeamUtil.log("debug", "tutorialIndex is 0");
					showVeamItTutorial(0);
				} else if (tutorialIndex == 1) {
					showVeamItTutorial(1);
				}
			}
		}
	}


	private static final String VEAMIT_TUTORIAL_INDEX = "VEAMIT_TUTORIAL_INDEX" ;
	private int getVeamItTutorialIndex(){
		String tutorialIndex = VeamUtil.getPreferenceString(this, VEAMIT_TUTORIAL_INDEX);
		return VeamUtil.parseInt(tutorialIndex) ;
	}

	private void setVeamItTutorialIndex(int tutorialIndex){
		VeamUtil.setPreferenceString(this, VEAMIT_TUTORIAL_INDEX, String.format("%d",tutorialIndex));
		return ;
	}

	private void showUpdateProgress(){
		FrameLayout rootLayout = (FrameLayout) findViewById(android.R.id.content);
		if (rootLayout != null) {
			if (updateProgress == null) {
				updateProgress = new ProgressBar(this);
				updateProgress.setIndeterminate(true);
				updateProgress.setVisibility(View.GONE);
				int progressSize = deviceWidth * 10 / 100;
				FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(progressSize, progressSize);
				layoutParams.setMargins((deviceWidth - progressSize)/2, (deviceHeight - progressSize) / 2, 0, 0);
				rootLayout.addView(updateProgress, layoutParams);
			}
			updateProgress.setVisibility(View.VISIBLE);
		}
	}

	private void hideUpdateProgress(){
		if (updateProgress != null) {
			updateProgress.setVisibility(View.GONE);
		}
	}


	private Typeface getTypefaceRobotoLight() {
		if(typefaceRobotoLight == null) {
			typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");
		}
		return typefaceRobotoLight ;
	}


	protected int getFloatingMenuKind(){
		return FLOATING_MENU_KIND_NONE ;
	}

	protected int getCurrentFloatingMenuPosition(){
		return 0 ;
	}

	protected void createFloatingMenu(RelativeLayout rootLayout){
		VeamUtil.log("debug", "createFloatingMenu") ;
		if(VeamUtil.isPreviewMode()) {
			if (rootLayout != null) {
				VeamUtil.log("debug", "rootLayout != null");
				String[] elements;
				int kind = this.getFloatingMenuKind();
				if (kind != FLOATING_MENU_KIND_NONE) {
					if (kind == FLOATING_MENU_KIND_EDIT_AND_TUTORIAL) {
						String[] workElements = {"Preview", "Edit Mode", "Tutorial"};
						elements = workElements;
					} else {
						String[] workElements = {"Preview", "Edit Mode"};
						elements = workElements;
					}

					int length = elements.length;
					int elementWidth = deviceWidth * 20 / 100;
					int elementHeight = deviceWidth * 7 / 100;
					int sideMargin = deviceWidth * 4 / 100;
					int floatingMenuWidth = elementWidth * length + sideMargin * 2;

					floatingMenuView = new RelativeLayout(this);
					//floatingMenuView.setBackgroundColor(VeamUtil.getColorFromArgbString("FFDDDDDD"));
					floatingMenuView.setBackgroundDrawable(getResources().getDrawable(R.drawable.floating_menu_background));
					for (int index = 0; index < length; index++) {
						TextView textView = new TextView(this);
						switch (index) {
							case 0:
								textView.setId(VIEWID_FLOATING_TEXT1);
								break;
							case 1:
								textView.setId(VIEWID_FLOATING_TEXT2);
								break;
							case 2:
								textView.setId(VIEWID_FLOATING_TEXT3);
								break;
						}
						textView.setText(elements[index]);
						textView.setTextSize((float) deviceWidth * 3.5f / 100 / scaledDensity);
						textView.setTextColor(Color.WHITE);
						if (index == getCurrentFloatingMenuPosition()) {
							textView.setBackgroundColor(VeamUtil.getLinkTextColor(this));
						} else {
							textView.setBackgroundColor(Color.TRANSPARENT);
						}
						textView.setGravity(Gravity.CENTER);
						textView.setOnClickListener(this);
						int x = sideMargin + index * elementWidth;
						floatingMenuView.addView(textView, ConsoleUtil.getRelativeLayoutPrams(x, 0, elementWidth, elementHeight));
					}
					rootLayout.addView(floatingMenuView, ConsoleUtil.getRelativeLayoutPrams((deviceWidth - floatingMenuWidth) / 2, deviceHeight * 80 / 100, floatingMenuWidth, elementHeight));
				}
			}
		}
	}

	protected void setSwipeView(View view){
		if(VeamUtil.isPreviewMode()){
			VeamUtil.log("debug", "setOnTouchListener");
			view.setOnTouchListener(new OnSwipeTouchListener(VeamActivity.this) {
				public void onSwipeTop() {
					//Toast.makeText(VideosActivity.this, "top", Toast.LENGTH_SHORT).show();
				}

				public void onSwipeRight() {
					//Toast.makeText(VideosActivity.this, "right", Toast.LENGTH_SHORT).show();
				}

				public void onSwipeLeft() {
					//Toast.makeText(VideosActivity.this, "left", Toast.LENGTH_SHORT).show();
					if (floatingMenuView != null) {
						if (floatingMenuView.getVisibility() == View.VISIBLE) {
							startEditModeActivity();
							overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
						}
					}
				}

				public void onSwipeBottom() {
					//Toast.makeText(VideosActivity.this, "bottom", Toast.LENGTH_SHORT).show();
				}

			});
		}
	}

	protected void showFloatingMenu(){
		VeamUtil.log("debug","showFloatingMenu") ;
		if(floatingMenuView != null){
			VeamUtil.log("debug","floatingMenuView != null") ;
			floatingMenuView.setVisibility(View.VISIBLE);
		}
	}

	private RelativeLayout veamitTutorialBaseView ;
	protected void showVeamItTutorial(int tutorialIndex){
		VeamUtil.log("debug","showVeamItTutorial "+tutorialIndex) ;
		String[] titles = {
				getString(R.string.initial_tutorial_title_1),
				getString(R.string.initial_tutorial_title_2),
				getString(R.string.initial_tutorial_title_3)
		} ;
		String[] descriptions = {
				getString(R.string.initial_tutorial_sub_title_1),
				getString(R.string.initial_tutorial_sub_title_2),
				getString(R.string.initial_tutorial_sub_title_3)
		} ;
		String[] nexts = {
				getString(R.string.initial_tutorial_button_1),
				getString(R.string.initial_tutorial_button_2),
				getString(R.string.initial_tutorial_button_3)
		} ;

		String title = "" ;
		if(tutorialIndex < titles.length){
			title = titles[tutorialIndex] ;
		}

		String description = "" ;
		if(tutorialIndex < descriptions.length){
			description = descriptions[tutorialIndex] ;
		}

		String next = "" ;
		if(tutorialIndex < nexts.length){
			next = nexts[tutorialIndex] ;
		}

		int tutorialWidth = deviceWidth * 90 / 100 ;
		int tutorialHeight = deviceHeight * 30 / 100 ;
		FrameLayout rootLayout = (FrameLayout) findViewById(android.R.id.content);
		if (rootLayout != null) {
			VeamUtil.log("debug","rootLayout != null ") ;
			if (veamitTutorialBaseView != null) {
				rootLayout.removeView(veamitTutorialBaseView);
				veamitTutorialBaseView = null;
			}
			veamitTutorialBaseView = new RelativeLayout(this);
			veamitTutorialBaseView.setOnClickListener(this);
			veamitTutorialBaseView.setBackgroundColor(VeamUtil.getColorFromArgbString("77000000"));

			FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(deviceWidth, deviceHeight);
			layoutParams.setMargins(0,0,0,0);
			rootLayout.addView(veamitTutorialBaseView, layoutParams);

			RelativeLayout baseView = new RelativeLayout(this) ;
			baseView.setBackgroundColor(Color.WHITE);
			baseView.setBackgroundDrawable(getResources().getDrawable(R.drawable.preview_login_background));
			veamitTutorialBaseView.addView(baseView, ConsoleUtil.getRelativeLayoutPrams((deviceWidth - tutorialWidth) / 2, (deviceHeight - tutorialHeight) / 2,tutorialWidth,tutorialHeight)) ;


			// tutorial_icon 62x54  y=11%,h=5%
			int iconImageWidth = deviceWidth * 10 / 100  ;
			int iconImageHeight = iconImageWidth * 54 / 62 ;

			int currentY = tutorialHeight*11/100 ;
			ImageView iconImageView = new ImageView(this) ;
			iconImageView.setImageResource(R.drawable.tutorial_icon);
			iconImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
			baseView.addView(iconImageView, ConsoleUtil.getRelativeLayoutPrams((tutorialWidth - iconImageWidth) / 2, currentY, iconImageWidth, iconImageHeight));
			currentY += iconImageHeight ;

			int numberOfElements = 3 ;
			currentY += tutorialHeight * 3 / 100 ;
			ImageView[] dotImageViews = new ImageView[numberOfElements] ;
			int imageSize = deviceWidth * 1 / 100 ;
			int imageGap = deviceWidth * 1 / 100 ;
			if(numberOfElements > 1){
				int currentX = (tutorialWidth / 2) - ((numberOfElements - 1) * (imageSize + imageGap) / 2) ;
				for(int index = 0 ; index < numberOfElements ; index++){
					//NSLog(@"dot x=%f",currentX) ;
					dotImageViews[index] = new ImageView(this) ;
					if(index == tutorialIndex){
						dotImageViews[index].setImageResource(VeamUtil.getDrawableId(this, "c_top_dot_on"));
					} else {
						dotImageViews[index].setImageResource(VeamUtil.getDrawableId(this, "c_top_dot_off"));
					}
					baseView.addView(dotImageViews[index],ConsoleUtil.getRelativeLayoutPrams(currentX,currentY,imageSize,imageSize));
					currentX += imageSize + imageGap ;
				}
			}

			currentY += imageSize ;
			currentY += tutorialHeight * 5 / 100 ;


			int labelHeight = tutorialHeight * 16 / 100 ;
			TextView titleLabel = new TextView(this) ;///
			titleLabel.setTextColor(Color.BLACK) ;
			//titleLabel.setBackgroundColor(Color.BLUE);
			titleLabel.setText(title);
			titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
			titleLabel.setTextSize((float) deviceHeight * 3.5f / 100 / scaledDensity);
			titleLabel.setGravity(Gravity.CENTER);
			ConsoleUtil.setTextSizeWithin(tutorialWidth * 90 / 100, titleLabel);
			baseView.addView(titleLabel, ConsoleUtil.getRelativeLayoutPrams(0, currentY, tutorialWidth, labelHeight));
			currentY += labelHeight ;

			TextView descriptionLabel = new TextView(this) ;///
			descriptionLabel.setTextColor(Color.BLACK) ;
			//descriptionLabel.setBackgroundColor(Color.GREEN);
			descriptionLabel.setText(description);
			descriptionLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
			descriptionLabel.setTextSize((float) deviceWidth * 3.0f / 100 / scaledDensity);
			descriptionLabel.setGravity(Gravity.CENTER);
			baseView.addView(descriptionLabel, ConsoleUtil.getRelativeLayoutPrams(0, currentY, tutorialWidth, labelHeight));
			currentY += labelHeight ;

			currentY += tutorialHeight * 5 / 100 ;
			TextView nextLabel = new TextView(this) ;///
			nextLabel.setId(VIEWID_INITIAL_TUTORIAL_NEXT);
			nextLabel.setOnClickListener(this);
			nextLabel.setTextColor(Color.RED) ;
			//descriptionLabel.setBackgroundColor(Color.GREEN);
			nextLabel.setText(next);
			nextLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
			nextLabel.setTextSize((float) deviceWidth * 5.0f / 100 / scaledDensity);
			nextLabel.setGravity(Gravity.CENTER);
			baseView.addView(nextLabel, ConsoleUtil.getRelativeLayoutPrams(0, currentY, tutorialWidth, labelHeight));
			currentY += labelHeight ;


		}
	}

	protected void hideVeamItTutorial(){
		FrameLayout rootLayout = (FrameLayout) findViewById(android.R.id.content);
		if (rootLayout != null) {
			if (veamitTutorialBaseView != null) {
				rootLayout.removeView(veamitTutorialBaseView);
				veamitTutorialBaseView = null;
			}
		}
	}


	protected void hideFloatingMenu(){
		if(floatingMenuView != null){
			floatingMenuView.setVisibility(View.GONE);
		}
	}

	protected boolean startEditModeActivity(){
		VeamUtil.log("debug","VeamActivity::startEditModeActivity") ;
		boolean consume = false ;
		if (	ConsoleUtil.getAppStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_MCN_REVIEW) ||
				ConsoleUtil.getAppStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_BUILDING) ||
				ConsoleUtil.getAppStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_APPLE_REVIEW)) {

			VeamUtil.showMessage(this,"You can't change.\nNow submitting this app.");
			consume = true ;
		}
		return consume ;
	}

	protected void startTutorialActivity(){
		VeamUtil.log("debug","VeamActivity::startTutorialActivity") ;
	}

	public void finishVertical(){
		this.finish() ;
		overridePendingTransition(R.anim.fadein, R.anim.push_down_out);
	}

	public void finishHorizontal(){
		this.finish() ;
		overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
	}






	public void showFullscreenProgress() {
		VeamUtil.log("debug", "VeamActivity::showFullscreenProgress ") ;
		handler.post(new Runnable() {
			public void run() {
				setFullscreenProgress(true);
			}
		});
	}

	public void hideFullscreenProgress() {
		VeamUtil.log("debug", "VeamActivity::hideFullscreenProgress ") ;
		handler.post(new Runnable() {
			public void run() {
				setFullscreenProgress(false);
			}
		});
	}

	public void setFullscreenProgress(boolean show) {
		VeamUtil.log("debug", "VeamActivity::setFullscreenProgress " + show) ;

		FrameLayout rootLayout = (FrameLayout) findViewById(android.R.id.content);
		if (rootLayout != null) {
			if (show) {
				if (progressBaseView != null) {
					rootLayout.removeView(progressBaseView);
					progressBaseView = null;
				}
				progressBaseView = new RelativeLayout(this);
				progressBaseView.setBackgroundColor(VeamUtil.getColorFromArgbString("77000000"));

				int progressSize = deviceWidth * 10 / 100 ;
				ProgressBar progressBar = new ProgressBar(this) ;
				progressBar.setIndeterminate(true) ;
				progressBaseView.addView(progressBar, ConsoleUtil.getRelativeLayoutPrams((deviceWidth - progressSize) / 2, (deviceHeight - progressSize) / 2, progressSize, progressSize)) ;


				FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(deviceWidth, deviceHeight);
				layoutParams.setMargins(0,0,0,0);
				rootLayout.addView(progressBaseView,layoutParams);
			} else {
				if (progressBaseView != null) {
					rootLayout.removeView(progressBaseView);
					progressBaseView = null;
				}
			}
		}
	}



	protected void backToPreviewHomeScreen(){
		if(VeamUtil.isPreviewMode()){
			Intent previewHomeIntent = new Intent(this, PreviewHomeActivity.class);
			startActivity(previewHomeIntent);
		}
	}




}
