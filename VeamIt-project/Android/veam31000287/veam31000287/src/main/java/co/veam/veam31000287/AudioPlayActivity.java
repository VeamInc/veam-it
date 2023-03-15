package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Color;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.text.Html;
import android.text.Layout;
import android.text.TextPaint;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TableLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.Session;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;



public class AudioPlayActivity extends VeamActivity implements OnClickListener, OnLoginFinishedListener, LoadDataTask.LoadDataTaskListener, OnCompletionListener, OnTouchListener {
	
	private RelativeLayout rootLayout ;

	private BackgroundSoundService backgroundSoundService;
	private Intent backgroundSoundServiceIntent ;

	private int currentView ;

    private static int VIEW_MAIN				 		= 1 ;
    private static int VIEW_WEB		 				= 2 ;

    public static int VIEWID_FAVORITE_BUTTON			= 0x10007 ;
	public static int VIEWID_LIKE_BUTTON				= 0x10008 ;
	public static int VIEWID_COMMENT_BUTTON				= 0x10009 ;
	public static int VIEWID_FOLD_COMMENT				= 0x1000A ;
	public static int VIEWID_EXPAND_COMMENT				= 0x1000B ;
	public static int VIEWID_CENTER_PLAY				= 0x1000C ;
	public static int VIEWID_SLIDER_POINT				= 0x1000D ;
	public static int VIEWID_SCROLL_VIEW 				= 0x1000E ;
    public static int VIEWID_PLAY_BUTTON				= 0x1000F ;
    public static int VIEWID_LINK       				= 0x10010 ;

	public static int REQUEST_POST_COMMENT_ACTIVITY		= 0x0001 ;
	//public static int REQUEST_CODE_TWITTER_AUTH			= 0x0002 ;
	
	private AudioObject audioObject ;
	private ImageView favoriteButtonImageView ;
	private ImageView likeButtonImageView ;
	private ImageView commentButtonImageView ;
	//protected String printableId ;
	
	private MediaPlayer mediaPlayer = null ;

	
	
	
	//private RelativeLayout titleBackView ;
	private int bottomTextViewWidth ;
	
	private ImageView audioImageView ;
	private RelativeLayout infoBackView ;
	private int infoViewWidth ;
	private int infoViewHeight ;
	private LinearLayout commentAreaView ;
	private boolean isShowAllComments = false ;
	private AudioDataXml currentAudioData ;
	private ScrollView scrollView ;
	private int infoViewY = 0 ;
	private CircleView circleView ;
	private ProgressBar downloadProgressBar ;
	private TextView downloadProgressText ;
	private Handler handler = null ;
    private ImageView centerPlayImageView ;
    private ImageView linkImageView ;

	
	private LinearLayout sliderLayout ;
	private TextView currentTimeTextView ;
	private RelativeLayout sliderBase ;
	private ImageView sliderImageView ;
	private ImageView sliderPointImageView ;
	private TextView durationTextView ;
	private int sliderPointSize ;
	private int offsetX = 0 ;
	private int offsetY = 0 ;
	private boolean isPointDragging = false ;
	private int duration = 0 ;
	private Timer timer ;
	private int currentTime ;
	private int currentTimeMilli ;
	private ImageView playImageView ;
	
	private boolean isPlaying = false ;



	
	boolean isLoading = false ;

	private int pendingOperation ;
	private static int PENDING_OPERATION_NONE		= 0 ;
	private static int PENDING_OPERATION_COMMENT	= 1 ;
	private static int PENDING_OPERATION_LIKE		= 2 ;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.activity_videos);
		
	    DisplayMetrics metrics = new DisplayMetrics();  
	    this.getWindowManager().getDefaultDisplay().getMetrics(metrics);

		handler = new Handler();
		
		Intent intent = getIntent() ;
		audioObject = (AudioObject)intent.getSerializableExtra("AudioObject") ;
		
		if(audioObject != null){
			this.pageName = String.format("AudioPlay/%s/%s",audioObject.getId(),audioObject.getTitle()) ;
		}

		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;

        RelativeLayout.LayoutParams layoutParams ;

        this.addBaseBackground(rootLayout) ;

        Typeface typefaceRobotoLight = Typeface.SANS_SERIF ; // Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

		String audioId = audioObject.getId() ;

		scrollView = new ScrollView(this) ;
		scrollView.setId(VIEWID_SCROLL_VIEW) ;
		scrollView.setVerticalScrollBarEnabled(false) ;
		rootLayout.addView(scrollView) ;
		RelativeLayout contentView = new RelativeLayout(this) ;
		scrollView.addView(contentView) ;
		int padding = 0 ;
		contentView.setPadding(padding, padding, padding, padding) ;

		int iconSize = deviceWidth * 12 / 100 ;
		int circleSize = deviceWidth * 50 / 100 ;
		int margin = deviceWidth * 3 / 100 ;
		int currentY = topBarHeight ;
		int bottomPosition = deviceHeight - margin - iconSize ;
		int titleTextHeight = deviceWidth*10/100 ;
		int playImageWidth = deviceWidth * 12 / 100 ;
		int playImageHeight = playImageWidth * 140 / 132 ;
		int durationHeight = deviceWidth * 10 / 100 ;

		int bodySize = circleSize ;
		bodySize += deviceWidth * 6 / 100 ;
		bodySize += titleTextHeight ;
		bodySize += deviceWidth * 1 / 100 ; // margin
		bodySize += playImageHeight ;
		bodySize += deviceWidth * 1 / 100 ; // margin
		bodySize += durationHeight ;

		currentY = topBarHeight + (bottomPosition - topBarHeight - bodySize) / 2 ;

		//////// circle
		audioImageView = new ImageView(this) ;
		String largeImageUrl = audioObject.getThumbnailUrl() ;
		audioImageView.setTag(Integer.valueOf(0)) ;
		if(VeamUtil.isEmpty(largeImageUrl)){
			audioImageView.setImageResource(R.drawable.message_icon_l) ;
		} else {
			audioImageView.setImageResource(R.drawable.message_icon_null) ;
			LoadImageTask loadImageTask = new LoadImageTask(this,largeImageUrl,audioImageView,circleSize,0,null) ;
			loadImageTask.execute("") ;
		}
		audioImageView.setBackgroundColor(Color.TRANSPARENT) ;
        RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(circleSize,circleSize) ;
		relativeLayoutParams.setMargins((deviceWidth-circleSize)/2, currentY, 0, 0) ;
		contentView.addView(audioImageView,relativeLayoutParams) ;

		circleView = new CircleView(this) ;
		circleView.setOval(new RectF(0.0f, 0.0f, circleSize+4,circleSize+4)) ;
		circleView.setPercentage(0.0f) ;
		circleView.setColor(VeamUtil.getColorFromArgbString("99000000")) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(circleSize+4,circleSize+4) ;
		relativeLayoutParams.setMargins((deviceWidth-circleSize)/2-2, currentY-2, 0, 0) ;
		contentView.addView(circleView,relativeLayoutParams) ;
		
		centerPlayImageView = new ImageView(this) ;
		centerPlayImageView.setId(VIEWID_CENTER_PLAY) ;
		centerPlayImageView.setOnClickListener(this) ;
		centerPlayImageView.setImageResource(R.drawable.audio_play) ;
		centerPlayImageView.setBackgroundColor(Color.TRANSPARENT) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(circleSize,circleSize) ;
		relativeLayoutParams.setMargins((deviceWidth-circleSize)/2, currentY, 0, 0) ;
		contentView.addView(centerPlayImageView,relativeLayoutParams) ;

        int linkSize = circleSize * 34 / 100 ;
        String linkUrl = audioObject.getLinkUrl() ;
        if(!VeamUtil.isEmpty(linkUrl)){
            linkImageView = new ImageView(this) ;
            linkImageView.setId(VIEWID_LINK) ;
            linkImageView.setOnClickListener(this) ;
            //linkImageView.setImageResource(R.drawable.audio_link_button) ;
            linkImageView.setImageBitmap(VeamUtil.getThemeImage(this,"audio_link_button",1)) ;
            linkImageView.setBackgroundColor(Color.TRANSPARENT) ;
            relativeLayoutParams = new RelativeLayout.LayoutParams(linkSize,linkSize) ;
            relativeLayoutParams.setMargins((deviceWidth-circleSize)/2+circleSize-linkSize, currentY+circleSize-linkSize, 0, 0) ;
            contentView.addView(linkImageView,relativeLayoutParams) ;
        }

		
		int progressSize = deviceWidth * 10 / 100 ;
		int circleY = currentY+(circleSize-progressSize)/2 ;
		downloadProgressBar = new ProgressBar(this) ;
		downloadProgressBar.setIndeterminate(true) ;
		//downloadProgressBar.setVisibility(View.GONE) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(progressSize,progressSize) ;
		relativeLayoutParams.setMargins((deviceWidth-progressSize)/2, circleY, 0, 0) ;
		contentView.addView(downloadProgressBar,relativeLayoutParams) ;
		
		downloadProgressText = new TextView(this) ;
		downloadProgressText.setText("0%") ;
		downloadProgressText.setTextSize((float)deviceWidth * 4.0f / 100 / scaledDensity) ;
		downloadProgressText.setTextColor(Color.WHITE) ;
		downloadProgressText.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceWidth * 10 / 100) ;
		relativeLayoutParams.setMargins(0, circleY+progressSize+deviceWidth*2/100, 0, 0) ;
		contentView.addView(downloadProgressText,relativeLayoutParams) ;
		


		currentY += circleSize ;
		
		currentY += deviceWidth * 6 / 100 ;
		///////// title
		TextView textView = new TextView(this) ;
		textView.setText(audioObject.getTitle()) ;
		textView.setTextSize((float)deviceWidth * 5.9f / 100 / scaledDensity) ;
		textView.setTextColor(VeamUtil.getBaseTextColor(this)) ;
		textView.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL) ;
		textView.setTypeface(Typeface.SERIF) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,titleTextHeight) ;
		relativeLayoutParams.setMargins(0, currentY, 0, 0) ;
		contentView.addView(textView,relativeLayoutParams) ;
		
		currentY += titleTextHeight ;
		currentY += deviceWidth * 1 / 100 ; // margin
		
		// play image 140x132
		playImageView = new ImageView(this) ;
		playImageView.setId(VIEWID_PLAY_BUTTON) ;
		playImageView.setOnClickListener(this) ;
		playImageView.setImageResource(R.drawable.p_pause) ;
		playImageView.setVisibility(View.GONE) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(playImageWidth,playImageHeight) ;
		relativeLayoutParams.setMargins((deviceWidth-playImageWidth)/2, currentY, 0, 0) ;
		contentView.addView(playImageView,relativeLayoutParams) ;
		
		currentY += playImageHeight ;
		currentY += deviceWidth * 1 / 100 ; // margin
		///////// time & duration & progress
    	sliderLayout = new LinearLayout(this) ;
    	sliderLayout.setOrientation(LinearLayout.HORIZONTAL) ;
    	sliderLayout.setGravity(Gravity.CENTER_VERTICAL) ;
    	
    	LinearLayout.LayoutParams linearLayoutParams ;
    	currentTimeTextView = new TextView(this) ;
    	currentTimeTextView.setText(" 0:00") ;
    	currentTimeTextView.setTextColor(Color.BLACK) ;
    	currentTimeTextView.setMaxLines(1) ;
    	currentTimeTextView.setTypeface(Typeface.SERIF) ;
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
    	

		duration = VeamUtil.parseInt(audioObject.getDuration()) ;
    	durationTextView = new TextView(this) ;
    	durationTextView.setText(String.format("%d:%02d",duration/60,duration%60)) ;
    	durationTextView.setTextColor(Color.BLACK) ;
    	durationTextView.setMaxLines(1) ;
    	durationTextView.setTypeface(Typeface.SERIF) ;
    	durationTextView.setTextSize(deviceWidth * 4 / 100 / scaledDensity) ;
    	durationTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.LEFT) ;
    	durationTextView.setPadding(10, 0, 0, 0) ;
		linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*15/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		linearLayoutParams.weight = 0 ;
    	sliderLayout.addView(durationTextView,linearLayoutParams) ;

		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,durationHeight) ;
		relativeLayoutParams.setMargins(0, currentY, 0, 0) ;
    	contentView.addView(sliderLayout,relativeLayoutParams) ;

		currentY += durationHeight ;
		
		currentY += margin ;
		
		//if(currentY < bottomPosition){
			currentY = bottomPosition ;
		//}
		
		
		likeButtonImageView = new ImageView(this) ;
		likeButtonImageView.setId(VIEWID_LIKE_BUTTON) ;
		likeButtonImageView.setOnClickListener(this) ;
		likeButtonImageView.setImageResource(R.drawable.forum_like_button_off) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(iconSize,iconSize) ;
		relativeLayoutParams.setMargins(margin, currentY, 0, 0) ;
		contentView.addView(likeButtonImageView,relativeLayoutParams) ;

		commentButtonImageView = new ImageView(this) ;
		commentButtonImageView.setId(VIEWID_COMMENT_BUTTON) ;
		commentButtonImageView.setOnClickListener(this) ;
		commentButtonImageView.setImageResource(R.drawable.forum_comment_button) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(iconSize,iconSize) ;
		relativeLayoutParams.setMargins(margin*2+iconSize, currentY, 0, 0) ;
		contentView.addView(commentButtonImageView,relativeLayoutParams) ;
		
		
		///// number of likes
		infoViewHeight = iconSize * 60 / 100 ;
		currentY += (iconSize - infoViewHeight) ;
		infoViewY = currentY ;
		int currentX = (margin+iconSize) * 2 ;
		infoViewWidth = deviceWidth - currentX - margin ;
		infoBackView = new RelativeLayout(this) ;
		infoBackView.setBackgroundColor(Color.TRANSPARENT); 
		relativeLayoutParams = new RelativeLayout.LayoutParams(infoViewWidth,infoViewHeight) ;
		relativeLayoutParams.setMargins(currentX, currentY, 0, 0) ;
		contentView.addView(infoBackView,relativeLayoutParams) ;
		
		this.setInfoView("-","-") ;


		currentY += infoViewHeight ;
		currentY += margin ;
		
		
		int sideMargin = deviceWidth * 3 / 100 ;
		bottomTextViewWidth = deviceWidth-sideMargin*2 ;
		
		LinearLayout commentView = new LinearLayout(this) ;
		commentView.setOrientation(LinearLayout.HORIZONTAL) ;
		commentView.setBackgroundColor(VeamUtil.getBackgroundColor(this)) ;
		//commentView.setGravity(Gravity.LEFT | Gravity.CENTER_VERTICAL) ;
		commentView.setPadding(deviceWidth*3/100, deviceWidth*3/100, deviceWidth*3/100, deviceWidth*3/100) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth, RelativeLayout.LayoutParams.WRAP_CONTENT) ;
		relativeLayoutParams.setMargins(0, currentY, 0, 0) ;
		contentView.addView(commentView,relativeLayoutParams) ;
		
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



        //this.addTopBar(rootLayout, VeamUtil.getAudioDateStringWithYear(audioObject.getCreatedAt()),true,false) ;
        this.addTopBar(rootLayout, audioObject.getTitle(),true,false) ;

		this.reloadData() ;
		
		int dataSize = VeamUtil.parseInt(audioObject.getDataSize()) ;
		String fileName = audioObject.getDataFileName() ;
		if(audioObject.dataFileExists(this)){
			this.hideDownloadProgress() ;
		} else {
			centerPlayImageView.setVisibility(View.GONE) ;
			String dataUrl = audioObject.getDataUrl() ;
			if(VeamUtil.isEmpty(dataUrl)){
				dataUrl = VeamUtil.getAudioUrl(this,audioObject.getId()) ;
				//VeamUtil.log("debug","audioUrl="+dataUrl) ;
			}
			LoadDataTask loadDataTask = new LoadDataTask(this,this,dataUrl,fileName,dataSize) ;
			loadDataTask.execute("") ;
		}

        currentView = VIEW_MAIN ;

    }
	
	public void hideDownloadProgress(){
		downloadProgressBar.setVisibility(View.GONE) ;
		downloadProgressText.setVisibility(View.GONE) ;
	}
	
	private void reloadData(){
		if(!isLoading){
			isLoading = true ;
			LoadAudioDataTask loadAudioDataTask = new LoadAudioDataTask(this,audioObject.getId()) ;
			loadAudioDataTask.execute("") ;
		}
	}
	
	/*
	private void setTitleView(String title,String numberOfLikes){
		if(titleBackView != null){
			titleBackView.removeAllViews() ;
			
			TextView likesTextView = new TextView(this) ;
			likesTextView.setText(numberOfLikes) ;
			likesTextView.setGravity(Gravity.RIGHT) ;
			likesTextView.setTextSize((float)deviceWidth * 5.9f / 100 / scaledDensity) ;
			likesTextView.setPadding(0, 0, 0, 0) ;
			likesTextView.setTextColor(VeamUtil.getBaseTextColor(this)) ;
			//likesTextView.setTypeface(typefaceRobotoLight) ;
			TextPaint paint = likesTextView.getPaint() ;
			int likesTextWidth = (int)Layout.getDesiredWidth(numberOfLikes, paint) ;
			RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(likesTextWidth,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			relativeLayoutParams.setMargins(bottomTextViewWidth-likesTextWidth, 0, 0, 0) ;
			titleBackView.addView(likesTextView,relativeLayoutParams) ;
			
			int likeImageMargin = deviceWidth * 1 / 100 ;
			int likeImageWidth = deviceWidth * 7 / 100 ;
			int likeImageHeight = likeImageWidth * 36 / 44 ;
			ImageView likeMarkImageView = new ImageView(this) ;
			likeMarkImageView.setImageResource(R.drawable.like) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(likeImageWidth,likeImageHeight) ;
			relativeLayoutParams.setMargins(bottomTextViewWidth-likesTextWidth-likeImageWidth-likeImageMargin, deviceWidth*15/1000, 0, 0) ;
			titleBackView.addView(likeMarkImageView,relativeLayoutParams) ;
			
			TextView textView = new TextView(this) ;
			textView.setText(audioObject.getTitle()) ;
			textView.setText(title) ;
			textView.setTextSize((float)deviceWidth * 5.9f / 100 / scaledDensity) ;
			textView.setPadding(0, 0, 0, 0) ;
			//textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000")) ;
			textView.setTextColor(VeamUtil.getBaseTextColor(this)) ;
			//textView.setTypeface(typefaceRobotoLight) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(bottomTextViewWidth-likesTextWidth-likeImageWidth-likeImageMargin,LinearLayout.LayoutParams.WRAP_CONTENT) ;
			relativeLayoutParams.setMargins(0, 0, 0, 0) ;
			titleBackView.addView(textView,relativeLayoutParams) ;
		}
	}
	*/
	
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
			int commentsTextWidth = (int)Layout.getDesiredWidth(numberOfComments, paint) + deviceWidth * 1 / 100 ;
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
	private void setCommentView(ArrayList<AudioCommentObject> comments){
		commentAreaView.removeAllViews() ;
		int count = comments.size() ;
		int showCount = count ;
		if((count > 3) && ! isShowAllComments){
			showCount = 3 ;
		}
		
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth*85/100, LinearLayout.LayoutParams.WRAP_CONTENT) ;
		

		for(int index = 0 ; index < showCount ; index++){
			AudioCommentObject comment = comments.get(index) ;
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
			commentAreaView.addView(textView, linearLayoutParams) ;

		}

	}
	
	@Override
	public void onDestroy() {
		/*
	    if(mDb != null){
	    	mDb.close() ;
    	    //VeamUtil.log("debug","DB CLOSE "+this.getClass().getName()) ;
	    	mDb = null ;
	    }
	    */
		//VeamUtil.log("debug","AudioPlayActivity::onDestroy()") ;
		this.stopAudioService();
		/*
		unbindService(serviceConnection);
		stopService(backgroundSoundServiceIntent) ;
		*/
	    super.onDestroy();
	}

	

	@Override
	public void onClick(View view) {
		if(view.getId() == VIEWID_TOP_BAR_BACK_BUTTON){

            if(currentView == VIEW_WEB){
                this.doTranslateAnimation(scrollView, 300, -deviceWidth, 0, 0, 0, null, null) ;
                this.doTranslateAnimation(webView, 300, 0, deviceWidth, 0, 0, "removeWeb", null) ;
                currentView = VIEW_MAIN ;
            } else {
                this.finish();
                overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
            }
		} else if(view.getId() == VIEWID_COMMENT_BUTTON){
			//VeamUtil.log("debug","forumListView") ;
			if(VeamUtil.isLogin(this)){
				this.operateCommentButton() ;
			} else {
				pendingOperation = PENDING_OPERATION_COMMENT ;
				this.login() ;
			}
			
		} else if(view.getId() == VIEWID_FOLD_COMMENT){
			if(currentAudioData != null){
				isShowAllComments = !isShowAllComments ;
				this.setCommentView(currentAudioData.getComments()) ;
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
		} else if(view.getId() == VIEWID_CENTER_PLAY){
			playAudio() ;
        } else if(view.getId() == VIEWID_LINK){
            //VeamUtil.log("debug", "link tapped " + audioObject.getLinkUrl()) ;
            //String viewerUrl = String.format("http://docs.google.com/gview?embedded=true&url=%s",audioObject.getLinkUrl()) ;
            String viewerUrl = VeamUtil.getPdfViewerUrl(this,audioObject.getLinkUrl()) ;
            this.createWebView(rootLayout,viewerUrl, audioObject.getTitle(),false,true,false) ;
            this.doTranslateAnimation(scrollView, 300, 0, -deviceWidth, 0, 0, null, null) ;
            this.doTranslateAnimation(webView, 300, deviceWidth, 0, 0, 0, null, null) ;
            currentView = VIEW_WEB ;
        } else if(view.getId() == VIEWID_PLAY_BUTTON){
			if(backgroundSoundService != null){
				if(backgroundSoundService.isPlaying()){
					this.pauseAudio() ;
				} else {
					this.startAudio();
				}
			}
		}
	}


	private ServiceConnection serviceConnection = new ServiceConnection() {
		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			BackgroundSoundService.LocalBinder binder = (BackgroundSoundService.LocalBinder)service;
			backgroundSoundService = binder.getService();
		}

		@Override
		public void onServiceDisconnected(ComponentName name) {
		}
	};

	public void playAudio(){
		centerPlayImageView.setVisibility(View.GONE);
		playImageView.setVisibility(View.VISIBLE) ;
		if(backgroundSoundService != null){
			if(backgroundSoundService.isPlaying()){
				backgroundSoundService.stop() ;
			}
			backgroundSoundService.start();
		} else {
			//VeamUtil.log("debug", "start sound service");
			backgroundSoundServiceIntent = new Intent(this, BackgroundSoundService.class);
			backgroundSoundServiceIntent.putExtra("DATA_PATH", audioObject.getDataFilePath(this));
			startService(backgroundSoundServiceIntent) ;
			bindService(backgroundSoundServiceIntent, serviceConnection, 0);
		}
		this.startProgressCheck() ;



		/*
		mediaPlayer = new MediaPlayer();
		try {
			mediaPlayer.setDataSource(audioObject.getDataFilePath(this)) ;
			mediaPlayer.setOnCompletionListener(this) ;
			mediaPlayer.prepare() ;
			duration = mediaPlayer.getDuration() / 1000 ;
			mediaPlayer.start();
			isPlaying = true ;
			this.startProgressCheck() ;
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		*/
	}
	
	private void pauseAudio(){
		backgroundSoundService.pause() ;
		playImageView.setImageResource(R.drawable.p_play) ;
		this.stopProgressCheck() ;
		isPlaying = false ;
	}
	
	private void startAudio(){
		backgroundSoundService.start() ;
		playImageView.setImageResource(R.drawable.p_pause) ;
		this.startProgressCheck() ;
		isPlaying = true ;
	}
	
	private void stopProgressCheck(){
		if(timer != null){
			timer.cancel() ;
			timer = null ;
		}
		getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) ;
	}
	
	private void startProgressCheck(){
		this.stopProgressCheck() ;
		
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) ;
		
        timer = new Timer(true);        
        timer.schedule(new TimerTask() {
			@Override
			public void run() {
				// 再生時間表示
				//VeamUtil.log("debug","timer") ;
				if (backgroundSoundService != null) {
					if (backgroundSoundService.isPlaying()) {
						currentTimeMilli = backgroundSoundService.getCurrentPosition();
						//VeamUtil.log("debug","currentTimeMilli="+currentTimeMilli) ;
						int workDuration = 0;
						if (duration == 0) {
							workDuration = backgroundSoundService.getDuration() / 1000;
							duration = workDuration;
							//VeamUtil.log("debug","workDuration="+workDuration) ;
							final int durationToBeSet = workDuration;
							handler.post(new Runnable() {
								public void run() {
									String durationString = String.format("%d:%02d", durationToBeSet / 60, durationToBeSet % 60);
									durationTextView.setText(durationString);
								}
							});
						}
						if (currentTime != (currentTimeMilli / 1000)) {
							currentTime = (currentTimeMilli / 1000);
							final String timeString = String.format("%d:%02d", currentTime / 60, currentTime % 60);
							handler.post(new Runnable() {
								public void run() {
									currentTimeTextView.setText(timeString);
									if (duration > 0) {
										setSliderPoint();
										setCircleShadow();
									}
								}
							});
						}
					} else if (backgroundSoundService.isCompleted()) {
						handler.post(new Runnable() {
							public void run() {
								AudioPlayActivity.this.onCompletion();
							}
						});

					}
				}
			}
		}, 100, 300);

	}

	private void setCircleShadow() {
		float percentage = (float)currentTime / duration ;
        circleView.setPercentage(percentage) ;
    }

    private void setSliderPoint()
    {
    	if(!isPointDragging){
	    	int sliderWidth = sliderBase.getWidth() - sliderPointSize ;
	        int sliderHeight = sliderBase.getHeight() ;
	        int sliderPosition = sliderWidth * currentTime / duration ;
	        //VeamUtil.log("debug","sliderWidth="+sliderWidth + " sliderHeight="+sliderHeight + " currentTime="+currentTime+ " duration="+duration)  ;
	        int y = (sliderHeight - sliderPointSize) / 2 ;
	        //VeamUtil.log("debug","sliderPosition="+sliderPosition + " sliderBaseW="+sliderBase.getWidth() + " H="+sliderBase.getHeight())  ;
	        sliderPointImageView.layout(sliderPosition, y, sliderPosition+sliderPointSize, y+sliderPointSize) ;
	        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(sliderPointSize,sliderPointSize) ;
	        params.setMargins(sliderPosition, y, 0, 0) ;
	        sliderPointImageView.setLayoutParams(params) ;
    	}
    }


	public void operateLike(){
		//VeamUtil.log("debug","operateLike") ;
		
		pendingOperation = PENDING_OPERATION_NONE ;
		
		String audioId = audioObject.getId() ;
		
		boolean isLike = false ;
		if(currentAudioData != null){
			isLike = currentAudioData.isLike ;
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
		
		SendAudioLikeTask sendAudioLikeTask = new SendAudioLikeTask(this,audioId,isLike) ;
		sendAudioLikeTask.execute("") ;
	}



	public void updateAudioData(AudioDataXml audioData){
		isLoading = false ;
		currentAudioData = audioData ;

		//VeamUtil.log("debug","updateAudioData  likes:"+audioData.numberOfLikes + " comments:" + audioData.getNumberOfComments()) ;

		if(audioData.isLike){
			//this.likeButtonImageView.setImageResource(R.drawable.forum_like_button_on) ;
			likeButtonImageView.setImageBitmap(VeamUtil.getThemeImage(this, "forum_like_button_on", 1)) ;
		} else {
			this.likeButtonImageView.setImageResource(R.drawable.forum_like_button_off) ;
		}
		
		this.setInfoView(String.format("%d", audioData.numberOfLikes),String.format("%d", audioData.getNumberOfComments())) ;
		this.setCommentView(audioData.getComments()) ;
	}

	public void onAudioDataLoadFailed() {
		
	}
	
	public void operateCommentButton(){
		//VeamUtil.log("debug","pictureId = "+currentPictureObject.getId()) ;
		Intent postCommentIntent = new Intent(this,PostAudioCommentActivity.class) ;
		postCommentIntent.putExtra("audio_id", audioObject.getId()) ;
		startActivityForResult(postCommentIntent,REQUEST_POST_COMMENT_ACTIVITY) ;
		overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
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

	public void sendAudioLikeDone(Integer resultCode) {
		this.reloadData() ;
		if(VeamUtil.isSubscriptionFree(this)){
			//VeamUtil.kickKiip(this,"AudioLike") ;
		}
	}

	@Override
	public void onLoadDataCompleted(Integer resultCode) {
		//VeamUtil.log("debug","onLoadDataCompleted " + resultCode) ;
		if(resultCode == 1){
			this.hideDownloadProgress() ;
			centerPlayImageView.setVisibility(View.VISIBLE);
		}
	}

	@Override
	public void onLoadDataProgress(int progress) {
		//VeamUtil.log("debug", "onLoadDataProgress:"+progress);
		final int targetProgress = progress ;
        handler.post( new Runnable() { public void run() {
        	downloadProgressText.setText(String.format("%d%%",targetProgress)) ;
        }});
	}

	@Override
	public void onCompletion(MediaPlayer player) {
		centerPlayImageView.setImageResource(R.drawable.audio_replay) ;
		centerPlayImageView.setVisibility(View.VISIBLE);
		circleView.setPercentage(0.0f) ;
		playImageView.setVisibility(View.GONE) ;
		this.stopProgressCheck() ;
		isPlaying = false ;
	}

	public void onCompletion() {
		centerPlayImageView.setImageResource(R.drawable.audio_replay) ;
		centerPlayImageView.setVisibility(View.VISIBLE);
		circleView.setPercentage(0.0f) ;
		playImageView.setVisibility(View.GONE) ;
		this.stopProgressCheck() ;
		isPlaying = false ;
	}

	@Override
	public boolean onTouch(View view, MotionEvent event) {
		if(view.getId() == VIEWID_SLIDER_POINT){
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
			} else /* if (event.getAction() == MotionEvent.ACTION_UP)*/ {
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
				if(backgroundSoundService != null){
					backgroundSoundService.seekTo(targetTime) ;
				}
				/*
			} else {
				//VeamUtil.log("debug","another action " + MotionEvent.ACTION_SCROLL) ;
				*/
			}
		} else if(view.getId() == VIEWID_SCROLL_VIEW){
			//VeamUtil.log("debug","onTouch scroll") ;
		}
		
		return true ;
	}

	/*
	@Override
    protected void onPause () {
        super.onPause ();
        if(this.mediaPlayer != null){
        	if(this.backgroundSoundService.isPlaying()){
        		this.pauseAudio() ;
        	}
        }
    }
	
	@Override
	public void onResume(){
		super.onResume();
        if(isPlaying && (this.mediaPlayer != null)){
      		this.startAudio() ;
        }
	}
	*/

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

    public void loginFacebook(){
        //VeamUtil.log("debug","loginFacebook") ;
        this.facebookLogin() ;
    }

    public void loginTwitter(){
        //VeamUtil.log("debug","loginTwitter") ;
        this.twitterLogin() ;
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


	@Override
	public void onStop() {
		super.onStop();
		// Unbind
		//VeamUtil.log("debug","AudioPlayActivity::onStop()") ;
		/*
		stopService(backgroundSoundServiceIntent) ;
		unbindService(serviceConnection);
		*/
	}


	private void stopAudioService(){
		if(backgroundSoundService != null) {
			if (backgroundSoundServiceIntent != null) {
				unbindService(serviceConnection);
				stopService(backgroundSoundServiceIntent);
			}
			backgroundSoundService = null ;
		}
	}

	@Override
	public void onResume() {
		super.onResume();
		this.stopAudioService();
	}


}
