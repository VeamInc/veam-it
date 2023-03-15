package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by veam on 11/24/16.
 */
public class ConsoleFaqActivity extends ConsoleActivity {

    private TextView buttonLabel ;
    private static final int VIEWID_EDIT_BUTTON = VIEWID_BASE + 0x0001 ;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        WebView webPageView = new WebView(this);
        String url = String.format("https://console.veam.co/creator.php/account/inquiry?k=veamit&os=a&app=%s&lang=%s",VeamUtil.getAppId(),VeamUtil.isLocaleJapanese()?"ja":"en")  ;
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
        webPageView.loadUrl(url);
        mainView.addView(webPageView,ConsoleUtil.getRelativeLayoutPrams(0,topBarHeight,deviceWidth,deviceHeight-topBarHeight-ConsoleUtil.getStatusBarHeight()));

    }

}
