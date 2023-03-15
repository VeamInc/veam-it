package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Iterator;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

/**
 * Created by veam on 12/13/16.
 */
public class LoadConsoleMessageTask extends AsyncTask<String, Integer, ConsoleMessageXml> {

    public static final int FOLLOW_KIND_FOLLOWINGS		= 0x0001 ;
    public static final int FOLLOW_KIND_FOLLOWERS		= 0x0002 ;
    public static final int FOLLOW_KIND_PICTURE_LIKERS	= 0x0003 ;
    public static final int FOLLOW_KIND_FIND_USER		= 0x0004 ;

    final String TAG = "LoadConsoleMessageTask";
    private ConsoleMessageAdapter.ConsoleMessageAdapterActivityInterface messageActivity ;
    private Context context ;
    private String mySocialUserId ;
    private String socialUserId ;
    private int pageNo ;


    // コンストラクタ
    public LoadConsoleMessageTask(ConsoleMessageAdapter.ConsoleMessageAdapterActivityInterface activity,Context context,int pageNo) {
        messageActivity = activity ;
        this.pageNo = pageNo ;
        this.context = context ;

    }

    // バックグラウンドで実行する処理
    @Override
    protected ConsoleMessageXml doInBackground(String... urls) {
        ConsoleMessageXml messageXml = null ;

        String userName = VeamUtil.getPreferenceString(context, VeamUtil.VEAM_CONSOLE_KEY_USER_ID) ;
        String password = VeamUtil.getPreferenceString(context, VeamUtil.VEAM_CONSOLE_KEY_PASSWORD) ;
        String currentPageNo = String.format("%d", pageNo) ;

        String apiName = "account/pagedmessage" ;

        String encodedUserName = "" ;
        String encodedPassword = "" ;
        try {
            encodedUserName = URLEncoder.encode(userName, "utf-8");
            encodedPassword = URLEncoder.encode(password, "utf-8");
        } catch (UnsupportedEncodingException e1) {
            e1.printStackTrace();
        }


        String planeText = String.format("CONSOLE_%s_%s_%s", currentPageNo,password,userName) ;
        VeamUtil.log("debug", "planeText=" + planeText) ;
        String signature = VeamUtil.sha1(planeText) ;
        String urlString = String.format("%s&un=%s&pw=%s&p=%s&s=%s", VeamUtil.getConsoleApiUrlString(context, apiName), encodedUserName, encodedPassword, currentPageNo, signature) ;
        VeamUtil.log("debug", "message url=" + urlString) ;

        try {
            // HTTP経由でアクセスし、InputStreamを取得する
            URL url = new URL(urlString);
            InputStream is = url.openConnection().getInputStream();

            SAXParserFactory spfactory = SAXParserFactory.newInstance();
            SAXParser parser = spfactory.newSAXParser();

            messageXml = new ConsoleMessageXml() ;
            messageXml.setShouldReverseOrder(true) ;
            parser.parse(is,messageXml) ;

        } catch (Exception e) {
            e.printStackTrace();
            //System.out.println("failed to load massage") ;
        }

        /*
        if(currentPageNo == 1){
            AppCreatorMessages *workMessages = [[AppCreatorMessages alloc] init] ;
            [workMessages parseWithData:data generateDateElement:YES] ;
            messages = workMessages ;
            creatorName = messages.appCreatorName ;
            mcnName = messages.mcnName ;
        } else {
            [messages parseWithData:data generateDateElement:YES] ; // add
        }
        */


        return messageXml ;
    }

    @Override
    protected void onPostExecute(ConsoleMessageXml result) {
        //VeamUtil.log(TAG, "onPostExecute - " + result);
        if(result == null){
            messageActivity.onMessageLoadFailed() ;
        } else {
            messageActivity.updateMessage(result,this.pageNo) ;
        }
    }
}
