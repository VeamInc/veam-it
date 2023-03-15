package co.veam.veam31000287;

import java.io.InputStream;
import java.net.URL;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

public class LoadMessageTask extends AsyncTask<String, Integer, MessageXml> {
	
	public static final int FOLLOW_KIND_FOLLOWINGS		= 0x0001 ;
	public static final int FOLLOW_KIND_FOLLOWERS		= 0x0002 ;
	public static final int FOLLOW_KIND_PICTURE_LIKERS	= 0x0003 ;
	public static final int FOLLOW_KIND_FIND_USER		= 0x0004 ;
	
	final String TAG = "LoadMessageTask";
	private MessageAdapter.MessageAdapterActivityInterface messageActivity ;
	private Context context ;
	private String mySocialUserId ;
	private String socialUserId ;
	private int pageNo ;
	

	// コンストラクタ  
    public LoadMessageTask(MessageAdapter.MessageAdapterActivityInterface activity,Context context,int pageNo,String mySocialUserId,String socialUserId) {
    	messageActivity = activity ;
    	this.pageNo = pageNo ;
    	this.context = context ;
    	this.mySocialUserId = mySocialUserId ;
    	this.socialUserId = socialUserId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected MessageXml doInBackground(String... urls) {
    	MessageXml messageXml = null ;

    	String urlString = null ;
		String signature = VeamUtil.sha1(String.format("VEAM_%s_%s",mySocialUserId,socialUserId)) ; 
		urlString = String.format("%s&mid=%s&p=%d&sid=%s&s=%s",VeamUtil.getApiUrlString(context, "pagedmessage"),mySocialUserId,pageNo,socialUserId,signature) ;
		
    	//VeamUtil.log("debug","message url="+urlString) ;
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();
    	    
    	    messageXml = new MessageXml() ;
    	    messageXml.setShouldReverseOrder(true) ;
    	    parser.parse(is,messageXml) ;
    	    
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load massage") ;
		}
    	
		return messageXml ;
    }
    
	@Override
	protected void onPostExecute(MessageXml result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == null){
			messageActivity.onMessageLoadFailed() ;
		} else {
			messageActivity.updateMessage(result,this.pageNo) ;
		}
	}
}
