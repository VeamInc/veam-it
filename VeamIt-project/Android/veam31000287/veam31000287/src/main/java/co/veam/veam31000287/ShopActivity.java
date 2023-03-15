package co.veam.veam31000287;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.webkit.WebSettings.PluginState;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

public class ShopActivity extends VeamActivity {
	
	private RelativeLayout rootLayout ;
	private RelativeLayout mainView ;
	private ProgressBar progress ;
	private ImageView backwardImageView ;
	private ImageView forwardImageView ;
	private WebView webPageView ;
	
	private static int VIEWID_BROWSER_BACKWARD_BUTTON	= 0x10001 ;
	private static int VIEWID_BROWSER_FORWARD_BUTTON	= 0x10002 ;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_shop);

		RelativeLayout.LayoutParams layoutParams ;
		
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		
		this.addTab(rootLayout, 4,true) ;
		
		mainView = this.addMainView(rootLayout,View.VISIBLE) ;

		this.addTopBar(mainView, "Shop",false,true) ;
		
		webPageView = new WebView(this) ;
		
		
		webPageView.setBackgroundColor(Color.argb(0,0,0,0)) ;
		webPageView.getSettings().setJavaScriptEnabled(true);
		webPageView.getSettings().setPluginState(PluginState.ON) ;
		webPageView.getSettings().setBuiltInZoomControls(true);
		webPageView.getSettings().setSupportZoom(true) ;
		webPageView.getSettings().setDomStorageEnabled(true);
		webPageView.setVerticalScrollbarOverlay(true);
		
		webPageView.getSettings().setLoadWithOverviewMode(true);
		webPageView.getSettings().setUseWideViewPort(true);		
		
		webPageView.setWebViewClient(new WebViewClient() {
	            @Override
	            public void onPageStarted(WebView view, String url, Bitmap favicon) {
	            	//System.out.println("onPageStarted") ;
	        		progress.setVisibility(View.VISIBLE) ; 
	                super.onPageStarted(view, url, favicon);
	            }

	            @Override
	            public void onPageFinished(WebView view, String url) {
	            	//System.out.println("onPageFinished") ;
	        		progress.setVisibility(View.GONE) ;
	        		if(view.canGoBack()){
	        			//VeamUtil.log("debug","can go back") ;
	        			backwardImageView.setImageResource(R.drawable.br_backward_on) ;
	        			backwardImageView.setVisibility(View.VISIBLE) ;
	        			forwardImageView.setVisibility(View.VISIBLE) ;
	        		} else {
	        			backwardImageView.setImageResource(R.drawable.br_backward_off) ;
	        		}
	        		
	        		if(view.canGoForward()){
	        			//VeamUtil.log("debug","can go forward") ;
	        			forwardImageView.setImageResource(R.drawable.br_forward_on) ;
	        			backwardImageView.setVisibility(View.VISIBLE) ;
	        			forwardImageView.setVisibility(View.VISIBLE) ;
	        		} else {
	        			forwardImageView.setImageResource(R.drawable.br_forward_off) ;
	        		}
	        		
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

	                if (url.startsWith("http://m.youtube.com/watch")) {
	                    Uri uri = Uri.parse(url);
	                    Intent varintent = new Intent(Intent.ACTION_VIEW);
	                    varintent.setData(Uri.parse("vnd.youtube:" + uri.getQueryParameter("v")));
	                    startActivity(varintent);
	                }
	            }	            
	        });
		
		//webPageView.loadUrl("http://www.ogorgeous.com/") ;
		webPageView.loadUrl("http://www.ogorgeous.com/products/just-in") ;
		
		
		layoutParams = createParam(deviceWidth, viewHeight-topBarHeight) ;
		layoutParams.setMargins(0, topBarHeight, 0, 0) ;
		mainView.addView(webPageView,layoutParams) ;
		
		progress = new ProgressBar(this) ;
		progress.setIndeterminate(true) ;
		int progressSize = deviceWidth * 10 / 100 ;
		layoutParams = createParam(progressSize, progressSize) ;
		layoutParams.setMargins(deviceWidth * 45 / 100, topBarHeight + (viewHeight-progressSize)/2, 0, 0) ;
		progress.setVisibility(View.GONE) ; 
		mainView.addView(progress,layoutParams) ;
		
		int buttonWidth = deviceWidth * 15 / 100 ;
		int buttonHeight = buttonWidth * 102 / 90 ;
		
		backwardImageView = new ImageView(this) ;
		backwardImageView.setId(VIEWID_BROWSER_BACKWARD_BUTTON) ;
		backwardImageView.setOnClickListener(this) ; 
		backwardImageView.setImageResource(R.drawable.br_backward_off) ;
		backwardImageView.setScaleType(ScaleType.FIT_XY) ;
		backwardImageView.setVisibility(View.GONE) ;
		layoutParams = createParam(buttonWidth, buttonHeight) ;
		layoutParams.setMargins(deviceWidth/2-buttonWidth, viewHeight-buttonHeight-deviceWidth*3/100, 0, 0) ;
		mainView.addView(backwardImageView,layoutParams) ;
		
		forwardImageView = new ImageView(this) ;
		forwardImageView.setId(VIEWID_BROWSER_FORWARD_BUTTON) ;
		forwardImageView.setOnClickListener(this) ; 
		forwardImageView.setImageResource(R.drawable.br_forward_off) ;
		forwardImageView.setScaleType(ScaleType.FIT_XY) ;
		forwardImageView.setVisibility(View.GONE) ;
		layoutParams = createParam(buttonWidth, buttonHeight) ;
		layoutParams.setMargins(deviceWidth/2, viewHeight-buttonHeight-deviceWidth*3/100, 0, 0) ;
		mainView.addView(forwardImageView,layoutParams) ;
	}
	
	
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","RecipesActivity::onClick") ;
		if(view.getId() == VIEWID_BROWSER_BACKWARD_BUTTON){
			//VeamUtil.log("debug","back button tapped") ;
			if(webPageView.canGoBack()){
				webPageView.goBack() ;
			}
		} else if(view.getId() == VIEWID_BROWSER_FORWARD_BUTTON){
			//VeamUtil.log("debug","forward button tapped") ;
			if(webPageView.canGoForward()){
				webPageView.goForward() ;
			}
		}
	}

	@Override
	public void resetProfileButton(){
		super.resetProfileButton() ;
		boolean hasNewNotification = VeamUtil.hasNewNotification(this) ;
		resetProfileButtonForView(mainView,hasNewNotification) ;
	}

	
}
