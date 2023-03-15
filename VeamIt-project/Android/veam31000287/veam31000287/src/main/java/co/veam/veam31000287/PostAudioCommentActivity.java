package co.veam.veam31000287;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;


public class PostAudioCommentActivity extends VeamActivity implements OnClickListener {
	// カメラインスタンス
    //private RelativeLayout mainView ;
	private RelativeLayout rootLayout ;
	private String audioId ;
	private EditText commentEditText ;
	private ProgressBar postProgressBar ;
	private TextView postTextView ;
	
	

	private int VIEWID_POST_BUTTON		= 0x10001 ;
	private int VIEWID_COMMENT_TEXT		= 0x10002 ;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		/*
		getWindow().setSoftInputMode(
				WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN|
				WindowManager.LayoutParams. SOFT_INPUT_ADJUST_PAN);
				*/
        setContentView(R.layout.activity_videos) ;
        
		
		Intent intent = getIntent();
		audioId = intent.getStringExtra("audio_id") ;

		this.pageName = String.format("PostAudioComment/%s",audioId) ;

		RelativeLayout.LayoutParams layoutParams ;
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		
		// add logo
	    ImageView backgroundImageView = new ImageView(this);
	    backgroundImageView.setImageResource(R.drawable.background);
	    backgroundImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
	    layoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceHeight) ;
	    rootLayout.addView(backgroundImageView,layoutParams) ;

		
		
		Typeface typefaceRobotoLight = Typeface.SANS_SERIF ; 
		
		commentEditText = new EditText(this) ;
		commentEditText.setId(VIEWID_COMMENT_TEXT) ;
		commentEditText.setBackgroundColor(Color.argb(0x77,0xFF,0xFF,0xFF)) ;
		commentEditText.setGravity(Gravity.TOP) ;
		commentEditText.setTypeface(typefaceRobotoLight) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*94/100,deviceWidth * 45 / 100) ;
		layoutParams.setMargins(deviceWidth*3/100, topBarHeight+deviceWidth*3/100, 0, 0) ;
		rootLayout.addView(commentEditText,layoutParams) ;

		this.addTopBar(rootLayout, this.getString(R.string.comment),true,false) ;
		
		postTextView = new TextView(this) ;
		postTextView.setOnClickListener(this) ;
		postTextView.setId(VIEWID_POST_BUTTON) ;
		postTextView.setText(this.getString(R.string.post)) ;
		//postTextView.setTextColor(Color.argb(0xFF,0xFF,0x62,0xBD)) ;
		postTextView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
		postTextView.setGravity(Gravity.CENTER_VERTICAL) ;
		postTextView.setPadding(0, 0, 0, 0) ;
		postTextView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*16/100,topBarHeight) ;
		relativeLayoutParams.setMargins(deviceWidth*84/100, 0, 0, 0) ;
		rootLayout.addView(postTextView, relativeLayoutParams) ;

		postProgressBar = new ProgressBar(this) ;
		postProgressBar.setIndeterminate(true) ;
		postProgressBar.setVisibility(View.GONE) ;
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth*10/100,deviceWidth*10/100) ;
		layoutParams.setMargins(deviceWidth * 84 / 100, deviceWidth * 2 / 100, 0, 0) ;
		rootLayout.addView(postProgressBar,layoutParams) ;
		
		commentEditText.requestFocus() ;
		InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
		inputMethodManager.showSoftInput(commentEditText, 0);
		
		
		
		commentEditText.requestFocus() ;
		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);		
    }
    
	public void operatePostComment(){
		String comment = commentEditText.getText().toString() ;
		if(VeamUtil.isEmpty(comment)){
			VeamUtil.showMessage(this, this.getString(R.string.please_input_comment)) ;
		} else {
			PostAudioCommentTask postCommentTask = new PostAudioCommentTask(this,audioId,comment) ;
			postCommentTask.execute("") ;
			postProgressBar.setVisibility(View.VISIBLE) ;
			postTextView.setVisibility(View.GONE);
		}
	}
	
    
    
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","ImageShareActivity::onClick") ;
		if(view.getId() == VIEWID_TOP_BAR_BACK_BUTTON){
			//VeamUtil.log("debug","back button tapped") ;
			this.finish() ;
			overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out) ;
		} else 	if(view.getId() == VIEWID_POST_BUTTON){
			//VeamUtil.log("debug","post button tapped") ;
			this.operatePostComment() ;
		}
	}
	
    @Override
    protected void onPause() {
        super.onPause();
    }
    

	public void onPostCommentFinished(AudioCommentObject audioCommentObject){
		//VeamUtil.log("debug","onPostCommentFinished") ;
		postProgressBar.setVisibility(View.GONE) ;
		postTextView.setVisibility(View.VISIBLE); 
		if(audioCommentObject != null){
			//VeamUtil.log("debug","audioCommentObject != null") ;
			this.setResult(1) ;
			this.finish() ;
		} else {
			
		}
	}

}