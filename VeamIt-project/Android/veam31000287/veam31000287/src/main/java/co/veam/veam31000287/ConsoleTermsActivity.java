package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.net.URLEncoder;

/**
 * Created by veam on 11/24/16.
 */
public class ConsoleTermsActivity extends ConsoleActivity {

    private TextView buttonLabel ;
    private static final int VIEWID_EDIT_BUTTON = VIEWID_BASE + 0x0001 ;
    private static final int VIEWID_TERMS_BACKWARD_BUTTON = VIEWID_BASE + 0x0002 ;
    private static final int VIEWID_TERMS_FORWARD_BUTTON = VIEWID_BASE + 0x0003 ;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        int editButtonHeight = deviceWidth * 44 / 320 ;

        webPageView = new WebView(this);
        String url = String.format("http://veam.co/top/termsofserviceforyoutuber?loc=%s",getString(R.string.language)) ;
        VeamUtil.log("debug", "url=" + url);
        webPageView.setBackgroundColor(Color.argb(0xFF, 0xFF, 0xFF, 0xFF));
        webPageView.getSettings().setJavaScriptEnabled(true);
        webPageView.getSettings().setPluginState(WebSettings.PluginState.ON);
        webPageView.getSettings().setBuiltInZoomControls(true);
        webPageView.getSettings().setSupportZoom(true);
        webPageView.getSettings().setDomStorageEnabled(true);
        webPageView.setVerticalScrollbarOverlay(true);

        webPageView.getSettings().setLoadWithOverviewMode(true);
        webPageView.getSettings().setUseWideViewPort(true);


        webPageView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                VeamUtil.log("debug","onPageStarted") ;
                browserProgress.setVisibility(View.VISIBLE);
                super.onPageStarted(view, url, favicon);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                VeamUtil.log("debug","onPageFinished"); ;
                browserProgress.setVisibility(View.GONE);
                /*
                if (view.canGoBack()) {
                    VeamUtil.log("debug","can go back") ;
                    backwardImageView.setImageResource(R.drawable.br_backward_on);
                    backwardImageView.setVisibility(View.VISIBLE);
                    forwardImageView.setVisibility(View.VISIBLE);
                } else {
                    backwardImageView.setImageResource(R.drawable.br_backward_off);
                }

                if (view.canGoForward()) {
                    VeamUtil.log("debug","can go forward") ;
                    forwardImageView.setImageResource(R.drawable.br_forward_on);
                    backwardImageView.setVisibility(View.VISIBLE);
                    forwardImageView.setVisibility(View.VISIBLE);
                } else {
                    forwardImageView.setImageResource(R.drawable.br_forward_off);
                }
                */

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
            }
        });



        webPageView.loadUrl(url);
        mainView.addView(webPageView,ConsoleUtil.getRelativeLayoutPrams(0,topBarHeight,deviceWidth,deviceHeight-topBarHeight-editButtonHeight-ConsoleUtil.getStatusBarHeight()));

        /*
        ConsoleAppStoreAdapter adapter = new ConsoleAppStoreAdapter(this) ;
        this.addMainList(adapter);
        */

        RelativeLayout editButtonView = new RelativeLayout(this) ;
        editButtonView.setBackgroundColor(VeamUtil.getColorFromArgbString("FFF8F8F8")) ;
        editButtonView.setOnClickListener(this);
        editButtonView.setId(VIEWID_EDIT_BUTTON) ;
        mainView.addView(editButtonView, ConsoleUtil.getRelativeLayoutPrams(0, deviceHeight - editButtonHeight - ConsoleUtil.getStatusBarHeight(), deviceWidth, editButtonHeight));

        View separatorView = new View(this) ;
        separatorView.setBackgroundColor(Color.BLACK) ;
        editButtonView.addView(separatorView, ConsoleUtil.getRelativeLayoutPrams(0, 0, deviceWidth, 1)) ;

        buttonLabel = new TextView(this) ;// [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], APP_STORE_EDIT_BUTTON_HEIGHT)] ;
        buttonLabel.setText(this.getString(R.string.accept)) ;
        buttonLabel.setTextColor(Color.BLACK) ;
        buttonLabel.setGravity(Gravity.CENTER);
        buttonLabel.setTextSize((float) deviceWidth * 4.0f / 100 / scaledDensity);
        buttonLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        editButtonView.addView(buttonLabel, ConsoleUtil.getRelativeLayoutPrams(0,0,deviceWidth,editButtonHeight)) ;
        updateButtonLabel() ;


        browserProgress = new ProgressBar(this);
        browserProgress.setIndeterminate(true);
        int progressSize = deviceWidth * 10 / 100;
        RelativeLayout.LayoutParams layoutParams = createParam(progressSize, progressSize);
        layoutParams.setMargins(deviceWidth * 45 / 100, (deviceHeight - progressSize) / 2, 0, 0);
        browserProgress.setVisibility(View.GONE);
        mainView.addView(browserProgress, layoutParams);

        int buttonWidth = deviceWidth * 15 / 100;
        int buttonHeight = buttonWidth * 102 / 90;

        backwardImageView = new ImageView(this);
        backwardImageView.setId(VIEWID_TERMS_BACKWARD_BUTTON);
        backwardImageView.setOnClickListener(this);
        backwardImageView.setImageResource(R.drawable.br_backward_off);
        backwardImageView.setScaleType(ImageView.ScaleType.FIT_XY);
        backwardImageView.setVisibility(View.GONE);
        layoutParams = createParam(buttonWidth, buttonHeight);
        layoutParams.setMargins(deviceWidth / 2 - buttonWidth, deviceHeight - editButtonHeight - ConsoleUtil.getStatusBarHeight() - buttonHeight - deviceWidth * 3 / 100, 0, 0);
        mainView.addView(backwardImageView, layoutParams);

        forwardImageView = new ImageView(this);
        forwardImageView.setId(VIEWID_TERMS_FORWARD_BUTTON);
        forwardImageView.setOnClickListener(this);
        forwardImageView.setImageResource(R.drawable.br_forward_off);
        forwardImageView.setScaleType(ImageView.ScaleType.FIT_XY);
        forwardImageView.setVisibility(View.GONE);
        layoutParams = createParam(buttonWidth, buttonHeight);
        layoutParams.setMargins(deviceWidth / 2, deviceHeight - editButtonHeight - ConsoleUtil.getStatusBarHeight() - buttonHeight - deviceWidth * 3 / 100, 0, 0);
        mainView.addView(forwardImageView, layoutParams);

    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        VeamUtil.log("debug", "ConsoleAppStoreActivity::onClick ") ;
        if(v.getId() == VIEWID_EDIT_BUTTON){
            if(!this.isAccepted()) {
                new AlertDialog.Builder(this)
                        .setMessage(getString(R.string.accept_these_terms))
                        .setPositiveButton(getString(R.string.accept), new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                // OK button pressed
                                showFullscreenProgress();
                                ConsoleUtil.getConsoleContents().setAppTermsAccepted();
                            }
                        })
                        .setNegativeButton(getString(R.string.cancel), null)
                        .show();
            }
        } else if (v.getId() == VIEWID_TERMS_BACKWARD_BUTTON) {
            //VeamUtil.log("debug","back button tapped") ;
            if (webPageView.canGoBack()) {
                webPageView.goBack();
            }
        } else if (v.getId() == VIEWID_TERMS_FORWARD_BUTTON) {
            //VeamUtil.log("debug","forward button tapped") ;
            if (webPageView.canGoForward()) {
                webPageView.goForward();
            }
        }

    }

    private void updateButtonLabel()
    {
        if(this.isAccepted()){
            buttonLabel.setText(getString(R.string.accepted)) ;
            buttonLabel.setTextColor(Color.RED) ;
        }
    }

    private boolean isAccepted()
    {
        String acceptedAt = ConsoleUtil.getConsoleContents().appInfo.getTermsAcceptedAt() ;
        return !VeamUtil.isEmpty(acceptedAt) ;
    }

    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostDone " + apiName) ;
        hideFullscreenProgress() ;
        if(apiName.equals("app/acceptterms")) {
            ConsoleUtil.getConsoleContents().appInfo.setTermsAcceptedAt("1");
            handler.post(new Runnable() {
                public void run() {
                    updateButtonLabel();
                }
            });
        }
    }

    @Override
    public void onConsoleDataPostFailed(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostFailed " + apiName) ;
        VeamUtil.showMessage(this,"Failed to send data");
        hideFullscreenProgress() ;
    }


}
