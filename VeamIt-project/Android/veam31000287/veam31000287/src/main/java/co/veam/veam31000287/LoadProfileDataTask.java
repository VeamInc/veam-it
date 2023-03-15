package co.veam.veam31000287;

import android.os.AsyncTask;

import java.io.InputStream;
import java.net.URL;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class LoadProfileDataTask extends AsyncTask<String, Integer, ProfileDataXml> {
	
	final String TAG = "LoadProfileDataTask";
	private ProfileActivity profileActivity ;
	private String socialUserId ;
	

	// コンストラクタ  
    public LoadProfileDataTask(ProfileActivity activity,String socialUserId) {
    	profileActivity = activity ;
    	this.socialUserId = socialUserId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected ProfileDataXml doInBackground(String... urls) {
    	ProfileDataXml profileDataXml = null ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
   		String mySocialUserId = "0" ;
   		if(VeamUtil.isLogin(profileActivity)){
   			mySocialUserId = VeamUtil.getSocialUserId(profileActivity) ;
   		}
    	
   		String signature = VeamUtil.sha1(String.format("VEAM_%s",socialUserId)) ; 
	    String urlString = String.format("%s&tid=%s&mid=%s&s=%s",VeamUtil.getApiUrlString(profileActivity, "socialuser/profile"),socialUserId,mySocialUserId,signature) ;
	    	
    	//VeamUtil.log("debug", "url=" + urlString);
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();
    	    
    	    profileDataXml = new ProfileDataXml() ; 
    	    parser.parse(is,profileDataXml) ;
    	    
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load pictures") ;
		}
    	
		return profileDataXml;
    }
    
	@Override
	protected void onPostExecute(ProfileDataXml result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == null){
			profileActivity.onProfileDataLoadFailed() ;
		} else {
			profileActivity.updateProfileData(result) ;
		}
	}
}
