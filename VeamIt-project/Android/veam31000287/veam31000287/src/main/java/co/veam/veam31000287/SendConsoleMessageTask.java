package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;

/**
 * Created by veam on 12/13/16.
 */
public class SendConsoleMessageTask extends AsyncTask<String, Integer, Integer> {

    final String TAG = "SendMessageTask";
    private ConsoleMessageAdapter.ConsoleMessageAdapterActivityInterface messageActivity ;
    private Context context ;
    private String message ;


    // コンストラクタ
    public SendConsoleMessageTask(ConsoleMessageAdapter.ConsoleMessageAdapterActivityInterface activity,Context context,String message) {
        messageActivity = activity ;
        this.context = context ;
        this.message = message ;
    }

    // バックグラウンドで実行する処理
    @Override
    protected Integer doInBackground(String... urls) {
        Integer resultCode = 0 ;

        String userName = VeamUtil.getPreferenceString(context, VeamUtil.VEAM_CONSOLE_KEY_USER_ID) ;
        String password = VeamUtil.getPreferenceString(context, VeamUtil.VEAM_CONSOLE_KEY_PASSWORD) ;

        String encodedMessage = "" ;
        String encodedUserName = "" ;
        String encodedPassword = "" ;
        try {
            encodedMessage = URLEncoder.encode(message, "utf-8");
            encodedUserName = URLEncoder.encode(userName, "utf-8");
            encodedPassword = URLEncoder.encode(password, "utf-8");
        } catch (UnsupportedEncodingException e1) {
            e1.printStackTrace();
        }

        String apiName = "account/sendmessagetomcn" ;
        String planeText = String.format("CONSOLE_%s_%s_%s",message,password,userName) ;
        String signature = VeamUtil.sha1(planeText) ;
        String urlString = String.format("%s&un=%s&pw=%s&m=%s&s=%s", VeamUtil.getConsoleApiUrlString(context, apiName), encodedUserName, encodedPassword, encodedMessage, signature) ;
        VeamUtil.log("debug", "message url=" + urlString) ;

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
