package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

public class LoadDataTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "LoadDataTask";
	private Context context ;
	private LoadDataTaskListener listener ;
	private String dataUrl ;
	private String fileName ;
	private int fileSize ;
	
	// コンストラクタ  
    public LoadDataTask(Context activity,LoadDataTaskListener listener,String dataUrl,String fileName,int fileSize) {
		//VeamUtil.log("debug", "LoadDataTask::LoadDataTask "+dataUrl);
    	this.context = activity ;
    	this.listener = listener ;
    	this.dataUrl = dataUrl ;
    	this.fileName = fileName ;
    	this.fileSize = fileSize ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... userId) {

    	Integer resultCode = 0 ;
		String outputPath = VeamUtil.getVeamFilePath(context, fileName) ;

		int BUFFER_SIZE = 10240;
		
		int totalBytesCount = fileSize ;
		//VeamUtil.log("debug", "outputPath:"+outputPath + " totalBytesCount:"+totalBytesCount);
		
		boolean completed = false ;
		int retryCount = 0 ;
		while(!completed && (retryCount < 3)){
			try {
			    File file = new File(outputPath);
				
				// HTTP経由でアクセスし、InputStreamを取得する
				//VeamUtil.log("debug", "LoadDataTask::doInbackground dataUrl=" + dataUrl) ;
				URL url = new URL(dataUrl);
				InputStream is = url.openConnection().getInputStream();
				int downloadedBytesCount = 0 ;
				//System.out.println("download size=" + totalBytesCount) ;
				BufferedInputStream in = new BufferedInputStream(is, BUFFER_SIZE);  
		      
			    BufferedOutputStream out;
				out = new BufferedOutputStream(new FileOutputStream(file, false), BUFFER_SIZE);
				
				byte buf[] = new byte[BUFFER_SIZE];  
			    int size = -1;
			    int prevProgress = 0 ;
			    while((size = in.read(buf)) != -1) {
			    	// System.out.println("downloading") ;
			    	out.write(buf, 0, size);
			    	downloadedBytesCount += size ;
			    	float progressFloat = (float)downloadedBytesCount / (float)totalBytesCount ;
			    	progressFloat *= 100 ;
			    	int progress = (int)progressFloat ;
			    	if(prevProgress != progress){
			    		//VEAMUtil.setDownloadNotification(this, title, contentId, musicId, VEAMConsts.DOWNLOAD_STATUS_DOWNLOADING,progress) ;
			    		prevProgress = progress ;
			    		if(listener != null){
			    			listener.onLoadDataProgress(progress) ;
			    		}
			    	}
			    }  
			    out.flush();  
			    out.close();  
			    in.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			if(VeamUtil.fileExistsAtVeamDirectory(context, fileName, totalBytesCount)){
				completed = true ;
				resultCode = 1 ;
			} else {
				try {
					Thread.sleep(5000) ;
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			
			retryCount++ ;
		}
		return resultCode ;
    }
    
	@Override
	protected void onPostExecute(Integer resultCode) {
		//VeamUtil.log("debug", "LoadDataTask::onPostExecute "+resultCode);
		if(listener != null){
			listener.onLoadDataCompleted(resultCode) ;
		}
	}
	
	public interface LoadDataTaskListener {
		void onLoadDataCompleted(Integer resultCode);
		void onLoadDataProgress(int progress) ;
	}

}
