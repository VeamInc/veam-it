package co.veam.veam31000287;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.RectF;
import android.hardware.Camera;
import android.media.CamcorderProfile;
import android.media.MediaRecorder;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by veam on 12/8/16.
 */
public class ConsoleTakeSnapActivity extends VeamActivity implements View.OnTouchListener, MediaRecorder.OnInfoListener {
    // カメラインスタンス
    private Camera camera = null;
    private CameraPreview cameraPreview = null;
    private int numberOfCameras ;
    private RelativeLayout mainView ;
    private RelativeLayout rootLayout ;
    private int currentCameraId ;
    private String mixedId ;
    private String videoCategoryId ;
    private String sellSectionCategoryId ;
    private boolean takenPicture ;
    private boolean hasAutoFocus = false ;
    private boolean shooting ;
    private int cameraY ;
    private int cameraSize ;

    private int uploadKind ;

    private MediaRecorder mediaRecorder ;

    private int currentVideoWidth ;
    private int currentVideoHeight ;

    private int currentDegrees = 0 ;
    private int currentRecordDegrees = 0 ;

    final private int REQUEST_CODE_GALLERY = 10;
    final private int REQUEST_CODE_CROP = 11;
    final private int REQUEST_CODE_IMAGE_EDIT_ACTIVITY = 12;

    private int VIEWID_CANCEL_TEXT		= 0x10001 ;
    private int VIEWID_SELECT_TEXT		= 0x10002 ;
    private int VIEWID_SHUTTER_BUTTON	= 0x10003 ;
    private int VIEWID_SWITCH_BUTTON	= 0x10004 ;

    private String currentFilePath ;

    protected Handler handler = null ;
    //ImageView shutterImageView ;
    CircleView redCircleView ;
    CircleView grayCircleView ;
    CircleView whiteCircleView ;
    CircleView progressCircleView ;
    private long recordStartTime ;
    Timer timer ;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_snap_camera);

        handler = new Handler();

        Intent intent = getIntent();
        mixedId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_MIXED_ID) ;
        videoCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_VIDEOCATEGORY_ID) ;
        sellSectionCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID) ;
        uploadKind = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND,0) ;
        VeamUtil.log("debug","ConsoleTakeSnapActivity::mixedId="+mixedId + " uploadKind="+uploadKind) ;

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

        int bottomHeight = deviceWidth*35/100;

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
        Camera.Size pictureSize = cameraParams.getPreviewSize() ;
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
        mainView.addView(bottomBackView, layoutParams) ;

        int shutterSize = deviceWidth * 30 / 100 ;
        int redSize = shutterSize * 70 / 100 ;
        int shutterX = (deviceWidth - shutterSize) / 2 ;
        int shutterY = (viewHeight - bottomHeight) + (bottomHeight - shutterSize) / 2 ;

        int strokeWidth = deviceWidth*15/1000 ;
        float margin = (float)strokeWidth / 2.0f ;

        grayCircleView = new CircleView(this) ;
        grayCircleView.setOval(new RectF(0.0f + margin, 0.0f + margin, shutterSize - margin, shutterSize - margin)) ;
        grayCircleView.setRevert(true);
        grayCircleView.setFill(true) ;
        grayCircleView.setStrokeWidth(strokeWidth);
        grayCircleView.setPercentage(1.0f) ;
        grayCircleView.setColor(VeamUtil.getColorFromArgbString("FF555555")) ;
        grayCircleView.setId(VIEWID_SHUTTER_BUTTON);
        grayCircleView.setOnTouchListener(this);
        mainView.addView(grayCircleView,ConsoleUtil.getRelativeLayoutPrams(shutterX,shutterY,shutterSize,shutterSize)) ;

        int redMargin = (shutterSize - redSize) / 2 ;
        redCircleView = new CircleView(this) ;
        redCircleView.setOval(new RectF(redMargin, redMargin, shutterSize-redMargin, shutterSize-redMargin)) ;
        redCircleView.setRevert(true);
        redCircleView.setFill(true) ;
        redCircleView.setStrokeWidth(strokeWidth);
        redCircleView.setPercentage(1.0f) ;
        redCircleView.setColor(VeamUtil.getColorFromArgbString("FFFF0000")) ;
        redCircleView.setVisibility(View.GONE);
        mainView.addView(redCircleView,ConsoleUtil.getRelativeLayoutPrams(shutterX,shutterY,shutterSize,shutterSize)) ;

        whiteCircleView = new CircleView(this) ;
        whiteCircleView.setOval(new RectF(0.0f+margin, 0.0f+margin, shutterSize-margin, shutterSize-margin)) ;
        whiteCircleView.setRevert(true);
        whiteCircleView.setFill(false) ;
        whiteCircleView.setStrokeWidth(strokeWidth);
        whiteCircleView.setPercentage(1.0f) ;
        whiteCircleView.setColor(VeamUtil.getColorFromArgbString("FFFFFFFF")) ;
        mainView.addView(whiteCircleView,ConsoleUtil.getRelativeLayoutPrams(shutterX,shutterY,shutterSize,shutterSize)) ;

        progressCircleView = new CircleView(this) ;
        progressCircleView.setOval(new RectF(0.0f+margin, 0.0f+margin, shutterSize-margin, shutterSize-margin)) ;
        progressCircleView.setRevert(true);
        progressCircleView.setFill(false) ;
        progressCircleView.setStrokeWidth(strokeWidth);
        progressCircleView.setPercentage(0.0f) ;
        progressCircleView.setColor(VeamUtil.getColorFromArgbString("FFFF0000")) ;
        mainView.addView(progressCircleView,ConsoleUtil.getRelativeLayoutPrams(shutterX,shutterY,shutterSize,shutterSize)) ;


        int switchWidth = deviceWidth * 13 / 100 ;
        int switchHeight = deviceWidth * 8 / 100 ;

        ImageView switchImageView = new ImageView(this) ;
        switchImageView.setId(VIEWID_SWITCH_BUTTON) ;
        switchImageView.setOnClickListener(this) ;
        switchImageView.setImageResource(R.drawable.change_camera) ;
        switchImageView.setScaleType(ImageView.ScaleType.FIT_XY) ;
        layoutParams = createParam(switchWidth, switchHeight) ;
        layoutParams.setMargins(deviceWidth*85/100,viewHeight-deviceWidth*165/1000,0,0) ;
        mainView.addView(switchImageView,layoutParams) ;

        /*
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
        */

    }

    public void shutterImageOn(){
        VeamUtil.log("debug","shutter on") ;
        handler.post(new Runnable() {
            public void run() {
                //shutterImageView.setImageResource(R.drawable.snap_record_on);
                redCircleView.setVisibility(View.VISIBLE);
            }
        });
    }

    public void shutterImageOff(){
        VeamUtil.log("debug","shutter off") ;
        handler.post(new Runnable() {
            public void run() {
                redCircleView.setVisibility(View.GONE);
                progressCircleView.setPercentage(0.0f) ;
            }
        });
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
            currentRecordDegrees = 270 ;
        } else {  // back-facing
            result = (info.orientation - degrees + 360) % 360 ;
            currentRecordDegrees = 90 ;
        }
        camera.setDisplayOrientation(result) ;

        currentDegrees = result ;
        VeamUtil.log("debug", "currentRecordDegrees = " + currentRecordDegrees) ;
    }


    private void setPreviewSize(Camera.Parameters cameraParams){
        Camera.Size pictureSize = cameraParams.getPictureSize() ;
        Camera.Size previewSize = cameraParams.getPreviewSize() ;
        float pictureRasio = (float)pictureSize.height / (float)pictureSize.width ; // 0.75 or 0.5625
        float previewRasio = (float)previewSize.height / (float)previewSize.width ; // 0.75 or 0.5625

        //VeamUtil.log("debug","picture w="+pictureSize.width+" h="+pictureSize.height+" r="+pictureRasio) ;
        //VeamUtil.log("debug","preview w="+previewSize.width+" h="+previewSize.height+" r="+previewRasio) ;

        if(pictureRasio != previewRasio){
            List<Camera.Size> supported = cameraParams.getSupportedPreviewSizes();
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
        VeamUtil.log("debug","openCamera") ;
        try {
            camera = Camera.open(currentCameraId) ;
            this.setCameraDisplayOrientation(currentCameraId,camera) ;
            //camera.setDisplayOrientation(90) ;


            if(cameraPreview != null){
                Camera.Parameters cameraParams = camera.getParameters() ;
                this.setPreviewSize(cameraParams) ;
                camera.setParameters(cameraParams);
                //Size pictureSize = cameraParams.getPictureSize() ;
                Camera.Size pictureSize = cameraParams.getPreviewSize() ;
                //VeamUtil.log("debug","open camera pictureSize:width=" + pictureSize.width + " height="+pictureSize.height) ;

                int rotatedWidth = pictureSize.height ;
                int rotatedHeight = pictureSize.width ;
                int cameraWidth = cameraSize ;
                int cameraHeight = rotatedHeight * cameraWidth / rotatedWidth ;
                RelativeLayout.LayoutParams layoutParams = createParam(cameraWidth, cameraHeight) ;
                layoutParams.setMargins((deviceWidth - cameraWidth) / 2, cameraY, 0, 0) ;
                //VeamUtil.log("debug","open camera camera:width=" + cameraWidth + " height="+cameraHeight) ;
                cameraPreview.setLayoutParams(layoutParams) ;

            }
        } catch (Exception e) {
            // エラー
            e.printStackTrace();
            this.finish();
        }
    }

    private void clearTmpFile(){
        String dirPath = Environment.getExternalStorageDirectory().getPath() + "/" + getString(R.string.app_name) ;

        FilenameFilter filter = new FilenameFilter() {
            /* ここに条件を書く。trueの場合、そのファイルは選択される */
            public boolean accept(File dir, String name) {
                if (name.startsWith("tmp") && name.endsWith(".3gp")) {
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
        String filename = String.format("tmp%s.3gp",dateString) ;
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


    @Override
    public void onClick(View view) {
        super.onClick(view) ;
        //VeamUtil.log("debug","CameraActivity::onClick") ;
        if((view.getId() == VIEWID_TOP_BAR_BACK_BUTTON) || (view.getId() == VIEWID_CANCEL_TEXT)){
            //VeamUtil.log("debug","back button tapped") ;
            this.finish() ;
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

    public void stopRecorder(){
        this.stopProgressCheck();
        if(mediaRecorder != null){
            mediaRecorder.stop();
            mediaRecorder.reset();
            mediaRecorder.release();
            mediaRecorder = null ;
            if(camera != null) {
                camera.lock();
            }
        }
    }

    public void launchSnapEditActivity(){
        if(currentFilePath != null){
            Intent intent = new Intent(this, ConsoleEditSnapActivity.class);
            intent.putExtra("FILE_PATH", currentFilePath);
            intent.putExtra("VIDEO_WIDTH", currentVideoHeight);
            intent.putExtra("VIDEO_HEIGHT", currentVideoWidth);

            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
            //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.done)) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_MIXED_ID,mixedId) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_VIDEOCATEGORY_ID,videoCategoryId) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID,sellSectionCategoryId) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND,uploadKind) ;

            startActivityForResult(intent,REQUEST_CODE_IMAGE_EDIT_ACTIVITY) ;
            overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out) ;
        } else {
            VeamUtil.showMessage(this, this.getString(R.string.out_of_memory)) ;
        }
    }

    protected void onActivityResult(int requestCode, int resultCode,Intent data) {
        //VeamUtil.log("debug","CameraActivity::onActivityResult resultCode:"+resultCode) ;
        if(requestCode == REQUEST_CODE_IMAGE_EDIT_ACTIVITY){
            if(resultCode == 1){
                this.setResult(1) ;
                this.finish() ;
            }
        }
    }

    @Override
    public boolean onTouch(View view, MotionEvent event) {
        boolean consume = false ;
        if(view.getId() == VIEWID_SHUTTER_BUTTON){
            VeamUtil.log("debug", "onTouch action=" + event.getAction());
            if(event.getAction() == MotionEvent.ACTION_DOWN) {
                VeamUtil.log("debug", "ACTION_DOWN");
                if (!shooting) {
                    try {
                        currentFilePath = this.prepareTmpFile();
                        mediaRecorder = new MediaRecorder();
                        //camera.lock();
                        camera.unlock();
                        mediaRecorder.setCamera(camera);
                        mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
                        mediaRecorder.setVideoSource(MediaRecorder.VideoSource.CAMERA);
                        mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
                        mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.DEFAULT);
                        mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.DEFAULT);
                        mediaRecorder.setMaxDuration(ConsoleUtil.VEAM_MAX_RECORD_TIME);
                        mediaRecorder.setOnInfoListener(this);

                        CamcorderProfile camcorderProfile = CamcorderProfile.get(currentCameraId, CamcorderProfile.QUALITY_480P);
                        currentVideoWidth = camcorderProfile.videoFrameWidth;
                        currentVideoHeight = camcorderProfile.videoFrameHeight;
                        mediaRecorder.setVideoSize(currentVideoWidth, currentVideoHeight);

                        mediaRecorder.setOutputFile(currentFilePath);
                        mediaRecorder.setOrientationHint(currentRecordDegrees);
                        mediaRecorder.prepare();
                        mediaRecorder.start();
                        shooting = true;
                        recordStartTime = System.currentTimeMillis();
                        startProgressCheck();
                        shutterImageOn() ;
                    } catch (IOException e) {
                        e.printStackTrace();
                        camera.lock();
                    }
                    consume = true ;
                }
            } else if(event.getAction() == MotionEvent.ACTION_UP){
                VeamUtil.log("debug", "ACTION_UP");
                if(shooting){
                    this.recordButtonReleased();
                    consume = true ;
                }
            }
        }

        return consume;
    }

    public void recordButtonReleased(){
        this.stopRecorder();
        shooting = false;
        shutterImageOff() ;
        long duration = System.currentTimeMillis() - recordStartTime ;
        VeamUtil.log("debug","duration="+duration) ;
        if(duration > 2000) {
            this.launchSnapEditActivity();
        }
    }

    @Override
    public void onInfo(MediaRecorder mr, int what, int extra) {
        if(what == MediaRecorder.MEDIA_RECORDER_INFO_MAX_DURATION_REACHED){
            this.recordButtonReleased();
        }
    }

    private void stopProgressCheck(){
        if(timer != null){
            timer.cancel() ;
            timer = null ;
        }
    }

    private void startProgressCheck(){
        this.stopProgressCheck() ;

        timer = new Timer(true);
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                // 再生時間表示
                //VeamUtil.log("debug","timer") ;
                handler.post(new Runnable() {
                    public void run() {
                        setCircleShadow();
                    }
                });
            }
        }, 0, 1000);

    }

    private void setCircleShadow() {
        long duration = System.currentTimeMillis() - recordStartTime ;

        float percentage = (float)duration / (float)ConsoleUtil.VEAM_MAX_RECORD_TIME ;
        if(percentage > 1.0f){
            percentage = 1.0f ;
        }
        progressCircleView.setPercentage(percentage) ;
    }
}
