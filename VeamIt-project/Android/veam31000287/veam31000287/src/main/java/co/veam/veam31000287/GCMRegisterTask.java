package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.iid.InstanceID;

import java.io.IOException;

/**
 * Created by veam on 2015/04/02.
 */
public class GCMRegisterTask extends AsyncTask<String, Integer, Integer> {

    final String TAG = "CGMRegisterTask";
    private Context context ;
    private String socialUserId ;


    // コンストラクタ
    public GCMRegisterTask(Context context,String socialUserId) {
        this.context = context ;
        this.socialUserId = socialUserId ;
    }

    // バックグラウンドで実行する処理
    @Override
    protected Integer doInBackground(String... urls) {
        Integer resultCode = 0 ;

        //VeamUtil.log("debug", "GCMRegisterTask::doInBackground") ;









        //if(this.isGooglePlayServicesAvailable()) {
        ////VeamUtil.log("debug","GooglePlayServices Available") ;
        //VeamUtil.log("debug", "register registerId");
        //GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(context);

        //String registrationId = null;
        String registrationId = VeamUtil.getRegistrationId(context);
        try {
            if (VeamUtil.isEmpty(registrationId)) {

                //VeamUtil.log("debug", "sender_id=" + VeamUtil.GCM_SENDER_ID);

                // Initially this call goes out to the network to retrieve the token, subsequent calls are local.
                InstanceID instanceID = InstanceID.getInstance(context) ;
                registrationId = instanceID.getToken(VeamUtil.GCM_SENDER_ID, GoogleCloudMessaging.INSTANCE_ID_SCOPE, null) ;
                Log.i(TAG, "GCM Registration Token: " + registrationId) ;

                /*
                registrationId = gcm.register(VeamUtil.GCM_SENDER_ID);
                */
                if (!VeamUtil.isEmpty(registrationId)) {
                    VeamUtil.setRegistrationId(context, registrationId);
                }
            }

            if (!VeamUtil.isEmpty(registrationId)) {

                VeamUtil.sendRegistration(context, registrationId, socialUserId);

                /*
                String encodedRegistrationId = "";
                try {
                    encodedRegistrationId = URLEncoder.encode(registrationId, "utf-8");
                } catch (UnsupportedEncodingException e1) {
                    e1.printStackTrace();
                    encodedRegistrationId = registrationId;
                }

                String uid = VeamUtil.getUniqueId(context);
                String signature = VeamUtil.sha1(String.format("VEAM_%s_%s", uid, registrationId));
                String urlString = String.format("%s&u=%s&t=%s&s=%s", VeamUtil.getApiUrlString(context, "registergcmregister"), uid, encodedRegistrationId, signature);
                //VeamUtil.log(TAG, "url=" + urlString);

                try {
                    // HTTP経由でアクセスし、InputStreamを取得する
                    URL url = new URL(urlString);
                    InputStream inputStream = url.openConnection().getInputStream();

                    InputStreamReader streamReader = new InputStreamReader(inputStream);
                    BufferedReader bufferedReader = new BufferedReader(streamReader);
                    ArrayList<String> result = new ArrayList<String>();
                    String line = bufferedReader.readLine();
                    while (line != null) {
                        result.add(line);
                        line = bufferedReader.readLine();
                    }

                    if (result.size() >= 1) {
                        if (result.get(0).equals("OK")) {
                            VeamUtil.setIsGcmRegisterDone(context, true);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                */
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return resultCode ;
    }

    @Override
    protected void onPostExecute(Integer resultCode) {
        //VeamUtil.log(TAG, "onPostExecute - " + result);
    }

    //private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000 ;

    private boolean isGooglePlayServicesAvailable() {
        try {
            int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(context);
            if (resultCode != ConnectionResult.SUCCESS) {
                if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                    //VeamUtil.log("debug","isUserRecoverableError "+resultCode) ;
                } else {
                    //VeamUtil.log("debug","Not UserRecoverableError "+resultCode) ;
                    //Log.i(TAG, "This device is not supported.");
                    //finish();
                }
                return false;
            }
        } catch (Exception e) {
            VeamUtil.log(TAG, e.toString());
        }
        return true;
    }
}
