package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.RelativeLayout;
import android.widget.Toast;
import android.widget.VideoView;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by veam on 12/8/16.
 */
public class ConsoleEditSnapActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface, MediaPlayer.OnCompletionListener {

    ConsoleEditSnapAdapter adapter ;

    MixedObject mixed ;

    private String snapFilePath ;
    private MediaPlayer mediaPlayer;
    private VideoView videoView ;
    private View maskView ;
    private int videoWidth ;
    private int videoHeight ;
    private int uploadKind ;
    private VideoCategoryObject videoCategory ;
    private SellVideoObject sellVideo ;
    private SellSectionItemObject sellSectionItem ;
    private SellSectionCategoryObject sellSectionCategory ;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        String mixedId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_MIXED_ID) ;
        uploadKind = intent.getIntExtra(ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND,0) ;
        String videoCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_VIDEOCATEGORY_ID) ;
        String sellSectionCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID) ;
        VeamUtil.log("debug","mixedId="+mixedId+ " uploadKind="+uploadKind) ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
        if (consoleContents != null) {
            if(!VeamUtil.isEmpty(mixedId)) {
                mixed = consoleContents.getMixedForId(mixedId);
            }
            if(!VeamUtil.isEmpty(videoCategoryId)){
                videoCategory = consoleContents.getVideoCategoryForId(videoCategoryId) ;
            }
            if(!VeamUtil.isEmpty(sellSectionCategoryId)){
                sellSectionCategory = consoleContents.getSellSectionCategoryForId(sellSectionCategoryId) ;
            }
        }
        snapFilePath = intent.getStringExtra("FILE_PATH") ;
        videoWidth = intent.getIntExtra("VIDEO_WIDTH",480) ;
        videoHeight = intent.getIntExtra("VIDEO_HEIGHT", 640) ;


        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditSnapAdapter(this,uploadKind) ;
        this.addMainList(adapter);

        int snapY = deviceWidth / 2 ;
        int snapWidth = deviceWidth * 50 / 100 ;
        int snapHeight = snapWidth * videoHeight / videoWidth ;
        int snapHeightMax = deviceHeight - snapY - ConsoleUtil.getStatusBarHeight() ;
        if(snapHeightMax < snapHeight){
            snapHeight = snapHeightMax ;
            snapWidth = snapHeight * videoWidth / videoHeight ;
        }

        if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SELLVIDEO){
            snapY = deviceHeight - ConsoleUtil.getStatusBarHeight() - snapWidth ;
        }

        int maskY = snapY + snapWidth ;

        int snapX = (deviceWidth - snapWidth) / 2 ;
        videoView = new VideoView(this) ;
        //videoView.setId(this.VIEWID_PLAYER) ;
        videoView.setBackgroundColor(Color.TRANSPARENT) ;
        videoView.setOnCompletionListener(this) ;
        //videoView.setOnTouchListener(this) ;
        rootLayout.addView(videoView,ConsoleUtil.getRelativeLayoutPrams(snapX,snapY,snapWidth,snapHeight)) ;

        maskView = new View(this) ;
        maskView.setBackgroundColor(Color.WHITE);
        rootLayout.addView(maskView, ConsoleUtil.getRelativeLayoutPrams(0, maskY, deviceWidth, deviceHeight-maskY)) ;

        this.startMovie();


    }

    private boolean isPlaying()
    {
        boolean retBool = false ;
        try {
            retBool = videoView.isPlaying() ;
        } catch (Exception e) {
            //Toast.makeText(getApplicationContext(),e.getMessage(),Toast.LENGTH_LONG).show();
        }
        return retBool ;
    }


    private void startMovie(){
        //VeamUtil.log("debug","startMovie()") ;
        if((videoView != null) && isPlaying()){
            videoView.stopPlayback() ;
        }

        videoView.setVideoPath(snapFilePath);
        videoView.start();

    }


    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditSnapActivity::onHeaderRightTextClicked ") ;
        if(adapter.isModified()){
            this.saveData();
        } else {
            this.finishVertical();
        }
    }

    public void removeVideoView(){
        if(videoView != null) {
            rootLayout.removeView(videoView);
            videoView = null ;
        }
        if(maskView != null) {
            rootLayout.removeView(maskView);
            maskView = null ;
        }
    }

    public void saveData(){
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(adapter != null) {
            String title = adapter.getTitle();
            String price = adapter.getPrice();
            String description = adapter.getDescription();

            if (VeamUtil.isEmpty(title)) {
                VeamUtil.showMessage(this, "Please input title");
                return;
            }

            if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SELLVIDEO){
                if(VeamUtil.isEmpty(description)){
                    VeamUtil.showMessage(this,"Please input description") ;
                    return  ;
                }

                if(VeamUtil.isEmpty(price)){
                    VeamUtil.showMessage(this,"Please input price") ;
                    return  ;
                }
            }


            videoView.stopPlayback();
            handler.post(new Runnable() {
                public void run() {
                    removeVideoView();
                }
            });

            String dateString = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String fileName = String.format("sa%s.mov", dateString) ;

            Intent intent = new Intent(this, UploadIntentService.class);
            intent.putExtra("SOURCE_FILE_URI",snapFilePath);
            intent.putExtra("FILE_NAME",fileName);
            this.startService(intent);

            VideoObject video = new VideoObject();
            if(videoCategory == null){
                video.setVideoCategoryId("0");
            } else {
                video.setVideoCategoryId(videoCategory.getId()) ;
            }
            video.setVideoSubCategoryId("0");

            video.setTitle(title);

            video.setSourceUrl(fileName);

            video.setThumbnailUrl("NOIMAGE");

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();

            if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SUBSCRIPTION) {
                if (mixed != null) {
                    VeamUtil.log("debug","mixed found id="+mixed.getId()) ;
                    video.setMixed(mixed);
                }

                contents.setVideo(video, null);
            } else if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SELLVIDEO){
                if(sellVideo == null){
                    sellVideo = new SellVideoObject() ;
                }
                sellVideo.setDescription(description) ;
                sellVideo.setPrice(price) ;

                contents.setSellVideo(sellVideo, video.getVideoCategoryId(), title, fileName, "NOIMAGE");
            } else if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SELLSECTION){
                if(sellSectionItem == null){
                    sellSectionItem = new SellSectionItemObject() ;
                    if(sellSectionCategory == null){
                        sellSectionItem.setSellSectionCategoryId("0") ;
                    } else {
                        sellSectionItem.setSellSectionCategoryId(sellSectionCategory.getId()) ;
                    }

                    sellSectionItem.setSellSectionSubCategoryId("0") ;
                }
                contents.setSellSectionVideo(sellSectionItem,title,fileName,"NOIMAGE") ;
            }
        }
    }

    @Override
    public void onHeaderCloseClicked(View v) {
        VeamUtil.log("debug", "onHeaderRightTextClicked ") ;
        if(adapter.isModified()){
            final String[] items = {this.getString(R.string.save),this.getString(R.string.discard),this.getString(R.string.cancel)};
            new AlertDialog.Builder(this)
                    .setItems(items, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            switch (which){
                                case 0:
                                    saveData();
                                    break ;
                                case 1:
                                    finishVertical();
                                    break ;
                                case 2:
                                    break ;
                            }
                        }
                    })
                    .show();
        } else {
            this.finishVertical();
        }
    }

    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostDone " + apiName) ;
        UpdateConsoleContentTask updateConsoleContentTask = new UpdateConsoleContentTask(this,this) ;
        updateConsoleContentTask.execute() ;
    }

    @Override
    public void onConsoleDataPostFailed(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostFailed " + apiName) ;
        VeamUtil.showMessage(this, "Failed to send data");
        hideFullscreenProgress() ;
    }

    @Override
    public void onUpdateConsoleContentFinished(Integer resultCode) {
        VeamUtil.log("debug", "onUpdateConsoleContentFinished") ;
        hideFullscreenProgress() ;
        this.setResult(1);
        this.finishVertical();
    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        if(videoView != null){
            videoView.start();
        }
    }
}
