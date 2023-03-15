package co.veam.veam31000287;

import java.util.ArrayList;

/**
 * Created by veam on 11/8/16.
 */
public class ConsoleSellSectionItemPostHandler implements HandlePostResultInterface {

    SellSectionItemObject sellSectionItem ;
    VideoObject video ;
    AudioObject audio ;
    PdfObject pdf ;

    public SellSectionItemObject getSellSectionItem() {
        return sellSectionItem;
    }

    public void setSellSectionItem(SellSectionItemObject sellSectionItem) {
        this.sellSectionItem = sellSectionItem;
    }

    public VideoObject getVideo() {
        return video;
    }

    public void setVideo(VideoObject video) {
        this.video = video;
    }

    public AudioObject getAudio() {
        return audio;
    }

    public void setAudio(AudioObject audio) {
        this.audio = audio;
    }

    public PdfObject getPdf() {
        return pdf;
    }

    public void setPdf(PdfObject pdf) {
        this.pdf = pdf;
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 6){
            //NSLog(@"count >= 2") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                String sellSectionItemId = results.get(1) ;
                String contentId = results.get(2) ;
                String kind = results.get(3) ;
                String status = results.get(4) ;
                String statusText = results.get(5) ;

                sellSectionItem.setId(sellSectionItemId) ;
                if(kind.equals(ConsoleUtil.VEAM_SELL_SECTION_ITEM_KIND_VIDEO)){
                    video.setId(contentId) ;
                } else if(kind.equals(ConsoleUtil.VEAM_SELL_SECTION_ITEM_KIND_PDF)){
                    pdf.setId(contentId) ;
                } else if(kind.equals(ConsoleUtil.VEAM_SELL_SECTION_ITEM_KIND_AUDIO)){
                    audio.setId(contentId) ;
                }

                sellSectionItem.setStatus(status) ;
                sellSectionItem.setStatusText(statusText) ;
            }
        }
    }
}
