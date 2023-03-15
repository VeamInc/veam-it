package co.veam.veam31000287;

import android.os.AsyncTask;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

public class PostUserDescriptionTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "PostUserDescriptionTask";
	private ProfileActivity profileActivity ;
	private String comment ;
	private String socialUserId ;
	
	// コンストラクタ  
    public PostUserDescriptionTask(ProfileActivity activity,String socialUserId,String comment) {
    	this.profileActivity = activity ;
    	this.comment = comment ;
    	this.socialUserId = socialUserId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	
    	Integer result = 0 ;
    	
    	String mySocialUserId = VeamUtil.getSocialUserId(profileActivity) ;
    	
    	//VeamUtil.log("debug","PostUserDescriptionTask "+ socialUserId + "=="+mySocialUserId) ;
    	if(VeamUtil.isEmpty(mySocialUserId) || !socialUserId.equals(mySocialUserId)){
    		return result ;
    	}
    	
    	String encodedComment = "" ;
		try {
			encodedComment = URLEncoder.encode(comment,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
    	
    	String uid = VeamUtil.getUniqueId(profileActivity) ;
    	
    	
    	String signature = VeamUtil.sha1(String.format("VEAM_%s_%s", socialUserId,comment)) ;
    	String urlString = String.format("%s&u=%s&sid=%s&d=%s&s=%s",VeamUtil.getApiUrlString(profileActivity, "socialuser/postdescription"),uid,socialUserId,encodedComment,signature) ;
    	//VeamUtil.log("debug", "url=" + urlString) ;
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			byte[] buffer = new byte[1024] ;
			InputStream inputStream = url.openConnection().getInputStream();
			int readLength = inputStream.read(buffer, 0, 1000) ;
			String responseString = new String(buffer, "UTF-8") ;
			responseString = responseString.substring(0,readLength) ;
			//VeamUtil.log("debug","response:"+responseString) ;
			String[] results = responseString.split("\\n") ;
			int numberOfLines = results.length ;
		    if(numberOfLines >= 1){
		        if(results[0].equals("OK")){
		        	result = 1 ;
		        }
		    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to post comment") ;
		}
    	
		return result ;
    }
    
	@Override
	protected void onPostExecute(Integer result) {
		//VeamUtil.log(TAG, "onPostExecute - " + tweet);
		profileActivity.onPostUserDescriptionFinished(result) ;
	}
	
}
