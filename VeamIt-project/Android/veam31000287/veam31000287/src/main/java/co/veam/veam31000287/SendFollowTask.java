package co.veam.veam31000287;

import android.os.AsyncTask;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;

public class SendFollowTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "SendFollowTask";
	private ProfileActivity profileActivity ;
	private String targetSocialUserId ;
	private boolean follow ;
	

	// コンストラクタ  
    public SendFollowTask(ProfileActivity activity,String targetSocialUserId,boolean follow) {
    	profileActivity = activity ;
    	this.targetSocialUserId = targetSocialUserId ;
    	this.follow = follow ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer resultCode = 0 ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String socialUserId = VeamUtil.getPreferenceString(profileActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(VeamUtil.isEmpty(socialUserId)){
    		return -1 ;
    	}

        String signature = VeamUtil.sha1(String.format("VEAM_%s_%s",targetSocialUserId,socialUserId)) ; 
    	String urlString = String.format("%s&tid=%s&mid=%s&f=%d&s=%s",VeamUtil.getApiUrlString(profileActivity, "socialuser/follow"),targetSocialUserId,socialUserId,follow?1:0,signature) ;
    	
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

		    if(result.size() >= 1){
		    	if(result.get(0).equals("OK")){
		    		resultCode = 1 ;
		    	}
		    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to send like") ;
		}
    	
		return resultCode ;
    }
    
	@Override
	protected void onPostExecute(Integer resultCode) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		profileActivity.sendFollowDone(resultCode) ;
	}
}
