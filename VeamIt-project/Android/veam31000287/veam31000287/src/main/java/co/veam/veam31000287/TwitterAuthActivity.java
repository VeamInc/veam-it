package co.veam.veam31000287;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import twitter4j.Twitter;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import co.veam.veam31000287.getAuthUrlBackground.getAuthUrlCallback;

public class TwitterAuthActivity extends VeamActivity implements getAuthUrlCallback, getAccessTokenBackground.getAuthUrlCallback {

	/*
	 */
	//Twitterアプリのconsumer_keyとconsumer_secretを設定
	//Twitterアプリ作成時に指定したCallback URL
    
    private WebView webView;
    private Twitter twitter;
    private String currentUrl ;
    private RequestToken requestToken ;
    
    private LinearLayout maskView ;
    
    private RelativeLayout rootLayout ;
    private boolean skipLogin ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
    	requestWindowFeature(Window.FEATURE_PROGRESS);
        super.onCreate(savedInstanceState);
        setResult(Activity.RESULT_CANCELED);
		setContentView(R.layout.activity_twitter_auth);
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
		
		Intent intent = getIntent() ;
		skipLogin = intent.getBooleanExtra("SKIP_LOGIN", false) ;

        webView = new WebView(this);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebChromeClient(mWebChromeClient);
        
        webView.setWebViewClient(new WebViewClient() {
        	
        	// shouldOverrideUrlLoading()内だと、処理の中に入らない端末があったので
        	// ページ読み込み時にもgetAccessTokenを入れておく
	       	@Override
	       	public void onPageStarted(WebView view, String url, Bitmap favicon) {		
	           	super.onPageFinished(view, url);
	           	//getAccessToken(url);
	           }
	       	 // タイトルバーのプログレスを消す
	       	@Override
	           public void onPageFinished(WebView view, String url) {
	               super.onPageFinished(view, url);
	               setProgressBarIndeterminateVisibility(false);
	               currentUrl = url ;
	           	if(currentUrl.equals("https://api.twitter.com/oauth/authorize")){
	           		showMask() ;
	           	}
	
	               view.loadUrl("javascript:window.activity.viewSource(document.documentElement.outerHTML);") ;
	           }
	       	
	       	
	       	 // shouldOverrideUrlLoading()内だと、処理の中に入らない端末があったので
	       	 // ページ読み込み時にもgetAccessTokenを入れておく
	       	@Override
	   	    public boolean shouldOverrideUrlLoading(WebView view, String url) {
	       		super.shouldOverrideUrlLoading(view, url);
	       		//getAccessToken(url);
	       		return false;
	   	    }
	        }
       	) ;

        //webView.setWebViewClient(mWebViewClient);
        webView.addJavascriptInterface(this, "activity");
		RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceHeight) ;
	    rootLayout.addView(webView) ;

	    CookieSyncManager.createInstance(this) ;
		CookieManager cookieManager = CookieManager.getInstance();
		cookieManager.removeAllCookie();
	    
        twitter = new TwitterFactory().getInstance();
        twitter.setOAuthConsumer(VeamUtil.TWITTER_CONSUMER_KEY, VeamUtil.TWITTER_CONSUMER_SECRET);

        
         // 普通にgetAuthorizationURL()すると、メインスレッドでhttp通信を行うため
         // 非同期でAuth用のURLを取得する
        getAuthUrlBackground getAuthUrl = new getAuthUrlBackground(this, twitter);
        getAuthUrl.execute();
        
        maskView = new LinearLayout(this) ;
        maskView.setBackgroundColor(Color.argb(215, 0, 0, 0)) ;
        ProgressBar progressBar = new ProgressBar(this) ;
        maskView.addView(progressBar) ;
        maskView.setVisibility(View.GONE) ; 
		layoutParams = new RelativeLayout.LayoutParams(deviceWidth,deviceHeight) ;
		maskView.setGravity(Gravity.CENTER_HORIZONTAL|Gravity.CENTER_VERTICAL) ;
		rootLayout.addView(maskView,layoutParams) ;
    }
    
    public void showMask()
    {
    	this.maskView.setVisibility(View.VISIBLE) ;
    }

    //auth用URLの取得に完了したらwebViewでロードする
	public void returnAuthUrl(RequestToken requestToken) {
		this.requestToken = requestToken ;
		if((webView != null) && (requestToken != null)){
			webView.loadUrl(requestToken.getAuthorizationURL());
		}
	}

	//タイトルバーを進捗のprogressbarを表示用
    private WebChromeClient mWebChromeClient = new WebChromeClient() {
    	@Override
		public void onProgressChanged(WebView view, int progress) {
            TwitterAuthActivity.this.setProgress(progress * 100);
            if (progress==100) {
            	TwitterAuthActivity.this.setProgressBarVisibility(false);
            }
        }
    };
   
    @JavascriptInterface
    public void viewSource(final String src) {
    	//System.out.println("html="+src);
    	
    	if(currentUrl.equals("https://api.twitter.com/oauth/authorize")){
    		try {
	    		 String regExp = "<code>([0-9]{7})</code>" ;
	    		 Pattern pattern = Pattern.compile(regExp) ;
	    		 Matcher matcher = pattern.matcher(src);
	    		 if(!matcher.find()){
	        		 regExp = ">([0-9]{7})<" ;
	        		 pattern = Pattern.compile(regExp) ;
	        		 matcher = pattern.matcher(src) ;
	    		 }
	    		 String pin = matcher.group(1) ;
	    		 //System.out.println("pin="+pin) ;
	    		 
	             getAccessTokenBackground getAccessToken = new getAccessTokenBackground(this, twitter, requestToken,pin);
	             getAccessToken.execute();
    		} catch(Exception e){
    			// cancel?
    			this.finish() ;
    		}
    	}
    }    

    /*
    private WebViewClient mWebViewClient = new WebViewClient() {
    	
    	 // shouldOverrideUrlLoading()内だと、処理の中に入らない端末があったので
    	 // ページ読み込み時にもgetAccessTokenを入れておく
    	@Override
    	public void onPageStarted(WebView view, String url, Bitmap favicon) {		
        	super.onPageFinished(view, url);
        	//getAccessToken(url);
        }
    	 // タイトルバーのプログレスを消す
    	@Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            setProgressBarIndeterminateVisibility(false);
            currentUrl = url ;
        	if(currentUrl.equals("https://api.twitter.com/oauth/authorize")){
        		
        	}

            view.loadUrl("javascript:window.activity.viewSource(document.documentElement.outerHTML);") ;
        }
    	
    	
    	 // shouldOverrideUrlLoading()内だと、処理の中に入らない端末があったので
    	 // ページ読み込み時にもgetAccessTokenを入れておく
    	@Override
	    public boolean shouldOverrideUrlLoading(WebView view, String url) {
    		super.shouldOverrideUrlLoading(view, url);
    		//getAccessToken(url);
    		return false;
	    }
    };
    */
    
    //AccessTokenを取得する
    /*
    private void getAccessToken(String url){
    	
    	 //twitter認証後に返されるURLをフックして、
    	 //oauth_verifierをURLのクエリーから取り出し
    	 //非同期でoauth_verifierを使ってAccessTokenを取得する
    	//System.out.println("twitter:url="+url) ;
    	if ((url != null) && (url.startsWith(CALLBACK_URL))) {
            Uri uri = Uri.parse(url);
            getAccessTokenBackground getAccessToken = new getAccessTokenBackground(this, twitter, uri.getQueryParameter("oauth_verifier"));
            getAccessToken.execute();
        }
    }
    */

    //AccessTokenの取得に成功したとき、コールバックによってここに入る
	public void returnAuthUrl(AccessToken accessToken) {
		//AccessTokenからそれぞれの情報を取得する
		long userId = accessToken.getUserId();
		String userIdString = String.format("%d", userId) ;
    	String screenName = accessToken.getScreenName();
    	String tokenSecret = accessToken.getTokenSecret();
    	String token = accessToken.getToken();
    	//System.out.println("userId="+userIdString+" screenName="+screenName+" tokenSecret="+tokenSecret+" token="+token) ;
    	
    	VeamUtil.setPreferenceString(this, VeamUtil.TWITTER_USER_ID, userIdString) ;
    	VeamUtil.setPreferenceString(this, VeamUtil.TWITTER_USER, screenName) ;
    	VeamUtil.setPreferenceString(this, VeamUtil.TWITTER_TOKEN_SECRET, tokenSecret) ;
    	VeamUtil.setPreferenceString(this, VeamUtil.TWITTER_TOKEN, token) ;
    	//VeamUtil.log("debug","tokenSecret:"+tokenSecret) ;
    	//VeamUtil.log("debug","token:"+token) ;

    	if(skipLogin){
			this.setResult(RESULT_OK) ;
			this.finish() ;
    	} else {
    		SocialLoginTask socialLoginTask = new SocialLoginTask(this,this,twitter,userIdString,screenName) ;
    		socialLoginTask.execute() ;
    	}

        /*
    	//プロフィール画像のURL取得
    	try {
			twitter.getProfileImage(accessToken.getScreenName(),ProfileImage.NORMAL).getURL();
		} catch (TwitterException e) {
			e.printStackTrace();
		}
		*/
    	
    	//以下好きなように実装する
	}
	
	public void onLoginFinished(Integer resultCode)
	{
		//System.out.println("onLoginFinished : "+resultCode) ;
		if(resultCode == 1){
			this.setResult(RESULT_OK) ;
			this.finish() ;
		}
	}
	
	@Override
	public void onDestroy() {
        super.onDestroy();
        // 画面が回転した時など、Activityが破棄されるときに呼び出されます
        // すべてのメモリはここで開放します
        // - 特に危険なのが内部クラス（MyWebChromeClientなど）、正しく開放しないとActivityが開放されません
        // - セットしたbackgroundのcallbackもnullにしないと開放が行われません
        // - webViewのdestroy()を忘れると後からGCが走ったときにVMがクラッシュします
        this.webView.stopLoading();
        this.webView.setWebChromeClient(null);
        this.webView.setWebViewClient(null);
        //this.webView.removeJavascriptInterface("activity") ;
        this.unregisterForContextMenu(this.webView);
        this.webView.destroy();
        this.webView = null;
    }
}

