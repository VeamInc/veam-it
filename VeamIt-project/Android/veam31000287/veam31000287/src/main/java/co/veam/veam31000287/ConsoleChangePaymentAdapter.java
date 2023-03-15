package co.veam.veam31000287;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;

/**
 * Created by veam on 11/15/16.
 */
public class ConsoleChangePaymentAdapter extends ConsoleBaseAdapter {

    private String[] paymentTypeIds ;
    private int typeCount ;
    private String[] paymentTypes ;

    public ConsoleChangePaymentAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
        String[] workPaymentTypeIds = {
                ConsoleUtil.VEAM_SUBSCRIPTION_KIND_MIXED_GRID,
                ConsoleUtil.VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS,
                ConsoleUtil.VEAM_SUBSCRIPTION_KIND_SELL_SECTION
        };
        paymentTypeIds = workPaymentTypeIds ;
        typeCount = paymentTypeIds.length ;
        paymentTypes = new String[typeCount] ;
        for(int index = 0 ; index < typeCount ; index++){
            paymentTypes[index] = ConsoleUtil.getPaymentTypeString(paymentTypeIds[index],"$0.99") ;
        }
    }

    private String getPaymentTypeIdFor(String paymentTypeString){
        int targetIndex = -1 ;
        for(int index = 0 ; index < typeCount ; index++){
            if(paymentTypeString.equals(paymentTypes[index])){
                targetIndex = index ;
                break ;
            }
        }
        return paymentTypeIds[targetIndex] ;
    }

    @Override
    public int getCount() {
        return 1 ;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        if(position == 0) {
            String paymentTypeId = ConsoleUtil.getConsoleContents().templateSubscription.getKind() ;
            String price = ConsoleUtil.getConsoleContents().templateSubscription.getPrice() ;
            String paymentType = ConsoleUtil.getPaymentTypeString(paymentTypeId,price) ;
            item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, context.getString(R.string.payment_type), paymentType, paymentTypes);
        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue) {
        VeamUtil.log("debug", "ConsoleEditAppIntormationAdapter::setNewValue " + position + " " + newValue);
        if (position == 0) {
            consoleActivity.showFullscreenProgress();
            ConsoleUtil.getConsoleContents().setTemplateSubscriptionKind(getPaymentTypeIdFor(newValue));
        }
    }


    /*
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        VeamUtil.log("debug", "getView:" + position) ;
        View retView = null ;
        if(position == 0){
            String paymentTypeId = ConsoleUtil.getConsoleContents().templateSubscription.getKind() ;
            String price = ConsoleUtil.getConsoleContents().templateSubscription.getPrice() ;
            String paymentType = ConsoleUtil.getPaymentTypeString(paymentTypeId,price) ;
            retView = this.getLeftRightTextView(context.getString(R.string.payment_type),paymentType,ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK);
            retView.setTag(position);
        }

        return retView ;
    }
    */



}
