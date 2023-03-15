package co.veam.veam31000287;

import org.xml.sax.Attributes;

import java.util.ArrayList;

/**
 * Created by veam on 10/27/16.
 */
public class TemplateYoutube implements HandlePostResultInterface {

    private String templateYoutubeId ;
    private String title ;
    private String embedFlag ;
    private String embedUrl ;
    private String leftImageUrl ;
    private String rightImageUrl ;

    public TemplateYoutube() {

    }

    public String getTemplateYoutubeId() {
        return templateYoutubeId;
    }

    public void setTemplateYoutubeId(String templateYoutubeId) {
        this.templateYoutubeId = templateYoutubeId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getEmbedFlag() {
        return embedFlag;
    }

    public void setEmbedFlag(String embedFlag) {
        this.embedFlag = embedFlag;
    }

    public String getEmbedUrl() {
        return embedUrl;
    }

    public void setEmbedUrl(String embedUrl) {
        this.embedUrl = embedUrl;
    }

    public String getLeftImageUrl() {
        return leftImageUrl;
    }

    public void setLeftImageUrl(String leftImageUrl) {
        this.leftImageUrl = leftImageUrl;
    }

    public String getRightImageUrl() {
        return rightImageUrl;
    }

    public void setRightImageUrl(String rightImageUrl) {
        this.rightImageUrl = rightImageUrl;
    }

    public TemplateYoutube(Attributes attributes) {
        this.setTemplateYoutubeId(attributes.getValue("id")) ;
        this.setTitle(attributes.getValue("t")) ;
        this.setEmbedFlag(attributes.getValue("e")) ;
        this.setEmbedUrl(attributes.getValue("u")) ;
        this.setLeftImageUrl(attributes.getValue("l")) ;
        this.setRightImageUrl(attributes.getValue("r")) ;
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 4){
            //NSLog(@"count >= 4") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                this.setLeftImageUrl(results.get(2)) ;
                this.setRightImageUrl(results.get(3)) ;
                //NSLog(@"set leftImageUrl:%@",self.leftImageUrl) ;
                //NSLog(@"set rightImageUrl:%@",self.rightImageUrl) ;
            }
        }

    }
}
