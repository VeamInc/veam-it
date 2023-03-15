package co.veam.veam31000287;

import android.util.Log;

/**
 * Created by veam on 12/6/16.
 */
public class ConsoleYoutubeCategoryAdapter extends ConsoleBaseAdapter {

    public ConsoleYoutubeCategoryAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            retValue = consoleContents.getNumberOfYoutubeCategories() ;
        }
        return retValue ;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            YoutubeCategoryObject youtubeCategoryObject = consoleContents.getYoutubeCategoryAt(position) ;
            if(youtubeCategoryObject != null) {
                item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TEXT_ORDER_STOP, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, youtubeCategoryObject.getName(),youtubeCategoryObject.getDisabled(),null);
            }
        }
        return item ;
    }

    @Override
    public boolean isDraggable(){
        return true ;
    }

}
