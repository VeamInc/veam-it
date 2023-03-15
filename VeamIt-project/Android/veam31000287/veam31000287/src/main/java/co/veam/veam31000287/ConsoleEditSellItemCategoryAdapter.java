package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 12/12/16.
 */
public class ConsoleEditSellItemCategoryAdapter extends ConsoleBaseAdapter {

    private String title ;
    private String kindId ;

    String[] kindNames = {"Video","PDF","Audio"} ;
    String[] kindIds = {"1","2","3"} ;

    public ConsoleEditSellItemCategoryAdapter(ConsoleActivity consoleActivity,String title,String kindId)
    {
        super(consoleActivity) ;

        if(title == null){
            this.title = "" ;
        } else {
            this.title = title;
        }

        if(kindId == null){
            this.kindId = "" ;
        } else {
            this.kindId = kindId;
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
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,"Category", " ",null);
                break ;
            case 1:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.title), title,null);
                break ;
            case 2:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.category_kind), getKindName(kindId),kindNames);
                break ;
        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "ConsoleEditSellItemCategoryAdapter::setNewValue " + position + " " + newValue) ;
        switch (position){
            case 1:
                title = newValue ;
                break ;
            case 2:
                kindId = this.getKindIdFor(newValue) ;
                VeamUtil.log("debug", "kindId="+kindId) ;
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

    public String getKindId() {
        return kindId;
    }

    public void setKindId(String kindId) {
        this.kindId = kindId;
    }

    public String getKindName(String kindId){
        String kindName = "" ;
        if(!VeamUtil.isEmpty(kindId)) {
            int length = kindIds.length;
            for (int index = 0; index < length; index++) {
                if (kindIds[index].equals(kindId)) {
                    kindName = kindNames[index];
                    break;
                }
            }
        }
        return kindName ;
    }

    private String getKindIdFor(String kindName){
        String kindId = "" ;
        if(!VeamUtil.isEmpty(kindName)) {
            int length = kindNames.length;
            for (int index = 0; index < length; index++) {
                if (kindNames[index].equals(kindName)) {
                    kindId = kindIds[index];
                    break;
                }
            }
        }
        return kindId ;
    }
}
