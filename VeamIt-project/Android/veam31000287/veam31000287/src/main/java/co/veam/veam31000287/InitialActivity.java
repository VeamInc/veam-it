package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Locale;

//import com.google.analytics.tracking.android.Log;

public class InitialActivity extends VeamActivity implements OnClickListener {

	private DatabaseHelper helper ;

	private RelativeLayout rootLayout ;
	private ImageView backgroundImageView ;
	private ImageView backgroundImageView2 ;
	private View bottomView ;
	private ImageView[] buttonImageViews ;
	
	private final int VIEWID_BACKGROUND 	= 0x10001 ;
	private final int VIEWID_BUTTON		 	= 0x10002 ;

    private Handler handler = new Handler();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.activity_initial);
		RelativeLayout.LayoutParams layoutParams ;
		
		pageName = "Initial" ;

        String language = Locale.getDefault().getLanguage() ;
		//VeamUtil.log("debug","language="+language) ;

        VeamConfiguration veamConfiguration = VeamConfiguration.getInstance(this) ;

		AdvertisingIdHelper.getInstance(this) ;

		//VeamUtil.log("debug", "InitialActivity::onCreate gcmRegisterTask.execute") ;
        GCMRegisterTask gcmRegisterTask = new GCMRegisterTask(this,VeamUtil.getSocialUserId(this)) ;
        gcmRegisterTask.execute("");

	     // キーハッシュを出力するコードを追加する
        /*
        try {
            PackageInfo info = getPackageManager().getPackageInfo("co.veam.veam31000287",PackageManager.GET_SIGNATURES);
            for (Signature signature :info.signatures) {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());
              VeamUtil.log("KeyHash:", Base64.encodeToString(md.digest(), Base64.DEFAULT));
                }
        } catch (NameNotFoundException e) {

        } catch (NoSuchAlgorithmException e) {

        }
        */

        // DBがなければ作成
		//VeamUtil.log("debug","bafore creating DB") ;
		helper = DatabaseHelper.getInstance(this) ;
		final SQLiteDatabase db  = helper.getReadableDatabase() ;
		//VeamUtil.log("debug", "after creating DB") ;

		Intent paramIntent = getIntent() ;
		boolean launchedByPreviewHome = paramIntent.getBooleanExtra("LAUNCHED_BY_PREVIEW_HOME",false) ;

		VeamUtil.log("debug", "InitialActivity launchedByPreviewHome="+launchedByPreviewHome) ;
		if(!launchedByPreviewHome) {
			if (VeamUtil.isPreviewMode()) {
				VeamUtil.log("debug", "isPreviewMode") ;
				String appId = VeamUtil.getAppId();
				if (VeamUtil.isEmpty(appId)) {
					VeamUtil.log("debug", "launch login activity") ;
					// launch login activity
					Intent previewLoginIntent = new Intent(this, PreviewLoginActivity.class);
					startActivity(previewLoginIntent);
				} else {
					VeamUtil.log("debug", "launch home activity") ;
					// launch home activity
					Intent previewHomeIntent = new Intent(this, PreviewHomeActivity.class);
					startActivity(previewHomeIntent);
				}

				this.finish() ;
				return ;
			}
		}

		if(VeamUtil.shouldSkipInitial(this)){
			this.launchExclusiveActivity() ;
			this.finish() ;
		}

		try {
			rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;

            this.addBaseBackground(rootLayout) ;

            backgroundImageView2 = new ImageView(this);
		    backgroundImageView2.setBackgroundColor(Color.rgb(0x10, 0x10, 0x10)) ;
		    backgroundImageView2.setId(this.VIEWID_BACKGROUND) ;
            backgroundImageView2.setImageBitmap(VeamUtil.getThemeImage(this,"initial_background",1));
		    backgroundImageView2.setScaleType(ImageView.ScaleType.CENTER_CROP);
		    backgroundImageView2.setVisibility(View.INVISIBLE) ;
		    rootLayout.addView(backgroundImageView2,createParam(deviceWidth, deviceHeight)) ;
		} catch (OutOfMemoryError e) {
			//VeamUtil.log("OutOfMemory") ;
		}

        this.addTab(rootLayout,-1,false) ;
	    
	    int duration = 2000 ;
		this.doFadeInAnimation(this.backgroundImageView2, duration, null, null) ;

		if(VeamUtil.isConnected(this)){
			Intent intent = new Intent(this, UpdateService.class) ;
			this.startService(intent) ;
		} else {
			//System.out.println("not connected") ;
		}

		/*
        if(VeamUtil.IN_APP_BILLING_TEST){
        	new AlertDialog.Builder(this).setTitle("TEST VERSION").setPositiveButton("OK",null).show();
        }
        */
	}
	
	public void removeBlurBackground(){
		//VeamUtil.log("debug","removeBlurBackground") ;
        handler.post( new Runnable() {
            public void run() {
            	doRemoveBlurBackground() ;
            }
        });
	}

	public void doRemoveBlurBackground(){
		//VeamUtil.log("debug","doRemoveBlurBackground") ;
		rootLayout.removeView(backgroundImageView) ;
		this.releaseImageView(backgroundImageView) ;
	}

	@Override
	public void onClick(View view) {
         super.onClick(view) ;
	}
	
	public void onDestroy() {
		//VeamUtil.log("debug","InitialActivity::onDestroy") ;
		super.onDestroy() ;
	}


}
