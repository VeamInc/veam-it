package co.veam.veam31000287;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by veam on 11/18/16.
 */
public class ConsoleAppStoreActivity extends ConsoleActivity {

    private static final int VIEWID_EDIT_BUTTON = VIEWID_BASE + 0x0001 ;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        ConsoleAppStoreAdapter adapter = new ConsoleAppStoreAdapter(this) ;
        this.addMainList(adapter);

        int editButtonHeight = deviceWidth * 44 / 320 ;
        RelativeLayout editButtonView = new RelativeLayout(this) ;
        editButtonView.setBackgroundColor(VeamUtil.getColorFromArgbString("FFF8F8F8")) ;
        editButtonView.setOnClickListener(this);
        editButtonView.setId(VIEWID_EDIT_BUTTON) ;
        mainView.addView(editButtonView, ConsoleUtil.getRelativeLayoutPrams(0, deviceHeight - editButtonHeight - ConsoleUtil.getStatusBarHeight(), deviceWidth, editButtonHeight));

        View separatorView = new View(this) ;
        separatorView.setBackgroundColor(Color.BLACK) ;
        editButtonView.addView(separatorView, ConsoleUtil.getRelativeLayoutPrams(0, 0, deviceWidth, 1)) ;

        TextView buttonLabel = new TextView(this) ;// [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], APP_STORE_EDIT_BUTTON_HEIGHT)] ;
        buttonLabel.setText(this.getString(R.string.edit_your_app_information)) ;
        buttonLabel.setTextColor(Color.BLACK) ;
        buttonLabel.setGravity(Gravity.CENTER);
        buttonLabel.setTextSize((float) deviceWidth * 4.0f / 100 / scaledDensity);
        buttonLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        editButtonView.addView(buttonLabel, ConsoleUtil.getRelativeLayoutPrams(0,0,deviceWidth,editButtonHeight)) ;

        int iconHeight = editButtonHeight * 80 / 100 ;
        ImageView iconImageView = new ImageView(this) ;//[[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth] - 33, 7, 30, 30)] ;
        iconImageView.setImageResource(R.drawable.c_edit_app) ;
        editButtonView.addView(iconImageView,ConsoleUtil.getRelativeLayoutPrams(deviceWidth-editButtonHeight,(editButtonHeight-iconHeight)/2,iconHeight,iconHeight)) ;

    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        VeamUtil.log("debug", "ConsoleAppStoreActivity::onClick ") ;
        if(v.getId() == VIEWID_EDIT_BUTTON){
            Intent intent = new Intent(this, ConsoleEditAppInformationActivity.class) ;
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
            overridePendingTransition(R.anim.push_up_in, R.anim.fadeout);
        }
    }

}
