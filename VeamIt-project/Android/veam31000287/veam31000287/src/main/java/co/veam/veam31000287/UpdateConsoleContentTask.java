package co.veam.veam31000287;

import android.content.Context;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.util.Log;

import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

/**
 * Created by veam on 10/27/16.
 */
public class UpdateConsoleContentTask  extends AsyncTask<String, Integer, Integer> {

    final String TAG = "UpdateConsoleContentTask";
    private UpdateConsoleContentTaskActivityInterface updateConsoleContentActivity ;
    private Context context ;

    // コンストラクタ
    public UpdateConsoleContentTask(UpdateConsoleContentTaskActivityInterface updateConsoleContentActivity, Context context) {
        this.updateConsoleContentActivity = updateConsoleContentActivity ;
        this.context = context ;
    }


    // バックグラウンドで実行する処理
    @Override
    protected Integer doInBackground(String... urls) {
        Integer resultCode = 0 ;

        VeamUtil.log("debug", "UpdateConsoleContentTask::doInBackground") ;

        try {


            // 処理中のものがないかチェック
            //NSLog(@"%@::updateContents",NSStringFromClass([self class])) ;

            // 0:waiting 1:done 2:error 3:executing
            String commandStatus = "0" ;
            int retryMax = 20 ;
            int retryCount = 0 ;
            while(!commandStatus.equals("1") && (retryCount < retryMax)){
                if(retryCount != 0){
                    VeamUtil.log("debug","retry " + retryCount) ;
                    Thread.sleep(5000);
                }

                commandStatus = this.getCommandStatus("UPDATE_CONCEPT_COLOR") ;

                retryCount++ ;

                //currentProgress = retryCount ;
                //[self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO] ;
            }

            commandStatus = "0" ;
            retryCount = 0 ;
            while(!commandStatus.equals("1") && (retryCount < retryMax)){
                if(retryCount != 0){
                    VeamUtil.log("debug","retry " + retryCount) ;
                    Thread.sleep(5000);
                }

                commandStatus = this.getCommandStatus("UPDATE_SCREEN_SHOT") ;

                retryCount++ ;

                //currentProgress = retryCount ;
                //[self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO] ;
            }


            ConsoleContents consoleContents = new ConsoleContents() ;
            // HTTP経由でアクセスし、InputStreamを取得する
            String urlString = VeamUtil.getConsoleApiUrlString(context,"content/list") ;
            ////VeamUtil.log("debug","url="+urlString) ;
            URL url = new URL(urlString);
            InputStream is = url.openConnection().getInputStream();

            SAXParserFactory spfactory = SAXParserFactory.newInstance();
            SAXParser parser = spfactory.newSAXParser();
            DatabaseHelper helper = DatabaseHelper.getInstance(context) ;
            final SQLiteDatabase db = helper.getReadableDatabase() ;

            SharedPreferences preferences = VeamUtil.getPreferences(context) ;
            SharedPreferences.Editor editor = preferences.edit();
            UpdateConsoleXmlHandler updateConsoleXmlHandler = new UpdateConsoleXmlHandler(context,consoleContents,editor,true,false) ;
            parser.parse(is, updateConsoleXmlHandler) ;
            editor.commit();
            ConsoleUtil.setConsoleContents(consoleContents);

            resultCode = 1 ;
        } catch (Exception e) {
            e.printStackTrace();
            //System.out.println("failed to update") ;
        }

        //VeamUtil.log("debug", "UpdateConsoleContentTask::doInBackground end") ;

        return resultCode;
    }

    @Override
    protected void onPostExecute(Integer resultCode) {
        //VeamUtil.log(TAG, "onPostExecute - " + resultCode);
        updateConsoleContentActivity.onUpdateConsoleContentFinished(resultCode) ;
    }


    @Override
    protected void onProgressUpdate(Integer... values) {
        VeamUtil.log("debug", "onProgressUpdate - " + values[0]);
    }

    public interface  UpdateConsoleContentTaskActivityInterface {
        public void onUpdateConsoleContentFinished(Integer resultCode) ;
        //public void onUpdateConsoleContentProgress(Integer percentage) ;
    }

    public String getCommandStatus(String commandName){

        String commandStatus = "0" ;
        String apiName = "app/getcommandstatus" ;
        String urlString = VeamUtil.getConsoleApiUrlString(AnalyticsApplication.getContext(), apiName) ;
        Map<String,String> params = new HashMap<String,String>() ;
        params.put("n",commandName) ;

        Set<String> unsortedKeys = params.keySet() ;
        TreeSet<String> keys = new TreeSet<String>() ;
        Iterator<String> iterator = unsortedKeys.iterator();
        while (iterator.hasNext()) {
            keys.add(iterator.next()) ;
        }

        List<String> postData = new ArrayList<String>();

        int count = keys.size() ;
        String planeText = "CONSOLE" ;
        Iterator<String> keyIterator = keys.iterator();
        while (keyIterator.hasNext()) {
            String key = keyIterator.next() ;
            String value = params.get(key) ;
            postData.add(String.format("%s=%s", key,value));
            planeText = planeText + String.format("_%s",value) ;
            VeamUtil.log("debug","param:"+String.format("%s=%s", key,value)) ;
        }

        String signature = VeamUtil.sha1(planeText) ;
        postData.add(String.format("%s=%s", "s",signature));

        try {
            HttpMultipartRequest request = new HttpMultipartRequest(
                    urlString,
                    postData,
                    "upfile",
                    "ConsoleFile") ;

            byte[] readBytes = new byte[0] ;

            //VeamUtil.log("debug","first:"+readBytes[0]) ;
            String responseString = request.send(readBytes);

            VeamUtil.log("debug","responseString:"+responseString) ;
            String[] results = responseString.split("\\n") ;
            int numberOfLines = results.length ;
            if(numberOfLines >= 2){
                if(results[0].equals("OK")){
                    commandStatus = results[1] ;
                    VeamUtil.log("debug","command status="+commandStatus) ;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return commandStatus ;

    }

}
