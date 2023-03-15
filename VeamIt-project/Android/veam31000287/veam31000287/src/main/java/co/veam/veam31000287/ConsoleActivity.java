package co.veam.veam31000287;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.text.Layout;
import android.text.TextPaint;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.Interpolator;
import android.view.animation.TranslateAnimation;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.dropbox.client2.android.AndroidAuthSession;
import com.google.android.gms.ads.AdSize;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by veam on 11/9/16.
 */
public class ConsoleActivity extends VeamActivity implements View.OnClickListener, AdapterView.OnItemClickListener {


    public static final int REQUEST_CODE_DROPBOX_ACTIVITY   = 1 ;

    protected static final int VIEWID_BASE = 0x8000 ;

    public static final int VIEWID_HEADER_RIGHT_TEXT   = 0x0001 ;
    public static final int VIEWID_HEADER_CLOSE        = 0x0002 ;
    public static final int VIEWID_HEADER_BACK         = 0x0003 ;
    public static final int VIEWID_FLOATING_TEXT1      = 0x0004 ;
    public static final int VIEWID_FLOATING_TEXT2      = 0x0005 ;
    public static final int VIEWID_FLOATING_TEXT3      = 0x0006 ;
    public static final int VIEWID_LIST_DELETE         = 0x0007 ;
    //public static final int VIEWID_TAB_BUTTON          = 0x0008 ;


    protected static final int FLOATING_MENU_KIND_NONE                    = 0 ;
    protected static final int FLOATING_MENU_KIND_EDIT                    = 2 ;
    protected static final int FLOATING_MENU_KIND_EDIT_AND_TUTORIAL       = 3 ;

    private IntentFilter mIntentFilter;


    protected RelativeLayout rootLayout ;
    protected RelativeLayout mainView ;
    protected RelativeLayout swipeView ;
    protected RelativeLayout contentView ;
    protected int deviceWidth ;
    protected int deviceHeight ;
    protected float scaledDensity ;
    protected int topBarHeight = 0 ;
    protected int headerHeight ;

    protected boolean launchFromPreview ;
    protected boolean hideHeaderBottomLine ;
    protected boolean showFooter ;
    protected boolean blackMode ;
    protected int headerStyle ;
    protected int numberOfHeaderDots ;
    protected int selectedHeaderDot ;
    protected int contentMode ;
    protected String headerTitle ;
    protected String headerRightText ;
    //protected ListView mainListView ;
    protected TouchInterceptor mainListView ;


    protected boolean needUpdateTimer = false ;
    protected Timer updateTimer ;

    protected int templateId = 0 ;
    /*
    protected int tabHeight = 0;
    protected int tabNo = 0;
    protected ImageView tabBackImageView;
    protected ImageView tabSelectedImageView;
    protected ImageView[] tabImageViews;
    protected TextView[] tabTitleViews;
    protected View[] tabButtonViews;
    protected int viewHeight = 0;
    protected int numberOfTabs;
    */






    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        preventUpdateOnResume = true ;

        if(VeamUtil.isPreviewMode()) {

            mReceiver = new ConsoleDataPostCompletionReceiver();
            mIntentFilter = new IntentFilter();
            mIntentFilter.addAction(ConsoleUtil.VEAM_CONSOLE_NOTIFICATION_ID_CONTENT_POST_COMPLETED);
            registerReceiver(mReceiver, mIntentFilter);

            handler = new Handler();

            DisplayMetrics metrics = new DisplayMetrics();
            this.getWindowManager().getDefaultDisplay().getMetrics(metrics);

            scaledDensity = metrics.scaledDensity;
            deviceWidth = metrics.widthPixels;
            deviceHeight = metrics.heightPixels;
            topBarHeight = deviceWidth * 14 / 100;

            Intent intent = this.getIntent();
            launchFromPreview = intent.getBooleanExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, false);
            hideHeaderBottomLine = intent.getBooleanExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
            showFooter = intent.getBooleanExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, false);
            blackMode = intent.getBooleanExtra(ConsoleUtil.VEAM_CONSOLE_BLACKMODE, false);
            templateId = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID,0) ;
            headerStyle = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
            numberOfHeaderDots = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 0);
            selectedHeaderDot = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 0);
            contentMode = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
            headerTitle = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE);
            headerRightText = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT);
            if (headerTitle == null) {
                headerTitle = " ";
            }
        }
    }

    @Override
    protected void onResume(){
        super.onResume();
        VeamUtil.log("debug", "ConsoleActivity::onResume") ;
        if(needUpdateTimer){
            updateTimer = new Timer(true);
            updateTimer.schedule( new TimerTask(){
                @Override
                public void run() {
                    doUpdate();
                }
            }, 30000, 30000);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        VeamUtil.log("debug", "ConsoleActivity::onPause");
        if(updateTimer != null){
            updateTimer.cancel();
            updateTimer = null ;
        }
    }

    protected void doUpdate(){
        VeamUtil.log("debug", "ConsoleActivity::doUpdate should be overridden");
    }

    protected void addMainList(ConsoleBaseAdapter adapter){
        VeamUtil.log("debug", "ConsoleActivity::addMainList") ;
        if(mainView != null) {
            VeamUtil.log("debug", "mainview exists") ;
            int listHeight = deviceHeight - topBarHeight ;

            /*
            RelativeLayout footerView = new RelativeLayout(this) ;
            footerView.setBackgroundColor(Color.TRANSPARENT);
            LinearLayout spacerView = new LinearLayout(this) ;
            spacerView.setBackgroundColor(Color.TRANSPARENT);
            footerView.addView(spacerView,ConsoleUtil.getRelativeLayoutPrams(0,0,deviceWidth,deviceWidth*30/100));
            */

            mainListView = new TouchInterceptor(this);
            //mainListView.addFooterView(footerView);
            mainListView.setSelector(new ColorDrawable(Color.argb(0x00, 0xFD, 0xD4, 0xDB)));
            mainListView.setOnItemClickListener(this);
            mainListView.setBackgroundColor(Color.TRANSPARENT);
            mainListView.setCacheColorHint(Color.TRANSPARENT);
            mainListView.setVerticalScrollBarEnabled(false);
            mainListView.setPadding(0, 0, 0, deviceWidth * 50 / 100);
            mainListView.setClipToPadding(false);
            mainListView.setDivider(null);
            mainListView.setConsoleBaseAdapter(adapter);
            mainView.addView(mainListView, ConsoleUtil.getRelativeLayoutPrams(0, topBarHeight, deviceWidth, listHeight));

            /*
            swipeView = new RelativeLayout(this);
            swipeView.setBackgroundColor(Color.TRANSPARENT);
            rootLayout.addView(swipeView, new RelativeLayout.LayoutParams(deviceWidth, deviceHeight));
            */
            setSwipeView(mainListView);


        }
    }

    protected void addHeader(){
        if(mainView != null) {
            RelativeLayout headerView = new RelativeLayout(this);
            if(blackMode) {
                headerView.setBackgroundColor(Color.BLACK);
            } else {
                headerView.setBackgroundColor(Color.WHITE);
            }
            mainView.addView(headerView, ConsoleUtil.getRelativeLayoutPrams(0, 0, deviceWidth, topBarHeight));

            int currentLeftX = 0;
            int currentRightX = deviceWidth;
            if ((headerStyle & ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) != 0) {
                ImageView backImage = new ImageView(this);
                backImage.setImageResource(R.drawable.c_top_back);
                backImage.setId(VIEWID_HEADER_BACK);
                backImage.setOnClickListener(this);
                headerView.addView(backImage, ConsoleUtil.getRelativeLayoutPrams(0, 0, topBarHeight, topBarHeight));
                currentLeftX += topBarHeight;

                int veamIconSize = deviceWidth * 10 / 100;
                ImageView veamImage = new ImageView(this);
                veamImage.setId(VIEWID_SIGN_OUT_BUTTON) ;
                veamImage.setImageResource(R.drawable.c_top_veam);
                veamImage.setScaleType(ImageView.ScaleType.CENTER_CROP);
                veamImage.setOnClickListener(this);
                headerView.addView(veamImage, ConsoleUtil.getRelativeLayoutPrams(currentRightX - veamIconSize, (topBarHeight - veamIconSize) / 2, veamIconSize, veamIconSize));
                currentRightX -= veamIconSize;
            }

            if ((headerStyle & ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE) != 0) {
                ImageView closeImage = new ImageView(this);
                closeImage.setImageResource(R.drawable.c_top_close);
                closeImage.setId(VIEWID_HEADER_CLOSE);
                closeImage.setOnClickListener(this);
                headerView.addView(closeImage, ConsoleUtil.getRelativeLayoutPrams(0, 0, topBarHeight, topBarHeight));
                currentLeftX += topBarHeight;
            }

            if ((headerStyle & ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) != 0) {
                TextView rightLabel = new TextView(this);
                rightLabel.setBackgroundColor(Color.TRANSPARENT);
                rightLabel.setTextColor(Color.RED);
                rightLabel.setText(headerRightText);
                rightLabel.setTextSize((float) deviceWidth * 5.0f / 100 / scaledDensity);
                rightLabel.setId(VIEWID_HEADER_RIGHT_TEXT) ;
                rightLabel.setOnClickListener(this);
                rightLabel.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT);
                TextPaint paint = rightLabel.getPaint();
                int textWidth = (int) Layout.getDesiredWidth(headerRightText, paint);
                currentRightX -= deviceWidth / 40; // margin
                currentRightX -= textWidth;
                headerView.addView(rightLabel, ConsoleUtil.getRelativeLayoutPrams(currentRightX, 0, textWidth, topBarHeight));
            }

            int fromRight = deviceWidth - currentRightX;
            int margin = 0;
            if (currentLeftX < fromRight) {
                margin = fromRight;
            } else {
                margin = currentLeftX;
            }
            int titleHeight = topBarHeight;
            if (this.numberOfHeaderDots > 1) {
                titleHeight = titleHeight * 35 / 45;
            }

            int headerWidth = deviceWidth - margin * 2 ;
            TextView headerTitleLabel = new TextView(this);
            headerTitleLabel.setBackgroundColor(Color.TRANSPARENT);
            headerTitleLabel.setTextColor(Color.RED);
            headerTitleLabel.setText(headerTitle);
            headerTitleLabel.setGravity(Gravity.CENTER);
            headerTitleLabel.setTextSize((float) deviceWidth * 5.0f / 100 / scaledDensity);
            headerView.addView(headerTitleLabel, ConsoleUtil.getRelativeLayoutPrams(margin, 0, deviceWidth - margin * 2, titleHeight));
            ConsoleUtil.setTextSizeWithin(headerWidth, headerTitleLabel);

            if (this.numberOfHeaderDots > 1) {
                int imageSize = deviceWidth * 4 / 320;
                int imageGap = deviceWidth * 3 / 320;
                int currentX = (deviceWidth / 2) - ((this.numberOfHeaderDots - 1) * (imageSize + imageGap) / 2);
                int dotY = topBarHeight * 35 / 45;
                for (int index = 0; index < this.numberOfHeaderDots; index++) {
                    //NSLog(@"dot x=%f",currentX) ;
                    ImageView dotImageView = new ImageView(this);
                    if (index == this.selectedHeaderDot) {
                        dotImageView.setImageResource(R.drawable.c_top_dot_on);
                    } else {
                        dotImageView.setImageResource(R.drawable.c_top_dot_off);
                    }
                    headerView.addView(dotImageView, ConsoleUtil.getRelativeLayoutPrams(currentX, dotY, imageSize, imageSize));
                    currentX += imageSize + imageGap;
                }
            }


            if (!hideHeaderBottomLine) {
                View bottomLine = new View(this);
                bottomLine.setBackgroundColor(Color.BLACK);
                headerView.addView(bottomLine, ConsoleUtil.getRelativeLayoutPrams(0, topBarHeight - 1, deviceWidth, 1));
            }
        }
    }

    protected void setupViews(){

        if(rootLayout != null) {
            int viewHeight = deviceHeight - ConsoleUtil.getStatusBarHeight();
            mainView = new RelativeLayout(this);
            if(blackMode) {
                mainView.setBackgroundColor(Color.BLACK);
            } else {
                mainView.setBackgroundColor(Color.WHITE);
            }
            rootLayout.addView(mainView, new RelativeLayout.LayoutParams(deviceWidth, viewHeight));

            if(headerStyle != ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_NONE){
                this.addHeader() ;
            }

           if(showFooter){
               this.addTab(rootLayout,templateId,true);
            }

            createFloatingMenu(rootLayout) ;
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        VeamUtil.log("debug", "ConsoleActivity::onClick ") ;
        if(v.getId() == VIEWID_HEADER_RIGHT_TEXT) {
            onHeaderRightTextClicked(v);
        } else if(v.getId() == VIEWID_HEADER_CLOSE){
            onHeaderCloseClicked(v);
        } else if(v.getId() == VIEWID_HEADER_BACK){
            onHeaderBackClicked(v);
        } else if(v.getId() == VIEWID_FLOATING_TEXT1){
            VeamUtil.log("debug","floating text 1") ;
            if(getCurrentFloatingMenuPosition() == 1){
                this.finishHorizontal();
            }
        } else if(v.getId() == VIEWID_FLOATING_TEXT2){
            VeamUtil.log("debug","floating text 2") ;
        } else if(v.getId() == VIEWID_FLOATING_TEXT3){
            VeamUtil.log("debug","floating text 3") ;
        }
    }

    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleActivity::onHeaderRightTextClicked ") ;
    }

    public void onHeaderCloseClicked(View v) {
        VeamUtil.log("debug", "ConsoleActivity::onHeaderCloseClicked ") ;
    }

    public void onHeaderBackClicked(View v) {
        VeamUtil.log("debug", "ConsoleActivity::onHeaderBackClicked ") ;
        this.finishHorizontal();
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        VeamUtil.log("debug", "ConsoleActivity::onItemClick " + position) ;
    }

    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "ConsoleActivity::onConsoleDataPostDone " + apiName) ;
    }

    public void onConsoleDataPostFailed(String apiName){
        VeamUtil.log("debug", "ConsoleActivity::onConsoleDataPostFailed " + apiName) ;
    }

    ConsoleDataPostCompletionReceiver mReceiver;

    public void onClickStopButton(int position) {
        VeamUtil.log("debug", "onClickStopButton should be overridden") ;
    }

    public void onClickRemoveButton(int position) {
        VeamUtil.log("debug", "onClickRemoveButton should be overridden") ;
    }

    private class ConsoleDataPostCompletionReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getStringExtra("ACTION");
            String apiName = intent.getStringExtra("API_NAME");
            if(!VeamUtil.isEmpty(action)){
                if(action.equals(ConsoleUtil.VEAM_CONSOLE_NOTIFICATION_CONTENT_POST_DONE)) {
                    ConsoleActivity.this.onConsoleDataPostDone(apiName);
                } else if(action.equals(ConsoleUtil.VEAM_CONSOLE_NOTIFICATION_CONTENT_POST_FAILED)) {
                    ConsoleActivity.this.onConsoleDataPostFailed(apiName);
                }
            }
            VeamUtil.log("debug", "ConsoleDataPostCompletionReceiver::onReceive " + apiName) ;
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




    protected void doTranslateAnimation(View view, long duration, float fromX, float toX, float fromY, float toY, String nextAction, Interpolator interpolator) {
        TranslateAnimation animation = new TranslateAnimation(fromX, toX, fromY, toY);
        if (interpolator != null) {
            animation.setInterpolator(interpolator);
        }
        this.doAnimation(animation, view, duration, nextAction);
    }

    protected void doAnimation(Animation animation, View view, long duration, String nextAction) {
        final ConsoleActivity activity = this;
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
                        method.invoke(activity, (Object[]) null);
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

    protected int getFloatingMenuKind(){
        return FLOATING_MENU_KIND_NONE ;
    }

    @Override
    protected int getCurrentFloatingMenuPosition(){
        return 1 ;
    }

    /*
     protected void createFloatingMenu(){
         VeamUtil.log("debug", "createFloatingMenu") ;
         if(rootLayout != null) {
             VeamUtil.log("debug", "rootLayout != null");
             String[] elements;
             int kind = this.getFloatingMenuKind();
             if (kind != FLOATING_MENU_KIND_NONE) {
                 if(kind == FLOATING_MENU_KIND_EDIT_AND_TUTORIAL){
                     String[] workElements = {"Preview","Edit Mode","Tutorial"} ;
                     elements = workElements ;
                 } else {
                     String[] workElements = {"Preview","Edit Mode"} ;
                     elements = workElements ;
                 }

                 int length = elements.length ;
                 int elementWidth = deviceWidth * 20 / 100 ;
                 int elementHeight = deviceWidth * 7 / 100 ;
                 int sideMargin = deviceWidth * 4 / 100 ;
                 int floatingMenuWidth = elementWidth * length + sideMargin * 2 ;

                 floatingMenuView = new RelativeLayout(this);
                 floatingMenuView.setBackgroundColor(VeamUtil.getColorFromArgbString("FFDDDDDD"));
                 for(int index = 0 ; index < length ; index++){
                     TextView textView = new TextView(this);
                     switch (index){
                         case 0:
                             textView.setId(VIEWID_FLOATING_TEXT1);
                             break ;
                         case 1:
                             textView.setId(VIEWID_FLOATING_TEXT2);
                             break ;
                         case 2:
                             textView.setId(VIEWID_FLOATING_TEXT3);
                             break ;
                     }
                     textView.setText(elements[index]);
                     textView.setTextSize((float) deviceWidth * 3.5f / 100 / scaledDensity);
                     textView.setTextColor(Color.WHITE);
                     if(index == getCurrentFloatingMenuPosition()) {
                         textView.setBackgroundColor(VeamUtil.getLinkTextColor(this));
                     } else {
                         textView.setBackgroundColor(Color.TRANSPARENT);
                     }
                     textView.setGravity(Gravity.CENTER);
                     textView.setOnClickListener(this);
                     int x = sideMargin + index * elementWidth ;
                     floatingMenuView.addView(textView,ConsoleUtil.getRelativeLayoutPrams(x,0,elementWidth,elementHeight));
                 }
                 rootLayout.addView(floatingMenuView, ConsoleUtil.getRelativeLayoutPrams((deviceWidth-floatingMenuWidth)/2, deviceHeight * 80 / 100, floatingMenuWidth, elementHeight));
             }
         }
     }
    */

    public void onAdapterTitleClick(ConsoleAdapterElement element){
        VeamUtil.log("debug", "ConsoleActivity::onAdapterTitleClick") ;
    }

    public void launchDropboxActivity(String title,String path,String acceptableExtensions){
        Intent intent = new Intent(this,ConsoleDropboxActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,title) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra("DROPBOX_PATH", path) ;
        intent.putExtra("DROPBOX_ACCEPTABLE_EXTENSIONS", acceptableExtensions) ;
        //startActivity(intent);
        startActivityForResult(intent, REQUEST_CODE_DROPBOX_ACTIVITY);
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
    }

    protected void setSwipeView(View view){
        if(VeamUtil.isPreviewMode()){
            VeamUtil.log("debug", "setOnTouchListener") ;
            view.setOnTouchListener(new OnSwipeTouchListener(ConsoleActivity.this) {
                /*
                public void onSwipeTop() {
                    //Toast.makeText(VideosActivity.this, "top", Toast.LENGTH_SHORT).show();
                }
                */
                public void onSwipeRight() {
                    //Toast.makeText(ConsoleActivity.this, "right", Toast.LENGTH_SHORT).show();
                    onListSwipeRight() ;
                }
                public void onSwipeLeft() {
                    //Toast.makeText(ConsoleActivity.this, "left", Toast.LENGTH_SHORT).show();
                    onListSwipeLeft() ;
                }
                /*
                public void onSwipeBottom() {
                    //Toast.makeText(VideosActivity.this, "bottom", Toast.LENGTH_SHORT).show();
                }
                */

            });
        }
    }

    protected void onListSwipeLeft(){
        if(this.getFloatingMenuKind() == VeamActivity.FLOATING_MENU_KIND_EDIT_AND_TUTORIAL){
            if(this.getCurrentFloatingMenuPosition() == 1){
                this.launchTutorialActivity() ;
            }
        }
    }
    protected void launchTutorialActivity() {
        VeamUtil.log("debug","ConsoleActivity::launchTutorialActivity should be overridden") ;
    }

    protected void onListSwipeRight(){
        this.onHeaderBackClicked(null);
    }

    public int getStatusBarHeight() {
        int result = 0;
        int resourceId = getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }





    /*
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
        this.tabBackImageView.setScaleType(ImageView.ScaleType.FIT_XY);
        this.tabBackImageView.setVisibility(View.VISIBLE);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(deviceWidth, tabHeight);
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
                this.tabSelectedImageView.setScaleType(ImageView.ScaleType.FIT_XY);
                this.tabSelectedImageView.setVisibility(View.VISIBLE);
                layoutParams = new RelativeLayout.LayoutParams(tabWidth, tabHeight);
                layoutParams.setMargins(index * tabWidth, viewHeight - tabHeight, 0, 0);
                rootLayout.addView(this.tabSelectedImageView, layoutParams);
            } else {
                this.tabImageViews[index].setImageResource(VeamUtil.getDrawableId(this, String.format("tab_icon_t%d_off", workTemplateId)));
            }
            this.tabImageViews[index].setScaleType(ImageView.ScaleType.FIT_CENTER);
            this.tabImageViews[index].setVisibility(View.VISIBLE);
            layoutParams = new RelativeLayout.LayoutParams(imageWidth, imageHeight);
            layoutParams.setMargins(tabWidth * index + margin, imageY, 0, 0);
            rootLayout.addView(this.tabImageViews[index], layoutParams);


            this.tabTitleViews[index] = new TextView(this);
            this.tabTitleViews[index].setText(VeamUtil.getTemplateTitle(this, workTemplateId));
            this.tabTitleViews[index].setGravity(Gravity.CENTER);
            this.tabTitleViews[index].setVisibility(View.VISIBLE);
            this.tabTitleViews[index].setTextSize((float) deviceWidth * 3.0f / 100 / scaledDensity);
            this.tabTitleViews[index].setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            layoutParams = new RelativeLayout.LayoutParams(tabWidth, tabHeight * 30 / 100);
            layoutParams.setMargins(tabWidth * index, titleY, 0, 0);
            rootLayout.addView(this.tabTitleViews[index], layoutParams);

            this.tabButtonViews[index] = new View(this);
            this.tabButtonViews[index].setBackgroundColor(Color.TRANSPARENT);
            this.tabButtonViews[index].setVisibility(View.VISIBLE);
            this.tabButtonViews[index].setId(this.VIEWID_TAB_BUTTON);
            this.tabButtonViews[index].setTag(Integer.valueOf(workTemplateId));
            this.tabButtonViews[index].setOnClickListener(this);
            //this.tabButtonViews[index].setOnTouchListener(this);
            layoutParams = new RelativeLayout.LayoutParams(tabWidth, tabHeight);
            layoutParams.setMargins(tabWidth * index, buttonY, 0, 0);
            rootLayout.addView(this.tabButtonViews[index], layoutParams);
        }
    }
    */


}
