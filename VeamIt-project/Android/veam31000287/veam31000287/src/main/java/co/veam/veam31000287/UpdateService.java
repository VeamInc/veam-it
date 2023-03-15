package co.veam.veam31000287;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.ads.identifier.AdvertisingIdClient.Info;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;


public class UpdateService extends IntentService {
	
    public UpdateService(){
        super("veam31000287.UpdateService");
    }
    
    @Override
	protected void onHandleIntent(Intent intent) {
    	//System.out.println("UpdateService::onHandleIntent") ;

    	try {
    		Info adInfo = AdvertisingIdClient.getAdvertisingIdInfo(this);
		} catch (IllegalStateException e1) {
			e1.printStackTrace();
		} catch (GooglePlayServicesRepairableException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (GooglePlayServicesNotAvailableException e1) {
			e1.printStackTrace();
		}

    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
    		String urlString = VeamUtil.getApiUrlString(this,"content/list") ;
    		VeamUtil.log("debug","url="+urlString) ;
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();
    		DatabaseHelper helper = DatabaseHelper.getInstance(this) ;
    		final SQLiteDatabase db = helper.getReadableDatabase() ;

    		UpdateXmlHandler updateXmlHandler = new UpdateXmlHandler(this,db,null,true,false,null) ;
    	    parser.parse(is,updateXmlHandler) ;
    	    
    	    if(!updateXmlHandler.updateFailed){
    	    	VeamUtil.notifyUpdateFinished(this) ;
    	    }
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to update") ;
		}
	}

	public class ExtraDataXmlHandler extends DefaultHandler {
		private Context mContext ;
    	private boolean updateFailed ;
    	SharedPreferences.Editor editor ;

    	public boolean updateFailed(){
    		return updateFailed ;
    	}

		public ExtraDataXmlHandler(Context context){
			super() ;
			mContext = context ;
			updateFailed = false ;
		}
		
		/**
		* ドキュメント開始時
		*/
		public void startDocument() {
			//System.out.println("extradata startDocument");
			SharedPreferences preferences = VeamUtil.getPreferences(mContext) ;
			editor = preferences.edit();
		}
		
		/**
		* 要素の開始タグ読み込み時
		*/
		public void startElement(String uri,String localName,String qName,Attributes attributes) {
			//System.out.println("startElement:" + qName + " localName=" + localName) ;
			String tag = "" ;
			if(localName.equals("")){
				tag = qName ;
			} else {
				tag = localName ;
			}
			String value = attributes.getValue("value") ;
			if(value != null){
				//System.out.println("tag=" + tag + " value="+value) ;
				//VEAMUtil.setPreferenceString(mContext, tag, value) ;
				editor.putString(tag,value);
				value = null ;
			}
		}
		
		/**
		* テキストデータ読み込み時
		*/
		public void characters(char[] ch,int offset,int length) {
			//System.out.println("テキストデータ：" + new String(ch, offset, length));
		}
		
		/**
		* 要素の終了タグ読み込み時
		*/
		public void endElement(String uri,String localName,String qName) {
			//System.out.println("要素終了:" + qName);
		}
		
		/**
		* ドキュメント終了時
		*/
		public void endDocument() {
			//System.out.println("extradata endDocument");
			editor.commit();
			if(!updateFailed){
			}
		}
	}    
	
}
