package co.veam.veam31000287;

/**
 * Created by veam on 12/12/16.
 */
public class ConsoleSellSectionCategoryAdapter extends ConsoleBaseAdapter {

    int cellCount ;

    public static final int ELEMENTID_PRICE = 1 ;
    public static final int ELEMENTID_SECTION_DESCRIPTION = 2 ;
    public static final int ELEMENTID_DESCRIPTION_BEFORE_PURCHASING = 3 ;


    private static final int POSITION_SET_THE_PRICE = 1 ;
    private static final int POSITION_DESCRIPTION_BEFORE_PURCHASING = 2 ;
    private static final int POSITION_SECTION_DESCRIPTION = 3 ;
    private static final int POSITION_SECTION_INFO_TITLE = 4 ;
    private static final int POSITION_ADD_NEW_CATEGORY = 5 ;

    private String[] prices ;
    private String price ;

    public ConsoleSellSectionCategoryAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;

        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        String priceKey = "subscription_prices" ;
        if(VeamUtil.isLocaleJapanese()){
            priceKey = "subscription_prices_ja" ;
        }
        prices = consoleContents.getValueForKey(priceKey).split("\\|") ;

    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            retValue = consoleContents.getNumberOfSellSectionCategories() ;
            price = consoleContents.templateSubscription.getPrice() ;
        }
        retValue += 5 ; // + Add New Theme

        cellCount = retValue ;

        return retValue ;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        if(position < cellCount-POSITION_ADD_NEW_CATEGORY) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                SellSectionCategoryObject sellSectionCategoryObject = consoleContents.getSellSectionCategoryAt(position);
                if (sellSectionCategoryObject != null) {
                    item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TEXT_ORDER_REMOVE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, sellSectionCategoryObject.getName(), "", null);
                }
            }
        } else if(position == cellCount-POSITION_ADD_NEW_CATEGORY){
            item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TITLE_ONLY, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED, "+ " + consoleActivity.getString(R.string.add_new_category), "", null);
        } else if(position == cellCount-POSITION_SECTION_INFO_TITLE){
            item = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, consoleActivity.getString(R.string.section_information), "", null);
        } else if(position == cellCount-POSITION_SECTION_DESCRIPTION){
            item = new ConsoleAdapterElement(ELEMENTID_SECTION_DESCRIPTION, ConsoleAdapterElement.KIND_TITLE_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED, consoleActivity.getString(R.string.description_of_this_section), "", null);
        } else if(position == cellCount-POSITION_DESCRIPTION_BEFORE_PURCHASING){
            item = new ConsoleAdapterElement(ELEMENTID_DESCRIPTION_BEFORE_PURCHASING, ConsoleAdapterElement.KIND_TITLE_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED, consoleActivity.getString(R.string.description_before_purchasing), "", null);
        } else if(position == cellCount-POSITION_SET_THE_PRICE){
            item = new ConsoleAdapterElement(ELEMENTID_PRICE, ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, consoleActivity.getString(R.string.set_the_price), price, prices);
        }
        return item ;
    }

    @Override
    public boolean isDraggable(){
        return true ;
    }

    @Override
    public void setNewValue(int position,String newValue) {
        //VeamUtil.log("debug", "ConsoleMixedForGridAdapter::setNewValue " + position + " " + newValue);
        Object item = getItem(position) ;
        if(item != null){
            if(item instanceof ConsoleAdapterElement){
                ConsoleAdapterElement element = (ConsoleAdapterElement)item ;
                if(element.getElementId() == ELEMENTID_PRICE){
                    consoleActivity.showFullscreenProgress();
                    ConsoleUtil.getConsoleContents().setTemplateSubscriptionPrice(newValue);
                }
            }
        }
    }

    @Override
    public void onTitleClick(int position,String title){
        //VeamUtil.log("debug","onTitleClick : " + position + " : " + title) ;
        Object item = getItem(position) ;
        if(item != null){
            if(item instanceof ConsoleAdapterElement){
                ConsoleAdapterElement element = (ConsoleAdapterElement)item ;
                consoleActivity.onAdapterTitleClick(element) ;
            }
        }
    }


}
