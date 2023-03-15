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
 * Created by veam on 11/21/16.
 */
public class ConsoleEditAppInformationActivity  extends ConsoleActivity {

    ConsoleEditAppInformationAdapter adapter ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditAppInformationAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditAppInformationActivity::onHeaderRightTextClicked ") ;
        if(adapter.isModified()){
            this.saveData();
        } else {
            this.finishVertical();
        }
    }

    public void saveData(){
        showFullscreenProgress();
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;

        String originalDescription = consoleContents.appInfo.getDescription() ;
        String newDescrioption = adapter.getDescription() ;
        consoleContents.appInfo.setName(adapter.getAppName()) ;
        consoleContents.appInfo.setStoreAppName(adapter.getAppStoreName()) ;
        consoleContents.appInfo.setDescription(newDescrioption) ;
        consoleContents.appInfo.setKeyword(adapter.getKeyword()) ;
        consoleContents.appInfo.setCategory(adapter.getCategory()) ;
        consoleContents.saveAppInfo();

        if(!originalDescription.equals(newDescrioption)){
            consoleContents.setValueForKey("app_description_set","1");
        }
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
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        VeamUtil.log("debug", "onItemClick " + position) ;
        if(position == 5){ // Rating
            Intent intent = new Intent(this, ConsoleEditRatingActivity.class) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE) ;
            //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
            intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
            //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,"Done") ;
            startActivity(intent);
            overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);

        }
    }



    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostDone " + apiName) ;
        hideFullscreenProgress() ;
        this.finishVertical();
    }

    @Override
    public void onConsoleDataPostFailed(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostFailed " + apiName) ;
        VeamUtil.showMessage(this,"Failed to send data");
        hideFullscreenProgress() ;
    }




}
