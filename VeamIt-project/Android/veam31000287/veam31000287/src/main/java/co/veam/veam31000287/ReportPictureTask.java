package co.veam.veam31000287;

import android.os.AsyncTask;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

public class ReportPictureTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "ReportPictureTask";
	private VeamActivity veamActivity ;
	private String message ;
	private String pictureId ;
	
	// コンストラクタ  
    public ReportPictureTask(VeamActivity activity,String pictureId,String message) {
    	this.veamActivity = activity ;
    	this.message = message ;
    	this.pictureId = pictureId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	
    	Integer result = 1 ;
        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String socialUserId = VeamUtil.getPreferenceString(veamActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(VeamUtil.isEmpty(socialUserId)){
    		socialUserId = "0" ;
    	}
    	
    	String encodedMessage = "" ;
		try {
			encodedMessage = URLEncoder.encode(message,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
    	
    	String uid = VeamUtil.getUniqueId(veamActivity) ;
    	String signature = VeamUtil.sha1(String.format("VEAM_%s_%s_%s_%s", uid,socialUserId,pictureId,message)) ;
    	
        
    	String urlString = String.format("%s&u=%s&sid=%s&p=%s&m=%s&s=%s",VeamUtil.getApiUrlString(veamActivity, "forum/reportpicture"),uid,socialUserId,pictureId,encodedMessage,signature) ;
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
			
		    if(numberOfLines >= 1){
		        if(results[0].equals("OK")){
		        	result = 0 ;
		        }
		    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to report picture") ;
		}
    	
		return result ;
    }
    
	@Override
	protected void onPostExecute(Integer result) {
		if(result == 0){
			veamActivity.onPictureReportFinished() ;
		} else {
			veamActivity.onPictureReportFailed(result) ;
		}
	}
	
}
