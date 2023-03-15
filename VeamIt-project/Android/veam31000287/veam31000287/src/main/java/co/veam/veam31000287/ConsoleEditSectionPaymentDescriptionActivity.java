package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.RelativeLayout;

/**
 * Created by veam on 12/13/16.
 */
public class ConsoleEditSectionPaymentDescriptionActivity extends ConsoleActivity {

    ConsoleEditSectionPaymentDescriptionAdapter adapter ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditSectionPaymentDescriptionAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditAppInformationActivity::onHeaderRightTextClicked ") ;
        if(adapter.isModified()){
            this.saveData();
        } else {
            this.finishHorizontal();
        }
    }

    public void saveData(){
        showFullscreenProgress();
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.setAppData(adapter.getDescription(),ConsoleUtil.CONSOLE_SECTION_PAYMENT_DESCRIPTION_KEY);
    }

    @Override
    public void onHeaderCloseClicked(View v) {
        VeamUtil.log("debug", "ConsoleActivity::onHeaderRightTextClicked ") ;
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
                                    finishHorizontal();
                                    break ;
                                case 2:
                                    break ;
                            }
                        }
                    })
                    .show();
        } else {
            this.finishHorizontal();
        }
    }

    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostDone " + apiName) ;
        hideFullscreenProgress() ;
        this.finishHorizontal();
    }

    @Override
    public void onConsoleDataPostFailed(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostFailed " + apiName) ;
        VeamUtil.showMessage(this,"Failed to send data");
        hideFullscreenProgress() ;
    }




}
