package co.veam.veam31000287;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

public class SendRegistrationTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "SendRegistrationTask";
	private Context context ;
	private String registrationId ;
	private String socialUserId ;
	

	// コンストラクタ  
    public SendRegistrationTask(Context context,String registrationId,String socialUserId) {
    	this.context = context ;
    	this.registrationId = registrationId ;
    	this.socialUserId = socialUserId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	//VeamUtil.log("debug","SendRegistrationTask::doInBackground") ;
    	Integer resultCode = VeamUtil.sendRegistration(context, registrationId, socialUserId) ;
    	return resultCode ;
    }
    
	@Override
	protected void onPostExecute(Integer resultCode) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
	}
}
