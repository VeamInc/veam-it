package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.RelativeLayout;

/**
 * Created by veam on 11/24/16.
 */
public class ConsoleEditRatingActivity extends ConsoleActivity {

    ConsoleEditRatingAdapter adapter ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleEditRatingAdapter(this) ;
        this.addMainList(adapter);

    }

    @Override
    public void onHeaderCloseClicked(View v) {
        VeamUtil.log("debug", "ConsoleActivity::onHeaderRightTextClicked ") ;
        this.finishVertical();
    }

}
