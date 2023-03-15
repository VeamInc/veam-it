package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.veam.inappbilling.util.IabHelper;
import com.veam.inappbilling.util.IabResult;
import com.veam.inappbilling.util.Inventory;
import com.veam.inappbilling.util.Purchase;

import org.json.JSONException;

import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * Created by veam on 2015/06/03.
 */
public class ExclusiveGridActivity extends VeamActivity implements View.OnClickListener, AdapterView.OnItemClickListener, PreviewDownloadTask.PreviewDownloadListenerInterface {

    private RelativeLayout rootLayout ;
    private RelativeLayout mainView ;

    /*
    private RelativeLayout subscriptionView ;
    private ScrollView subscriptionScrollView ;
    */

    private RelativeLayout subscriptionPurchaseView ;
    private ScrollView subscriptionPurchaseScrollView ;

    /*
    private RelativeLayout beginnersView ;
    private RelativeLayout beginnersPurchaseView ;
    private ScrollView beginnersPurchaseScrollView ;
    */

    private HeaderGridView gridView ;
    private MixedGridAdapter mixedGridAdapter ;
    private TextView[] subscriptionWorkoutTextViews ;

    private RelativeLayout calendarSelectView ;
    private ListView selectListView ;

    private YoutubeObject currentYoutubeObject = null ;

    private boolean iabSetupDone = false ;


    // The helper object
    IabHelper iabHelper;
    private final String payloadString = "VEAM_IN_APP_BILLING"; // TODO shou be dynamically generated

    private final int REQUEST_CODE_PURCHASE			        = 0x0001 ;
    private final int REQUEST_CODE_ACTIVITY_VIDEO_PLAYER 	= 0x0002 ;
    private final int REQUEST_CODE_ACTIVITY_AUDIO_PLAYER 	= 0x0003 ;

    private final int CALENDAR_SUBSCRIPTION			= 1 ;
    private final int CALENDAR_BEGINNERS		 	= 2 ;
    private int currentCalendar = 0 ;

    private RelativeLayout subCategoryView ;
    private LinearLayout workoutArea ;
    private TextView weekdayTextView ;
    private TextView weekdayCommentTextView ;
    TextView wordsOfTheDayTextView ;
    private int targetYear ;
    private int targetMonth ;
    private ImageView goodJobImageView ;

    private VideoObject currentVideoObject ;

    AdView adView ;


    //private boolean beginnersBought = false ;
    //private boolean subscriptionBought = false ;

    public static int VIEWID_CALENDAR_CATEGORY			= 0x10001 ;
    public static int VIEWID_CALENDAR_LIST				= 0x10002 ;
    public static int VIEWID_SUBSCRIPTION				= 0x10003 ;
    public static int VIEWID_BEGINNERS				 	= 0x10004 ;
    public static int VIEWID_CALENDAR_LABEL			 	= 0x10005 ;
    public static int VIEWID_SUBSCRIPTION_CHECKBOX		= 0x10006 ;
    public static int VIEWID_SUBSCRIPTION_WORKOUT		= 0x10007 ;
    public static int VIEWID_SUBSCRIPTION_VIDEO			= 0x10008 ;
    public static int VIEWID_SUBSCRIPTION_LIST_BUTTON	= 0x10009 ;
    public static int VIEWID_CALENDAR_SELECT			= 0x1000a ;
    public static int VIEWID_SUBSCRIPTION_PURCHASE		= 0x1000b ;
    public static int VIEWID_BEGINNERS_PURCHASE			= 0x1000c ;

    private int previousView ;
    private int currentView ;
    private static int VIEW_MIXED_GRID 		      = 1 ;
    private static int VIEW_SUBSCRIPTION_PURCHASE 		= 2 ;

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

        this.pageName = "Exclusive" ;

        //VeamUtil.setSubscriptionIsBought(this,true) ; // TODO TEST

        RelativeLayout.LayoutParams layoutParams ;

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;

        this.addBaseBackground(rootLayout) ;
        this.addTab(rootLayout, TEMPLATE_ID, true) ;

        mainView = this.addMainView(rootLayout,View.VISIBLE) ;

        gridView = new HeaderGridView(this) ;

        gridView.setNumColumns(4) ;
        gridView.setPadding(deviceWidth * 3 / 100, 0, deviceWidth * 3 / 100, 0) ;
        gridView.setOnItemClickListener(this) ;
        gridView.setSelector(new ColorDrawable(Color.argb(0x00, 0xFD, 0xD4, 0xDB))) ;
        gridView.setBackgroundColor(Color.TRANSPARENT) ;
        gridView.setCacheColorHint(Color.TRANSPARENT) ;
        gridView.setVerticalScrollBarEnabled(false) ;
        gridView.setPadding(0, topBarHeight, 0, 0) ;
        layoutParams = createParam(deviceWidth, viewHeight) ;
        mainView.addView(gridView,layoutParams) ;

        if(VeamUtil.isSubscriptionFree(this)) {
            if(VeamUtil.isActiveAdmob) {
                adView = new AdView(this);
                adView.setAdSize(AdSize.SMART_BANNER);
                adView.setAdUnitId(this.getString(R.string.admob_id_exclusive));
                android.widget.AbsListView.LayoutParams params = new android.widget.AbsListView.LayoutParams(deviceWidth, AbsListView.LayoutParams.WRAP_CONTENT);
                adView.setLayoutParams(params);
                adView.loadAd(VeamUtil.getAdRequest());
                gridView.addHeaderView(adView);
            }
        }

        this.addTopBar(mainView,this.getString(R.string.exclusive),false,true) ;

        MixedObject[] mixedObjects = null ;
        if(VeamUtil.getSubscriptionIsBought(this)){
            mixedObjects = VeamUtil.getMixedObjectsForExclusive(mDb,VeamUtil.getSubscriptionStart(this,VeamUtil.getSubscriptionIndex(this))) ;
        }
        mixedGridAdapter = new MixedGridAdapter(this,mixedObjects,deviceWidth,topBarHeight,scaledDensity) ;
        gridView.setAdapter(mixedGridAdapter) ;

        currentView = VIEW_MIXED_GRID ;

        GregorianCalendar today = new GregorianCalendar() ;
        targetYear = today.get(Calendar.YEAR) ;
        targetMonth = today.get(Calendar.MONTH) + 1 ;


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
                    VeamUtil.showMessage(ExclusiveGridActivity.this,ExclusiveGridActivity.this.getString(R.string.iab_setup_failed) + result);
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
        setSwipeView(gridView);
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
        //this.goodJobImageView.setImageResource(resourceId) ;
        this.goodJobImageView.setImageBitmap(VeamUtil.getThemeImage(this,"thankyou",1)) ;
        goodJobImageView.setVisibility(View.INVISIBLE) ;
        RelativeLayout.LayoutParams layoutParams = createParam(goodJobImageSize, goodJobImageSize) ;
        layoutParams.setMargins(deviceWidth/4, (viewHeight-goodJobImageSize)/2, 0,0) ;
        rootLayout.addView(goodJobImageView, layoutParams) ;
        this.doFadeOutAnimation(goodJobImageView, 2000, "removeGoodJobImage", null) ;
    }

    public void removeGoodJobImage(){
        if(goodJobImageView != null){
            rootLayout.removeView(goodJobImageView) ;
            goodJobImageView = null ;
        }
    }

    private void testInventory(){
        try {
            String[] jsonStrings = {
					///*Subscription*/ "{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000287\",\"productId\": \"co.veam.veam31000287.subscription0.1m\"  ,\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"TEST_TOKEN\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000287\",\"productId\": \"co.veam.veam31000287.calendar.beginners.4w\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
                    //"{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000287\",\"productId\": \"co.veam.veam31000287.calendar.beginners2.4w\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"VEAM_IN_APP_BILLING\",\"token\": \"\"}",
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

            // Do we have the infinite gas plan?
            Purchase subscriptionPurchase = inventory.getPurchase(VeamUtil.getSubscriptionProductId(VeamUtil.getSubscriptionIndex(ExclusiveGridActivity.this))) ;
            boolean subscriptionBought = (subscriptionPurchase != null && verifyDeveloperPayload(subscriptionPurchase));
            //VeamUtil.log("debug", "subscription " + (subscriptionBought ? "bought" : "not bought"));
            if(subscriptionBought){
                //VeamUtil.log("debug","token:"+subscriptionPurchase.getToken()) ;
                VeamUtil.setSubscriptionIsBought(ExclusiveGridActivity.this, true) ;
                UpdateSubscriptionTask updateSubscriptionTask = new UpdateSubscriptionTask(ExclusiveGridActivity.this,subscriptionPurchase.getSku(),subscriptionPurchase.getToken()) ;
                updateSubscriptionTask.execute("") ;
            } else {
                VeamUtil.setSubscriptionIsBought(ExclusiveGridActivity.this, false) ;
            }

            //VeamUtil.log("debug", "Initial inventory query finished; enabling main UI.") ;
        }
    };

    public void hideSubscriptionPurchase(){
        this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, null, null) ;
        this.doTranslateAnimation(subscriptionPurchaseView, 300, 0, deviceWidth, 0, 0, "removeSubscriptionPurchase", null) ;
        currentView = VIEW_MIXED_GRID ;
        this.showFloatingMenu();
        this.trackPageView("Exclusive") ;
    }

    @Override
    public void onClick(View view) {
        super.onClick(view) ;
        //VeamUtil.log("debug","ExclusiveGridActivity::onClick") ;
        if(view.getId() == VIEWID_TOP_BAR_BACK_BUTTON){
            //VeamUtil.log("debug","back button tapped") ;
            if(currentView == VIEW_SUBSCRIPTION_PURCHASE){
                this.doTranslateAnimation(mainView, 300, -deviceWidth, 0, 0, 0, null, null) ;
                this.doTranslateAnimation(subscriptionPurchaseView, 300, 0, deviceWidth, 0, 0, "removeSubscriptionPurchase", null) ;
                currentView = VIEW_MIXED_GRID ;
                this.showFloatingMenu();
                this.trackPageView("Exclusive") ;
            }
        } else if(view.getId() == VIEWID_SUBSCRIPTION_VIDEO){
            /*
            if(this.isBoughtCurrentCalendar()) {
                Integer index = (Integer) view.getTag();
                currentVideoObject = this.monthlyVideoObjects[index];
                if (VeamUtil.previewExists(this, currentVideoObject.getId())) {
                    this.playVideoObject();
                } else {
                    PreviewDownloadTask previewDownloadTask = new PreviewDownloadTask(this, currentVideoObject, this.getString(R.string.PreviewDownloadTitie), this.getString(R.string.PreviewDownloadDescription));
                    previewDownloadTask.setListener(this);
                    previewDownloadTask.execute(currentVideoObject.getId());
                }
            }
            */
        } else if(view.getId() == VIEWID_SUBSCRIPTION_PURCHASE){
			/*
			showGoodJobImage(true) ; // TEST
			setSubscriptionBought("TEST_TOKEN") ; // TEST
			*/
            if(((iabHelper != null) && iabSetupDone) || VeamUtil.isTestInAppBilling()){
                String productId = VeamUtil.getSubscriptionProductId(VeamUtil.getSubscriptionIndex(this)) ;
                if(VeamUtil.isTestInAppBilling()){
                    //VeamUtil.log("debug","IN_APP_BILLING_TEST "+productId) ;
                    try {
                        IabResult result = new IabResult(IabHelper.BILLING_RESPONSE_RESULT_OK,"") ;
                        String jsonString = String.format("{\"orderId\": \"123456\",\"packageName\": \"co.veam.veam31000287\",\"productId\": \"%s\",\"purchaseTime\": \"0\",\"purchaseState\": \"0\",\"developerPayload\": \"%s\",\"token\": \"TEST_TOKEN\"}",productId,this.payloadString) ;
                        Purchase info = new Purchase("TEST_ITEM_TYPE", jsonString, "TEST_SIGNATURE");
                        mPurchaseFinishedListener.onIabPurchaseFinished(result, info) ;
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    iabHelper.launchSubscriptionPurchaseFlow(this, productId, REQUEST_CODE_PURCHASE, mPurchaseFinishedListener, payloadString);
                }
            } else {
                VeamUtil.showMessage(this,this.getString(R.string.iab_not_setup)) ;
            }
        }
    }

    public void removeSubscriptionPurchase(){
        if(subscriptionPurchaseView != null){
            subscriptionPurchaseView.removeAllViews() ;
            this.rootLayout.removeView(subscriptionPurchaseView) ;
            subscriptionPurchaseView = null ;
        }
    }

    public void hideGoodJobImage(){
        if(goodJobImageView != null){
            goodJobImageView.setVisibility(View.GONE) ;
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

    public void showSubscriptionPurchase(){
        this.createSubscriptionPurchase() ;
        this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, null, null) ;
        this.doTranslateAnimation(subscriptionPurchaseView, 300, deviceWidth, 0, 0, 0, null, null) ;
        currentCalendar = CALENDAR_SUBSCRIPTION ;
        currentView = VIEW_SUBSCRIPTION_PURCHASE ;
        this.hideFloatingMenu();
        this.trackPageView("AboutSubscription") ;
    }

    @Override
    public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
        //VeamUtil.log("debug", "onItemClick " + position) ;
        if(this.currentView == VIEW_MIXED_GRID) {
            if(VeamUtil.getSubscriptionIsBought(this)) {
                if(mixedGridAdapter != null){
                    if(VeamUtil.isSubscriptionFree(this)) {
                        position -= 4;
                    }
                    MixedObject mixedObject = (MixedObject)mixedGridAdapter.getItem(position) ;
                    if(mixedObject != null) {
                        String kind = mixedObject.getKind();
                        if (kind.equals(MixedObject.KIND_FIXED_VIDEO) || kind.equals(MixedObject.KIND_PERIODICAL_VIDEO)) {
                            currentVideoObject = VeamUtil.getVideoObject(mDb, mixedObject.getContentId());
                            if (currentVideoObject != null) {
                                //VeamUtil.log("debug", "Video Found");
                                if (VeamUtil.previewExists(this, currentVideoObject.getId())) {
                                    this.playVideoObject();
                                } else {
                                    PreviewDownloadTask previewDownloadTask = new PreviewDownloadTask(this, currentVideoObject, this.getString(R.string.PreviewDownloadTitie), this.getString(R.string.PreviewDownloadDescription));
                                    previewDownloadTask.setListener(this);
                                    previewDownloadTask.execute(currentVideoObject.getId());
                                }
                            } else {
                                //VeamUtil.log("debug", "No Video Found");
                            }
                        } else if (kind.equals(MixedObject.KIND_FIXED_AUDIO) || kind.equals(MixedObject.KIND_PERIODICAL_AUDIO)) {
                            AudioObject audioObject = VeamUtil.getAudioObject(mDb, mixedObject.getContentId());
                            if(audioObject != null) {
                                Intent audioDetailIntent = new Intent(this, AudioPlayActivity.class);
                                audioDetailIntent.putExtra("AudioObject", (AudioObject) audioObject);
                                startActivityForResult(audioDetailIntent, REQUEST_CODE_ACTIVITY_AUDIO_PLAYER);
                                this.overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
                            }
                        }
                    }
                }
            } else {
                this.showSubscriptionPurchase();
            }
        }





        /*
        if(listView == this.categoryListView){
            //VeamUtil.log("debug","categoryListView") ;
            if(currentView == VIEW_CALENDAR_CATEGORY_LIST){
                //Integer position = (Integer)view.getTag() ;
                if(position == 1){
                    //VeamUtil.log("debug","subscription tap") ;
                    this.createSubscription() ;
                    this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, null, null) ;
                    this.doTranslateAnimation(subscriptionView, 300, deviceWidth, 0, 0, 0, null, null) ;
                    currentCalendar = CALENDAR_SUBSCRIPTION ;
                    currentView = VIEW_SUBSCRIPTION ;
                    this.trackPageView(String.format("Calendar/%04d%02d",targetYear,targetMonth)) ;
                } else if(position >= 2){
                    //VeamUtil.log("debug","fixed calendar tap") ;
                    FixedCalendarObject[] fixedCalendarObjects = VeamUtil.getFixedCalendarObjects(mDb) ;
                    if(fixedCalendarObjects != null){
                        //VeamUtil.log("debug","fixedCalendarObjects found") ;
                        int fixedCalendarIndex = position - 2 ;
                        if(fixedCalendarIndex < fixedCalendarObjects.length){
                            currentFixedCalendarObject = fixedCalendarObjects[fixedCalendarIndex] ;
                            //VeamUtil.log("debug","set currentFixedCalendarObject") ;
                            this.createBeginners() ;
                            this.doTranslateAnimation(mainView, 300, 0, -deviceWidth, 0, 0, null, null) ;
                            this.doTranslateAnimation(beginnersView, 300, deviceWidth, 0, 0, 0, null, null) ;
                            currentCalendar = CALENDAR_BEGINNERS ;
                            currentView = VIEW_BEGINNERS ;
                            this.trackPageView("BeginnersCalendar") ;
                        }
                    }
                }
            }
            this.categoryListView.setSelected(false) ;
        } else if(listView == this.selectListView){
            //VeamUtil.log("debug","categoryListView") ;
            String yearMonthString = (String)calendarSelectAdapter.getItem(position) ;
            targetYear = Integer.parseInt(yearMonthString.substring(0, 4)) ;
            targetMonth = Integer.parseInt(yearMonthString.substring(4, 6)) ;
            //this.createSubscription() ;
            this.doTranslateAnimation(subscriptionView, 300, -deviceWidth, 0, 0, 0, null, null) ;
            //this.doTranslateAnimation(calendarSelectView, 300, 0, deviceWidth, 0, 0, "removeCalendarSelect", null) ;
            this.doTranslateAnimation(calendarSelectView, 400, 0, deviceWidth, 0, 0, "removeCalendarSelectAndUpdateSubscription", null) ;
            currentView = VIEW_SUBSCRIPTION ;
            this.trackPageView(String.format("Calendar/%04d%02d",targetYear,targetMonth)) ;
            // set targetYear
            // set targetMonth
        }
        */

    }


	/*
	//ClickableSpanクラスを継承したクラス
	public class TextClickEventHandler extends ClickableSpan {
		TextView textView ;
		String text ;
		CalendarActivity videosActivity ;

		public TextClickEventHandler(String url, TextView tvPost,CalendarActivity videosActivity) {
			super() ;
			this.text = url ;
			this.textView = tvPost ;
			this.videosActivity  =videosActivity ;
		}

		@Override
		public void onClick(View view) {
			Log.v("debug", "textClickEventHandler event occur : " + this.text);
			videosActivity.onUrlClick(this.text) ;
		}
	}
	*/

    public void createSubscriptionPurchase(){
        this.removeSubscriptionPurchase();

        subscriptionPurchaseView = this.addMainView(rootLayout,View.VISIBLE) ;

        subscriptionPurchaseScrollView = new ScrollView(this) ;
        subscriptionPurchaseScrollView.setVerticalScrollBarEnabled(false) ;
        subscriptionPurchaseScrollView.setBackgroundColor(Color.TRANSPARENT) ;
        RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth,viewHeight) ;
        subscriptionPurchaseView.addView(subscriptionPurchaseScrollView,relativeLayoutParams) ;

        int padding = deviceWidth * 3 / 100 ;
        LinearLayout contentView = new LinearLayout(this) ;
        contentView.setPadding(padding, topBarHeight, padding, 0) ;
        contentView.setOrientation(LinearLayout.VERTICAL) ;
        subscriptionPurchaseScrollView.addView(contentView) ;

        Typeface typefaceRobotoLight = Typeface.createFromAsset(this.getAssets(), "Roboto-Light.ttf");

        String description = VeamUtil.getSubscriptionDescription(this,VeamUtil.getSubscriptionIndex(this)) ; //  VeamUtil.getPreferenceString(this,"subscription_0_description") ;
        TextView textView = new TextView(this) ;
        textView.setText(description) ;
        textView.setTextSize((float)deviceWidth * 4.7f / 100 / scaledDensity) ;
        textView.setBackgroundColor(Color.TRANSPARENT) ;
        textView.setTypeface(typefaceRobotoLight) ;
        textView.setTextColor(VeamUtil.getColorFromArgbString("FF2E2E30")) ;
        LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,LinearLayout.LayoutParams.WRAP_CONTENT) ;
        linearLayoutParams.setMargins(0,deviceWidth*5/100,0,0) ;
        contentView.addView(textView,linearLayoutParams) ;

        String buttonText = VeamUtil.getSubscriptionButtonText(this, VeamUtil.getSubscriptionIndex(this)) ; // VeamUtil.getPreferenceString(this,"subscription_0_button_text") ;
        TextView purchaseTextView = new TextView(this) ;
        purchaseTextView.setId(VIEWID_SUBSCRIPTION_PURCHASE) ;
        purchaseTextView.setOnClickListener(this) ;
        purchaseTextView.setText(buttonText) ;
        purchaseTextView.setTextSize((float)deviceWidth * 4.8f / 100 / scaledDensity) ;
        purchaseTextView.setBackgroundColor(VeamUtil.getLinkTextColor(this)) ;
        purchaseTextView.setTypeface(Typeface.SERIF) ;
        purchaseTextView.setTextColor(Color.WHITE) ;
        purchaseTextView.setGravity(Gravity.CENTER) ;
        linearLayoutParams = new LinearLayout.LayoutParams(deviceWidth-padding*2,deviceWidth*12/100) ;
        contentView.addView(purchaseTextView,linearLayoutParams) ;

        this.addTopBar(subscriptionPurchaseView,this.getString(R.string.about_subscription),true,true) ;

    }








    // Callback for when a purchase is finished
    IabHelper.OnIabPurchaseFinishedListener mPurchaseFinishedListener = new IabHelper.OnIabPurchaseFinishedListener() {
        public void onIabPurchaseFinished(IabResult result, Purchase purchase) {
            //VeamUtil.log("deubg", "Purchase finished: " + result + ", purchase: " + purchase);

            if (result.isFailure()) {
                if(result.getResponse() == IabHelper.BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED){
                    VeamUtil.showMessage(ExclusiveGridActivity.this, ExclusiveGridActivity.this.getString(R.string.already_purchased)) ;
                    return ;
                }
                if(result.getResponse() != IabHelper.IABHELPER_USER_CANCELLED){
                    complain(ExclusiveGridActivity.this.getString(R.string.purchase_cancelled) + result);
                }
                //setWaitScreen(false);
                return;
            }
            if (!verifyDeveloperPayload(purchase)) {
                complain("Error purchasing. Authenticity verification failed.");
                //setWaitScreen(false);
                return;
            }

            //VeamUtil.log("debug", "Purchase successful.");

            if(purchase.getSku().equals(VeamUtil.getSubscriptionProductId(VeamUtil.getSubscriptionIndex(ExclusiveGridActivity.this)))) {
                //VeamUtil.log("debug", "subscription purchased.");
                showGoodJobImage(true) ;
                setSubscriptionBought(purchase.getToken()) ;
                ExclusiveGridActivity.this.reloadExclusiveGrid() ;
            }
        }
    };

    public void setSubscriptionBought(String token){
        VeamUtil.setSubscriptionIsBought(this, true) ;
        if(currentView == VIEW_SUBSCRIPTION_PURCHASE){
            this.hideSubscriptionPurchase() ;
        }
        UpdateSubscriptionTask updateSubscriptionTask = new UpdateSubscriptionTask(this,VeamUtil.getSubscriptionProductId(VeamUtil.getSubscriptionIndex(this)),token) ;
        updateSubscriptionTask.execute("") ;
    }

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
        //VeamUtil.log("Debug", "onActivityResult(" + requestCode + "," + resultCode + "," + data);

        if((requestCode == REQUEST_CODE_ACTIVITY_VIDEO_PLAYER) || (requestCode == REQUEST_CODE_ACTIVITY_AUDIO_PLAYER)){
            if(VeamUtil.isSubscriptionFree(this)){
                //VeamUtil.kickKiip(this,"ViewExclusiveContent") ;
            }
        }

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


    @Override
    public void onCancelPreviewDownload(String contentId) {
    }

    @Override
    public void onCompletePreviewDownload(String contentId) {
        this.playVideoObject() ;
    }

    public void playVideoObject(){
        if(currentVideoObject != null){
            //VeamUtil.log("debug","playSolo") ;
            Intent intentPlayMovie = new Intent(this,VideoPlayActivity.class) ;

            String key = currentVideoObject.getVideoKey() ;
            //intentPlayMovie.putExtra("TITLE_NO", currentTitleNo) ;
            intentPlayMovie.putExtra("FILENAME",String.format("p%s.mp4", currentVideoObject.getId())) ;
            intentPlayMovie.putExtra("KEY",key) ;
            intentPlayMovie.putExtra("CONTENTID",currentVideoObject.getId()) ;
            intentPlayMovie.putExtra("TITLE",currentVideoObject.getTitle()) ;
            startActivityForResult(intentPlayMovie,REQUEST_CODE_ACTIVITY_VIDEO_PLAYER) ;
            overridePendingTransition(R.anim.fadein, R.anim.fadeout) ;
        }
    }


    public void reloadExclusiveGrid(){
        MixedObject[] mixedObjects = null ;
        if(VeamUtil.getSubscriptionIsBought(this)){
            mixedObjects = VeamUtil.getMixedObjectsForExclusive(mDb,VeamUtil.getSubscriptionStart(this,VeamUtil.getSubscriptionIndex(this))) ;
        }
        if(mixedGridAdapter != null) {
            mixedGridAdapter.setMixeds(mixedObjects) ;
            mixedGridAdapter.notifyDataSetChanged() ;
        }
    }

    public void onSubscriptionUpdated(){
        //VeamUtil.log("debug","onCalendarUpdated()") ;
        this.reloadExclusiveGrid() ;
    }

    @Override
    protected int getFloatingMenuKind(){
        return FLOATING_MENU_KIND_EDIT_AND_TUTORIAL ;
    }

    @Override
    protected boolean startEditModeActivity(){
        VeamUtil.log("debug", "startEditModeActivity") ;
        if(!super.startEditModeActivity()) {
            Intent intent = new Intent(this, ConsoleMixedForGridActivity.class);
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW, true);
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE, false);
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE, ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK);
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE, getString(R.string.exclusive_upload));
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS, 3);
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT, 1);
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER, true);
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TEMPLATE_ID, TEMPLATE_ID);
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
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.exclusive_tutorial)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,3) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,2) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND,ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
    }

    @Override
    public void onContentsUpdated(){
        VeamUtil.log("debug", "ExclusiveGridActivity::onContentsUpdated") ;
        if(gridView != null) {
            MixedObject[] mixedObjects = null ;
            if(VeamUtil.getSubscriptionIsBought(this)){
                mixedObjects = VeamUtil.getMixedObjectsForExclusive(mDb,VeamUtil.getSubscriptionStart(this,VeamUtil.getSubscriptionIndex(this))) ;
            }
            mixedGridAdapter = new MixedGridAdapter(this,mixedObjects,deviceWidth,topBarHeight,scaledDensity) ;
            gridView.setAdapter(mixedGridAdapter) ;
        }
    }



}
