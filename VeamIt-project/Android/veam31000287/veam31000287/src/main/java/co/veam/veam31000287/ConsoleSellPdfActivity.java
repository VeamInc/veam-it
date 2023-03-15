package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.RelativeLayout;

/**
 * Created by veam on 12/12/16.
 */
public class ConsoleSellPdfActivity extends ConsoleActivity {

    private int indexToBeRemoved ;
    ConsoleSellPdfAdapter adapter ;
    SellItemCategoryObject sellItemCategory ;
    PdfCategoryObject pdfCategory ;
    SellPdfObject currentSellPdf ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        needUpdateTimer = true ;

        Intent intent = getIntent() ;
        String sellItemCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_SELLITEMCATEGORY_ID) ;
        VeamUtil.log("debug", "sellItemCategoryId=" + sellItemCategoryId) ;
        if(!VeamUtil.isEmpty(sellItemCategoryId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                sellItemCategory = consoleContents.getSellItemCategoryForId(sellItemCategoryId);
                if(sellItemCategory != null){
                    VeamUtil.log("debug","pdfCategoryId="+sellItemCategory.getTargetCategoryId()) ;
                    pdfCategory = consoleContents.getPdfCategoryForId(sellItemCategory.getTargetCategoryId()) ;
                }
            }
        }


        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleSellPdfAdapter(this,pdfCategory.getId()) ;
        this.addMainList(adapter);
    }

    @Override
    public void onClick(View view) {
        super.onClick(view);
        if(view.getId() == VIEWID_LIST_DELETE){
            int index = (Integer)view.getTag() ;
            indexToBeRemoved = index ;
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setTitle(getString(R.string.delete_this));
            //builder.setMessage(this.getString(R.string.why_are_you_reporting_this_photo)) ;
            builder.setPositiveButton("OK",
                    new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            //VeamUtil.log("debug","report "+currentPictureObject.getId()+" "+reportEditText.getText().toString()) ;
                            removeSellPdf();
                        }
                    });

            builder.setNegativeButton(this.getString(R.string.cancel), null);
            AlertDialog dialog = builder.create();
            dialog.show();
        }
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        VeamUtil.log("debug", "ConsoleActivity::onItemClick " + position) ;
        int count = adapter.getCount() ;
        if(position == count - 1) {
            launchEditSellPdfActivity("") ; // new
        }
    }

    public void launchEditSellPdfActivity(String sellPdfId){

        Intent intent = new Intent(this,ConsoleEditSellPdfActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.confirm)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLPDF_ID,sellPdfId) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_PDFCATEGORY_ID,pdfCategory.getId()) ;
        intent.putExtra("IS_SELL_SECTION",false) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }


    public void removeSellPdf(){
        showFullscreenProgress();
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.removeSellPdfForPdfCategory(pdfCategory.getId(), indexToBeRemoved);
    }


    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostDone " + apiName) ;
        hideFullscreenProgress() ;
        if(adapter != null){
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void onConsoleDataPostFailed(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostFailed " + apiName) ;
        VeamUtil.showMessage(this, "Failed to send data");
        hideFullscreenProgress() ;
    }

    @Override
    protected void doUpdate(){
        VeamUtil.log("debug", "ConsoleSellPdfActivity::doUpdate ");
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            consoleContents.updatePreparingSellPdfStatus(pdfCategory.getId());
        }
    }

    @Override
    protected int getFloatingMenuKind(){
        return FLOATING_MENU_KIND_EDIT ;
    }

}
