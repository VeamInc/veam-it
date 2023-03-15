package co.veam.veam31000287;

/**
 * Created by veam on 12/7/16.
 */
public class ConsoleWebAdapter extends ConsoleBaseAdapter {

    int cellCount ;

    public ConsoleWebAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            retValue = consoleContents.getNumberOfWebs() ;
        }
        retValue++ ; // + Add New Theme

        cellCount = retValue ;

        return retValue ;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        if(position < cellCount-1) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                WebObject webObject = consoleContents.getWebAt(position);
                if (webObject != null) {
                    item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TEXT_ORDER_REMOVE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, webObject.getTitle(), "", null);
                }
            }
        } else if(position == cellCount-1){
            item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TITLE_ONLY, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED, "+ " + consoleActivity.getString(R.string.add_new_url), "", null);
        }
        return item ;
    }

    @Override
    public boolean isDraggable(){
        return true ;
    }

}
