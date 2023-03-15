package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.facebook.Session;


public class SettingsActivity extends VeamActivity implements OnClickListener {
	
	private RelativeLayout rootLayout ;
	private RelativeLayout mainView ;
	private RelativeLayout aboutView ;
	private int currentView ;
	private int previousView ;
	private LinearLayout accountView ;
	
	private TextView accountRightTextView ;
	private TextView accountLeftTextView ;
	private RelativeLayout accountBottomBar ;
	
	private static int VIEWID_FACEBOOK			 		= 0x10001 ;
	private static int VIEWID_TWITTER			 		= 0x10002 ;
	//private static int VIEWID_RESTORE					= 0x10003 ;
	private static int VIEWID_USER_GUIDE				= 0x10004 ;
	private static int VIEWID_TERMS_OF_SERVICE			= 0x10005 ;
	private static int VIEWID_ABOUT_THIS_APP			= 0x10006 ;
	private static int VIEWID_BAR_TITLE					= 0x10007 ;
	private static int VIEWID_DONE_BUTTON				= 0x10008 ;
	private static int VIEWID_ABOUT_IMAGE 				= 0x10009 ;
    private static int VIEWID_ABOUT_SCREEN              	= 0x1000A ;
	
	private static int VIEW_MAIN				 		= 1 ;
	//private static int VIEW_YOUTUBE_SUB_CATEGORY_LIST	= 2 ;
	//private static int VIEW_YOUTUBE_LIST 				= 3 ;
	//private static int VIEW_YOUTUBE_DETAIL 				= 4 ;
	private static int VIEW_WEB		 					= 5 ;
	private static int VIEW_ABOUT	 					= 6 ;
	
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_settings);
		
		this.pageName = "Settings" ;
		
		RelativeLayout.LayoutParams relativeLayoutParams ;
		
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		
		Typeface typeface = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

		
		this.addBaseBackground(rootLayout) ;
		mainView = this.addMainView(rootLayout,View.VISIBLE) ;
		
		ScrollView scrollView = new ScrollView(this) ;
		scrollView.setVerticalScrollBarEnabled(false) ;
		mainView.addView(scrollView) ;
		LinearLayout contentView = new LinearLayout(this) ;
		scrollView.addView(contentView) ;
		contentView.setOrientation(LinearLayout.VERTICAL) ;
		int padding = 0 ;
		contentView.setPadding(padding,padding,padding,padding) ;

		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth,topBarHeight) ; 
		
		View spacerView = new View(this) ;
		contentView.addView(spacerView, linearLayoutParams) ;
		
		this.addOneTitle(contentView,this.getString(R.string.account_login)) ;
		
		accountView = new LinearLayout(this) ;
		accountView.setOrientation(LinearLayout.VERTICAL) ;
		contentView.addView(accountView) ;
		
		RelativeLayout relativeLayout = this.addOneBar(accountView,"Facebook",VIEWID_FACEBOOK) ;
		accountRightTextView = new TextView(this) ;
		accountRightTextView.setText(this.getString(R.string.login)) ;
		accountRightTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.RIGHT) ;
		accountRightTextView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
		accountRightTextView.setTypeface(typeface) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*58/100,deviceWidth*14/100) ;
		relativeLayoutParams.setMargins(deviceWidth*34/100, 0, 0, 0) ;
		relativeLayout.addView(accountRightTextView, relativeLayoutParams) ;
		accountLeftTextView = (TextView)relativeLayout.findViewById(VIEWID_BAR_TITLE) ;

		this.addAccountBottomBar() ;
		
		/*
		this.addOneTitle(contentView,this.getString(R.string.storage_settings)) ;
		this.addOneBar(contentView,this.getString(R.string.restore),VIEWID_RESTORE) ;
		*/
		
		this.addOneTitle(contentView,this.getString(R.string.help)) ;
		this.addOneBar(contentView,this.getString(R.string.user_guide),VIEWID_USER_GUIDE) ;
		this.addOneBar(contentView,this.getString(R.string.terms_of_service),VIEWID_TERMS_OF_SERVICE) ;
		this.addOneBar(contentView,this.getString(R.string.about_this_app),VIEWID_ABOUT_THIS_APP) ;

		this.addTopBar(mainView, this.getString(R.string.settings),false,false) ;
		this.addDoneButton(mainView) ;
		
		this.updateView() ;
		
		currentView = VIEW_MAIN ;
	}
	
	public void addDoneButton(RelativeLayout view){

		int iconSize = 0 ;
		if(VeamUtil.isPreviewMode()) {
			if (!isPreventSignoutButton) {
				iconSize = deviceWidth * 10 / 100;
			}
		}
		int doneX = deviceWidth*84/100 - iconSize ;

		TextView textView = new TextView(this) ;
		textView.setOnClickListener(this) ;
		textView.setId(VIEWID_DONE_BUTTON) ;
		textView.setText(this.getString(R.string.done)) ;
		textView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*16/100,topBarHeight) ;
		relativeLayoutParams.setMargins(doneX, 0, 0, 0) ;
		view.addView(textView, relativeLayoutParams) ;
	}
	
	public RelativeLayout addOneTitle(LinearLayout contentView,String title){
		int barHeight = deviceWidth*12/100 ;
		RelativeLayout relativeLayout = new RelativeLayout(this) ;
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth,barHeight) ;
		contentView.addView(relativeLayout,linearLayoutParams) ;

		Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

		TextView textView = new TextView(this) ;
		textView.setId(VIEWID_BAR_TITLE) ;
		textView.setText(title) ;
		textView.setGravity(Gravity.BOTTOM) ;
		textView.setPadding(0, 0, 0, deviceWidth*2/100) ;
		textView.setTextSize((float)deviceWidth * 4.2f / 100 / scaledDensity) ;
		textView.setTypeface(typefaceRobotoLight) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*96/100,barHeight) ;
		relativeLayoutParams.setMargins(deviceWidth*3/100, 0, 0, 0) ;
		relativeLayout.addView(textView, relativeLayoutParams) ;
		
		View lineView = new View(this) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,1) ;
		relativeLayoutParams.setMargins(0,barHeight-1,0, 0) ;
		relativeLayout.addView(lineView,relativeLayoutParams) ;
		
		return relativeLayout ;
	}
	
	public RelativeLayout addOneBar(LinearLayout contentView,String title,int viewId){
		RelativeLayout relativeLayout = new RelativeLayout(this) ;
		relativeLayout.setId(viewId) ;
		relativeLayout.setOnClickListener(this) ;
		relativeLayout.setBackgroundColor(Color.argb(0x77,0xff,0xff,0xff));
		relativeLayout.setPadding(0, 0, 0, 0) ;
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth,deviceWidth*14/100) ;
		contentView.addView(relativeLayout,linearLayoutParams) ;
		
		Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");
		
		TextView textView = new TextView(this) ;
		textView.setText(title) ;
		textView.setId(VIEWID_BAR_TITLE) ;
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setTextSize((float)deviceWidth * 5.4f / 100 / scaledDensity) ;
		textView.setTypeface(typefaceRobotoLight) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*96/100,deviceWidth*14/100) ;
		relativeLayoutParams.setMargins(deviceWidth*3/100, 0, 0, 0) ;
		relativeLayout.addView(textView, relativeLayoutParams) ;
		
		View lineView = new View(this) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,1) ;
		relativeLayoutParams.setMargins(0,deviceWidth*14/100-1,0, 0) ;
		relativeLayout.addView(lineView,relativeLayoutParams) ;
		
		ImageView imageView ;
		imageView = new ImageView(this) ;
		imageView.setImageResource(R.drawable.setting_arrow) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*3/100,deviceWidth*5/100) ;
		relativeLayoutParams.setMargins(this.deviceWidth*94/100,this.deviceWidth*5/100, 0, 0) ;
		relativeLayout.addView(imageView,relativeLayoutParams) ;

		return relativeLayout ;
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if(requestCode == REQUEST_CODE_TWITTER_AUTH){
			this.updateView() ;
		} else {
			Session session = Session.getActiveSession() ;
			if(session != null){
				session.onActivityResult(this, requestCode, resultCode, data);
			}
		}
	}
	
	
	

	public void logout(){
		VeamUtil.logoutSocial(this) ;
		this.updateView() ;
		this.sendRegistration() ;
	}
	
	public void sendRegistration(){
		String socialUserId = VeamUtil.getSocialUserId(this) ;

		//String regId = GCMRegistrar.getRegistrationId(this);
		//VeamUtil.log("debug", "sendRegistration regId="+regId + " socialUserId="+socialUserId);
        GCMRegisterTask sendRegistrationTask = new GCMRegisterTask(this,socialUserId) ;
        sendRegistrationTask.execute("") ;
	}
	
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","SettingsActivity::onClick") ;
		if(view.getId() == this.VIEWID_TOP_BAR_BACK_BUTTON){
			if(currentView == VIEW_WEB){
				if(previousView == VIEW_ABOUT){
					this.doTranslateAnimation(aboutView, 300, -deviceWidth, 0, 0, 0, null, null) ;
					this.doTranslateAnimation(webView, 300, 0, deviceWidth, 0, 0, "removeWeb", null) ;
					currentView = VIEW_ABOUT ;
					this.trackPageView("About") ;					
				} else {
					this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, null, null) ;
					this.doTranslateAnimation(webView, 300, 0, deviceWidth, 0, 0, "removeWeb", null) ;
					currentView = VIEW_MAIN ;
				}
			} else if(currentView == VIEW_ABOUT){
				this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, null, null) ;
				this.doTranslateAnimation(aboutView, 300, 0, deviceWidth, 0, 0, "removeAbout", null) ;
				currentView = VIEW_MAIN ;
			}

		} else if(view.getId() == VIEWID_FACEBOOK){
			//VeamUtil.log("debug","VIEWID_FACEBOOK") ;
			if(VeamUtil.isLogin(this)){
				//VeamUtil.log("debug","already logged in") ;
				AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		        // アラートダイアログのタイトルを設定します
		        alertDialogBuilder.setTitle(this.getString(R.string.warning));
		        // アラートダイアログのメッセージを設定します
		        alertDialogBuilder.setMessage(this.getString(R.string.logout_warning));
		        // アラートダイアログの肯定ボタンがクリックされた時に呼び出されるコールバックリスナーを登録します
		        alertDialogBuilder.setPositiveButton(this.getString(R.string.logout),
		                new DialogInterface.OnClickListener() {
		                    @Override
		                    public void onClick(DialogInterface dialog, int which) {
		                    	logout() ;
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
				
			} else {
				//VeamUtil.log("debug","not logged in") ;

				this.facebookLogin() ;
			}
		} else if(view.getId() == VIEWID_TWITTER){
			// login
			Intent twitterAuthlIntent = new Intent(this,TwitterAuthActivity.class) ;
			startActivityForResult(twitterAuthlIntent,REQUEST_CODE_TWITTER_AUTH) ;
			this.overridePendingTransition(R.anim.push_left_in,R.anim.push_left_out) ;
		} else if(view.getId() == VIEWID_USER_GUIDE){
            String url = String.format("http://veam.co/top/userguideforapp/?a=%s",VeamUtil.getAppId()) ;
			this.createWebView(rootLayout, url,this.getString(R.string.user_guide), false,false,false) ;
			this.addDoneButton(webView) ;
			this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(webView, 300, deviceWidth, 0, 0, 0, null, null) ;
			previousView = currentView ;
			currentView = VIEW_WEB;
			this.trackPageView(String.format("WebView/%s",url)) ;
		} else if(view.getId() == VIEWID_TERMS_OF_SERVICE){
            String url = String.format("http://veam.co/top/termsofserviceforapp/?a=%s&os=a",VeamUtil.getAppId()) ;
			this.createWebView(rootLayout, url, this.getString(R.string.terms_of_service), false,false,false) ;
			this.addDoneButton(webView) ;
			this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(webView, 300, deviceWidth, 0, 0, 0, null, null) ;
			previousView = currentView ;
			currentView = VIEW_WEB;
			this.trackPageView(String.format("WebView/%s",url)) ;
		} else if(view.getId() == VIEWID_ABOUT_THIS_APP){
			this.createAboutView(rootLayout) ;
			this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(aboutView, 300, deviceWidth, 0, 0, 0, null, null) ;
			currentView = VIEW_ABOUT;
			this.trackPageView("About") ;			
		} else if(view.getId() == VIEWID_ABOUT_SCREEN){
			//VeamUtil.log("debug","about screen tapped") ;
            String url = String.format("http://help.veam.co/contact/app.php/inquiry?m=%s&a=%s",VeamUtil.getMcnId(this),VeamUtil.getAppId()) ;
			this.createWebView(rootLayout, url, "Veam", false,false,false) ;
			this.addDoneButton(webView) ;
			this.doTranslateAnimation(aboutView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(webView, 300, deviceWidth, 0, 0, 0, null, null) ;
			previousView = currentView ;
			currentView = VIEW_WEB;
			this.trackPageView(String.format("WebView/%s","http://veam.co/")) ;
		} else if(view.getId() == VIEWID_DONE_BUTTON){
			this.finish() ;
			overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
		}
	}
	
		
	@Override
	public void onDestroy() {
	    super.onDestroy();
	}
	
	public void addAccountBottomBar(){
		Typeface typeface = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");
		
		accountBottomBar = this.addOneBar(accountView,"Twitter",VIEWID_TWITTER) ;
		TextView textView = new TextView(this) ;
		textView.setText(this.getString(R.string.login)) ;
		textView.setGravity(Gravity.CENTER_VERTICAL|Gravity.RIGHT) ;
		textView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*58/100,deviceWidth*14/100) ;
		relativeLayoutParams.setMargins(deviceWidth*34/100, 0, 0, 0) ;
		accountBottomBar.addView(textView, relativeLayoutParams) ;
	}

	public void updateView(){
		if(VeamUtil.isLogin(this)){
			String kind = VeamUtil.getPreferenceString(this, VeamUtil.SOCIAL_USER_KIND) ;
			if(!VeamUtil.isEmpty(kind)){
				if(accountLeftTextView != null){
					if(kind.equals(VeamUtil.SOCIAL_USER_KIND_FACEBOOK)){
						accountLeftTextView.setText("Facebook") ;
					} else if(kind.equals(VeamUtil.SOCIAL_USER_KIND_TWITTER)){
						accountLeftTextView.setText("Twitter") ;
					}
				}
				accountRightTextView.setText(VeamUtil.getSocialUserName(this)) ;
				if(accountBottomBar != null){
					accountBottomBar.removeAllViews() ;
					accountView.removeView(accountBottomBar) ;
					accountBottomBar = null ;
				}
			}
		} else {
			if(accountBottomBar == null){
				accountLeftTextView.setText("Facebook") ;
				accountRightTextView.setText(this.getString(R.string.login)) ;
				this.addAccountBottomBar() ;
			}
		}
	}

	public void onLoginFinished(Integer resultCode) {
		//VeamUtil.log("debug","SettingsActivity::onLoginFinished") ;
		this.updateView() ;
	}

	public void removeWeb(){
		if(webView != null){
			webView.removeAllViews() ;
			this.rootLayout.removeView(webView) ;
			webView = null ;

			webPageView.stopLoading();
			webPageView.setWebViewClient(null);
			webPageView.setWebChromeClient(null);
			webPageView.destroy();
			webPageView = null; 
		}
	}
	
	public void removeAbout(){
		if(aboutView != null){
			aboutView.removeAllViews() ;
			this.rootLayout.removeView(aboutView) ;
			aboutView = null ;
		}
	}
	
	public void createAboutView(RelativeLayout rootLayout){
		aboutView = this.addMainView(rootLayout,View.VISIBLE) ;

        Typeface typeface = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

        View backView = new View(this) ;
        backView.setBackgroundColor(Color.TRANSPARENT);
        backView.setId(VIEWID_ABOUT_SCREEN) ;
        backView.setOnClickListener(this);
        RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, deviceHeight) ;
        layoutParams.setMargins(0,0, 0, 0) ;
        aboutView.addView(backView,layoutParams) ;

        int graySize = deviceWidth * 55 / 100 ;
        if(graySize * 2 > deviceHeight){
            graySize = deviceHeight / 2 ;
        }

        int iconSize = graySize * 90 / 100 ;
        int logoWidth = graySize * 50 / 100 ; // 200x150
        int logoHeight = logoWidth * 150 / 200 ;


        int imageBottom = deviceWidth * 4 / 100 ;
        int titleSize = deviceWidth * 5 / 100 ;
        int titleBottom = deviceWidth * 6 / 100 ;
        int logoSize = logoHeight ;
        int logoBottom = deviceWidth * 5 / 100 ;
        int copyrightSize = deviceWidth * 4 / 100 ;

        int contentSize = graySize + imageBottom + titleSize + 2 + titleBottom + logoSize + logoBottom + copyrightSize + 2 ;

        int currentY = (deviceHeight - contentSize) / 2 ;
		//VeamUtil.log("debug","TopBarHeight="+topBarHeight) ;

        View imageBackView = new View(this) ;
        imageBackView.setBackgroundColor(VeamUtil.getColorFromArgbString("1A000000"));
        layoutParams = createParam(graySize, graySize) ;
        layoutParams.setMargins((deviceWidth-graySize)/2,currentY, 0, 0) ;
        aboutView.addView(imageBackView,layoutParams) ;

        ImageView imageView = new ImageView(this) ;
        imageView.setImageBitmap(VeamUtil.getThemeImage(this,"c_veam_icon",1)) ;
        layoutParams = createParam(iconSize, iconSize) ;
        layoutParams.setMargins((deviceWidth-iconSize)/2,currentY + (graySize - iconSize)/2, 0, 0) ;
        aboutView.addView(imageView,layoutParams) ;

        currentY += graySize + imageBottom ;

        TextView appNameTextView = new TextView(this) ;
        appNameTextView.setTextColor(VeamUtil.getColorFromArgbString("FF4C4C4C"));
        appNameTextView.setText(VeamUtil.getAppName(this)) ;
        appNameTextView.setGravity(Gravity.CENTER) ;
        appNameTextView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
        appNameTextView.setTypeface(typeface) ;
        layoutParams = createParam(deviceWidth, titleSize) ;
        layoutParams.setMargins(0, currentY, 0, 0) ;
        aboutView.addView(appNameTextView,layoutParams) ;

        currentY += titleSize + titleBottom ;

        ImageView logoImageView = new ImageView(this) ;
        logoImageView.setImageBitmap(VeamUtil.getThemeImage(this,"mcn_logo",1)) ;
        layoutParams = createParam(logoWidth, logoHeight) ;
        layoutParams.setMargins((deviceWidth-logoWidth)/2,currentY, 0, 0) ;
        aboutView.addView(logoImageView,layoutParams) ;

        currentY += logoSize + logoBottom ;

        TextView copyrightTextView = new TextView(this) ;
        copyrightTextView.setTextColor(VeamUtil.getColorFromArgbString("FF4C4C4C"));
        copyrightTextView.setText(String.format("©2017 %s, Veam™.",VeamUtil.getAppName(this))) ;
        copyrightTextView.setGravity(Gravity.CENTER) ;
        copyrightTextView.setTextSize((float)deviceWidth * 3.0f / 100 / scaledDensity) ;
        copyrightTextView.setTypeface(typeface) ;
        layoutParams = createParam(deviceWidth, copyrightSize) ;
        layoutParams.setMargins(0, currentY, 0, 0) ;
        aboutView.addView(copyrightTextView,layoutParams) ;


/*


        UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], copyrightSize+2)] ;
        [copyrightLabel setText:[NSString stringWithFormat:@"ﾂｩ2015 %@, Veam邃｢.",[VeamUtil getAppName])) ;
        [copyrightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:copyrightSize)) ;
        [copyrightLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF4C4C4C")) ;
        [copyrightLabel setTextAlignment:NSTextAlignmentCenter] ;
        [self.view addSubview:copyrightLabel] ;

*/





        this.addTopBar(aboutView, this.getString(R.string.about_this_app),true,false) ;
		this.addDoneButton(aboutView) ;

        /*
		int imageHeight = (viewHeight - topBarHeight) * 90 / 100 ;
		int imageWidth = imageHeight * 200 / 358 ;
		ImageView imageView = new ImageView(this) ;
		imageView.setId(VIEWID_ABOUT_IMAGE) ;
		imageView.setOnClickListener(this) ; 
		imageView.setImageResource(R.drawable.about) ;
		imageView.setScaleType(ScaleType.FIT_XY) ;
		RelativeLayout.LayoutParams layoutParams = createParam(imageWidth, imageHeight) ;
		layoutParams.setMargins((deviceWidth-imageWidth)/2, topBarHeight + (viewHeight-topBarHeight-imageHeight)/2, 0, 0) ;
		aboutView.addView(imageView,layoutParams) ;
			*/

	}
	

}
