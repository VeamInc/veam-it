package co.veam.veam31000287;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.hardware.Camera;
import android.hardware.Camera.AutoFocusCallback;
import android.hardware.Camera.CameraInfo;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.Size;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.Surface;
import android.view.View;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class CameraActivity extends VeamActivity implements PictureCallback, AutoFocusCallback {
	// カメラインスタンス
	private Camera camera = null;
	private CameraPreview cameraPreview = null;
	private int numberOfCameras ;
	private RelativeLayout mainView ;
	private RelativeLayout rootLayout ;
	private int currentCameraId ;
	private String forumId ;
	private boolean takenPicture ;
	private boolean hasAutoFocus = false ;
	private int cameraY ;
	private int cameraSize ;

	private int currentDegrees = 0 ;

	final private int REQUEST_CODE_GALLERY = 10;
	final private int REQUEST_CODE_CROP = 11;
	final private int REQUEST_CODE_IMAGE_EDIT_ACTIVITY = 12;

	private int VIEWID_CANCEL_TEXT		= 0x10001 ;
	private int VIEWID_SELECT_TEXT		= 0x10002 ;
	private int VIEWID_SHUTTER_BUTTON	= 0x10003 ;
	private int VIEWID_SWITCH_BUTTON	= 0x10004 ;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
		setContentView(R.layout.activity_camerra);

		Intent intent = getIntent();
		forumId = intent.getStringExtra("forum_id") ;


		numberOfCameras = Camera.getNumberOfCameras() ;
		//VeamUtil.log("debug","numberOfCameras:"+numberOfCameras) ;
		if(numberOfCameras == 0){
			VeamUtil.showMessage(this,this.getString(R.string.no_camera_available)) ;
			this.finish() ;
			return ;
		}

		PackageManager packageManager = this.getPackageManager() ;
		hasAutoFocus = packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_AUTOFOCUS) ;
		//VeamUtil.log("debug",hasAutoFocus?"has AF":"NOT has AF") ;

		currentCameraId = 0 ;

		this.openCamera() ;

		RelativeLayout.LayoutParams layoutParams ;
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;

		FrameLayout.LayoutParams rootParams = (FrameLayout.LayoutParams)rootLayout.getLayoutParams() ;
		rootParams.height = deviceHeight * 2 ;
		rootLayout.setLayoutParams(rootParams) ;


		//mainView = this.addMainView(rootLayout,View.VISIBLE) ;
		viewHeight = deviceHeight - this.getStatusBarHeight() ;
		mainView = new RelativeLayout(this) ;
		mainView.setBackgroundColor(Color.TRANSPARENT) ;
		rootLayout.addView(mainView,createParam(deviceWidth, viewHeight*2)) ;

		int bottomHeight = deviceWidth*25/100;

		cameraSize = deviceWidth*98/100 ;

		int space = (this.viewHeight - this.topBarHeight - bottomHeight - cameraSize) ;
		//VeamUtil.log("debug","space=" + space) ;
		if(space < 0){
			cameraSize = this.viewHeight - this.topBarHeight - bottomHeight ;
			space = 0 ;
		}

		Camera.Parameters cameraParams = camera.getParameters();
		this.setPreviewSize(cameraParams) ;
		camera.setParameters(cameraParams);
		//Size pictureSize = cameraParams.getPictureSize() ;
		Size pictureSize = cameraParams.getPreviewSize() ;
		//VeamUtil.log("debug","pictureSize:width=" + pictureSize.width + " height="+pictureSize.height) ;

		int rotatedWidth = pictureSize.height ;
		int rotatedHeight = pictureSize.width ;
		int cameraWidth = cameraSize ;
		int cameraHeight = rotatedHeight * cameraWidth / rotatedWidth ;

		cameraY = topBarHeight + space / 2 ;

		// FrameLayout に CameraPreview クラスを設定
		cameraPreview = new CameraPreview(this, camera) ;
		layoutParams = createParam(cameraWidth, cameraHeight) ;
		layoutParams.setMargins((deviceWidth-cameraWidth)/2,cameraY,0,0) ;
		mainView.addView(cameraPreview,layoutParams) ;
		//VeamUtil.log("debug","cameraY:"+cameraY + "deviceWidth:"+deviceWidth + "deviceHeight:"+deviceHeight + "pw:"+pictureSize.width+" ph:"+pictureSize.height + " cw:"+cameraWidth+" ch:"+cameraHeight) ;

		this.addTopBar(mainView, "",true,false) ;
		TextView cancelTextView = new TextView(this) ;
		cancelTextView.setId(VIEWID_CANCEL_TEXT) ;
		cancelTextView.setOnClickListener(this) ;
		cancelTextView.setText(this.getString(R.string.cancel)) ;
		cancelTextView.setGravity(Gravity.CENTER_VERTICAL|Gravity.LEFT) ;
		cancelTextView.setTextColor(Color.WHITE) ;
		cancelTextView.setTextSize((float)deviceWidth * 5.0f / 100 / scaledDensity) ;
		layoutParams = createParam(deviceWidth*30/100, topBarHeight) ;
		layoutParams.setMargins(topBarHeight/2,0,0,0) ;
		mainView.addView(cancelTextView,layoutParams) ;
		mainView.setBackgroundColor(Color.rgb(0x22, 0x22, 0x22)) ;

		int maskY = cameraY+cameraWidth ;
		View maskView = new View(this) ;
		maskView.setBackgroundColor(Color.rgb(0x22, 0x22, 0x22)) ;
		layoutParams = createParam(deviceWidth, this.viewHeight-maskY) ;
		layoutParams.setMargins(0,maskY,0,0) ;
		mainView.addView(maskView,layoutParams) ;

		View bottomBackView = new View(this) ;
		bottomBackView.setBackgroundColor(Color.BLACK) ;
		layoutParams = createParam(deviceWidth, bottomHeight) ;
		layoutParams.setMargins(0,this.viewHeight-bottomHeight,0,0) ;
		mainView.addView(bottomBackView,layoutParams) ;

		int shutterSize = deviceWidth * 20 / 100 ;
		ImageView shutterImageView = new ImageView(this) ;
		shutterImageView.setId(VIEWID_SHUTTER_BUTTON) ;
		shutterImageView.setOnClickListener(this) ;
		shutterImageView.setImageResource(R.drawable.shutter) ;
		shutterImageView.setScaleType(ScaleType.FIT_XY) ;
		layoutParams = createParam(shutterSize, shutterSize) ;
		layoutParams.setMargins(deviceWidth*40/100,viewHeight-deviceWidth*225/1000,0,0) ;
		mainView.addView(shutterImageView,layoutParams) ;

		int switchWidth = deviceWidth * 13 / 100 ;
		int switchHeight = deviceWidth * 8 / 100 ;

		ImageView switchImageView = new ImageView(this) ;
		switchImageView.setId(VIEWID_SWITCH_BUTTON) ;
		switchImageView.setOnClickListener(this) ;
		switchImageView.setImageResource(R.drawable.change_camera) ;
		switchImageView.setScaleType(ScaleType.FIT_XY) ;
		layoutParams = createParam(switchWidth, switchHeight) ;
		layoutParams.setMargins(deviceWidth*85/100,viewHeight-deviceWidth*165/1000,0,0) ;
		mainView.addView(switchImageView,layoutParams) ;

		TextView selectTextView = new TextView(this) ;
		selectTextView.setId(VIEWID_SELECT_TEXT) ;
		selectTextView.setOnClickListener(this) ;
		selectTextView.setText(this.getString(R.string.select)) ;
		selectTextView.setGravity(Gravity.CENTER) ;
		selectTextView.setTextColor(Color.WHITE) ;
		selectTextView.setTextSize((float)deviceWidth * 5.0f / 100 / scaledDensity) ;
		layoutParams = createParam(deviceWidth*28/100, deviceWidth*25/100) ;
		layoutParams.setMargins(0,viewHeight-deviceWidth*25/100,0,0) ;
		mainView.addView(selectTextView,layoutParams) ;

	}



	public void setCameraDisplayOrientation(int cameraId, android.hardware.Camera camera) {
		android.hardware.Camera.CameraInfo info = new android.hardware.Camera.CameraInfo() ;
		android.hardware.Camera.getCameraInfo(cameraId, info) ;
		int rotation = this.getWindowManager().getDefaultDisplay().getRotation() ;
		int degrees = 0 ;
		switch (rotation){
			case Surface.ROTATION_0: degrees = 0; break ;
			case Surface.ROTATION_90: degrees = 90; break ;
			case Surface.ROTATION_180: degrees = 180; break ;
			case Surface.ROTATION_270: degrees = 270; break ;
		}

		int result ;
		if(info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT){
			result = (info.orientation + degrees) % 360 ;
			result = (360 - result) % 360 ;  // compensate the mirror
		} else {  // back-facing
			result = (info.orientation - degrees + 360) % 360 ;
		}
		camera.setDisplayOrientation(result) ;

		currentDegrees = result ;
		//VeamUtil.log("debug","currentDegrees = " + currentDegrees) ;
	}


	private void setPreviewSize(Camera.Parameters cameraParams){
		Size pictureSize = cameraParams.getPictureSize() ;
		Size previewSize = cameraParams.getPreviewSize() ;
		float pictureRasio = (float)pictureSize.height / (float)pictureSize.width ; // 0.75 or 0.5625
		float previewRasio = (float)previewSize.height / (float)previewSize.width ; // 0.75 or 0.5625

		//VeamUtil.log("debug","picture w="+pictureSize.width+" h="+pictureSize.height+" r="+pictureRasio) ;
		//VeamUtil.log("debug","preview w="+previewSize.width+" h="+previewSize.height+" r="+previewRasio) ;

		if(pictureRasio != previewRasio){
			List<Size> supported = cameraParams.getSupportedPreviewSizes();
			if (supported != null) {
				for (Camera.Size size : supported) {
					float workPreviewRasio = (float)size.height / (float)size.width ; // 0.75 or 0.5625
					if(pictureRasio == workPreviewRasio){
						cameraParams.setPreviewSize(size.width, size.height);
						//VeamUtil.log("debug","set preview w=" + size.width + " h=" + size.height + " r=" + workPreviewRasio) ;
						break ;
					}
				}
			}
		}
	}

	private void openCamera(){
		// カメラインスタンスの取得
		try {
			camera = Camera.open(currentCameraId) ;
			this.setCameraDisplayOrientation(currentCameraId,camera) ;
			//camera.setDisplayOrientation(90) ;

			if(cameraPreview != null){
				Camera.Parameters cameraParams = camera.getParameters() ;
				this.setPreviewSize(cameraParams) ;
				camera.setParameters(cameraParams);
				//Size pictureSize = cameraParams.getPictureSize() ;
				Size pictureSize = cameraParams.getPreviewSize() ;
				//VeamUtil.log("debug","open camera pictureSize:width=" + pictureSize.width + " height="+pictureSize.height) ;

				int rotatedWidth = pictureSize.height ;
				int rotatedHeight = pictureSize.width ;
				int cameraWidth = cameraSize ;
				int cameraHeight = rotatedHeight * cameraWidth / rotatedWidth ;
				RelativeLayout.LayoutParams layoutParams = createParam(cameraWidth, cameraHeight) ;
				layoutParams.setMargins((deviceWidth-cameraWidth)/2,cameraY,0,0) ;
				//VeamUtil.log("debug","open camera camera:width=" + cameraWidth + " height="+cameraHeight) ;
				cameraPreview.setLayoutParams(layoutParams) ;
			}
		} catch (Exception e) {
			// エラー
			this.finish();
		}
	}

	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","CameraActivity::onClick") ;
		if((view.getId() == VIEWID_TOP_BAR_BACK_BUTTON) || (view.getId() == VIEWID_CANCEL_TEXT)){
			//VeamUtil.log("debug","back button tapped") ;
			this.finish() ;
		} else 	if(view.getId() == VIEWID_SHUTTER_BUTTON){
			takenPicture = false ;
			if(hasAutoFocus){
				camera.autoFocus(this) ;
			} else {
				takenPicture = true ;
				camera.takePicture(null, null, this) ;
			}
		} else 	if(view.getId() == VIEWID_SELECT_TEXT){
			this.clearTmpFile() ;
			Intent intent = new Intent();
			intent.setType("image/*");
			intent.setAction(Intent.ACTION_GET_CONTENT);

			List<ResolveInfo> list = getPackageManager().queryIntentActivities(intent, 0);
			int size = list.size();
			if (size == 0) {
				//VeamUtil.log("debug","No Select Action") ;
			} else {
				//VeamUtil.log("debug", "Select Actions");
				for (ResolveInfo resolveInfo : list) {
					//VeamUtil.log("debug", " packageName=" + resolveInfo.activityInfo.packageName + " name=" + resolveInfo.activityInfo.name);
					if(resolveInfo.activityInfo.packageName.equals("com.google.android.apps.photos")) {
						//VeamUtil.log("debug", "set class");
						intent.setClassName(resolveInfo.activityInfo.packageName, resolveInfo.activityInfo.name) ;
						break ;
					}
				}
			}


			startActivityForResult(intent, REQUEST_CODE_GALLERY);
		} else 	if(view.getId() == VIEWID_SWITCH_BUTTON){
			if (numberOfCameras == 1) {
				return ;
			}

			currentCameraId++ ;
			if(currentCameraId >= numberOfCameras){
				currentCameraId = 0 ;
			}

			if (camera != null) {
				camera.stopPreview();
				cameraPreview.setCamera(null);
				camera.release();
				camera = null;
			}

			this.openCamera() ;
			cameraPreview.setCamera(camera);
			cameraPreview.startPreview();
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		//VeamUtil.log("debug","CameraActivity::onResume") ;
		if(camera == null){
			//VeamUtil.log("debug","camera == null") ;
			this.openCamera() ;
			cameraPreview.setCamera(camera);
			cameraPreview.startPreview() ;
		}
	}

	@Override
	protected void onPause() {
		super.onPause();
		//VeamUtil.log("debug","CameraActivity::onPause") ;
		// カメラ破棄インスタンスを解放
		if (camera != null) {
			camera.stopPreview();
			cameraPreview.setCamera(null);
			camera.release();
			camera = null;
		}
	}

	public Bitmap cropImage(byte[] data,int sampleSize){

		Bitmap targetBitmap = null ;

		Bitmap bitmap = null ;
		Bitmap rotatedBitmap = null ;

		try {
			BitmapFactory.Options options = new BitmapFactory.Options() ;
			options.inSampleSize  = sampleSize ;
			options.inJustDecodeBounds = false ;
			options.inPurgeable = true ;

			bitmap = BitmapFactory.decodeByteArray(data, 0, data.length, options) ;

			if(currentDegrees == 270){
				try {
					Matrix matrix = new Matrix();
					matrix.preScale(-1, -1);
					Bitmap flip = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, false) ;

					bitmap.recycle() ;
					bitmap = null ;

					bitmap = flip ;

				} catch (Exception e){

				}
			}
			//VeamUtil.log("debug","decoded") ;

			data = null ;

			int width = bitmap.getWidth() ;
			int height = bitmap.getHeight() ;

			//VeamUtil.log("debug","decoded width:"+width + " height:"+height) ;

			float scale = (float)VeamUtil.FORUM_PICTURE_SIZE / height ;

			CameraInfo info = new CameraInfo() ;
			Camera.getCameraInfo(this.currentCameraId, info) ;
			int targetRotation ;
			if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
				targetRotation = -90 ;
			} else {  // back-facing
				targetRotation = 90 ;
			}
			//VeamUtil.log("debug","rotaion:"+targetRotation) ;

			Matrix matrix ;
			matrix = new Matrix() ;
			matrix.setRotate(targetRotation) ;
			rotatedBitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, true) ;
			//VeamUtil.log("debug","rotated") ;
			bitmap.recycle() ;
			bitmap = null ;

			matrix = new Matrix() ;
			matrix.setScale(scale, scale) ;
			Bitmap squareBitmap = Bitmap.createBitmap(rotatedBitmap, 0, 0, height, height, matrix, true) ;
			//VeamUtil.log("debug","square width:"+squareBitmap.getWidth()) ;
			//VeamUtil.log("debug","squared") ;
			rotatedBitmap.recycle() ;
			rotatedBitmap = null ;

			targetBitmap = squareBitmap ;

		} catch (OutOfMemoryError e) {
			//VeamUtil.log("debug","OutOfMemory") ;
		}

		try {
			if(bitmap != null){
				bitmap.recycle() ;
				bitmap = null ;
			}

			if(rotatedBitmap != null){
				rotatedBitmap.recycle() ;
				rotatedBitmap = null ;
			}
		} catch(Exception e){
			e.printStackTrace() ;
		}


		return targetBitmap ;
	}

	@Override
	public void onPictureTaken(byte[] data, Camera targetCamera) {
		//VeamUtil.log("debug","onPictureTaken length:"+data.length) ;

		Bitmap targetBitmap = null ;
		int sampleSize = 1 ;

		// まず適切なサンプルサイズを計算
		try {
			BitmapFactory.Options options = new BitmapFactory.Options() ;
			options.inJustDecodeBounds = true ;
			BitmapFactory.decodeByteArray(data, 0, data.length, options) ;
			int width = options.outWidth ;
			int height = options.outHeight ;
			//VeamUtil.log("debug","inJustDecodeBounds w:"+width + " h:"+height) ;

			float scale = 1.0f ;
			if(width < height){
				scale = width / (float)VeamUtil.FORUM_PICTURE_SIZE ;
			} else {
				scale = height / (float)VeamUtil.FORUM_PICTURE_SIZE ;
			}

			sampleSize = (int)scale ;

		} catch (OutOfMemoryError e) {
			//VeamUtil.log("debug","OutOfMemory") ;
		}

		if(sampleSize < 1){
			sampleSize = 1 ;
		}

		while((targetBitmap == null) && (sampleSize <= 16)){
			targetBitmap = this.cropImage(data, sampleSize) ;
			//VeamUtil.log("debug","crop done sample size : " + sampleSize) ;
			sampleSize *= 2 ;
		}

		this.showImageEditActivity(targetBitmap) ;

	}

	public void showImageEditActivity(Bitmap targetBitmap){
		if(targetBitmap != null){
			//VeamUtil.log("debug","showImageEditActivity width:"+targetBitmap.getWidth()) ;
			String result = null ;
			if(result == null){
				// 自前で保存する
				File file = new File(this.prepareTmpFile()) ;
				try {
					if(file.exists()){
						file.delete() ;
					}
					if(file.createNewFile()){
						FileOutputStream fos = new FileOutputStream(file) ;
						targetBitmap.compress(Bitmap.CompressFormat.JPEG, 90, fos) ;
						fos.close() ;
						result = "file://" + file.getPath() ;
					} else {
						//VeamUtil.log("debug","could not create new file") ;
					}
				} catch (FileNotFoundException e) {
					e.printStackTrace() ;
				} catch (IOException e) {
					e.printStackTrace() ;
				}
			}

			if(result == null){
				// 自前保存に失敗したら、MediaStoreにまかせてみる
				result = MediaStore.Images.Media.insertImage(this.getContentResolver(), targetBitmap, "veam_picture", null) ;
			}
			targetBitmap.recycle() ;
			targetBitmap = null ;
			//VeamUtil.log("debug","stored") ;
			//VeamUtil.log("debug","resulit="+result) ;
			if(result != null){
				Intent imageEditIntent = new Intent(this, ImageEditActivity.class);
				imageEditIntent.putExtra("url", result);
				imageEditIntent.putExtra("forum_id", forumId) ;
				startActivityForResult(imageEditIntent,REQUEST_CODE_IMAGE_EDIT_ACTIVITY) ;
				overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out) ;
			} else {
				VeamUtil.showMessage(this,this.getString(R.string.external_storage_unavailable)) ;
			}
			//VeamUtil.log("debug","resulit="+result) ;
		} else {
			VeamUtil.showMessage(this, this.getString(R.string.out_of_memory)) ;
		}
	}

	@Override
	public void onAutoFocus(boolean success, Camera camera) {
		if(!takenPicture){
			takenPicture = true ;
			camera.takePicture(null, null, this) ;
		}
	}

	private void clearTmpFile(){
		String dirPath = Environment.getExternalStorageDirectory().getPath() + "/" + getString(R.string.app_name) ;

		FilenameFilter filter = new FilenameFilter() {
			/* ここに条件を書く。trueの場合、そのファイルは選択される */
			public boolean accept(File dir, String name) {
				if (name.startsWith("tmp") && name.endsWith(".jpg")) {
					return true;
				} else {
					return false;
				}
			}
		};
		File dir = new File(dirPath) ;
		if(!dir.exists()){
			if(!dir.mkdirs()){
				// ディレクトリ作れなかった
			}
		}

		File[] files = dir.listFiles(filter) ;
		for (int i = 0; i < files.length; i++) {
			File file = files[i] ;
			file.delete() ;
			MediaScannerConnection.scanFile(this, new String[]{file.getAbsolutePath()}, null, null);
		}
	}

	private String prepareTmpFile(){
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		Date date = new Date();
		String dateString = dateFormat.format(date);
		String filename = String.format("tmp%s.jpg",dateString) ;
		String dirPath = Environment.getExternalStorageDirectory().getPath() + "/" + getString(R.string.app_name) ;

		File dir = new File(dirPath) ;
		if(!dir.exists()){
			if(!dir.mkdirs()){
				// ディレクトリ作れなかった
			}
		}

		this.clearTmpFile() ;

		return dirPath+"/"+filename ;
	}

	private Uri pickedFileUri ;
	protected void onActivityResult(int requestCode, int resultCode,Intent data) {
		//VeamUtil.log("debug","CameraActivity::onActivityResult resultCode:"+resultCode) ;
		if(requestCode == REQUEST_CODE_GALLERY){
			if (resultCode == RESULT_OK) {
				//VeamUtil.log("debug","REQUEST_CODE_GALLERY RESULT_OK") ;
				//　適当に保存するところ作る
            	/*
                String filename = "tmp.jpg" ;
                String dirPath = Environment.getExternalStorageDirectory().getPath() + "/" + getString(R.string.app_name) ;

                File dir = new File(dirPath);
                if(!dir.exists()){
                    if(!dir.mkdirs()){
                        // ディレクトリ作れなかった
                    }
                }
                */

				// 先にファイルを用意しておいて、トリミングさんにそこに保存してくれるように頼む
				File pickedFile = new File(this.prepareTmpFile());

				pickedFileUri = Uri.fromFile(pickedFile) ;
				//VeamUtil.log("debug","picked file uri : " + pickedFileUri.getPath()) ;

				Uri targetUri = data.getData() ;
				if(VeamUtil.isDocumentUri(this, targetUri)){
					//VeamUtil.log("debug","this is a document url") ;
					Uri readableUri = VeamUtil.getReadableUri(this, targetUri) ;
					if(readableUri != null){
						targetUri = readableUri ;
					}
				}

				Intent intent = new Intent("com.android.camera.action.CROP");
				intent.setData(targetUri);
				intent.putExtra("outputX", VeamUtil.FORUM_PICTURE_SIZE);
				intent.putExtra("outputY", VeamUtil.FORUM_PICTURE_SIZE);
				intent.putExtra("aspectX", 1);
				intent.putExtra("aspectY", 1);
				intent.putExtra("scale", true);
				//intent.putExtra("return-data", true);
				intent.putExtra(MediaStore.EXTRA_OUTPUT, pickedFileUri);

				List<ResolveInfo> list = getPackageManager().queryIntentActivities(intent, 0);

				int size = list.size();

				if (size == 0) {
					//VeamUtil.log("debug","No Crop Action") ;
				} else {
					//VeamUtil.log("debug", "Crop Actions");
					for (ResolveInfo resolveInfo : list) {
						//VeamUtil.log("debug", " packageName=" + resolveInfo.activityInfo.packageName + " name=" + resolveInfo.activityInfo.name);
						if(resolveInfo.activityInfo.packageName.equals("com.google.android.apps.photos")) {
							//VeamUtil.log("debug", "set class");
							intent.setClassName(resolveInfo.activityInfo.packageName,resolveInfo.activityInfo.name) ;
							break ;
						}
					}
				}

				try {
					startActivityForResult(intent, REQUEST_CODE_CROP);
				} catch (ActivityNotFoundException e) {
					VeamUtil.showMessage(this, "Your device doesn't support the crop action") ;
				}
			}
		} else if(requestCode == REQUEST_CODE_CROP){
			if (resultCode == RESULT_OK) {
				Intent imageEditIntent = new Intent(this, ImageEditActivity.class);
				imageEditIntent.putExtra("url","file://" + pickedFileUri.getPath());
				imageEditIntent.putExtra("forum_id", forumId) ;
				startActivityForResult(imageEditIntent,REQUEST_CODE_IMAGE_EDIT_ACTIVITY) ;
				overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out) ;

/*
            	Bundle ext = data.getExtras();
            	if (ext != null) {
            		Bitmap targetBitmap = ext.getParcelable("data");
            		targetBitmap.setDensity(100) ;
            		this.showImageEditActivity(targetBitmap) ;
            	}
            	*/
			}
		} else if(requestCode == REQUEST_CODE_IMAGE_EDIT_ACTIVITY){
			if(resultCode == 1){
				this.setResult(1) ;
				this.finish() ;
			}
		}
	}

}
