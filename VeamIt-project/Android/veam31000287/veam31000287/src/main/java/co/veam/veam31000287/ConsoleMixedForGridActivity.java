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

import java.util.ArrayList;
import java.util.List;

/**
 * Created by veam on 11/29/16.
 */
public class ConsoleMixedForGridActivity extends ConsoleActivity {

    private int indexToBeRemoved ;
    ConsoleMixedForGridAdapter adapter ;
    MixedObject currentMixed ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        needUpdateTimer = true ;

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleMixedForGridAdapter(this) ;
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
                            removeMixed();
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
        if(position < adapter.numberOfAllMixeds()){
            if(adapter.isAppReleased){
                if(position == 0){
                    // リリース後は Deadline  のところだけ押せる
                    currentMixed = (MixedObject)adapter.getItem(position) ;

                    final String[] values = {"Audio","Video",getString(R.string.shoot_a_video)} ;
                    final List<Integer> checkedItems = new ArrayList<>();
                    new AlertDialog.Builder(this)
                            .setTitle(getString(R.string.upload))
                            .setSingleChoiceItems(values, -1, new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    checkedItems.clear();
                                    checkedItems.add(which);
                                }
                            })
                            .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    if (!checkedItems.isEmpty()) {
                                        int index = checkedItems.get(0);
                                        VeamUtil.log("debug","checkedItem:" + index);
                                        //String newText = values[index];
                                        if(index == 0){
                                            // Audio
                                            launchEditAudioActivity() ;
                                        } else if(index == 1){
                                            // Video
                                            launchEditVideoActivity() ;
                                        } else if(index == 2){
                                            // Shoot a Video
                                            launchShootVideoActivity() ;
                                        }
                                    }
                                }
                            })
                            .setNegativeButton("Cancel", null)
                            .show();
                }
            } else {
                currentMixed = (MixedObject)adapter.getItem(position) ;

                final String[] values = {"Audio","Video",getString(R.string.shoot_a_video)} ;
                final List<Integer> checkedItems = new ArrayList<>();
                new AlertDialog.Builder(this)
                        .setTitle(getString(R.string.upload))
                        .setSingleChoiceItems(values, -1, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                checkedItems.clear();
                                checkedItems.add(which);
                            }
                        })
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                if (!checkedItems.isEmpty()) {
                                    int index = checkedItems.get(0);
                                    VeamUtil.log("debug","checkedItem:" + index);
                                    if(index == 0){
                                        // Audio
                                        launchEditAudioActivity() ;
                                    } else if(index == 1){
                                        // Video
                                        launchEditVideoActivity() ;
                                    } else if(index == 2){
                                        // Shoot a Video
                                        launchShootVideoActivity() ;
                                    }
                                }
                            }
                        })
                        .setNegativeButton("Cancel", null)
                        .show();
            }
        }
    }

    public void launchEditAudioActivity(){
        String kind = currentMixed.getKind() ;
        if(kind.equals(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO)){
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO);
        } else if(kind.equals(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO)){
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO);
        } else {
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO);
        }

        Intent intent = new Intent(this,ConsoleEditAudioActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.done)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_MIXED_ID,currentMixed.getId()) ;
        intent.putExtra("MIXED_ID",currentMixed.getId()) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }

    public void launchEditVideoActivity(){

        String kind = currentMixed.getKind() ;
        if(kind.equals(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO)){
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO);
        } else if(kind.equals(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO)){
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO);
        } else {
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO);
        }

        Intent intent = new Intent(this,ConsoleEditVideoActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.done)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_MIXED_ID,currentMixed.getId()) ;
        intent.putExtra("MIXED_ID",currentMixed.getId()) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }

    public void launchShootVideoActivity(){

        String kind = currentMixed.getKind() ;
        if(kind.equals(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO)){
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO);
        } else if(kind.equals(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO)){
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO);
        } else {
            currentMixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO);
        }

        Intent intent = new Intent(this,ConsoleTakeSnapActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.done)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_MIXED_ID,currentMixed.getId()) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND,ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SUBSCRIPTION) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }

    public void removeMixed(){
        showFullscreenProgress();
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.removeMixedForCategory("0", indexToBeRemoved);
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
    public void onAdapterTitleClick(ConsoleAdapterElement element){
        VeamUtil.log("debug", "ConsoleMixedForGridActivity::onAdapterTitleClick") ;
        if(element != null){
            if(element.getElementId() == ConsoleMixedForGridAdapter.ELEMENTID_DESCRIPTION){
                Intent intent = new Intent(this, ConsoleEditSubscriptionDescriptionActivity.class) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
                //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
                intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.done)) ;
                startActivity(intent);
                overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
            }
        }
    }

    @Override
    protected void doUpdate(){
        VeamUtil.log("debug", "ConsoleMixedForGridActivity::doUpdate ");
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            consoleContents.updatePreparingMixedStatus("0");
        }
    }

    @Override
    protected int getFloatingMenuKind(){
        return FLOATING_MENU_KIND_EDIT_AND_TUTORIAL ;
    }

    @Override
    protected void launchTutorialActivity() {
        VeamUtil.log("debug","ConsoleMixedForGridActivity::launchTutorialActivity") ;
        Intent intent = new Intent(this,ConsoleTutorialActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_BACK) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.exclusive_tutorial)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,3) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,2) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND,ConsoleUtil.VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
    }

    @Override
    protected void startTutorialActivity() {
        VeamUtil.log("debug", "startTutorialActivity");
        this.launchTutorialActivity() ;
    }


}
