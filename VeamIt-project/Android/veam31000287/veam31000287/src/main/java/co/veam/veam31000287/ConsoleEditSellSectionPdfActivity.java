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
 * Created by veam on 12/13/16.
 */
public class ConsoleEditSellSectionPdfActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditSellSectionPdfAdapter adapter ;

    //MixedObject mixed ;
    SellSectionItemObject sellSectionItem ;
    PdfObject pdf ;
    SellSectionCategoryObject sellSectionCategory ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        String sellSectionCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID) ;
        if(!VeamUtil.isEmpty(sellSectionCategoryId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                sellSectionCategory = consoleContents.getSellSectionCategoryForId(sellSectionCategoryId) ;
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditSellSectionPdfAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditSellSectionPdfActivity::onHeaderRightTextClicked ") ;
        if(adapter.isModified()){
            this.saveData();
        } else {
            this.finishVertical();
        }
    }

    public void saveData(){
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(adapter != null) {
            String title = adapter.getTitle() ;
            String sourceUrl = adapter.getPdfDataUrl() ;
            String imageUrl = adapter.getImageDataUrl() ;

            if(VeamUtil.isEmpty(title)){
                VeamUtil.showMessage(this,"Please input title") ;
                return  ;
            }
            if(VeamUtil.isEmpty(sourceUrl)){
                VeamUtil.showMessage(this,"Please input pdf data url") ;
                return  ;
            }

            if(VeamUtil.isEmpty(imageUrl)){
                VeamUtil.showMessage(this,"Please select image data url") ;
                return  ;
            }

            if(pdf == null){
                //NSLog(@"new pdf c=%@",pdfCategory.pdfCategoryId) ;
                pdf = new PdfObject() ;
                pdf.setPdfCategoryId("0") ;
                pdf.setPdfSubCategoryId("0") ;
            }

            pdf.setTitle(title) ;
            pdf.setDataUrl(sourceUrl) ;
            pdf.setThumbnailUrl(imageUrl) ;

            if(sellSectionItem == null){
                sellSectionItem = new SellSectionItemObject() ;
                sellSectionItem.setSellSectionCategoryId(sellSectionCategory.getId()) ;
            }


            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setSellSectionPdf(sellSectionItem,title,sourceUrl,imageUrl) ;
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
