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
 * Created by veam on 12/7/16.
 */
public class ConsoleForumActivity extends ConsoleActivity implements TouchInterceptor.DragListener, TouchInterceptor.DropListener {

    private ConsoleForumAdapter adapter ;

    private int indexToBeRemoved = 0 ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleForumAdapter(this) ;
        this.addMainList(adapter);

        mainListView.setDragListener(this);
        mainListView.setDropListener(this);
    }

    @Override
    public void onConsoleDataPostDone(String apiName){
        VeamUtil.log("debug", "onConsoleDataPostDone " + apiName) ;
        hideFullscreenProgress() ;
        //this.finishHorizontal();
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
    public void onClickRemoveButton(int position) {
        VeamUtil.log("debug","onClickRemoveButton position="+position) ;
        indexToBeRemoved = position ;
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(getString(R.string.delete_this));
        builder.setPositiveButton("OK",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //VeamUtil.log("debug","report "+currentPictureObject.getId()+" "+reportEditText.getText().toString()) ;
                        removeForum();
                    }
                });

        builder.setNegativeButton(this.getString(R.string.cancel), null);
        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void removeForum(){
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null) {
            consoleContents.removeForumAt(indexToBeRemoved);
            if (adapter != null) {
                adapter.notifyDataSetChanged();
            }
        }
    }


    @Override
    public void drag(int from, int to) {
        VeamUtil.log("debug","drag "+ from+" to "+to) ;
    }

    @Override
    public void drop(int from, int to) {
        VeamUtil.log("debug","drop "+ from+" to "+to) ;
        if(from != to) {
            int fixedTo = to ;
            ConsoleContents consoleContent = ConsoleUtil.getConsoleContents();
            if (consoleContent != null) {
                int numberOfForums = consoleContent.getNumberOfForums() ;
                if(numberOfForums <= fixedTo){
                    fixedTo = numberOfForums - 1 ;
                }
                consoleContent.moveForumFrom(from, fixedTo);
                if (adapter != null) {
                    adapter.notifyDataSetChanged();
                }
            }
        }
    }

    @Override
    protected int getFloatingMenuKind(){
        return FLOATING_MENU_KIND_EDIT_AND_TUTORIAL ;
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        VeamUtil.log("debug", "onItemClick " + position) ;
        if(adapter != null){
            int count = adapter.getCount() ;
            String forumId = "" ;
            if(position < count-1){
                ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
                if(consoleContents != null){
                    ForumObject forum = consoleContents.getForumAt(position) ;
                    if(forum != null){
                        forumId = forum.getId() ;
                    }
                }
            }
            launchEditForumActivity(forumId) ;
        }
    }

    public void launchEditForumActivity(String forumId){
        Intent intent = new Intent(this,ConsoleEditForumActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.confirm)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_FORUM_ID,forumId) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }

    @Override
    protected void launchTutorialActivity() {
        VeamUtil.log("debug","ConsoleForumActivity::launchTutorialActivity") ;
        Intent intent = new Intent(this,ConsoleTutorialActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.forum_tutorial)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,3) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,2) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND,ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_FORUM) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
    }

    @Override
    protected void startTutorialActivity() {
        VeamUtil.log("debug", "startTutorialActivity");
        this.launchTutorialActivity() ;
    }

}
