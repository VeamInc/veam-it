package co.veam.veam31000287;

/**
 * Created by veam on 12/7/16.
 */
public class ConsoleForumAdapter extends ConsoleBaseAdapter {

    int cellCount ;

    public ConsoleForumAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            retValue = consoleContents.getNumberOfForums() ;
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
                ForumObject forumObject = consoleContents.getForumAt(position);
                if (forumObject != null) {
                    item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TEXT_ORDER_REMOVE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, forumObject.getName(), "", null);
                }
            }
        } else if(position == cellCount-1){
            item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TITLE_ONLY, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED, "+ " + consoleActivity.getString(R.string.add_new_theme), "", null);
        }
        return item ;
    }

    @Override
    public boolean isDraggable(){
        return true ;
    }

}
