package co.veam.veam31000287;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Typeface;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.media.MediaPlayer.OnVideoSizeChangedListener;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.text.Html;
import android.text.Layout;
import android.text.TextPaint;
import android.util.Log;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TableLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import com.facebook.Session;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

// android.widget.ArrayAdapter



public class VideoPlayActivity extends VeamActivity implements
OnCompletionListener,OnPreparedListener, OnVideoSizeChangedListener,SurfaceHolder.Callback,OnItemClickListener, OnClickListener, OnTouchListener {


	private BackgroundVideoService backgroundVideoService;
	private Intent backgroundVideoServiceIntent ;

	private AMHttpServer m_Server ;
    private int mVideoWidth;
    private int mVideoHeight;
    private MediaPlayer mMediaPlayer;
    private VideoView mPreview;
    private SurfaceHolder holder;
    private boolean mIsVideoSizeKnown = false;
    private boolean mIsVideoReadyToBePlayed = false;

    private int pendingOperation ;
    private static int PENDING_OPERATION_NONE		= 0 ;
    private static int PENDING_OPERATION_COMMENT	= 1 ;
    private static int PENDING_OPERATION_LIKE		= 2 ;

    private AlertDialog mEndDialog ;
    
    private final int ANGLE_1	= 1 ;
    private final int ANGLE_2	= 2 ;
    
    private String fileName = null ;
    private String key = null ;
    private String key2 = null ;

    private String contentId = null ;
    private String contentId2 = null ;
    
    private String titleName ;
    
    private int currentOrientation ;


    boolean isLoading = false ;
    private VideoDataXml currentVideoData ;


    private int currentPosition ;
    
    private RelativeLayout rootLayout ;

    private ScrollView scrollView ;
    
    private final int VIEWID_ZOOM_BUTTON		= 0x10001 ;
    private final int VIEWID_PREV_BUTTON		= 0x10002 ;
    private final int VIEWID_PLAY_BUTTON		= 0x10003 ;
    private final int VIEWID_NEXT_BUTTON		= 0x10004 ;
    private final int VIEWID_SLIDER_POINT		= 0x10005 ;
    //private final int VIEWID_BACK_BUTTON		    = 0x10006 ;
    private final int VIEWID_LAND_PLAY_BUTTON	= 0x10007 ;
    private final int VIEWID_LAND_SLIDER_POINT= 0x10008 ;
    private final int VIEWID_PLAYER				= 0x10009 ;
    public static int VIEWID_LIKE_BUTTON			= 0x1000A ;
    public static int VIEWID_COMMENT_BUTTON		= 0x1000B ;
    public static int VIEWID_FOLD_COMMENT			= 0x1000C ;
    public static int VIEWID_EXPAND_COMMENT		= 0x1000D ;
    public static int VIEWID_SCROLL_VIEW    		= 0x1000E ;


    private boolean isSwitching = false ;
    
    private Timer timer = null ;
    private Handler handler = new Handler();
    
    private TextView annotationTextView ;
    private TextView annotationTextView2 ;
    private TextView titleTextView ;
	private ImageView prevButtonImageView ;
	private ImageView nextButtonImageView ;
	private ImageView playButtonImageView ;
	private ImageView landPlayButtonImageView ;
	//private ImageView backButtonImageView ;
	private LinearLayout controllerLayout ;
	private LinearLayout landControllerLayout ;
	private int sliderPointSize ;
	private int landSliderPointSize ;
	private int currentTime = 0 ;
	private int duration = 0 ;
	
	private int landControllerHeight ;
	private int offsetX = 0 ;
	private int offsetY = 0 ;
	private int landOffsetX = 0 ;
	private int landOffsetY = 0 ;
	private boolean isPointDragging = false ;

	private ImageView sliderPointImageView ;
	private ImageView sliderImageView ;
	private LinearLayout sliderLayout ;
	private RelativeLayout sliderBase ;
    private TextView currentTimeTextView ;
    private TextView durationTextView ;
	
	private ImageView landSliderPointImageView ;
	private ImageView landSliderImageView ;
	private LinearLayout landSliderLayout ;
	private RelativeLayout landSliderBase ;
    private TextView landCurrentTimeTextView ;
    private TextView landDurationTextView ;
	private boolean isLandControllerVisible = false ;

    private RelativeLayout infoView ;
    private RelativeLayout infoBackView ;
    private int infoViewY = 0 ;
    private int infoViewWidth ;
    private int infoViewHeight ;
    int infoIconSize ;
    int infoMargin ;
    int bottomPosition ;
    private int bottomTextViewWidth ;
    private ImageView likeButtonImageView ;
    private ImageView commentButtonImageView ;
    private LinearLayout commentAreaView ;
    private boolean isShowAllComments = false ;



    //private ImageView backgroundImageView ;
	private ImageView zoomButtonImageView ;
	private int zoomButtonSize ;
	private View grayView ;
	//private ImageView miniLogoImageView ;

    public static int REQUEST_POST_COMMENT_ACTIVITY		= 0x0001 ;



    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);

       //VeamUtil.log("debug","VideoPlayActivity.onCreate") ;
		
		RelativeLayout.LayoutParams layoutParams ;

		Resources resources = getResources();
		Configuration config = resources.getConfiguration();
		this.currentOrientation = config.orientation ;
		if(this.currentOrientation == Configuration.ORIENTATION_LANDSCAPE){
			int work = deviceHeight ;
			deviceHeight = deviceWidth ;
			deviceWidth = work ; 
		}


        //VeamUtil.log("debug","orientation=" + this.currentOrientation + " width=" + deviceWidth + " height=" + deviceHeight) ;
        
        Intent intent = getIntent();
        fileName = intent.getStringExtra("FILENAME");
        key = intent.getStringExtra("KEY");
        contentId = intent.getStringExtra("CONTENTID") ;
        titleName = intent.getStringExtra("TITLE");
        key2 = intent.getStringExtra("KEY2");
        contentId2 = intent.getStringExtra("CONTENTID2") ;

       	pageName = String.format("Playback/%s/%s",titleName,contentId) ;

        setContentView(R.layout.player);
        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        
		this.addBaseBackground(rootLayout) ;

        mPreview = new VideoView(this) ;
        mPreview.setId(this.VIEWID_PLAYER) ;
        mPreview.setBackgroundColor(Color.TRANSPARENT) ;
    	mPreview.setOnCompletionListener(this) ;
    	mPreview.setOnTouchListener(this) ;
    	
    	zoomButtonSize = deviceWidth * 20 / 100 ;

        timer = new Timer(true);        
        timer.schedule( new TimerTask(){
            @Override
            public void run() {
            	if(!isSwitching){
            		// 再生時間表示
	            	if((mPreview != null) && isPlaying()){
	            		int currentTimeMilli = mPreview.getCurrentPosition() ;
	            		//VeamUtil.log("debug","currentTimeMilli="+currentTimeMilli) ;
	            		int workDuration = 0 ;
	            		if(duration == 0){
	            			workDuration = mPreview.getDuration() / 1000 ;
	            			duration = workDuration ;
	            			//VeamUtil.log("debug","workDuration="+workDuration) ;
		            		final int durationToBeSet = workDuration ;
			                handler.post( new Runnable() {
			                    public void run() {
			            			String durationString = String.format("%d:%02d", durationToBeSet/60,durationToBeSet%60) ;
			            			durationTextView.setText(durationString) ;
			            			landDurationTextView.setText(durationString) ;
			                    }
			                });
	            		}
	            		if(currentTime != (currentTimeMilli / 1000)){
	            			currentTime = (currentTimeMilli / 1000) ;
	            			final String timeString = String.format("%d:%02d", currentTime/60,currentTime%60) ;
			                handler.post( new Runnable() {
			                    public void run() {
			            			currentTimeTextView.setText(timeString) ;
			            			landCurrentTimeTextView.setText(timeString) ;
			            			if(duration > 0){
			            				setSliderPoint() ;
			            			}
			                    }
			                });
	            		}
	            	}
            	}
            }
        }, 100, 300);
        
        

		Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

    	titleTextView = new TextView(this) ;
    	titleTextView.setText(titleName) ;
    	titleTextView.setTextColor(Color.BLACK) ;
    	titleTextView.setMaxLines(1) ;
    	titleTextView.setTypeface(typefaceRobotoLight) ;
    	titleTextView.setTextSize(deviceWidth * 5 / 100 / scaledDensity) ;
    	titleTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.CENTER_HORIZONTAL) ;

    	grayView = new View(this) ;
    	grayView.setBackgroundColor(Color.argb(16, 255, 255, 255)) ;
    	
    	sliderLayout = new LinearLayout(this) ;
    	sliderLayout.setOrientation(LinearLayout.HORIZONTAL) ;
    	sliderLayout.setGravity(Gravity.CENTER_VERTICAL) ;
    	
    	LinearLayout.LayoutParams linearLayoutParams ;
    	currentTimeTextView = new TextView(this) ;
    	currentTimeTextView.setText(" 0:00") ;
    	currentTimeTextView.setTextColor(Color.BLACK) ;
    	currentTimeTextView.setMaxLines(1) ;
    	currentTimeTextView.setTypeface(Typeface.SANS_SERIF) ;
    	currentTimeTextView.setTextSize(deviceWidth * 4 / 100 / scaledDensity) ;
    	currentTimeTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.RIGHT) ;
    	currentTimeTextView.setPadding(0, 0, 5, 0) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*15/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.weight = 0 ;
    	sliderLayout.addView(currentTimeTextView,linearLayoutParams) ;
    	
    	sliderBase = new RelativeLayout(this) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.weight = 1 ;
		sliderBase.setGravity(Gravity.CENTER_VERTICAL) ;
    	sliderLayout.addView(sliderBase,linearLayoutParams) ;
    	
		sliderPointSize = deviceWidth * 8 / 100 ;
		
    	sliderImageView = new ImageView(this) ;
    	sliderImageView.setImageResource(R.drawable.p_slider_back) ;
    	sliderImageView.setScaleType(ScaleType.FIT_CENTER) ;
		layoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,RelativeLayout.LayoutParams.MATCH_PARENT) ;
		layoutParams.setMargins(0,0, 0, 0) ;
		sliderBase.addView(sliderImageView,layoutParams) ;

    	sliderPointImageView = new ImageView(this) ;
    	sliderPointImageView.setId(this.VIEWID_SLIDER_POINT) ;
    	sliderPointImageView.setImageResource(R.drawable.p_slider_point) ;
    	sliderPointImageView.setScaleType(ScaleType.FIT_CENTER) ;
    	sliderPointImageView.setOnTouchListener(this) ;
		layoutParams = new RelativeLayout.LayoutParams(sliderPointSize,RelativeLayout.LayoutParams.MATCH_PARENT) ;
		layoutParams.setMargins(0,0,0,0) ;
		sliderBase.addView(sliderPointImageView,layoutParams) ;
    	

    	durationTextView = new TextView(this) ;
    	durationTextView.setText("0:00") ;
    	durationTextView.setTextColor(Color.BLACK) ;
    	durationTextView.setMaxLines(1) ;
    	durationTextView.setTypeface(Typeface.SANS_SERIF) ;
    	durationTextView.setTextSize(deviceWidth * 4 / 100 / scaledDensity) ;
    	durationTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.LEFT) ;
    	durationTextView.setPadding(10, 0, 0, 0) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*15/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.weight = 0 ;
    	sliderLayout.addView(durationTextView,linearLayoutParams) ;

    	
    	
    	controllerLayout = new LinearLayout(this) ;
    	controllerLayout.setOrientation(LinearLayout.HORIZONTAL) ;
    	controllerLayout.setGravity(Gravity.CENTER_VERTICAL) ;
    	
    	View dummyView = new View(this) ;
    	dummyView.setBackgroundColor(Color.TRANSPARENT) ;
    	linearLayoutParams = new LinearLayout.LayoutParams(1, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 1 ;
    	controllerLayout.addView(dummyView,linearLayoutParams) ;
    	
    	prevButtonImageView = new ImageView(this) ;
    	prevButtonImageView.setId(this.VIEWID_PREV_BUTTON) ;
    	prevButtonImageView.setImageResource(R.drawable.p_prev) ;
    	prevButtonImageView.setScaleType(ScaleType.FIT_CENTER) ;
    	prevButtonImageView.setOnClickListener(this) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceHeight*9/100, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 0 ;
    	linearLayoutParams.gravity = Gravity.RIGHT ;
    	controllerLayout.addView(prevButtonImageView,linearLayoutParams) ;
    	
    	playButtonImageView = new ImageView(this) ;
    	playButtonImageView.setId(this.VIEWID_PLAY_BUTTON) ;
    	playButtonImageView.setImageResource(R.drawable.p_pause) ;
    	playButtonImageView.setScaleType(ScaleType.FIT_CENTER) ;
    	playButtonImageView.setOnClickListener(this) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceHeight*12/100, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 0 ;
    	linearLayoutParams.gravity = Gravity.CENTER_HORIZONTAL ;
		controllerLayout.addView(playButtonImageView,linearLayoutParams) ;

    	nextButtonImageView = new ImageView(this) ;
    	nextButtonImageView.setId(this.VIEWID_NEXT_BUTTON) ;
    	nextButtonImageView.setImageResource(R.drawable.p_next) ;
    	nextButtonImageView.setScaleType(ScaleType.FIT_CENTER) ;
    	nextButtonImageView.setOnClickListener(this) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceHeight*9/100, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 0 ;
    	linearLayoutParams.gravity = Gravity.LEFT ;
		controllerLayout.addView(nextButtonImageView,linearLayoutParams) ;

    	dummyView = new View(this) ;
    	dummyView.setBackgroundColor(Color.TRANSPARENT) ;
    	linearLayoutParams = new LinearLayout.LayoutParams(1, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 1 ;
    	controllerLayout.addView(dummyView,linearLayoutParams) ;
    	

    	landControllerHeight = deviceWidth*15/100 ;
    	landControllerLayout = new LinearLayout(this) ;
    	landControllerLayout.setBackgroundColor(Color.BLACK) ;
    	landControllerLayout.setOrientation(LinearLayout.HORIZONTAL) ;
    	landControllerLayout.setGravity(Gravity.CENTER_VERTICAL) ;
    	
    	landPlayButtonImageView = new ImageView(this) ;
    	landPlayButtonImageView.setId(this.VIEWID_LAND_PLAY_BUTTON) ;
    	landPlayButtonImageView.setImageResource(R.drawable.p_pause) ;
    	landPlayButtonImageView.setScaleType(ScaleType.FIT_CENTER) ;
    	landPlayButtonImageView.setOnClickListener(this) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*15/100, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 0 ;
    	linearLayoutParams.gravity = Gravity.CENTER_HORIZONTAL ;
    	landControllerLayout.addView(landPlayButtonImageView,linearLayoutParams) ;
    	
    	landSliderLayout = new LinearLayout(this) ;
    	landSliderLayout.setOrientation(LinearLayout.HORIZONTAL) ;
    	landSliderLayout.setGravity(Gravity.CENTER_VERTICAL) ;
    	
    	
    	landCurrentTimeTextView = new TextView(this) ;
    	landCurrentTimeTextView.setText(" 0:00") ;
    	landCurrentTimeTextView.setTextColor(Color.WHITE) ;
    	landCurrentTimeTextView.setMaxLines(1) ;
    	landCurrentTimeTextView.setTypeface(Typeface.SANS_SERIF) ;
    	landCurrentTimeTextView.setTextSize(deviceWidth * 4 / 100 / scaledDensity) ;
    	landCurrentTimeTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.RIGHT) ;
    	landCurrentTimeTextView.setPadding(0, 0, 5, 0) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*15/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.weight = 0 ;
		landSliderLayout.addView(landCurrentTimeTextView,linearLayoutParams) ;
    	
    	landSliderBase = new RelativeLayout(this) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 1 ;
		landSliderBase.setGravity(Gravity.CENTER_VERTICAL) ;
    	landSliderLayout.addView(landSliderBase,linearLayoutParams) ;
    	
		landSliderPointSize = deviceWidth * 8 / 100 ;
		
    	landSliderImageView = new ImageView(this) ;
    	landSliderImageView.setImageResource(R.drawable.land_slider_back) ;
    	landSliderImageView.setScaleType(ScaleType.FIT_XY) ;
		layoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,RelativeLayout.LayoutParams.MATCH_PARENT) ;
		layoutParams.setMargins(0,0,0,0) ;
		landSliderBase.addView(landSliderImageView,layoutParams) ;

    	landSliderPointImageView = new ImageView(this) ;
    	landSliderPointImageView.setId(this.VIEWID_LAND_SLIDER_POINT) ;
    	landSliderPointImageView.setImageResource(R.drawable.p_slider_point) ;
    	landSliderPointImageView.setScaleType(ScaleType.FIT_CENTER) ;
    	landSliderPointImageView.setOnTouchListener(this) ;
		layoutParams = new RelativeLayout.LayoutParams(landSliderPointSize,RelativeLayout.LayoutParams.MATCH_PARENT) ;
		layoutParams.setMargins(0,0,0,0) ;
		landSliderBase.addView(landSliderPointImageView,layoutParams) ;
    	

    	landDurationTextView = new TextView(this) ;
    	landDurationTextView.setText("0:00") ;
    	landDurationTextView.setTextColor(Color.WHITE) ;
    	landDurationTextView.setMaxLines(1) ;
    	landDurationTextView.setTypeface(Typeface.SANS_SERIF) ;
    	landDurationTextView.setTextSize(deviceWidth * 4 / 100 / scaledDensity) ;
    	landDurationTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.LEFT) ;
    	landDurationTextView.setPadding(10, 0, 0, 0) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*15/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.weight = 0 ;
    	landSliderLayout.addView(landDurationTextView,linearLayoutParams) ;

		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*85/100, LinearLayout.LayoutParams.MATCH_PARENT) ;
		linearLayoutParams.weight = 1 ;
    	linearLayoutParams.gravity = Gravity.CENTER_HORIZONTAL ;
    	landControllerLayout.addView(landSliderLayout,linearLayoutParams) ;




        infoIconSize = deviceWidth * 12 / 100 ;
        infoMargin = deviceWidth * 3 / 100 ;
        bottomPosition = deviceHeight - infoMargin - infoIconSize ;

        int infoY = 0 ;
        infoView = new RelativeLayout(this) ;

        likeButtonImageView = new ImageView(this) ;
        likeButtonImageView.setId(VIEWID_LIKE_BUTTON) ;
        likeButtonImageView.setOnClickListener(this) ;
        likeButtonImageView.setImageResource(R.drawable.forum_like_button_off) ;
        RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(infoIconSize,infoIconSize) ;
        relativeLayoutParams.setMargins(infoMargin, infoY, 0, 0) ;
        infoView.addView(likeButtonImageView,relativeLayoutParams) ;

        commentButtonImageView = new ImageView(this) ;
        commentButtonImageView.setId(VIEWID_COMMENT_BUTTON) ;
        commentButtonImageView.setOnClickListener(this) ;
        commentButtonImageView.setImageResource(R.drawable.forum_comment_button) ;
        relativeLayoutParams = new RelativeLayout.LayoutParams(infoIconSize,infoIconSize) ;
        relativeLayoutParams.setMargins(infoMargin*2+infoIconSize, infoY, 0, 0) ;
        infoView.addView(commentButtonImageView,relativeLayoutParams) ;


        ///// number of likes
        infoViewHeight = infoIconSize * 60 / 100 ;
        infoY += (infoIconSize - infoViewHeight) ;
        int currentX = (infoMargin+infoIconSize) * 2 ;
        infoViewWidth = deviceWidth - currentX - infoMargin ;
        infoBackView = new RelativeLayout(this) ;
        infoBackView.setBackgroundColor(Color.TRANSPARENT);
        relativeLayoutParams = new RelativeLayout.LayoutParams(infoViewWidth,infoViewHeight) ;
        relativeLayoutParams.setMargins(currentX, infoY, 0, 0) ;
        infoView.addView(infoBackView,relativeLayoutParams) ;

        this.setInfoView("-","-") ;


        infoY += infoViewHeight ;
        infoY += infoMargin ;


        int sideMargin = deviceWidth * 3 / 100 ;
        bottomTextViewWidth = deviceWidth-sideMargin*2 ;

        LinearLayout commentView = new LinearLayout(this) ;
        commentView.setOrientation(LinearLayout.HORIZONTAL) ;
        commentView.setBackgroundColor(VeamUtil.getBackgroundColor(this)) ;
        //commentView.setGravity(Gravity.LEFT | Gravity.CENTER_VERTICAL) ;
        commentView.setPadding(deviceWidth*3/100, deviceWidth*3/100, deviceWidth*3/100, deviceWidth*3/100) ;
        relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth, RelativeLayout.LayoutParams.WRAP_CONTENT) ;
        relativeLayoutParams.setMargins(0, infoY, 0, 0) ;
        infoView.addView(commentView,relativeLayoutParams) ;

        ImageView commentMarkImageView = new ImageView(this) ;
        commentMarkImageView.setScaleType(ScaleType.FIT_START) ;
        //commentMarkImageView.setImageResource(R.drawable.forum_comment) ;
		commentMarkImageView.setImageBitmap(VeamUtil.getThemeImage(this, "forum_comment", 1)) ;
        commentMarkImageView.setPadding(0, deviceWidth*1/100, 0, 0) ;
        linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*6/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
        commentView.addView(commentMarkImageView,linearLayoutParams) ;

        commentAreaView = new LinearLayout(this) ;
        commentAreaView.setOrientation(LinearLayout.VERTICAL) ;
        commentAreaView.setBackgroundColor(Color.TRANSPARENT);
        commentAreaView.setPadding(deviceWidth*3/100, 0, 0, 0) ;
        linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*88/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
        commentView.addView(commentAreaView,linearLayoutParams) ;



        this.addTopBar(rootLayout, this.getString(R.string.exclusive_video), true, false) ;
    	
		isLandControllerVisible = false ;
		this.doFadeAnimation(landControllerLayout, 10, 1.0f, 0.0f, null, null) ;
		
    	this.adjustViewsForOrientation() ;
    	this.startMovie() ;

        this.reloadData() ;

    }
    
    /*
    private int getOrientation()
    {
    	Resources resources = getResources();
    	Configuration config = resources.getConfiguration();
    	return config.orientation ;
    }
    */
    
    private boolean isPlaying()
    {
    	boolean retBool = false ;
    	try {
    		retBool = mPreview.isPlaying() ;
        } catch (Exception e) {
        	//Toast.makeText(getApplicationContext(),e.getMessage(),Toast.LENGTH_LONG).show();
    	}
    	return retBool ;
    }

    
    private void setSliderPoint()
    {
    	if(!isPointDragging){
    		if(currentOrientation == Configuration.ORIENTATION_LANDSCAPE){
		    	int sliderWidth = landSliderBase.getWidth() - landSliderPointSize ;
		        int sliderHeight = landSliderBase.getHeight() ;
		        int sliderPosition = sliderWidth * currentTime / duration ;
		        int y = (sliderHeight - landSliderPointSize) / 2 ;
		        //VeamUtil.log("debug","sliderPosition="+sliderPosition + " sliderBaseW="+sliderBase.getWidth() + " H="+sliderBase.getHeight())  ;
		        landSliderPointImageView.layout(sliderPosition, y, sliderPosition+landSliderPointSize, y+landSliderPointSize) ;
		        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(landSliderPointSize,landSliderPointSize) ;
		        params.setMargins(sliderPosition, y, 0, 0) ;
		        landSliderPointImageView.setLayoutParams(params) ;
    		} else {
		    	int sliderWidth = sliderBase.getWidth() - sliderPointSize ;
		        int sliderHeight = sliderBase.getHeight() ;
		        int sliderPosition = sliderWidth * currentTime / duration ;
		        int y = (sliderHeight - sliderPointSize) / 2 ;
		        //VeamUtil.log("debug","sliderPosition="+sliderPosition + " sliderBaseW="+sliderBase.getWidth() + " H="+sliderBase.getHeight())  ;
		        sliderPointImageView.layout(sliderPosition, y, sliderPosition+sliderPointSize, y+sliderPointSize) ;
		        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(sliderPointSize,sliderPointSize) ;
		        params.setMargins(sliderPosition, y, 0, 0) ;
		        sliderPointImageView.setLayoutParams(params) ;
    		}
    	}
    }
    
    private void startMovie(){
       //VeamUtil.log("debug","startMovie()") ;
        try {
        	if((mPreview != null) && isPlaying()){
        		mPreview.stopPlayback() ;
        	}
        	
        	this.closeServer() ;
        	
        	//System.out.println("before server") ;
        	int port = 8080 ;
       		m_Server = new AMHttpServer(this,port,getAssets(),fileName,key);
        	//System.out.println("after server") ;
	        m_Server.start(); // start thread
        	//System.out.println("after start") ;
	        
        	mPreview.setVideoURI(Uri.parse(String.format("http://localhost:%d/",port)));
        	if(this.currentPosition != 0){
        		mPreview.seekTo(this.currentPosition) ;
        	}
        	mPreview.start();
        	
        }catch (IOException e){
        //VeamUtil.log("debug","WebServer error : " + e.getClass().getName() + " " +  e.getMessage()) ;
        	Toast.makeText(getApplicationContext(),this.getString(R.string.error_failed_to_open_movie),Toast.LENGTH_LONG).show();
        	this.endActivity() ;
        } catch (Exception e) {
        	Toast.makeText(getApplicationContext(),e.getMessage(),Toast.LENGTH_LONG).show();
        }
        this.isSwitching = false ;
    }
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
    	// System.out.println("Menu " + item.getItemId()) ;
    	closeServer() ;
    	EndApplication() ;
        return false;
    }
    
    public void surfaceChanged(SurfaceHolder surfaceholder, int i, int j, int k) {
        // System.out.println("surfaceChanged called");
    }

    public void surfaceDestroyed(SurfaceHolder surfaceholder) {
	//VeamUtil.log("debug","surfaceDestroyed") ;
    	if(mMediaPlayer.isPlaying()){
    		mMediaPlayer.stop();
    	}
    	closeServer() ;
//    	EndApplication() ;
    }


    public void surfaceCreated(SurfaceHolder holder) {
	//VeamUtil.log("debug","surfaceCreated") ;
        playVideo();
    }
    
    public void playVideo()
    {
	    try {
	    	mMediaPlayer = new MediaPlayer();
	    	mMediaPlayer.setDataSource("http://localhost:8080/") ;
	        mMediaPlayer.setDisplay(holder);
	    	mMediaPlayer.prepare();
	    	mMediaPlayer.setOnCompletionListener(this);
	    	mMediaPlayer.setOnPreparedListener(this);
	        mMediaPlayer.setOnVideoSizeChangedListener(this);
	    	mMediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
	    } catch (Exception e) {
	        // Toast.makeText(MediaPlayerDemo_Video.this,"error: " + e.getMessage(),Toast.LENGTH_LONG).show();
	        // Log.e("BigBuckBUNNY", "error: " + e.getMessage(), e);
	        //System.out.println("error: " + e.getMessage()) ;
	    }
    }
    
    public void onPrepared(MediaPlayer mediaplayer) {
    	// System.out.println("onPrepared called");
        startVideoPlayback() ;
    }
    
    public void onStop() {
    //VeamUtil.log("debug","onStop") ;
    	//closeServer() ;
    	super.onStop();
    }

    public void onDestroy(){
       //VeamUtil.log("debug", "onDestroy") ;
        closeServer() ;
		this.stopVideoService();
		super.onDestroy();
    }

    private void pausePlayback(){
        if(mPreview != null){
            if(isPlaying()) {
                mPreview.pause();
                handler.post(new Runnable() {
					public void run() {
						playButtonImageView.setImageResource(R.drawable.p_play);
						//setSliderPoint() ;
					}
				});
			}
        }
    }
    private void stopPlayback(){
       //VeamUtil.log("debug","stopPlayback()") ;
        if(mPreview != null) {
           //VeamUtil.log("debug","mPreview != null") ;
            if (isPlaying()) {
               //VeamUtil.log("debug","mPreview playing") ;
                mPreview.stopPlayback();
            }
        }
    }
    
    private void EndApplication()
    {
    	if(mMediaPlayer != null){
	    	if(mMediaPlayer.isPlaying()){
	    		mMediaPlayer.stop();
	    	}
    	}
    	// Keep screen off
    	getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    	closeServer() ;
    	
    	this.endActivity() ;
    }
    
    private void closeServer(){
    	if(m_Server != null){
    		m_Server.close() ;
    		m_Server = null ;
    	}
    }
 
    public void onCompletion(MediaPlayer arg0) {
    //VeamUtil.log("debug","onCompletion called") ;
    	if(isSwitching){
    		return ;
    	}
    	closeServer() ;

    	this.endActivity() ;
    	
    }

    public void onVideoSizeChanged(MediaPlayer mp, int width, int height) {
    	// System.out.println("onVideoSizeChanged called");
        if (width == 0 || height == 0) {
        	// System.out.println("invalid video width(" + width + ") or height(" + height + ")");
            return;
        }
        mIsVideoSizeKnown = true;
        mVideoWidth = width;
        mVideoHeight = height;
        if (mIsVideoReadyToBePlayed && mIsVideoSizeKnown) {
            startVideoPlayback();
        }
    }

    private void startVideoPlayback() {
    //VeamUtil.log("debug","startVideoPlayback");
        holder.setFixedSize(mVideoWidth, mVideoHeight);
        mMediaPlayer.start();
    }

    public void finishToLink()
    {
    	this.setResult(Activity.RESULT_FIRST_USER + 0) ;
    	EndApplication() ;
    }

	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		
		//System.out.println("onItemClick arg2="+arg2); 
    	switch(arg2){
    	case 0: // watch again 
        	this.setResult(Activity.RESULT_FIRST_USER+1) ;
    		break ;
    	case 1: // download & watch
        	this.setResult(Activity.RESULT_FIRST_USER+2) ;
    		break ;
    	case 2: // go to market
        	this.setResult(Activity.RESULT_FIRST_USER+3) ;
    		break ;
    	}
    	mEndDialog.dismiss();
    	finish() ;
	}
	
	private void endActivity()
	{
		/*
		if(mContentId != null){
			Intent intentContent = new Intent(this,ContentActivity.class);
			intentContent.putExtra("CONTENTID",mContentId) ; 
			startActivityForResult(intentContent,VEAMConsts.ACTIVITY_CONTENT);
		}
		*/
		finish() ;
		overridePendingTransition(0, 0) ; // no animation
	}
	
	@Override
	public void onResume() {
	    super.onResume();
		//VeamUtil.log("debug","AMPlayer::onResume") ;
		this.stopVideoService();
		//overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
	}

	@Override
	public void onClick(View view) {
		//VeamUtil.log("debug","onClick") ;
		if(view.getId() == this.VIEWID_ZOOM_BUTTON){
			/*
			if(this.mPreview != null){
				currentPosition = this.mPreview.getCurrentPosition() ;
				//VeamUtil.log("debug","current:"+currentPosition) ;
				if(this.currentAngle == this.ANGLE_1){
					this.currentAngle = this.ANGLE_2 ;
	                handler.post( new Runnable() {
	                    public void run() {
	                    	if(currentTitleNo <= 3){
	                    		zoomButtonImageView.setImageResource(R.drawable.zoomout1) ;
	                    	} else {
	                    		zoomButtonImageView.setImageResource(R.drawable.zoomout2) ;
	                    	}
	                    }
	                });
				} else {
					this.currentAngle = this.ANGLE_1 ;
	                handler.post( new Runnable() {
	                    public void run() {
                    		zoomButtonImageView.setImageResource(R.drawable.zoom) ;
	                    }
	                });
				}
				isSwitching = true ;
				this.startMovie() ;
			} else {
			//VeamUtil.log("debug","mPreview is null") ;
			}
			*/
		} else if(view.getId() == this.VIEWID_PREV_BUTTON){
			//VeamUtil.log("debug","prev") ;
			if(mPreview != null){
				int time = mPreview.getCurrentPosition() ;
				time -= 10000 ; // 10 sec
				if(time < 0){
					time = 0 ;
				}
				mPreview.seekTo(time) ;
			}
		} else if(view.getId() == this.VIEWID_PLAY_BUTTON){
		//VeamUtil.log("debug","play") ;
			if(mPreview != null){
				if(isPlaying()){
					mPreview.pause() ;
	                handler.post(new Runnable() {
						public void run() {
							playButtonImageView.setImageResource(R.drawable.p_play);
							//setSliderPoint() ;
						}
					});
				} else {
					mPreview.start() ;
	                handler.post( new Runnable() {
	                    public void run() {
	                    	playButtonImageView.setImageResource(R.drawable.p_pause) ;
	                    }
	                });
				}
			}
			
		} else if(view.getId() == this.VIEWID_NEXT_BUTTON){
			//VeamUtil.log("debug","next") ;
			if(mPreview != null){
				int time = mPreview.getCurrentPosition() ;
				int limit = mPreview.getDuration() ;
				time += 10000 ; // 10 sec
				if(time < limit){
					mPreview.seekTo(time) ;
				}
			}
		} else if(view.getId() == this.VIEWID_LAND_PLAY_BUTTON){
		//VeamUtil.log("debug","land play") ;
			if(mPreview != null){
				if(isPlaying()){
					mPreview.pause() ;
	                handler.post( new Runnable() {
	                    public void run() {
	                    	landPlayButtonImageView.setImageResource(R.drawable.p_play) ;
	                    	//setSliderPoint() ;
	                    }
	                });
				} else {
					mPreview.start() ;
	                handler.post( new Runnable() {
	                    public void run() {
	                    	landPlayButtonImageView.setImageResource(R.drawable.p_pause) ;
	                    }
	                });
				}
			}
			
		} else if(view.getId() == this.VIEWID_PLAYER){
			//VeamUtil.log("debug","player") ;
		} else if(view.getId() == VIEWID_TOP_BAR_BACK_BUTTON){
			//VeamUtil.log("debug","back") ;
			this.closeActivity() ;
        } else if(view.getId() == VIEWID_FOLD_COMMENT){
            if(currentVideoData != null){
                isShowAllComments = !isShowAllComments ;
                this.setCommentView(currentVideoData.getComments()) ;
            }
        } else if(view.getId() == VIEWID_LIKE_BUTTON){
            if(VeamUtil.isLogin(this)){
                this.operateLike() ;
            } else {
                pendingOperation = PENDING_OPERATION_LIKE ;
                this.login() ;
            }
        } else if(view.getId() == VIEWID_EXPAND_COMMENT){
            scrollView.smoothScrollTo(0, infoViewY - topBarHeight) ;
        } else if(view.getId() == VIEWID_COMMENT_BUTTON){
            //VeamUtil.log("debug","forumListView") ;
            if(VeamUtil.isLogin(this)){
                this.operateCommentButton() ;
            } else {
                pendingOperation = PENDING_OPERATION_COMMENT ;
                this.login() ;
            }
		}
	}
	
	private void closeActivity()
	{
		if(this.isPlaying()){
			mPreview.stopPlayback() ;
		}
		this.finish() ;
		overridePendingTransition(0, 0) ; // no animation
	}
	
	@Override
	public void onConfigurationChanged(Configuration newConfig)
	{
      //VeamUtil.log("debug","onConfigurationChanged") ;
		super.onConfigurationChanged(newConfig);
		currentPosition = mPreview.getCurrentPosition() ;
		rootLayout.removeAllViews() ;
		setContentView(R.layout.player);
		this.currentOrientation = newConfig.orientation ;
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		this.adjustViewsForOrientation() ;
		if(Build.VERSION.SDK_INT <= 21){
		//VeamUtil.log("debug","restart server") ;
			this.startMovie(); // TODO
		}

		mPreview.seekTo(currentPosition) ;
    	mPreview.start();
	//VeamUtil.log("debug", "onConfigurationChanged end") ;
	}
	
	
	private void adjustViewsForOrientation() {
		RelativeLayout.LayoutParams layoutParams ;
	    
	    if(this.currentOrientation == Configuration.ORIENTATION_LANDSCAPE) {
	    	//VeamUtil.log("debug","landscape") ;
			rootLayout.removeAllViews();
			VeamUtil.removeFromParentView(mPreview);
	    	layoutParams = new RelativeLayout.LayoutParams(deviceHeight,deviceWidth) ;
			layoutParams.setMargins(0,0,0, 0);
			mPreview.layout(0, 0, deviceHeight, deviceWidth) ;
	    	rootLayout.addView(mPreview, layoutParams) ;
	    	
			layoutParams = new RelativeLayout.LayoutParams(deviceHeight,landControllerHeight);
			layoutParams.setMargins(0,deviceWidth * 85 / 100, 0, 0);
			rootLayout.addView(landControllerLayout, layoutParams) ;

	    } else if(this.currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
	    	//VeamUtil.log("debug","portrait") ;
	        
	        int movieHeight = deviceWidth * 9 / 16 ;
	        int y = topBarHeight ;

			int extraHeight = bottomPosition - topBarHeight - movieHeight * 10 / 8 ;
			int titleHeight = extraHeight*5/25 ;
			int sliderHeight = extraHeight*8/25 ;
			int controllerHeight = extraHeight*12/25 ;

			this.addBaseBackground(rootLayout) ;

			scrollView = new ScrollView(this) ;
			scrollView.setId(VIEWID_SCROLL_VIEW);
			scrollView.setVerticalScrollBarEnabled(false) ;
			rootLayout.addView(scrollView) ;
            RelativeLayout contentView = new RelativeLayout(this) ;
			scrollView.addView(contentView) ;
			int padding = 0;
			contentView.setPadding(padding, padding, padding, padding);

			this.addTopBar(rootLayout, this.getString(R.string.exclusive_video), true, false) ;

			VeamUtil.removeFromParentView(titleTextView);
			//layoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceHeight*5/100) ;
			layoutParams = new RelativeLayout.LayoutParams(deviceWidth,titleHeight) ;
			layoutParams.setMargins(0, y, 0, 0) ;
            contentView.addView(titleTextView, layoutParams) ;
			y += titleHeight ;

			VeamUtil.removeFromParentView(grayView);
			int grayHeight = movieHeight*10/8 ;
			layoutParams = new RelativeLayout.LayoutParams(deviceWidth,grayHeight) ;
			layoutParams.setMargins(0, y, 0, 0) ;
            contentView.addView(grayView, layoutParams) ;

			y += movieHeight / 8 ;

			VeamUtil.removeFromParentView(mPreview);
	    	layoutParams = new RelativeLayout.LayoutParams(deviceWidth,movieHeight) ;
	    	layoutParams.setMargins(0,y, 0, 0) ;
            contentView.addView(mPreview, layoutParams) ;

			y += movieHeight ;
			y += movieHeight / 8 ;

			VeamUtil.removeFromParentView(sliderLayout);
	    	layoutParams = new RelativeLayout.LayoutParams(deviceWidth, sliderHeight) ;
	    	layoutParams.setMargins(0,y, 0, 0) ;
            contentView.addView(sliderLayout, layoutParams) ;

			y += sliderHeight ;

			VeamUtil.removeFromParentView(controllerLayout);
	    	layoutParams = new RelativeLayout.LayoutParams(deviceWidth,controllerHeight) ;
	    	layoutParams.setMargins(0,y, 0, 0) ;
            contentView.addView(controllerLayout,layoutParams) ;

            y += controllerHeight ;

           //VeamUtil.log("debug","info Position " + y + " < " + bottomPosition) ;
            //if(y < bottomPosition){
                y = bottomPosition ;
            //}

            infoViewY = y ;

			VeamUtil.removeFromParentView(infoView);
            layoutParams = new RelativeLayout.LayoutParams(deviceWidth,RelativeLayout.LayoutParams.WRAP_CONTENT) ;
            layoutParams.setMargins(0,y, 0, 0) ;
            contentView.addView(infoView,layoutParams) ;
	    }
	}

	@Override
	public boolean onTouch(View view, MotionEvent event) {
		if(view.getId() == this.VIEWID_SLIDER_POINT){
			int x = (int) event.getRawX();
			int y = (int) event.getRawY();
			if (event.getAction() == MotionEvent.ACTION_MOVE) {
				int left = view.getLeft() + (x - offsetX) ;
				int top = view.getTop() ;
				if(left < 0){
					left = 0 ;
				}
				int sliderWidth = this.sliderBase.getWidth() - sliderPointSize ;
				if(sliderWidth < left){
					left = sliderWidth ;
				}
				//VeamUtil.log("debug",String.format("onTouch ACTION_MOVE %d %d",left,top)) ;
				view.layout(left,top, left + view.getWidth(),top+view.getHeight());
				RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(view.getWidth(),view.getHeight()) ;
				params.setMargins(left, top, 0, 0) ;
		        view.setLayoutParams(params) ;

				offsetX = x;
				offsetY = y;
			} else if (event.getAction() == MotionEvent.ACTION_DOWN) {
				//VeamUtil.log("debug",String.format("onTouch ACTION_DOWN %d %d",x,y)) ;
				isPointDragging = true ;
				offsetX = x;
				offsetY = y;
			} else if (event.getAction() == MotionEvent.ACTION_UP) {
				isPointDragging = false ;
				//VeamUtil.log("debug",String.format("onTouch ACTION_UP %d %d",x,y)) ;
				int left = view.getLeft() + (x - offsetX) ;
				if(left < 0){
					left = 0 ;
				}
				int sliderWidth = this.sliderBase.getWidth() - sliderPointSize ;
				if(sliderWidth < left){
					left = sliderWidth ;
				}
				int targetTime = duration * 1000 * left / sliderWidth ;
				if(mPreview != null){
					mPreview.seekTo(targetTime) ;
				}
			} else {
			//VeamUtil.log("debug","another action") ;
			}
		} else if(view.getId() == this.VIEWID_LAND_SLIDER_POINT){
			int x = (int) event.getRawX();
			int y = (int) event.getRawY();
			if (event.getAction() == MotionEvent.ACTION_MOVE) {
				int left = view.getLeft() + (x - landOffsetX) ;
				int top = view.getTop() ;
				if(left < 0){
					left = 0 ;
				}
				int sliderWidth = this.landSliderBase.getWidth() - sliderPointSize ;
				if(sliderWidth < left){
					left = sliderWidth ;
				}
				//VeamUtil.log("debug",String.format("onTouch ACTION_MOVE %d %d",left,top)) ;
				view.layout(left,top, left + view.getWidth(),top+view.getHeight());
				RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(view.getWidth(),view.getHeight()) ;
				params.setMargins(left, top, 0, 0) ;
		        view.setLayoutParams(params) ;
				landOffsetX = x;
				landOffsetY = y;
			} else if (event.getAction() == MotionEvent.ACTION_DOWN) {
				//VeamUtil.log("debug",String.format("onTouch ACTION_DOWN %d %d",x,y)) ;
				isPointDragging = true ;
				landOffsetX = x;
				landOffsetY = y;
			} else if (event.getAction() == MotionEvent.ACTION_UP) {
				isPointDragging = false ;
				//VeamUtil.log("debug",String.format("onTouch ACTION_UP %d %d",x,y)) ;
				int left = view.getLeft() + (x - landOffsetX) ;
				if(left < 0){
					left = 0 ;
				}
				int sliderWidth = this.landSliderBase.getWidth() - sliderPointSize ;
				if(sliderWidth < left){
					left = sliderWidth ;
				}
				int targetTime = duration * 1000 * left / sliderWidth ;
				if(mPreview != null){
					mPreview.seekTo(targetTime) ;
				}
			} else {
			//VeamUtil.log("debug","another action") ;
			}
		} else if(view.getId() == this.VIEWID_PLAYER){
			//VeamUtil.log("debug","PLAYER touch") ;
			if(currentOrientation == Configuration.ORIENTATION_LANDSCAPE){
				if (event.getAction() == MotionEvent.ACTION_UP) {
					if(isLandControllerVisible){
						isLandControllerVisible = false ;
						this.doFadeAnimation(this.landControllerLayout, 500, 1.0f, 0.0f, null, null) ;
					} else {
						isLandControllerVisible = true ;
						this.doFadeAnimation(this.landControllerLayout, 500, 0.0f, 1.0f, null, null) ;
					}
				}
			}
		}
		
		return true ;
	}


    private void setInfoView(String numberOfLikes,String numberOfComments){
        if(infoBackView != null){
            infoBackView.removeAllViews() ;

            int currentX = infoViewWidth - infoViewHeight ;
            ImageView expandImageView = new ImageView(this) ;
            expandImageView.setId(VIEWID_EXPAND_COMMENT) ;
            expandImageView.setOnClickListener(this) ;
            //expandImageView.setImageResource(R.drawable.expand_comment) ; // 36x36
			expandImageView.setImageBitmap(VeamUtil.getThemeImage(this, "expand_comment", 1)) ;
			RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(infoViewHeight,infoViewHeight) ;
            relativeLayoutParams.setMargins(currentX, 0, 0, 0) ;
            infoBackView.addView(expandImageView,relativeLayoutParams) ;

            TextView commentsTextView = new TextView(this) ;
            commentsTextView.setText(numberOfComments) ;
            commentsTextView.setGravity(Gravity.RIGHT|Gravity.CENTER_VERTICAL) ;
            commentsTextView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
            commentsTextView.setPadding(0, 0, 0, 0) ;
            commentsTextView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
            TextPaint paint = commentsTextView.getPaint() ;
            int commentsTextWidth = (int) Layout.getDesiredWidth(numberOfComments, paint) + deviceWidth * 1 / 100 ;
            currentX -= commentsTextWidth ;
            relativeLayoutParams = new RelativeLayout.LayoutParams(commentsTextWidth,infoViewHeight) ;
            relativeLayoutParams.setMargins(currentX, 0, 0, 0) ;
            infoBackView.addView(commentsTextView,relativeLayoutParams) ;

            int commentImageHeight = infoViewHeight * 80 / 100 ; // likeImageWidth * 36 / 44 ;
            int commentImageWidth = commentImageHeight * 44 / 36 ;
            currentX -= commentImageWidth ;
            ImageView commentMarkImageView = new ImageView(this) ;
            //commentMarkImageView.setImageResource(R.drawable.program_comment) ;
			commentMarkImageView.setImageBitmap(VeamUtil.getThemeImage(this, "program_comment", 1)) ;
            relativeLayoutParams = new RelativeLayout.LayoutParams(commentImageWidth,commentImageHeight) ;
            relativeLayoutParams.setMargins(currentX, (infoViewHeight - commentImageHeight)/2 , 0, 0) ;
            infoBackView.addView(commentMarkImageView,relativeLayoutParams) ;

            currentX -= deviceWidth * 3 / 100 ;

            TextView likesTextView = new TextView(this) ;
            likesTextView.setText(numberOfLikes) ;
            likesTextView.setGravity(Gravity.RIGHT|Gravity.CENTER_VERTICAL) ;
            likesTextView.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
            likesTextView.setPadding(0, 0, 0, 0) ;
            likesTextView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
            paint = likesTextView.getPaint() ;
            int likesTextWidth = (int)Layout.getDesiredWidth(numberOfLikes, paint) + deviceWidth * 1 / 100 ;
            currentX -= likesTextWidth ;
            relativeLayoutParams = new RelativeLayout.LayoutParams(likesTextWidth,infoViewHeight) ;
            relativeLayoutParams.setMargins(currentX, 0, 0, 0) ;
            infoBackView.addView(likesTextView,relativeLayoutParams) ;

            int likeImageHeight = infoViewHeight * 80 / 100 ; // likeImageWidth * 36 / 44 ;
            int likeImageWidth = likeImageHeight * 44 / 36 ;
            currentX -= likeImageWidth ;
            ImageView likeMarkImageView = new ImageView(this) ;
            //likeMarkImageView.setImageResource(R.drawable.program_like) ;
			likeMarkImageView.setImageBitmap(VeamUtil.getThemeImage(this, "program_like", 1)) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(likeImageWidth,likeImageHeight) ;
            relativeLayoutParams.setMargins(currentX, (infoViewHeight - likeImageHeight)/2 , 0, 0) ;
            infoBackView.addView(likeMarkImageView,relativeLayoutParams) ;

        }
    }
    private void setCommentView(ArrayList<VideoCommentObject> comments){
        commentAreaView.removeAllViews() ;
        int count = comments.size() ;
        int showCount = count ;
        if((count > 3) && ! isShowAllComments){
            showCount = 3 ;
        }

        LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*85/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;


        for(int index = 0 ; index < showCount ; index++){
            VideoCommentObject comment = comments.get(index) ;
            TextView commentTextView = new TextView(this) ;
            commentTextView.setTextSize((float)deviceWidth * 3.9f / 100 / scaledDensity) ;
            String htmlString = String.format("<font color=\"#%06x\"><b>%s</b></font> <font color=\"#%06x\">%s</font>",
                    VeamUtil.getLinkTextColor(this)&0x00FFFFFF,comment.getUserName(),
                    0x00202020,comment.getText()) ;
            commentTextView.setText(Html.fromHtml(htmlString)) ;
            commentTextView.setTypeface(Typeface.SANS_SERIF) ;
            commentAreaView.addView(commentTextView,linearLayoutParams) ;
        }

        if(count <= 3){
            TextView textView = new TextView(this) ;
            textView.setTextSize((float)deviceWidth * 3.9f / 100 / scaledDensity) ;
            textView.setText(" ") ;

            textView.setGravity(Gravity.CENTER_VERTICAL) ;
            textView.setTextColor(VeamUtil.getBaseTextColor(this)) ;
            textView.setTypeface(Typeface.SANS_SERIF) ;

            linearLayoutParams = new TableLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,deviceWidth*15/100, 1f) ;
            commentAreaView.addView(textView,linearLayoutParams) ;

        } else {
            TextView textView = new TextView(this) ;
            textView.setTextSize((float)deviceWidth * 3.9f / 100 / scaledDensity) ;
            if(!isShowAllComments){
                textView.setText(String.format(this.getString(R.string.view_all_comments),count)) ;
            } else {
                textView.setText(this.getString(R.string.close_all_comments)) ;
            }
            textView.setGravity(Gravity.CENTER_VERTICAL) ;
            textView.setTextColor(VeamUtil.getColorFromArgbString("00202020")) ;
            textView.setTextColor(VeamUtil.getBaseTextColor(this)) ;
            textView.setTypeface(Typeface.SANS_SERIF) ;
            textView.setId(VIEWID_FOLD_COMMENT) ;
            textView.setOnClickListener(this) ;

            linearLayoutParams = new TableLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,deviceWidth*15/100, 1f) ;
            commentAreaView.addView(textView,linearLayoutParams) ;

        }
    }


    private void reloadData(){
        if(!isLoading){
            isLoading = true ;
            LoadVideoDataTask loadVideoDataTask = new LoadVideoDataTask(this,contentId) ;
            loadVideoDataTask.execute("") ;
        }
    }

    public void operateCommentButton(){
        //VeamUtil.log("debug","pictureId = "+currentPictureObject.getId()) ;
        this.pausePlayback() ;
        Intent postCommentIntent = new Intent(this,PostVideoCommentActivity.class) ;
        postCommentIntent.putExtra("video_id", contentId) ;
        startActivityForResult(postCommentIntent,REQUEST_POST_COMMENT_ACTIVITY) ;
        overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
    }

    public void operateLike(){
        //VeamUtil.log("debug","operateLike") ;

        pendingOperation = PENDING_OPERATION_NONE ;

        boolean isLike = false ;
        if(currentVideoData != null){
            isLike = currentVideoData.isLike ;
        }
        if(isLike){
            //VeamUtil.log("debug","is like") ;
            likeButtonImageView.setImageResource(R.drawable.forum_like_button_off) ;
        } else {
            //VeamUtil.log("debug","is not like") ;
            //likeButtonImageView.setImageResource(R.drawable.forum_like_button_on) ;
			likeButtonImageView.setImageBitmap(VeamUtil.getThemeImage(this, "forum_like_button_on", 1)) ;
		}

        isLike = !isLike ;

        SendVideoLikeTask sendVideoLikeTask = new SendVideoLikeTask(this,contentId,isLike) ;
        sendVideoLikeTask.execute("") ;
    }

    public void updateVideoData(VideoDataXml videoData){
        isLoading = false ;
        currentVideoData = videoData ;

        //VeamUtil.log("debug","updateVideoData  likes:"+videoData.numberOfLikes + " comments:" + videoData.getNumberOfComments()) ;

        if(videoData.isLike){
            //this.likeButtonImageView.setImageResource(R.drawable.forum_like_button_on) ;
			likeButtonImageView.setImageBitmap(VeamUtil.getThemeImage(this, "forum_like_button_on", 1)) ;
        } else {
            this.likeButtonImageView.setImageResource(R.drawable.forum_like_button_off) ;
        }

        this.setInfoView(String.format("%d", videoData.numberOfLikes),String.format("%d", videoData.getNumberOfComments())) ;
        this.setCommentView(videoData.getComments()) ;
    }

    public void onVideoDataLoadFailed() {
        isLoading = false ;
    }

    public void sendVideoLikeDone(Integer resultCode) {
        this.reloadData() ;
		//VeamUtil.log("debug","sendVideoLikeDone") ;
		if(VeamUtil.isSubscriptionFree(this)){
			//VeamUtil.kickKiip(this,"VideoLike") ;
		}
	}

    public void login(){
        this.pausePlayback() ;
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

    public void loginFacebook(){
        //VeamUtil.log("debug","loginFacebook") ;
        this.facebookLogin() ;
    }

    public void loginTwitter(){
        //VeamUtil.log("debug","loginTwitter") ;
        this.twitterLogin() ;
    }

    public void onLoginFinished(Integer resultCode) {
        //VeamUtil.log("debug","onLoginFinished:"+resultCode) ;
        if(resultCode == 1){
            doPendingOperation() ;
        } else {
            //onLoginFailed() ;
        }
    }

    public void doPendingOperation(){
        if(pendingOperation == PENDING_OPERATION_COMMENT){
            //VeamUtil.log("debug","pending : comment " + currentPictureObject.getId()) ;
            this.operateCommentButton() ;
        } else if(pendingOperation == PENDING_OPERATION_LIKE){
            this.operateLike() ;
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //VeamUtil.log("debug","AudioDetailActivity::onActivityResult resultCode:"+resultCode) ;
        if(requestCode == REQUEST_POST_COMMENT_ACTIVITY){
            //VeamUtil.log("debug","REQUEST_POST_COMMENT_ACTIVITY") ;
            if(resultCode == 1){
                this.reloadData() ;
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


	private ServiceConnection serviceConnection = new ServiceConnection() {
		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			BackgroundVideoService.LocalBinder binder = (BackgroundVideoService.LocalBinder)service;
			backgroundVideoService = binder.getService();
		}

		@Override
		public void onServiceDisconnected(ComponentName name) {
		}
	};


	@Override
	public void onUserLeaveHint(){
	//VeamUtil.log("debug", "onUserLeaveHint");
		this.startVideoService();
	}

	private void startVideoService(){
	//VeamUtil.log("debug", "start video service");
		if(mPreview != null){
			if(isPlaying()) {
				mPreview.pause();
				int currentPosition = mPreview.getCurrentPosition() ;
				backgroundVideoServiceIntent = new Intent(this, BackgroundVideoService.class);
				backgroundVideoServiceIntent.putExtra("DATA_PATH", "http://localhost:8080/");
				backgroundVideoServiceIntent.putExtra("CURRENT_POSITION", currentPosition);
				startService(backgroundVideoServiceIntent) ;
				bindService(backgroundVideoServiceIntent, serviceConnection, 0);
			}
		}
	}

	private void stopVideoService(){
		if(backgroundVideoService != null) {
			if (backgroundVideoServiceIntent != null) {
				unbindService(serviceConnection);
				stopService(backgroundVideoServiceIntent);
			}
			backgroundVideoService = null ;
		}
	}
}
