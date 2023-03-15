package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 12/7/16.
 */
public class ConsoleEditWebAdapter extends ConsoleBaseAdapter {

    private String title ;
    private String url ;

    public ConsoleEditWebAdapter(ConsoleActivity consoleActivity,String title,String url)
    {
        super(consoleActivity) ;

        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
        if(title == null){
            this.title = "" ;
        } else {
            this.title = title;
        }

        if(url == null){
            this.url = "" ;
        } else {
            this.url = url;
        }
    }

    @Override
    public int getCount() {
        return 3;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        switch (position){
            case 0:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,"URL", " ",null);
                break ;
            case 1:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.title), title,null);
                break ;
            case 2:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,"URL", url,null);
                break ;
        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "ConsoleEditWebAdapter::setNewValue " + position + " " + newValue) ;
        switch (position){
            case 1:
                title = newValue ;
                break ;
            case 2:
                url = newValue ;
                break ;
            case 5:
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
