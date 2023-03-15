package co.veam.veam31000287;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;

public class LoadImageTask extends AsyncTask<String, Integer, Bitmap> {
	
	final String TAG = "LoadImageTask";
	private Context context ;
	private ImageView imageView ;
	private String imageUrl ;
	private int displayWidth ;
	private int targetTag ;
	private ProgressBar progress ;
	
	// コンストラクタ  
    public LoadImageTask(Context activity,String imageUrl,ImageView imageView,int displayWidth,int targetTag,ProgressBar progress) {
    	context = activity ;
    	this.imageView = imageView ;
    	this.imageUrl = imageUrl ;
    	this.displayWidth = displayWidth ;
    	this.targetTag = targetTag ;
    	this.progress = progress ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Bitmap doInBackground(String... userId) {

    	Bitmap retBitmap = VeamUtil.getCachedFileBitmapWithWidth(context, imageUrl, displayWidth,1, true) ;
    	/*
    	FileInputStream inputStream = VeamUtil.getCachedFileInputStream(context, imageUrl, true) ;
    	if(inputStream != null){
    		int retryCount = 0 ; 
			BitmapFactory.Options options = new BitmapFactory.Options() ;
			//options.inSampleSize = 2 ;
			options.inJustDecodeBounds = true ;
			BitmapFactory.decodeStream(inputStream,null,options) ;
			  
			int imageHeight = options.outHeight ;  
			int imageWidth = options.outWidth ;
			options.inSampleSize  = imageWidth / displayWidth ;
			if(options.inSampleSize < 1){
				options.inSampleSize = 1 ;
			}
			//options.inSampleSize *= 5 ;
			options.inJustDecodeBounds = false ;
			
			//VeamUtil.log("debug","displayWidth:" + displayWidth + " imageWidth:" + imageWidth + " imageHeight:" + imageHeight + " inSampleSize:" + options.inSampleSize) ;
    		while((retBitmap == null) && (retryCount < 5)){
	    		try {
	    	    	inputStream = VeamUtil.getCachedFileInputStream(context, imageUrl, false) ;
	    			retBitmap = BitmapFactory.decodeStream(inputStream,null,options) ;
	    		} catch (OutOfMemoryError e) {
	    			VeamUtil.log("debug","OutOfMemory") ;
	    			try {
						Thread.sleep(500) ;
					} catch (InterruptedException e1) {
						e1.printStackTrace();
					}
	    		}
	    		retryCount++ ;
    		}
    	}
    	*/
		return retBitmap;
    }
    
	@Override
	protected void onPostExecute(Bitmap bitmap) {
		//VeamUtil.log(TAG, "LoadIconTask::onPostExecute");
		if(progress != null){
			Integer tag = (Integer)progress.getTag() ;
			if(targetTag == tag){
				progress.setVisibility(View.GONE) ;
			}
		}
		if(bitmap != null){
			Integer tag = (Integer)imageView.getTag() ;
			if(targetTag == tag){
				//VeamUtil.log("debug","onPostExecute w:" + bitmap.getWidth() + " h:" + bitmap.getHeight()) ;
				imageView.setImageBitmap(bitmap) ;
			}
			bitmap = null ;
		}
	}
}
