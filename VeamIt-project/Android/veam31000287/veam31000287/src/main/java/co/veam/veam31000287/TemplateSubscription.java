package co.veam.veam31000287;

import org.xml.sax.Attributes;

import java.util.ArrayList;

/**
 * Created by veam on 10/27/16.
 */
public class TemplateSubscription implements HandlePostResultInterface {
    private String templateSubscriptionId ;
    private String title ;
    private String layout ;
    private String price ;
    private String kind ;
    private String rightImageUrl ;
    private String uploadSpan ;
    private String isFree ;

    public TemplateSubscription() {

    }

    public String getTemplateSubscriptionId() {
        return templateSubscriptionId;
    }

    public void setTemplateSubscriptionId(String templateSubscriptionId) {
        this.templateSubscriptionId = templateSubscriptionId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLayout() {
        return layout;
    }

    public void setLayout(String layout) {
        this.layout = layout;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
    }

    public String getRightImageUrl() {
        return rightImageUrl;
    }

    public void setRightImageUrl(String rightImageUrl) {
        this.rightImageUrl = rightImageUrl;
    }

    public String getUploadSpan() {
        return uploadSpan;
    }

    public void setUploadSpan(String uploadSpan) {
        this.uploadSpan = uploadSpan;
    }

    public String getIsFree() {
        return isFree;
    }

    public void setIsFree(String isFree) {
        this.isFree = isFree;
    }

    public TemplateSubscription(Attributes attributes){
        this.setTemplateSubscriptionId(attributes.getValue("id")) ;
        this.setTitle(attributes.getValue("t")) ;
        this.setLayout(attributes.getValue("l")) ;
        this.setKind(attributes.getValue("k")) ;
        this.setPrice(attributes.getValue("p")) ;
        this.setRightImageUrl(attributes.getValue("r")) ;
        String workUploadSpan = attributes.getValue("u") ;
        if(VeamUtil.isEmpty(workUploadSpan)){
            this.setUploadSpan("7") ;
        } else {
            this.setUploadSpan(workUploadSpan) ;
        }

        String workIsFree = attributes.getValue("f") ;
        if(VeamUtil.isEmpty(workIsFree)){
            this.setIsFree("0") ;
        } else {
            this.setIsFree(workIsFree) ;
        }
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 2){
            //NSLog(@"count >= 2") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                this.setRightImageUrl(results.get(1)) ;
                //NSLog(@"set rightImageUrl:%@",self.rightImageUrl) ;
            }
        }

    }
}
