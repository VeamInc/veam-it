package co.veam.veam31000287;

import java.io.IOException;

import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.Size;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;


public class CameraPreview extends SurfaceView implements SurfaceHolder.Callback {

    private Camera camera;

    /**
     * コンストラクタ
     */
    public CameraPreview(Context context, Camera camera) {
        super(context);

        this.camera = camera;

        // サーフェスホルダーの取得とコールバック通知先の設定
        SurfaceHolder holder = getHolder();
        holder.addCallback(this);
        holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
    }
    
    public void setCamera(Camera camera){
    	this.camera = camera ;
    }
    
    public void startPreview(){
        try {
            SurfaceHolder holder = getHolder();
            //holder.addCallback(this);
            //holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
            // カメラインスタンスに、画像表示先を設定
        	camera.setPreviewDisplay(holder);
            // プレビュー開始
        	camera.startPreview();
        } catch (IOException e) {
            //
        }
    }

    /**
     * SurfaceView 生成
     */
    public void surfaceCreated(SurfaceHolder holder) {
        try {
        	if(camera != null){
	            // カメラインスタンスに、画像表示先を設定
	        	camera.setPreviewDisplay(holder);
	            // プレビュー開始
	        	camera.startPreview();
        	}
        } catch (IOException e) {
            //
        }
    }

    /**
     * SurfaceView 破棄
     */
    public void surfaceDestroyed(SurfaceHolder holder) {
    }

    /**
     * SurfaceHolder が変化したときのイベント
     */
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        // 画面回転に対応する場合は、ここでプレビューを停止し、
        // 回転による処理を実施、再度プレビューを開始する。
    	
    	/*    	
    	camera.stopPreview();
        Camera.Parameters cameraParams = camera.getParameters();
        Size previewSize = cameraParams.getPreviewSize() ;

    	//VeamUtil.log("debug","surfaceChanged w:" + width + " h:" + height + " preview w:" + previewSize.width + " h:" + previewSize.height) ;

        cameraParams.setRotation(90);
        cameraParams.setPreviewSize(height, width);// here w h are reversed
        camera.setParameters(cameraParams);
        camera.startPreview();
        */
    }
}