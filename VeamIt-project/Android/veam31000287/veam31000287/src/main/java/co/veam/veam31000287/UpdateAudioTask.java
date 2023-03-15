package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

public class UpdateAudioTask extends AsyncTask<String, Integer, Integer> {

	final String TAG = "UpdateAudioTask";
	private Context context ;
	private SellAudioObject sellAudioObject ;

	// コンストラクタ
    public UpdateAudioTask(Context context, SellAudioObject sellAudioObject) {
    	this.context = context ;
    	this.sellAudioObject = sellAudioObject ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer result = 0 ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
		String productId = sellAudioObject.getProductId() ;
		String signature = VeamUtil.sha1(String.format("VEAM_%s",productId)) ;
		String urlString = String.format("%s&p=%s&s=%s",VeamUtil.getApiUrlString(context, "subscription/verifysellaudiopurchase"),productId,signature) ;

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

			//VeamUtil.log("debug", "response=" + responseString) ;

			String[] results = responseString.split("\\n") ;
			int numberOfLines = results.length ;

		    if(numberOfLines >= 4){
		        if(results[0].equals("OK")){
					//String latestReceipt = results[1] ;
					//String retProductId = results[2] ; // co.veam.veam__APP_ID__.audio.__SELL_AUDIO_ID__
					String audioUrl = results[3] ;
					//String token = results[4] ;

					String audioId = sellAudioObject.getAudioId() ;
					VeamUtil.setAudioUrl(context,audioUrl,audioId) ;

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
			//exclusiveGridActivity.onSubscriptionUpdated() ;
		}
	}
}
