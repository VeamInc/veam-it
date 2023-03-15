package co.veam.veam31000287;

import android.os.AsyncTask;
import android.util.Log;

import java.io.InputStream;
import java.net.URL;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class LoadVideoDataTask extends AsyncTask<String, Integer, VideoDataXml> {
	
	final String TAG = "LoadVideoDataTask";
	private VideoPlayActivity videoPlayActivity;
	private String videoId ;
	

	// コンストラクタ  
    public LoadVideoDataTask(VideoPlayActivity activity, String videoId) {
    	videoPlayActivity = activity ;
    	this.videoId = videoId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected VideoDataXml doInBackground(String... urls) {
    	VideoDataXml videoDataXml = null ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String socialUserId = VeamUtil.getSocialUserId(videoPlayActivity) ;
    	if(socialUserId == null){
    		socialUserId = "" ;
    	}
    	
    	String urlString = String.format("%s&v=%s&sid=%s",VeamUtil.getApiUrlString(videoPlayActivity, "video/getinfo"),videoId,socialUserId) ;

		//VeamUtil.log("debug", "url=" + urlString);
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();
    	    
    	    videoDataXml = new VideoDataXml() ;
    	    parser.parse(is, videoDataXml) ;
    	    
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load pictures") ;
		}
    	
		return videoDataXml;
    }
    
	@Override
	protected void onPostExecute(VideoDataXml result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == null){
			videoPlayActivity.onVideoDataLoadFailed() ;
		} else {
			videoPlayActivity.updateVideoData(result) ;
		}
	}
}
