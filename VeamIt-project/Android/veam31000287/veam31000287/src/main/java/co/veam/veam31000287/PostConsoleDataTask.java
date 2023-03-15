package co.veam.veam31000287;

import android.media.Image;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import com.facebook.HttpMethod;
import com.facebook.Request;
import com.facebook.Response;
import com.facebook.Session;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import twitter4j.StatusUpdate;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;

/**
 * Created by veam on 11/8/16.
 */
public class PostConsoleDataTask extends AsyncTask<String, Integer, Integer> {

    final String TAG = "PostConsoleDataTask";
    private String apiName ;
    private Map<String,String> params ;
    private String imageUri ;
    private HandlePostResultInterface handlePostResultInterface ;

    // コンストラクタ
    public PostConsoleDataTask(String apiName,Map<String,String> params,String imageUri,HandlePostResultInterface handlePostResultInterface) {
        this.apiName = apiName ;
        this.params = params ;
        this.imageUri = imageUri ;
        this.handlePostResultInterface = handlePostResultInterface ;
    }

    // バックグラウンドで実行する処理
    @Override
    protected Integer doInBackground(String... urls) {

        Integer result = 0 ;
        //NSLog("url=%",[apiUrlWithParam absoluteString]) ;
        String urlString = VeamUtil.getConsoleApiUrlString(AnalyticsApplication.getContext(), apiName) ;
        VeamUtil.log("debug","url="+urlString) ;

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

            byte[] readBytes ;

            if(imageUri != null) {
                File file = new File(imageUri);
                FileInputStream fileInputStream = new FileInputStream(file);
                //fileInputStream = AnalyticsApplication.getContext().openFileInput("ConsoleFile");
                readBytes = new byte[fileInputStream.available()];
                fileInputStream.read(readBytes);
            } else {
                readBytes = new byte[0] ;
            }

            //VeamUtil.log("debug","first:"+readBytes[0]) ;
            String responseString = request.send(readBytes);

            VeamUtil.log("debug","responseString:"+responseString) ;
            String[] results = responseString.split("\\n") ;
            int numberOfLines = results.length ;
            if(numberOfLines >= 1){
                if(results[0].equals("OK")){
                    VeamUtil.log("debug","Console Post Data OK") ;
                    result = 1 ;
                    if(handlePostResultInterface != null) {
                        handlePostResultInterface.handlePostResult(new ArrayList(Arrays.asList(results)));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result ;
    }

    @Override
    protected void onPostExecute(Integer result) {
        VeamUtil.log(TAG, "onPostExecute - " + result);
        if(result == 1){
            ConsoleUtil.notifyConsoleDataPostDone(apiName) ;
        } else {
            ConsoleUtil.notifyConsoleDataPostFailed(apiName);
        }
    }
}
