package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.RelativeLayout;

/**
 * Created by veam on 12/12/16.
 */
public class ConsoleEditSellVideoActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditSellVideoAdapter adapter ;

    //MixedObject mixed ;
    SellVideoObject sellVideo ;
    VideoObject video ;
    VideoCategoryObject videoCategory ;
    boolean isSellSection ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        //String mixedId = intent.getStringExtra("MIXED_ID") ;
        isSellSection = intent.getBooleanExtra("IS_SELL_SECTION", false) ;
        String videoCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_VIDEOCATEGORY_ID) ;
        if(!VeamUtil.isEmpty(videoCategoryId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                //mixed = consoleContents.getMixedForId(mixedId);
                videoCategory = consoleContents.getVideoCategoryForId(videoCategoryId) ;
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditSellVideoAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditSellVideoActivity::onHeaderRightTextClicked ") ;
        if(adapter.isModified()){
            this.saveData();
        } else {
            this.finishVertical();
        }
    }

    public void saveData(){
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(adapter != null) {
            //NSLog(@"%@::saveValues",NSStringFromClass([self class])) ;
            String title = adapter.getTitle() ;
            String sourceUrl = adapter.getVideoDataUrl() ;
            String imageUrl = adapter.getImageDataUrl() ;
            String description = adapter.getDescription() ;
            String price = adapter.getPrice() ;

            if(isSellSection){
                description = "" ;
                price = "" ;
            }

            if(VeamUtil.isEmpty(title)){
                VeamUtil.showMessage(this,"Please input title") ;
                return  ;
            }
            if(VeamUtil.isEmpty(sourceUrl)){
                VeamUtil.showMessage(this,"Please input video data url") ;
                return  ;
            }

            if(VeamUtil.isEmpty(imageUrl)){
                VeamUtil.showMessage(this,"Please select image data url") ;
                return  ;
            }


            if(!isSellSection){
                if(VeamUtil.isEmpty(description)){
                    VeamUtil.showMessage(this,"Please input description") ;
                    return  ;
                }

                if(VeamUtil.isEmpty(price)){
                    VeamUtil.showMessage(this,"Please input price") ;
                    return  ;
                }
            }

            if(video == null){
                //NSLog(@"new video c=%@",videoCategory.videoCategoryId) ;
                video = new VideoObject() ;
                if(videoCategory == null){
                    video.setVideoCategoryId("0") ;
                } else {
                    video.setVideoCategoryId(videoCategory.getId()) ;
                }

                video.setVideoSubCategoryId("0") ;
            }

            video.setTitle(title) ;
            video.setDataUrl(sourceUrl) ;
            video.setThumbnailUrl(imageUrl) ;

            if(sellVideo == null){
                sellVideo = new SellVideoObject() ;
            }
            sellVideo.setDescription(description) ;
            sellVideo.setPrice(price) ;

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setSellVideo(sellVideo,video.getVideoCategoryId(),title,sourceUrl,imageUrl);
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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == REQUEST_CODE_DROPBOX_ACTIVITY){
            if(resultCode == RESULT_OK) {
                if(data != null) {
                    Bundle bundle = data.getExtras();
                    String shareUrl = bundle.getString("DROPBOX_SHARE_URL");
                    if (!VeamUtil.isEmpty(shareUrl)) {
                        if (adapter != null) {
                            adapter.setValue(shareUrl);
                            adapter.notifyDataSetChanged();
                        }
                    }
                }
            }
        }
    }


    @Override
    public void onUpdateConsoleContentFinished(Integer resultCode) {
        VeamUtil.log("debug", "onUpdateConsoleContentFinished") ;
        hideFullscreenProgress() ;
        this.finishVertical();
    }
}
