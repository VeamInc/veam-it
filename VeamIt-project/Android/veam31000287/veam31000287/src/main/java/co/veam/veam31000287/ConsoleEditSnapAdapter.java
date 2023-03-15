package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 12/8/16.
 */
public class ConsoleEditSnapAdapter extends ConsoleBaseAdapter {

    private String title ;
    private int uploadKind ;
    private String price ;
    private String[] prices ;
    private String description ;

    public ConsoleEditSnapAdapter(ConsoleActivity consoleActivity,int uploadKind)
    {
        super(consoleActivity) ;

        title = "" ;
        this.uploadKind = uploadKind ;
        price = "" ;
        description = "" ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        String priceKey = "subscription_prices" ;
        if(VeamUtil.isLocaleJapanese()){
            priceKey = "subscription_prices_ja" ;
        }
        prices = consoleContents.getValueForKey(priceKey).split("\\|") ;

        modified = true ;

    }



    @Override
    public int getCount() {
        int retValue = 0 ;
        if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SUBSCRIPTION){
            retValue = 2 ;
        } else if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SELLVIDEO){
            retValue = 4 ;
        } else if(uploadKind == ConsoleUtil.VEAM_CONSOLE_UPLOAD_KIND_SELLSECTION){
            retValue = 2 ;
        }
        return retValue;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        switch (position){
            case 0:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,context.getString(R.string.upload_video_to_veam_cloud), " ",null);
                break ;
            case 1:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.title), title,null);
                break ;
            case 2:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.ppc_price), price,prices);
                break ;
            case 3:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_LONG_TEXT, ConsoleBaseAdapter.COLOR_TYPE_TOP_RED,context.getString(R.string.description), description,null);
                break ;
        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "setNewValue " + position + " " + newValue) ;
        switch (position){
            case 1:
                title = newValue ;
                break ;
            case 2:
                price = newValue ;
                break ;
            case 3:
                description = newValue ;
                break ;
            default:
                // should not be here
                break ;
        }

    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        VeamUtil.log("debug", "getView:" + position) ;
        View retView = getDefaultView(position,convertView) ;
        return retView ;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
