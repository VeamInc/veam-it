package co.veam.veam31000287;

import org.xml.sax.Attributes;

import java.util.ArrayList;

/**
 * Created by veam on 10/27/16.
 */
public class AppInfo implements HandlePostResultInterface {
    private String appId ;
    private String name ;
    private String storeAppName ;
    private String category ;
    private String subCategory ;
    private String description ;
    private String keyword ;
    private String backgroundImageUrl ;
    private String splashImageUrl ;
    private String iconImageUrl ;
    private String screenShot1Url ;
    private String screenShot2Url ;
    private String screenShot3Url ;
    private String screenShot4Url ;
    private String screenShot5Url ;
    private String status ;
    private String statusText ;
    private String termsAcceptedAt ;
    private String releasedAt ;
    private String modified ;

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStoreAppName() {
        return storeAppName;
    }

    public void setStoreAppName(String storeAppName) {
        this.storeAppName = storeAppName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSubCategory() {
        return subCategory;
    }

    public void setSubCategory(String subCategory) {
        this.subCategory = subCategory;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getBackgroundImageUrl() {
        return backgroundImageUrl;
    }

    public void setBackgroundImageUrl(String backgroundImageUrl) {
        this.backgroundImageUrl = backgroundImageUrl;
    }

    public String getSplashImageUrl() {
        return splashImageUrl;
    }

    public void setSplashImageUrl(String splashImageUrl) {
        this.splashImageUrl = splashImageUrl;
    }

    public String getIconImageUrl() {
        return iconImageUrl;
    }

    public void setIconImageUrl(String iconImageUrl) {
        this.iconImageUrl = iconImageUrl;
    }

    public String getScreenShot1Url() {
        return screenShot1Url;
    }

    public void setScreenShot1Url(String screenShot1Url) {
        this.screenShot1Url = screenShot1Url;
    }

    public String getScreenShot2Url() {
        return screenShot2Url;
    }

    public void setScreenShot2Url(String screenShot2Url) {
        this.screenShot2Url = screenShot2Url;
    }

    public String getScreenShot3Url() {
        return screenShot3Url;
    }

    public void setScreenShot3Url(String screenShot3Url) {
        this.screenShot3Url = screenShot3Url;
    }

    public String getScreenShot4Url() {
        return screenShot4Url;
    }

    public void setScreenShot4Url(String screenShot4Url) {
        this.screenShot4Url = screenShot4Url;
    }

    public String getScreenShot5Url() {
        return screenShot5Url;
    }

    public void setScreenShot5Url(String screenShot5Url) {
        this.screenShot5Url = screenShot5Url;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusText() {
        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

    public String getTermsAcceptedAt() {
        return termsAcceptedAt;
    }

    public void setTermsAcceptedAt(String termsAcceptedAt) {
        this.termsAcceptedAt = termsAcceptedAt;
    }

    public String getReleasedAt() {
        return releasedAt;
    }

    public void setReleasedAt(String releasedAt) {
        this.releasedAt = releasedAt;
    }

    public String getModified() {
        return modified;
    }

    public void setModified(String modified) {
        this.modified = modified;
    }

    //- (id)initWithAttributes:(NSDictionary *)attributeDict ;
    public AppInfo(Attributes attributes){
        this.setAppId(attributes.getValue("id")) ;
        this.setName(attributes.getValue("n")) ;
        this.setStoreAppName(attributes.getValue("sn")) ;
        this.setCategory(attributes.getValue("c")) ;
        this.setSubCategory(attributes.getValue("sc")) ;
        this.setDescription(attributes.getValue("d")) ;
        this.setKeyword(attributes.getValue("k")) ;
        this.setBackgroundImageUrl(attributes.getValue("bu")) ;
        this.setSplashImageUrl(attributes.getValue("su")) ;
        this.setIconImageUrl(attributes.getValue("iu")) ;
        this.setScreenShot1Url(attributes.getValue("s1")) ;
        this.setScreenShot2Url(attributes.getValue("s2")) ;
        this.setScreenShot3Url(attributes.getValue("s3")) ;
        this.setScreenShot4Url(attributes.getValue("s4")) ;
        this.setScreenShot5Url(attributes.getValue("s5")) ;
        this.setStatus(attributes.getValue("st")) ;
        this.setStatusText(attributes.getValue("stt")) ;
        this.setTermsAcceptedAt(attributes.getValue("at")) ;
        this.setReleasedAt(attributes.getValue("rt")) ;
        this.setModified(attributes.getValue("mo")) ;
    }

    public void handlePostResult(ArrayList<String> results)
    {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 10){
        //NSLog(@"count >= 10") ;
        String result = results.get(0) ;
        if(result.equals("OK")){
            this.setAppId(results.get(1)) ;
            this.setBackgroundImageUrl(results.get(2)) ;
            this.setSplashImageUrl(results.get(3)) ;
            this.setIconImageUrl(results.get(4)) ;
            this.setScreenShot1Url(results.get(5)) ;
            this.setScreenShot2Url(results.get(6)) ;
            this.setScreenShot3Url(results.get(7)) ;
            this.setScreenShot4Url(results.get(8)) ;
            this.setScreenShot5Url(results.get(9)) ;
            //NSLog(@"set backgroundImageUrl:%@",self.backgroundImageUrl) ;
            //NSLog(@"set splashImageUrl:%@",self.splashImageUrl) ;
            //NSLog(@"set iconImageUrl:%@",self.iconImageUrl) ;
        }
    }
    }

}
