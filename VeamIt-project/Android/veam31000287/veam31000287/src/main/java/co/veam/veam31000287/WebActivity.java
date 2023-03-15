package co.veam.veam31000287;

import java.util.HashMap;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.ads.AdSize;


public class WebActivity extends VeamActivity implements OnClickListener, OnItemClickListener {

	private RelativeLayout rootLayout ;
	private RelativeLayout mainView ;
	private ListView webListView ;
	private WebAdapter webAdapter ;
	private WebObject currentWebObject ;
	private int templateId ;
	
	public static int VIEWID_TOP_DELETE				= 0x10001 ;
	public static int VIEWID_DONE_BUTTON			= 0x10002 ;
	
	private int currentView ;
	private static int VIEW_WEB_LIST 					= 1 ;
	private static int VIEW_WEB		 					= 5 ;
	private String webCategoryId ;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_videos);

		this.pageName = "Webs" ;

		RelativeLayout.LayoutParams layoutParams ;
		
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;

		Intent intent = getIntent();
		templateId = intent.getIntExtra("TEMPLATE_ID",3) ;


		this.addBaseBackground(rootLayout) ;
		this.addTab(rootLayout, templateId,true) ;
		mainView = this.addMainView(rootLayout,View.VISIBLE) ;
		
		webListView = new ListView(this) ;
		webListView.setSelector(new ColorDrawable(Color.argb(0x00, 0xFD, 0xD4, 0xDB))) ;
		webListView.setBackgroundColor(Color.TRANSPARENT) ;
		webListView.setCacheColorHint(Color.TRANSPARENT) ;
		webListView.setVerticalScrollBarEnabled(false) ;
		webListView.setOnItemClickListener(this) ;
		webListView.setPadding(0, 0, 0, 0) ;
		webListView.setDivider(null) ;
		layoutParams = createParam(deviceWidth, viewHeight) ;
		mainView.addView(webListView, layoutParams) ;

		String titleString = this.getString(R.string.links) ;
		if(templateId == 9){
			titleString = "Shop" ;
		}
		this.addTopBar(mainView, titleString,false,true) ;

		webCategoryId = "0" ;
		if(templateId == 9){
			webCategoryId = "1" ;
		}
		WebObject[] webObjects = VeamUtil.getWebObjects(mDb,webCategoryId) ;
		webAdapter = new WebAdapter(this,webObjects,deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_linkscategory), AdSize.SMART_BANNER) ;
		webListView.setAdapter(webAdapter) ;
		
		currentView = VIEW_WEB_LIST ;

		if(webObjects.length == 1){
			WebObject webObject = webObjects[0] ;
			currentWebObject = webObject ;

			if(currentWebObject != null){
				String url = webObject.getUrl() ;
				if(!VeamUtil.isEmpty(url)) {
					this.createWebView(rootLayout, url, webObject.getTitle(), false, true,true) ;
					mainView.layout(-deviceWidth, 0, -deviceWidth + mainView.getWidth(), mainView.getHeight());
					webView.layout(deviceWidth/2, 0, webView.getWidth(), webView.getHeight());

					currentView = VIEW_WEB ;
					this.trackPageView(String.format("WebView/%s",url)) ;
				}
			}
		}

		this.createFloatingMenu(rootLayout);
		setSwipeView(webListView) ;
	}
	
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","VideosActivity::onClick") ;
		if(view.getId() == VIEWID_TOP_BAR_BACK_BUTTON){
			//VeamUtil.log("debug","back button tapped") ;
			if(currentView == VIEW_WEB){
				this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showMainView", null) ;
				this.doTranslateAnimation(webView, 300, 0, deviceWidth, 0, 0, "removeWeb", null) ;
				currentView = VIEW_WEB_LIST ;
				this.showFloatingMenu();
			}
		}
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
	
	public void hideMainView(){
		if(mainView != null){
			mainView.setVisibility(View.GONE) ;
		}
	}

	public void showMainView(){
		if(mainView != null){
			mainView.setVisibility(View.VISIBLE) ;
		}
	}

	public void showWebView(){
		if(webView != null){
			webView.setVisibility(View.VISIBLE) ;
		}
	}


	@Override
	public void onDestroy() {
	    super.onDestroy();
	}

	@Override
	public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
		//VeamUtil.log("debug","onItemClick") ;
		if(listView == this.webListView){
			//VeamUtil.log("debug","categoryListView") ;
			if(currentView == VIEW_WEB_LIST){
				//Integer position = (Integer)view.getTag() ;
				WebObject webObject = (WebObject)webAdapter.getItem(position) ;
				currentWebObject = webObject ;
				
	    		if(currentWebObject != null){
	    			String url = webObject.getUrl() ;
	    			if(!VeamUtil.isEmpty(url)){
	    				this.createWebView(rootLayout,url, webObject.getTitle(),false,true,false) ;
	    				this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, null, null) ;
	    				this.doTranslateAnimation(webView, 300, deviceWidth, 0, 0, 0, null, null) ;
	    				currentView = VIEW_WEB ;
						this.hideFloatingMenu();
	    				this.trackPageView(String.format("WebView/%s",url)) ;
	    			}
	    		}
			}
			this.webListView.setSelected(false) ;
		}
	}

	@Override
	protected int getFloatingMenuKind(){
		return FLOATING_MENU_KIND_EDIT_AND_TUTORIAL ;
	}

	@Override
	protected boolean startEditModeActivity(){
		VeamUtil.log("debug", "startEditModeActivity") ;
		if(!super.startEditModeActivity()) {
			Intent intent = new Intent(this, ConsoleWebActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.links_url));
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 3);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, templateId);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
			startActivity(intent);
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
		}
		return true ;
	}

	@Override
	protected void startTutorialActivity(){
		VeamUtil.log("debug", "startTutorialActivity") ;
		Intent intent = new Intent(this,ConsoleTutorialActivity.class) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.links_tutorial)) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,3) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,2) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND,ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_LINK) ;
		startActivity(intent);
		overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
	}


	@Override
	public void onContentsUpdated(){
		VeamUtil.log("debug", "VideosCategoryActivity::onContentsUpdated") ;
		if(webListView != null) {
			WebObject[] webObjects = VeamUtil.getWebObjects(mDb, webCategoryId) ;
			webAdapter = new WebAdapter(this,webObjects,deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_linkscategory), AdSize.SMART_BANNER) ;
			webListView.setAdapter(webAdapter) ;
		}
	}


}
