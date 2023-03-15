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
 * Created by veam on 12/2/16.
 */
public class ConsoleEditVideoActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditVideoAdapter adapter ;

    MixedObject mixed ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        String mixedId = intent.getStringExtra("MIXED_ID") ;
        if(!VeamUtil.isEmpty(mixedId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                mixed = consoleContents.getMixedForId(mixedId);
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditVideoAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditVideoActivity::onHeaderRightTextClicked ") ;
        if(adapter.isModified()){
            this.saveData();
        } else {
            this.finishVertical();
        }
    }

    public void saveData(){
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(adapter != null) {
            String title = adapter.getTitle();
            String videoUrl = adapter.getVideoDataUrl();
            String imageUrl = adapter.getImageDataUrl();

            if (VeamUtil.isEmpty(title)) {
                VeamUtil.showMessage(this, "Please input title");
                return;
            }

            if (VeamUtil.isEmpty(videoUrl)) {
                VeamUtil.showMessage(this, "Please input video data url");
                return;
            }

            if (VeamUtil.isEmpty(imageUrl)) {
                VeamUtil.showMessage(this, "Please select image data url");
                return;
            }

            VideoObject video = new VideoObject();
            video.setVideoCategoryId("0");
            video.setVideoSubCategoryId("0");
            //video.setKind(VideoObject.VEAM_VIDEO_KIND_MESSAGE);

            video.setTitle(title);

            video.setSourceUrl(videoUrl);

            video.setThumbnailUrl(imageUrl);


            if (mixed != null) {
                VeamUtil.log("debug","mixed found id="+mixed.getId()) ;
                video.setMixed(mixed);
            }

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setVideo(video, null);
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
