package co.veam.veam31000287;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.ImageView;

public class LoadDrawableTask extends AsyncTask<String, Integer, Drawable> {
	
	final String TAG = "LoadImageTask";
	private Context context ;
	private ImageView imageView ;
	private String imageUrl ;
	private int displayWidth ;
	private int targetTag ;
	
	// コンストラクタ  
    public LoadDrawableTask(Context activity,String imageUrl,ImageView imageView,int displayWidth,int targetTag) {
    	context = activity ;
    	this.imageView = imageView ;
    	this.imageUrl = imageUrl ;
    	this.displayWidth = displayWidth ;
    	this.targetTag = targetTag ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Drawable doInBackground(String... userId) {

    	Bitmap retBitmap = VeamUtil.getCachedFileBitmapWithWidth(context, imageUrl, displayWidth,2, true) ;
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
    	Drawable drawable = new BitmapDrawable(context.getResources(), retBitmap); 
    	
		return drawable ;
    }
    
	@Override
	protected void onPostExecute(Drawable drawable) {
		//VeamUtil.log(TAG, "LoadIconTask::onPostExecute");
		if(drawable != null){
			Integer tag = (Integer)imageView.getTag() ;
			if(targetTag == tag){
				//VeamUtil.log("debug","onPostExecute w:" + bitmap.getWidth() + " h:" + bitmap.getHeight()) ;
				//imageView.setImageBitmap(bitmap) ;
				imageView.setImageDrawable(drawable) ;
			}
			drawable = null ;
		}
	}
}
