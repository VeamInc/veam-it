package co.veam.veam31000287;

import android.graphics.Color;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.apache.http.HttpEntityEnclosingRequest;

import java.util.ArrayList;

/**
 * Created by veam on 11/18/16.
 */
public class ConsoleAppStoreAdapter extends ConsoleBaseAdapter {

    private int topMargin ;
    private int margin ;

    public ConsoleAppStoreAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
        margin = listWidth * 5 / 100 ;
    }

    @Override
    public int getCount() {
        return 9 ;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        VeamUtil.log("debug", "getView:" + position) ;
        View retView = null ;
        if(position == 0) {

            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
            AppInfo appInfo = consoleContents.appInfo ;
            RelativeLayout view = new RelativeLayout(AnalyticsApplication.getContext()) ;

            int iconSize = listWidth * 100 / 320 ;
            ImageView iconImageView = new ImageView(context) ;
            iconImageView.setImageBitmap(VeamUtil.getCachedFileBitmap(context, appInfo.getIconImageUrl(), false)) ;
            view.addView(iconImageView, ConsoleUtil.getRelativeLayoutPrams(margin, margin, iconSize, iconSize)) ;

            TextView titleLabel = new TextView(context) ;
            titleLabel.setText(consoleContents.appInfo.getStoreAppName());
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.RED) ;
            view.addView(titleLabel, ConsoleUtil.getRelativeLayoutPrams(listWidth * 130 / 320, listWidth * 15 / 320, listWidth * 175 / 320, listWidth * 7 / 100));

            TextView companyLabel = new TextView(context) ;
            companyLabel.setText("Veam Inc.");
            companyLabel.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
            companyLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            companyLabel.setTextColor(Color.BLACK) ;
            view.addView(companyLabel, ConsoleUtil.getRelativeLayoutPrams(listWidth * 130 / 320, listWidth * 10 / 100, listWidth * 175 / 320, listWidth * 5 / 100));

            TextView noteLabel = new TextView(context) ;
            noteLabel.setText(context.getString(R.string.app_store_offers_iap));
            noteLabel.setTextSize((float) listWidth * 3.0f / 100 / scaledDensity);
            noteLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            noteLabel.setTextColor(Color.GRAY) ;
            view.addView(noteLabel, ConsoleUtil.getRelativeLayoutPrams(listWidth * 130 / 320, listWidth * 15 / 100, listWidth * 175 / 320, listWidth * 4 / 100));

            ImageView reviewImageView = new ImageView(context) ;
            reviewImageView.setImageResource(R.drawable.app_store_review);
            view.addView(reviewImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth * 130 / 320, listWidth * 89 / 320, listWidth * 175 / 320, listWidth * 26 / 320)) ;

            ImageView barImageView = new ImageView(context) ;
            barImageView.setImageResource(R.drawable.c_store_bar);
            view.addView(barImageView, ConsoleUtil.getRelativeLayoutPrams(0, margin*2+iconSize, listWidth, listWidth*94/749)) ;


            /*
            self.reviewImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(130, 89, 175, 26)] ;
            self.reviewImageView.image = [UIImage imageNamed:@"app_store_review.png"] ;
            [self.contentView addSubview:self.reviewImageView] ;
            */


            //AppStoreSummaryTableViewCell *cell = [[AppStoreSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:contents.appInfo.storeAppName] ;
            retView = view ;

        } else if(position == 1){

            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;

            RelativeLayout view = new RelativeLayout(AnalyticsApplication.getContext()) ;
            view.setBackgroundColor(Color.TRANSPARENT) ;

            String url1 = consoleContents.appInfo.getScreenShot1Url() ;
            String url2 = consoleContents.appInfo.getScreenShot2Url() ;
            String url3 = consoleContents.appInfo.getScreenShot3Url() ;
            String url4 = consoleContents.appInfo.getScreenShot4Url() ;
            String url5 = consoleContents.appInfo.getScreenShot5Url() ;
            ArrayList<String> horizontalList = new ArrayList<>() ;
            if(!VeamUtil.isEmpty(url1)){
                horizontalList.add(url1);
            }
            if(!VeamUtil.isEmpty(url2)){
                horizontalList.add(url2);
            }
            if(!VeamUtil.isEmpty(url3)){
                horizontalList.add(url3);
            }
            if(!VeamUtil.isEmpty(url4)){
                horizontalList.add(url4);
            }
            if(!VeamUtil.isEmpty(url5)){
                horizontalList.add(url5);
            }

            RecyclerView screenShotView = new RecyclerView(context) ;
            LinearLayoutManager horizontalLayoutManagaer = new LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false);
            screenShotView.setLayoutManager(horizontalLayoutManagaer);
            ConsoleScreenShotAdapter horizontalAdapter = new ConsoleScreenShotAdapter(horizontalList,listWidth);
            screenShotView.setAdapter(horizontalAdapter);

            view.addView(screenShotView, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, listWidth));

            retView = view ;
            //retView.setTag(position);
        } else if(position == 2){
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
            //RelativeLayout view = new RelativeLayout(AnalyticsApplication.getContext()) ;
            LinearLayout view = new LinearLayout(AnalyticsApplication.getContext()) ;
            view.setOrientation(LinearLayout.VERTICAL);

            View lineView = new View(context) ;
            lineView.setBackgroundColor(Color.BLACK);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(listWidth-margin*2,1) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(lineView, params) ;


            TextView titleLabel = new TextView(context) ;
            titleLabel.setText("Description");
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, listWidth * 8 / 100) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(titleLabel, params);

            TextView descriptionLabel = new TextView(context) ;
            descriptionLabel.setText(consoleContents.appInfo.getDescription());
            descriptionLabel.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
            descriptionLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            descriptionLabel.setTextColor(Color.RED) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, LinearLayout.LayoutParams.WRAP_CONTENT) ;
            params.setMargins(margin, margin, margin, 0) ;
            view.addView(descriptionLabel, params);

            retView = view ;
        } else if(position == 3){
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
            //RelativeLayout view = new RelativeLayout(AnalyticsApplication.getContext()) ;
            LinearLayout view = new LinearLayout(AnalyticsApplication.getContext()) ;
            view.setOrientation(LinearLayout.VERTICAL);

            View lineView = new View(context) ;
            lineView.setBackgroundColor(Color.BLACK);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(listWidth-margin*2,1) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(lineView, params) ;


            TextView titleLabel = new TextView(context) ;
            titleLabel.setText("Information");
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, listWidth * 8 / 100) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(titleLabel, params);

            int leftWidth = listWidth * 25 / 100 ;
            int gap = listWidth * 5 / 100 ;
            int rightWidth = listWidth - leftWidth - gap - margin * 2 ;
            int lineMargin = listWidth * 2 / 100 ;

            params = new LinearLayout.LayoutParams(listWidth - margin * 2, LinearLayout.LayoutParams.WRAP_CONTENT) ;
            params.setMargins(margin, lineMargin, 0, 0);
            view.addView(this.getPairTextView(leftWidth, gap, rightWidth, "Seller", Color.GRAY, "Veam Inc.", Color.BLACK), params) ;
            view.addView(this.getPairTextView(leftWidth,gap,rightWidth,"Developer",Color.GRAY,"Veam Inc.",Color.BLACK),params) ;
            view.addView(this.getPairTextView(leftWidth,gap,rightWidth,"Category",Color.RED,consoleContents.appInfo.getCategory(),Color.RED),params) ;
            view.addView(this.getPairTextView(leftWidth,gap,rightWidth,"Updated",Color.GRAY,"2016/11/21",Color.BLACK),params) ;
            view.addView(this.getPairTextView(leftWidth,gap,rightWidth,"Version",Color.GRAY,"1.0",Color.BLACK),params) ;
            view.addView(this.getPairTextView(leftWidth,gap,rightWidth,"Size",Color.GRAY,"6.8 MB",Color.BLACK),params) ;
            view.addView(this.getPairTextView(leftWidth,gap,rightWidth,"Rating",Color.RED,"4+",Color.RED),params) ;
            view.addView(this.getPairTextView(leftWidth,gap,rightWidth,"Compatibility",Color.GRAY,"Required Android 2.3 or later.",Color.BLACK),params) ;



            retView = view ;
        } else if(position == 4){
            LinearLayout view = new LinearLayout(AnalyticsApplication.getContext()) ;
            view.setOrientation(LinearLayout.VERTICAL);

            View lineView = new View(context) ;
            lineView.setBackgroundColor(Color.BLACK);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(listWidth-margin*2,1) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(lineView, params) ;


            TextView titleLabel = new TextView(context) ;
            titleLabel.setText("In-App Purchases");
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, listWidth * 8 / 100) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(titleLabel, params);

            retView = view ;
        } else if(position == 5){
            LinearLayout view = new LinearLayout(AnalyticsApplication.getContext()) ;
            view.setOrientation(LinearLayout.VERTICAL);

            View lineView = new View(context) ;
            lineView.setBackgroundColor(Color.BLACK);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(listWidth-margin*2,1) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(lineView, params) ;


            TextView titleLabel = new TextView(context) ;
            titleLabel.setText("Version History");
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, listWidth * 8 / 100) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(titleLabel, params);

            retView = view ;
        } else if(position == 6){
            LinearLayout view = new LinearLayout(AnalyticsApplication.getContext()) ;
            view.setOrientation(LinearLayout.VERTICAL);

            View lineView = new View(context) ;
            lineView.setBackgroundColor(Color.BLACK);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(listWidth-margin*2,1) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(lineView, params) ;


            TextView titleLabel = new TextView(context) ;
            titleLabel.setText("Privacy Policy");
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, listWidth * 8 / 100) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(titleLabel, params);

            retView = view ;
        } else if(position == 7){
            LinearLayout view = new LinearLayout(AnalyticsApplication.getContext()) ;
            view.setOrientation(LinearLayout.VERTICAL);

            View lineView = new View(context) ;
            lineView.setBackgroundColor(Color.BLACK);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(listWidth-margin*2,1) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(lineView, params) ;


            TextView titleLabel = new TextView(context) ;
            titleLabel.setText("Developer Apps");
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, listWidth * 8 / 100) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(titleLabel, params);

            retView = view ;
        } else if(position == 8){
            LinearLayout view = new LinearLayout(AnalyticsApplication.getContext()) ;
            view.setOrientation(LinearLayout.VERTICAL);

            View lineView = new View(context) ;
            lineView.setBackgroundColor(Color.BLACK);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(listWidth-margin*2,1) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(lineView, params) ;


            TextView titleLabel = new TextView(context) ;
            titleLabel.setText(" ");
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            params = new LinearLayout.LayoutParams(listWidth - margin * 2, listWidth * 8 / 100) ;
            params.setMargins(margin, margin, 0, 0) ;
            view.addView(titleLabel, params);

            retView = view ;
        }

        return retView ;
    }

    public RelativeLayout getPairTextView(int leftWidth,int gap,int rightWidth,String text1,int color1,String text2,int color2){
        RelativeLayout relativeLayout = new RelativeLayout(AnalyticsApplication.getContext()) ;

        TextView leftLabel = new TextView(context) ;
        leftLabel.setText(text1);
        leftLabel.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
        leftLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        leftLabel.setTextColor(color1) ;
        leftLabel.setGravity(Gravity.RIGHT);
        relativeLayout.addView(leftLabel, ConsoleUtil.getRelativeLayoutPrams(0, 0, leftWidth, RelativeLayout.LayoutParams.WRAP_CONTENT));

        TextView rightLabel = new TextView(context) ;
        rightLabel.setText(text2);
        rightLabel.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
        rightLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        rightLabel.setTextColor(color2) ;
        rightLabel.setGravity(Gravity.LEFT);
        relativeLayout.addView(rightLabel, ConsoleUtil.getRelativeLayoutPrams(leftWidth+gap,0,rightWidth,RelativeLayout.LayoutParams.WRAP_CONTENT));

        return relativeLayout ;
    }

}
