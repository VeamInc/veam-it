package co.veam.veam31000287;

import android.os.AsyncTask;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;

import com.facebook.HttpMethod;
import com.facebook.Request;
import com.facebook.Response;
import com.facebook.Session;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import twitter4j.StatusUpdate;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;

public class PostPictureTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "PostPictureTask";
	private ImageShareActivity imageShareActivity ;
	private String comment ;
	private String forumId ;
	private boolean shouldPostToTwitter ;
	private boolean shouldPostToFacebook ;
	private Session facebookSession ;
	
	// コンストラクタ  
    public PostPictureTask(ImageShareActivity activity,String forumId,String comment,boolean shouldPostToFacebook,boolean shouldPostToTwitter,Session facebookSession) {
    	this.imageShareActivity = activity ;
    	this.comment = comment ;
    	this.forumId = forumId ;
    	this.shouldPostToFacebook = shouldPostToFacebook ; 
    	this.shouldPostToTwitter = shouldPostToTwitter ;
    	this.facebookSession = facebookSession ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	
    	Integer result = 0 ; 
    	
        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	
    	String socialUserId = VeamUtil.getPreferenceString(imageShareActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(VeamUtil.isEmpty(socialUserId)){
    		return result ;
    	}
    	
    	/*
    	String encodedComment = "" ;
		try {
			encodedComment = URLEncoder.encode(comment,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		*/
		
    	String uid = VeamUtil.getUniqueId(imageShareActivity) ;
        String signature = VeamUtil.sha1(String.format("VEAM_%s_%s_%s",uid,socialUserId,comment)) ;

    	String urlString = String.format("%s",VeamUtil.getApiUrlString(imageShareActivity, "forum/postpicture")) ;
    	//VeamUtil.log("debug", "url=" + urlString) ;

		List<String> postData = new ArrayList<String>();
    	postData.add(String.format("%s=%s", "u",uid));
    	postData.add(String.format("%s=%s", "sid",socialUserId));
    	postData.add(String.format("%s=%s", "f",forumId));
    	postData.add(String.format("%s=%s", "c",comment));
    	postData.add(String.format("%s=%s", "s",signature));
    	try {
    	
	    	HttpMultipartRequest request = new HttpMultipartRequest(
	    			urlString,
	    			postData,
	    			"upfile",
	    			"ImageShareActivity") ;
	    	
			FileInputStream fileInputStream ;
            fileInputStream = imageShareActivity.openFileInput("ImageShareActivity") ;
            byte[] readBytes = new byte[fileInputStream.available()] ;
            fileInputStream.read(readBytes) ;

          //VeamUtil.log("debug","first:"+readBytes[0]) ;
	    	String responseString = request.send(readBytes);
    	
	    	//VeamUtil.log("debug","responseString:"+responseString) ;
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
		          //VeamUtil.log("debug","post ok comment:"+commentId) ;
		            result = 1 ;
		        }
		    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to post comment") ;
		}
    	

    	if(shouldPostToTwitter){
    		FileInputStream inputStream;
			try {
				String twitterTokenSecret = VeamUtil.getPreferenceString(imageShareActivity, VeamUtil.TWITTER_TOKEN_SECRET) ;
		    	String twitterToken = VeamUtil.getPreferenceString(imageShareActivity, VeamUtil.TWITTER_TOKEN) ;
	    		Twitter twitter = new TwitterFactory().getInstance() ;
	    		twitter.setOAuthConsumer(VeamUtil.TWITTER_CONSUMER_KEY, VeamUtil.TWITTER_CONSUMER_SECRET) ;
	    		twitter.setOAuthAccessToken(new AccessToken(twitterToken, twitterTokenSecret)) ;

				inputStream = imageShareActivity.openFileInput("ImageShareActivity");
	    		StatusUpdate status = new StatusUpdate(comment);
	    		status.media(this.imageShareActivity.getString(R.string.app_name),inputStream) ;
	    		twitter.updateStatus(status) ;
	    		inputStream.close() ;
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (TwitterException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}
    	
    	if(this.shouldPostToFacebook && (facebookSession != null)){
    		//Request request = Request.newStatusUpdateRequest(Session.getActiveSession(), comment, null);
    		//Request request = Request.newUploadPhotoRequest(session, file, callback) .newStatusUpdateRequest(Session.getActiveSession(), comment, null);
    		
			try {
				String path = "/data/data/" + this.imageShareActivity.getPackageName() + "/files/ImageShareActivity" ;
				File file = new File(path) ;
				ParcelFileDescriptor descriptor = ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY) ;
	            Bundle parameters = new Bundle(2) ;
	            parameters.putParcelable("picture", descriptor) ;
	            parameters.putString("caption", comment) ;
	            Request request = new Request(Session.getActiveSession(), "me/photos", parameters, HttpMethod.POST, null) ;
	    		// バックグラウンドなので同期実行しても良い
	    		Response response = request.executeAndWait();
	    		boolean success = (response.getError() == null);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

    	}
    	
		return result ;
    }
    
	@Override
	protected void onPostExecute(Integer result) {
		//VeamUtil.log(TAG, "onPostExecute - " + tweet);
		imageShareActivity.onPostPictureFinished(result) ;
	}
	
}
