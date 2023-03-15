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
public class ConsoleEditSellAudioActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditSellAudioAdapter adapter ;

    //MixedObject mixed ;
    SellAudioObject sellAudio ;
    AudioObject audio ;
    AudioCategoryObject audioCategory ;
    boolean isSellSection ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        //String mixedId = intent.getStringExtra("MIXED_ID") ;
        isSellSection = intent.getBooleanExtra("IS_SELL_SECTION", false) ;
        String audioCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_AUDIOCATEGORY_ID) ;
        if(!VeamUtil.isEmpty(audioCategoryId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                //mixed = consoleContents.getMixedForId(mixedId);
                audioCategory = consoleContents.getAudioCategoryForId(audioCategoryId) ;
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditSellAudioAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditSellAudioActivity::onHeaderRightTextClicked ") ;
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
            String sourceUrl = adapter.getAudioDataUrl() ;
            String imageUrl = adapter.getImageDataUrl() ;
            String pdfUrl = adapter.getPdfDataUrl() ;
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
                VeamUtil.showMessage(this,"Please input audio data url") ;
                return  ;
            }

            if(VeamUtil.isEmpty(imageUrl)){
                VeamUtil.showMessage(this,"Please select image data url") ;
                return  ;
            }

            if (VeamUtil.isEmpty(pdfUrl)) {
                pdfUrl = "";
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

            if(audio == null){
                //NSLog(@"new audio c=%@",audioCategory.audioCategoryId) ;
                audio = new AudioObject() ;
                if(audioCategory == null){
                    audio.setAudioCategoryId("0") ;
                } else {
                    audio.setAudioCategoryId(audioCategory.getId()) ;
                }

                audio.setAudioSubCategoryId("0") ;
            }

            audio.setTitle(title) ;
            audio.setDataUrl(sourceUrl) ;
            audio.setThumbnailUrl(imageUrl) ;
            audio.setLinkUrl(pdfUrl) ;

            if(sellAudio == null){
                sellAudio = new SellAudioObject() ;
            }
            sellAudio.setDescription(description) ;
            sellAudio.setPrice(price) ;

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setSellAudio(sellAudio,audio.getAudioCategoryId(),title,sourceUrl,imageUrl,pdfUrl);
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
