package co.veam.veam31000287;

/**
 * Created by veam on 12/9/16.
 */
public class ConsoleSellItemCategoryAdapter extends ConsoleBaseAdapter {

    int cellCount ;

    public ConsoleSellItemCategoryAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            retValue = consoleContents.getNumberOfSellItemCategories() ;
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
                SellItemCategoryObject sellItemCategoryObject = consoleContents.getSellItemCategoryAt(position);
                if (sellItemCategoryObject != null) {
                    item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TEXT_ORDER_REMOVE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, this.getSellItemCategoryName(sellItemCategoryObject), "", null);
                }
            }
        } else if(position == cellCount-1){
            item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TITLE_ONLY, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED, "+ " + consoleActivity.getString(R.string.add_new_category), "", null);
        }
        return item ;
    }

    public String getSellItemCategoryName(SellItemCategoryObject sellItemCategoryObject){
        String name = "" ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        name = consoleContents.getCategoryTitleForSellItemCategory(sellItemCategoryObject) ;
        return name ;
    }

    @Override
    public boolean isDraggable(){
        return true ;
    }

}
