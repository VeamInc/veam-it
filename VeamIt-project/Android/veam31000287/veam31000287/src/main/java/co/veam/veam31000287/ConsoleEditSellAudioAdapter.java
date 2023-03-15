package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 12/12/16.
 */
public class ConsoleEditSellAudioAdapter extends ConsoleBaseAdapter {

    private static final int ELEMENTID_AUDIO_URL = 1 ;
    private static final int ELEMENTID_IMAGE_URL = 2 ;
    private static final int ELEMENTID_PDF_URL = 3 ;
    private static final int ELEMENTID_PRICE = 4 ;
    private static final int ELEMENTID_DESCRIPTION = 5 ;

    private int currentElementId = 0 ;

    private String title ;
    private String audioDataUrl ;
    private String imageDataUrl ;
    private String pdfDataUrl ;
    private String price ;
    private String description ;
    private String[] prices ;

    public ConsoleEditSellAudioAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;

        title = "" ;
        audioDataUrl = "" ;
        imageDataUrl = "" ;
        pdfDataUrl = "" ;
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
        return 7;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        switch (position){
            case 0:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,context.getString(R.string.upload_audio_to_veam_cloud), " ",null);
                break ;
            case 1:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.title), title,null);
                break ;
            case 2:
                item = new ConsoleAdapterElement(ELEMENTID_AUDIO_URL,ConsoleAdapterElement.KIND_TEXT_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.audio_data_url), ConsoleUtil.getUrlFileName(audioDataUrl),null);
                break ;
            case 3:
                item = new ConsoleAdapterElement(ELEMENTID_IMAGE_URL,ConsoleAdapterElement.KIND_TEXT_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.image_data_url), ConsoleUtil.getUrlFileName(imageDataUrl),null);
                break ;
            case 4:
                item = new ConsoleAdapterElement(ELEMENTID_PDF_URL,ConsoleAdapterElement.KIND_TEXT_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.pdf_data_url), ConsoleUtil.getUrlFileName(pdfDataUrl),null);
                break ;
            case 5:
                item = new ConsoleAdapterElement(ELEMENTID_PRICE,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.ppc_price), price,prices);
                break ;
            case 6:
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
                audioDataUrl = newValue ;
                break ;
            case 3:
                imageDataUrl = newValue ;
                break ;
            case 4:
                pdfDataUrl = newValue ;
                break ;
            case 5:
                price = newValue ;
                break ;
            case 6:
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
            if(currentElementId == ELEMENTID_AUDIO_URL) {
                consoleActivity.launchDropboxActivity("Dropbox", "/",ConsoleUtil.DROPBOX_AUDIO_EXTENSIONS);
            } else if(currentElementId == ELEMENTID_IMAGE_URL) {
                consoleActivity.launchDropboxActivity("Dropbox", "/",ConsoleUtil.DROPBOX_IMAGE_EXTENSIONS);
            } else if(currentElementId == ELEMENTID_PDF_URL) {
                consoleActivity.launchDropboxActivity("Dropbox", "/",ConsoleUtil.DROPBOX_PDF_EXTENSIONS);
            }
        }
    }

    public void setValue(String string){
        if(currentElementId == ELEMENTID_AUDIO_URL) {
            audioDataUrl = string ;
        } else if(currentElementId == ELEMENTID_IMAGE_URL) {
            imageDataUrl = string ;
        } else if(currentElementId == ELEMENTID_PDF_URL) {
            pdfDataUrl = string ;
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

    public String getAudioDataUrl() {
        return audioDataUrl;
    }

    public void setAudioDataUrl(String audioDataUrl) {
        this.audioDataUrl = audioDataUrl;
    }

    public String getImageDataUrl() {
        return imageDataUrl;
    }

    public void setImageDataUrl(String imageDataUrl) {
        this.imageDataUrl = imageDataUrl;
    }

    public String getPdfDataUrl() {
        return pdfDataUrl;
    }

    public void setPdfDataUrl(String pdfDataUrl) {
        this.pdfDataUrl = pdfDataUrl;
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
