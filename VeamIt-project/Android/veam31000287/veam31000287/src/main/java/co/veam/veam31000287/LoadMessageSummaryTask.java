package co.veam.veam31000287;

import java.io.InputStream;
import java.net.URL;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

public class LoadMessageSummaryTask extends AsyncTask<String, Integer, MessageXml> {
	
	final String TAG = "LoadMessageSummaryTask";
	private MessageSummaryAdapter.MessageSummaryAdapterActivityInterface messageSummaryActivity ;
	private Context context ;
	private String socialUserId ;
	private int pageNo ;
	

	// コンストラクタ  
    public LoadMessageSummaryTask(MessageSummaryAdapter.MessageSummaryAdapterActivityInterface activity,Context context,int pageNo,String socialUserId) {
    	messageSummaryActivity = activity ;
    	this.pageNo = pageNo ;
    	this.context = context ;
    	this.socialUserId = socialUserId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected MessageXml doInBackground(String... urls) {
    	MessageXml messageXml = null ;

    	String urlString = null ;
		String signature = VeamUtil.sha1(String.format("VEAM_%s",socialUserId)) ; 
		urlString = String.format("%s&p=%d&sid=%s&s=%s",VeamUtil.getApiUrlString(context, "pagedmessagesummary"),pageNo,socialUserId,signature) ;
		
    	//VeamUtil.log("debug","message summary url="+urlString) ;
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();
    	    
    	    messageXml = new MessageXml() ;
    	    parser.parse(is,messageXml) ;
    	    
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load message summary") ;
		}
    	
		return messageXml ;
    }
    
	@Override
	protected void onPostExecute(MessageXml result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == null){
			messageSummaryActivity.onMessageSummaryLoadFailed() ;
		} else {
			messageSummaryActivity.updateMessageSummary(result,this.pageNo) ;
		}
	}
}
