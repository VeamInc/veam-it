package co.veam.veam31000287;

import android.os.AsyncTask;
import android.util.Log;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

public class PostAudioCommentTask extends AsyncTask<String, Integer, AudioCommentObject> {
	
	final String TAG = "PostAudioCommentTask";
	private PostAudioCommentActivity postAudioCommentActivity;
	private String comment ;
	private String audioId ;
	
	// コンストラクタ  
    public PostAudioCommentTask(PostAudioCommentActivity activity, String audioId, String comment) {
    	this.postAudioCommentActivity = activity ;
    	this.comment = comment ;
    	this.audioId = audioId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected AudioCommentObject doInBackground(String... urls) {
    	
        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	AudioCommentObject audioCommentObject = null ;
    	
    	String socialUserId = VeamUtil.getSocialUserId(postAudioCommentActivity) ;
    	if(VeamUtil.isEmpty(socialUserId)){
    		return null ;
    	}
    	
    	String encodedComment = "" ;
		try {
			encodedComment = URLEncoder.encode(comment,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
    	
    	String uid = VeamUtil.getUniqueId(postAudioCommentActivity) ;
    	String signature = VeamUtil.sha1(String.format("VEAM_%s_%s_%s_%s", uid,socialUserId,audioId,comment)) ;
    	
        
    	String urlString = String.format("%s&u=%s&sid=%s&au=%s&c=%s&s=%s",VeamUtil.getApiUrlString(postAudioCommentActivity, "audio/postcomment"),uid,socialUserId,audioId,encodedComment,signature) ;
		//VeamUtil.log("debug", "url=" + urlString) ;
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			byte[] buffer = new byte[1024] ;
			InputStream inputStream = url.openConnection().getInputStream();
			int readLength = inputStream.read(buffer, 0, 1000) ;
			String responseString = new String(buffer, "UTF-8") ;
			responseString = responseString.substring(0,readLength) ;
			//System.out.println(responseString) ;
			String[] results = responseString.split("\\n") ;
			int numberOfLines = results.length ;
			/*
			for(int index = 0 ; index < numberOfLines ; index++){
				//System.out.println(index+":"+results[index]) ;
			}
			*/
			
			/*
			InputStreamReader streamReader = new InputStreamReader(inputStream);
			BufferedReader bufferedReader = new BufferedReader(streamReader);
			ArrayList<String> result = new ArrayList<String>() ; 
			String line = bufferedReader.readLine() ;
			while(line != null){
				//VeamUtil.log("debug",line) ;
				result.add(line) ;
				line = bufferedReader.readLine() ;
			}
			
			int numberOfLines = result.size() ;
			for(int index = 0 ; index < numberOfLines ; index++){
				//System.out.println(result.get(index)) ;
			}
			
			*/
		    if(numberOfLines >= 2){
		        if(results[0].equals("OK")){
		        	
		            String commentId = results[1] ;
		            //commentId = results[2] ;
		            //String userId = results[3] ;
		            String userName = results[4] ;
		            String text = results[5] ;

		            audioCommentObject = new AudioCommentObject(commentId,audioId,socialUserId,userName,text) ;
		        }
		    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to post comment") ;
		}
    	
		return audioCommentObject;
    }
    
	@Override
	protected void onPostExecute(AudioCommentObject audioCommentObject) {
		//VeamUtil.log(TAG, "onPostExecute - " + tweet);
		postAudioCommentActivity.onPostCommentFinished(audioCommentObject) ;
	}
	
}
