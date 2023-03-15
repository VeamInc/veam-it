package co.veam.veam31000287;

import android.util.Log;

import com.dropbox.client2.DropboxAPI;

/**
 * Created by veam on 12/1/16.
 */
public class ConsoleDropboxAdapter  extends ConsoleBaseAdapter {

    public static final int ELEMENTID_DIRECTORY = 1 ;
    public static final int ELEMENTID_FILE = 2 ;

    DropboxAPI.Entry entry ;

    public ConsoleDropboxAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
    }

    public void setEntry(DropboxAPI.Entry entry){
        this.entry = entry ;
    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        if(entry == null){
            retValue = 0 ;
        } else {
            retValue = entry.contents.size() ;
        }
        return retValue ;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        if((entry == null) || (entry.contents == null)){
            item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SPACER,0,"","",null);
        } else {
            if(position < entry.contents.size()){
                DropboxAPI.Entry file = entry.contents.get(position) ;
                if(file.isDir){
                    item = new ConsoleAdapterElement(ELEMENTID_DIRECTORY,ConsoleAdapterElement.KIND_TITLE_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, file.fileName(),"",null);
                } else {
                    String description = String.format("%s, modified %s",this.getSizeString(file.bytes),file.modified.substring(0,22)) ;
                    item = new ConsoleAdapterElement(ELEMENTID_FILE,ConsoleAdapterElement.KIND_TITLE_AND_DESCRIPTION, ConsoleBaseAdapter.COLOR_TYPE_ALL_BLACK, file.fileName(),description,null);
                }
            } else {
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SPACER,0,"","",null);
            }
        }
        return item ;
    }

    private String getSizeString(long size)
    {
        float convertedSize = 0 ;
        String unit = "" ;
        float giga = 1024*1024*1024 ;
        float mega = 1024*1024 ;
        float kilo = 1024 ;
        if(size >= giga){
            unit = "GB" ;
            convertedSize = size / giga ;
        } else if(size >= mega){
            unit = "MB" ;
            convertedSize = size / mega ;
        } else if(size >= kilo){
            unit = "KB" ;
            convertedSize = size / kilo ;
        } else {
            unit = "B" ;
            convertedSize = size ;
        }

        String sizeString = String.format("%.1f %s",convertedSize,unit) ;
        return sizeString ;
    }

    @Override
    public void onTitleClick(int position,String title){
        VeamUtil.log("debug", "onTitleClick : " + position + " : " + title) ;
        Object item = getItem(position) ;
        if(item != null){
            if(item instanceof ConsoleAdapterElement){
                ConsoleAdapterElement element = (ConsoleAdapterElement)item ;
                consoleActivity.onAdapterTitleClick(element) ;
            }
        }
    }


}
