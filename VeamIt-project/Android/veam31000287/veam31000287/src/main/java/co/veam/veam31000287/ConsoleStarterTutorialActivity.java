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
 * Created by veam on 12/14/16.
 */
public class ConsoleStarterTutorialActivity extends ConsoleActivity {

    private TextView titleLabel ;
    private TextView descriptionLabel ;
    private ImageView mainImageView ;
    private int mainImageViewX ;
    private int mainImageViewY ;
    private ImageView animationImageView ;
    private ImageView nextImageView ;
    private ImageView prevImageView ;
    private ImageView[] dotImageViews ;

    private String selectedColorString ;
    /*
    private String[] elementTitles ;
    private String[] elementDescriptions ;
    */
    private int currentIndex ;
    private int numberOfElements ;

    private int tutorialKind ;
    private ConsoleTutorialElement[] elements ;

    final private int REQUEST_CODE_GALLERY = 10;
    final private int REQUEST_CODE_CROP = 11;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = this.getIntent();
        tutorialKind = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND, 0) ;

        ConsoleTutorialElement[] workElements = {
                new ConsoleTutorialElement(
                        "1",
                        "Select color and photo",
                        "will be used in the apps.",
                        "start_tutorial_ss1",
                        ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED),

        } ;
        elements = workElements ;


        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        numberOfElements = elements.length ;

        currentIndex = 0 ;
        int currentY = deviceHeight * 15 / 100 ;
        String startImageFileName = elements[0].imageFileName ;

        int contentHeight = deviceHeight - ConsoleUtil.getStatusBarHeight() ;
        int imageHeight = contentHeight * 65 / 100 ;
        int imageWidth = imageHeight * 452 / 702 ;
        int imageWidthMax = deviceWidth * 71 / 100 ;
        if(imageWidth > imageWidthMax){
            imageWidth = imageWidthMax ;
            imageHeight = imageWidth * 702 / 452 ;
        }

        // tutorial_icon 62x54  y=11%,h=5%
        int iconImageHeight = contentHeight * 5 / 100 ;
        int iconImageWidth = iconImageHeight * 62 / 54 ;
        ImageView iconImageView = new ImageView(this) ;
        iconImageView.setImageResource(R.drawable.start_tutorial_icon);
        iconImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        mainView.addView(iconImageView,ConsoleUtil.getRelativeLayoutPrams((deviceWidth-iconImageWidth)/2,contentHeight*11/100,iconImageWidth,iconImageHeight));


        mainImageView = new ImageView(this) ;
        mainImageView.setImageResource(VeamUtil.getDrawableId(this,startImageFileName));
        mainImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        mainImageViewX = (deviceWidth-imageWidth) / 2 ;
        mainImageViewY = contentHeight - imageHeight ; ;
        int prevImageY = mainImageViewY + imageHeight / 2 ;
        mainView.addView(mainImageView,ConsoleUtil.getRelativeLayoutPrams(mainImageViewX,mainImageViewY,imageWidth,imageHeight));
        currentY += imageHeight ;

        String nextImageFileName = startImageFileName ;
        if(elements.length >= 2){
            nextImageFileName = elements[1].imageFileName ;
        }
        animationImageView = new ImageView(this) ;
        animationImageView.setImageResource(VeamUtil.getDrawableId(this, nextImageFileName));
        animationImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        mainView.addView(animationImageView,ConsoleUtil.getRelativeLayoutPrams(mainImageViewX,mainImageViewY,imageWidth,imageHeight));

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

        int labelHeight = contentHeight * 6 / 100 ;
        titleLabel = new TextView(this) ;///
        titleLabel.setTextColor(Color.WHITE) ;
        //titleLabel.setBackgroundColor(Color.BLUE);
        titleLabel.setText("Title");
        titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        titleLabel.setTextSize((float) deviceWidth * 6.0f / 100 / scaledDensity);
        titleLabel.setGravity(Gravity.CENTER);
        ConsoleUtil.setTextSizeWithin(deviceWidth*90/100,titleLabel);
        mainView.addView(titleLabel, ConsoleUtil.getRelativeLayoutPrams(0, contentHeight * 17 / 100, deviceWidth, labelHeight));
        currentY += labelHeight ;

        descriptionLabel = new TextView(this) ;///
        descriptionLabel.setTextColor(Color.WHITE) ;
        //descriptionLabel.setBackgroundColor(Color.GREEN);
        descriptionLabel.setText("");
        descriptionLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        descriptionLabel.setTextSize((float) deviceWidth * 3.0f / 100 / scaledDensity);
        descriptionLabel.setGravity(Gravity.CENTER);
        mainView.addView(descriptionLabel, ConsoleUtil.getRelativeLayoutPrams(0, contentHeight*23/100, deviceWidth, deviceHeight*8/100));
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
                mainView.addView(dotImageViews[index],ConsoleUtil.getRelativeLayoutPrams(currentX,contentHeight*34/100,imageSize,imageSize));
                currentX += imageSize + imageGap ;
            }
        }

        this.setMainImage() ;

    }

    public void setMainImage(){
        String title = elements[currentIndex].title ;
        String description = elements[currentIndex].description ;
        titleLabel.setText(title) ;
        descriptionLabel.setText(description) ;

        String imageFileName = elements[currentIndex].imageFileName ;
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
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleActivity::onHeaderRightTextClicked ") ;
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
    }

    public void sendConceptColor(){
        showFullscreenProgress(); ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.setConceptColor(selectedColorString);
    }

    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "ConsoleStarterTutorialActivity::onConsoleDataPostDone " + apiName) ;
        hideFullscreenProgress() ;
        if( apiName.equals("app/setconceptcolor")){
            // pick icon image
            launchImageSelector();
        }

        if(apiName.equals("app/seticonimage")) {
            backToPreviewHomeScreen();
        }
    }

    public void sendIconImage(String imageUri){
        showFullscreenProgress(); ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.setAppIconImage(imageUri);
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
        VeamUtil.log("debug", "ConsoleCustomizeDesignActivity::onActivityResult resultCode:" + resultCode) ;
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
                intent.putExtra("outputX", 1024);
                intent.putExtra("outputY", 1024);
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
                String imagePath = pickedFileUri.getPath();
                VeamUtil.log("debug","image uri = "+ imagePath) ;
                 sendIconImage(imagePath);
            }
        }
    }



}
