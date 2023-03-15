package co.veam.veam31000287;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.provider.ContactsContract;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by veam on 11/29/16.
 */
public class ConsoleMixedForGridAdapter extends ConsoleBaseAdapter {

    public boolean isAppReleased ;
    private int numberOfMixeds ;
    private ArrayList<MixedObject> mixeds ;

    private int CONSOLE_MIXED_CELL_HEIGHT ;
    private int CONSOLE_MIXED_CELL_LEFTMARGIN ;
    private int CONSOLE_MIXED_CELL_RIGHTMARGIN ;

    public static final int ELEMENTID_PRICE = 1 ;
    public static final int ELEMENTID_DESCRIPTION = 2 ;


    public ConsoleMixedForGridAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;
        CONSOLE_MIXED_CELL_HEIGHT = listWidth * 88 / 320 ;
        CONSOLE_MIXED_CELL_LEFTMARGIN = listWidth * 10 / 320 ;
        CONSOLE_MIXED_CELL_RIGHTMARGIN = listWidth * 6 / 320 ;
    }

    @Override
    public int getCount() {
        int retValue = 0 ;

        ConsoleContents contents = ConsoleUtil.getConsoleContents() ;
        String appStatus = contents.appInfo.getStatus() ;
        if(appStatus.equals(ConsoleUtil.VEAM_APP_INFO_STATUS_RELEASED)){
            isAppReleased = true ;
        }

        numberOfMixeds = contents.getNumberOfMixedsForCategory("0") ;
        mixeds = contents.getMixedsForCategory("0") ;
        //VeamUtil.log("debug","numberOfMixeds="+numberOfMixeds) ;
        if(this.isAppReleased){
            retValue = this.numberOfAllMixeds() ; //
        } else {
            retValue = this.numberOfAllMixeds() + 5 ; // + comment cell
        }

        return retValue ;
    }

    public int numberOfAllMixeds()
    {
        int retValue = numberOfMixeds ;
        if(isAppReleased){
            retValue++ ;
        }
        return retValue ;
    }


    @Override
    public Object getItem(int position) {
        Object retValue = null ;
        if(isAppReleased){
            if(position == 0){
                double uploadTime = ConsoleUtil.getConsoleContents().getNextUploadTime() ;
                String deadlineString = VeamUtil.getMessageDateString(String.format("%f", uploadTime)) ;
                MixedObject mixed = new MixedObject() ;
                mixed.setKind(ConsoleUtil.VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO) ;
                mixed.setTitle("Title") ;
                mixed.setStatus("1") ;
                mixed.setStatusText("Deadline") ;
                mixed.setDeadlineString(deadlineString) ;
                retValue = mixed ;
            } else {
                int index = position - 1 ;
                retValue = (Object)this.getMixedAt(index) ;
            }
        } else {
            if(position < this.numberOfAllMixeds()) {
                retValue = (Object)this.getMixedAt(position);
            } else {
                int index = position - this.numberOfAllMixeds() ;
                if(index == 0) {
                    ConsoleAdapterElement element = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SPACER, 0, null, null, null);
                    retValue = element;
                } else if(index == 1){
                    ConsoleAdapterElement element = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,
                            context.getString(R.string.subscription_information),null,null);
                    retValue = element ;
                } else if(index == 2){
                    ConsoleAdapterElement element = new ConsoleAdapterElement(ELEMENTID_DESCRIPTION,ConsoleAdapterElement.KIND_TITLE_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,
                            context.getString(R.string.description_before_purchasing),null,null);
                    retValue = element ;
                } else if(index == 3) {
                    ConsoleContents contents = ConsoleUtil.getConsoleContents() ;
                    String priceKey = "subscription_prices" ;
                    if(VeamUtil.isLocaleJapanese()){
                        priceKey = "subscription_prices_ja" ;
                    }
                    String[] prices = contents.getValueForKey(priceKey).split("\\|") ;

                    ConsoleAdapterElement element = new ConsoleAdapterElement(ELEMENTID_PRICE,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,
                            context.getString(R.string.set_the_price_monthly),contents.templateSubscription.getPrice(),prices);
                    retValue = element ;
                } else if(index == 4) {
                    ConsoleAdapterElement element = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SPACER, 0, null, null, null);
                    retValue = element ;
                }
            }
        }
        return retValue ;
    }


    private MixedObject getMixedAt(int index)
    {
        MixedObject retValue = null ;
        retValue = mixeds.get(index) ;
        return retValue ;
    }

    private int getMixedIndexFor(int position)
    {
        int retValue = -1 ;
        if(isAppReleased){
            if(position == 0){
                retValue = -1 ;
            } else {
                retValue = position - 1 ;
            }
        } else {
            retValue = position ;
        }
        return retValue ;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        //VeamUtil.log("debug", "getView:" + position) ;
        View cell = null ;
        if(position < this.numberOfAllMixeds()){
            int thumbnailWidth = listWidth * 68 / 320  ;
            int thumbnailHeight = listWidth * 68 / 320  ;
            int deleteButtonWidth = listWidth * 27 / 320 ;
            int deleteButtonHeight = listWidth * 44 / 320 ;
            boolean isLast = (position == (this.numberOfAllMixeds()-1)) ;
            MixedObject mixed = (MixedObject)this.getItem(position) ;
            RelativeLayout mixedCell = new RelativeLayout(consoleActivity) ;
            //[[ConsoleMixedForGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" mixed:mixed isLast:isLast] ;

            int mixedIndex = this.getMixedIndexFor(position) ;
            if(0 <= mixedIndex){
                ImageView deleteImageView = new ImageView(consoleActivity) ;
                deleteImageView.setId(ConsoleActivity.VIEWID_LIST_DELETE);
                deleteImageView.setImageResource(R.drawable.list_delete_on);
                deleteImageView.setOnClickListener(consoleActivity);
                deleteImageView.setTag(Integer.valueOf(mixedIndex)) ;
                mixedCell.addView(deleteImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth - CONSOLE_MIXED_CELL_RIGHTMARGIN - deleteButtonWidth, (CONSOLE_MIXED_CELL_HEIGHT - deleteButtonHeight) / 2, deleteButtonWidth, deleteButtonHeight)) ;
            }

            ImageView thumbnailImageView = new ImageView(consoleActivity) ;
            thumbnailImageView.setTag(Integer.valueOf(position)) ;
            String thumbnailUrl = mixed.getThumbnailUrl() ;
            //NSLog(@"mixed thumbnailUrl=%@",mixed.thumbnailUrl) ;
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
            mixedCell.addView(thumbnailImageView,ConsoleUtil.getRelativeLayoutPrams(CONSOLE_MIXED_CELL_LEFTMARGIN,(CONSOLE_MIXED_CELL_HEIGHT-thumbnailHeight)/2, thumbnailWidth, thumbnailHeight));

            int titleX = CONSOLE_MIXED_CELL_LEFTMARGIN + thumbnailWidth + listWidth * 12 / 320 ;

            TextView titleLabel = new TextView(consoleActivity) ;
            titleLabel.setText(mixed.getTitle()) ;
            titleLabel.setGravity(Gravity.CENTER_VERTICAL);
            titleLabel.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
            titleLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
            titleLabel.setTextColor(Color.BLACK) ;
            mixedCell.addView(titleLabel, ConsoleUtil.getRelativeLayoutPrams(titleX, 0, listWidth - titleX - deleteButtonWidth - CONSOLE_MIXED_CELL_RIGHTMARGIN, CONSOLE_MIXED_CELL_HEIGHT)) ;


            VeamUtil.log("debug","id="+mixed.getId()+" status="+mixed.getStatus()) ;
            if(mixed.getStatus().equals(ConsoleUtil.VEAM_MIXED_STATUS_READY)){
                titleLabel.setTextColor(Color.BLACK) ;
            } else {
                thumbnailImageView.setBackgroundColor(Color.RED) ;

                boolean deadlineExists = !VeamUtil.isEmpty(mixed.getDeadlineString()) ;

                TextView statusLabel = new TextView(context) ;
                statusLabel.setTextSize((float) listWidth * 10.0f / 100 / scaledDensity);
                statusLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
                statusLabel.setText(mixed.getStatusText()) ;
                statusLabel.setTextColor(Color.WHITE) ;
                statusLabel.setGravity(Gravity.CENTER) ;
                if(deadlineExists) {
                    mixedCell.addView(statusLabel, ConsoleUtil.getRelativeLayoutPrams(CONSOLE_MIXED_CELL_LEFTMARGIN + thumbnailWidth * 10 / 100, (CONSOLE_MIXED_CELL_HEIGHT - thumbnailHeight) / 2, thumbnailWidth*80/100, thumbnailHeight/2));
                } else {
                    mixedCell.addView(statusLabel, ConsoleUtil.getRelativeLayoutPrams(CONSOLE_MIXED_CELL_LEFTMARGIN + thumbnailWidth * 10 / 100, (CONSOLE_MIXED_CELL_HEIGHT - thumbnailHeight) / 2, thumbnailWidth*80/100, thumbnailHeight));
                }
                ConsoleUtil.setTextSizeWithin(thumbnailWidth*80/100,statusLabel);

                if(mixed.getStatusText().equals("Preparing")){
                    ConsoleUtil.startViewBlinking(statusLabel);
                }

                if(deadlineExists){
                    TextView deadlineLabel = new TextView(context) ;
                    deadlineLabel.setTextSize((float) listWidth * 10.0f / 100 / scaledDensity);
                    deadlineLabel.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
                    deadlineLabel.setText(mixed.getDeadlineString()) ;
                    deadlineLabel.setTextColor(Color.WHITE) ;
                    deadlineLabel.setGravity(Gravity.CENTER) ;
                    mixedCell.addView(statusLabel, ConsoleUtil.getRelativeLayoutPrams(CONSOLE_MIXED_CELL_LEFTMARGIN + thumbnailWidth * 10 / 100, (CONSOLE_MIXED_CELL_HEIGHT - thumbnailHeight) / 2 + thumbnailHeight / 2, thumbnailWidth * 80 / 100, thumbnailHeight / 2));
                    ConsoleUtil.setTextSizeWithin(thumbnailWidth * 80 / 100, deadlineLabel);
                }

                titleLabel.setTextColor(VeamUtil.getColorFromArgbString("FFB4B4B4")) ;
                //self.moveImageView.image = moveOffImage ;
            }

            mixedCell.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(0, CONSOLE_MIXED_CELL_HEIGHT - 1, listWidth, 1));

            cell = mixedCell ;
        } else {
            cell = getDefaultView(position,convertView) ;
        }

        if(cell == null){
            cell = new RelativeLayout(consoleActivity) ;
        }

        return cell;
    }

    @Override
    public int getItemViewType(int position){
        int itemType = 0 ;
        return itemType ;
    }

    @Override
    public int getViewTypeCount(){
        return 1 ;
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
