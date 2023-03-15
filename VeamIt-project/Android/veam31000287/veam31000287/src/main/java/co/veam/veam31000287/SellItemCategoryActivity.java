package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Build;
import android.text.ClipboardManager;
import android.text.Layout;
import android.text.TextPaint;
import android.util.Log;
import android.view.Gravity;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.ScrollView;
import android.widget.TextView;

import com.veam.inappbilling.util.IabHelper;
import com.veam.inappbilling.util.IabResult;
import com.veam.inappbilling.util.Inventory;
import com.veam.inappbilling.util.Purchase;

import org.json.JSONException;

import java.net.URLEncoder;


public class SellItemCategoryActivity extends VeamActivity implements OnClickListener, OnItemClickListener, PreviewDownloadTask.PreviewDownloadListenerInterface {
	/*
	private DatabaseHelper helper ;
	SQLiteDatabase mDb ;
	*/

    private boolean iabSetupDone = false ;
    IabHelper iabHelper;
    private final String payloadString = "VEAM_IN_APP_BILLING"; // TODO shou be dynamically generated

    private final int REQUEST_CODE_PURCHASE			= 0x0001 ;
    private final int REQUEST_CODE_ACTIVITY_PLAYER 	= 0x0002 ;

    private Handler handler = new Handler();

    private ImageView goodJobImageView ;

    private RelativeLayout rootLayout ;
	private RelativeLayout mainView ;
	private RelativeLayout subCategoryView ;
    private RelativeLayout sellVideoView ;
    private RelativeLayout sellPdfView ;
    private RelativeLayout sellAudioView ;
	private ListView categoryListView ;
	private ListView subCategoryListView ;
    private ListView sellVideoListView ;
    private ListView sellPdfListView ;
    private ListView sellAudioListView ;
    protected RelativeLayout pdfWebView ;
    private RelativeLayout videoPurchaseView ;
    private ScrollView videoPurchaseScrollView ;
    private RelativeLayout pdfPurchaseView ;
    private RelativeLayout audioPurchaseView ;
    private ScrollView pdfPurchaseScrollView ;
    private ScrollView audioPurchaseScrollView ;
	private SellItemCategoryAdapter sellItemCategoryAdapter;
    private SellVideoAdapter sellVideoAdapter ;
    private SellPdfAdapter sellPdfAdapter ;
    private SellAudioAdapter sellAudioAdapter ;
    TextView urlTextView ;
    private SellItemCategoryObject currentSellItemCategoryObject ;
    private VideoCategoryObject currentVideoCategoryObject ;
    private PdfCategoryObject currentPdfCategoryObject ;
    private AudioCategoryObject currentAudioCategoryObject ;
    private SellVideoObject currentSellVideoObject = null ;
    private SellPdfObject currentSellPdfObject = null ;
    private SellAudioObject currentSellAudioObject = null ;
    private VideoObject currentVideoObject = null ;
    private PdfObject currentPdfObject = null ;
    private AudioObject currentAudioObject = null ;

	public static int VIEWID_VIDEO_CATEGORY			= 0x10001 ;
    public static int VIEWID_SELL_VIDEO				= 0x10004 ;
    public static int VIEWID_SELL_VIDEO_PURCHASE	= 0x10005 ;
    public static int VIEWID_SELL_PDF				= 0x10006 ;
    public static int VIEWID_SELL_PDF_PURCHASE		= 0x10007 ;
    public static int VIEWID_PDF_URL        		= 0x10008 ;
    public static int VIEWID_SELL_AUDIO				= 0x10009 ;
    public static int VIEWID_SELL_AUDIO_PURCHASE	= 0x1000A ;

	private int currentView ;
	private static int VIEW_SELL_ITEM_CATEGORY_LIST 		= 1 ;
    private static int VIEW_SELL_VIDEO_LIST 				= 6 ;
    private static int VIEW_SELL_VIDEO_PURCHASE     		= 7 ;
    private static int VIEW_SELL_PDF_LIST 				    = 8 ;
    private static int VIEW_SELL_PDF_PURCHASE     		    = 9 ;
    private static int VIEW_SELL_PDF		 				= 10 ;
    private static int VIEW_SELL_AUDIO_LIST 				= 11 ;
    private static int VIEW_SELL_AUDIO_PURCHASE     		= 12 ;
    private static int VIEW_SELL_AUDIO		 				= 13 ;

    private static final int TEMPLATE_ID = 8 ;

    @Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_videos);
		/*
		helper = new DatabaseHelper(this) ;
		mDb = helper.getReadableDatabase() ;
		*/
		this.pageName = "SellItemMenu" ;

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
		
		this.addTopBar(mainView, this.getString(R.string.exclusive),false,true) ;

		SellItemCategoryObject[] sellItemCategoryObjects = VeamUtil.getSellItemCategoryObjects(mDb) ;
		sellItemCategoryAdapter = new SellItemCategoryAdapter(this,sellItemCategoryObjects,deviceWidth,topBarHeight,scaledDensity) ;
		categoryListView.setAdapter(sellItemCategoryAdapter) ;

		currentView = VIEW_SELL_ITEM_CATEGORY_LIST ;
        this.showFloatingMenu();

        // Create the helper, passing it our context and the public key to verify signatures with
        //VeamUtil.log(TAG, "Creating IAB helper.");
        iabHelper = new IabHelper(this, VeamUtil.IAB_PUBLIC);

        // enable debug logging (for a production application, you should set this to false).
        iabHelper.enableDebugLogging(false);

        // Start setup. This is asynchronous and the specified listener
        // will be called once setup completes.
        //VeamUtil.log(TAG, "Starting setup.");
        iabHelper.startSetup(new IabHelper.OnIabSetupFinishedListener() {
            public void onIabSetupFinished(IabResult result) {
                //VeamUtil.log("debug", "IAB Setup finished.");

                if (!result.isSuccess()) {
                    // Oh noes, there was a problem.
                    VeamUtil.showMessage(SellItemCategoryActivity.this,"Problem setting up in-app billing: " + result);
                    return;
                }

                iabSetupDone = true ;

                // Hooray, IAB is fully set up. Now, let's get an inventory of stuff we own.
                //VeamUtil.log(TAG, "Setup successful. Querying inventory.");
                //mHelper.queryInventoryAsync(mGotInventoryListener);

                if(VeamUtil.isTestInAppBilling()){
                    testInventory() ;
                } else {
                    // Hooray, IAB is fully set up. Now, let's get an inventory of stuff we own.
                    //VeamUtil.log("debug", "Setup successful. Querying inventory.");
                    iabHelper.queryInventoryAsync(mGotInventoryListener);
                }
            }
        });


        this.createFloatingMenu(rootLayout);
        setSwipeView(categoryListView) ;
    }
	
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","VideosActivity::onClick") ;
		if(view.getId() == this.VIEWID_TOP_BAR_BACK_BUTTON){
			//VeamUtil.log("debug","back button tapped") ;
            if(currentView == VIEW_SELL_VIDEO_LIST){
                this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showMainView", null) ;
                this.doTranslateAnimation(sellVideoView, 300, 0, deviceWidth, 0, 0, "removeSellVideoList", null) ;
                currentView = VIEW_SELL_ITEM_CATEGORY_LIST ;
                this.showFloatingMenu();
            } else if(currentView == VIEW_SELL_VIDEO_PURCHASE){
                this.doTranslateAnimation(sellVideoView, 300, -deviceWidth, 0, 0, 0, "showSellVideoListView", null) ;
                this.doTranslateAnimation(videoPurchaseView, 300, 0, deviceWidth, 0, 0, "removeVideoPurchase", null) ;
                currentView = VIEW_SELL_VIDEO_LIST ;
                this.showFloatingMenu();
			} else if(currentView == VIEW_SELL_PDF_LIST){
                this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showMainView", null) ;
                this.doTranslateAnimation(sellPdfView, 300, 0, deviceWidth, 0, 0, "removeSellPdfList", null) ;
                currentView = VIEW_SELL_ITEM_CATEGORY_LIST ;
                this.showFloatingMenu();
            } else if(currentView == VIEW_SELL_PDF_PURCHASE) {
                this.doTranslateAnimation(sellPdfView, 300, -deviceWidth, 0, 0, 0, "showSellPdfListView", null);
                this.doTranslateAnimation(pdfPurchaseView, 300, 0, deviceWidth, 0, 0, "removePdfPurchase", null);
                currentView = VIEW_SELL_PDF_LIST;
                this.showFloatingMenu();
            } else if(currentView == VIEW_SELL_PDF) {
                this.doTranslateAnimation(sellPdfView, 300, -deviceWidth, 0, 0, 0, "showSellPdfListView", null);
                this.doTranslateAnimation(pdfWebView, 300, 0, deviceWidth, 0, 0, "removeWeb", null);
                currentView = VIEW_SELL_PDF_LIST;
                this.showFloatingMenu();
            } else if(currentView == VIEW_SELL_AUDIO_LIST){
                this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, "showMainView", null) ;
                this.doTranslateAnimation(sellAudioView, 300, 0, deviceWidth, 0, 0, "removeSellAudioList", null) ;
                currentView = VIEW_SELL_ITEM_CATEGORY_LIST ;
                this.showFloatingMenu();
            } else if(currentView == VIEW_SELL_AUDIO_PURCHASE) {
                this.doTranslateAnimation(sellAudioView, 300, -deviceWidth, 0, 0, 0, "showSellAudioListView", null);
                this.doTranslateAnimation(audioPurchaseView, 300, 0, deviceWidth, 0, 0, "removeAudioPurchase", null);
                currentView = VIEW_SELL_AUDIO_LIST;
                this.showFloatingMenu();
            }
        } else if(view.getId() == VIEWID_SELL_VIDEO_PURCHASE){
            // start purchase flow
            //VeamUtil.log("debug","start purchase flow") ;
            if((iabHelper != null) && iabSetupDone && (currentSellVideoObject != null)){
                String productId = currentSellVideoObject.getProductId() ;
                //VeamUtil.log("debug","launch sell video purchase flow "+productId) ;
                if(VeamUtil.isTestInAppBilling()){
                    //VeamUtil.log("debug","IN_APP_BILLING_TEST") ;
                    try {
                        IabResult result = new IabResult(IabHelper.BILLING_RESPONSE_RESULT_OK,"") ;
                        String jsonString = String.format("{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000015\",\"productId\": \"%s\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"%s\",\"token\": \"\"}",
                                productId,this.payloadString) ;
                        Purchase info = new Purchase("TEST_ITEM_TYPE", jsonString, "TEST_SIGNATURE");
                        mPurchaseFinishedListener.onIabPurchaseFinished(result, info) ;
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    iabHelper.launchPurchaseFlow(this,productId, REQUEST_CODE_PURCHASE, mPurchaseFinishedListener, payloadString) ;
                }
            } else {
                VeamUtil.showMessage(this, "Google Play In-app Billing is not set up.") ;
            }
        } else if(view.getId() == VIEWID_SELL_PDF_PURCHASE){
            // start purchase flow
            //VeamUtil.log("debug","start purchase flow") ;
            if((iabHelper != null) && iabSetupDone && (currentSellPdfObject != null)){
                String productId = currentSellPdfObject.getProductId() ;
                //VeamUtil.log("debug","launch sell pdf purchase flow "+productId) ;
                if(VeamUtil.isTestInAppBilling()){
                    //VeamUtil.log("debug","IN_APP_BILLING_TEST") ;
                    try {
                        IabResult result = new IabResult(IabHelper.BILLING_RESPONSE_RESULT_OK,"") ;
                        String jsonString = String.format("{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000015\",\"productId\": \"%s\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"%s\",\"token\": \"\"}",
                                productId,this.payloadString) ;
                        Purchase info = new Purchase("TEST_ITEM_TYPE", jsonString, "TEST_SIGNATURE");
                        mPurchaseFinishedListener.onIabPurchaseFinished(result, info) ;
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    iabHelper.launchPurchaseFlow(this,productId, REQUEST_CODE_PURCHASE, mPurchaseFinishedListener, payloadString) ;
                }
            } else {
                VeamUtil.showMessage(this, "Google Play In-app Billing is not set up.") ;
            }



        } else if(view.getId() == VIEWID_SELL_AUDIO_PURCHASE){
            // start purchase flow
            //VeamUtil.log("debug","start purchase flow") ;
            if((iabHelper != null) && iabSetupDone && (currentSellAudioObject != null)){
                String productId = currentSellAudioObject.getProductId() ;
                //VeamUtil.log("debug","launch sell pdf purchase flow "+productId) ;
                if(VeamUtil.isTestInAppBilling()){
                    //VeamUtil.log("debug","IN_APP_BILLING_TEST") ;
                    try {
                        IabResult result = new IabResult(IabHelper.BILLING_RESPONSE_RESULT_OK,"") ;
                        String jsonString = String.format("{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000015\",\"productId\": \"%s\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"%s\",\"token\": \"\"}",
                                productId,this.payloadString) ;
                        Purchase info = new Purchase("TEST_ITEM_TYPE", jsonString, "TEST_SIGNATURE");
                        mPurchaseFinishedListener.onIabPurchaseFinished(result, info) ;
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    iabHelper.launchPurchaseFlow(this,productId, REQUEST_CODE_PURCHASE, mPurchaseFinishedListener, payloadString) ;
                }
            } else {
                VeamUtil.showMessage(this, "Google Play In-app Billing is not set up.") ;
            }
        } else if(view.getId() == VIEWID_PDF_URL){
            final String stringToBeCopied = urlTextView.getText().toString() ;
            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
            alertDialogBuilder.setTitle(null);
            alertDialogBuilder.setMessage("Copy this URL?");
            alertDialogBuilder.setPositiveButton("OK",
                    new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            ClipboardManager cm = (ClipboardManager)SellItemCategoryActivity.this.getSystemService(Context.CLIPBOARD_SERVICE) ;
                            cm.setText(stringToBeCopied) ;
                        }
                    });
            alertDialogBuilder.setNegativeButton("Cancel",
                    new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                        }
                    });
            alertDialogBuilder.setCancelable(false);
            AlertDialog alertDialog = alertDialogBuilder.create();
            alertDialog.show();
        }
	}
	
    public void removeSellVideoList(){
        if(sellVideoView != null){
            sellVideoView.removeAllViews() ;
            this.rootLayout.removeView(sellVideoView) ;
            sellVideoView = null ;
        }
    }

    public void removeSellPdfList(){
        if(sellPdfView != null){
            sellPdfView.removeAllViews() ;
            this.rootLayout.removeView(sellPdfView) ;
            sellPdfView = null ;
        }
    }

    public void removeSellAudioList(){
        if(sellAudioView != null){
            sellAudioView.removeAllViews() ;
            this.rootLayout.removeView(sellAudioView) ;
            sellAudioView = null ;
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

    public void showSellVideoListView(){
        if(sellVideoListView != null){
            sellVideoListView.setVisibility(View.VISIBLE) ;
        }
    }

    public void showSellPdfListView(){
        if(sellPdfListView != null){
            sellPdfListView.setVisibility(View.VISIBLE) ;
        }
    }

    public void showSellAudioListView(){
        if(sellAudioListView != null){
            sellAudioListView.setVisibility(View.VISIBLE) ;
        }
    }

    @Override
	public void onDestroy() {
	    super.onDestroy();
	}

	@Override
	public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
		//VeamUtil.log("debug","onItemClick") ;
		if(listView == this.categoryListView){
			//VeamUtil.log("debug","categoryListView") ;
			if(currentView == VIEW_SELL_ITEM_CATEGORY_LIST){
				//Integer position = (Integer)view.getTag() ;
				SellItemCategoryObject sellItemCategoryObject = (SellItemCategoryObject) sellItemCategoryAdapter.getItem(position) ;
				currentSellItemCategoryObject = sellItemCategoryObject ;
				if(sellItemCategoryObject != null){
                    //VeamUtil.log("debug","sellItemCategoryObject.getKind()="+sellItemCategoryObject.getKind()) ;
                    if(sellItemCategoryObject.getKind().equals(SellItemCategoryObject.KIND_VIDEO_CATEGORY)){
                        // Exclusive Videos
                        //VeamUtil.log("debug","ExclusiveVideos tap") ;
                        VideoCategoryObject videoCategoryObject = VeamUtil.getVideoCategoryObject(mDb,sellItemCategoryObject.getTargetCategoryId()) ;
                        currentVideoCategoryObject = videoCategoryObject ;
                        if(videoCategoryObject != null){
                            //VeamUtil.log("debug","count:" + sellVideoObjects.length) ;
                            if (this.sellVideoView != null) {
                                sellVideoView.removeAllViews();
                                this.rootLayout.removeView(sellVideoView);
                                sellVideoView = null;
                            }

                            sellVideoView = this.addMainView(rootLayout, View.VISIBLE);

                            sellVideoListView = new ListView(this);
                            sellVideoListView.setSelector(new ColorDrawable(Color.argb(0x00, 0xFD, 0xD4, 0xDB)));
                            sellVideoListView.setOnItemClickListener(this);
                            sellVideoListView.setBackgroundColor(Color.TRANSPARENT);
                            sellVideoListView.setCacheColorHint(Color.TRANSPARENT);
                            sellVideoListView.setVerticalScrollBarEnabled(false);
                            sellVideoListView.setPadding(0, 0, 0, 0);
                            sellVideoListView.setDivider(null);
                            RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight);
                            sellVideoView.addView(sellVideoListView, layoutParams);

                            SellVideoObject[] sellVideoObjects = VeamUtil.getSellVideoObjectsForVideoCategory(mDb, currentVideoCategoryObject.getId()) ;
                            VideoObject[] videoObjects = VeamUtil.getVideoObjects(this, mDb, currentVideoCategoryObject.getId(), "0");
                            sellVideoAdapter = new SellVideoAdapter(this, sellVideoObjects, videoObjects, deviceWidth, topBarHeight, scaledDensity);
                            sellVideoListView.setAdapter(sellVideoAdapter);

                            setSwipeView(sellVideoListView) ;


                            this.addTopBar(sellVideoView, videoCategoryObject.getName(), true, true);

                            this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, "hideMainView", null);
                            this.doTranslateAnimation(sellVideoView, 300, deviceWidth, 0, 0, 0, null, null);
                            currentView = VIEW_SELL_VIDEO_LIST;
                            this.showFloatingMenu();
                            this.trackPageView("SellVideoList/");
                        }
                    } else if(sellItemCategoryObject.getKind().equals(SellItemCategoryObject.KIND_PDF_CATEGORY)){
                        // Exclusive Pdfs
                        //VeamUtil.log("debug", "ExclusivePdfs tap") ;
                        PdfCategoryObject pdfCategoryObject = VeamUtil.getPdfCategoryObject(mDb, sellItemCategoryObject.getTargetCategoryId()) ;
                        currentPdfCategoryObject = pdfCategoryObject ;
                        if(pdfCategoryObject != null) {
                            //VeamUtil.log("debug", "pdfCategoryObject name="+pdfCategoryObject.getName()) ;
                            //VeamUtil.log("debug", "pdfObjects count="+pdfObjects.length) ;
                            //VeamUtil.log("debug","count:" + sellVideoObjects.length) ;
                            if (this.sellPdfView != null) {
                                sellPdfView.removeAllViews();
                                this.rootLayout.removeView(sellPdfView);
                                sellPdfView = null;
                            }

                            sellPdfView = this.addMainView(rootLayout, View.VISIBLE);

                            sellPdfListView = new ListView(this);
                            sellPdfListView.setSelector(new ColorDrawable(Color.argb(0x00, 0xFD, 0xD4, 0xDB)));
                            sellPdfListView.setOnItemClickListener(this);
                            sellPdfListView.setBackgroundColor(Color.TRANSPARENT);
                            sellPdfListView.setCacheColorHint(Color.TRANSPARENT);
                            sellPdfListView.setVerticalScrollBarEnabled(false);
                            sellPdfListView.setPadding(0, 0, 0, 0);
                            sellPdfListView.setDivider(null);
                            RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight);
                            sellPdfView.addView(sellPdfListView, layoutParams);

                            SellPdfObject[] sellPdfObjects = VeamUtil.getSellPdfObjectsForPdfCategory(mDb, currentPdfCategoryObject.getId());
                            PdfObject[] pdfObjects = VeamUtil.getPdfObjects(this, mDb, currentPdfCategoryObject.getId(), "0");
                            sellPdfAdapter = new SellPdfAdapter(this, sellPdfObjects, pdfObjects, deviceWidth, topBarHeight, scaledDensity);
                            sellPdfListView.setAdapter(sellPdfAdapter);

                            setSwipeView(sellPdfListView) ;

                            this.addTopBar(sellPdfView, pdfCategoryObject.getName(), true, true);

                            this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, "hideMainView", null);
                            this.doTranslateAnimation(sellPdfView, 300, deviceWidth, 0, 0, 0, null, null);
                            currentView = VIEW_SELL_PDF_LIST;
                            this.showFloatingMenu();
                            this.trackPageView("SellPdfList/");
                        }


                    } else if(sellItemCategoryObject.getKind().equals(SellItemCategoryObject.KIND_AUDIO_CATEGORY)){
                        // Exclusive Audios
                        //VeamUtil.log("debug", "ExclusiveAudios tap") ;
                        AudioCategoryObject audioCategoryObject = VeamUtil.getAudioCategoryObject(mDb, sellItemCategoryObject.getTargetCategoryId()) ;
                        currentAudioCategoryObject = audioCategoryObject ;
                        if(audioCategoryObject != null) {
                            //VeamUtil.log("debug", "audioCategoryObject name="+audioCategoryObject.getName() + " id="+audioCategoryObject.getId()) ;
                            //VeamUtil.log("debug", "audioObjects count="+audioObjects.length) ;
                            //VeamUtil.log("debug","count:" + sellAudioObjects.length) ;
                            if (this.sellAudioView != null) {
                                sellAudioView.removeAllViews();
                                this.rootLayout.removeView(sellAudioView);
                                sellAudioView = null;
                            }

                            sellAudioView = this.addMainView(rootLayout, View.VISIBLE);

                            sellAudioListView = new ListView(this);
                            sellAudioListView.setSelector(new ColorDrawable(Color.argb(0x00, 0xFD, 0xD4, 0xDB)));
                            sellAudioListView.setOnItemClickListener(this);
                            sellAudioListView.setBackgroundColor(Color.TRANSPARENT);
                            sellAudioListView.setCacheColorHint(Color.TRANSPARENT);
                            sellAudioListView.setVerticalScrollBarEnabled(false);
                            sellAudioListView.setPadding(0, 0, 0, 0);
                            sellAudioListView.setDivider(null);
                            RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight);
                            sellAudioView.addView(sellAudioListView, layoutParams);

                            SellAudioObject[] sellAudioObjects = VeamUtil.getSellAudioObjectsForAudioCategory(mDb, currentAudioCategoryObject.getId());
                            AudioObject[] audioObjects = VeamUtil.getAudioObjects(this, mDb, currentAudioCategoryObject.getId(), "0");
                            sellAudioAdapter = new SellAudioAdapter(this, sellAudioObjects, audioObjects, deviceWidth, topBarHeight, scaledDensity);
                            sellAudioListView.setAdapter(sellAudioAdapter);

                            setSwipeView(sellAudioListView) ;

                            this.addTopBar(sellAudioView, audioCategoryObject.getName(), true, true);

                            this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, "hideMainView", null);
                            this.doTranslateAnimation(sellAudioView, 300, deviceWidth, 0, 0, 0, null, null);
                            currentView = VIEW_SELL_AUDIO_LIST;
                            this.showFloatingMenu();
                            this.trackPageView("SellAudioList/");
                        }

                    }
				} else {
                   //VeamUtil.log("debug","no video category found") ;
                }
			}
			this.categoryListView.setSelected(false) ;
        } else if(listView == this.sellVideoListView){
            if(currentView == VIEW_SELL_VIDEO_LIST){
                SellVideoObject sellVideoObject = (SellVideoObject)sellVideoAdapter.getItem((Integer)view.getTag()) ;
                currentSellVideoObject = sellVideoObject ;
                if(sellVideoObject != null){
                    //VeamUtil.log("debug","tap "+youtubeObject.getTitle()) ;
                    currentVideoObject = sellVideoAdapter.getVideoObject(sellVideoObject.getVideoId()) ;
                    if(currentVideoObject != null) {
                        if(VeamUtil.getSellVideoIsBought(this,sellVideoObject.getId())) {
                            if (VeamUtil.previewExists(this, currentVideoObject.getId())) {
                                this.playVideoObject();
                            } else {
                                PreviewDownloadTask previewDownloadTask = new PreviewDownloadTask(this, currentVideoObject, this.getString(R.string.PreviewDownloadTitie), this.getString(R.string.PreviewDownloadDescription));
                                previewDownloadTask.setListener(this);
                                previewDownloadTask.execute(currentVideoObject.getId());
                            }
                            this.trackPageView(String.format("SellVideoPlay/%s/%s/", currentVideoObject.getId(), currentVideoObject.getTitle()));
                        } else {
                            this.showVideoPurchase() ;
                        }
                    }
                }
            }
        } else if(listView == this.sellPdfListView){
            if(currentView == VIEW_SELL_PDF_LIST){
                SellPdfObject sellPdfObject = (SellPdfObject)sellPdfAdapter.getItem((Integer)view.getTag()) ;
                currentSellPdfObject = sellPdfObject ;
                if(sellPdfObject != null){
                    currentPdfObject = sellPdfAdapter.getPdfObject(sellPdfObject.getPdfId());
                    if(currentPdfObject != null) {
                        if(VeamUtil.getSellPdfIsBought(this, sellPdfObject.getId())) {
                            this.playPdfObject();
                            this.trackPageView(String.format("SellPdfShow/%s/%s/", currentPdfObject.getId(), currentPdfObject.getTitle()));
                        } else {
                            this.showPdfPurchase() ;
                        }
                    }
                }
            }



        } else if(listView == this.sellAudioListView){
            if(currentView == VIEW_SELL_AUDIO_LIST){
                SellAudioObject sellAudioObject = (SellAudioObject)sellAudioAdapter.getItem((Integer)view.getTag()) ;
                currentSellAudioObject = sellAudioObject ;
                if(sellAudioObject != null){
                    currentAudioObject = sellAudioAdapter.getAudioObject(sellAudioObject.getAudioId());
                    if(currentAudioObject != null) {
                        if(VeamUtil.getSellAudioIsBought(this, sellAudioObject.getId())) {
                            this.playAudioObject();
                            this.trackPageView(String.format("SellAudioShow/%s/%s/", currentAudioObject.getId(), currentAudioObject.getTitle()));
                        } else {
                            this.showAudioPurchase() ;
                        }
                    }
                }
            }
		}
	}



    public void showVideoPurchase(){
        this.createVideoPurchase() ;
        this.doTranslateAnimation(sellVideoView, 300, 0, -deviceWidth, 0, 0, null, null) ;
        this.doTranslateAnimation(videoPurchaseView, 300, deviceWidth, 0, 0, 0, null, null) ;
        currentView = VIEW_SELL_VIDEO_PURCHASE ;
        this.hideFloatingMenu();
        this.trackPageView("AboutVideo/") ;
    }

    public void removeVideoPurchase(){
        if(videoPurchaseView != null){
            videoPurchaseView.removeAllViews() ;
            this.rootLayout.removeView(videoPurchaseView) ;
            videoPurchaseView = null ;
        }
    }

    public void createVideoPurchase(){

        //VeamUtil.log("debug","createVideoPurchase "+currentSellVideoObject.getId() + " " + currentSellVideoObject.getDescription()) ;

        this.removeVideoPurchase();

        videoPurchaseView = this.addMainView(rootLayout,View.VISIBLE) ;

        videoPurchaseScrollView = new ScrollView(this) ;
        videoPurchaseScrollView.setVerticalScrollBarEnabled(false) ;
        videoPurchaseScrollView.setBackgroundColor(Color.TRANSPARENT) ;
        RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,viewHeight) ;
        videoPurchaseView.addView(videoPurchaseScrollView,relativeLayoutParams) ;

        int padding = deviceWidth * 3 / 100 ;
        LinearLayout contentView = new LinearLayout(this) ;
        contentView.setPadding(padding, topBarHeight+padding, padding, 0) ;
        contentView.setOrientation(LinearLayout.VERTICAL) ;
        videoPurchaseScrollView.addView(contentView) ;

        Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

        TextView textView = new TextView(this) ;
        textView.setText(currentSellVideoObject.getDescription()) ;
        textView.setTextSize((float)deviceWidth * 4.7f / 100 / scaledDensity) ;
        textView.setBackgroundColor(Color.TRANSPARENT) ;
        textView.setTypeface(typefaceRobotoLight) ;
        textView.setTextColor(VeamUtil.getColorFromArgbString("FF2E2E30")) ;
        LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,LinearLayout.LayoutParams.WRAP_CONTENT) ;
        contentView.addView(textView,linearLayoutParams) ;

        TextView purchaseTextView = new TextView(this) ;
        purchaseTextView.setId(VIEWID_SELL_VIDEO_PURCHASE) ;
        purchaseTextView.setOnClickListener(this) ;
        purchaseTextView.setText(currentSellVideoObject.getButtonText()) ;
        purchaseTextView.setTextSize((float)deviceWidth * 5.5f / 100 / scaledDensity) ;
        purchaseTextView.setBackgroundColor(VeamUtil.getLinkTextColor(this)) ;
        purchaseTextView.setTypeface(Typeface.SERIF) ;
        purchaseTextView.setTextColor(Color.WHITE) ;
        purchaseTextView.setGravity(Gravity.CENTER) ;
        linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,deviceWidth*12/100) ;
        contentView.addView(purchaseTextView,linearLayoutParams) ;

        this.addTopBar(videoPurchaseView, "About Video",true,true) ;

    }















    public void showPdfPurchase(){
        this.createPdfPurchase() ;
        this.doTranslateAnimation(sellPdfView, 300, 0, -deviceWidth, 0, 0, null, null) ;
        this.doTranslateAnimation(pdfPurchaseView, 300, deviceWidth, 0, 0, 0, null, null) ;
        currentView = VIEW_SELL_PDF_PURCHASE ;
        this.hideFloatingMenu();
        this.trackPageView("AboutPdf/") ;
    }

    public void removePdfPurchase(){
        if(pdfPurchaseView != null){
            pdfPurchaseView.removeAllViews() ;
            this.rootLayout.removeView(pdfPurchaseView) ;
            pdfPurchaseView = null ;
        }
    }

    public void createPdfPurchase(){

        //VeamUtil.log("debug","createPdfPurchase "+currentSellPdfObject.getId() + " " + currentSellPdfObject.getDescription()) ;

        this.removePdfPurchase();

        pdfPurchaseView = this.addMainView(rootLayout,View.VISIBLE) ;

        pdfPurchaseScrollView = new ScrollView(this) ;
        pdfPurchaseScrollView.setVerticalScrollBarEnabled(false) ;
        pdfPurchaseScrollView.setBackgroundColor(Color.TRANSPARENT) ;
        RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,viewHeight) ;
        pdfPurchaseView.addView(pdfPurchaseScrollView,relativeLayoutParams) ;

        int padding = deviceWidth * 3 / 100 ;
        LinearLayout contentView = new LinearLayout(this) ;
        contentView.setPadding(padding, topBarHeight+padding, padding, 0) ;
        contentView.setOrientation(LinearLayout.VERTICAL) ;
        pdfPurchaseScrollView.addView(contentView) ;

        Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

        TextView textView = new TextView(this) ;
        textView.setText(currentSellPdfObject.getDescription()) ;
        textView.setTextSize((float)deviceWidth * 4.7f / 100 / scaledDensity) ;
        textView.setBackgroundColor(Color.TRANSPARENT) ;
        textView.setTypeface(typefaceRobotoLight) ;
        textView.setTextColor(VeamUtil.getColorFromArgbString("FF2E2E30")) ;
        LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,LinearLayout.LayoutParams.WRAP_CONTENT) ;
        contentView.addView(textView,linearLayoutParams) ;

        TextView purchaseTextView = new TextView(this) ;
        purchaseTextView.setId(VIEWID_SELL_PDF_PURCHASE) ;
        purchaseTextView.setOnClickListener(this) ;
        purchaseTextView.setText(currentSellPdfObject.getButtonText()) ;
        purchaseTextView.setTextSize((float)deviceWidth * 5.5f / 100 / scaledDensity) ;
        purchaseTextView.setBackgroundColor(VeamUtil.getLinkTextColor(this)) ;
        purchaseTextView.setTypeface(Typeface.SERIF) ;
        purchaseTextView.setTextColor(Color.WHITE) ;
        purchaseTextView.setGravity(Gravity.CENTER) ;
        linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,deviceWidth*12/100) ;
        contentView.addView(purchaseTextView,linearLayoutParams) ;

        this.addTopBar(pdfPurchaseView, "About PDF",true,true) ;

    }











    public void showAudioPurchase(){
        this.createAudioPurchase() ;
        this.doTranslateAnimation(sellAudioView, 300, 0, -deviceWidth, 0, 0, null, null) ;
        this.doTranslateAnimation(audioPurchaseView, 300, deviceWidth, 0, 0, 0, null, null) ;
        currentView = VIEW_SELL_AUDIO_PURCHASE ;
        this.hideFloatingMenu();
        this.trackPageView("AboutAudio/") ;
    }

    public void removeAudioPurchase(){
        if(audioPurchaseView != null){
            audioPurchaseView.removeAllViews() ;
            this.rootLayout.removeView(audioPurchaseView) ;
            audioPurchaseView = null ;
        }
    }

    public void createAudioPurchase(){

        //VeamUtil.log("debug","createAudioPurchase "+currentSellAudioObject.getId() + " " + currentSellAudioObject.getDescription()) ;

        this.removeAudioPurchase();

        audioPurchaseView = this.addMainView(rootLayout,View.VISIBLE) ;

        audioPurchaseScrollView = new ScrollView(this) ;
        audioPurchaseScrollView.setVerticalScrollBarEnabled(false) ;
        audioPurchaseScrollView.setBackgroundColor(Color.TRANSPARENT) ;
        RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,viewHeight) ;
        audioPurchaseView.addView(audioPurchaseScrollView,relativeLayoutParams) ;

        int padding = deviceWidth * 3 / 100 ;
        LinearLayout contentView = new LinearLayout(this) ;
        contentView.setPadding(padding, topBarHeight+padding, padding, 0) ;
        contentView.setOrientation(LinearLayout.VERTICAL) ;
        audioPurchaseScrollView.addView(contentView) ;

        Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

        TextView textView = new TextView(this) ;
        textView.setText(currentSellAudioObject.getDescription()) ;
        textView.setTextSize((float)deviceWidth * 4.7f / 100 / scaledDensity) ;
        textView.setBackgroundColor(Color.TRANSPARENT) ;
        textView.setTypeface(typefaceRobotoLight) ;
        textView.setTextColor(VeamUtil.getColorFromArgbString("FF2E2E30")) ;
        LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,LinearLayout.LayoutParams.WRAP_CONTENT) ;
        contentView.addView(textView,linearLayoutParams) ;

        TextView purchaseTextView = new TextView(this) ;
        purchaseTextView.setId(VIEWID_SELL_AUDIO_PURCHASE) ;
        purchaseTextView.setOnClickListener(this) ;
        purchaseTextView.setText(currentSellAudioObject.getButtonText()) ;
        purchaseTextView.setTextSize((float)deviceWidth * 5.5f / 100 / scaledDensity) ;
        purchaseTextView.setBackgroundColor(VeamUtil.getLinkTextColor(this)) ;
        purchaseTextView.setTypeface(Typeface.SERIF) ;
        purchaseTextView.setTextColor(Color.WHITE) ;
        purchaseTextView.setGravity(Gravity.CENTER) ;
        linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,deviceWidth*12/100) ;
        contentView.addView(purchaseTextView,linearLayoutParams) ;

        this.addTopBar(audioPurchaseView, "About Audio",true,true) ;

    }
























    @Override
	public void resetProfileButton(){
		super.resetProfileButton() ;
	}


    @Override
    public void onCancelPreviewDownload(String contentId) {
    }

    @Override
    public void onCompletePreviewDownload(String contentId) {
        if(sellVideoAdapter != null){
            sellVideoAdapter.notifyDataSetChanged();
        }
        this.playVideoObject() ;
    }

    public void playVideoObject(){
        if(currentVideoObject != null){
            //VeamUtil.log("debug","playSolo") ;
            Intent intentPlayMovie = new Intent(this,VideoPlayActivity.class) ;

            String key = currentVideoObject.getVideoKey() ;
            intentPlayMovie.putExtra("FILENAME",String.format("p%s.mp4", currentVideoObject.getId())) ;
            intentPlayMovie.putExtra("KEY", key) ;
            intentPlayMovie.putExtra("CONTENTID", currentVideoObject.getId()) ;
            intentPlayMovie.putExtra("TITLE", currentVideoObject.getTitle()) ;
            startActivityForResult(intentPlayMovie, REQUEST_CODE_ACTIVITY_PLAYER) ;
            overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
        }
    }


    public void playPdfObject(){
        if(currentPdfObject != null){
            //VeamUtil.log("debug","playSolo") ;

            String pdfUrl = VeamUtil.getPdfUrl(this,currentPdfObject.getId()) ;
            String viewerUrl = VeamUtil.getPdfViewerUrl(this, pdfUrl) ;
            this.createPdfWebView(rootLayout, viewerUrl, currentPdfObject.getTitle(), currentPdfObject, false, true) ;
            this.doTranslateAnimation(sellPdfView, 300, 0, -deviceWidth, 0, 0, null, null) ;
            this.doTranslateAnimation(pdfWebView, 300, deviceWidth, 0, 0, 0, null, null) ;
            currentView = VIEW_SELL_PDF ;
            this.hideFloatingMenu();
        }
    }


    public void playAudioObject(){
        if(currentAudioObject != null){
            //VeamUtil.log("debug","playSolo") ;
            Intent audioDetailIntent = new Intent(this, AudioPlayActivity.class);
            audioDetailIntent.putExtra("AudioObject", (AudioObject) currentAudioObject);
            startActivityForResult(audioDetailIntent, 0);
            this.overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
        }
    }




    private void testInventory(){
        try {
            String[] jsonStrings = {
					/*Subscription*/// "{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000015\",\"productId\": \"co.veam.veam31000015.calendar.1m\"  ,\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"TEST_TOKEN\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000015\",\"productId\": \"co.veam.veam31000015.calendar.beginners.4w\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000015\",\"productId\": \"co.veam.veam31000015.calendar.beginners2.4w\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000015\",\"productId\": \"co.veam.veam31000015.video.201503\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000287\",\"productId\": \"co.veam.veam31000287.video.50053599\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000287\",\"productId\": \"co.veam.veam31000287.audio.155\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000287\",\"productId\": \"co.veam.veam31000287.pdf.14\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
            } ;
            Inventory inventory = new Inventory() ;
            for(int index = 0 ; index < jsonStrings.length ; index++){
                String jsonString = jsonStrings[index] ;
                Purchase purchase = new Purchase("TEST_ITEM_TYPE", jsonString, "TEST_SIGNATURE");
                inventory.addPurchase(purchase) ;
            }
            IabResult result = new IabResult(IabHelper.BILLING_RESPONSE_RESULT_OK,"") ;
            mGotInventoryListener.onQueryInventoryFinished(result, inventory) ;
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace() ;
        }
    }


    // Listener that's called when we finish querying the items and subscriptions we own
    IabHelper.QueryInventoryFinishedListener mGotInventoryListener = new IabHelper.QueryInventoryFinishedListener() {
        public void onQueryInventoryFinished(IabResult result, Inventory inventory) {
            //VeamUtil.log("debug", "Query inventory finished.") ;
            if (result.isFailure()) {
                //VeamUtil.log("debug", "Query inventory isFailure.") ;
                //complain("Failed to query inventory: " + result) ;
                return ;
            }

            //VeamUtil.log("debug", "Query inventory was successful.");
            SQLiteDatabase db = SellItemCategoryActivity.this.getDb() ;

            SellVideoObject[] sellVideoObjects = VeamUtil.getSellVideoObjects(db) ;
            if(sellVideoObjects != null){
                int count = sellVideoObjects.length ;
                for(int index = 0 ; index < count ; index++){
                    String productId = sellVideoObjects[index].getProductId() ;
                    // Do we have the premium upgrade?
                    Purchase sellVideoPurchase = inventory.getPurchase(productId);
                    boolean sellVideoBought = (sellVideoPurchase != null && verifyDeveloperPayload(sellVideoPurchase));
                    //VeamUtil.log("debug", productId + " is " + (fixedCalendarBought ? "bought" : "not bought"));
                    if(sellVideoBought){
                        VeamUtil.setSellVideoIsBought(SellItemCategoryActivity.this, true, sellVideoObjects[index].getId()) ;
                    }
                }
            }

            SellPdfObject[] sellPdfObjects = VeamUtil.getSellPdfObjects(db) ;
            if(sellPdfObjects != null){
                int count = sellPdfObjects.length ;
                for(int index = 0 ; index < count ; index++){
                    String productId = sellPdfObjects[index].getProductId() ;
                    // Do we have the premium upgrade?
                    Purchase sellPdfPurchase = inventory.getPurchase(productId);
                    boolean sellPdfBought = (sellPdfPurchase != null && verifyDeveloperPayload(sellPdfPurchase));
                    //VeamUtil.log("debug", productId + " is " + (fixedCalendarBought ? "bought" : "not bought"));
                    if(sellPdfBought){
                        SellItemCategoryActivity.this.setSellPdfIsBought(true, sellPdfObjects[index]);
                        //VeamUtil.setSellPdfIsBought(SellItemCategoryActivity.this, true, sellPdfObjects[index].getId());
                    }
                }
            }

            SellAudioObject[] sellAudioObjects = VeamUtil.getSellAudioObjects(db) ;
            if(sellAudioObjects != null){
                int count = sellAudioObjects.length ;
                for(int index = 0 ; index < count ; index++){
                    String productId = sellAudioObjects[index].getProductId() ;
                    // Do we have the premium upgrade?
                    Purchase sellAudioPurchase = inventory.getPurchase(productId);
                    boolean sellAudioBought = (sellAudioPurchase != null && verifyDeveloperPayload(sellAudioPurchase));
                    //VeamUtil.log("debug", productId + " is " + (fixedCalendarBought ? "bought" : "not bought"));
                    if(sellAudioBought){
                        SellItemCategoryActivity.this.setSellAudioIsBought(true, sellAudioObjects[index]);
                        //VeamUtil.setSellAudioIsBought(SellItemCategoryActivity.this, true, sellAudioObjects[index].getId());
                    }
                }
            }

            //VeamUtil.log("debug", "Initial inventory query finished; enabling main UI.") ;
        }
    };

    /** Verifies the developer payload of a purchase. */
    boolean verifyDeveloperPayload(Purchase p) {

        // subscription の inventory で payload に空の値が入ってくるようになったので、暫定的にチェックはすべてOKで返すようにする。
        return true ;

    	/*
        String payload = p.getDeveloperPayload();
        //VeamUtil.log("debug","payload="+payload) ;
        return payload.equals(this.payloadString) ;
        */
        /*
         * TODO: verify that the developer payload of the purchase is correct. It will be
         * the same one that you sent when initiating the purchase.
         *
         * WARNING: Locally generating a random string when starting a purchase and
         * verifying it here might seem like a good approach, but this will fail in the
         * case where the user purchases an item on one device and then uses your app on
         * a different device, because on the other device you will not have access to the
         * random string you originally generated.
         *
         * So a good developer payload has these characteristics:
         *
         * 1. If two different users purchase an item, the payload is different between them,
         *    so that one user's purchase can't be replayed to another user.
         *
         * 2. The payload must be such that you can verify it even when the app wasn't the
         *    one who initiated the purchase flow (so that items purchased by the user on
         *    one device work on other devices owned by the user).
         *
         * Using your own server to store and verify developer payloads across app
         * installations is recommended.
         */

        //return true;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //VeamUtil.log(TAG, "onActivityResult(" + requestCode + "," + resultCode + "," + data);

        if((iabHelper != null) && iabSetupDone){
            // Pass on the activity result to the helper for handling
            if (!iabHelper.handleActivityResult(requestCode, resultCode, data)) {
                // not handled, so handle it ourselves (here's where you'd
                // perform any handling of activity results not related to in-app
                // billing...
                super.onActivityResult(requestCode, resultCode, data);
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    public void setSellPdfIsBought(boolean isBought,SellPdfObject sellPdfObject){
        VeamUtil.setSellPdfIsBought(SellItemCategoryActivity.this, isBought, sellPdfObject.getId()) ;
        if(isBought) {
            PdfObject pdfObject = VeamUtil.getPdfObject(mDb, sellPdfObject.getPdfId()) ;
            if(pdfObject != null) {
                UpdatePdfTask updatePdfTask = new UpdatePdfTask(this, sellPdfObject);
                updatePdfTask.execute("");
            }
        }
    }

    public void setSellAudioIsBought(boolean isBought,SellAudioObject sellAudioObject){
        VeamUtil.setSellAudioIsBought(SellItemCategoryActivity.this, isBought, sellAudioObject.getId()) ;
        if(isBought) {
            AudioObject audioObject = VeamUtil.getAudioObject(mDb, sellAudioObject.getAudioId()) ;
            if(audioObject != null) {
                UpdateAudioTask updateAudioTask = new UpdateAudioTask(this, sellAudioObject);
                updateAudioTask.execute("");
            }
        }
    }

    // Callback for when a purchase is finished
    IabHelper.OnIabPurchaseFinishedListener mPurchaseFinishedListener = new IabHelper.OnIabPurchaseFinishedListener() {
        public void onIabPurchaseFinished(IabResult result, Purchase purchase) {
            //VeamUtil.log("deubg", "Purchase finished: " + result + ", purchase: " + purchase);

            if (result.isFailure()) {
                if(result.getResponse() == IabHelper.BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED){
                    VeamUtil.showMessage(SellItemCategoryActivity.this, "already purchased") ;
                    if(currentView == VIEW_SELL_VIDEO_PURCHASE){
                        //VeamUtil.log("deubg", "beginners");
                        if(currentSellVideoObject != null){
                            VeamUtil.setSellVideoIsBought(SellItemCategoryActivity.this, true, currentSellVideoObject.getId()) ;
                        }
                    } else if(currentView == VIEW_SELL_PDF_PURCHASE){
                        //VeamUtil.log("deubg", "beginners");
                        if(currentSellPdfObject != null){
                            SellItemCategoryActivity.this.setSellPdfIsBought(true, currentSellPdfObject) ;
                            //VeamUtil.setSellPdfIsBought(SellItemCategoryActivity.this, true, currentSellPdfObject.getId()) ;
                        }
                    } else if(currentView == VIEW_SELL_AUDIO_PURCHASE){
                        //VeamUtil.log("deubg", "beginners");
                        if(currentSellAudioObject != null){
                            SellItemCategoryActivity.this.setSellAudioIsBought(true, currentSellAudioObject) ;
                            //VeamUtil.setSellAudioIsBought(SellItemCategoryActivity.this, true, currentSellAudioObject.getId()) ;
                        }
                    }
                    return ;
                }
                if(result.getResponse() != IabHelper.IABHELPER_USER_CANCELLED){
                    complain("Error purchasing: " + result);
                }
                //setWaitScreen(false);
                return;
            }
            if (!verifyDeveloperPayload(purchase)) {
                complain("Error purchasing. Authenticity verification failed.");
                //setWaitScreen(false);
                return;
            }

            //VeamUtil.log(TAG, "Purchase successful.");

            SQLiteDatabase db = SellItemCategoryActivity.this.getDb() ;
            SellVideoObject[] sellVideoObjects = VeamUtil.getSellVideoObjects(db) ;
            if(sellVideoObjects != null){
                int count = sellVideoObjects.length ;
                for(int index = 0 ; index < count ; index++){
                    String productId = sellVideoObjects[index].getProductId() ;
                    if(purchase.getSku().equals(productId)){
                        showGoodJobImage(true) ;
                        setSellVideoBought(productId, sellVideoObjects[index].getId()) ;
                    }
                }
            }

            SellPdfObject[] sellPdfObjects = VeamUtil.getSellPdfObjects(db) ;
            if(sellPdfObjects != null){
                int count = sellPdfObjects.length ;
                for(int index = 0 ; index < count ; index++){
                    String productId = sellPdfObjects[index].getProductId() ;
                    if(purchase.getSku().equals(productId)){
                        showGoodJobImage(true) ;
                        setSellPdfBought(productId, sellPdfObjects[index]);
                    }
                }
            }

            SellAudioObject[] sellAudioObjects = VeamUtil.getSellAudioObjects(db) ;
            if(sellAudioObjects != null){
                int count = sellAudioObjects.length ;
                for(int index = 0 ; index < count ; index++){
                    String productId = sellAudioObjects[index].getProductId() ;
                    if(purchase.getSku().equals(productId)){
                        showGoodJobImage(true) ;
                        setSellAudioBought(productId, sellAudioObjects[index]);
                    }
                }
            }

        }
    };

    void complain(String message) {
        //Log.e(TAG, "**** Tutorial Error: " + message);
        alert("Error: " + message);
    }

    void alert(String message) {
        AlertDialog.Builder bld = new AlertDialog.Builder(this);
        bld.setMessage(message);
        bld.setNeutralButton("OK", null);
        //VeamUtil.log(TAG, "Showing alert dialog: " + message);
        bld.create().show();
    }

    public void showGoodJobImage(boolean isThankYou){
        int resourceId = VeamUtil.getDrawableId(this, String.format("goodjob%d",(int)(Math.random()*10))) ;
        if(isThankYou){
            if(Build.VERSION.SDK_INT < 14){
                return ;
            }
            resourceId = R.drawable.thankyou ;
        }
        if(goodJobImageView != null){
            this.rootLayout.removeView(goodJobImageView) ;
            goodJobImageView = null ;
        }

        int goodJobImageSize = deviceWidth / 2 ;
        goodJobImageView = new ImageView(this) ;
        if(isThankYou) {
            //this.goodJobImageView.setImageResource(resourceId);
            this.goodJobImageView.setImageBitmap(VeamUtil.getThemeImage(this, "thankyou", 1)) ;
        } else {
            this.goodJobImageView.setImageResource(resourceId);
        }
        goodJobImageView.setVisibility(View.INVISIBLE) ;
        RelativeLayout.LayoutParams layoutParams = createParam(goodJobImageSize, goodJobImageSize) ;
        layoutParams.setMargins(deviceWidth / 4, (viewHeight - goodJobImageSize) / 2, 0, 0) ;
        rootLayout.addView(goodJobImageView, layoutParams) ;
        this.doFadeOutAnimation(goodJobImageView, 2000, "removeGoodJobImage", null) ;
    }

    public void removeGoodJobImage(){
        if(goodJobImageView != null){
            rootLayout.removeView(goodJobImageView) ;
            goodJobImageView = null ;
        }
    }



    public void setSellVideoBought(String productId,String sellVideoId){
        //beginnersBought = true ;
        VeamUtil.setSellVideoIsBought(this, true, sellVideoId) ;
        if(currentView == VIEW_SELL_VIDEO_PURCHASE){
            if(sellVideoAdapter != null){
                sellVideoAdapter.notifyDataSetChanged();
            }
            this.hideVideoPurchase() ;
        }
    }

    public void setSellPdfBought(String productId,SellPdfObject sellPdfObject){
        //beginnersBought = true ;
        String sellPdfId = sellPdfObject.getId() ;
        VeamUtil.setSellPdfIsBought(this, true, sellPdfId);
        if(currentView == VIEW_SELL_PDF_PURCHASE){
            if(sellPdfAdapter != null){
                sellPdfAdapter.notifyDataSetChanged();
            }
            this.hidePdfPurchase() ;
        }
        UpdatePdfTask updatePdfTask = new UpdatePdfTask(this, sellPdfObject);
        updatePdfTask.execute("");
    }

    public void setSellAudioBought(String productId,SellAudioObject sellAudioObject){
        //beginnersBought = true ;
        String sellAudioId = sellAudioObject.getId() ;
        VeamUtil.setSellAudioIsBought(this, true, sellAudioId);
        if(currentView == VIEW_SELL_AUDIO_PURCHASE){
            if(sellAudioAdapter != null){
                sellAudioAdapter.notifyDataSetChanged();
            }
            this.hideAudioPurchase() ;
        }
        UpdateAudioTask updateAudioTask = new UpdateAudioTask(this, sellAudioObject);
        updateAudioTask.execute("");
    }

    public void hideVideoPurchase(){
        this.doTranslateAnimation(sellVideoView, 300, -deviceWidth, 0, 0, 0, "showSellVideoListView", null) ;
        this.doTranslateAnimation(videoPurchaseView, 300, 0, deviceWidth, 0, 0, "removeVideoPurchase", null) ;
        currentView = VIEW_SELL_VIDEO_LIST ;
        this.showFloatingMenu();
        this.trackPageView("SellVideoList/") ;
    }

    public void hidePdfPurchase(){
        this.doTranslateAnimation(sellPdfView, 300, -deviceWidth, 0, 0, 0, "showSellPdfListView", null) ;
        this.doTranslateAnimation(pdfPurchaseView, 300, 0, deviceWidth, 0, 0, "removePdfPurchase", null) ;
        currentView = VIEW_SELL_PDF_LIST ;
        this.showFloatingMenu();
        this.trackPageView("SellPdfList/") ;
    }

    public void hideAudioPurchase(){
        this.doTranslateAnimation(sellAudioView, 300, -deviceWidth, 0, 0, 0, "showSellAudioListView", null) ;
        this.doTranslateAnimation(audioPurchaseView, 300, 0, deviceWidth, 0, 0, "removeAudioPurchase", null) ;
        currentView = VIEW_SELL_AUDIO_LIST ;
        this.showFloatingMenu();
        this.trackPageView("SellAudioList/") ;
    }

    public void removeWeb(){
        if(pdfWebView != null){
            pdfWebView.removeAllViews() ;
            this.rootLayout.removeView(pdfWebView) ;
            pdfWebView = null ;

            webPageView.stopLoading();
            webPageView.setWebViewClient(null);
            webPageView.setWebChromeClient(null);
            webPageView.destroy();
            webPageView = null;
        }
    }




    public void createPdfWebView(RelativeLayout rootLayout,String url,String title,PdfObject pdfObject,boolean isImage,boolean showSettingsButton) {
        pdfWebView = this.addMainView(rootLayout,View.VISIBLE) ;

        if(showSettingsButton){
            this.addTopBar(pdfWebView, title,true,true) ;
        } else {
            this.addTopBar(pdfWebView, title,true,false) ;
        }

        webPageView = new WebView(this) ;


        webPageView.setBackgroundColor(Color.argb(0,0,0,0)) ;
        webPageView.getSettings().setJavaScriptEnabled(true);
        webPageView.getSettings().setPluginState(WebSettings.PluginState.ON) ;
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
                browserProgress.setVisibility(View.VISIBLE) ;
                super.onPageStarted(view, url, favicon);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                //System.out.println("onPageFinished") ;
                browserProgress.setVisibility(View.GONE) ;
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

        if(isImage){
            String htmlString = String.format("<html><body><img src=\"%s\" width=\"100%%\"></body></html>",url) ;
            webPageView.loadData(URLEncoder.encode(htmlString).replaceAll("\\+"," "), "text/html", "utf-8" );
            //webPageView.loadData(htmlString, "text/html", "UTF-8") ;
        } else {
            webPageView.loadUrl(url) ;
        }

        int urlHeight = deviceWidth * 8 / 100 ;
        int urlTextHeight = deviceWidth * 6 / 100 ;



        Typeface typeface = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

        String urlText = String.format("http://dl.veam.co/pdf/dl/i/%s/t/%s", pdfObject.getId(), VeamUtil.getPdfToken(this,pdfObject.getId())) ;
        //String urlText = String.format("http://dl.veam.co/pdf/dl/i/TEST/t/TEST") ;
        float urlSize = (float) deviceWidth * 3.8f / 100 / scaledDensity ;
        urlTextView = new TextView(this) ;
        urlTextView.setId(VIEWID_PDF_URL) ;
        urlTextView.setOnClickListener(this);
        urlTextView.setText(urlText) ;
        urlTextView.setBackgroundColor(Color.TRANSPARENT) ;
        urlTextView.setBackgroundResource(R.drawable.textline_blue);
        ((GradientDrawable)urlTextView.getBackground()).setColor(VeamUtil.getTopBarColor(this));
        urlTextView.setGravity(Gravity.CENTER_HORIZONTAL);
        urlTextView.setPadding(0, 0, 0, 0);
        urlTextView.setTextSize(urlSize) ;
        urlTextView.setTypeface(typeface) ;
        urlTextView.setMaxLines(1) ;
        urlTextView.setTextColor(Color.WHITE) ;
        RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*90/100,urlTextHeight) ;
        relativeLayoutParams.setMargins(deviceWidth * 5 / 100, topBarHeight + (urlHeight - urlTextHeight)/2, 0, 0) ;
        pdfWebView.addView(urlTextView,relativeLayoutParams) ;






        RelativeLayout.LayoutParams layoutParams = createParam(deviceWidth, viewHeight-topBarHeight - urlHeight) ;
        layoutParams.setMargins(0, topBarHeight + urlHeight, 0, 0) ;
        pdfWebView.addView(webPageView,layoutParams) ;

        browserProgress = new ProgressBar(this) ;
        browserProgress.setIndeterminate(true) ;
        int progressSize = deviceWidth * 10 / 100 ;
        layoutParams = createParam(progressSize, progressSize) ;
        layoutParams.setMargins(deviceWidth * 45 / 100, topBarHeight + (viewHeight-progressSize)/2, 0, 0) ;
        browserProgress.setVisibility(View.GONE) ;
        pdfWebView.addView(browserProgress,layoutParams) ;

        int buttonWidth = deviceWidth * 15 / 100 ;
        int buttonHeight = buttonWidth * 102 / 90 ;

        backwardImageView = new ImageView(this) ;
        backwardImageView.setId(VIEWID_BROWSER_BACKWARD_BUTTON) ;
        backwardImageView.setOnClickListener(this) ;
        backwardImageView.setImageResource(R.drawable.br_backward_off) ;
        backwardImageView.setScaleType(ImageView.ScaleType.FIT_XY) ;
        backwardImageView.setVisibility(View.GONE) ;
        layoutParams = createParam(buttonWidth, buttonHeight) ;
        layoutParams.setMargins(deviceWidth/2-buttonWidth, viewHeight-buttonHeight-deviceWidth*3/100, 0, 0) ;
        pdfWebView.addView(backwardImageView,layoutParams) ;

        forwardImageView = new ImageView(this) ;
        forwardImageView.setId(VIEWID_BROWSER_FORWARD_BUTTON) ;
        forwardImageView.setOnClickListener(this) ;
        forwardImageView.setImageResource(R.drawable.br_forward_off) ;
        forwardImageView.setScaleType(ImageView.ScaleType.FIT_XY) ;
        forwardImageView.setVisibility(View.GONE) ;
        layoutParams = createParam(buttonWidth, buttonHeight) ;
        layoutParams.setMargins(deviceWidth/2, viewHeight-buttonHeight-deviceWidth*3/100, 0, 0) ;
        pdfWebView.addView(forwardImageView,layoutParams) ;
    }



    @Override
    protected int getFloatingMenuKind(){
        return FLOATING_MENU_KIND_EDIT ;
    }

    @Override
    protected boolean startEditModeActivity(){
        VeamUtil.log("debug", "startEditModeActivity") ;
        if(!super.startEditModeActivity()) {
            if (currentView == VIEW_SELL_ITEM_CATEGORY_LIST) {
                Intent intent = new Intent(this, ConsoleSellItemCategoryActivity.class);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.sell_content_category));
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 2);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, TEMPLATE_ID);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
                startActivity(intent);
                overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
            } else if (currentView == VIEW_SELL_AUDIO_LIST) {
                Intent intent = new Intent(this, ConsoleSellAudioActivity.class);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.sell_audio_upload));
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 2);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, TEMPLATE_ID);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLITEMCATEGORY_ID, currentSellItemCategoryObject.getId());
                startActivity(intent);
                overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
            } else if (currentView == VIEW_SELL_VIDEO_LIST) {
                Intent intent = new Intent(this, ConsoleSellVideoActivity.class);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.sell_video_upload));
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 2);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, TEMPLATE_ID);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLITEMCATEGORY_ID, currentSellItemCategoryObject.getId());
                startActivity(intent);
                overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
            } else if (currentView == VIEW_SELL_PDF_LIST) {
                Intent intent = new Intent(this, ConsoleSellPdfActivity.class);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.sell_pdf_upload));
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 2);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, TEMPLATE_ID);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, true);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE, ConsoleUtil.VEAM_CONSOLE_SETTING_MODE);
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLITEMCATEGORY_ID, currentSellItemCategoryObject.getId());
                startActivity(intent);
                overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
            }
        }
        return true ;
    }


    @Override
    public void onContentsUpdated(){
        VeamUtil.log("debug", "SellItemCategoryActivity::onContentsUpdated") ;
        if(categoryListView != null) {
            SellItemCategoryObject[] sellItemCategoryObjects = VeamUtil.getSellItemCategoryObjects(mDb) ;
            sellItemCategoryAdapter = new SellItemCategoryAdapter(this,sellItemCategoryObjects,deviceWidth,topBarHeight,scaledDensity) ;
            categoryListView.setAdapter(sellItemCategoryAdapter) ;
        }

        if(sellVideoListView != null) {
            SellVideoObject[] sellVideoObjects = VeamUtil.getSellVideoObjectsForVideoCategory(mDb, currentVideoCategoryObject.getId()) ;
            VideoObject[] videoObjects = VeamUtil.getVideoObjects(this, mDb, currentVideoCategoryObject.getId(), "0");
            sellVideoAdapter = new SellVideoAdapter(this, sellVideoObjects, videoObjects, deviceWidth, topBarHeight, scaledDensity);
            sellVideoListView.setAdapter(sellVideoAdapter);
        }

        if(sellPdfListView != null) {
            SellPdfObject[] sellPdfObjects = VeamUtil.getSellPdfObjectsForPdfCategory(mDb, currentPdfCategoryObject.getId());
            PdfObject[] pdfObjects = VeamUtil.getPdfObjects(this, mDb, currentPdfCategoryObject.getId(), "0");
            sellPdfAdapter = new SellPdfAdapter(this, sellPdfObjects, pdfObjects, deviceWidth, topBarHeight, scaledDensity);
            sellPdfListView.setAdapter(sellPdfAdapter);
        }

        if(sellAudioListView != null) {
            SellAudioObject[] sellAudioObjects = VeamUtil.getSellAudioObjectsForAudioCategory(mDb, currentAudioCategoryObject.getId());
            AudioObject[] audioObjects = VeamUtil.getAudioObjects(this, mDb, currentAudioCategoryObject.getId(), "0");
            sellAudioAdapter = new SellAudioAdapter(this, sellAudioObjects, audioObjects, deviceWidth, topBarHeight, scaledDensity);
            sellAudioListView.setAdapter(sellAudioAdapter);
        }
    }


}
