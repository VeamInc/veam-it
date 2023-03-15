package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 12/13/16.
 */
public class ConsoleEditSellSectionPdfAdapter extends ConsoleBaseAdapter {

    private static final int ELEMENTID_PDF_URL = 1 ;
    private static final int ELEMENTID_IMAGE_URL = 2 ;

    private int currentElementId = 0 ;

    private String title ;
    private String pdfDataUrl ;
    private String imageDataUrl ;

    public ConsoleEditSellSectionPdfAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;

        title = "" ;
        pdfDataUrl = "" ;
        imageDataUrl = "" ;
    }



    @Override
    public int getCount() {
        return 4;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        switch (position){
            case 0:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_SMALL_TITLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK,context.getString(R.string.upload_pdf_to_veam_cloud), " ",null);
                break ;
            case 1:
                item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_TEXT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.title), title,null);
                break ;
            case 2:
                item = new ConsoleAdapterElement(ELEMENTID_PDF_URL,ConsoleAdapterElement.KIND_TEXT_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.pdf_data_url), ConsoleUtil.getUrlFileName(pdfDataUrl),null);
                break ;
            case 3:
                item = new ConsoleAdapterElement(ELEMENTID_IMAGE_URL,ConsoleAdapterElement.KIND_TEXT_CLICKABLE, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,context.getString(R.string.image_data_url), ConsoleUtil.getUrlFileName(imageDataUrl),null);
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
                pdfDataUrl = newValue ;
                break ;
            case 3:
                imageDataUrl = newValue ;
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
            if(currentElementId == ELEMENTID_PDF_URL) {
                consoleActivity.launchDropboxActivity("Dropbox", "/",ConsoleUtil.DROPBOX_PDF_EXTENSIONS);
            } else if(currentElementId == ELEMENTID_IMAGE_URL) {
                consoleActivity.launchDropboxActivity("Dropbox", "/",ConsoleUtil.DROPBOX_IMAGE_EXTENSIONS);
            }
        }
    }

    public void setValue(String string){
        if(currentElementId == ELEMENTID_PDF_URL) {
            pdfDataUrl = string ;
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

    public String getPdfDataUrl() {
        return pdfDataUrl;
    }

    public void setPdfDataUrl(String pdfDataUrl) {
        this.pdfDataUrl = pdfDataUrl;
    }

    public String getImageDataUrl() {
        return imageDataUrl;
    }

    public void setImageDataUrl(String imageDataUrl) {
        this.imageDataUrl = imageDataUrl;
    }

}
