package co.veam.veam31000287;

import java.io.FileNotFoundException;
import java.io.IOException;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ImageView.ScaleType;
import android.widget.RelativeLayout;

public class ImageEditActivity extends VeamActivity {
	// カメラインスタンス
    private RelativeLayout mainView ;
	private RelativeLayout rootLayout ;
	private ImageView pictureImageView ;
	private String url ;
	private String forumId ;
	private Bitmap pictureBitmap = null ;
	
	private int VIEWID_ROTATE_BUTTON		= 0x10001 ;
	private int VIEWID_NEXT_BUTTON			= 0x10002 ;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_image_edit) ;
        
		this.pageName = "ImageEdit" ;
        
		RelativeLayout.LayoutParams layoutParams ;
		rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;

		mainView = this.addMainView(rootLayout,View.VISIBLE) ;
		mainView.setBackgroundColor(Color.rgb(0x22, 0x22, 0x22)) ;

		
		int bottomHeight = deviceWidth*25/100;

		int imageSize = deviceWidth*98/100 ;
		
		int space = (this.viewHeight - this.topBarHeight - bottomHeight - imageSize) ;
		if(space < 0){
			imageSize = this.viewHeight - this.topBarHeight - bottomHeight ;
			space = 0 ;
		}
		
		Intent intent = getIntent();
		url = intent.getStringExtra("url") ;
		forumId = intent.getStringExtra("forum_id") ;
		Uri uri = Uri.parse(url) ;
		try {
			pictureBitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), uri) ;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		int imageY = topBarHeight + space / 2 ;
        pictureImageView = new ImageView(this) ;
        if(pictureBitmap != null){
        	pictureImageView.setImageBitmap(pictureBitmap) ;
        }
		layoutParams = createParam(imageSize, imageSize) ;
		layoutParams.setMargins((deviceWidth-imageSize)/2,imageY,0,0) ;
		mainView.addView(pictureImageView,layoutParams) ;
		
		this.addTopBar(mainView,this.getString(R.string.edit),true,false) ;
		
		TextView textView = new TextView(this) ;
		textView.setOnClickListener(this) ;
		textView.setId(VIEWID_NEXT_BUTTON) ;
		textView.setText(this.getString(R.string.next)) ;
		textView.setTextColor(VeamUtil.getLinkTextColor(this)) ;
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)deviceWidth * 5.3f / 100 / scaledDensity) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(deviceWidth*16/100,topBarHeight) ;
		relativeLayoutParams.setMargins(deviceWidth*84/100, 0, 0, 0) ;
		mainView.addView(textView, relativeLayoutParams) ;

		

		
		int maskY = imageY+imageSize ;
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

		int rotateWidth = deviceWidth * 24 / 100 ;
		int rotateHeight = deviceWidth * 21 / 100 ;
		ImageView rotateImageView = new ImageView(this) ;
		rotateImageView.setId(VIEWID_ROTATE_BUTTON) ;
		rotateImageView.setOnClickListener(this) ;
		rotateImageView.setImageResource(R.drawable.rotate) ;
		rotateImageView.setScaleType(ScaleType.FIT_XY) ;
		layoutParams = createParam(rotateWidth, rotateHeight) ;
		layoutParams.setMargins(deviceWidth*40/100,viewHeight-deviceWidth*23/100,0,0) ;
		mainView.addView(rotateImageView,layoutParams) ;
    }
    
	@Override
	public void onClick(View view) {
		super.onClick(view) ;
		//VeamUtil.log("debug","ImageEditActivity::onClick") ;
		if(view.getId() == this.VIEWID_TOP_BAR_BACK_BUTTON){
			//VeamUtil.log("debug","back button tapped") ;
			this.finish() ;
			overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out) ;
		} else 	if(view.getId() == VIEWID_ROTATE_BUTTON){
			//VeamUtil.log("debug","rotate button tapped") ;
			Matrix matrix = new Matrix() ;
			matrix.setRotate(-90) ;
			try {
				Bitmap newPictureBitmap = Bitmap.createBitmap(pictureBitmap, 0, 0, pictureBitmap.getWidth(), pictureBitmap.getHeight(), matrix, true) ;
				pictureImageView.setImageBitmap(newPictureBitmap) ;
				pictureBitmap.recycle() ;
				pictureBitmap = newPictureBitmap ;
			} catch (OutOfMemoryError e) {
				//VeamUtil.log("debug","OutOfMemory") ;
			}
			
		} else 	if(view.getId() == VIEWID_NEXT_BUTTON){
			//VeamUtil.storeBitmap(this, "ImageShareActivity", pictureBitmap,Bitmap.CompressFormat.PNG,100) ;
			VeamUtil.storeBitmap(this, "ImageShareActivity", pictureBitmap,Bitmap.CompressFormat.JPEG,95) ;
			Intent imageShareIntent = new Intent(this, ImageShareActivity.class) ;
			imageShareIntent.putExtra("forum_id", forumId) ;
			startActivityForResult(imageShareIntent,1) ;
			overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out) ;
		}
	}

    @Override
    protected void onPause() {
        super.onPause();
    }
    
    protected void onActivityResult(int requestCode, int resultCode,Intent data) {
    	//VeamUtil.log("debug","ImageEditActivity::onActivityResult requestCode:"+requestCode + " resultCode:"+resultCode) ;
    	if(resultCode == 1){
    		this.setResult(1) ;
    		this.finish() ;
    	}
    }



}