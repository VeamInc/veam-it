package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.exception.DropboxException;

import java.io.IOException;

/**
 * Created by veam on 12/2/16.
 */
public class ConsoleDropboxShareTask extends AsyncTask<String, Integer, String> {

    final String TAG = "ConsoleDropboxListTask";
    private Context context ;
    private DropboxAPI<AndroidAuthSession> mApi;
    private String path ;
    private ConsoleDropboxActivity consoleDropboxActivity ;

    // コンストラクタ
    public ConsoleDropboxShareTask(ConsoleDropboxActivity consoleDropboxActivity, DropboxAPI<AndroidAuthSession> api,String path) {
        this.context = context ;
        this.consoleDropboxActivity = consoleDropboxActivity ;
        this.mApi = api ;
        this.path = path ;
    }

    // バックグラウンドで実行する処理
    @Override
    protected String doInBackground(String... urls) {
        // Get the metadata for a directory
        VeamUtil.log("debug", "ConsoleDropboxShareTask dropboxPath=" + path) ;
        String result = null;
        DropboxAPI.DropboxLink link = null ;
        try {
            VeamUtil.log("debug", "ConsoleDropboxShareTask mApi.share(" + path) ;
            link = mApi.share(path) ;
        } catch (DropboxException e) {
            e.printStackTrace();
        }

        if(link != null){
            String linkPath = link.url ;
            int retry = 3 ;
            while(VeamUtil.isEmpty(result) && (retry > 0)) {
                try {
                    VeamUtil.log("debug", "ConsoleDropboxShareTask dropobxPath=" + path + " link=" + linkPath + " length=" + linkPath.length());
                    result = ConsoleUtil.getFinalURL(linkPath);
                    int index = result.lastIndexOf("?dl=0");
                    if (index >= 0) {
                        result = result.substring(0, index);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                linkPath = linkPath.substring(0,linkPath.length()-1) ;
                retry-- ;
            }
        }

        return result ;
    }

    @Override
    protected void onPostExecute(String result) {
        //VeamUtil.log(TAG, "onPostExecute - " + result);
        consoleDropboxActivity.onShareDropboxFile(result);
    }
}
