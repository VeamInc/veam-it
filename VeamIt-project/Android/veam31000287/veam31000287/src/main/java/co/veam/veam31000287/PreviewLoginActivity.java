package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.text.InputType;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import java.util.Locale;

/**
 * Created by veam on 5/26/16.
 */
public class PreviewLoginActivity extends VeamActivity implements View.OnClickListener,PreviewLoginTask.PreviewLoginTaskActivityInterface, OnKeyboardVisibilityListener {

    private DatabaseHelper helper ;

    private RelativeLayout rootLayout ;

    private final int VIEWID_BACKGROUND 	= 0x10001 ;
    private final int VIEWID_EMAIL_TEXT	 	= 0x10002 ;
    private final int VIEWID_PASSWORD_TEXT	= 0x10003 ;
    private final int VIEWID_LOGIN_TEXT	    = 0x10004 ;

    private Handler handler = new Handler();

    private RelativeLayout movableView ;
    private ScrollView scrollView ;

    private EditText emailEditText ;
    private EditText passwordEditText ;
    private TextView loginTextView ;

    private ProgressBar progressBar ;
    private boolean isLoading = false ;

    private int welcomeY = 0 ;
    private int emailY = 0 ;
    private int loginBottomY = 0 ;


    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_preview_login);
        RelativeLayout.LayoutParams layoutParams ;

        pageName = "PreviewLogin" ;

        isPreventSignoutButton = true ;

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

                int elementWidth =  deviceWidth * 80 / 100 ;
                int elementHeight = deviceWidth * 15 / 100 ;
                float welcomeTextSize =  (float)deviceWidth * 7.0f / 100 / scaledDensity ;
                float loginTextSize =  (float)deviceWidth * 6.0f / 100 / scaledDensity ;
                float textSize =  (float)deviceWidth * 5.0f / 100 / scaledDensity ;
                int baseWidth = deviceWidth*90/100 ;
                int baseHeight = deviceHeight*70/100 ;

                int totalElementHeight = elementHeight * 4 + elementHeight * 3 / 3 ;
                int currentY = (deviceHeight - totalElementHeight) / 2 - elementHeight;

                if(currentY < (deviceHeight - baseHeight) / 2){
                    baseHeight = deviceHeight - (currentY * 2) ;
                }

                Typeface typefaceRobotoLight = Typeface.SANS_SERIF ;

                welcomeY = currentY + elementHeight ;

                scrollView = new ScrollView(this) ;
                scrollView.setVerticalScrollBarEnabled(false);
                layoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceHeight) ;
                layoutParams.setMargins(0, 0, 0, 0) ;
                rootLayout.addView(scrollView, layoutParams) ;

                movableView = new RelativeLayout(this) ;
                layoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceHeight+welcomeY) ;
                layoutParams.setMargins(0, 0, 0, 0);
                scrollView.addView(movableView, layoutParams) ;


                View baseView = new View(this) ;
                baseView.setBackgroundColor(Color.WHITE);
                baseView.setBackgroundDrawable(getResources().getDrawable(R.drawable.preview_login_background));
                layoutParams = new RelativeLayout.LayoutParams(baseWidth,baseHeight) ;
                layoutParams.setMargins((deviceWidth - baseWidth) / 2, (deviceHeight - baseHeight) / 2, 0, 0);
                movableView.addView(baseView, layoutParams) ;

                TextView welcomeTextView = new TextView(this) ;
                welcomeTextView.setBackgroundColor(Color.WHITE);
                welcomeTextView.setTextColor(Color.RED);
                welcomeTextView.setGravity(Gravity.CENTER) ;
                welcomeTextView.setTextSize(welcomeTextSize);
                welcomeTextView.setTypeface(Typeface.DEFAULT_BOLD);
                welcomeTextView.setText("WELCOME BACK!") ;
                layoutParams = new RelativeLayout.LayoutParams(elementWidth,elementHeight) ;
                layoutParams.setMargins((deviceWidth - elementWidth) / 2, currentY, 0, 0) ;
                movableView.addView(welcomeTextView, layoutParams) ;

                currentY += elementHeight + (elementHeight / 3) ;

                emailEditText = new EditText(this) ;
                emailEditText.setId(VIEWID_EMAIL_TEXT) ;
                emailEditText.setBackgroundColor(Color.argb(0xAA, 0xFF, 0xFF, 0xFF)) ;
                emailEditText.setBackgroundDrawable(getResources().getDrawable(R.drawable.preview_login_rectangle));
                emailEditText.setGravity(Gravity.CENTER_VERTICAL) ;
                emailEditText.setTypeface(typefaceRobotoLight) ;
                emailEditText.setTextSize(textSize);
                emailEditText.setHint("Email");
                emailEditText.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS) ;
                layoutParams = new RelativeLayout.LayoutParams(elementWidth,elementHeight) ;
                layoutParams.setMargins((deviceWidth - elementWidth)/2, currentY, 0, 0) ;
                movableView.addView(emailEditText, layoutParams) ;

                emailY = currentY ;
                currentY += elementHeight + (elementHeight / 3) ;

                passwordEditText = new EditText(this) ;
                passwordEditText.setId(VIEWID_PASSWORD_TEXT) ;
                passwordEditText.setBackgroundColor(Color.argb(0xAA, 0xFF, 0xFF, 0xFF)) ;
                passwordEditText.setBackgroundDrawable(getResources().getDrawable(R.drawable.preview_login_rectangle));
                passwordEditText.setGravity(Gravity.CENTER_VERTICAL) ;
                passwordEditText.setTypeface(typefaceRobotoLight) ;
                passwordEditText.setTextSize(textSize);
                passwordEditText.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD) ;
                passwordEditText.setHint("Password");
                layoutParams = new RelativeLayout.LayoutParams(elementWidth,elementHeight) ;
                layoutParams.setMargins((deviceWidth - elementWidth)/2, currentY, 0, 0) ;
                movableView.addView(passwordEditText, layoutParams) ;

                currentY += elementHeight + (elementHeight / 3) ;

                loginTextView = new TextView(this) ;
                loginTextView.setId(VIEWID_LOGIN_TEXT) ;
                loginTextView.setBackgroundColor(Color.RED);
                loginTextView.setTextColor(Color.WHITE);
                loginTextView.setGravity(Gravity.CENTER) ;
                loginTextView.setTextSize(loginTextSize);
                loginTextView.setTypeface(Typeface.DEFAULT_BOLD);
                loginTextView.setText("LOG IN") ;
                loginTextView.setOnClickListener(this);
                layoutParams = new RelativeLayout.LayoutParams(elementWidth,elementHeight) ;
                layoutParams.setMargins((deviceWidth - elementWidth)/2, currentY, 0, 0) ;
                movableView.addView(loginTextView, layoutParams) ;

                loginBottomY = currentY + elementHeight ;


                progressBar = new ProgressBar(this,null,android.R.attr.progressBarStyleLarge);
                progressBar.setIndeterminate(true);
                progressBar.setVisibility(View.GONE);
                layoutParams = new RelativeLayout.LayoutParams(elementHeight,elementHeight) ;
                layoutParams.setMargins((deviceWidth - elementHeight) / 2 , currentY, 0, 0) ;
                movableView.addView(progressBar, layoutParams) ;


            } catch (OutOfMemoryError e) {
                //VeamUtil.log("OutOfMemory") ;
            }
        }

        this.setKeyboardListener(this);
    }

    @Override
    public void onClick(View view) {
        super.onClick(view) ;
        //VeamUtil.log("debug","onClick") ;
        if(view.getId() == VIEWID_LOGIN_TEXT){
            String email = emailEditText.getText().toString() ;
            String password = passwordEditText.getText().toString() ;
            if(VeamUtil.isEmpty(email) || VeamUtil.isEmpty(password)){
                VeamUtil.showMessage(this,"The user name or password is incorrect.");
            } else {
                //VeamUtil.log("debug", "email:" + email + " password:" + password) ;
                if(!isLoading) {
                    isLoading = true ;
                    progressBar.setVisibility(View.VISIBLE) ;
                    PreviewLoginTask previewLoginTask = new PreviewLoginTask(this, this, email, password);
                    previewLoginTask.execute();
                }
            }
        }
    }


    @Override
    public void onLoginFinished(Integer resultCode, String message) {
        //VeamUtil.log("debug","onLoginFinished " + resultCode) ;
        progressBar.setVisibility(View.GONE) ;
        isLoading = false ;
        if(resultCode == 1){
            // launch home activity
            Intent intent = new Intent(this, PreviewHomeActivity.class);
            startActivity(intent) ;
        } else {
            if(VeamUtil.isEmpty(message)){
                VeamUtil.showMessage(this,"Login failed");
            } else {
                VeamUtil.showMessage(this,message);
            }
        }
    }

    @Override
    public void onVisibilityChanged(boolean isVisible) {
        VeamUtil.log("debug", "Keyboard detected " + isVisible) ;
        if(scrollView != null) {
            if (isVisible) {
                scrollView.scrollTo(0,welcomeY);
            } else {
                scrollView.scrollTo(0,0);
            }
        }
    }


    public final void setKeyboardListener(final OnKeyboardVisibilityListener listener) {
        final View activityRootView = rootLayout ; //((ViewGroup)getActivity().findViewById(android.R.id.content)).getChildAt(0);

        activityRootView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {

            private boolean wasOpened;

            private final Rect r = new Rect();

            @Override
            public void onGlobalLayout() {
                activityRootView.getWindowVisibleDisplayFrame(r);

                int activityHeight = activityRootView.getRootView().getHeight() ;
                int visibleHeight = r.height() ;
                VeamUtil.log("debug","activityHeight="+activityHeight+" visibleHeight="+visibleHeight);

                // 画面の高さとビューの高さを比べる
                int heightDiff = activityRootView.getRootView().getHeight() - r.height();

                boolean isOpen = heightDiff > 100;

                if (isOpen == wasOpened) {
                    // キーボードの表示状態は変わっていないはずなので何もしない
                    return;
                }

                wasOpened = isOpen;

                listener.onVisibilityChanged(isOpen);
            }
        }) ;
    }

}


