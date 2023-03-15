package co.veam.veam31000287;

import android.app.IntentService;
import android.content.Intent;
import android.util.Log;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by veam on 12/9/16.
 */
public class UploadIntentService extends IntentService {

    public UploadIntentService(String name) {
        super(name);
        // TODO 自動生成されたコンストラクター・スタブ
    }

    public UploadIntentService(){
        // ActivityのstartService(intent);で呼び出されるコンストラクタはこちら
        super("UploadIntentService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        // 非同期処理を行うメソッド。タスクはonHandleIntentメソッド内で実行する
        VeamUtil.log("debug", "UploadIntentService::onHandleIntent Start");

        String sourceFileUri = intent.getStringExtra("SOURCE_FILE_URI") ;
        String fileName = intent.getStringExtra("FILE_NAME") ;

        String uploadUrl = VeamUtil.getUploadApiUrl("file/upload") ;
        String uploadServerUri = String.format("%s&k=1&f=%s",uploadUrl,fileName) ;

        VeamUtil.log("debug", "UploadIntentService::onHandleIntent Start fileName="+fileName + " : sourceFile="+sourceFileUri+" : URL=" + uploadServerUri);

        if(!VeamUtil.isEmpty(sourceFileUri)){
            HttpURLConnection conn = null;
            DataOutputStream dos = null;
            String lineEnd = "\r\n";
            String twoHyphens = "--";
            String boundary = "*****";
            int bytesRead, bytesAvailable, bufferSize;
            byte[] buffer;
            int maxBufferSize = 1 * 1024 * 1024;
            File sourceFile = new File(sourceFileUri);

            if (sourceFile.isFile()) {
                try {
                    // open a URL connection to the Servlet
                    FileInputStream fileInputStream = new FileInputStream(sourceFile);
                    URL url = new URL(uploadServerUri);

                    // Open a HTTP connection to the URL
                    conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("PUT");

                    /*
                    conn.setInstanceFollowRedirects(false);
                    //conn.setRequestProperty("Accept-Language", "jp");
                    conn.setDoOutput(true);
                    conn.setConnectTimeout(5000);
                    conn.setReadTimeout(5000);
                    //conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
                    conn.setRequestProperty("Content-Type", "application/octet-stream");
                    */

                    /*
                    OutputStream os = conn.getOutputStream();
                    PrintStream ps = new PrintStream(os);
                    ps.print("jsonString");
                    ps.close();
                    */

                    conn.setInstanceFollowRedirects(false);
                    //conn.setDoInput(true); // Allow Inputs
                    conn.setDoOutput(true); // Allow Outputs
                    //conn.setUseCaches(false); // Don't use a Cached Copy
                    conn.setConnectTimeout(50000);
                    conn.setReadTimeout(50000);
                    conn.setRequestMethod("PUT");
                    //conn.setRequestMethod("POST");
                    conn.setRequestProperty("Connection", "Keep-Alive");
                    //conn.setRequestProperty("ENCTYPE", "multipart/form-data");
                    conn.setRequestProperty("Content-Type", "application/octet-stream");
                    //conn.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);
                    //conn.setRequestProperty("uploaded_file", fileName);

                    dos = new DataOutputStream(conn.getOutputStream());

                    // create a buffer of maximum size
                    bytesAvailable = fileInputStream.available();

                    bufferSize = Math.min(bytesAvailable, maxBufferSize);
                    buffer = new byte[bufferSize];

                    // read file and write it into form...
                    bytesRead = fileInputStream.read(buffer, 0, bufferSize);

                    while (bytesRead > 0) {
                        VeamUtil.log("debug","upload "+ bufferSize + "bytes") ;
                        dos.write(buffer, 0, bufferSize);
                        bytesAvailable = fileInputStream.available();
                        bufferSize = Math.min(bytesAvailable, maxBufferSize);
                        bytesRead = fileInputStream.read(buffer, 0, bufferSize);
                    }


                    //close the streams //
                    fileInputStream.close();
                    dos.flush();
                    dos.close();

                    // Responses from the server (code and message)
                    int serverResponseCode = conn.getResponseCode();
                    String serverResponseMessage = conn.getResponseMessage();

                    VeamUtil.log("debug", "upload file HTTP Response is : " + serverResponseMessage + ": " + serverResponseCode);

                    if (serverResponseCode == 200) {
                    }

                } catch (MalformedURLException ex) {
                    ex.printStackTrace();
                    VeamUtil.log("debug","Upload file to server error: " + ex.getMessage());
                } catch (Exception e) {
                    e.printStackTrace();
                    VeamUtil.log("debug","Upload file to server Exception : "+ e.getMessage());
                }
            } else {
                Log.e("debug", "Source File not exist :" + sourceFileUri);
            }
        }
        VeamUtil.log("debug", "UploadIntentService::onHandleIntent End");
    }
}