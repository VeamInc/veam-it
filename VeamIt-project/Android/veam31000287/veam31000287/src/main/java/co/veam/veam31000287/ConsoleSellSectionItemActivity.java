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
 * Created by veam on 12/13/16.
 */
public class ConsoleSellSectionItemActivity extends ConsoleActivity {

    private int indexToBeRemoved ;
    ConsoleSellSectionItemAdapter adapter ;
    SellSectionCategoryObject sellSectionCategory ;
    SellSectionItemObject currentSellSectionItem ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        needUpdateTimer = true ;

        Intent intent = getIntent() ;
        String sellSectionCategoryId = intent.getStringExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID) ;
        VeamUtil.log("debug", "sellSectionCategoryId=" + sellSectionCategoryId) ;
        if(!VeamUtil.isEmpty(sellSectionCategoryId)) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                sellSectionCategory = consoleContents.getSellSectionCategoryForId(sellSectionCategoryId);
                if(sellSectionCategory != null){
                    VeamUtil.log("debug","sellSectionCategoryId="+sellSectionCategory.getId()) ;
                    sellSectionCategory = consoleContents.getSellSectionCategoryForId(sellSectionCategory.getId()) ;
                }
            }
        }


        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleSellSectionItemAdapter(this,sellSectionCategory.getId()) ;
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
                            removeSellSectionItem();
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
            final String[] values = {"Video","PDF","Audio",getString(R.string.shoot_a_video)} ;
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
                                    launchEditVideoActivity("") ;
                                } else if(index == 1){
                                    launchEditPdfActivity("") ;
                                } else if(index == 2){
                                    launchEditAudioActivity("") ;
                                } else if(index == 3){
                                    launchShootVideoActivity("") ;
                                }
                            }
                        }
                    })
                    .setNegativeButton("Cancel", null)
                    .show();

        }
    }

    public void launchEditVideoActivity(String sellSectionItemId){
        Intent intent = new Intent(this,ConsoleEditSellSectionVideoActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.confirm)) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONITEM_ID,sellSectionItemId) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID,sellSectionCategory.getId()) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }

    public void launchEditPdfActivity(String sellSectionItemId){
        Intent intent = new Intent(this,ConsoleEditSellSectionPdfActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.confirm)) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONITEM_ID,sellSectionItemId) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID,sellSectionCategory.getId()) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }

    public void launchEditAudioActivity(String sellSectionItemId){
        Intent intent = new Intent(this,ConsoleEditSellSectionAudioActivity.class) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_LAUNCHFROMPREVIEW,true) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HIDEHEADERBOTTOMLINE,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERSTYLE,ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_CLOSE | ConsoleUtil.VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERTITLE,getString(R.string.required_app_information)) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_NUMBEROFHEADERDOTS,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELECTEDHEADERDOT,0) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SHOWFOOTER,false) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_CONTENTMODE,ConsoleUtil.VEAM_CONSOLE_SETTING_MODE) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_HEADERRIGHTTEXT,getString(R.string.confirm)) ;
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONITEM_ID,sellSectionItemId) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID,sellSectionCategory.getId()) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }

    public void launchShootVideoActivity(String sellSectionItemId){
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
        //intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONITEM_ID,sellSectionItemId) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_SELLSECTIONCATEGORY_ID,sellSectionCategory.getId()) ;
        intent.putExtra(ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND,ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SELLSECTION) ;
        startActivity(intent);
        overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
    }



    public void removeSellSectionItem(){
        showFullscreenProgress();
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        consoleContents.removeSellSectionItemForSellSectionCategory(sellSectionCategory.getId(), indexToBeRemoved);
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
        VeamUtil.log("debug", "ConsoleSellSectionItemActivity::doUpdate ");
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            consoleContents.updatePreparingSellSectionItemStatus(sellSectionCategory.getId());
        }
    }

    @Override
    protected int getFloatingMenuKind(){
        return FLOATING_MENU_KIND_EDIT ;
    }

}
