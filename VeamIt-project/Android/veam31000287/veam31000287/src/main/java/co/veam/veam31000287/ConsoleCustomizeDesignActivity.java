package co.veam.veam31000287;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.graphics.Color;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.io.File;
import java.io.FilenameFilter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by veam on 11/16/16.
 */
public class ConsoleCustomizeDesignActivity extends ConsoleActivity {

    private TextView titleLabel ;
    private TextView descriptionLabel ;
    private ImageView mainImageView ;
    private int mainImageViewX ;
    private int mainImageViewY ;
    private ImageView animationImageView ;
    private ImageView submitImageView ;
    private ImageView nextImageView ;
    private ImageView prevImageView ;
    private ImageView[] dotImageViews ;
    private String[] elementTitles ;
    private String[] elementDescriptions ;
    private int currentIndex ;
    private int numberOfElements ;
    private String imageFileNameFormat = "c_custom_design_%d" ;

    private String selectedColorString ;

    final private int REQUEST_CODE_GALLERY = 10;
    final private int REQUEST_CODE_CROP = 11;
    final private int REQUEST_CODE_IMAGE_EDIT_ACTIVITY = 12;

    final private int INDEX_SPLASH = 0 ;
    final private int INDEX_COLOR = 1 ;
    final private int INDEX_ICON = 2 ;
    final private int INDEX_YOUTUBE = 3 ;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        String[] workElementTitles = {
                getString(R.string.customize_design_title_1),
                getString(R.string.customize_design_title_2),
                getString(R.string.customize_design_title_3),
                getString(R.string.customize_design_title_4),
        } ;
        elementTitles = workElementTitles ;

        String[] workElementDescriptions = {
                getString(R.string.customize_design_description_1),
                getString(R.string.customize_design_description_2),
                getString(R.string.customize_design_description_3),
                getString(R.string.customize_design_description_4),
        } ;
        elementDescriptions = workElementDescriptions ;

        numberOfElements = elementTitles.length ;

        currentIndex = 0 ;
        int currentY = deviceHeight * 15 / 100 ;
        String startImageFileName = String.format(imageFileNameFormat,1) ;

        mainImageView = new ImageView(this) ;
        mainImageView.setImageResource(VeamUtil.getDrawableId(this,startImageFileName));
        mainImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        int imageWidth = deviceWidth * 71 / 100 ;
        int imageHeight = deviceHeight * 65 / 100 ;
        int prevImageY = currentY + imageHeight / 2 ;
        mainImageViewX = (deviceWidth-imageWidth) / 2 ;
        mainImageViewY = currentY ;
        mainView.addView(mainImageView,ConsoleUtil.getRelativeLayoutPrams(mainImageViewX,currentY,imageWidth,imageHeight));
        currentY += imageHeight ;

        animationImageView = new ImageView(this) ;
        animationImageView.setImageResource(VeamUtil.getDrawableId(this, String.format(imageFileNameFormat, 2)));
        animationImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        //animationImageView.setVisibility(View.GONE);
        mainView.addView(animationImageView,ConsoleUtil.getRelativeLayoutPrams(mainImageViewX,mainImageViewY,imageWidth,imageHeight));

        int submitImageWidth = deviceWidth * 60 / 320 ;
        int submitImageHeight = submitImageWidth ;
        submitImageView = new ImageView(this) ;
        submitImageView.setImageResource(R.drawable.c_update);
        submitImageView.setOnClickListener(this) ;
        mainView.addView(submitImageView, ConsoleUtil.getRelativeLayoutPrams(deviceWidth * 200 / 320, deviceHeight * 10 / 100, submitImageWidth, submitImageHeight));

        int prevImageSize = deviceWidth * 50 / 320 ;
        prevImageY -= prevImageSize ;

        prevImageView = new ImageView(this) ;
        prevImageView.setImageResource(R.drawable.c_prev);
        prevImageView.setOnClickListener(this);
        prevImageView.setVisibility(View.VISIBLE);
        mainView.addView(prevImageView,ConsoleUtil.getRelativeLayoutPrams(0,prevImageY,prevImageSize,prevImageSize));

        nextImageView = new ImageView(this) ;
        nextImageView.setImageResource(R.drawable.c_next);
        nextImageView.setOnClickListener(this);
        nextImageView.setVisibility(View.VISIBLE);
        mainView.addView(nextImageView,ConsoleUtil.getRelativeLayoutPrams(deviceWidth-prevImageSize,prevImageY,prevImageSize,prevImageSize));

        int labelHeight = deviceHeight * 4 / 100 ;
        titleLabel = new TextView(this) ;///
        titleLabel.setTextColor(Color.RED) ;
        //titleLabel.setBackgroundColor(Color.BLACK);
        titleLabel.setText("Title");
        titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        titleLabel.setTextSize((float) deviceWidth * 3.5f / 100 / scaledDensity);
        titleLabel.setGravity(Gravity.CENTER);
        mainView.addView(titleLabel,ConsoleUtil.getRelativeLayoutPrams(0,currentY,deviceWidth,labelHeight));
        currentY += labelHeight ;

        descriptionLabel = new TextView(this) ;///
        descriptionLabel.setTextColor(Color.BLACK) ;
        //descriptionLabel.setBackgroundColor(Color.RED);
        descriptionLabel.setText("Size : 640 x 1136 px (Portrait)");
        descriptionLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        descriptionLabel.setTextSize((float) deviceWidth * 3.0f / 100 / scaledDensity);
        descriptionLabel.setGravity(Gravity.CENTER);
        mainView.addView(descriptionLabel, ConsoleUtil.getRelativeLayoutPrams(0, currentY, deviceWidth, labelHeight));
        currentY += labelHeight ;


        currentY += deviceHeight * 1 / 100 ;
        dotImageViews = new ImageView[numberOfElements] ;
        if(numberOfElements > 1){
            int imageSize = deviceWidth * 1 / 100 ;
            int imageGap = deviceWidth * 1 / 100 ;
            int currentX = (deviceWidth / 2) - ((numberOfElements - 1) * (imageSize + imageGap) / 2) ;
            for(int index = 0 ; index < numberOfElements ; index++){
                //NSLog(@"dot x=%f",currentX) ;
                dotImageViews[index] = new ImageView(this) ;
                mainView.addView(dotImageViews[index],ConsoleUtil.getRelativeLayoutPrams(currentX,currentY,imageSize,imageSize));
                currentX += imageSize + imageGap ;
            }
        }

        this.setMainImage() ;

        /*

        backgroundImageInputBarView = [self addImageInputBar:@"Background" y:0 fullBottomLine:NO
        displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_BACKGROUND_IMAGE] ;
        [backgroundImageInputBarView setAlpha:0.0] ;

        iconImageInputBarView = [self addImageInputBar:@"Icon" y:0 fullBottomLine:NO
        displayWidth:300 displayHeight:300 cropWidth:1024 cropHeight:1024 resizableCropArea:NO tag:CONSOLE_VIEW_ICON_IMAGE] ;
        [iconImageInputBarView setAlpha:0.0] ;

        youtubeImageInputBarView = [self addImageInputBar:@"Youtube" y:0 fullBottomLine:NO
        displayWidth:300 displayHeight:300 cropWidth:1024 cropHeight:1024 resizableCropArea:NO tag:CONSOLE_VIEW_YOUTUBE_IMAGE] ;
        [youtubeImageInputBarView setAlpha:0.0] ;
        */

        /*
        ConsoleChangePaymentAdapter adapter = new ConsoleChangePaymentAdapter(deviceWidth,scaledDensity) ;
        this.addMainList(adapter);
        */
    }

    public void setMainImage(){
        String title = elementTitles[currentIndex] ;
        String description = elementDescriptions[currentIndex] ;
        titleLabel.setText(title) ;
        descriptionLabel.setText(description) ;

        String imageFileName = String.format(imageFileNameFormat,currentIndex+1) ;
        mainImageView.setImageResource(VeamUtil.getDrawableId(this,imageFileName));

        if(currentIndex == 0){
            prevImageView.setVisibility(View.GONE);
        } else {
            prevImageView.setVisibility(View.VISIBLE);
        }

        if(currentIndex < numberOfElements - 1){
            nextImageView.setVisibility(View.VISIBLE);
        } else {
            nextImageView.setVisibility(View.GONE);
        }

        if(numberOfElements > 1){
            for(int index = 0 ; index < numberOfElements ; index++){
                ImageView imageView = dotImageViews[index] ;
                if(index == currentIndex){
                    imageView.setImageResource(VeamUtil.getDrawableId(this,"c_top_dot_on"));
                } else {
                    imageView.setImageResource(VeamUtil.getDrawableId(this,"c_top_dot_off"));
                }
            }
        }

        this.doTranslateAnimation(mainImageView, 0, 0, 0, 0, 0, null, null);
        this.doTranslateAnimation(animationImageView, 0, deviceWidth, deviceWidth, 0, 0, null, null);
    }

    public void doAnimationWithDirection(int direction){
        final int finalDirection = direction ;
        handler.post(new Runnable() {
            public void run() {
                VeamUtil.log("debug", "startanimation ");
                if (finalDirection < 0) {
                    doTranslateAnimation(mainImageView, 500, 0, deviceWidth, 0, 0, "setMainImage", null);
                    doTranslateAnimation(animationImageView, 500, -deviceWidth, 0, 0, 0, null, null);
                } else {
                    doTranslateAnimation(mainImageView, 500, 0, -deviceWidth, 0, 0, "setMainImage", null);
                    doTranslateAnimation(animationImageView, 500, deviceWidth, 0, 0, 0, null, null);
                }

            }
        });

    }

    @Override
    public void onClick(View view) {
        super.onClick(view);
        VeamUtil.log("debug", "ConsoleCustomizeDesignActivity::onClick ") ;
        if(view == prevImageView){
            VeamUtil.log("debug", "prevImageView ") ;
            if(currentIndex > 0){
                currentIndex-- ;
                handler.post(new Runnable() {
                    public void run() {
                        VeamUtil.log("debug", "set animationImageView " + currentIndex) ;
                        animationImageView.setImageResource(VeamUtil.getDrawableId(ConsoleCustomizeDesignActivity.this, String.format(imageFileNameFormat, currentIndex+1)));
                    }
                });
                this.doAnimationWithDirection(-1) ;
            }
        } else if(view == nextImageView){
            VeamUtil.log("debug", "nextImageView ") ;
            if(currentIndex < (numberOfElements-1)){
                currentIndex++ ;
                handler.post(new Runnable() {
                    public void run() {
                        VeamUtil.log("debug", "set animationImageView " + currentIndex) ;
                        animationImageView.setImageResource(VeamUtil.getDrawableId(ConsoleCustomizeDesignActivity.this, String.format(imageFileNameFormat, currentIndex+1)));
                    }
                });
                this.doAnimationWithDirection(1) ;
            }
        } else if(view == submitImageView){
            if(currentIndex == INDEX_SPLASH) { // Splash
                launchImageSelector();
            } else if(currentIndex == INDEX_COLOR) { // Color
                ColorPickerDialog mColorPickerDialog;
                mColorPickerDialog = new ColorPickerDialog(this,
                        new ColorPickerDialog.OnColorChangedListener() {
                            @Override
                            public void colorChanged(int color) {
                                selectedColorString = String.format("%08X", color) ;
                                sendConceptColor();
                            }
                        },
                        Color.BLACK
                );

                mColorPickerDialog.show();
            } else if(currentIndex == INDEX_ICON) { // Icon
                launchImageSelector();
            } else if(currentIndex == INDEX_YOUTUBE) { // Youtube
                launchImageSelector();
            }
        }
    }

    public void launchImageSelector(){
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

    private Uri pickedFileUri ;
    protected void onActivityResult(int requestCode, int resultCode,Intent data) {
        VeamUtil.log("debug","ConsoleCustomizeDesignActivity::onActivityResult resultCode:"+resultCode) ;
        if(requestCode == REQUEST_CODE_GALLERY){
            if (resultCode == RESULT_OK) {
                VeamUtil.log("debug", "REQUEST_CODE_GALLERY RESULT_OK") ;

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
                if((currentIndex == INDEX_ICON) || (currentIndex == INDEX_YOUTUBE)) {
                    intent.putExtra("outputX", 1024);
                    intent.putExtra("outputY", 1024);
                    intent.putExtra("aspectX", 1);
                    intent.putExtra("aspectY", 1);
                } else if(currentIndex == INDEX_SPLASH){
                    intent.putExtra("outputX", 640);
                    intent.putExtra("outputY", 1136);
                    intent.putExtra("aspectX", 640);
                    intent.putExtra("aspectY", 1136);
                }
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
                String imagePath = pickedFileUri.getPath();
                VeamUtil.log("debug","image uri = "+ imagePath) ;
                if(currentIndex == INDEX_SPLASH) {
                    sendSplashImage(imagePath);
                } else if(currentIndex == INDEX_ICON) {
                    sendIconImage(imagePath);
                } else if(currentIndex == INDEX_YOUTUBE){
                    sendYoutubeImage(imagePath) ;
                }
            }
        }
    }


    public void sendConceptColor(){
        showFullscreenProgress(); ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.setConceptColor(selectedColorString);
    }

    public void sendIconImage(String imageUri){
        showFullscreenProgress(); ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.setAppIconImage(imageUri);
    }

    public void sendYoutubeImage(String imagePath){
        showFullscreenProgress(); ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.setTemplateYoutubeRightImage(imagePath);
    }

    public void sendSplashImage(String imagePath){
        showFullscreenProgress(); ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        //consoleContents.setAppSplashImage(imagePath);
        consoleContents.setAppCustomBackgroundImage(imagePath);
    }

    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "ConsoleActivity::onConsoleDataPostDone " + apiName) ;
        hideFullscreenProgress() ;
        if( apiName.equals("app/setconceptcolor") ||
                apiName.equals("app/seticonimage") ||
                apiName.equals("app/setcustombackgroundimage") ||
            apiName.equals("youtube/setrightimage")) {
            backToPreviewHomeScreen();
        }
    }

    @Override
    public void onConsoleDataPostFailed(String apiName){
        VeamUtil.log("debug", "ConsoleActivity::onConsoleDataPostFailed " + apiName) ;
        VeamUtil.showMessage(this,"Failed to send data");
        hideFullscreenProgress() ;
    }



}
