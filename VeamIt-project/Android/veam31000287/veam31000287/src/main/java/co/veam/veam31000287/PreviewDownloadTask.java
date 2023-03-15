package co.veam.veam31000287;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnClickListener;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.EventListener;

public class PreviewDownloadTask extends AsyncTask<String, Integer, Integer> implements OnCancelListener, OnClickListener {
	
	final String TAG = "PreviewDownloadTask";
	ProgressDialog dialog;
	private Activity mActivity ;
	private PreviewDownloadNotify mPreviewDownloadNotify = null;
	private VideoObject videoObject ;
	

	// コンストラクタ  
    public PreviewDownloadTask(Activity activity,VideoObject videoObject,String dialogTitle,String dialogMessage) {
    	mActivity = activity ;
    	this.videoObject = videoObject ;
    	mPreviewDownloadNotify = new PreviewDownloadNotify();
         // 通知用クラスに通知先のインスタンスを付加
    	
		dialog = new ProgressDialog(mActivity) ;
		dialog.setTitle(dialogTitle) ;
		dialog.setMessage(dialogMessage) ;
		dialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL) ;
		dialog.setCancelable(true) ;
		dialog.setOnCancelListener(this) ;
		dialog.setProgress(0) ;
		dialog.setButton(mActivity.getString(R.string.cancel), this) ;
		dialog.show() ;
	}
    public void setListener(PreviewDownloadListenerInterface listener){
    	mPreviewDownloadNotify.setListener(listener);
    }
    
    private static final int BUFFER_SIZE = 262144 ;
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	
    	Integer retInt = 0 ;
    	/*
        DatabaseHelper helper = new DatabaseHelper(mActivity);
		SQLiteDatabase db = helper.getReadableDatabase();
		*/
		DatabaseHelper helper = DatabaseHelper.getInstance(mActivity) ;
		SQLiteDatabase db = helper.getReadableDatabase() ;

    	
    	String previewDownloadUrl = this.videoObject.getDataUrl() ;
    	String fileName = "tmp.mp4.part" ;
    	String outputPath = VeamUtil.getVeamFilePath(mActivity, fileName) ;
		int totalBytes = 0 ;

		try {
	        File file = new File(outputPath);
	        BufferedOutputStream out;
			out = new BufferedOutputStream(new FileOutputStream(file, false), BUFFER_SIZE);
			
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(previewDownloadUrl);
			URLConnection urlConnection = url.openConnection() ;
			InputStream is = urlConnection.getInputStream();
			BufferedInputStream in = new BufferedInputStream(is, BUFFER_SIZE);
			
			
			totalBytes = urlConnection.getContentLength() ;
			dialog.setMax(totalBytes) ;

			int writtenBytes = 0 ;
      
			byte buf[] = new byte[BUFFER_SIZE];  
	        int size = -1;  
	        while((size = in.read(buf)) != -1) {
	        	// System.out.println("downloading") ;
	        	out.write(buf, 0, size);
	        	writtenBytes += size ;
				publishProgress(writtenBytes) ;
				if(isCancelled()){
					//System.out.println("Cancelled!") ;
					break;
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
		
		String toFileName = String.format("p%s.mp4", this.videoObject.getId()) ;
		if((totalBytes > 0) && VeamUtil.fileExistsAtVeamDirectory(mActivity, fileName, totalBytes)){
			VeamUtil.moveVeamFile(mActivity, fileName, toFileName) ;
			retInt = 1 ;
		}
		
		/*
		if(db != null){
			db.close() ;
		}
		*/
		
		return retInt;
    }
    
    
	  @Override
	  protected void onProgressUpdate(Integer... values) {
	    //VeamUtil.log(TAG, "onProgressUpdate - " + values[0]);
	    dialog.setProgress(values[0]);
	  }
	  
	  @Override
	  protected void onCancelled() {
		//VeamUtil.log(TAG, "onCancelled");
	    dialog.dismiss();
	  }

	  @Override
	  protected void onPostExecute(Integer result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
	    dialog.dismiss() ;
	    if(result == 1){
	    	this.mPreviewDownloadNotify.complete(this.videoObject.getId()) ;
	    } else {
	    	this.mPreviewDownloadNotify.cancel(this.videoObject.getId()) ;
	    }
	  }

	  public void onCancel(DialogInterface dialog) {
		//VeamUtil.log(TAG, "Dialog onCancell... calling cancel(true)");
	    this.cancel(true);
	  }

	public void onClick(DialogInterface dialog, int which) {
		//VeamUtil.log(TAG, "Dialog cancel button down ... calling cancel(true)");
	    this.cancel(true);
	    this.mPreviewDownloadNotify.cancel(this.videoObject.getId()) ;
	}
	
	public interface PreviewDownloadListenerInterface extends EventListener {
	    public void onCancelPreviewDownload(String contentId);
	    public void onCompletePreviewDownload(String contentId);
	}
	
	public class PreviewDownloadNotify {
		 
	    private PreviewDownloadListenerInterface listener = null;
	 
	    public void cancel(String contentId){
	        if(this.listener != null){
                listener.onCancelPreviewDownload(contentId) ;
	        }
	    }
	    
	    public void complete(String contentId){
	        if(this.listener != null){
                listener.onCompletePreviewDownload(contentId) ;
	        }
	    }
	 
	    /**
	     * リスナーを追加する
	     * @param listener
	     */
	    public void setListener(PreviewDownloadListenerInterface listener){
	        this.listener = listener;
	    }
	 
	    /**
	     * リスナーを削除する
	     */
	    public void removeListener(){
	        this.listener = null;
	    }
	}
}
