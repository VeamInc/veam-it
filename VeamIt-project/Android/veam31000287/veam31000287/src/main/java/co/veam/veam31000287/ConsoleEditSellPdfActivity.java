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
public class ConsoleEditSellPdfActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditSellPdfAdapter adapter ;

    //MixedObject mixed ;
    SellPdfObject sellPdf ;
    PdfObject pdf ;
    PdfCategoryObject pdfCategory ;
    boolean isSellSection ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        //String mixedId = intent.getStringExtra("MIXED_ID") ;
        isSellSection = intent.getBooleanExtra("IS_SELL_SECTION", false) ;
        String pdfCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_PDFCATEGORY_ID) ;
        if(!VeamUtil.isEmpty(pdfCategoryId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                //mixed = consoleContents.getMixedForId(mixedId);
                pdfCategory = consoleContents.getPdfCategoryForId(pdfCategoryId) ;
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditSellPdfAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditSellPdfActivity::onHeaderRightTextClicked ") ;
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
            String sourceUrl = adapter.getPdfDataUrl() ;
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
                VeamUtil.showMessage(this,"Please input pdf data url") ;
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

            if(pdf == null){
                //NSLog(@"new pdf c=%@",pdfCategory.pdfCategoryId) ;
                pdf = new PdfObject() ;
                if(pdfCategory == null){
                    pdf.setPdfCategoryId("0") ;
                } else {
                    pdf.setPdfCategoryId(pdfCategory.getId()) ;
                }

                pdf.setPdfSubCategoryId("0") ;
            }

            pdf.setTitle(title) ;
            pdf.setDataUrl(sourceUrl) ;
            pdf.setThumbnailUrl(imageUrl) ;

            if(sellPdf == null){
                sellPdf = new SellPdfObject() ;
            }
            sellPdf.setDescription(description) ;
            sellPdf.setPrice(price) ;

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setSellPdf(sellPdf,pdf.getPdfCategoryId(),title,sourceUrl,imageUrl);
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
