package co.veam.veam31000287;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

public class SendMessageTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "SendMessageTask";
	private MessageAdapter.MessageAdapterActivityInterface messageActivity ;
	private Context context ;
	private String mySocialUserId ;
	private String socialUserId ;
	private String message ;
	

	// コンストラクタ  
    public SendMessageTask(MessageAdapter.MessageAdapterActivityInterface activity,Context context,String mySocialUserId,String socialUserId,String message) {
    	messageActivity = activity ;
    	this.context = context ;
    	this.mySocialUserId = mySocialUserId ;
    	this.socialUserId = socialUserId ;
    	this.message = message ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer resultCode = 0 ;

    	String encodedMessage = "" ;
		try {
			encodedMessage = URLEncoder.encode(message,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	String uid = VeamUtil.getUniqueId(context) ;
        String signature = VeamUtil.sha1(String.format("VEAM_%s_%s_%s_%s",uid,mySocialUserId,socialUserId,message)) ; 
    	String urlString = String.format("%s&u=%s&fid=%s&tid=%s&m=%s&s=%s",VeamUtil.getApiUrlString(context, "senddirectmessage"),uid,mySocialUserId,socialUserId,encodedMessage,signature) ;
    	
    	//VeamUtil.log("debug", "send message url=" + urlString) ;
    	
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
			//System.out.println("failed to send message") ;
		}
    	
    	
		return resultCode ;
    }
    
	@Override
	protected void onPostExecute(Integer result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		messageActivity.onMessageSend(result) ;
	}
}
