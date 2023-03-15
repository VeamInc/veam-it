package co.veam.veam31000287;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.WakefulBroadcastReceiver;

/**
 * Created by veam on 2015/04/02.
 */
public class GCMBroadcastReceiver extends WakefulBroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        // Explicitly specify that GcmMessageHandler will handle the intent.
        ComponentName comp = new ComponentName(context.getPackageName(),GCMIntentService.class.getName()) ;

        // Start the service, keeping the device awake while it is launching.
        startWakefulService(context, (intent.setComponent(comp))) ;
        setResultCode(Activity.RESULT_OK) ;
    }
}