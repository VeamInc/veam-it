package co.veam.veam31000287;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;


public class VideosActivity extends VeamActivity implements OnClickListener, OnItemClickListener {
	/*
	private DatabaseHelper helper ;
	SQLiteDatabase mDb ;
	*/
	private RelativeLayout rootLayout ;
	private RelativeLayout mainView ;
	private RelativeLayout subCategoryView ;
	private RelativeLayout youtubeView ;
	private ListView categoryListView ;
	private ListView subCategoryListView ;
	private ListView youtubeListView ;
	private YoutubeCategoryAdapter youtubeCategoryAdapter ;
	private YoutubeSubCategoryAdapter youtubeSubCategoryAdapter ;
	private YoutubeAdapter youtubeAdapter ;
	///private youtubeAdapter youtubeAdapter ;
	//private String currentCategoryName ;
	private YoutubeCategoryObject currentYoutubeCategoryObject ;
	private YoutubeObject currentYoutubeObject = null ; 
	private YoutubeSubCategoryObject currentYoutubeSubCategoryObject = null ;

	private AdView playlistCategoryAdView = null ;
	private AdView playlistAdView = null ;

	public static int VIEWID_YOUTUBE_CATEGORY			= 0x10001 ;
	public static int VIEWID_YOUTUBE_SUB_CATEGORY		= 0x10002 ;
	public static int VIEWID_YOUTUBE					= 0x10003 ;
	
	private int currentView ;
	private static int VIEW_YOUTUBE_CATEGORY_LIST 		= 1 ;
	private static int VIEW_YOUTUBE_SUB_CATEGORY_LIST	= 2 ;
	private static int VIEW_YOUTUBE_LIST 				= 3 ;
	private static int VIEW_YOUTUBE_DETAIL 				= 4 ;
	private static int VIEW_WEB		 					= 5 ;

	private static final int TEMPLATE_ID = 1 ;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_videos);
		/*
		helper = new DatabaseHelper(this) ;
		mDb = helper.getReadableDatabase() ;
		*/
		this.pageName = "Videos" ;

		//playlistCategoryAdView = this.createAdView(AdSize.BANNER,this.getString(R.string.admob_id_playlistcategory)) ;

		RelativeLayout.LayoutParams layoutParams ;
		
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;


		this.addBaseBackground(rootLayout) ;
		this.addTab(rootLayout, TEMPLATE_ID,true) ;
		mainView = this.addMainView(rootLayout,View.VISIBLE) ;


		categoryListView = new ListView(this) ;
		//categoryListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
		categoryListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
		categoryListView.setBackgroundColor(Color.TRANSPARENT) ;
		categoryListView.setCacheColorHint(Color.TRANSPARENT) ;
		categoryListView.setVerticalScrollBarEnabled(false) ;
		categoryListView.setOnItemClickListener(this) ;
		//categoryListView.setOnScrollListener(this) ;
		categoryListView.setPadding(0, 0, 0, 0) ;
		categoryListView.setDivider(null) ;
		layoutParams = createParam(deviceWidth, viewHeight) ;
		mainView.addView(categoryListView,layoutParams) ;
		
		this.addTopBar(mainView, this.getString(R.string.youtube),false,true) ;
		
		//BulletinObject bulletinObject = VeamUtil.getCurrentBulletin(mDb) ;

		YoutubeCategoryObject[] youtubeCategoryObjects = VeamUtil.getYoutubeCategoryObjects(mDb) ;
		youtubeCategoryAdapter = new YoutubeCategoryAdapter(this,youtubeCategoryObjects,deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_playlistcategory),AdSize.SMART_BANNER) ;
		categoryListView.setAdapter(youtubeCategoryAdapter) ;
		
		currentView = VIEW_YOUTUBE_CATEGORY_LIST ;

		this.createFloatingMenu(rootLayout);
		setSwipeView(categoryListView) ;

	}
	
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","VideosActivity::onClick") ;
		if(view.getId() == this.VIEWID_TOP_BAR_BACK_BUTTON){
			//VeamUtil.log("debug","back button tapped") ;
			if(currentView == VIEW_YOUTUBE_SUB_CATEGORY_LIST){
				this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showMainView", null) ;
				this.doTranslateAnimation(subCategoryView, 300, 0, deviceWidth, 0, 0, "removeSubCategoryList", null) ;
				currentView = VIEW_YOUTUBE_CATEGORY_LIST ;
				this.showFloatingMenu();
			} else if(currentView == VIEW_YOUTUBE_LIST){
				if(subCategoryView == null){
					this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showMainView", null) ;
					this.doTranslateAnimation(youtubeView, 300, 0, deviceWidth, 0, 0, "removeYoutubeList", null) ;
					currentView = VIEW_YOUTUBE_CATEGORY_LIST ;
					this.showFloatingMenu();
				} else {
					this.doTranslateAnimation(subCategoryView, 300, -deviceWidth, 0, 0, 0, "showSubCategoryView", null) ;
					this.doTranslateAnimation(youtubeView, 300, 0, deviceWidth, 0, 0, "removeYoutubeList", null) ;
					currentView = VIEW_YOUTUBE_SUB_CATEGORY_LIST ;
					this.hideFloatingMenu();
					if(currentYoutubeCategoryObject != null){
						this.trackPageView(String.format("VideoCategoryList/%s/%s",currentYoutubeCategoryObject.getId(),currentYoutubeCategoryObject.getName())) ;
					}
				}
			} else if(currentView == VIEW_YOUTUBE_DETAIL){
				this.doTranslateAnimation(youtubeView, 300, -deviceWidth, 0, 0, 0, "showYoutubeView", null) ;
				this.doTranslateAnimation(youtubeDetailView, 300, 0, deviceWidth, 0, 0, "removeYoutubeDetail", null) ;
				currentView = VIEW_YOUTUBE_LIST ;
				this.hideFloatingMenu();
				if(currentYoutubeSubCategoryObject != null){
					this.trackPageView(String.format("VideoList/%s/%s",currentYoutubeSubCategoryObject.getId(),currentYoutubeSubCategoryObject.getName())) ;
				}
			} else if(currentView == VIEW_WEB){
				if(youtubeDetailView == null){
					this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showMainView", null) ;
					this.doTranslateAnimation(webView, 300, 0, deviceWidth, 0, 0, "removeWeb", null) ;
					currentView = VIEW_YOUTUBE_CATEGORY_LIST ;
					this.showFloatingMenu();
				} else {
					this.doTranslateAnimation(youtubeDetailView, 300, -deviceWidth, 0, 0, 0, "showYoutubeDetailView", null) ;
					this.doTranslateAnimation(webView, 300, 0, deviceWidth, 0, 0, "removeWeb", null) ;
					currentView = VIEW_YOUTUBE_DETAIL ;
					this.hideFloatingMenu();
					if(currentYoutubeObject != null){
						this.trackPageView(String.format("VideoDetail/%s/%s",currentYoutubeObject.getId(),currentYoutubeObject.getTitle())) ;
					}
				}
			}
		}
	}
	
	public void removeSubCategoryList(){
		if(subCategoryView != null){
			subCategoryView.removeAllViews() ;
			this.rootLayout.removeView(subCategoryView) ;
			subCategoryView = null ;
		}
	}

	public void removeYoutubeList(){
		if(youtubeView != null){
			youtubeView.removeAllViews() ;
			this.rootLayout.removeView(youtubeView) ;
			youtubeView = null ;
		}
	}

	public void removeYoutubeDetail(){
		if(youtubeDetailView != null){
			if(currentYoutubePlayer != null){
				currentYoutubePlayer.release();
				currentYoutubePlayer = null ;
				//VeamUtil.log("debug", "youtube player released") ;
			}
			youtubeDetailView.removeAllViews() ;
			this.rootLayout.removeView(youtubeDetailView) ;
			youtubeDetailView = null ;
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

	public void hideSubCategoryView(){
		if(subCategoryView != null){
			subCategoryView.setVisibility(View.GONE) ;
		}
	}

	public void hideYoutubeView(){
		if(youtubeView != null){
			youtubeView.setVisibility(View.GONE) ;
		}
	}

	public void showMainView(){
		if(mainView != null){
			mainView.setVisibility(View.VISIBLE) ;
		}
	}

	public void showSubCategoryView(){
		if(subCategoryView != null){
			subCategoryView.setVisibility(View.VISIBLE) ;
		}
	}

	public void showYoutubeView(){
		if(youtubeView != null){
			youtubeView.setVisibility(View.VISIBLE) ;
		}
	}

	public void showYoutubeDetailView(){
		if(youtubeDetailView != null){
			youtubeDetailView.setVisibility(View.VISIBLE) ;
		}
	}

	public void showWebView(){
		if(webView != null){
			webView.setVisibility(View.VISIBLE) ;
		}
	}


	/*
	public void visibleRecipeList(){
		if(recipeView != null){
			recipeView.setVisibility(View.VISIBLE) ;
		}
	}

	public void removeRecipeDetail(){
		if(recipeDetailView != null){
			recipeDetailView.removeAllViews() ;
			this.rootLayout.removeView(recipeDetailView) ;
			recipeDetailView = null ;
		}
	}
	*/
	
	@Override
	public void onDestroy() {
		/*
	    if(mDb != null){
	    	mDb.close() ;
	    	mDb = null ;
	    }
	    */
	    super.onDestroy();
	}

	@Override
	public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
		//VeamUtil.log("debug","onItemClick") ;
		if(listView == this.categoryListView){
			//VeamUtil.log("debug","categoryListView") ;
			if(currentView == VIEW_YOUTUBE_CATEGORY_LIST){
				//Integer position = (Integer)view.getTag() ;
                YoutubeCategoryObject youtubeCategoryObject = (YoutubeCategoryObject)youtubeCategoryAdapter.getItem(position) ;
                currentYoutubeCategoryObject = youtubeCategoryObject ;
                if(youtubeCategoryObject != null){
                    //currentCategoryName = youtubeCategoryObject.getName() ;

                    YoutubeSubCategoryObject[] subCategoryObjects = VeamUtil.getYoutubeSubCategoryObjects(mDb,youtubeCategoryObject.getId()) ;
                    if(subCategoryObjects != null){
                        //VeamUtil.log("debug","tap "+youtubeCategoryObject.getName() + "count:" + subCategoryObjects.length) ;
                        if(subCategoryView != null){
                            subCategoryView.removeAllViews() ;
                            this.rootLayout.removeView(subCategoryView) ;
                            subCategoryView = null ;
                        }

                        subCategoryView = this.addMainView(rootLayout, View.VISIBLE) ;

                        subCategoryListView = new ListView(this) ;
                        //recipeListView.setVerticalFadingEdgeEnabled(false) ;
                        //recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
                        subCategoryListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
                        subCategoryListView.setOnItemClickListener(this) ;
                        subCategoryListView.setBackgroundColor(Color.TRANSPARENT) ;
                        subCategoryListView.setCacheColorHint(Color.TRANSPARENT) ;
                        subCategoryListView.setVerticalScrollBarEnabled(false) ;
                        subCategoryListView.setPadding(0, 0, 0, 0) ;
                        subCategoryListView.setDivider(null) ;
                        RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
                        subCategoryView.addView(subCategoryListView,layoutParams) ;

                        youtubeSubCategoryAdapter = new YoutubeSubCategoryAdapter(this,subCategoryObjects,deviceWidth,topBarHeight,scaledDensity) ;
                        subCategoryListView.setAdapter(youtubeSubCategoryAdapter) ;

                        this.addTopBar(subCategoryView, youtubeCategoryObject.getName(), true, true) ;

                        this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, "hideMainView", null) ;
                        this.doTranslateAnimation(subCategoryView, 300, deviceWidth, 0, 0, 0, null, null) ;
                        currentView = VIEW_YOUTUBE_SUB_CATEGORY_LIST ;
						this.hideFloatingMenu();
                        if(currentYoutubeCategoryObject != null){
                            this.trackPageView(String.format("VideoCategoryList/%s/%s",currentYoutubeCategoryObject.getId(),currentYoutubeCategoryObject.getName())) ;
                        }
                    } else {
                        // sub category が無い場合は直接Youtubeリストへ
                        YoutubeObject[] youtubeObjects = VeamUtil.getYoutubeObjects(this,mDb,youtubeCategoryObject.getId(),"0") ;
                        if(youtubeObjects != null){
                            //VeamUtil.log("debug","count:" + youtubeObjects.length) ;
                            if(this.youtubeView != null){
                                youtubeView.removeAllViews() ;
                                this.rootLayout.removeView(youtubeView) ;
                                youtubeView = null ;
                            }

                            youtubeView = this.addMainView(rootLayout, View.VISIBLE) ;

                            youtubeListView = new ListView(this) ;
                            youtubeListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
                            youtubeListView.setOnItemClickListener(this) ;
                            youtubeListView.setBackgroundColor(Color.TRANSPARENT) ;
                            youtubeListView.setCacheColorHint(Color.TRANSPARENT) ;
                            youtubeListView.setVerticalScrollBarEnabled(false) ;
                            youtubeListView.setPadding(0, 0, 0, 0) ;
                            youtubeListView.setDivider(null) ;
                            RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
                            youtubeView.addView(youtubeListView,layoutParams) ;

                            youtubeAdapter = new YoutubeAdapter(this,youtubeObjects,deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_playlist),AdSize.SMART_BANNER) ;
                            youtubeListView.setAdapter(youtubeAdapter) ;

                            this.addTopBar(youtubeView, youtubeCategoryObject.getName(), true, true) ;

                            this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, "hideMainView", null) ;
                            this.doTranslateAnimation(youtubeView, 300, deviceWidth, 0, 0, 0, null, null) ;
                            currentView = VIEW_YOUTUBE_LIST ;
							this.hideFloatingMenu();
                            this.trackPageView(String.format("VideoList/%s",youtubeCategoryObject.getName())) ;
                        }
                    }
                }
			}
			this.categoryListView.setSelected(false) ;
		} else if(listView == this.subCategoryListView){
			if(currentView == VIEW_YOUTUBE_SUB_CATEGORY_LIST){
				YoutubeSubCategoryObject youtubeSubCategoryObject = (YoutubeSubCategoryObject)youtubeSubCategoryAdapter.getItem((Integer)view.getTag()) ;
				currentYoutubeSubCategoryObject = youtubeSubCategoryObject ;
				if(youtubeSubCategoryObject != null){
					YoutubeObject[] youtubeObjects = VeamUtil.getYoutubeObjects(this,mDb,youtubeSubCategoryObject.getYoutubeCategoryId(),youtubeSubCategoryObject.getId()) ;
					if(youtubeObjects != null){
						//VeamUtil.log("debug","tap "+youtubeSubCategoryObject.getName() + "count:" + youtubeObjects.length) ;
						if(this.youtubeView != null){
							youtubeView.removeAllViews() ;
							this.rootLayout.removeView(youtubeView) ;
							youtubeView = null ;
						}
						
						youtubeView = this.addMainView(rootLayout, View.VISIBLE) ;
			
						youtubeListView = new ListView(this) ;
						//recipeListView.setVerticalFadingEdgeEnabled(false) ;
						//recipeListView.setSelector(new ColorDrawable(Color.argb(0xFF,0xFD,0xD4,0xDB))) ;
						youtubeListView.setSelector(new ColorDrawable(Color.argb(0x00,0xFD,0xD4,0xDB))) ;
						youtubeListView.setOnItemClickListener(this) ;
						youtubeListView.setBackgroundColor(Color.TRANSPARENT) ;
						youtubeListView.setCacheColorHint(Color.TRANSPARENT) ;
						youtubeListView.setVerticalScrollBarEnabled(false) ;
						youtubeListView.setPadding(0, 0, 0, 0) ;
						youtubeListView.setDivider(null) ;
						RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight) ;
						youtubeView.addView(youtubeListView,layoutParams) ;
						
						youtubeAdapter = new YoutubeAdapter(this,youtubeObjects,deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_playlist),AdSize.SMART_BANNER) ;
						youtubeListView.setAdapter(youtubeAdapter) ;
						
						this.addTopBar(youtubeView, youtubeSubCategoryObject.getName(), true, true) ;
						
						this.doTranslateAnimation(subCategoryView, 300, 0, -deviceWidth, 0, 0, "hideSubCategoryView", null) ;
						this.doTranslateAnimation(youtubeView, 300, deviceWidth, 0, 0, 0, null, null) ;
						currentView = VIEW_YOUTUBE_LIST ;
						this.hideFloatingMenu();
						if(currentYoutubeSubCategoryObject != null){
							this.trackPageView(String.format("VideoList/%s/%s",currentYoutubeSubCategoryObject.getId(),currentYoutubeSubCategoryObject.getName())) ;
						}
					}
				}
			}
			this.categoryListView.setSelected(false) ;
		} else if(listView == this.youtubeListView){
			if(currentView == VIEW_YOUTUBE_LIST){
				YoutubeObject youtubeObject = (YoutubeObject)youtubeAdapter.getItem((Integer)view.getTag()) ;
				currentYoutubeObject = youtubeObject ; 
				if(youtubeObject != null){
					//VeamUtil.log("debug","tap "+youtubeObject.getTitle()) ;
					
					this.createYoutubeDetailView(rootLayout, youtubeObject) ;
					this.doTranslateAnimation(this.youtubeView, 300, 0, -deviceWidth, 0, 0, "hideYoutubeView", null) ;
					this.doTranslateAnimation(youtubeDetailView, 300, deviceWidth, 0, 0, 0, null, null) ;
					currentView = VIEW_YOUTUBE_DETAIL ;
					this.hideFloatingMenu();
					if(currentYoutubeObject != null){
						this.trackPageView(String.format("VideoDetail/%s/%s",currentYoutubeObject.getId(),currentYoutubeObject.getTitle())) ;
					}
				}
			}
			//this.recipeListView.setItemChecked(position, false) ;
		}
	}
	
	
	@Override
	public void onUrlClick(String url) {
		//VeamUtil.log("debug","onUrlClick") ;
		if(currentView == VIEW_YOUTUBE_DETAIL){
			this.createWebView(rootLayout,url, "Web",false,true,false) ;
			this.doTranslateAnimation(youtubeDetailView, 300, 0, -deviceWidth, 0, 0, null, null) ;
			this.doTranslateAnimation(webView, 300, deviceWidth, 0, 0, 0, null, null) ;
			currentView = VIEW_WEB;
			this.hideFloatingMenu();
			this.trackPageView(String.format("WebView/%s", url)) ;
		}
	}

	@Override
	public void onPrintableClick(String printableId) {
		//VeamUtil.log("debug","onUrlClick") ;
		if(currentView == VIEW_YOUTUBE_DETAIL){
			YoutubeObject youtubeObject = new YoutubeObject(mDb,printableId) ;
			//String youtubeObjectId = youtubeObject.getId() ;
			String imageUrl = youtubeObject.getLink() ;
			if(!VeamUtil.isEmpty(imageUrl) && (youtubeObject.getKind().equals("3"))){
				this.createWebView(rootLayout,imageUrl, "Printable",true,true,false);
				this.doTranslateAnimation(youtubeDetailView, 300, 0, -deviceWidth, 0, 0, null, null) ;
				this.doTranslateAnimation(webView, 300, deviceWidth, 0, 0, 0, null, null) ;
				currentView = VIEW_WEB;
				this.hideFloatingMenu();
				this.trackPageView(String.format("WebView/%s",imageUrl)) ;
			}
		}
	}
	

	@Override
	public void resetProfileButton(){
		super.resetProfileButton() ;
		boolean hasNewNotification = VeamUtil.hasNewNotification(this) ;
		resetProfileButtonForView(mainView,hasNewNotification) ;
		resetProfileButtonForView(subCategoryView,hasNewNotification) ;
		resetProfileButtonForView(youtubeView,hasNewNotification) ;
	}


	public AdView createAdView(AdSize adSize,String adUnitId){
		AdView adView = new AdView(this) ;
		adView.setLayoutParams(new android.widget.AbsListView.LayoutParams(deviceWidth, android.widget.AbsListView.LayoutParams.WRAP_CONTENT));
		adView.setAdSize(adSize);
		adView.setAdUnitId(adUnitId);
		adView.loadAd(VeamUtil.getAdRequest());

		return adView ;
	}

	@Override
	protected int getFloatingMenuKind(){
		return FLOATING_MENU_KIND_EDIT_AND_TUTORIAL ;
	}

	@Override
	protected boolean startEditModeActivity(){
		VeamUtil.log("debug", "startEditModeActivity") ;
		if(!super.startEditModeActivity()) {
			Intent intent = new Intent(this, ConsoleYoutubeCategoryActivity.class);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.youtube));
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 3);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
			intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, TEMPLATE_ID);
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
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.youtube_tutorial)) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,3) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,2) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
		intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND,ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE) ;
		startActivity(intent);
		overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
	}


	@Override
	public void onContentsUpdated(){
		VeamUtil.log("debug", "VideosCategoryActivity::onContentsUpdated") ;
		if(categoryListView != null) {
			YoutubeCategoryObject[] youtubeCategoryObjects = VeamUtil.getYoutubeCategoryObjects(mDb) ;
			youtubeCategoryAdapter = new YoutubeCategoryAdapter(this,youtubeCategoryObjects,deviceWidth,topBarHeight,scaledDensity,this.getString(R.string.admob_id_playlistcategory),AdSize.SMART_BANNER) ;
			categoryListView.setAdapter(youtubeCategoryAdapter) ;
		}
	}



}
