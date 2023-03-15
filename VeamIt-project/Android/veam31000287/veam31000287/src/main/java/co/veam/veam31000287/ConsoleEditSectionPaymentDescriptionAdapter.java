package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 12/13/16.
 */
public class ConsoleEditSectionPaymentDescriptionAdapter extends ConsoleBaseAdapter {

    private String description ;

    public ConsoleEditSectionPaymentDescriptionAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;

        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
        description = consoleContents.getValueForKey(ConsoleUtil.CONSOLE_SECTION_PAYMENT_DESCRIPTION_KEY) ;
    }

    @Override
    public int getCount() {
        return 1;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        switch (position){
            case 0:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_LONG_TEXT, ConsoleBaseAdapter.COLOR_TYPE_TOP_RED,context.getString(R.string.description_before_purchasing), description,null);
                break ;
        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "ConsoleEditSectionPaymentDescriptionAdapter::setNewValue " + position + " " + newValue) ;
        switch (position){
            case 0:
                description = newValue ;
                break ;
        }

    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        VeamUtil.log("debug", "getView:" + position) ;
        View retView = getDefaultView(position,convertView) ;
        return retView ;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
