package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.exception.DropboxException;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

/**
 * Created by veam on 12/1/16.
 */
public class ConsoleDropboxListTask extends AsyncTask<String, Integer, DropboxAPI.Entry> {

    final String TAG = "ConsoleDropboxListTask";
    private Context context ;
    private DropboxAPI<AndroidAuthSession> mApi;
    private String path ;
    private ConsoleDropboxActivity consoleDropboxActivity ;

    // コンストラクタ
    public ConsoleDropboxListTask(ConsoleDropboxActivity consoleDropboxActivity, DropboxAPI<AndroidAuthSession> api,String path) {
        this.context = context ;
        this.consoleDropboxActivity = consoleDropboxActivity ;
        this.mApi = api ;
        this.path = path ;
    }

    // バックグラウンドで実行する処理
    @Override
    protected DropboxAPI.Entry doInBackground(String... urls) {
        // Get the metadata for a directory
        DropboxAPI.Entry result = null;
        try {
            result = mApi.metadata(path, 1000, null, true, null);
        } catch (DropboxException e) {
            e.printStackTrace();
        }

        return result ;
    }

    @Override
    protected void onPostExecute(DropboxAPI.Entry result) {
        //VeamUtil.log(TAG, "onPostExecute - " + result);
        consoleDropboxActivity.onLoadList(result);
    }
}
