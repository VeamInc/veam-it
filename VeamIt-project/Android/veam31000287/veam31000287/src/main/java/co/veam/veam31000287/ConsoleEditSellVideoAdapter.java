package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 12/12/16.
 */
public class ConsoleEditSellVideoAdapter extends ConsoleBaseAdapter {

    private static final int ELEMENTID_VIDEO_URL = 1 ;
    private static final int ELEMENTID_IMAGE_URL = 2 ;
    private static final int ELEMENTID_PRICE = 3 ;
    private static final int ELEMENTID_DESCRIPTION = 4 ;

    private int currentElementId = 0 ;

    private String title ;
    private String videoDataUrl ;
    private String imageDataUrl ;
    private String price ;
    private String description ;
    private String[] prices ;

    public ConsoleEditSellVideoAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;

        title = "" ;
        videoDataUrl = "" ;
        imageDataUrl = "" ;
        price = "" ;
        description = "" ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        String priceKey = "subscription_prices" ;
        if(VeamUtil.isLocaleJapanese()){
            priceKey = "subscription_prices_ja" ;
        }
        prices = consoleContents.getValueForKey(priceKey).split("\\|") ;

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
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,context.getString(R.string.upload_video_to_veam_cloud), " ",null);
                break ;
            case 1:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.title), title,null);
                break ;
            case 2:
                item = new ConsoleAdapterElement(ELEMENTID_VIDEO_URL,ConsoleAdapterElement.KIND_TEXT_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.video_data_url), ConsoleUtil.getUrlFileName(videoDataUrl),null);
                break ;
            case 3:
                item = new ConsoleAdapterElement(ELEMENTID_IMAGE_URL,ConsoleAdapterElement.KIND_TEXT_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.image_data_url), ConsoleUtil.getUrlFileName(imageDataUrl),null);
                break ;
            case 4:
                item = new ConsoleAdapterElement(ELEMENTID_PRICE,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.ppc_price), price,prices);
                break ;
            case 5:
                item = new ConsoleAdapterElement(ELEMENTID_DESCRIPTION,ConsoleAdapterElement.KIND_EDITABLE_LONG_TEXT, ConsoleBaseAdapter.COLOR_TYPE_TOP_RED,context.getString(R.string.description), description,null);
                break ;

        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "ConsoleEditAppIntormationAdapter::setNewValue " + position + " " + newValue) ;
        switch (position){
            case 1:
                title = newValue ;
                break ;
            case 2:
                videoDataUrl = newValue ;
                break ;
            case 3:
                imageDataUrl = newValue ;
                break ;
            case 4:
                price = newValue ;
                break ;
            case 5:
                description = newValue ;
                break ;
            default:
                // should not be here
                VeamUtil.log("debug","setNewValue not implemented") ;
                break ;
        }

    }

    @Override
    public void onTextClick(int position,String title){
        VeamUtil.log("debug", "onTextClick should be overridden : " + position + " : " + title) ;
        ConsoleAdapterElement consoleAdapterElement = (ConsoleAdapterElement)getItem(position) ;
        if(consoleAdapterElement != null){
            currentElementId = consoleAdapterElement.getElementId() ;
            if(currentElementId == ELEMENTID_VIDEO_URL) {
                consoleActivity.launchDropboxActivity("Dropbox", "/",ConsoleUtil.DROPBOX_VIDEO_EXTENSIONS);
            } else if(currentElementId == ELEMENTID_IMAGE_URL) {
                consoleActivity.launchDropboxActivity("Dropbox", "/",ConsoleUtil.DROPBOX_IMAGE_EXTENSIONS);
            }
        }
    }

    public void setValue(String string){
        if(currentElementId == ELEMENTID_VIDEO_URL) {
            videoDataUrl = string ;
        } else if(currentElementId == ELEMENTID_IMAGE_URL) {
            imageDataUrl = string ;
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

    public String getVideoDataUrl() {
        return videoDataUrl;
    }

    public void setVideoDataUrl(String videoDataUrl) {
        this.videoDataUrl = videoDataUrl;
    }

    public String getImageDataUrl() {
        return imageDataUrl;
    }

    public void setImageDataUrl(String imageDataUrl) {
        this.imageDataUrl = imageDataUrl;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
