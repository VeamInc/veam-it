package co.veam.veam31000287;

import android.os.AsyncTask;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;

public class SendLikeTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "SendLikeTask";
	private VeamActivity veamActivity ;
	private PictureObject pictureObject ;
	private boolean isLike ;
	

	// コンストラクタ  
    public SendLikeTask(VeamActivity activity,PictureObject pictureObject,boolean isLike) {
    	veamActivity = activity ;
    	this.pictureObject = pictureObject ;
    	this.isLike = isLike ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer resultCode = 0 ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String socialUserId = VeamUtil.getPreferenceString(veamActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(VeamUtil.isEmpty(socialUserId)){
    		return -1 ;
    	}
    	
    	String pictureId = pictureObject.getId() ;
        String signature = VeamUtil.sha1(String.format("VEAM_%s_%s",pictureId,socialUserId)) ; 
    	String urlString = String.format("%s&p=%s&sid=%s&l=%d&s=%s",VeamUtil.getApiUrlString(veamActivity, "forum/likepicture"),pictureId,socialUserId,isLike?1:0,signature) ;
    	
    	//VeamUtil.log(TAG, "url=" + urlString);
    	
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
		    		Integer numberOfLikes = Integer.parseInt(pictureObject.getLikes()) ;
		    		if(isLike){
		    			numberOfLikes++ ;
		    		} else {
		    			numberOfLikes-- ;
		    		}
		    		pictureObject.setLikes(String.format("%d", numberOfLikes)) ;
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
		veamActivity.sendLikeDone(resultCode) ;
	}
}
