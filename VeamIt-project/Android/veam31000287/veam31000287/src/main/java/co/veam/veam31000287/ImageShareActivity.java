package co.veam.veam31000287;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.Request;
import com.facebook.Response;
import com.facebook.Session;
import com.facebook.Session.StatusCallback;
import com.facebook.SessionState;
import com.facebook.model.GraphUser;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;

public class ImageShareActivity extends VeamActivity implements StatusCallback {
	// カメラインスタンス
    private RelativeLayout mainView ;
	private RelativeLayout rootLayout ;
	private ImageView pictureImageView ;
	private Bitmap pictureBitmap = null ;
	private String forumId ;
	private EditText commentEditText ;
	private ImageView facebookImageView ;
	private ImageView twitterImageView ;
	private ProgressBar postProgressBar ;
	private TextView postTextView ;
	private boolean shouldPostToFacebook = false ;
	private boolean shouldPostToTwitter = false ;
	
	//private String twitterTokenSecret = "" ;
	private String twitterToken = "" ;
	private Session facebookSession ;

	InterstitialAd mInterstitialAd;



	private int VIEWID_POST_BUTTON		= 0x10001 ;
	private int VIEWID_COMMENT_TEXT		= 0x10002 ;
	private int VIEWID_FACEBOOK_BUTTON	= 0x10003 ;
	private int VIEWID_TWITTER_BUTTON	= 0x10004 ;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_image_edit) ;
        
		this.pageName = "ImageShare" ;

		mInterstitialAd = new InterstitialAd(this);
		mInterstitialAd.setAdUnitId(this.getString(R.string.admob_id_postpicture));
		requestNewInterstitial();

		mInterstitialAd.setAdListener(new AdListener() {
			@Override
			public void onAdClosed() {
				finish() ;
			}
		});



		Intent intent = getIntent();
		forumId = intent.getStringExtra("forum_id") ;
		//pictureBitmap = (Bitmap) intent.getParcelableExtra("bitmap") ;
		pictureBitmap = VeamUtil.restoreBitmap(this, "ImageShareActivity") ;
		
		TextView textView ;
		
		RelativeLayout.LayoutParams layoutParams ;
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		
		this.addBaseBackground(rootLayout) ;

		mainView = this.addMainView(rootLayout,View.VISIBLE) ;
		
		int imageSize = deviceWidth*25/100 ;
		int imageMargin = deviceWidth * 4 / 100 ;
		int imageY = topBarHeight + imageMargin ;
		int commentWidth = deviceWidth - imageSize - imageMargin * 2 ;
		int imageBackHeight = imageSize+imageMargin*2 ;

		View imageBackView = new View(this) ;
		imageBackView.setBackgroundColor(Color.argb(0x77, 0xff, 0xff, 0xff)) ;
		layoutParams = createParam(deviceWidth, imageBackHeight) ;
		layoutParams.setMargins(0,topBarHeight,0,0) ;
		mainView.addView(imageBackView,layoutParams) ;
		
		View lineView = new View(this) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		layoutParams = createParam(deviceWidth,1) ;
		layoutParams.setMargins(0,topBarHeight+imageBackHeight,0, 0) ;
		mainView.addView(lineView,layoutParams) ;
		
		
		
        pictureImageView = new ImageView(this) ;
        if(pictureBitmap != null){
        	pictureImageView.setImageBitmap(pictureBitmap) ;
        }
		layoutParams = createParam(imageSize, imageSize) ;
		layoutParams.setMargins(deviceWidth-imageSize-imageMargin,imageY,0,0) ;
		mainView.addView(pictureImageView,layoutParams) ;
		
		Typeface typefaceRobotoLight= Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");
		
		commentEditText = new EditText(this) ;
		commentEditText.setId(VIEWID_COMMENT_TEXT) ;
		commentEditText.setHint(this.getString(R.string.add_a_caption)) ;
		commentEditText.setTextSize((float)deviceWidth * 4.5f / 100 / scaledDensity) ;
		commentEditText.setBackgroundColor(Color.TRANSPARENT) ;
		commentEditText.setGravity(Gravity.TOP) ;
		commentEditText.setTypeface(typefaceRobotoLight) ;
		layoutParams = new RelativeLayout.LayoutParams(commentWidth,imageSize) ;
		layoutParams.setMargins(imageMargin, imageY, 0, 0) ;
		mainView.addView(commentEditText,layoutParams) ;

		try {

			facebookImageView = new ImageView(this) ;
			facebookImageView.setId(VIEWID_FACEBOOK_BUTTON) ;
			facebookImageView.setOnClickListener(this) ;
			facebookImageView.setImageResource(R.drawable.share_facebook_off) ;
			facebookImageView.setScaleType(ScaleType.FIT_XY) ;
			
			twitterImageView = new ImageView(this) ;
			twitterImageView.setId(VIEWID_TWITTER_BUTTON) ;
			twitterImageView.setOnClickListener(this) ;
			twitterImageView.setImageResource(R.drawable.share_twitter_off) ;
			twitterImageView.setScaleType(ScaleType.FIT_XY) ;
			

			int currentY = topBarHeight+imageBackHeight ;
			textView = new TextView(this) ;
			textView.setText(this.getString(R.string.share)) ;
			textView.setTextColor(Color.rgb(0x20, 0x20, 0x20)) ;
			textView.setGravity(Gravity.BOTTOM) ;
			textView.setPadding(deviceWidth*5/100,0, 0, 0 ) ;
			textView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
			textView.setTypeface(typefaceRobotoLight) ;
			layoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceWidth*10/100) ;
			layoutParams.setMargins(0, currentY, 0, 0) ;
			mainView.addView(textView, layoutParams) ;
			
			currentY += deviceWidth*10/100 ;
	
			lineView = new View(this) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			layoutParams = createParam(deviceWidth,1) ;
			layoutParams.setMargins(0,currentY,0, 0) ;
			mainView.addView(lineView,layoutParams) ;
	
			currentY++ ;
			
			int buttonHeight = deviceWidth*15/100 ;
			
			View buttonBackView = new View(this) ;
			buttonBackView.setBackgroundColor(Color.argb(0x77, 0xff, 0xff, 0xff)) ;
			layoutParams = createParam(deviceWidth, buttonHeight) ;
			layoutParams.setMargins(0,currentY,0,0) ;
			mainView.addView(buttonBackView,layoutParams) ;
			
			layoutParams = createParam(deviceWidth/2, buttonHeight) ;
			layoutParams.setMargins(0,currentY,0,0) ;
			mainView.addView(facebookImageView,layoutParams) ;
			
			layoutParams = createParam(deviceWidth/2, buttonHeight) ;
			layoutParams.setMargins(deviceWidth/2,currentY,0,0) ;
			mainView.addView(twitterImageView,layoutParams) ;
	
			lineView = new View(this) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			layoutParams = createParam(1,buttonHeight) ;
			layoutParams.setMargins(deviceWidth/2,currentY,0, 0) ;
			mainView.addView(lineView,layoutParams) ;
	
			currentY += buttonHeight ;
	
			lineView = new View(this) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			layoutParams = createParam(deviceWidth,1) ;
			layoutParams.setMargins(0,currentY,0, 0) ;
			mainView.addView(lineView,layoutParams) ;
			
		} catch (OutOfMemoryError e) {
			//VeamUtil.log("debug","OutOfMemory") ;
		}
		
		this.addTopBar(mainView,this.getString(R.string.share),true,false) ;
		
		postTextView = new TextView(this) ;
		postTextView.setOnClickListener(this) ;
		postTextView.setId(VIEWID_POST_BUTTON) ;
		postTextView.setText(this.getString(R.string.post)) ;
		postTextView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
		postTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		postTextView.setPadding(0, 0, 0, 0) ;
		postTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*16/100,topBarHeight) ;
		layoutParams.setMargins(deviceWidth*84/100, 0, 0, 0) ;
		mainView.addView(postTextView, layoutParams) ;
		
		postProgressBar = new ProgressBar(this) ;
		postProgressBar.setIndeterminate(true) ;
		postProgressBar.setVisibility(View.GONE) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
		layoutParams.setMargins(deviceWidth * 84 / 100, deviceWidth * 2 / 100, 0, 0) ;
		mainView.addView(postProgressBar,layoutParams) ;
		
		commentEditText.requestFocus() ;
		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);		
    }
    
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","ImageShareActivity::onClick") ;
		if(view.getId() == this.VIEWID_TOP_BAR_BACK_BUTTON){
			//VeamUtil.log("debug","back button tapped") ;
			this.finish() ;
			overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out) ;
		} else 	if(view.getId() == VIEWID_FACEBOOK_BUTTON){
			if(this.shouldPostToFacebook){
				this.setFacebook(false) ;
			} else {
				this.activateFacebookSession(this) ;
			}
		} else 	if(view.getId() == VIEWID_TWITTER_BUTTON){
			if(this.shouldPostToTwitter){
				this.setTwitter(false) ;
			} else {
				//twitterTokenSecret = VeamUtil.getPreferenceString(this, VeamUtil.TWITTER_TOKEN_SECRET) ;
		    	twitterToken = VeamUtil.getPreferenceString(this, VeamUtil.TWITTER_TOKEN) ;
		    	if(VeamUtil.isEmpty(twitterToken)){
		    		Intent twitterAuthlIntent = new Intent(this,TwitterAuthActivity.class) ;
		    		twitterAuthlIntent.putExtra("SKIP_LOGIN", true) ;
		    		startActivityForResult(twitterAuthlIntent,REQUEST_CODE_TWITTER_AUTH) ;
		    		this.overridePendingTransition(R.anim.push_left_in,R.anim.push_left_out) ;
		    	} else {
		    		this.setTwitter(true) ;
		    	}
			}
		} else 	if(view.getId() == VIEWID_POST_BUTTON){
			//VeamUtil.log("debug","post button tapped") ;
			String comment = commentEditText.getText().toString() ;
			if((comment == null) || comment.equals("")){
				VeamUtil.showMessage(this, this.getString(R.string.please_add_a_caption)) ;
			} else {
				postTextView.setVisibility(View.GONE) ;
				postProgressBar.setVisibility(View.VISIBLE) ;
				
				
				PostPictureTask postPictureTask = new PostPictureTask(this,forumId,comment,shouldPostToFacebook,shouldPostToTwitter,facebookSession) ;
				postPictureTask.execute("") ;
			}
		}
	}
	
	public void setFacebook(boolean shouldPost){
		shouldPostToFacebook = shouldPost ;
		if(shouldPost){
			//this.facebookImageView.setImageResource(R.drawable.share_facebook_on) ;
			this.facebookImageView.setImageBitmap(VeamUtil.getThemeImage(this, "share_facebook_on", 1)) ;
		} else {
			this.facebookImageView.setImageResource(R.drawable.share_facebook_off) ;
		}
	}
	
	public void setTwitter(boolean shouldPost){
		shouldPostToTwitter = shouldPost ;
		if(shouldPost){
			//this.twitterImageView.setImageResource(R.drawable.share_twitter_on) ;
			this.twitterImageView.setImageBitmap(VeamUtil.getThemeImage(this, "share_twitter_on", 1)) ;
		} else {
			this.twitterImageView.setImageResource(R.drawable.share_twitter_off) ;
		}
	}
	
	public void onPostPictureFinished(Integer result){
		//VeamUtil.log("debug","onPostPictureFinished") ;
		postTextView.setVisibility(View.VISIBLE) ;
		postProgressBar.setVisibility(View.GONE) ;
		if(result == 1){
    		this.setResult(1) ;
			if (mInterstitialAd.isLoaded()) {
				mInterstitialAd.show();
			} else {
				this.finish() ;
			}
		}
	}

    @Override
    protected void onPause() {
        super.onPause();
    }
    
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if(requestCode == REQUEST_CODE_TWITTER_AUTH){
			//twitterTokenSecret = VeamUtil.getPreferenceString(this, VeamUtil.TWITTER_TOKEN_SECRET) ;
	    	twitterToken = VeamUtil.getPreferenceString(this, VeamUtil.TWITTER_TOKEN) ;
	    	if(!VeamUtil.isEmpty(twitterToken)){
	    		this.setTwitter(true) ;
	    	}
		} else {
			//VeamUtil.log("debug","onActivityResult facebook") ;
			Session session = Session.getActiveSession() ;
			if(session != null){
				//VeamUtil.log("debug","session != null") ;
				session.onActivityResult(this, requestCode, resultCode, data);
				this.setFacebook(true) ;
			}
		}
	}


	@Override
	public void call(Session session, SessionState state, Exception exception) {
		//VeamUtil.log("debug","SessionState:"+state) ;
		if(state == SessionState.CLOSED_LOGIN_FAILED){
			//VeamUtil.log("debug","CLOSED_LOGIN_FAILED") ;
			VeamUtil.showMessage(this, this.getString(R.string.login_failed)) ;
			return ;
		}
		if (session.isOpened()) {
			//VeamUtil.log("debug","isOpened") ;
			// get user info
			facebookSession = session ;
			Request.executeMeRequestAsync(session, new Request.GraphUserCallback() {
				@Override
				public void onCompleted(GraphUser user, Response response) {
					//VeamUtil.log("debug","onCompleted") ;
					if (user != null) {
						//VeamUtil.log("debug","name:" + user.getName() + " id:"+user.getId()) ;
						setFacebook(true) ;
					}
				}
			});
		} else {
			//VeamUtil.log("debug","not opened") ;
		}
	}

	private void requestNewInterstitial() {
		if(VeamUtil.isActiveAdmob) {
			AdRequest adRequest = new AdRequest.Builder()
					.addTestDevice("YOUR_DEVICE_HASH")
					.build();

			mInterstitialAd.loadAd(adRequest);
		}
	}


}