package co.veam.veam31000287;

import android.os.AsyncTask;
import android.util.Log;

import java.io.InputStream;
import java.net.URL;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class LoadAudioDataTask extends AsyncTask<String, Integer, AudioDataXml> {
	
	final String TAG = "LoadAudioDataTask";
	private AudioPlayActivity audioPlayActivity;
	private String audioId ;
	

	// コンストラクタ  
    public LoadAudioDataTask(AudioPlayActivity activity,String audioId) {
    	audioPlayActivity = activity ;
    	this.audioId = audioId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected AudioDataXml doInBackground(String... urls) {
    	AudioDataXml audioDataXml = null ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String socialUserId = VeamUtil.getSocialUserId(audioPlayActivity) ;
    	if(socialUserId == null){
    		socialUserId = "" ;
    	}
    	
    	String urlString = String.format("%s&au=%s&sid=%s",VeamUtil.getApiUrlString(audioPlayActivity, "audio/getinfo"),audioId,socialUserId) ;

		//VeamUtil.log("debug", "url=" + urlString);
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();
    	    
    	    audioDataXml = new AudioDataXml() ;
    	    parser.parse(is, audioDataXml) ;
    	    
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load pictures") ;
		}
    	
		return audioDataXml;
    }
    
	@Override
	protected void onPostExecute(AudioDataXml result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == null){
			audioPlayActivity.onAudioDataLoadFailed() ;
		} else {
			audioPlayActivity.updateAudioData(result) ;
		}
	}
}
