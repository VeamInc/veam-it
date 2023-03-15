package co.veam.veam31000287;

import android.os.AsyncTask;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

public class PostCommentTask extends AsyncTask<String, Integer, PictureCommentObject> {
	
	final String TAG = "PostCommentTask";
	private VeamActivity veamActivity ;
	private String comment ;
	private String pictureId ;
	
	// コンストラクタ  
    public PostCommentTask(VeamActivity activity,String pictureId,String comment) {
    	this.veamActivity = activity ;
    	this.comment = comment ;
    	this.pictureId = pictureId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected PictureCommentObject doInBackground(String... urls) {
    	
        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	PictureCommentObject pictureCommentObject = null ;
    	
    	String socialUserId = VeamUtil.getPreferenceString(veamActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(VeamUtil.isEmpty(socialUserId)){
    		return null ;
    	}
    	
    	String encodedComment = "" ;
		try {
			encodedComment = URLEncoder.encode(comment,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
    	
    	String uid = VeamUtil.getUniqueId(veamActivity) ;
    	String signature = VeamUtil.sha1(String.format("VEAM_%s_%s_%s_%s", uid,socialUserId,pictureId,comment)) ;
    	
        
    	String urlString = String.format("%s&u=%s&sid=%s&p=%s&c=%s&s=%s",VeamUtil.getApiUrlString(veamActivity, "forum/postpicturecomment"),uid,socialUserId,pictureId,encodedComment,signature) ;
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

		            pictureCommentObject = new PictureCommentObject(commentId,pictureId,socialUserId,userName,text) ;
		        }
		    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to post comment") ;
		}
    	
		return pictureCommentObject ;
    }
    
	@Override
	protected void onPostExecute(PictureCommentObject pictureCommentObject) {
		//VeamUtil.log(TAG, "onPostExecute - " + tweet);
		veamActivity.onPostCommentFinished(pictureCommentObject) ;
	}
	
}
