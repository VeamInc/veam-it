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
 * Created by veam on 12/7/16.
 */
public class ConsoleEditWebActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditWebAdapter adapter ;

    WebObject web ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        String webId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_WEB_ID) ;
        if(!VeamUtil.isEmpty(webId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                web = consoleContents.getWebForId(webId);
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        String webTitle = "" ;
        String webUrl = "" ;
        if(web != null){
            webTitle = web.getTitle() ;
            webUrl = web.getUrl() ;
        }

        adapter = new ConsoleEditWebAdapter(this,webTitle,webUrl) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditWebActivity::onHeaderRightTextClicked ") ;
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
            String url = adapter.getUrl();

            if (VeamUtil.isEmpty(title)) {
                VeamUtil.showMessage(this, "Please input title");
                return;
            }

            if (VeamUtil.isEmpty(url)) {
                VeamUtil.showMessage(this, "Please input URL");
                return;
            }

            if(web == null) {
                web = new WebObject();
            }

            web.setTitle(title);
            web.setUrl(url);

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setWeb(web);
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
