package co.veam.veam31000287;

import android.os.AsyncTask;

import java.io.DataOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class LoadPictureTask extends AsyncTask<String, Integer, PictureXml> {
	
	final String TAG = "LoadPictureTask";
	private VeamActivity veamActivity ;
	private String forumId ;
	private String socialUserId ;
	private int pageNo ;
	

	// コンストラクタ  
    public LoadPictureTask(VeamActivity activity,String forumId,int pageNo,String socialUserId) {
    	veamActivity = activity ;
    	this.pageNo = pageNo ;
    	this.forumId = forumId ;
    	this.socialUserId = socialUserId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected PictureXml doInBackground(String... urls) {
    	PictureXml pictureXml = null ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	/*
    	String socialUserId = VeamUtil.getPreferenceString(veamActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(socialUserId == null){
    		socialUserId = "" ;
    	}
    	*/
    	
    	String urlString = VeamUtil.getApiUrlString(veamActivity, "forum/picturelist") ;
    	String params = "" ;
    	
    	if(forumId.equals(VeamUtil.SPECIAL_FORUM_ID_FAVORITES)){
            String favoriteString = VeamUtil.getFavoritePictures(veamActivity) ;
            String favoriteIds = String.format("f:%s",favoriteString) ;
    		params = String.format("f=%s&p=%d&s=%s",favoriteIds,this.pageNo,socialUserId) ;
    	} else if(forumId.equals(VeamUtil.SPECIAL_FORUM_ID_USER_POST)){
    		String mySocialUserId = VeamUtil.getSocialUserId(veamActivity) ;
        	params = String.format("f=%s:%s&p=%d&s=%s",VeamUtil.SPECIAL_FORUM_ID_USER_POST,socialUserId,this.pageNo,mySocialUserId) ;
    	} else {
        	params = String.format("f=%s&p=%d&s=%s",forumId,this.pageNo,socialUserId) ;
    	}

    	//VeamUtil.log("debug", "url=" + urlString);
    	//VeamUtil.log("debug", "params=" + params);
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			
			HttpURLConnection connection = (HttpURLConnection)url.openConnection() ;
			connection.setRequestMethod("POST") ; // GET だとパラメタが長くなりすぎる場合があるのでPOST
			connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded") ;
			//connection.setRequestProperty("Content-Length", "" + Integer.toString(params.getBytes().length)) ;
			//connection.setRequestProperty("Content-Language", "en-US") ;  
			connection.setUseCaches (false) ;
			connection.setDoInput(true) ;
			connection.setDoOutput(true) ;

			//Send request
			DataOutputStream wr = new DataOutputStream (connection.getOutputStream ()) ;
			wr.writeBytes(params) ;
			wr.flush() ;
			wr.close() ;
			
			InputStream is = connection.getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();

			String numberOfPicturesBetweenAdString = VeamUtil.getPreferenceString(veamActivity, "number_of_pictures_between_ads") ;

			int numberOfPicturesBetweenAd = 0 ;
			if(!VeamUtil.isEmpty(numberOfPicturesBetweenAdString)){
				numberOfPicturesBetweenAd = VeamUtil.parseInt(numberOfPicturesBetweenAdString) ;
			}
			pictureXml = new PictureXml(numberOfPicturesBetweenAd) ;
    	    parser.parse(is,pictureXml) ;
    	    
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load pictures") ;
		}
    	
		return pictureXml;
    }
    
	@Override
	protected void onPostExecute(PictureXml result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == null){
			veamActivity.onPictureLoadFailed() ;
		} else {
			veamActivity.updatePicture(result,this.pageNo) ;
		}
	}
}
