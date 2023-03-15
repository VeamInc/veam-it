package co.veam.veam31000287;

import java.io.IOException;

import android.content.Context;
import android.os.AsyncTask;

import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.ads.identifier.AdvertisingIdClient.Info;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

public class LoadAdvertisingIdTask extends AsyncTask<String, Integer, Info> {
	
	public static final int FOLLOW_KIND_FOLLOWINGS	= 0x0001 ;
	public static final int FOLLOW_KIND_FOLLOWERS	= 0x0002 ;
	
	final String TAG = "LoadFollowTask";
	private Context context ;
	private AdvertisingIdHelper advertisingIdHelper;
	

	// コンストラクタ  
    public LoadAdvertisingIdTask(Context context,AdvertisingIdHelper advertisingIdHelper) {
    	this.context = context ;
    	this.advertisingIdHelper = advertisingIdHelper ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Info doInBackground(String... urls) {
    	Info adInfo = null ;
    	try {
			adInfo = AdvertisingIdClient.getAdvertisingIdInfo(context);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (GooglePlayServicesRepairableException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (GooglePlayServicesNotAvailableException e) {
			e.printStackTrace();
		}
		return adInfo ;
    }
    
	@Override
	protected void onPostExecute(Info adInfo) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		advertisingIdHelper.onInfoLoaded(adInfo) ;
	}
}
