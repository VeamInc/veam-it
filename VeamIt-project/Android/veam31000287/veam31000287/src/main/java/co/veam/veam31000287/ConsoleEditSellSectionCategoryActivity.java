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
public class ConsoleEditSellSectionCategoryActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditSellSectionCategoryAdapter adapter ;

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
                sellSectionCategory = consoleContents.getSellSectionCategoryForId(sellSectionCategoryId);
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        String sellSectionCategoryTitle = "" ;
        if(sellSectionCategory != null){
            sellSectionCategoryTitle = sellSectionCategory.getName() ;
        }

        adapter = new ConsoleEditSellSectionCategoryAdapter(this,sellSectionCategoryTitle) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditSellSectionCategoryActivity::onHeaderRightTextClicked ") ;
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

            if (VeamUtil.isEmpty(title)) {
                VeamUtil.showMessage(this, "Please input title");
                return;
            }

            if(sellSectionCategory == null) {
                sellSectionCategory = new SellSectionCategoryObject();
            }

            sellSectionCategory.setName(title);
            sellSectionCategory.setKind("0");

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setSellSectionCategory(sellSectionCategory,title);
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
