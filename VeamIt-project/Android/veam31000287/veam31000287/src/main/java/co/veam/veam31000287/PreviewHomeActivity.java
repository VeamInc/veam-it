package co.veam.veam31000287;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.io.Console;

/**
 * Created by veam on 5/27/16.
 */
public class PreviewHomeActivity extends VeamActivity implements View.OnClickListener ,UpdateContentTask.UpdateContentTaskActivityInterface,UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    private DatabaseHelper helper ;

    private RelativeLayout rootLayout ;

    private final int VIEWID_BACKGROUND 	= 0x10001 ;
    private final int VIEWID_APP_TEXT	 	= 0x10002 ;
    private final int VIEWID_APP_IMAGE  	= 0x10003 ;

    private Handler handler = new Handler();

    private RoundImageView appImageView ;
    private TextView appTextView ;
    private ProgressBar progressBar ;
    private CircleView circleView ;

    private boolean isLoading = true ;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_preview_home);
        RelativeLayout.LayoutParams layoutParams ;

        pageName = "PreviewHome" ;

        if(VeamUtil.isPreviewMode()) {
            try {
                rootLayout = (RelativeLayout) this.findViewById(R.id.rootLayout);

                try {
                    baseBackgroundImageView = new ImageView(this);
                    baseBackgroundImageView.setImageResource(R.drawable.background);
                    baseBackgroundImageView.setImageBitmap(VeamUtil.getThemeImage(this, "c_home_background0", 4));
                    baseBackgroundImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
                    baseBackgroundImageView.setVisibility(View.VISIBLE);
                    rootLayout.addView(baseBackgroundImageView, createParam(deviceWidth, deviceHeight));
                } catch (OutOfMemoryError e) {
                    //VeamUtil.log("debug","OutOfMemory") ;
                }

                int iconSize = (int)(deviceWidth * 30 / 100 / scaledDensity) ;
                float textSize =  (float)deviceWidth * 2.5f / 100 / scaledDensity ;
                int currentY = topBarHeight+deviceWidth*3/100 ;
                int currentX = deviceWidth * 5 / 100 ;

                Typeface typefaceRobotoLight = Typeface.SANS_SERIF ;

                appImageView = new RoundImageView(this) ;
                appImageView.setRadius(iconSize * 23f / 100f);
                appImageView.setId(VIEWID_APP_IMAGE) ;
                appImageView.setImageBitmap(VeamUtil.getThemeImage(this, "c_small_icon", 1));
                //appImageView.setImageBitmap(VeamUtil.getThemeImage(this, "c_veam_icon", 1));
                appImageView.setOnClickListener(this);
                layoutParams = new RelativeLayout.LayoutParams(iconSize,iconSize) ;
                layoutParams.setMargins(currentX, currentY, 0, 0) ;
                rootLayout.addView(appImageView, layoutParams) ;

                progressBar = new ProgressBar(this,null,android.R.attr.progressBarStyleLarge);
                progressBar.setIndeterminate(true);
                progressBar.setVisibility(View.VISIBLE);
                layoutParams = new RelativeLayout.LayoutParams(iconSize,iconSize) ;
                layoutParams.setMargins(currentX, currentY, 0, 0) ;
                rootLayout.addView(progressBar, layoutParams) ;

                circleView = new CircleView(this) ;
                circleView.setOval(new RectF(0.0f, 0.0f, iconSize,iconSize)) ;
                circleView.setPercentage(0.0f) ;
                circleView.setColor(VeamUtil.getColorFromArgbString("99000000")) ;
                circleView.setVisibility(View.VISIBLE);
                layoutParams = new RelativeLayout.LayoutParams(iconSize,iconSize) ;
                layoutParams.setMargins(currentX, currentY, 0, 0) ;
                rootLayout.addView(circleView,layoutParams) ;


                currentY += iconSize ;

                appTextView = new TextView(this) ;
                appTextView.setId(VIEWID_APP_TEXT) ;
                appTextView.setGravity(Gravity.CENTER_HORIZONTAL) ;
                appTextView.setTextSize(textSize);
                appTextView.setTextColor(Color.WHITE);
                appTextView.setText("Loading..");
                layoutParams = new RelativeLayout.LayoutParams(iconSize,iconSize) ;
                layoutParams.setMargins(currentX, currentY, 0, 0) ;
                rootLayout.addView(appTextView, layoutParams) ;

            } catch (OutOfMemoryError e) {
                //VeamUtil.log("OutOfMemory") ;
            }


        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        VeamUtil.log("debug","PreviewHomeActivity::onResume") ;

    }

    @Override
    public void onStart() {
        super.onStart();
        VeamUtil.log("debug", "PreviewHomeActivity::onStart") ;
        progressBar.setVisibility(View.VISIBLE) ;
        circleView.setVisibility(View.VISIBLE) ;
        appTextView.setText("Loading..") ;
        if(circleView != null) {
            circleView.setPercentage(0.0f);
        }
        isLoading = true ;
        UpdateConsoleContentTask updateConsoleContentTask = new UpdateConsoleContentTask(this,this) ;
        updateConsoleContentTask.execute() ;
    }

    @Override
    public void onClick(View view) {
        super.onClick(view) ;
        //VeamUtil.log("debug", "onClick") ;
        if(view.getId() == VIEWID_APP_IMAGE){
            if(!isLoading){
                if(this.isInitializingApp()){

                    Intent intent = new Intent(this,ConsoleStarterTutorialActivity.class) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,"") ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.next)) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, false) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_BLACKMODE, true) ;
                    intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
                    startActivity(intent);
                    overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
                } else {
                    Intent intent = new Intent(this, InitialActivity.class);
                    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    intent.putExtra("LAUNCHED_BY_PREVIEW_HOME", true);
                    startActivity(intent);
                }
            }
        }
    }

    @Override
    public void onUpdateConsoleContentFinished(Integer resultCode) {
        VeamUtil.log("debug", "onUpdateConsoleContentFinished:"+resultCode) ;
        VeamUtil.log("debug", "appId:"+ConsoleUtil.getAppId()) ;

        if(circleView != null){
            circleView.setPercentage(consoleContentPercentage);
        }

        UpdateContentTask updateContentTask = new UpdateContentTask(this,this) ;
        updateContentTask.execute() ;
    }


    private final float consoleContentPercentage = 0.3f ;
    /*
    @Override
    public void onUpdateConsoleContentProgress(Integer percentage) {
        if(circleView != null){
            float floatPercentage = (float)percentage / 100.0f ;
            floatPercentage *= consoleContentPercentage ;
            circleView.setPercentage(floatPercentage);
        }
    }
    */

    public boolean isInitializingApp(){
        boolean isInitializing = false ;

        VeamUtil.log("debug","isInitializingApp status="+ ConsoleUtil.getAppStatus()) ;

        if(ConsoleUtil.getAppStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_INITIALIZED)){
            isInitializing = true ;
        }

        return isInitializing ;

    }

    @Override
    public void onUpdateFinished(Integer resultCode) {
        VeamUtil.log("debug", "onUpdateFinished:" + resultCode) ;
        appImageView.setImageBitmap(VeamUtil.getThemeImage(this, "c_small_icon", 1)) ;
        progressBar.setVisibility(View.GONE) ;
        circleView.setVisibility(View.GONE) ;
        String appName = VeamUtil.getAppName(this) ;
        if(this.isInitializingApp()){
            appName = "Start" ;
        }
        appTextView.setText(appName) ;
        isLoading = false ;
    }

    @Override
    public void onUpdateContentProgress(Integer percentage) {
        VeamUtil.log("debug", "onUpdateContentProgress:"+percentage) ;
        if(circleView != null){
            float floatPercentage = (float)percentage / 100.0f ;
            floatPercentage *= (1.0f - consoleContentPercentage) ;
            floatPercentage += consoleContentPercentage ;
            circleView.setPercentage(floatPercentage);
        }
    }
}
