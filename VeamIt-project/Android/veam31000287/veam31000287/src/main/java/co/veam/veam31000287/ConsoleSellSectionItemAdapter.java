package co.veam.veam31000287;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by veam on 12/13/16.
 */
public class ConsoleSellSectionItemAdapter extends ConsoleBaseAdapter {

    int cellCount ;
    String sellSectionCategoryId ;

    private int CELL_HEIGHT ;
    private int CELL_LEFTMARGIN ;
    private int CELL_RIGHTMARGIN ;


    public ConsoleSellSectionItemAdapter(ConsoleActivity consoleActivity,String sellSectionCategoryId)
    {
        super(consoleActivity) ;

        this.sellSectionCategoryId = sellSectionCategoryId ;

        CELL_HEIGHT = listWidth * 88 / 320 ;
        CELL_LEFTMARGIN = listWidth * 10 / 320 ;
        CELL_RIGHTMARGIN = listWidth * 6 / 320 ;
    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        if(consoleContents != null){
            retValue = consoleContents.getNumberOfSellSectionItemsForSellSectionCategory(sellSectionCategoryId) ;
        }
        retValue++ ; // + Add New

        cellCount = retValue ;

        return retValue ;
    }

    @Override
    public Object getItem(int position) {
        Object item = null ;
        if(position < cellCount-1) {
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
            if (consoleContents != null) {
                SellSectionItemObject sellSectionItemObject = consoleContents.getSellSectionItemForSellSectionCategory(sellSectionCategoryId, position, 0) ;
                item = (Object)sellSectionItemObject ;
            }
        } else if(position == cellCount-1){
            ConsoleAdapterElement adapterElement = new ConsoleAdapterElement(0, ConsoleAdapterElement.KIND_TITLE_ONLY, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED, "+ " + consoleActivity.getString(R.string.add_new_item), "", null);
            item = (Object)adapterElement ;
        }
        return item ;
    }

    /*
    @Override
    public boolean isDraggable(){
        return true ;
    }
    */

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        //VeamUtil.log("debug", "getView:" + position) ;
        View cell = null ;
        if(position == cellCount-1){
            cell = this.getDefaultView(position,convertView) ;
        } else if(position < cellCount-1){
            int thumbnailWidth = listWidth * 90 / 320  ;
            int thumbnailHeight = listWidth * 68 / 320  ;
            int deleteButtonWidth = listWidth * 27 / 320 ;
            int deleteButtonHeight = listWidth * 44 / 320 ;
            int titleHeight = CELL_HEIGHT * 70 / 100 ;
            int priceHeight = CELL_HEIGHT * 30 / 100 ;
            boolean isLast = (position == (cellCount-2)) ;
            SellSectionItemObject sellSectionItem = (SellSectionItemObject)this.getItem(position) ;
            RelativeLayout workCell = new RelativeLayout(consoleActivity) ;

            ImageView deleteImageView = new ImageView(consoleActivity) ;
            deleteImageView.setId(ConsoleActivity.VIEWID_LIST_DELETE);
            deleteImageView.setImageResource(R.drawable.list_delete_on);
            deleteImageView.setOnClickListener(consoleActivity);
            deleteImageView.setTag(Integer.valueOf(position)) ;
            workCell.addView(deleteImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth - CELL_RIGHTMARGIN - deleteButtonWidth, (CELL_HEIGHT - deleteButtonHeight) / 2, deleteButtonWidth, deleteButtonHeight)) ;

            String thumbnailUrl = ConsoleUtil.getThumbnailUrlFromSellSectionItem(sellSectionItem) ;
            String title = sellSectionItem.getTitle() ;
            String price = ConsoleUtil.getSellSectionItemKindString(sellSectionItem) ;

            ImageView thumbnailImageView = new ImageView(consoleActivity) ;
            thumbnailImageView.setTag(Integer.valueOf(position)) ;
            if(!VeamUtil.isEmpty(thumbnailUrl)){
                Bitmap thumbnailImage = VeamUtil.getCachedFileBitmap(consoleActivity, thumbnailUrl, false) ;
                if(thumbnailImage == null){
                    thumbnailImageView.setImageDrawable(new ColorDrawable(Color.argb(0, 0, 0, 0))) ;
                    LoadImageTask loadImageTask = new LoadImageTask(consoleActivity,thumbnailUrl,thumbnailImageView,thumbnailWidth,position,null) ;
                    loadImageTask.execute("") ;

                } else {
                    thumbnailImageView.setImageBitmap(thumbnailImage) ;
                }
            }
            workCell.addView(thumbnailImageView,ConsoleUtil.getRelativeLayoutPrams(CELL_LEFTMARGIN,(CELL_HEIGHT-thumbnailHeight)/2, thumbnailWidth, thumbnailHeight));

            int titleX = CELL_LEFTMARGIN + thumbnailWidth + listWidth * 12 / 320 ;

            TextView titleLabel = new TextView(consoleActivity) ;
            titleLabel.setText(title) ;
            titleLabel.setGravity(Gravity.CENTER_VERTICAL);
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            workCell.addView(titleLabel, ConsoleUtil.getRelativeLayoutPrams(titleX, 0, listWidth - titleX - deleteButtonWidth - CELL_RIGHTMARGIN, titleHeight)) ;

            TextView priceLabel = new TextView(consoleActivity) ;
            priceLabel.setText(price) ;
            priceLabel.setGravity(Gravity.TOP|Gravity.LEFT);
            priceLabel.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
            priceLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            priceLabel.setTextColor(Color.BLACK) ;
            workCell.addView(priceLabel, ConsoleUtil.getRelativeLayoutPrams(titleX, titleHeight, listWidth - titleX - deleteButtonWidth - CELL_RIGHTMARGIN, priceHeight)) ;


            VeamUtil.log("debug", "id=" + sellSectionItem.getId() + " status=" + sellSectionItem.getStatus()) ;
            if(sellSectionItem.getStatus().equals(ConsoleUtil.VEAM_SELL_SECTION_ITEM_STATUS_READY)){
                titleLabel.setTextColor(Color.BLACK) ;
                priceLabel.setTextColor(Color.BLACK) ;
            } else {
                thumbnailImageView.setBackgroundColor(Color.RED) ;

                if(sellSectionItem.getStatus().equals(ConsoleUtil.VEAM_SELL_SECTION_ITEM_STATUS_SUBMITTING)){
                    TextView statusBlackLabel = new TextView(context) ;
                    statusBlackLabel.setTextSize((float) listWidth * 10.0f / 100 / scaledDensity);
                    statusBlackLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
                    statusBlackLabel.setText(sellSectionItem.getStatusText()) ;
                    statusBlackLabel.setTextColor(Color.BLACK) ;
                    statusBlackLabel.setGravity(Gravity.CENTER) ;
                    workCell.addView(statusBlackLabel, ConsoleUtil.getRelativeLayoutPrams(CELL_LEFTMARGIN + thumbnailWidth * 10 / 100 + 1, (CELL_HEIGHT - thumbnailHeight) / 2 + 1, thumbnailWidth*80/100, thumbnailHeight));
                    ConsoleUtil.setTextSizeWithin(thumbnailWidth*75/100,statusBlackLabel);
                }

                TextView statusLabel = new TextView(context) ;
                statusLabel.setTextSize((float) listWidth * 10.0f / 100 / scaledDensity);
                statusLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
                statusLabel.setText(sellSectionItem.getStatusText()) ;
                statusLabel.setTextColor(Color.WHITE) ;
                statusLabel.setGravity(Gravity.CENTER) ;
                workCell.addView(statusLabel, ConsoleUtil.getRelativeLayoutPrams(CELL_LEFTMARGIN + thumbnailWidth * 10 / 100, (CELL_HEIGHT - thumbnailHeight) / 2, thumbnailWidth*80/100, thumbnailHeight));
                ConsoleUtil.setTextSizeWithin(thumbnailWidth*75/100,statusLabel);

                if(sellSectionItem.getStatusText().equals("Preparing")){
                    ConsoleUtil.startViewBlinking(statusLabel);
                }

                titleLabel.setTextColor(VeamUtil.getColorFromArgbString("FFB4B4B4")) ;
                priceLabel.setTextColor(VeamUtil.getColorFromArgbString("FFB4B4B4")) ;
                //self.moveImageView.image = moveOffImage ;
            }

            workCell.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(0, CELL_HEIGHT - 1, listWidth, 1));

            cell = workCell ;
        } else {
            cell = getDefaultView(position,convertView) ;
        }

        if(cell == null){
            cell = new RelativeLayout(consoleActivity) ;
        }

        return cell;
    }


}
