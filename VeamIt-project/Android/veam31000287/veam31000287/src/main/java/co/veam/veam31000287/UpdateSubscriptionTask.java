package co.veam.veam31000287;

import android.os.AsyncTask;
import android.util.Log;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

public class UpdateSubscriptionTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "UpdateSubscriptionTask";
	private ExclusiveGridActivity exclusiveGridActivity ;
	private String productId ;
	private String purchaseToken ;

	// コンストラクタ
    public UpdateSubscriptionTask(ExclusiveGridActivity activity, String productId, String purchaseToken) {
    	this.exclusiveGridActivity = activity ;
    	this.productId = productId ;
    	this.purchaseToken = purchaseToken ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer result = 0 ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String urlString = String.format("%s&p=%s&t=%s",VeamUtil.getApiUrlString(exclusiveGridActivity, "subscription/verifypurchase"),productId,purchaseToken) ;

		//VeamUtil.log("debug", "url=" + urlString);
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			byte[] buffer = new byte[65536] ;
			URLConnection connection = url.openConnection() ;
			InputStream inputStream = connection.getInputStream();
			
			String responseString = "" ;
			int totalReadSize = 0 ;
			int readLength = 0 ;
			while((readLength = inputStream.read(buffer, 0, 65536)) > 0){
				String readString = new String(buffer, "UTF-8") ;
				responseString += readString.substring(0,readLength) ;
				totalReadSize += readLength ;
	    		//VeamUtil.log("debug","readLength:"+readLength) ;
			}

			//VeamUtil.log("debug","content length:"+connection.getContentLength()) ;
			//VeamUtil.log("debug","totalReadSize:"+totalReadSize) ;
			//VeamUtil.log("debug","responseString:"+responseString) ;
			String[] results = responseString.split("\\n") ;
			int numberOfLines = results.length ;
			//VeamUtil.log("debug","numberOfLines:"+numberOfLines) ;

		    if(numberOfLines >= 4){
		        if(results[0].equals("OK")){
                    String startTime = results[2] ;
                    //String expirationTime = results[3] ;
                    VeamUtil.setSubscriptionStart(this.exclusiveGridActivity,VeamUtil.getSubscriptionIndex(exclusiveGridActivity),startTime) ;
		            result = 1 ;
		        }
		    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load calendar") ;
		}
    	
		return result ;
    }
    
	@Override
	protected void onPostExecute(Integer result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == 1){
			exclusiveGridActivity.onSubscriptionUpdated() ;
		}
	}
}
