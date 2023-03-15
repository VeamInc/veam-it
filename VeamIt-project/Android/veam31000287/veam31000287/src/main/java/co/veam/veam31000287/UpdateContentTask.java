package co.veam.veam31000287;

import android.content.Context;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.User;

public class UpdateContentTask extends AsyncTask<String, Integer, Integer> implements UpdateXmlHandler.UpdateXmlHandlerInterface {

	final String TAG = "UpdateContentTask";
	private UpdateContentTaskActivityInterface updateContentActivity ;
	private Context context ;

    //private static final int BUFFER_SIZE = 10240;


	// コンストラクタ
    public UpdateContentTask(UpdateContentTaskActivityInterface updateContentActivity, Context context) {
    	this.updateContentActivity = updateContentActivity ;
    	this.context = context ;
	}


    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer resultCode = 0 ;

		//VeamUtil.log("debug", "UpdateContentTask::doInBackground") ;

		try {
			// HTTP経由でアクセスし、InputStreamを取得する
			String urlString = VeamUtil.getApiUrlString(context,"content/list") ;
			////VeamUtil.log("debug","url="+urlString) ;
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();

			SAXParserFactory spfactory = SAXParserFactory.newInstance();
			SAXParser parser = spfactory.newSAXParser();
			DatabaseHelper helper = DatabaseHelper.getInstance(context) ;
			final SQLiteDatabase db = helper.getReadableDatabase() ;

			SharedPreferences preferences = VeamUtil.getPreferences(context) ;
			SharedPreferences.Editor editor = preferences.edit();
			UpdateXmlHandler updateXmlHandler = new UpdateXmlHandler(context,db,editor,true,false,this) ;
			parser.parse(is,updateXmlHandler) ;
			editor.commit();

			resultCode = 1 ;
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to update") ;
		}

		//VeamUtil.log("debug", "UpdateContentTask::doInBackground end") ;

		return resultCode;
    }
    
	@Override
	protected void onPostExecute(Integer resultCode) {
		//VeamUtil.log(TAG, "onPostExecute - " + resultCode);
		updateContentActivity.onUpdateFinished(resultCode) ;
	}

	@Override
	public void onUpdateContentProgress(Integer percentage) {
		this.publishProgress(percentage);
	}

	@Override
	protected void onProgressUpdate(Integer... values) {
		VeamUtil.log("debug", "onProgressUpdate - " + values[0]);
		if(updateContentActivity != null) {
			updateContentActivity.onUpdateContentProgress(values[0]);
		}
	}


	public interface  UpdateContentTaskActivityInterface {
		public void onUpdateFinished(Integer resultCode) ;
		public void onUpdateContentProgress(Integer percentage) ;
	}

		


}
