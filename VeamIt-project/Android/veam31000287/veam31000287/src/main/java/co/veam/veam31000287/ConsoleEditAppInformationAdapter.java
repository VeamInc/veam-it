package co.veam.veam31000287;

import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import java.io.Console;

/**
 * Created by veam on 11/21/16.
 */
public class ConsoleEditAppInformationAdapter extends ConsoleBaseAdapter {

    private String appName ;
    private String appStoreName ;
    private String description ;
    private String keyword ;
    private String category ;
    private String[] categories ;

    public ConsoleEditAppInformationAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;

        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
        appName = consoleContents.appInfo.getName();
        appStoreName = consoleContents.appInfo.getStoreAppName();
        description = consoleContents.appInfo.getDescription();
        keyword = consoleContents.appInfo.getKeyword();
        category = consoleContents.appInfo.getCategory();
        categories = consoleContents.getAppCategories() ;
    }



    @Override
    public int getCount() {
        return 6;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        switch (position){
            case 0:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.app_info_app_name), appName,null);
                break ;
            case 1:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.app_info_store_app_name), appStoreName,null);
                break ;
            case 2:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_LONG_TEXT, ConsoleBaseAdapter.COLOR_TYPE_TOP_RED,context.getString(R.string.app_info_description), description,null);
                break ;
            case 3:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_LONG_TEXT, ConsoleBaseAdapter.COLOR_TYPE_TOP_RED,context.getString(R.string.app_info_keywords), keyword,null);
                break ;
            case 4:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.app_info_category), category,categories);
                break ;
            case 5:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_TITLE_ONLY, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.app_info_rating), " ",null);
                break ;
        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "ConsoleEditAppIntormationAdapter::setNewValue " + position + " " + newValue) ;
        switch (position){
            case 0:
                appName = newValue ;
                break ;
            case 1:
                appStoreName = newValue ;
                break ;
            case 2:
                description = newValue ;
                break ;
            case 3:
                keyword = newValue ;
                break ;
            case 4:
                category = newValue ;
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

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }

    public String getAppStoreName() {
        return appStoreName;
    }

    public void setAppStoreName(String appStoreName) {
        this.appStoreName = appStoreName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
