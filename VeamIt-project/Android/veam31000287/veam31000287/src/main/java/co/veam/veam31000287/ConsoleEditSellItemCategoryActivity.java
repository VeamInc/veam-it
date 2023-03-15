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
 * Created by veam on 12/9/16.
 */
public class ConsoleEditSellItemCategoryActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditSellItemCategoryAdapter adapter ;

    SellItemCategoryObject sellItemCategory ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        String sellItemCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_SELLITEMCATEGORY_ID) ;
        if(!VeamUtil.isEmpty(sellItemCategoryId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                sellItemCategory = consoleContents.getSellItemCategoryForId(sellItemCategoryId);
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        String sellItemCategoryTitle = "" ;
        String sellItemCategoryKind = "" ;
        if(sellItemCategory != null){
            sellItemCategoryTitle = this.getSellItemCategoryName(sellItemCategory) ;
            sellItemCategoryKind = sellItemCategory.getKind() ;
        }

        adapter = new ConsoleEditSellItemCategoryAdapter(this,sellItemCategoryTitle,sellItemCategoryKind) ;
        this.addMainList(adapter);
    }

    public String getSellItemCategoryName(SellItemCategoryObject sellItemCategoryObject){
        String name = "" ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        name = consoleContents.getCategoryTitleForSellItemCategory(sellItemCategoryObject) ;
        return name ;
    }


    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditSellItemCategoryActivity::onHeaderRightTextClicked ") ;
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
            String kind = adapter.getKindId() ;

            if (VeamUtil.isEmpty(title)) {
                VeamUtil.showMessage(this, "Please input title");
                return;
            }

            if (VeamUtil.isEmpty(kind)) {
                VeamUtil.showMessage(this, "Please input kind");
                return;
            }

            if(sellItemCategory == null) {
                sellItemCategory = new SellItemCategoryObject();
            }

            sellItemCategory.setKind(kind);

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setSellItemCategory(sellItemCategory,title);
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
        this.finishVertical();
    }
}
