package co.veam.veam31000287;

import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;

public class SendAudioLikeTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "SendAudioLikeTask";
	private AudioPlayActivity audioPlayActivity;
	private String audioId ;
	private boolean isLike ;
	

	// コンストラクタ  
    public SendAudioLikeTask(AudioPlayActivity activity,String audioId,boolean isLike) {
    	audioPlayActivity = activity ;
    	this.audioId = audioId ;
    	this.isLike = isLike ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer resultCode = 0 ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String socialUserId = VeamUtil.getPreferenceString(audioPlayActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(VeamUtil.isEmpty(socialUserId)){
    		return -1 ;
    	}

        int like = isLike?1:0 ;
        String signature = VeamUtil.sha1(String.format("VEAM_%d_%s_%s",like,socialUserId,audioId)) ;
    	String urlString = String.format("%s&au=%s&sid=%s&l=%d&s=%s",VeamUtil.getApiUrlString(audioPlayActivity, "audio/like"),audioId,socialUserId,like,signature) ;

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
		audioPlayActivity.sendAudioLikeDone(resultCode) ;
	}
}
