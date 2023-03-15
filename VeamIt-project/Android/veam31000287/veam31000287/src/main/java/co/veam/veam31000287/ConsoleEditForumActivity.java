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
public class ConsoleEditForumActivity extends ConsoleActivity implements UpdateConsoleContentTask.UpdateConsoleContentTaskActivityInterface {

    ConsoleEditForumAdapter adapter ;

    ForumObject forum ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = getIntent() ;
        String forumId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_FORUM_ID) ;
        if(!VeamUtil.isEmpty(forumId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                forum = consoleContents.getForumForId(forumId);
            }
        }

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        String forumTitle = "" ;
        if(forum != null){
            forumTitle = forum.getName() ;
        }

        adapter = new ConsoleEditForumAdapter(this,forumTitle) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderRightTextClicked(View v) {
        VeamUtil.log("debug", "ConsoleEditForumActivity::onHeaderRightTextClicked ") ;
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

            if(forum == null) {
                forum = new ForumObject();
                forum.setKind(VeamUtil.VEAM_FORUM_KIND_NORMAL);
            }

            forum.setName(title);

            showFullscreenProgress();
            ConsoleContents contents = ConsoleUtil.getConsoleContents();
            contents.setForum(forum);
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
