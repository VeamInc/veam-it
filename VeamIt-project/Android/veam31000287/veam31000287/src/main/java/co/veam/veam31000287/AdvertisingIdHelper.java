package co.veam.veam31000287;

import android.content.Context;
import android.util.Log;

import com.google.android.gms.ads.identifier.AdvertisingIdClient.Info;

public class AdvertisingIdHelper {
	private static AdvertisingIdHelper sSingleton = null ;
	private Info adInfo = null ;

	public static synchronized AdvertisingIdHelper getInstance(Context context) {
        if (sSingleton == null) {
            sSingleton = new AdvertisingIdHelper(context);
        }
        return sSingleton;
    }
	
	public AdvertisingIdHelper(Context context) {
		//VeamUtil.log("debug","AdvertisingIdHelper::AdvertisingIdHelper") ;
		LoadAdvertisingIdTask loadAdvertisingIdTask = new LoadAdvertisingIdTask(context,this) ;
		loadAdvertisingIdTask.execute("") ;
	}

	public void onInfoLoaded(Info targetAdInfo) {
		//VeamUtil.log("debug","AdvertisingIdHelper::onInfoLoaded") ;
		this.adInfo = targetAdInfo ;
		/*
		if(adInfo != null){
			//VeamUtil.log("debug","adInfo id="+ adInfo.getId() + " limited="+(adInfo.isLimitAdTrackingEnabled()?"YES":"NO")) ;
		}
		*/
	}
	
	public String getAdvertisingId(){
		String advertisingId = "" ;
		if((adInfo != null) && !adInfo.isLimitAdTrackingEnabled()){
			advertisingId = adInfo.getId() ;
		}
		return advertisingId ;
	}
}
