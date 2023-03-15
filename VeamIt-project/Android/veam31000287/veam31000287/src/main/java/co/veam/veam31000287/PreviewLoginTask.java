package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.User;

public class PreviewLoginTask extends AsyncTask<String, Integer, Integer> {

	final String TAG = "PreviewLoginTask";
	private PreviewLoginTaskActivityInterface previewLoginActivity ;
	private Context context ;
	private String targetAppId ;
	private String email ;
	private String password ;
	private String message ;


	// コンストラクタ
    public PreviewLoginTask(PreviewLoginTaskActivityInterface previewLoginActivity, Context context, String email, String password) {
    	this.previewLoginActivity = previewLoginActivity ;
    	this.context = context ;
		this.email = email ;
		this.password = password ;
	}

    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer resultCode = 0 ;

		String encodedEmail = "" ;
		String encodedPassword = "" ;
		message = "" ;

		try {
			encodedEmail = URLEncoder.encode(email, "utf-8");
			encodedPassword = URLEncoder.encode(password,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}


		String signature = VeamUtil.sha1(String.format("CONSOLE_%s_%s_%s", password,"",email)) ;
		String urlString = String.format("%s&u=%s&p=%s&s=%s",VeamUtil.getConsoleApiUrlString(context, "account/login"),encodedEmail,encodedPassword,signature) ;
		//VeamUtil.log("debug", "url=" + urlString);

		try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream inputStream = url.openConnection().getInputStream();

			InputStreamReader streamReader = new InputStreamReader(inputStream);
			BufferedReader bufferedReader = new BufferedReader(streamReader);
			ArrayList<String> result = new ArrayList<String>() ;
			String line = bufferedReader.readLine() ;
			while(line != null){
				result.add(line) ;
				line = bufferedReader.readLine() ;
			}

			int count = result.size() ;
			if(count > 0){
				String code = result.get(0) ;
				if(code.equals("OK")){
					//NSLog(@"OK") ;
					if(count >= 5){
						VeamUtil.setPreferenceString(context,VeamUtil.USERDEFAULT_KEY_PREVIEW_APP_ID,result.get(1)) ;
						VeamUtil.setPreferenceString(context,VeamUtil.VEAM_CONSOLE_KEY_APP_SECRET,result.get(2)) ;
						VeamUtil.setPreferenceString(context,VeamUtil.VEAM_CONSOLE_KEY_USER_PRIVILAGES,result.get(3)) ;

						VeamUtil.setPreferenceString(context,VeamUtil.VEAM_CONSOLE_KEY_USER_ID,email) ;
						VeamUtil.setPreferenceString(context,VeamUtil.VEAM_CONSOLE_KEY_PASSWORD,password) ;
						resultCode = 1 ;
					} else {
						message = "Failed to Login" ;
					}
				} else if(code.equals("ERROR_MESSAGE")){
					if(count >= 2){
						message = result.get(1) ;
					} else {
						message = "Failed to Login" ;
					}
				} else {
					for(int index = 0 ; index < count ; index++){
						//NSLog(@"%@",results.get(index]) ;
					}
					message = "Failed to Login" ;
				}
			}


		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load tweet") ;
		}

		return resultCode;
    }
    
	@Override
	protected void onPostExecute(Integer resultCode) {
		//VeamUtil.log(TAG, "onPostExecute - " + resultCode);
		previewLoginActivity.onLoginFinished(resultCode,message) ;
	}



	public interface  PreviewLoginTaskActivityInterface {
		public void onLoginFinished(Integer resultCode,String message) ;
	}

}
