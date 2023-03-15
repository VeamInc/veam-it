package co.veam.veam31000287;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.widget.RelativeLayout;

/**
 * Created by veam on 12/6/16.
 */
public class ConsoleYoutubeCategoryActivity  extends ConsoleActivity implements TouchInterceptor.DragListener, TouchInterceptor.DropListener {

    private ConsoleYoutubeCategoryAdapter adapter ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleYoutubeCategoryAdapter(this) ;
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
    public void onClickStopButton(int position) {
        VeamUtil.log("debug","onClickStopButton position="+position) ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null) {
            YoutubeCategoryObject category = consoleContents.getYoutubeCategoryAt(position);
            if (category != null) {
                consoleContents.disableYoutubeCategoryAt(position, !category.getDisabled().equals("1"));
                if(adapter != null){
                    adapter.notifyDataSetChanged();
                }
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
            ConsoleContents consoleContent = ConsoleUtil.getConsoleContents();
            if (consoleContent != null) {
                consoleContent.moveYoutubeCategoryFrom(from, to);
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
    protected void launchTutorialActivity() {
        VeamUtil.log("debug","ConsoleYoutubeActivity::launchTutorialActivity") ;
        Intent intent = new Intent(this,ConsoleTutorialActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.youtube_tutorial)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,3) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,2) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND,ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
    }

    @Override
    protected void startTutorialActivity() {
        VeamUtil.log("debug", "startTutorialActivity");
        this.launchTutorialActivity() ;
    }

}
