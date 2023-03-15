package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
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
import android.widget.AdapterView;
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
 * Created by veam on 12/7/16.
 */
public class ConsoleTutorialActivity extends ConsoleActivity {

    private TextView titleLabel ;
    private TextView descriptionLabel ;
    private ImageView mainImageView ;
    private int mainImageViewX ;
    private int mainImageViewY ;
    private ImageView animationImageView ;
    private ImageView nextImageView ;
    private ImageView prevImageView ;
    private ImageView[] dotImageViews ;
    /*
    private String[] elementTitles ;
    private String[] elementDescriptions ;
    */
    private int currentIndex ;
    private int numberOfElements ;

    private int tutorialKind ;
    private ConsoleTutorialElement[] elements ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = this.getIntent();
        tutorialKind = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND, 0) ;

        switch (tutorialKind) {
            case ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE:
                ConsoleTutorialElement[] workElements1 = {
                new ConsoleTutorialElement(
                "1",
                getString(R.string.exclusive_tutorial_title_1),
                getString(R.string.exclusive_tutorial_description_1),
                "exclusive_tutorial_ss1",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE),

                new ConsoleTutorialElement(
                "2",
                getString(R.string.exclusive_tutorial_title_2),
                getString(R.string.exclusive_tutorial_description_2),
                "exclusive_tutorial_ss2",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE),

                new ConsoleTutorialElement(
                "3",
                getString(R.string.exclusive_tutorial_title_3),
                getString(R.string.exclusive_tutorial_description_3),
                "exclusive_tutorial_ss3",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE),

                } ;
                elements = workElements1 ;
                break;
            case ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED:
                ConsoleTutorialElement[] workElements2 = {
                new ConsoleTutorialElement(
                "1",
                getString(R.string.exclusive_released_tutorial_title_1),
                getString(R.string.exclusive_released_tutorial_description_1),
                "exclusive_ar_tutorial_ss1",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED),

                } ;
                elements = workElements2 ;
                break;
            case ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE:
                ConsoleTutorialElement[] workElements3 = {
                new ConsoleTutorialElement(
                "1",
                getString(R.string.youtube_tutorial_title_1),
                getString(R.string.youtube_tutorial_description_1),
                "youtube_tutorial_ss1",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE),

                new ConsoleTutorialElement(
                "2",
                getString(R.string.youtube_tutorial_title_2),
                getString(R.string.youtube_tutorial_description_2),
                "youtube_tutorial_ss2",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE),

                } ;
                elements = workElements3 ;
                break;
            case ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM:
                ConsoleTutorialElement[] workElements4 = {
                new ConsoleTutorialElement(
                "1",
                getString(R.string.forum_tutorial_title_1),
                getString(R.string.forum_tutorial_description_1),
                "forum_tutorial_ss1",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM),

                new ConsoleTutorialElement(
                "2",
                getString(R.string.forum_tutorial_title_2),
                getString(R.string.forum_tutorial_description_2),
                "forum_tutorial_ss2",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM),

                new ConsoleTutorialElement(
                "3",
                getString(R.string.forum_tutorial_title_3),
                getString(R.string.forum_tutorial_description_3),
                "forum_tutorial_ss3",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM),

                } ;
                elements = workElements4 ;
                break;
            case ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM_RELEASED:
                ConsoleTutorialElement[] workElements5 = {
                new ConsoleTutorialElement(
                "1",
                getString(R.string.forum_released_tutorial_title_1),
                getString(R.string.forum_released_tutorial_description_1),
                "forum_tutorial_ss1",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM),

                new ConsoleTutorialElement(
                "2",
                getString(R.string.forum_released_tutorial_title_2),
                getString(R.string.forum_released_tutorial_description_2),
                "forum_tutorial_ss2",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM),

                } ;
                elements = workElements5 ;
                break;
            case ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_LINK:
                ConsoleTutorialElement[] workElements6 = {
                new ConsoleTutorialElement(
                "1",
                getString(R.string.links_tutorial_title_1),
                getString(R.string.links_tutorial_description_1),
                "link_tutorial_ss1",
                ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_LINK),
                } ;
                elements = workElements6 ;
                break;

            default:
                break;
        }



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
        iconImageView.setImageResource(R.drawable.tutorial_icon);
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
        titleLabel.setTextColor(Color.BLACK) ;
        //titleLabel.setBackgroundColor(Color.BLUE);
        titleLabel.setText("Title");
        titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        titleLabel.setTextSize((float) deviceWidth * 6.0f / 100 / scaledDensity);
        titleLabel.setGravity(Gravity.CENTER);
        ConsoleUtil.setTextSizeWithin(deviceWidth * 90 / 100, titleLabel);
        mainView.addView(titleLabel, ConsoleUtil.getRelativeLayoutPrams(0, contentHeight * 17 / 100, deviceWidth, labelHeight));
        currentY += labelHeight ;

        //float descriptionTextSize = (float) deviceWidth * 3.0f / 100 / scaledDensity ;
        float descriptionTextSize = (float) deviceHeight * 2.0f / 100 / scaledDensity ;
        int descriptionLabelHeight = deviceHeight*8/100 ;
        descriptionLabel = new TextView(this);///
        descriptionLabel.setTextColor(Color.BLACK) ;
        //descriptionLabel.setBackgroundColor(Color.GREEN);
        descriptionLabel.setText("");
        descriptionLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        descriptionLabel.setTextSize(descriptionTextSize);
        descriptionLabel.setGravity(Gravity.CENTER);
        mainView.addView(descriptionLabel, ConsoleUtil.getRelativeLayoutPrams(0, contentHeight*23/100, deviceWidth, descriptionLabelHeight));
        currentY += labelHeight ;

        VeamUtil.log("debug","textSize="+descriptionTextSize+" descriptionLabelHeight"+descriptionLabelHeight) ;


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
                        animationImageView.setImageResource(VeamUtil.getDrawableId(ConsoleTutorialActivity.this, elements[currentIndex].imageFileName));
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
                        animationImageView.setImageResource(VeamUtil.getDrawableId(ConsoleTutorialActivity.this, elements[currentIndex].imageFileName));
                    }
                });
                this.doAnimationWithDirection(1) ;
            }
        }
    }
}
