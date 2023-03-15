package co.veam.veam31000287;

import android.media.Image;
import android.provider.MediaStore;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.MissingResourceException;

/**
 * Created by veam on 10/27/16.
 */
public class ConsoleContents {

    //NSData *xmlData ;
    //BOOL isParsing ;

    Map<String,String> dictionary ;

    AppInfo appInfo ;
    //BankAccountInfo *bankAccountInfo ;
    ArrayList<AppRatingQuestion> appRatingQuestions ;

    //// subscription
    TemplateSubscription templateSubscription ;

    //// youtube
    TemplateYoutube templateYoutube ;
    ArrayList<YoutubeCategoryObject> youtubeCategories ;
    //Map<String,ArrayList<YoutubeSubCategoryObject>> youtubeSubCategoriesPerCategory ;
    Map<String,ArrayList<YoutubeObject>> youtubesPerCategory ;
    Map<String,ArrayList<YoutubeObject>> youtubesPerSubCategory ;
    Map<String,YoutubeObject> youtubesForYoutubeId ;

    //// forum
    TemplateForum templateForum ;
    ArrayList<ForumObject> forums ;

    //// mixed
    TemplateMixed templateMixed ;
    //ArrayList<MixedCategoryObject> mixedCategories ;
    //NSMutableDictionary *mixedSubCategoriesPerCategory ;
    Map<String,ArrayList<MixedObject>> mixedsPerCategory ;
    //NSMutableDictionary *mixedsPerSubCategory ;
    Map<String,MixedObject> mixedsForMixedId ;
    //ArrayList<RecipeObject> recipes ;

    //// video
    ArrayList<VideoCategoryObject> videoCategories ;
    //NSMutableDictionary *videoSubCategoriesPerCategory ;
    Map<String,ArrayList<VideoObject>> videosPerCategory ;
    //NSMutableDictionary *videosPerSubCategory ;
    Map<String,VideoObject> videosForVideoId ;
    Map<String,SellVideoObject> sellVideosForSellVideoId ;
    ArrayList<SellVideoObject> sellVideos ;

    //// sell item
    ArrayList<SellItemCategoryObject> sellItemCategories ;

    //// sell section
    ArrayList<SellSectionCategoryObject> sellSectionCategories ;
    Map<String,SellSectionItemObject> sellSectionItemsForSellSectionItemId ;
    ArrayList<SellSectionItemObject> sellSectionItems ;

    //// pdf
    ArrayList<PdfCategoryObject> pdfCategories ;
    //NSMutableDictionary *pdfSubCategoriesPerCategory ;
    Map<String,ArrayList<PdfObject>> pdfsPerCategory ;
    //NSMutableDictionary *pdfsPerSubCategory ;
    Map<String,PdfObject> pdfsForPdfId ;
    Map<String,SellPdfObject> sellPdfsForSellPdfId ;
    ArrayList<SellPdfObject> sellPdfs ;

    //// audio
    ArrayList<AudioCategoryObject> audioCategories ;
    //NSMutableDictionary *audioSubCategoriesPerCategory ;
    Map<String,ArrayList<AudioObject>> audiosPerCategory ;
    //NSMutableDictionary *audiosPerSubCategory ;
    Map<String,AudioObject> audiosForAudioId ;
    Map<String,SellAudioObject> sellAudiosForSellAudioId ;
    ArrayList<SellAudioObject> sellAudios ;

    //// web
    TemplateWeb templateWeb ;
    ArrayList<WebObject> webs ;

    //// etc
    ArrayList<AlternativeImageObject> alternativeImages ;
    Map<String,AlternativeImageObject> alternativeImagesForFileName ;

    /*
    ArrayList<> customizeElementsForDesign ;
    ArrayList<> customizeElementsForFeature ;
    ArrayList<> customizeElementsForSubscription ;
    */



    public void init(){

        dictionary = new HashMap<String,String>() ;

        // appInfo = new AppInfo() ;
        appRatingQuestions = new ArrayList<AppRatingQuestion>() ;

        //// subscription
        //templateSubscription = new TemplateSubscription() ;

        //// youtube
        //templateYoutube = new TemplateYoutube() ;
        youtubeCategories = new ArrayList<YoutubeCategoryObject>() ;
        youtubesPerCategory = new HashMap<String,ArrayList<YoutubeObject>>() ;
        youtubesPerSubCategory = new HashMap<String,ArrayList<YoutubeObject>>() ;
        youtubesForYoutubeId = new HashMap<String,YoutubeObject>() ;

        //// forum
        //templateForum = new TemplateForum() ;
        forums = new ArrayList<ForumObject>() ;

        //// mixed
        //templateMixed = new TemplateMixed() ;
        mixedsPerCategory = new HashMap<String,ArrayList<MixedObject>>() ;
        mixedsForMixedId = new HashMap<String,MixedObject>() ;

        //// video
        videoCategories = new ArrayList<VideoCategoryObject>() ;
        videosPerCategory = new HashMap<String,ArrayList<VideoObject>>() ;
        videosForVideoId = new HashMap<String,VideoObject>() ;
        sellVideosForSellVideoId = new HashMap<String,SellVideoObject>() ;
        sellVideos = new ArrayList<SellVideoObject>() ;

        //// sell item
        sellItemCategories = new ArrayList<SellItemCategoryObject>() ;

        //// sell section
        sellSectionCategories = new ArrayList<SellSectionCategoryObject>() ;
        sellSectionItemsForSellSectionItemId = new HashMap<String,SellSectionItemObject>() ;
        sellSectionItems = new ArrayList<SellSectionItemObject>() ;

        //// pdf
        pdfCategories = new ArrayList<PdfCategoryObject>() ;
        pdfsPerCategory = new HashMap<String,ArrayList<PdfObject>>() ;
        pdfsForPdfId = new HashMap<String,PdfObject>() ;
        sellPdfsForSellPdfId = new HashMap<String,SellPdfObject>() ;
        sellPdfs = new ArrayList<SellPdfObject>() ;

        //// audio
        audioCategories = new ArrayList<AudioCategoryObject>() ;
        audiosPerCategory = new HashMap<String,ArrayList<AudioObject>>() ;
        audiosForAudioId = new HashMap<String,AudioObject>() ;
        sellAudiosForSellAudioId = new HashMap<String,SellAudioObject>() ;
        sellAudios = new ArrayList<SellAudioObject>() ;

        //// web
        //templateWeb = new TemplateWeb() ;
        webs = new ArrayList<WebObject>() ;

        //// etc
        alternativeImages = new ArrayList<AlternativeImageObject>() ;
        alternativeImagesForFileName = new HashMap<String,AlternativeImageObject>() ;

    }

    public void addMixed(MixedObject mixed)
    {
        String mixedSubCategoryId = mixed.getMixedSubCategoryId() ;

        /*
        ArrayList<MixedObject> mixeds = mixedsPerSubCategory.get(mixedSubCategoryId) ;
        if(mixeds == null){
            mixeds = NSMutableArray() ;
            mixedsPerSubCategory.put(__KEY__,mixeds,mixedSubCategoryId) ;
        }
        mixeds addObject:mixed) ;
        */

        if(mixedSubCategoryId.equals("0")) {
            String mixedCategoryId = mixed.getMixedCategoryId();
            ArrayList<MixedObject> mixeds = mixedsPerCategory.get(mixedCategoryId);
            if (mixeds == null) {
                mixeds = new ArrayList<MixedObject>();
                mixedsPerCategory.put(mixedCategoryId, mixeds);
            }
            mixeds.add(mixed);
            VeamUtil.log("debug","add mixed category=" + mixedCategoryId + " size=" + mixeds.size()) ;
        }

        mixedsForMixedId.put(mixed.getId(),mixed) ;
    }






    public float getSettingCompletionRatio(){
        float ratio = 0.0f ;

        ArrayList<String> requiredOperations = this.getRequiredOperationsToSubmit() ;
        if(requiredOperations.size() == 0){
            ratio = 1.0f ;
        } else {
            //// Subscription //////////////////////////////////////
            if(this.isSubscriptionContentCompleted()){
                ratio += 0.5f ;
            }

            //// Forum //////////////////////////////////////
            if(this.isForumCompleted()){
                ratio += 0.1f ;
            }

            //// Links //////////////////////////////////////
            if(this.isLinksCompleted()){
                ratio += 0.1f ;
            }

            //// App Info //////////////////////////////////////
            if(!VeamUtil.isEmpty(appInfo.getTermsAcceptedAt())){
                ratio += 0.1f ;
            }
            if(!VeamUtil.isEmpty(appInfo.getDescription())){
                ratio += 0.05f ;
            }
            if(!VeamUtil.isEmpty(appInfo.getKeyword())){
                ratio += 0.05f ;
            }
            if(!VeamUtil.isEmpty(appInfo.getCategory())){
                ratio += 0.05f ;
            }

            if(this.isRatingCompleted()){
                ratio += 0.05f ;
            }

            if(ratio >= 1.0){
                ratio = 0.99f ;
            }
        }
        return ratio ;
    }

    public ArrayList<String> getRequiredOperationsToSubmit(){
        //NSLog("getRequiredOperationsToSubmit") ;

        ArrayList<String> requiredOperations = new ArrayList<String>() ;

        if(VeamUtil.isEmpty(appInfo.getBackgroundImageUrl())){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_background)) ;
        }
        
        //// Subscription //////////////////////////////////////
        if(!this.isSubscriptionContentCompleted()){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_subscription)) ;
        }

        if(!this.isSubscriptionDescriptionCompleted()){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_subscription_description)) ;
        }

        //// Forum //////////////////////////////////////
        if(!this.isForumCompleted()){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_forum)) ;
        }

        //// Links //////////////////////////////////////
        if(!this.isLinksCompleted()){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_links)) ;
        }

        //// App Info //////////////////////////////////////
        if(VeamUtil.isEmpty(appInfo.getTermsAcceptedAt())){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_terms)) ;
        }
        if(VeamUtil.isEmpty(appInfo.getDescription()) || VeamUtil.isEmpty(this.getValueForKey("app_description_set"))){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_description)) ;
        }
        if(VeamUtil.isEmpty(appInfo.getKeyword())){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_keywords)) ;
        }
        if(VeamUtil.isEmpty(appInfo.getCategory())){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_category)) ;
        }
        if(!this.isRatingCompleted()){
            requiredOperations.add(ConsoleUtil.getString(R.string.required_operation_rating)) ;
        }

        return requiredOperations ;
    }



    public boolean isSubscriptionDescriptionCompleted()
    {
        boolean subscruptionDescriptionCompleted = true ;

        if(templateSubscription.getKind().equals(ConsoleUtil.VEAM_SUBSCRIPTION_KIND_MIXED_GRID)){
            subscruptionDescriptionCompleted = !VeamUtil.isEmpty(this.getValueForKey("subscription_description_set")) ;
        }
        return subscruptionDescriptionCompleted ;

    }


        public boolean isSubscriptionContentCompleted()
    {
        // at least 1 content

        ArrayList<MixedObject> mixeds = this.getMixedsForCategory("0") ;
        boolean subscruptionContentCompleted = true ;

        if(templateSubscription.getKind().equals(ConsoleUtil.VEAM_SUBSCRIPTION_KIND_MIXED_GRID)){
            int count = mixeds.size() ;
            if(count < 1){
                subscruptionContentCompleted = false ;
            } else {
                int mixedCount = 0 ;
                for(int index = 0 ; index < count ; index++){
                    MixedObject mixed = mixeds.get(index) ;
                    String contentId = mixed.getContentId() ;
                    if(!VeamUtil.isEmpty(contentId) && !contentId.equals("0")){
                        mixedCount++ ;
                    }
                }
                //NSLog("mixedCount %d",mixedCount) ;
                if(mixedCount < 1){
                    subscruptionContentCompleted = false ;
                }
            }
        } else if(templateSubscription.getKind().equals(ConsoleUtil.VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS)){
            int videoCount = sellVideos.size() ;
        int audioCount = sellAudios.size() ;
        int pdfCount = sellPdfs.size() ;
            if((videoCount < 1) && (audioCount < 1) && (pdfCount < 1)){
                subscruptionContentCompleted = false ;
            }
        } else if(templateSubscription.getKind().equals(ConsoleUtil.VEAM_SUBSCRIPTION_KIND_SELL_SECTION)){
        int count = sellSectionItems.size() ; ;
            if(count < 1){
                subscruptionContentCompleted = false ;
            }
        }
        return subscruptionContentCompleted ;
    }

    public boolean isForumCompleted()
    {
        boolean forumCompleted = true ;
        int count = forums.size() ;
        //NSLog("forum count %d",count) ;
        if(count < 2){
            forumCompleted = false ;
        }
        return forumCompleted ;
    }

    public boolean isLinksCompleted()
    {
        boolean linksCompleted = true ;
        int count = webs.size() ;
        //NSLog("web count %d",count) ;
        if(count < 0){
            linksCompleted = false ;
        } else {
            for(int index = 0 ; index < count ; index++){
                WebObject web = webs.get(index) ;
                String url = web.getUrl() ;
                if(url.equals("https://www.facebook.com/VeamApp") || url.equals("https://twitter.com/VeamApp")){
                    linksCompleted = false ;
                }
            }
        }
        return linksCompleted ;
    }



    public boolean isRatingCompleted()
    {
        boolean ratingCompleted = true ;
        int count = appRatingQuestions.size() ;
        for(int index = 0 ; index < count ; index++){
            AppRatingQuestion appRatingQuestion = appRatingQuestions.get(index) ;
            if(VeamUtil.isEmpty(appRatingQuestion.getAnswer())){
                ratingCompleted = false ;
            }
        }
        return ratingCompleted ;
    }











    public String escapeNull(String string)
    {
        String retValue = string ;
        if(retValue == null){
            retValue = "" ;
        }
        return retValue ;
    }



/////////////////////////////////////////////////////////////////////////////////
    // App
/////////////////////////////////////////////////////////////////////////////////
    public void setAppBackgroundImage(String image)
    {
        String apiName = "app/setbackgroundimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"background.png","n") ;
        this.sendData(apiName,params,image,appInfo) ;
    }

    public void setAppCustomBackgroundImage(String image)
    {
        String apiName = "app/setcustombackgroundimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"background.png","n") ;
        this.sendData(apiName,params,image,appInfo) ;
    }

    public void setAppSplashImage(String image)
    {
        String apiName = "app/setsplashimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"initial_background.png","n") ;
        this.sendData(apiName,params,image,appInfo) ;
    }

    public void setAppTermsAccepted()
    {

        String userName = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_USER_ID) ;
        String password = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_PASSWORD) ;

        String apiName = "app/acceptterms" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,userName,"un") ;
        ConsoleUtil.putValueAndKey(params,password,"pw") ;
        this.sendData(apiName,params,null,null) ;
    }

    public void submitToMcn()
    {

        String userName = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_USER_ID) ;
        String password = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_PASSWORD) ;

        String apiName = "app/submittomcn" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,userName,"un") ;
        ConsoleUtil.putValueAndKey(params,password,"pw") ;
        this.sendData(apiName,params,null,null) ;
    }

    public boolean canSubmitToMcn()
    {
        ArrayList<String> requiredOperations = this.getRequiredOperationsToSubmit() ;
        return (requiredOperations.size() == 0) ;
    }

    public void deployContents()
    {

        String userName = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_USER_ID) ;
        String password = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_PASSWORD) ;

        String apiName = "app/deploycontents" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,userName,"un") ;
        ConsoleUtil.putValueAndKey(params,password,"pw") ;
        this.sendData(apiName,params,null,null) ;
    }


    public void setAppIconImage(String image)
    {
        String apiName = "app/seticonimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"icon.png","n") ;
        this.sendData(apiName,params,image,appInfo) ;
    }

    public void setAppCustomIconImage(String image)
    {
        String apiName = "app/setcustomiconimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"icon.png","n") ;
        this.sendData(apiName,params,image,appInfo) ;
    }

    public void setAppScreenShot(String image,String name)
    {
        String apiName = "app/setscreenshot" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,name,"n") ;
        this.sendData(apiName,params,image,appInfo) ;
    }

    public void setAppColor(String colorString,String name)
    {
        ConsoleUtil.putValueAndKey(dictionary,colorString,name) ;
        String apiName = "app/setcolor" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,name,"n") ;
        ConsoleUtil.putValueAndKey(params,colorString,"c") ;
        this.sendData(apiName,params,null,null) ;
    }

    public void setAppData(String value,String name)
    {
        VeamUtil.log("debug","setAppData name="+name) ;
        ConsoleUtil.putValueAndKey(dictionary,value,name) ;
        String apiName = "app/setvalue" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,name,"n") ;
        ConsoleUtil.putValueAndKey(params, value, "v") ;
        if(name.equals("subscription_0_description")){
            VeamUtil.log("debug","subscription_0_description set subscription_description_set") ;
            this.setValueForKey("subscription_description_set","1");
        }
        this.sendData(apiName, params, null, null) ;
    }

    public void setAppName(String name)
    {
        appInfo.setName(name) ;
        this.saveAppInfo() ;
    }

    public void setAppStoreAppName(String name)
    {
        appInfo.setStoreAppName(name) ;
        this.saveAppInfo() ;
    }

    public void setAppDescription(String description)
    {
        appInfo.setDescription(description) ;
        this.saveAppInfo() ;
    }

    public void setAppKeyword(String keyword)
    {
        appInfo.setKeyword(keyword) ;
        this.saveAppInfo() ;
    }

    public void setAppCategory(String category)
    {
        appInfo.setCategory(category) ;
        this.saveAppInfo() ;
    }

    public void saveAppInfo()
    {
        String apiName = "app/setdata" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(appInfo.getName()),"n") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(appInfo.getStoreAppName()),"sn") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(appInfo.getCategory()),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(appInfo.getSubCategory()),"sc") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(appInfo.getDescription()),"d") ;
        ConsoleUtil.putValueAndKey(params, this.escapeNull(appInfo.getKeyword()), "k") ;
        this.sendData(apiName, params, null, null) ;
    }


    public void setConceptColor(String colorString)
    {
        String apiName = "app/setconceptcolor" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(colorString),"c") ;
        this.sendData(apiName,params,null,null) ;
    }



    /*
    public void saveBankAccountInfo
    {
        String apiName = "app/setbankdata" ;
        Map<String,String> params = new HashMap<String,String>() ;
        this.escapeNull(bankAccountInfo.routingNumber),"ro",
        this.escapeNull(bankAccountInfo.accountNumber),"nu",
        this.escapeNull(bankAccountInfo.accountName),"na",
        this.escapeNull(bankAccountInfo.accountType),"ty",
        this.escapeNull(bankAccountInfo.streetAddress),"ad",
        this.escapeNull(bankAccountInfo.city),"ci",
        this.escapeNull(bankAccountInfo.state),"st",
        this.escapeNull(bankAccountInfo.zipCode),"zi",
            null) ;
        this.sendData(apiName,params,null,null) ;
    }
    */

    public int   getNumberOfAppRatingQuestions()
    {
        return appRatingQuestions.size() ;
    }

    public AppRatingQuestion getAppRatingQuestionAt(int index)
    {
        AppRatingQuestion retValue = null ;
        if(index < appRatingQuestions.size()){
        retValue = appRatingQuestions.get(index) ;
    }
        return retValue ;
    }

    public AppRatingQuestion getAppRatingQuestionForId(String appRatingQuestionId)
    {
        int count = appRatingQuestions.size() ;
        AppRatingQuestion retValue = null ;
        for(int index = 0 ; index < count ; index++){
            AppRatingQuestion appRatingQuestion = appRatingQuestions.get(index) ;
            if(appRatingQuestion.getAppRatingQuestionId().equals(appRatingQuestionId)){
                retValue = appRatingQuestion ;
                break ;
            }
        }
        return retValue ;
    }

    public void setAppRatingQuestion(AppRatingQuestion appRatingQuestion)
    {
        if(VeamUtil.isEmpty(appRatingQuestion.getAppRatingQuestionId())){
        appRatingQuestions.add(0,appRatingQuestion) ;
    } else {
        int count = appRatingQuestions.size() ;
        for(int index = 0 ; index  < count ; index++){
            AppRatingQuestion workAppRatingQuestion = appRatingQuestions.get(index) ;
            if(workAppRatingQuestion.getAppRatingQuestionId().equals(appRatingQuestion.getAppRatingQuestionId())){
                appRatingQuestions.remove(index) ;
                appRatingQuestions.add(index,appRatingQuestion) ;
                break ;
            }
        }
    }
        this.saveAppRatingQuestion(appRatingQuestion) ;
    }

    public void saveAppRatingQuestion(AppRatingQuestion appRatingQuestion)
    {
        String apiName = "app/setratingquestion" ;
        String appRatingQuestionId = "" ;
        if(!VeamUtil.isEmpty(appRatingQuestion.getAppRatingQuestionId())){
            appRatingQuestionId = appRatingQuestion.getAppRatingQuestionId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(appRatingQuestionId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(appRatingQuestion.getAnswer()),"an") ;
        this.sendData(apiName, params, null, null) ;
    }


    public String[] getAppCategories(){
        String[] retValue = null ;
        String value = null ;
        if(VeamUtil.isLocaleJapanese()) {
            value = this.getValueForKey("app_categories_ja");
        } else {
            value = this.getValueForKey("app_categories");
        }

        if(value != null){
            retValue = value.split("\\|") ;
        }

        return retValue ;
    }


/////////////////////////////////////////////////////////////////////////////////
    // Subscription
/////////////////////////////////////////////////////////////////////////////////
    public void setTemplateSubscriptionTitle(String title)
    {
        templateSubscription.setTitle(title) ;
        this.saveTemplateSubscription() ;
    }

    public void setTemplateSubscriptionLayout(String layout)
    {
        templateSubscription.setLayout(layout) ;
        this.saveTemplateSubscription() ;
    }

    public void setTemplateSubscriptionPrice(String price)
    {
        //NSLog("setTemplateSubscriptionPrice %",price) ;
        templateSubscription.setPrice(price) ;
        this.saveTemplateSubscription() ;
    }

    public void setTemplateSubscriptionKind(String kind)
    {
        //NSLog("setTemplateSubscriptionKind %",kind) ;
        templateSubscription.setKind(kind) ;
        this.saveTemplateSubscription() ;
    }

    public void setTemplateSubscriptionRightImage(String image)
    {
        String apiName = "subscription/setrightimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"t8_top_right.png","n") ;
        this.sendData(apiName,params,image,templateSubscription) ;
    }

    public void saveTemplateSubscription()
    {
        String apiName = "subscription/setdata" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(templateSubscription.getTitle()),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(templateSubscription.getLayout()),"l") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(templateSubscription.getKind()),"k") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(templateSubscription.getPrice()),"p") ;
        this.sendData(apiName,params,null,null) ;
    }

    public boolean isAppReleased()
    {
        return appInfo.getStatus().equals(ConsoleUtil.VEAM_APP_INFO_STATUS_RELEASED) ;
    }

    public long getNextUploadTime()
    {
        int numberOfMixeds = this.getNumberOfMixedsForCategory("0") ;
        String previousDateString ;
        if(numberOfMixeds <= 2){
            previousDateString = appInfo.getReleasedAt() ;
        } else {
            //MixedObject mixed = this.getMixedForCategory:"0" at:numberOfMixeds-1 order:NSOrderedAscending) ;
            MixedObject mixed = this.getMixedForCategory("0",0,ConsoleUtil.VEAM_ORDER_ASCENDING) ;
            previousDateString = mixed.getCreatedAt() ;
        }

        long uploadSpan = VeamUtil.parseInt(templateSubscription.getUploadSpan()) ;
        long deadline = VeamUtil.parseInt(previousDateString) + (uploadSpan * 86400) ; // 60x60x24=86400

        return deadline ;
    }




/////////////////////////////////////////////////////////////////////////////////
    // Video
/////////////////////////////////////////////////////////////////////////////////
    public void setVideoCategory(VideoCategoryObject videoCategory)
    {
        if(VeamUtil.isEmpty(videoCategory.getId())){
            videoCategories.add(0,videoCategory) ;
        } else {
            int count = videoCategories.size() ;
            for(int index = 0 ; index  < count ; index++){
                VideoCategoryObject workVideoCategory = videoCategories.get(index) ;
                if(workVideoCategory.getId().equals(videoCategory.getId())){
                    videoCategories.remove(index) ;
                    videoCategories.add(index,videoCategory) ;
                    break ;
                }
            }
        }
        this.saveVideoCategory(videoCategory) ;
    }

    public void saveVideoCategory(VideoCategoryObject videoCategory)
    {
        String apiName = "video/setcategory" ;
        String videoCategoryId = "" ;
        if(!VeamUtil.isEmpty(videoCategory.getId())){
            videoCategoryId = videoCategory.getId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(videoCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(videoCategory.getName()),"n") ;
        this.sendData(apiName,params,null,videoCategory) ;
        this.appInfo.setModified("1") ;
    }

    public void removeVideoCategoryAt(int index)
    {
        String videoCategoryIdToBeRemoved = null ;
        int count = videoCategories.size() ;
        if(index < count){
            VideoCategoryObject videoCategory = videoCategories.get(index) ;
            videoCategoryIdToBeRemoved = videoCategory.getId() ;
            videoCategories.remove(index) ;
        }

        if(!VeamUtil.isEmpty(videoCategoryIdToBeRemoved)){
            String apiName = "video/removecategory" ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(videoCategoryIdToBeRemoved),"i") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }

    public int   getNumberOfVideoCategories()
    {
        return videoCategories.size() ;
    }

    public ArrayList<VideoCategoryObject> getVideoCategories()
    {
        return videoCategories ;
    }

    public VideoCategoryObject getVideoCategoryAt(int index)
    {
        VideoCategoryObject retValue = null ;
        if(index < videoCategories.size()){
            retValue = videoCategories.get(index) ;
        }
        return retValue ;
    }

    public void moveVideoCategoryFrom(int fromIndex,int toIndex)
    {
        VideoCategoryObject objectToBeMoved = videoCategories.get(fromIndex) ;
        videoCategories.remove(fromIndex) ;
        videoCategories.add(toIndex,objectToBeMoved) ;
        this.saveVideoCategoryOrder() ;
    }

    public void saveVideoCategoryOrder()
    {
        int count = videoCategories.size() ;
        if(count > 1){
            String apiName = "video/setcategoryorder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                VideoCategoryObject category = videoCategories.get(index) ;
                if(index == 0){
                    orderString = category.getId() ;
                } else {
                    orderString = orderString + String.format(",%s",category.getId()) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }


    public VideoCategoryObject getVideoCategoryForId(String videoCategoryId)
    {
        int count = videoCategories.size() ;
        VideoCategoryObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            VideoCategoryObject videoCategory = videoCategories.get(index) ;
            if(videoCategory.getId().equals(videoCategoryId)){
                retValue = videoCategory ;
                break ;
            }
        }
        return retValue ;
    }

    /*
    public ArrayList<> )getVideoSubCategories:(String )videoCategoryId
    {
        ArrayList<> retValue = videoSubCategoriesPerCategory.get(videoCategoryId) ;
        return retValue ;
    }

    public int   getNumberOfVideoSubCategories:(String )videoCategoryId
    {
        return this.getVideoSubCategories:videoCategoryId).size() ;
    }

    public VideoSubCategory *)getVideoSubCategoryAt:(int)index videoCategoryId:(String )videoCategoryId
    {
        VideoSubCategory *retValue = null ;
        if(index < this.getVideoSubCategories:videoCategoryId).size()){
        retValue = this.getVideoSubCategories:videoCategoryId).get(index) ;
    }
        return retValue ;
    }

    public void moveVideoSubCategoryFrom:(int)fromIndex to:(int)toIndex videoCategoryId:(String )videoCategoryId
    {
        ArrayList<> subCategories = this.getVideoSubCategories:videoCategoryId) ;
        if(subCategories != null){
            VideoSubCategory *objectToBeMoved = subCategories.get(fromIndex) ;
            subCategories.remove(fromIndex) ;
            subCategories.add(xxx,objectToBeMoved,toIndex) ;
            this.saveVideoSubCategoryOrder:videoCategoryId) ;
        }
    }

    public void saveVideoSubCategoryOrder:(String )videoCategoryId
    {

        ArrayList<> subCategories = this.getVideoSubCategories:videoCategoryId) ;
        if(subCategories != null){
            int count = subCategories.size() ;
            if(count > 1){
                String apiName = "video/setsubcategoryorder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    VideoSubCategory *subCategory = subCategories.get(index) ;
                    if(index == 0){
                        orderString = subCategory.videoSubCategoryId ;
                    } else {
                        orderString = orderString  + String.format(",%s",subCategory.videoSubCategoryId) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setVideoSubCategory:(VideoSubCategory *)videoSubCategory
    {
        ArrayList<> subCategories = this.getVideoSubCategories:videoSubCategory.videoCategoryId) ;
        if(subCategories == null){
            subCategories = new ArrayList<>() ; ;
            videoSubCategoriesPerCategory.put(__KEY__,subCategories,videoSubCategory.videoCategoryId) ;
        }

        if(subCategories != null){
            if(VeamUtil.isEmpty(videoSubCategory.videoSubCategoryId)){
                subCategories.add(xxx,videoSubCategory,0) ;
            } else {
                int count = subCategories.size() ;
                for(int index = 0 ; index  < count ; index++){
                    VideoSubCategory *workVideoSubCategory = subCategories.get(index) ;
                    if(workVideoSubCategory.videoSubCategoryId.equals(videoSubCategory.videoSubCategoryId)){
                        subCategories.remove(index) ;
                        subCategories.add(xxx,videoSubCategory,index) ;
                        break ;
                    }
                }
            }
            this.saveVideoSubCategory:videoSubCategory) ;
        }
    }

    public void saveVideoSubCategory:(VideoSubCategory *)videoSubCategory
    {
        String apiName = "video/setsubcategory" ;
        String videoSubCategoryId = "" ;
        if(!VeamUtil.isEmpty(videoSubCategory.videoSubCategoryId)){
        videoSubCategoryId = videoSubCategory.videoSubCategoryId ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(videoSubCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(videoSubCategory.videoCategoryId),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(videoSubCategory.name),"n") ;
        this.sendData(apiName,params,null,videoSubCategory) ;
        this.appInfo.setModified("1") ;
    }

    public void removeVideoSubCategoryAt:(int)index videoCategoryId:(String )videoCategoryId
    {
        ArrayList<> subCategories = this.getVideoSubCategories:videoCategoryId) ;
        if(subCategories != null){
            String videoSubCategoryIdToBeRemoved = null ;
            int count = subCategories.size() ;
            if(index < count){
                VideoSubCategory *videoSubCategory = subCategories.get(index) ;
                videoSubCategoryIdToBeRemoved = videoSubCategory.videoSubCategoryId ;
                subCategories.remove(index) ;
            }

            if(!VeamUtil.isEmpty(videoSubCategoryIdToBeRemoved)){
                String apiName = "video/removesubcategory" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(videoSubCategoryIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    */

    public int   getNumberOfVideosForCategory(String videoCategoryId)
    {
        return this.getVideosForCategory(videoCategoryId).size() ;
    }

    /*
    public int   getNumberOfVideosForSubCategory:(String )videoSubCategoryId
    {
        return this.getVideosForSubCategory:videoSubCategoryId).size() ;
    }
    */

    public ArrayList<VideoObject> getVideosForCategory(String videoCategoryId)
    {
        ArrayList<VideoObject> retValue = videosPerCategory.get(videoCategoryId) ;
        if(retValue == null){
            retValue = new ArrayList<VideoObject>() ;
        }

        return retValue ;
    }

    public int getNumberOfWaitingVideoForCategory(String videoCategoryId)
    {
        int numberOfWaitingVideos = 0 ;
        ArrayList<VideoObject> videos = this.getVideosForCategory(videoCategoryId) ;
        int count = videos.size() ;
        for(int index = 0 ; index < count ; index++){
            VideoObject video = videos.get(index) ;
            if(video.getStatus().equals(ConsoleUtil.VEAM_VIDEO_STATUS_WAITING)){
                numberOfWaitingVideos++ ;
            }
        }
        return numberOfWaitingVideos ;
    }


    public int getNumberOfWaitingMixedForCategory(String mixedCategoryId)
    {
        int numberOfWaitingMixeds = 0 ;
        ArrayList<MixedObject> mixeds = this.getMixedsForCategory(mixedCategoryId) ;
        int count = mixeds.size() ;
        for(int index = 0 ; index < count ; index++){
            MixedObject mixed = mixeds.get(index) ;
            if(mixed.getStatus().equals(ConsoleUtil.VEAM_MIXED_STATUS_WAITING)){
                numberOfWaitingMixeds++ ;
            }
        }
        return numberOfWaitingMixeds ;
    }


    /*
    public ArrayList<> )getVideosForSubCategory:(String )videoSubCategoryId
    {
        ArrayList<> retValue = videosPerSubCategory.get(videoSubCategoryId) ;
        return retValue ;
    }
    */

    public VideoObject getVideoForId(String videoId)
    {
        VideoObject retValue = null ;
        retValue = videosForVideoId.get(videoId) ;
        return retValue ;
    }

    public VideoObject getVideoForCategory(String videoCategoryId,int index)
    {
        VideoObject retValue = null ;
        ArrayList<VideoObject> videos = this.getVideosForCategory(videoCategoryId) ;
        retValue = videos.get(index) ;
        return retValue ;
    }

    /*
    public VideoObject getVideoForSubCategory(String videoSubCategoryId,int index)
    {
        VideoObject retValue = null ;
        ArrayList<VideoObject> videos = this.getVideosForSubCategory(videoSubCategoryId) ;
        retValue = videos.get(index) ;
        return retValue ;
    }
    */

    public void moveVideoForCategory(String videoCategoryId,int fromIndex,int toIndex)
    {
        ArrayList<VideoObject> videos = this.getVideosForCategory(videoCategoryId) ;
        if(videos != null){
            VideoObject objectToBeMoved = videos.get(fromIndex) ;
            videos.remove(fromIndex) ;
            videos.add(toIndex,objectToBeMoved) ;
            this.saveVideoOrder(videos) ;
        }
    }

    /*
    public void moveVideoForSubCategory(String videoSubCategoryId,int fromIndex,int toIndex)
    {
        ArrayList<> videos = this.getVideosForSubCategory:videoSubCategoryId) ;
        if(videos != null){
            VideoObject objectToBeMoved = videos.get(fromIndex) ;
            videos.remove(fromIndex) ;
            videos.add(xxx,objectToBeMoved,toIndex) ;
            this.saveVideoOrder:videos) ;
        }
    }
    */

    public void saveVideoOrder(ArrayList<VideoObject> videos)
    {
        if(videos != null){
            int count = videos.size() ;
            if(count > 1){
                String apiName = "video/setvideoorder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    VideoObject video = videos.get(index) ;
                    if(index == 0){
                        orderString = video.getId() ;
                    } else {
                        orderString = orderString + String.format(",%s",video.getId()) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setVideo(VideoObject video,String thumbnailImage)
    {
        ArrayList<VideoObject> videos = null ;
        if(video.getVideoSubCategoryId().equals("0")){
            videos = this.getVideosForCategory(video.getVideoCategoryId()) ;
        } else {
            //videos = this.getVideosForSubCategory:video.videoSubCategoryId) ;
        }

        if(videos == null){
            videos = new ArrayList<VideoObject>() ;
            if(video.getVideoSubCategoryId().equals("0")){
                videosPerCategory.put(video.getVideoCategoryId(),videos) ;
            } else {
                //videosPerSubCategory.put(__KEY__,videos,video.videoSubCategoryId) ;
            }
        }

        if(videos != null){
            if(VeamUtil.isEmpty(video.getId())){
                videos.add(0,video) ;
            } else {
                int count = videos.size() ;
                for(int index = 0 ; index  < count ; index++){
                    VideoObject workVideo = videos.get(index) ;
                    if(workVideo.getId().equals(video.getId())){
                        videos.remove(index) ;
                        videos.add(index,video) ;
                        break ;
                    }
                }
            }
            this.saveVideo(video,thumbnailImage) ;
        }
    }

    public void saveVideo(VideoObject video,String thumbnailImage)
    {
        VeamUtil.log("debug","saveVideo") ;
        MixedObject mixed = video.getMixed() ;
        if((mixed != null) && !VeamUtil.isEmpty(mixed.getKind())){
            VeamUtil.log("debug","set mixed for video") ;
            String apiName = "mixed/setvideo" ;
            //NSLog("%",apiName) ;
            String videoId = "" ;
            if(!VeamUtil.isEmpty(video.getId())){
                videoId = video.getId() ;
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getId()),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getMixedCategoryId()),"c") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getMixedSubCategoryId()),"sub") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getKind()),"k") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(""),"vi") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getTitle()),"t") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getSourceUrl()),"su") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getThumbnailUrl()),"iu") ;
            this.sendData(apiName,params,thumbnailImage,mixed) ;
            this.appInfo.setModified("1") ;
        } else {
            String apiName = "video/setvideo" ;
            //NSLog("%",apiName) ;
            String videoId = "" ;
            if(!VeamUtil.isEmpty(video.getId())){
                videoId = video.getId() ;
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(videoId),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getVideoCategoryId()),"c") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getVideoSubCategoryId()),"sub") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getTitle()),"t") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getKind()),"k") ;
            //this.escapeNull(video.duration),"dur",
            ConsoleUtil.putValueAndKey(params,this.escapeNull(video.getThumbnailUrl()),"su") ;
            this.sendData(apiName,params,thumbnailImage,video) ;
            this.appInfo.setModified("1") ;
        }
    }

    public void updatePreparingVideoStatus(String videoCategoryId)
    {
        String apiName = "video/getvideostatus" ;

        String preparingVideoIds = "" ;

        ArrayList<VideoObject> videos = this.getVideosForCategory(videoCategoryId) ;
        int count = videos.size() ;
        for(int index = 0 ; index < count ; index++){
            VideoObject video = videos.get(index) ;
            if(video.getStatus().equals(ConsoleUtil.VEAM_VIDEO_STATUS_PREPARING)){
                if(!VeamUtil.isEmpty(preparingVideoIds)){
                    preparingVideoIds = preparingVideoIds + String.format(",%s",video.getId()) ;
                } else {
                    preparingVideoIds = video.getId() ;
                }
            }
        }

        if(!VeamUtil.isEmpty(preparingVideoIds)){
            ConsoleUpdatePreparingVideoStatusHandler handler = new ConsoleUpdatePreparingVideoStatusHandler() ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(preparingVideoIds),"i") ;
            this.sendData(apiName,params,null,handler) ;
        }
    }



    public void removeVideoForCategory(String videoCategoryId,int index)
    {
        ArrayList<VideoObject> videos = this.getVideosForCategory(videoCategoryId) ;
        this.removeVideoFrom(videos,index) ;
    }

    /*
    public void removeVideoForSubCategory(String videoSubCategoryId at:(int)index
    {
        ArrayList<> videos = this.getVideosForSubCategory:videoSubCategoryId) ;
        this.removeVideoFrom:videos at:index) ;
    }
    */

    public void removeVideoFrom(ArrayList<VideoObject> videos,int index)
    {
        if(videos != null){
            String videoIdToBeRemoved = null ;
            int count = videos.size() ;
            if(index < count){
                VideoObject video = videos.get(index) ;
                videoIdToBeRemoved = video.getId() ;
                videos.remove(index) ;
            }

            if(!VeamUtil.isEmpty(videoIdToBeRemoved)){
                String apiName = "video/removevideo" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(videoIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }


    public int   getNumberOfSellVideosForVideoCategory(String videoCategoryId)
    {
        //NSLog("getNumberOfSellVideosForVideoCategory videoCategoryId=%",videoCategoryId) ;
        int retValue = 0 ;
        ArrayList<SellVideoObject> sellVideosForCategory = this.getSellVideosForVideoCategory(videoCategoryId) ;
        if(sellVideosForCategory != null){
            retValue = sellVideosForCategory.size() ;
        }
        return retValue ;
    }

    public ArrayList<SellVideoObject> getSellVideosForVideoCategory(String videoCategoryId)
    {
        ArrayList<SellVideoObject> retValue = new ArrayList<SellVideoObject>() ;
        int count = sellVideos.size() ;
        //NSLog("getSellVideosForVideoCategory count=%d",count) ;
        for(int index = 0 ; index < count ; index++){
            SellVideoObject sellVideo = sellVideos.get(index) ;
            if(sellVideo != null){
                VideoObject video = this.getVideoForId(sellVideo.getVideoId()) ;
                if(video != null){
                    if(video.getVideoCategoryId().equals(videoCategoryId)){
                        retValue.add(sellVideo) ;
                    }
                }
            }
        }
        return retValue ;
    }

    public SellVideoObject getSellVideoForVideoCategory(String videoCategoryId,int index,int order)
    {
        SellVideoObject retValue = null ;
        ArrayList<SellVideoObject> sellVideosForCategory = this.getSellVideosForVideoCategory(videoCategoryId) ;
        if(sellVideosForCategory != null){
            if(sellVideosForCategory.size() >index){
                retValue = sellVideosForCategory.get(index) ;
            }
        }

        return retValue ;
    }



    public void removeSellVideoForVideoCategory(String videoCategoryId,int index)
    {
        ArrayList<SellVideoObject> sellVideosForCategory = this.getSellVideosForVideoCategory(videoCategoryId) ;
        this.removeSellVideoFrom(sellVideosForCategory,index) ;
    }

    public void removeSellVideoFrom(ArrayList<SellVideoObject> sellVideosForCategory,int index)
    {
        if(sellVideosForCategory != null){
            String sellVideoIdToBeRemoved = null ;
            int count = sellVideosForCategory.size() ;
            if(index < count){
                SellVideoObject sellVideo = sellVideosForCategory.get(index) ;
                sellVideoIdToBeRemoved = sellVideo.getId() ;
                sellVideosForCategory.remove(index) ;
            }

            if(!VeamUtil.isEmpty(sellVideoIdToBeRemoved)){
                String apiName = "sellitem/removesellvideo" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params, this.escapeNull(sellVideoIdToBeRemoved), "i") ;
                this.sendData(apiName, params, null, null) ;
                this.appInfo.setModified("1") ;
                count = sellVideos.size() ;
                //NSLog("sellVideos count=%d",count) ;
                for(int sellVideoIndex = 0 ; sellVideoIndex < count ; sellVideoIndex++){
                    SellVideoObject sellVideo = sellVideos.get(sellVideoIndex) ;
                    if(sellVideo != null){
                        String workSellVideoId = sellVideo.getId() ;
                        if(sellVideoIdToBeRemoved.equals(workSellVideoId)){
                            sellVideos.remove(sellVideoIndex) ;
                            break ;
                        }
                    }
                }
                sellVideosForSellVideoId.remove(sellVideoIdToBeRemoved) ;
            }
        }
    }










    public SellVideoObject getSellVideoForId(String sellVideoId)
    {
        SellVideoObject retValue = null ;
        retValue = sellVideosForSellVideoId.get(sellVideoId) ;
        return retValue ;
    }

    public void setSellVideo(SellVideoObject sellVideo,String videoCategoryId,String videoTitle,String videoSourceUrl,String videoImageUrl)
    {
        ArrayList<SellVideoObject> workSellVideos = null ;
        workSellVideos = this.getSellVideosForVideoCategory(videoCategoryId) ;

        if(workSellVideos == null){
            workSellVideos = new ArrayList<SellVideoObject>() ;
        }

        if(workSellVideos != null){
            if(VeamUtil.isEmpty(sellVideo.getId())){
                workSellVideos.add(0,sellVideo) ;
            } else {
                int count = workSellVideos.size() ;
                for(int index = 0 ; index  < count ; index++){
                    SellVideoObject workSellVideo = workSellVideos.get(index) ;
                    if(workSellVideo.getId().equals(sellVideo.getId())){
                        workSellVideos.remove(index) ;
                        workSellVideos.add(index,sellVideo) ;
                        break ;
                    }
                }
            }
            this.saveSellVideo(sellVideo,videoCategoryId,videoTitle,videoSourceUrl,videoImageUrl) ;
        }
    }

    public void saveSellVideo(SellVideoObject sellVideo,String videoCategoryId,String videoTitle,String videoSourceUrl,String videoImageUrl)
    {
        String apiName = "sellitem/setvideo" ;
        //NSLog("%",apiName) ;
        String sellVideoId = "" ;
        if(!VeamUtil.isEmpty(sellVideo.getId())){
        sellVideoId = sellVideo.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellVideoId),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(videoCategoryId),"c") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(sellVideo.getDescription()),"d") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(sellVideo.getPrice()),"p") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(videoTitle),"t") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(videoSourceUrl),"su") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(videoImageUrl),"iu") ;

        VideoObject video = new VideoObject() ;
        video.setTitle(videoTitle) ;
        video.setVideoCategoryId(videoCategoryId) ;

        ConsoleSellVideoPostHandler consoleSellVideoPostHandler = new ConsoleSellVideoPostHandler() ;
        consoleSellVideoPostHandler.setSellVideo(sellVideo) ;
        consoleSellVideoPostHandler.setVideo(video) ;

        this.sendData(apiName,params,null,consoleSellVideoPostHandler) ;
        this.appInfo.setModified("1") ;
    }















/////////////////////////////////////////////////////////////////////////////////
    // Audio
/////////////////////////////////////////////////////////////////////////////////
    /*
    public ArrayList<AudioObject> getAudiosForSubCategory(String audioSubCategoryId)
    {
        ArrayList<AudioObject> retValue = audiosPerSubCategory.get(audioSubCategoryId) ;
        return retValue ;
    }
    */

    public ArrayList<AudioObject> getAudiosForCategory(String audioCategoryId)
    {
        ArrayList<AudioObject> retValue = audiosPerCategory.get(audioCategoryId) ;
        if(retValue == null){
            retValue = new ArrayList<AudioObject>() ;
        }

        return retValue ;
    }

    public void setAudio(AudioObject audio,String thumbnailImage)
    {
        ArrayList<AudioObject> audios = null ;
        if(audio.getAudioSubCategoryId().equals("0")){
            audios = this.getAudiosForCategory(audio.getAudioCategoryId()) ;
        } else {
            //audios = this.getAudiosForSubCategory:audio.getAudioSubCategoryId()) ;
        }

        if(audios == null){
            audios = new ArrayList<AudioObject>() ;
            if(audio.getAudioSubCategoryId().equals("0")){
                audiosPerCategory.put(audio.getAudioCategoryId(),audios) ;
            } else {
                //audiosPerSubCategory.put(__KEY__,audios,audio.getAudioSubCategoryId()) ;
            }
        }

        if(audios != null){
            if(VeamUtil.isEmpty(audio.getId())){
                audios.add(0,audio) ;
            } else {
                int count = audios.size() ;
                for(int index = 0 ; index  < count ; index++){
                    AudioObject workAudio = audios.get(index) ;
                    if(workAudio.getId().equals(audio.getId())){
                        audios.remove(index) ;
                        audios.add(index,audio) ;
                        break ;
                    }
                }
            }
            this.saveAudio(audio,thumbnailImage) ;
        }
    }

    public void saveAudio(AudioObject audio,String thumbnailImage)
    {
        MixedObject mixed = audio.getMixed() ;
        if((mixed != null) && !VeamUtil.isEmpty(mixed.getKind())){
            String apiName = "mixed/setaudio" ;
            //NSLog("%",apiName) ;
            String audioId = "" ;
            if(!VeamUtil.isEmpty(audio.getId())){
                audioId = audio.getId() ;
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getId()),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getMixedCategoryId()),"c") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getMixedSubCategoryId()),"sub") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getKind()),"k") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(""),"ai") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(audio.getTitle()),"t") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(audio.getDataUrl()),"su") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(audio.getLinkUrl()),"lu") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(audio.getThumbnailUrl()),"iu") ;
            this.sendData(apiName,params,null,mixed) ;
            this.appInfo.setModified("1") ;
        } else {
            /* not implemented
            String apiName = "audio/setaudio" ;
            NSLog("%",apiName) ;
            String audioId = "" ;
            if(!VeamUtil.isEmpty(audio.getId())){
                audioId = audio.getId() ;
            }
            Map<String,String> params = new HashMap<String,String>() ;
                                    this.escapeNull(audioId),"i",
                                    this.escapeNull(audio.getAudioCategoryId()),"c",
                                    this.escapeNull(audio.getAudioSubCategoryId()),"sub",
                                    this.escapeNull(audio.title),"t",
                                    this.escapeNull(audio.kind),"k",
                                    //this.escapeNull(audio.duration),"dur",
                                    this.escapeNull(audio.sourceUrl),"su",
                                    null) ;
            this.sendData(apiName,params image:thumbnailImage HandlePostResultInterface:audio) ;
             */
        }
    }




    public AudioObject getAudioForId(String audioId)
    {
        AudioObject retValue = null ;
        retValue = audiosForAudioId.get(audioId) ;
        return retValue ;
    }






    public int   getNumberOfSellAudiosForAudioCategory(String audioCategoryId)
    {
        //NSLog("getNumberOfSellAudiosForAudioCategory audioCategoryId=%",audioCategoryId) ;
        int retValue = 0 ;
        ArrayList<SellAudioObject> sellAudiosForCategory = this.getSellAudiosForAudioCategory(audioCategoryId) ;
        if(sellAudiosForCategory != null){
            retValue = sellAudiosForCategory.size() ;
        }
        return retValue ;
    }

    public ArrayList<SellAudioObject> getSellAudiosForAudioCategory(String audioCategoryId)
    {
        ArrayList<SellAudioObject> retValue = new ArrayList<SellAudioObject>() ;
        int count = sellAudios.size() ;
        VeamUtil.log("debug","getSellAudiosForAudioCategory id="+audioCategoryId+" count="+count) ;
        for(int index = 0 ; index < count ; index++){
            SellAudioObject sellAudio = sellAudios.get(index) ;
            if(sellAudio != null){
                AudioObject audio = this.getAudioForId(sellAudio.getAudioId()) ;
                if(audio != null){
                    VeamUtil.log("debug","audio.getAudioCategoryId()="+audio.getAudioCategoryId()) ;
                    if(audio.getAudioCategoryId().equals(audioCategoryId)){
                        retValue.add(sellAudio) ;
                    }
                }
            }
        }
        return retValue ;
    }

    public SellAudioObject getSellAudioForAudioCategory(String audioCategoryId,int index,int order)
    {
        SellAudioObject retValue = null ;
        ArrayList<SellAudioObject> sellAudiosForCategory = this.getSellAudiosForAudioCategory(audioCategoryId) ;
        if(sellAudiosForCategory != null){
            if(sellAudiosForCategory.size() >index){
                retValue = sellAudiosForCategory.get(index) ;
            }
        }

        return retValue ;
    }

    public SellAudioObject getSellAudioForId(String sellAudioId)
    {
        SellAudioObject retValue = null ;
        retValue = sellAudiosForSellAudioId.get(sellAudioId) ;
        return retValue ;
    }




    public void removeSellAudioForAudioCategory(String audioCategoryId,int index)
    {
        ArrayList<SellAudioObject> sellAudiosForCategory = this.getSellAudiosForAudioCategory(audioCategoryId) ;
        this.removeSellAudioFrom(sellAudiosForCategory, index) ;
    }

    public void removeSellAudioFrom(ArrayList<SellAudioObject> sellAudiosForCategory,int index)
    {
        if(sellAudiosForCategory != null){
            String sellAudioIdToBeRemoved = null ;
            int count = sellAudiosForCategory.size() ;
            if(index < count){
                SellAudioObject sellAudio = sellAudiosForCategory.get(index) ;
                sellAudioIdToBeRemoved = sellAudio.getId() ;
                sellAudiosForCategory.remove(index) ;
            }

            if(!VeamUtil.isEmpty(sellAudioIdToBeRemoved)){
                String apiName = "sellitem/removesellaudio" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params, this.escapeNull(sellAudioIdToBeRemoved), "i") ;
                this.sendData(apiName, params, null, null) ;
                this.appInfo.setModified("1") ;
                count = sellAudios.size() ;
                for(int sellAudioIndex = 0 ; sellAudioIndex < count ; sellAudioIndex++){
                    SellAudioObject sellAudio = sellAudios.get(sellAudioIndex) ;
                    if(sellAudio != null){
                        String workSellAudioId = sellAudio.getId() ;
                        if(sellAudioIdToBeRemoved.equals(workSellAudioId)){
                            sellAudios.remove(sellAudioIndex) ;
                            break ;
                        }
                    }
                }
                sellAudiosForSellAudioId.remove(sellAudioIdToBeRemoved) ;
            }
        }
    }









    public void setSellAudio(SellAudioObject sellAudio,String audioCategoryId,String audioTitle,String audioSourceUrl,String audioImageUrl,String audioLinkUrl)
    {
        ArrayList<SellAudioObject> workSellAudios = null ;
        workSellAudios = this.getSellAudiosForAudioCategory(audioCategoryId) ;

        if(workSellAudios == null){
            workSellAudios = new ArrayList<SellAudioObject>() ;
        }

        if(workSellAudios != null){
            if(VeamUtil.isEmpty(sellAudio.getId())){
                workSellAudios.add(0,sellAudio) ;
            } else {
                int count = workSellAudios.size() ;
                for(int index = 0 ; index  < count ; index++){
                    SellAudioObject workSellAudio = workSellAudios.get(index) ;
                    if(workSellAudio.getId().equals(sellAudio.getId())){
                        workSellAudios.remove(index) ;
                        workSellAudios.add(index,sellAudio) ;
                        break ;
                    }
                }
            }
            this.saveSellAudio(sellAudio,audioCategoryId,audioTitle ,audioSourceUrl ,audioImageUrl ,audioLinkUrl) ;
        }
    }

    public void saveSellAudio(SellAudioObject sellAudio ,String audioCategoryId ,String audioTitle ,String audioSourceUrl ,String audioImageUrl ,String audioLinkUrl)
    {
        String apiName = "sellitem/setaudio" ;
        //NSLog("%",apiName) ;
        String sellAudioId = "" ;
        if(!VeamUtil.isEmpty(sellAudio.getId())){
            sellAudioId = sellAudio.getId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellAudioId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(audioCategoryId),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellAudio.getDescription()),"d") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellAudio.getPrice()),"p") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(audioTitle),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(audioSourceUrl),"su") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(audioImageUrl),"iu") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(audioLinkUrl),"lu") ;

        AudioObject audio = new AudioObject() ;
        audio.setTitle(audioTitle) ;
        audio.setAudioCategoryId(audioCategoryId) ;

        ConsoleSellAudioPostHandler consoleSellAudioPostHandler = new ConsoleSellAudioPostHandler() ;
        consoleSellAudioPostHandler.setSellAudio(sellAudio) ;
        consoleSellAudioPostHandler.setAudio(audio) ;

        this.sendData(apiName,params,null,consoleSellAudioPostHandler) ;
        this.appInfo.setModified("1") ;
    }

    public AudioCategoryObject getAudioCategoryForId(String audioCategoryId)
    {
        int count = audioCategories.size() ;
        AudioCategoryObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            AudioCategoryObject audioCategory = audioCategories.get(index) ;
            if(audioCategory.getId().equals(audioCategoryId)){
                retValue = audioCategory ;
                break ;
            }
        }
        return retValue ;
    }
















/////////////////////////////////////////////////////////////////////////////////
    // Youtube
/////////////////////////////////////////////////////////////////////////////////
    public void setTemplateYoutubeTitle(String title)
    {
        templateYoutube.setTitle(title) ;
        this.saveTemplateYoutube() ;
    }

    public void setTemplateYoutubeEmbedFlag(boolean embedFlag)
    {
        templateYoutube.setEmbedFlag(embedFlag ? "1" : "0") ;
        this.saveTemplateYoutube() ;
    }

    public void setTemplateYoutubeEmbedUrl(String url)
    {
        templateYoutube.setEmbedUrl(url) ;
        this.saveTemplateYoutube() ;
    }

    public void setTemplateYoutubeLeftImage(String image)
    {
        String apiName = "youtube/setleftimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"t1_top_left.png","n") ;
        this.sendData(apiName,params,image,templateYoutube) ;
    }

    public void setTemplateYoutubeRightImage(String image)
    {
        String apiName = "youtube/setrightimage" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,"t1_top_right.png","n") ;
        this.sendData(apiName, params, image, templateYoutube) ;
    }

    public void saveTemplateYoutube()
    {
        String apiName = "youtube/setdata" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(templateYoutube.getTitle()),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(templateYoutube.getEmbedFlag()),"e") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(templateYoutube.getEmbedUrl()),"u") ;
        this.sendData(apiName,params,null,null) ;
    }

    public void setYoutubeCategory(YoutubeCategoryObject youtubeCategory)
    {
        if(VeamUtil.isEmpty(youtubeCategory.getId())){
            youtubeCategories.add(0,youtubeCategory) ;
        } else {
            int count = youtubeCategories.size() ;
            for(int index = 0 ; index  < count ; index++){
                YoutubeCategoryObject workYoutubeCategory = youtubeCategories.get(index) ;
                if(workYoutubeCategory.getId().equals(youtubeCategory.getId())){
                    youtubeCategories.remove(index) ;
                    youtubeCategories.add(index,youtubeCategory) ;
                    break ;
                }
            }
        }
        this.saveYoutubeCategory(youtubeCategory) ;
    }

    public void saveYoutubeCategory(YoutubeCategoryObject youtubeCategory)
    {
        String apiName = "youtube/setcategory" ;
        String youtubeCategoryId = "" ;
        if(!VeamUtil.isEmpty(youtubeCategory.getId())){
            youtubeCategoryId = youtubeCategory.getId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeCategoryId),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeCategory.getName()),"n") ;
            //ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeCategory.getEmbed()),"e") ;
            //ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeCategory.getEmbedUrl()),"u") ;
        this.sendData(apiName,params,null,youtubeCategory) ;
    }

    public void removeYoutubeCategoryAt(int index)
    {
        String youtubeCategoryIdToBeRemoved = null ;
        int count = youtubeCategories.size() ;
        if(index < count){
            YoutubeCategoryObject youtubeCategory = youtubeCategories.get(index) ;
            youtubeCategoryIdToBeRemoved = youtubeCategory.getId() ;
            youtubeCategories.remove(index) ;
        }

        if(!VeamUtil.isEmpty(youtubeCategoryIdToBeRemoved)){
        String apiName = "youtube/removecategory" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeCategoryIdToBeRemoved),"i") ;
        this.sendData(apiName,params,null,null) ;
        this.appInfo.setModified("1") ;
    }
    }

    public void disableYoutubeCategoryAt(int index,boolean disabled)
    {
        int count = youtubeCategories.size() ;
        if(index < count){
            String disableString = disabled?"1":"0" ;
            YoutubeCategoryObject youtubeCategory = youtubeCategories.get(index) ;
            youtubeCategory.setDisabled(disableString) ;

            String apiName = "youtube/disablecategory" ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeCategory.getId()),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(disableString),"d") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }

    public int getNumberOfYoutubeCategories()
    {
        return youtubeCategories.size() ;
    }

    public ArrayList<YoutubeCategoryObject> getYoutubeCategories()
    {
        return youtubeCategories ;
    }

    public YoutubeCategoryObject getYoutubeCategoryAt(int index)
    {
        YoutubeCategoryObject retValue = null ;
        if(index < youtubeCategories.size()){
        retValue = youtubeCategories.get(index) ;
    }
        return retValue ;
    }

    public void moveYoutubeCategoryFrom(int fromIndex,int toIndex)
    {
        YoutubeCategoryObject objectToBeMoved = youtubeCategories.get(fromIndex) ;
        youtubeCategories.remove(fromIndex) ;
        youtubeCategories.add(toIndex,objectToBeMoved) ;
        this.saveYoutubeCategoryOrder() ;
    }

    public void saveYoutubeCategoryOrder()
    {
        int count = youtubeCategories.size() ;
        if(count > 1){
            String apiName = "youtube/setcategoryorder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                YoutubeCategoryObject category = youtubeCategories.get(index) ;
                if(index == 0){
                    orderString = category.getId() ;
                } else {
                    orderString = orderString + String.format(",%s",category.getId()) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }


    public YoutubeCategoryObject getYoutubeCategoryForId(String youtubeCategoryId)
    {
        int count = youtubeCategories.size() ;
        YoutubeCategoryObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            YoutubeCategoryObject youtubeCategory = youtubeCategories.get(index) ;
            if(youtubeCategory.getId().equals(youtubeCategoryId)){
                retValue = youtubeCategory ;
                break ;
            }
        }
        return retValue ;
    }

    /*
    public ArrayList<> )getYoutubeSubCategories:(String )youtubeCategoryId
    {
        ArrayList<> retValue = youtubeSubCategoriesPerCategory.get(youtubeCategoryId) ;
        return retValue ;
    }

    public int   getNumberOfYoutubeSubCategories:(String )youtubeCategoryId
    {
        return this.getYoutubeSubCategories:youtubeCategoryId).size() ;
    }

    public YoutubeSubCategory *)getYoutubeSubCategoryAt:(int)index youtubeCategoryId:(String )youtubeCategoryId
    {
        YoutubeSubCategory *retValue = null ;
        if(index < this.getYoutubeSubCategories:youtubeCategoryId).size()){
        retValue = this.getYoutubeSubCategories:youtubeCategoryId).get(index) ;
    }
        return retValue ;
    }

    public void moveYoutubeSubCategoryFrom:(int)fromIndex to:(int)toIndex youtubeCategoryId:(String )youtubeCategoryId
    {
        ArrayList<> subCategories = this.getYoutubeSubCategories:youtubeCategoryId) ;
        if(subCategories != null){
            YoutubeSubCategory *objectToBeMoved = subCategories.get(fromIndex) ;
            subCategories.remove(fromIndex) ;
            subCategories.add(xxx,objectToBeMoved,toIndex) ;
            this.saveYoutubeSubCategoryOrder:youtubeCategoryId) ;
        }
    }

    public void saveYoutubeSubCategoryOrder:(String )youtubeCategoryId
    {

        ArrayList<> subCategories = this.getYoutubeSubCategories:youtubeCategoryId) ;
        if(subCategories != null){
            int count = subCategories.size() ;
            if(count > 1){
                String apiName = "youtube/setsubcategoryorder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    YoutubeSubCategory *subCategory = subCategories.get(index) ;
                    if(index == 0){
                        orderString = subCategory.youtubeSubCategoryId ;
                    } else {
                        orderString = orderString  + String.format(",%s",subCategory.youtubeSubCategoryId) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setYoutubeSubCategory:(YoutubeSubCategory *)youtubeSubCategory
    {
        ArrayList<> subCategories = this.getYoutubeSubCategories:youtubeSubCategory.youtubeCategoryId) ;
        if(subCategories == null){
            subCategories = new ArrayList<>() ; ;
            youtubeSubCategoriesPerCategory.put(__KEY__,subCategories,youtubeSubCategory.youtubeCategoryId) ;
        }

        if(subCategories != null){
            if(VeamUtil.isEmpty(youtubeSubCategory.youtubeSubCategoryId)){
                subCategories.add(xxx,youtubeSubCategory,0) ;
            } else {
                int count = subCategories.size() ;
                for(int index = 0 ; index  < count ; index++){
                    YoutubeSubCategory *workYoutubeSubCategory = subCategories.get(index) ;
                    if(workYoutubeSubCategory.youtubeSubCategoryId.equals(youtubeSubCategory.youtubeSubCategoryId)){
                        subCategories.remove(index) ;
                        subCategories.add(xxx,youtubeSubCategory,index) ;
                        break ;
                    }
                }
            }
            this.saveYoutubeSubCategory:youtubeSubCategory) ;
        }
    }

    public void saveYoutubeSubCategory:(YoutubeSubCategory *)youtubeSubCategory
    {
        String apiName = "youtube/setsubcategory" ;
        String youtubeSubCategoryId = "" ;
        if(!VeamUtil.isEmpty(youtubeSubCategory.youtubeSubCategoryId)){
        youtubeSubCategoryId = youtubeSubCategory.youtubeSubCategoryId ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeSubCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeSubCategory.youtubeCategoryId),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeSubCategory.name),"n") ;
        this.sendData(apiName,params,null,youtubeSubCategory) ;
        this.appInfo.setModified("1") ;
    }

    public void removeYoutubeSubCategoryAt:(int)index youtubeCategoryId:(String )youtubeCategoryId
    {
        ArrayList<> subCategories = this.getYoutubeSubCategories:youtubeCategoryId) ;
        if(subCategories != null){
            String youtubeSubCategoryIdToBeRemoved = null ;
            int count = subCategories.size() ;
            if(index < count){
                YoutubeSubCategory *youtubeSubCategory = subCategories.get(index) ;
                youtubeSubCategoryIdToBeRemoved = youtubeSubCategory.youtubeSubCategoryId ;
                subCategories.remove(index) ;
            }

            if(!VeamUtil.isEmpty(youtubeSubCategoryIdToBeRemoved)){
                String apiName = "youtube/removesubcategory" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeSubCategoryIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }
    */

    public int getNumberOfYoutubesForCategory(String youtubeCategoryId)
    {
        return this.getYoutubesForCategory(youtubeCategoryId).size() ;
    }

    /*
    public int getNumberOfYoutubesForSubCategory(String youtubeSubCategoryId)
    {
        return this.getYoutubesForSubCategory(youtubeSubCategoryId).size() ;
    }
    */

    public ArrayList<YoutubeObject> getYoutubesForCategory(String youtubeCategoryId)
    {
        ArrayList<YoutubeObject> retValue = youtubesPerCategory.get(youtubeCategoryId) ;
        if(retValue == null){
            retValue = new ArrayList<YoutubeObject>() ;
        }

        return retValue ;
    }

    /*
    public ArrayList<> )getYoutubesForSubCategory:(String )youtubeSubCategoryId
    {
        ArrayList<> retValue = youtubesPerSubCategory.get(youtubeSubCategoryId) ;
        return retValue ;
    }
    */

    public YoutubeObject getYoutubeForId(String youtubeId)
    {
        YoutubeObject retValue = null ;
        retValue = youtubesForYoutubeId.get(youtubeId) ;
        return retValue ;
    }

    public YoutubeObject getYoutubeForCategory(String youtubeCategoryId,int index)
    {
        YoutubeObject retValue = null ;
        ArrayList<YoutubeObject> youtubes = this.getYoutubesForCategory(youtubeCategoryId) ;
        retValue = youtubes.get(index) ;
        return retValue ;
    }

    /*
    public YoutubeObject getYoutubeForSubCategory(String youtubeSubCategoryId,int index)
    {
        YoutubeObject retValue = null ;
        ArrayList<YoutubeObject> youtubes = this.getYoutubesForSubCategory(youtubeSubCategoryId) ;
        retValue = youtubes.get(index) ;
        return retValue ;
    }
    */

    public void moveYoutubeForCategory(String youtubeCategoryId,int fromIndex,int toIndex)
    {
        ArrayList<YoutubeObject> youtubes = this.getYoutubesForCategory(youtubeCategoryId) ;
        if(youtubes != null){
            YoutubeObject objectToBeMoved = youtubes.get(fromIndex) ;
            youtubes.remove(fromIndex) ;
            youtubes.add(toIndex,objectToBeMoved) ;
            this.saveYoutubeOrder(youtubes) ;
        }
    }

    /*
    public void moveYoutubeForSubCategory(String youtubeSubCategoryId,int fromIndex ,int toIndex)
    {
        ArrayList<YoutubeObject> youtubes = this.getYoutubesForSubCategory(youtubeSubCategoryId) ;
        if(youtubes != null){
            YoutubeObject objectToBeMoved = youtubes.get(fromIndex) ;
            youtubes.remove(fromIndex) ;
            youtubes insertObject(objectToBeMoved,toIndex) ;
            this.saveYoutubeOrder(youtubes) ;
        }
    }
    */

    public void saveYoutubeOrder(ArrayList<YoutubeObject> youtubes)
    {
        if(youtubes != null){
            int count = youtubes.size() ;
            if(count > 1){
                String apiName = "youtube/setyoutubeorder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    YoutubeObject youtube = youtubes.get(index) ;
                    if(index == 0){
                        orderString = youtube.getId() ;
                    } else {
                        orderString = orderString  + String.format(",%s",youtube.getId()) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setYoutube(YoutubeObject youtube)
    {
        ArrayList<YoutubeObject> youtubes = null ;
        if(youtube.getYoutubeSubCategoryId().equals("0")){
        youtubes = this.getYoutubesForCategory(youtube.getYoutubeCategoryId()) ;
    } else {
        //youtubes = this.getYoutubesForSubCategory(youtube.getYoutubeSubCategoryId()) ;
    }

        if(youtubes == null){
            youtubes = new ArrayList<YoutubeObject>() ;
            if(youtube.getYoutubeSubCategoryId().equals("0")){
                youtubesPerCategory.put(youtube.getYoutubeCategoryId(),youtubes) ;
            } else {
                //youtubesPerSubCategory setObject(youtubes,youtube.getYoutubeSubCategoryId()) ;
            }
        }

        if(youtubes != null){
            if(VeamUtil.isEmpty(youtube.getId())){
                youtubes.add(0, youtube) ;
            } else {
                int count = youtubes.size() ;
                for(int index = 0 ; index  < count ; index++){
                    YoutubeObject workYoutube = youtubes.get(index) ;
                    if(workYoutube.getId().equals(youtube.getId())){
                        youtubes.remove(index) ;
                        youtubes.add(index,youtube) ;
                        break ;
                    }
                }
            }
            this.saveYoutube(youtube) ;
        }
    }

    public void saveYoutube(YoutubeObject youtube)
    {
        String apiName = "youtube/setyoutube" ;
        String youtubeId = "" ;
        if(!VeamUtil.isEmpty(youtube.getId())){
        youtubeId = youtube.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtube.getYoutubeCategoryId()),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtube.getYoutubeSubCategoryId()),"sub") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtube.getKind()),"k") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtube.getTitle()),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtube.getYoutubeVideoId()),"v") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtube.getDuration()),"dur") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(youtube.getDescription()),"des") ;
        this.sendData(apiName,params,null,youtube) ;
        this.appInfo.setModified("1") ;
    }


    public void removeYoutubeForCategory(String youtubeCategoryId,int index)
    {
        ArrayList<YoutubeObject> youtubes = this.getYoutubesForCategory(youtubeCategoryId) ;
        this.removeYoutubeFrom(youtubes,index) ;
    }

    /*
    public void removeYoutubeForSubCategory(String youtubeSubCategoryId,int index)
    {
        ArrayList<> youtubes = this.getYoutubesForSubCategory(youtubeSubCategoryId) ;
        this.removeYoutubeFrom(youtubes at:index) ;
    }
    */

    public void removeYoutubeFrom(ArrayList<YoutubeObject> youtubes,int index)
    {
        if(youtubes != null){
            String youtubeIdToBeRemoved = null ;
            int count = youtubes.size() ;
            if(index < count){
                YoutubeObject youtube = youtubes.get(index) ;
                youtubeIdToBeRemoved = youtube.getId() ;
                youtubes.remove(index) ;
            }

            if(!VeamUtil.isEmpty(youtubeIdToBeRemoved)){
                String apiName = "youtube/removeyoutube" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(youtubeIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }







/////////////////////////////////////////////////////////////////////////////////
    // AlternativeImage
/////////////////////////////////////////////////////////////////////////////////
    public AlternativeImageObject getAlternativeImageForFileName(String fileName)
    {
        return alternativeImagesForFileName.get(fileName) ;
    }






/////////////////////////////////////////////////////////////////////////////////
    // Mixed
/////////////////////////////////////////////////////////////////////////////////
    public void setTemplateMixedTitle(String title)
    {
        templateMixed.setTitle(title) ;
        this.saveTemplateMixed() ;
    }

    public void saveTemplateMixed()
    {
        String apiName = "mixed/setdata" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params, this.escapeNull(templateMixed.getTitle()), "t") ;
        this.sendData(apiName, params, null, null) ;
    }

    /*
    public void setMixedCategory(MixedCategoryObject mixedCategory)
    {
        if(VeamUtil.isEmpty(mixedCategory.getId())){
        mixedCategories insertObject(mixedCategory,0) ;
    } else {
        int count = mixedCategories.size() ;
        for(int index = 0 ; index  < count ; index++){
            MixedCategoryObject workMixedCategory = mixedCategories.get(index) ;
            if(workmixedCategory.getId().equals(mixedCategory.getId())){
                mixedCategories.remove(index) ;
                mixedCategories insertObject(mixedCategory,index) ;
                break ;
            }
        }
    }
        this.saveMixedCategory(mixedCategory) ;
    }

    public void saveMixedCategory:(MixedCategoryObject )mixedCategory
    {
        String apiName = "mixed/setcategory" ;
        String mixedCategoryId = "" ;
        if(!VeamUtil.isEmpty(mixedCategory.getId())){
        mixedCategoryId = mixedCategory.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedCategory.name),"n") ;
        this.sendData(apiName,params,null,mixedCategory) ;
        this.appInfo.setModified("1") ;
    }

    public void removeMixedCategoryAt:(int)index
    {
        String mixedCategoryIdToBeRemoved = null ;
        int count = mixedCategories.size() ;
        if(index < count){
            MixedCategoryObject mixedCategory = mixedCategories.get(index) ;
            mixedCategoryIdToBeRemoved = mixedCategory.getId() ;
            mixedCategories.remove(index) ;
        }

        if(!VeamUtil.isEmpty(mixedCategoryIdToBeRemoved)){
        String apiName = "mixed/removecategory" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedCategoryIdToBeRemoved),"i") ;
        this.sendData(apiName,params,null,null) ;
        this.appInfo.setModified("1") ;
    }
    }

    public int   getNumberOfMixedCategories
    {
        return mixedCategories.size() ;
    }

    public ArrayList<> )getMixedCategories
    {
        return mixedCategories ;
    }

    public MixedCategoryObject )getMixedCategoryAt:(int)index
    {
        MixedCategoryObject retValue = null ;
        if(index < mixedCategories.size()){
        retValue = mixedCategories.get(index) ;
    }
        return retValue ;
    }

    public void moveMixedCategoryFrom:(int)fromIndex to:(int)toIndex
    {
        MixedCategoryObject objectToBeMoved = mixedCategories.get(fromIndex) ;
        mixedCategories.remove(fromIndex) ;
        mixedCategories insertObject(objectToBeMoved,toIndex) ;
        this.saveMixedCategoryOrder) ;
    }

    public void saveMixedCategoryOrder
    {
        int count = mixedCategories.size() ;
        if(count > 1){
            String apiName = "mixed/setcategoryorder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                MixedCategoryObject category = mixedCategories.get(index) ;
                if(index == 0){
                    orderString = category.mixedCategoryId ;
                } else {
                    orderString = orderString  + String.format(",%s",category.mixedCategoryId) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }


    public MixedCategoryObject )getMixedCategoryForId:(String )mixedCategoryId
    {
        int count = mixedCategories.size() ;
        MixedCategoryObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            MixedCategoryObject mixedCategory = mixedCategories.get(index) ;
            if(mixedCategory mixedCategoryId).equals(mixedCategoryId)){
                retValue = mixedCategory ;
                break ;
            }
        }
        return retValue ;
    }

    public ArrayList<> )getMixedSubCategories:(String )mixedCategoryId
    {
        ArrayList<> retValue = mixedSubCategoriesPerCategory objectForKey(mixedCategoryId) ;
        return retValue ;
    }

    public int   getNumberOfMixedSubCategories:(String )mixedCategoryId
    {
        return this.getMixedSubCategories(mixedCategoryId).size() ;
    }

    public MixedSubCategory *)getMixedSubCategoryAt:(int)index mixedCategoryId:(String )mixedCategoryId
    {
        MixedSubCategory *retValue = null ;
        if(index < this.getMixedSubCategories(mixedCategoryId).size()){
        retValue = this.getMixedSubCategories(mixedCategoryId).get(index) ;
    }
        return retValue ;
    }

    public void moveMixedSubCategoryFrom:(int)fromIndex to:(int)toIndex mixedCategoryId:(String )mixedCategoryId
    {
        ArrayList<> subCategories = this.getMixedSubCategories(mixedCategoryId) ;
        if(subCategories != null){
            MixedSubCategory *objectToBeMoved = subCategories.get(fromIndex) ;
            subCategories.remove(fromIndex) ;
            subCategories insertObject(objectToBeMoved,toIndex) ;
            this.saveMixedSubCategoryOrder(mixedCategoryId) ;
        }
    }

    public void saveMixedSubCategoryOrder:(String )mixedCategoryId
    {

        ArrayList<> subCategories = this.getMixedSubCategories(mixedCategoryId) ;
        if(subCategories != null){
            int count = subCategories.size() ;
            if(count > 1){
                String apiName = "mixed/setsubcategoryorder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    MixedSubCategory *subCategory = subCategories.get(index) ;
                    if(index == 0){
                        orderString = subCategory.mixedSubCategoryId ;
                    } else {
                        orderString = orderString  + String.format(",%s",subCategory.mixedSubCategoryId) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setMixedSubCategory:(MixedSubCategory *)mixedSubCategory
    {
        ArrayList<> subCategories = this.getMixedSubCategories(mixedSubCategory.mixedCategoryId) ;
        if(subCategories == null){
            subCategories = new ArrayList<>() ; ;
            mixedSubCategoriesPerCategory setObject(subCategories,mixedSubCategory.mixedCategoryId) ;
        }

        if(subCategories != null){
            if(VeamUtil.isEmpty(mixedSubCategory.mixedSubCategoryId)){
                subCategories insertObject(mixedSubCategory,0) ;
            } else {
                int count = subCategories.size() ;
                for(int index = 0 ; index  < count ; index++){
                    MixedSubCategory *workMixedSubCategory = subCategories.get(index) ;
                    if(workMixedSubCategory.mixedSubCategoryId.equals(mixedSubCategory.mixedSubCategoryId)){
                        subCategories.remove(index) ;
                        subCategories insertObject(mixedSubCategory,index) ;
                        break ;
                    }
                }
            }
            this.saveMixedSubCategory(mixedSubCategory) ;
        }
    }

    public void saveMixedSubCategory:(MixedSubCategory *)mixedSubCategory
    {
        String apiName = "mixed/setsubcategory" ;
        String mixedSubCategoryId = "" ;
        if(!VeamUtil.isEmpty(mixedSubCategory.mixedSubCategoryId)){
        mixedSubCategoryId = mixedSubCategory.mixedSubCategoryId ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedSubCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedSubCategory.mixedCategoryId),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedSubCategory.name),"n") ;
        this.sendData(apiName,params,null,mixedSubCategory) ;
        this.appInfo.setModified("1") ;
    }

    public void removeMixedSubCategoryAt:(int)index mixedCategoryId:(String )mixedCategoryId
    {
        ArrayList<> subCategories = this.getMixedSubCategories(mixedCategoryId) ;
        if(subCategories != null){
            String mixedSubCategoryIdToBeRemoved = null ;
            int count = subCategories.size() ;
            if(index < count){
                MixedSubCategory *mixedSubCategory = subCategories.get(index) ;
                mixedSubCategoryIdToBeRemoved = mixedSubCategory.mixedSubCategoryId ;
                subCategories.remove(index) ;
            }

            if(!VeamUtil.isEmpty(mixedSubCategoryIdToBeRemoved)){
                String apiName = "mixed/removesubcategory" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedSubCategoryIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }
    */

    public int   getNumberOfMixedsForCategory(String mixedCategoryId)
    {
        return this.getMixedsForCategory(mixedCategoryId).size() ;
    }

    /*
    public int getNumberOfMixedsForSubCategory(String mixedSubCategoryId)
    {
        return this.getMixedsForSubCategory(mixedSubCategoryId).size() ;
    }
    */

    public ArrayList<MixedObject> getMixedsForCategory(String mixedCategoryId)
    {
        ArrayList<MixedObject> retValue = mixedsPerCategory.get(mixedCategoryId) ;
        if(retValue == null){
            retValue = new ArrayList<MixedObject>() ;
        }
        return retValue ;
    }

    /*
    public ArrayList<MixedObject> getMixedsForSubCategory(String mixedSubCategoryId)
    {
        ArrayList<MixedObject> retValue = mixedsPerSubCategory.get(mixedSubCategoryId) ;
        return retValue ;
    }
    */

    public MixedObject getMixedForId(String mixedId)
    {
        MixedObject retValue = null ;
        retValue = mixedsForMixedId.get(mixedId) ;
        return retValue ;
    }

    public MixedObject getMixedForCategory(String mixedCategoryId ,int index,int order)
    {
        MixedObject retValue = null ;
        ArrayList<MixedObject> mixeds = this.getMixedsForCategory(mixedCategoryId) ;
        int targetIndex = index ;
        if(order == ConsoleUtil.VEAM_ORDER_DESCENDING){
            targetIndex = mixeds.size() - index - 1 ;
        }
        retValue = mixeds.get(targetIndex) ;
        return retValue ;
    }

    /*
    public MixedObject getMixedForSubCategory(String mixedSubCategoryId,int index)
    {
        MixedObject retValue = null ;
        ArrayList<MixedObject> mixeds = this.getMixedsForSubCategory(mixedSubCategoryId) ;
        retValue = mixeds.get(index) ;
        return retValue ;
    }
    */

    public void moveMixedForCategory(String mixedCategoryId ,int fromIndex,int toIndex)
    {
        ArrayList<MixedObject> mixeds = this.getMixedsForCategory(mixedCategoryId) ;
        if(mixeds != null){
            MixedObject objectToBeMoved = mixeds.get(fromIndex) ;
            mixeds.remove(fromIndex) ;
            mixeds.add(toIndex,objectToBeMoved) ;
            this.saveMixedOrder(mixeds) ;
        }
    }

    /*
    public void moveMixedForSubCategory(String mixedSubCategoryId,int fromIndex,int toIndex)
    {
        ArrayList<MixedObject> mixeds = this.getMixedsForSubCategory(mixedSubCategoryId) ;
        if(mixeds != null){
            MixedObject objectToBeMoved = mixeds.get(fromIndex) ;
            mixeds.remove(fromIndex) ;
            mixeds.add(toIndex,objectToBeMoved) ;
            this.saveMixedOrder(mixeds) ;
        }
    }
    */

    public void saveMixedOrder(ArrayList<MixedObject> mixeds)
    {
        if(mixeds != null){
            int count = mixeds.size() ;
            if(count > 1){
                String apiName = "mixed/setmixedorder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    MixedObject mixed = mixeds.get(index) ;
                    if(index == 0){
                        orderString = mixed.getId() ;
                    } else {
                        orderString = orderString  + String.format(",%s",mixed.getId()) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setMixed(MixedObject mixed)
    {
        ArrayList<MixedObject> mixeds = null ;
        if(mixed.getMixedSubCategoryId().equals("0")){
        mixeds = this.getMixedsForCategory(mixed.getMixedCategoryId()) ;
    } else {
        //mixeds = this.getMixedsForSubCategory(mixed.getMixedSubCategoryId()) ;
    }

        if(mixeds == null){
            mixeds = new ArrayList<MixedObject>() ;
            if(mixed.getMixedSubCategoryId().equals("0")){
                mixedsPerCategory.put(mixed.getMixedCategoryId(),mixeds) ;
            } else {
                //mixedsPerSubCategory setObject(mixeds,mixed.getMixedSubCategoryId()) ;
            }
        }

        if(mixeds != null){
            if(VeamUtil.isEmpty(mixed.getId())){
                mixeds.add(0, mixed) ;
            } else {
                int count = mixeds.size() ;
                for(int index = 0 ; index  < count ; index++){
                    MixedObject workMixed = mixeds.get(index) ;
                    if(workMixed.getId().equals(mixed.getId())){
                        mixeds.remove(index) ;
                        mixeds.add(index, mixed) ;
                        break ;
                    }
                }
            }
            //this.saveMixed:mixed) ;
        }
    }

/*
public void saveMixed:(MixedObject )mixed
{
    String apiName = "mixed/setmixed" ;
    String mixedId = "" ;
    if(!VeamUtil.isEmpty(mixed.getId())){
        mixedId = mixed.getId() ;
    }
    Map<String,String> params = new HashMap<String,String>() ;
                            this.escapeNull(mixedId),"i",
                            this.escapeNull(mixed.getMixedCategoryId()),"c",
                            this.escapeNull(mixed.getMixedSubCategoryId()),"sub",
                            this.escapeNull(mixed.kind),"k",
                            this.escapeNull(mixed.title),"t",
                            this.escapeNull(mixed.contentId),"ci",
                            null) ;
    this.sendData(apiName,params,null,mixed) ;
}
*/


    public void updatePreparingMixedStatus(String mixedCategoryId)
    {
        VeamUtil.log("debug","ConsoleContents::updatePreparingMixedStatus " + mixedCategoryId) ;

        String apiName = "mixed/getmixedstatus" ;

        String preparingMixedIds = "" ;

        ArrayList<MixedObject> mixeds = this.getMixedsForCategory(mixedCategoryId) ;
        int count = mixeds.size() ;
        for(int index = 0 ; index < count ; index++){
            MixedObject mixed = mixeds.get(index) ;
            if(mixed.getStatus().equals(ConsoleUtil.VEAM_MIXED_STATUS_PREPARING)){
                if(!VeamUtil.isEmpty(preparingMixedIds)){
                    preparingMixedIds = preparingMixedIds  + String.format(",%s",mixed.getId()) ;
                } else {
                    preparingMixedIds = mixed.getId() ;
                }
            }
        }

        if(!VeamUtil.isEmpty(preparingMixedIds)){
            ConsoleUpdatePreparingMixedStatusHandler handler = new ConsoleUpdatePreparingMixedStatusHandler() ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(preparingMixedIds),"i") ;
            this.sendData(apiName,params,null,handler) ;
        }
    }




    public void updatePreparingSellVideoStatus(String videoCategoryId)
    {
        String apiName = "sellitem/getsellvideostatus" ;

        String preparingSellVideoIds = "" ;

        ArrayList<SellVideoObject> sellVideos = this.getSellVideosForVideoCategory(videoCategoryId) ;
        int count = sellVideos.size() ;
        for(int index = 0 ; index < count ; index++){
            SellVideoObject sellVideo = sellVideos.get(index) ;
            if(sellVideo.getStatus().equals(ConsoleUtil.VEAM_SELL_VIDEO_STATUS_PREPARING) || sellVideo.getStatus().equals(ConsoleUtil.VEAM_SELL_VIDEO_STATUS_SUBMITTING)){
                if(!VeamUtil.isEmpty(preparingSellVideoIds)){
                    preparingSellVideoIds = preparingSellVideoIds  + String.format(",%s",sellVideo.getId()) ;
                } else {
                    preparingSellVideoIds = sellVideo.getId() ;
                }
            }
        }

        if(!VeamUtil.isEmpty(preparingSellVideoIds)){
            ConsoleUpdatePreparingSellVideoStatusHandler handler = new ConsoleUpdatePreparingSellVideoStatusHandler() ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(preparingSellVideoIds),"i") ;
            this.sendData(apiName,params,null,handler) ;
        }
    }


    public void updatePreparingSellPdfStatus(String pdfCategoryId)
    {
        String apiName = "sellitem/getsellpdfstatus" ;

        String preparingSellPdfIds = "" ;

        ArrayList<SellPdfObject> sellPdfs = this.getSellPdfsForPdfCategory(pdfCategoryId) ;
        int count = sellPdfs.size() ;
        for(int index = 0 ; index < count ; index++){
            SellPdfObject sellPdf = sellPdfs.get(index) ;
            if(sellPdf.getStatus().equals(ConsoleUtil.VEAM_SELL_PDF_STATUS_PREPARING) || sellPdf.getStatus().equals(ConsoleUtil.VEAM_SELL_PDF_STATUS_SUBMITTING)){
                if(!VeamUtil.isEmpty(preparingSellPdfIds)){
                    preparingSellPdfIds = preparingSellPdfIds + String.format(",%s",sellPdf.getId()) ;
                } else {
                    preparingSellPdfIds = sellPdf.getId() ;
                }
            }
        }

        if(!VeamUtil.isEmpty(preparingSellPdfIds)){
        ConsoleUpdatePreparingSellPdfStatusHandler handler = new ConsoleUpdatePreparingSellPdfStatusHandler() ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(preparingSellPdfIds),"i") ;
        this.sendData(apiName,params,null,handler) ;
    }
    }

    public void updatePreparingSellAudioStatus(String audioCategoryId)
    {
        VeamUtil.log("debug","ConsoleContent::updatePreparingSellAudioStatus") ;
        String apiName = "sellitem/getsellaudiostatus" ;

        String preparingSellAudioIds = "" ;

        ArrayList<SellAudioObject> sellAudios = this.getSellAudiosForAudioCategory(audioCategoryId) ;
        int count = sellAudios.size() ;
        for(int index = 0 ; index < count ; index++){
            SellAudioObject sellAudio = sellAudios.get(index) ;
            VeamUtil.log("debug","sellAudio id="+sellAudio.getId() + " status="+sellAudio.getStatus()) ;
            if(sellAudio.getStatus().equals(ConsoleUtil.VEAM_SELL_AUDIO_STATUS_PREPARING) || sellAudio.getStatus().equals(ConsoleUtil.VEAM_SELL_AUDIO_STATUS_SUBMITTING)){
                if(!VeamUtil.isEmpty(preparingSellAudioIds)){
                    preparingSellAudioIds = preparingSellAudioIds  + String.format(",%s",sellAudio.getId()) ;
                } else {
                    preparingSellAudioIds = sellAudio.getId() ;
                }
            }
        }

        if(!VeamUtil.isEmpty(preparingSellAudioIds)){
            ConsoleUpdatePreparingSellAudioStatusHandler handler = new ConsoleUpdatePreparingSellAudioStatusHandler() ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(preparingSellAudioIds),"i") ;
            this.sendData(apiName,params,null,handler) ;
        }
    }



    public void removeMixedForCategory(String mixedCategoryId,int index)
    {
        ArrayList<MixedObject> mixeds = this.getMixedsForCategory(mixedCategoryId) ;
        this.removeMixedFrom(mixeds,index) ;

    }

    /*
    public void removeMixedForSubCategory(String mixedSubCategoryId,int index)
    {
        ArrayList<MixedObject> mixeds = this.getMixedsForSubCategory(mixedSubCategoryId) ;
        this.removeMixedFrom(mixeds,index) ;
    }
    */

    public void removeMixedFrom(ArrayList<MixedObject> mixeds,int index)
    {
        if(mixeds != null){
            String mixedIdToBeRemoved = null ;
            int count = mixeds.size() ;
            if(index < count){
                MixedObject mixed = mixeds.get(index) ;
                mixedIdToBeRemoved = mixed.getId() ;
                if(this.isAppReleased() || (index >= 2)){
                    mixeds.remove(index) ;
                } else {
                    mixed.setKind("0") ;
                    mixed.setContentId("0");
                    if(index == 0){
                        mixed.setTitle("Welcome");
                    } else {
                        mixed.setTitle("Bonus");
                    }
                    mixed.setDisplayName("");
                    mixed.setThumbnailUrl("") ;
                    mixed.setStatus("1") ;
                    mixed.setStatusText(String.format("%d",index+1)) ;
                }
            }

            if(!VeamUtil.isEmpty(mixedIdToBeRemoved)){
                String apiName = "mixed/removemixed" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    /*
    public void setRecipe:(Recipe *)recipe recipeImage:(Image )recipeImage
    {
        this.setMixed(recipe.mixed) ;

        if(VeamUtil.isEmpty(recipe.recipeId)){
        recipes insertObject(recipe,0) ;
    } else {
        int count = recipes.size() ;
        for(int index = 0 ; index  < count ; index++){
            Recipe *workRecipe = recipes.get(index) ;
            if(workRecipe.recipeId.equals(recipe.recipeId)){
                recipes.remove(index) ;
                recipes insertObject(recipe,index) ;
                break ;
            }
        }
    }
        this.saveRecipe(recipe recipeImage:recipeImage) ;
    }

    public void saveRecipe:(Recipe *)recipe recipeImage:(Image )recipeImage
    {
        String apiName = "mixed/setrecipe" ;

        MixedObject mixed = recipe.mixed ;

        String mixedId = "" ;
        if(!VeamUtil.isEmpty(mixed.getId())){
        mixedId = mixed.getId() ;
    }

        String recipeId = "" ;
        if(!VeamUtil.isEmpty(recipe.recipeId)){
        recipeId = recipe.recipeId ;
    }

        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixedId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getMixedCategoryId()),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.getMixedSubCategoryId()),"sub") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(mixed.kind),"k") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(recipe.title),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(recipe.recipeId),"ri") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(recipe.ingredients),"ing") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(recipe.directions),"dir") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(recipe.nutrition),"nut") ;
        this.sendData(apiName,params image:recipeImage HandlePostResultInterface:recipe) ;
        this.appInfo.setModified("1") ;
    }

    public Recipe *)getRecipeForId:(String )recipeId
    {
        //NSLog("getRecipeForId:%",recipeId) ;
        Recipe *retValue = null ;
        int count = recipes.size() ;
        for(int index = 0 ; index < count ;index++){
            Recipe *workRecipe = recipes.get(index) ;
            if(workRecipe.recipeId.equals(recipeId)){
                retValue = workRecipe ;
                break ;
            }
        }

        return retValue ;
    }
    */












/////////////////////////////////////////////////////////////////////////////////
    // etc
/////////////////////////////////////////////////////////////////////////////////
    /*
    public id)initWithResourceFile
    {
        //NSLog("ConsoleContents::initWithResourceFile") ;
        // load content
        NSFileManager *fileManager = NSFileManager defaultManager) ;
        String contentsStorePath = VeamUtil getFilePathAtCachesDirectory:CONSOLE_CONTENTS_FILE_NAME) ;
        if (!fileManager fileExistsAtPath:contentsStorePath)) {
        String defaultStorePath = NSBundle mainBundle) pathForResource:CONSOLE_DEFAULT_CONTENTS_FILE_NAME ofType:null) ;
        if(defaultStorePath){
            //NSLog("copy contents") ;
            fileManager copyItemAtPath:defaultStorePath toPath:contentsStorePath error:NULL);
        }
    }
        //NSLog("console contents url : %",contentsStorePath) ;
        NSURL *contentsFileUrl = NSURL fileURLWithPath:contentsStorePath) ;
        return this.initWithUrl:contentsFileUrl) ;
    }
    */

    /*
    public id)initWithUrl:(NSURL *)url ;
    {
        //NSLog("ConsoleContents::initWithUrl url=%",url.absoluteString) ;
        self = super init) ;

        NSXMLParser *parser = NSXMLParser alloc) initWithContentsOfURL:url) ;
        this.startParsing:parser) ;

        return self ;
    }
    */

    /*
    public id)initWithServerData
    {
        //NSLog("ConsoleContents::initWithServerData") ;
        String urlString  = String.format:"%",ConsoleUtil getApiUrl:"content/list")) ;
        //NSLog("urlString String url = %",urlString) ;
        NSURL *url = NSURL URLWithString:urlString) ;
        //NSLog("update url : %",url absoluteString)) ;

        String userName = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_USER_ID) ;
        String password = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(), VeamUtil.VEAM_CONSOLE_KEY_PASSWORD) ;

        NSMutableURLRequest *request = NSMutableURLRequest alloc) initWithURL: url) ;
        request setHTTPMethod: "POST") ;
        String boundary = "0x0hHai1CanHazB0undar135" ;
        String contentType = String.format:"multipart/form-data; boundary=%", boundary) ;
        request setValue:contentType forHTTPHeaderField:"Content-Type");

        NSMutableData *body = NSMutableData data);

        body appendData:String.format:"--%\r\n", boundary) dataUsingEncoding:NSUTF8StringEncoding)) ;
        body appendData:"Content-Disposition: form-data; name=\"un\"\r\n" dataUsingEncoding:NSUTF8StringEncoding)) ;
        body appendData:"\r\n" dataUsingEncoding:NSUTF8StringEncoding)) ;
        ody appendData:userName dataUsingEncoding:NSUTF8StringEncoding)) ;
        body appendData:"\r\n" dataUsingEncoding:NSUTF8StringEncoding)) ;

        body appendData:String.format:"--%\r\n", boundary) dataUsingEncoding:NSUTF8StringEncoding)) ;
        ody appendData:Content-Disposition: form-data; name=\"pw\"\r\n" dataUsingEncoding:NSUTF8StringEncoding)) ;
        body appendData:\r\n" dataUsingEncoding:NSUTF8StringEncoding)) ;
        body appendData:password dataUsingEncoding:NSUTF8StringEncoding)) ;
        body appendData:\r\n" dataUsingEncoding:NSUTF8StringEncoding)) ;

        body appendData:String.format:"--%--\r\n",boundary) dataUsingEncoding:NSUTF8StringEncoding)) ;

        request setHTTPBody:body) ;

        //NSLog("url=%",url.absoluteString) ;
        //NSLog("body=%",NSString alloc) initWithData:body encoding:NSUTF8StringEncoding)) ;
        NSURLResponse *response = null ;
        NSError *error = null;
        NSData *data = NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error) ;

        // error
        String error_str = error localizedDescription) ;
        if (0 == error_str length)) {
        String string = NSString alloc) initWithData:data encoding:NSUTF8StringEncoding) ;
        if(!string.equals("NO_UPDATE")){
            // get bank accout info
            return this.initWithData:data) ; // analyze sync
        }
    }

        return this.init) ;
    }
    */

    /*
    public id)initWithData:(NSData *)data
    {
        //NSLog("ConsoleContents::initWithData") ;
        self = super init) ;

        xmlData = data ;

        NSXMLParser *parser = NSXMLParser alloc) initWithData:data) ;
        this.startParsing:parser) ;

        return self ;
    }
    */

    /*
    public void startParsing:(NSXMLParser *)parser
    {
        this.setup) ;

        isParsing = YES ;

        parser setDelegate:self);
        parser setShouldProcessNamespaces:NO);
        parser setShouldReportNamespacePrefixes:NO);
        parser setShouldResolveExternalEntities:NO);
        parser parse);

        NSError *parseError = parser parserError);
        if (parseError) {
            NSLog("error: %", parseError);
        }
    }
    */

    public void setup()
    {
        dictionary = new HashMap<String,String>() ;

        // app
        appRatingQuestions = new ArrayList<AppRatingQuestion>() ;
        //bankAccountInfo = BankAccountInfo  ;

        // forum
        templateForum = new TemplateForum() ;
        forums = new ArrayList<ForumObject>() ;

        // subscription
        templateSubscription = new TemplateSubscription()  ;

        // youtube
        templateYoutube = new TemplateYoutube()  ;
        youtubeCategories = new ArrayList<YoutubeCategoryObject>()  ;
        //youtubeSubCategoriesPerCategory = new HashMap<String,>();
        youtubesPerCategory = new HashMap<String,ArrayList<YoutubeObject>>();
        youtubesPerSubCategory = new HashMap<String,ArrayList<YoutubeObject>>();
        youtubesForYoutubeId = new HashMap<String,YoutubeObject>();

        // mixed
        templateMixed = new TemplateMixed()  ;
        //mixedCategories = new ArrayList<>()  ;
        //mixedSubCategoriesPerCategory = new HashMap<String,>();
        mixedsPerCategory = new HashMap<String,ArrayList<MixedObject>>();
        //mixedsPerSubCategory = new HashMap<String,>();
        mixedsForMixedId = new HashMap<String,MixedObject>();
        //recipes = new ArrayList<>()  ;
        //recipesForId = new HashMap<String,>();

        // video
        videoCategories = new ArrayList<VideoCategoryObject>()  ;
        //videoSubCategoriesPerCategory = new HashMap<String,>();
        videosPerCategory = new HashMap<String,ArrayList<VideoObject>>();
        //videosPerSubCategory = new HashMap<String,>();
        videosForVideoId = new HashMap<String,VideoObject>();
        sellVideos = new ArrayList<SellVideoObject>()  ;
        sellVideosForSellVideoId = new HashMap<String,SellVideoObject>();

        // sell item
        sellItemCategories = new ArrayList<SellItemCategoryObject>()  ;

        // sell section
        sellSectionCategories = new ArrayList<SellSectionCategoryObject>()  ;
        sellSectionItems = new ArrayList<SellSectionItemObject>()  ;
        sellSectionItemsForSellSectionItemId = new HashMap<String,SellSectionItemObject>();


        // pdf
        pdfCategories = new ArrayList<PdfCategoryObject>()  ;
        //pdfSubCategoriesPerCategory = new HashMap<String,>();
        pdfsPerCategory = new HashMap<String,ArrayList<PdfObject>>();
        //pdfsPerSubCategory = new HashMap<String,>();
        pdfsForPdfId = new HashMap<String,PdfObject>();
        sellPdfs = new ArrayList<>()  ;
        sellPdfsForSellPdfId = new HashMap<String,SellPdfObject>();

        // audio
        audioCategories = new ArrayList<AudioCategoryObject>()  ;
        //audioSubCategoriesPerCategory = new HashMap<String,>();
        audiosPerCategory = new HashMap<String,ArrayList<AudioObject>>();
        //audiosPerSubCategory = new HashMap<String,>();
        audiosForAudioId = new HashMap<String,AudioObject>();
        sellAudios = new ArrayList<SellAudioObject>()  ;
        sellAudiosForSellAudioId = new HashMap<String,SellAudioObject>();

        // web
        templateWeb = new TemplateWeb()  ;
        webs = new ArrayList<WebObject>()  ;

        // etc
        alternativeImages = new ArrayList<AlternativeImageObject>()  ;
        alternativeImagesForFileName = new HashMap<String,AlternativeImageObject>();




    }

    /*
    public ArrayList<> getCustomizeElementsForKind:(int)kind ;
    {
        ArrayList<> retValue = null ;
        switch (kind) {
            case VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN:
                retValue = customizeElementsForDesign ;
                break;
            case VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE:
                retValue = customizeElementsForFeature ;
                break;
            case VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION:
                retValue = customizeElementsForSubscription ;
                break;

            default:
                break;
        }

        return retValue ;
    }
    */


    public void sendData(String apiName,Map<String,String> params,String image,HandlePostResultInterface handlePostResultInterface)
    {
        PostConsoleDataTask postConsoleDataTask = new PostConsoleDataTask(apiName,params,image,handlePostResultInterface) ;
        postConsoleDataTask.execute() ;
        ConsoleUtil.setContentsChanged(true);
        //ConsoleUtil postContentsUpdateNotification) ;
    }

    /*
    public void doPost:(ConsolePostData *)postData
    {
        //NSLog("ConsoleContents::doPost") ;
        autoreleasepool
        {
            //isChanged = YES ;
            AppDelegate sharedInstance) setIsContentsChanged:YES) ;
            ArrayList<> results = ConsoleUtil doPost:postData) ;
            NSDictionary *userInfo = NSDictionary dictionaryWithObjectsAndKeys:"CONTENT_POST_DONE","ACTION",postData.apiName,"API_NAME",results,"RESULTS",null) ;
            ConsoleUtil postContentsUpdateNotification:userInfo) ;
        }
    }
    */

    public boolean isValid()
    {
        boolean retValue = false ;
        String checkValue = this.getValueForKey("check") ;
        if(!VeamUtil.isEmpty(checkValue) && checkValue.equals("OK")){
            retValue = true ;
        }
        return retValue ;
    }

    public String getValueForKey(String key)
    {
        //NSLog("key=%",key) ;
        String value = dictionary.get(key) ;
        return value ;
    }

    public void setValueForKey(String key ,String value)
    {
        //NSLog("setValueForKey % %",key,value) ;
        dictionary.put(key,value) ;
    }

    public int getNumberOfForums()
    {
        return forums.size() ;
    }

    public ForumObject getForumAt(int index)
    {
        ForumObject retValue = null ;
        if(index < forums.size()){
        retValue = forums.get(index) ;
    }
        return retValue ;
    }

    public ForumObject getForumForId(String forumId)
    {
        int count = forums.size() ;
        ForumObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            ForumObject forum = forums.get(index) ;
            if(forum.getId().equals(forumId)){
                retValue = forum ;
                break ;
            }
        }
        return retValue ;
    }

    public void setForum(ForumObject forum)
    {
        if(VeamUtil.isEmpty(forum.getId())){
            forums.add(0,forum) ;
        } else {
            int count = forums.size() ;
            for(int index = 0 ; index  < count ; index++){
                ForumObject workForum = forums.get(index) ;
                if(workForum.getId().equals(forum.getId())){
                    forums.remove(index) ;
                    forums.add(index,forum) ;
                    break ;
                }
            }
        }
        this.saveForum(forum) ;
    }

    public void saveForum(ForumObject forum)
    {
        String apiName = "forum/setforum" ;
        String forumId = "" ;
        if(!VeamUtil.isEmpty(forum.getId())){
            forumId = forum.getId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(forumId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(forum.getName()),"n") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(forum.getKind()),"k") ;
        this.sendData(apiName,params,null,forum) ;
        this.appInfo.setModified("1") ;
    }

    public void setTemplateForumTitle(String title)
    {
        templateForum.setTitle(title) ;
        this.saveTemplateForum() ;
    }

    public void saveTemplateForum()
    {
        String apiName = "forum/setdata" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params, this.escapeNull(templateForum.getTitle()), "t") ;
        this.sendData(apiName, params, null, null) ;
    }

    public void moveForumFrom(int fromIndex,int toIndex)
    {
        ForumObject objectToBeMoved = forums.get(fromIndex) ;
        forums.remove(fromIndex) ;
        forums.add(toIndex, objectToBeMoved) ;
        this.saveForumOrder() ;
    }

    public void saveForumOrder()
    {
        int count = forums.size() ;
        if(count > 1){
            String apiName = "forum/setforumorder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                ForumObject forum = forums.get(index) ;
                if(index == 0){
                    orderString = forum.getId() ;
                } else {
                    orderString = orderString  + String.format(",%s",forum.getId()) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }

    public void removeForumAt(int index)
    {
        String forumIdToBeRemoved = null ;
        int count = forums.size() ;
        if(index < count){
            ForumObject forum = forums.get(index) ;
            forumIdToBeRemoved = forum.getId() ;
            forums.remove(index) ;
        }

        if(!VeamUtil.isEmpty(forumIdToBeRemoved)){
            String apiName = "forum/removeforum" ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(forumIdToBeRemoved),"i") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }















    public int getNumberOfWebs()
    {
        return webs.size() ;
    }

    public ArrayList<WebObject> getWebs()
    {
        return webs ;
    }
    
    public WebObject getWebAt(int index)
    {
        WebObject retValue = null ;
        if(index < webs.size()){
            retValue = webs.get(index) ;
        }
        return retValue ;
    }

    public WebObject getWebForId(String webId)
    {
        int count = webs.size() ;
        WebObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            WebObject web = webs.get(index) ;
            if(web.getId().equals(webId)){
                retValue = web ;
                break ;
            }
        }
        return retValue ;
    }



    public void setWeb(WebObject web)
    {
        if(VeamUtil.isEmpty(web.getId())){
            webs.add(0,web) ;
        } else {
            int count = webs.size() ;
            for(int index = 0 ; index  < count ; index++){
                WebObject workWeb = webs.get(index) ;
                if(workWeb.getId().equals(web.getId())){
                    webs.remove(index) ;
                    webs.add(index,web) ;
                    break ;
                }
            }
        }
        this.saveWeb(web) ;
    }

    public void saveWeb(WebObject web)
    {
        String apiName = "web/setweb" ;
        String webId = "" ;
        if(!VeamUtil.isEmpty(web.getId())){
            webId = web.getId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(webId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(web.getTitle()),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(web.getUrl()),"u") ;
        this.sendData(apiName,params,null,web) ;
        this.appInfo.setModified("1") ;
    }

    public void setTemplateWebTitle(String title)
    {
        templateWeb.setTitle(title) ;
        this.saveTemplateWeb() ;
    }

    public void saveTemplateWeb()
    {
        String apiName = "web/setdata" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params, this.escapeNull(templateWeb.getTitle()), "t") ;
        this.sendData(apiName, params, null, null) ;
    }

    public void moveWebFrom(int fromIndex,int toIndex)
    {
        WebObject objectToBeMoved = webs.get(fromIndex) ;
        webs.remove(fromIndex) ;
        webs.add(toIndex, objectToBeMoved) ;
        this.saveWebOrder() ;
    }

    public void saveWebOrder()
    {
        int count = webs.size() ;
        if(count > 1){
            String apiName = "web/setweborder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                WebObject web = webs.get(index) ;
                if(index == 0){
                    orderString = web.getId() ;
                } else {
                    orderString = orderString  + String.format(",%s",web.getId()) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }

    public void removeWebAt(int index)
    {
        String webIdToBeRemoved = null ;
        int count = webs.size() ;
        if(index < count){
            WebObject web = webs.get(index) ;
            webIdToBeRemoved = web.getId() ;
            webs.remove(index) ;
        }

        if(!VeamUtil.isEmpty(webIdToBeRemoved)){
            String apiName = "web/removeweb" ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(webIdToBeRemoved),"i") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }

































/////////////////////////////////////////////////////////////////////////////////
    // SellItemCategory
/////////////////////////////////////////////////////////////////////////////////
    public void setSellItemCategory(SellItemCategoryObject sellItemCategory,String title)
    {
        if(VeamUtil.isEmpty(sellItemCategory.getId())){
        sellItemCategories.add(0,sellItemCategory) ;
    } else {
        int count = sellItemCategories.size() ;
        for(int index = 0 ; index  < count ; index++){
            SellItemCategoryObject workSellItemCategory = sellItemCategories.get(index) ;
            if(workSellItemCategory.getId().equals(sellItemCategory.getId())){
                sellItemCategories.remove(index) ;
                sellItemCategories.add(index,sellItemCategory) ;
                break ;
            }
        }
    }
        this.saveSellItemCategory(sellItemCategory,title) ;
    }

    public void saveSellItemCategory(SellItemCategoryObject sellItemCategory,String title)
    {
        String apiName = "sellitem/setcategory" ;
        String sellItemCategoryId = "" ;
        if(!VeamUtil.isEmpty(sellItemCategory.getId())){
        sellItemCategoryId = sellItemCategory.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellItemCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellItemCategory.getKind()),"k") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellItemCategory.getTargetCategoryId()),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(title),"n") ;
        this.sendData(apiName,params,null,sellItemCategory) ;
        //NSLog("set post resuilt? sellItemCategory.getTargetCategoryId()=%",sellItemCategory.getTargetCategoryId()) ;
        this.appInfo.setModified("1") ;
    }

    public void removeSellItemCategoryAt(int index)
    {
        String sellItemCategoryIdToBeRemoved = null ;
        int count = sellItemCategories.size() ;
        if(index < count){
            SellItemCategoryObject sellItemCategory = sellItemCategories.get(index) ;
            sellItemCategoryIdToBeRemoved = sellItemCategory.getId() ;
            sellItemCategories.remove(index) ;
        }

        if(!VeamUtil.isEmpty(sellItemCategoryIdToBeRemoved)){
        String apiName = "sellitem/removecategory" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellItemCategoryIdToBeRemoved),"i") ;
        this.sendData(apiName,params,null,null) ;
        this.appInfo.setModified("1") ;
    }
    }

    public int   getNumberOfSellItemCategories()
    {
        return sellItemCategories.size() ;
    }

    public ArrayList<SellItemCategoryObject> getSellItemCategories()
    {
        return sellItemCategories ;
    }

    public SellItemCategoryObject getSellItemCategoryAt(int index)
    {
        SellItemCategoryObject retValue = null ;
        if(index < sellItemCategories.size()){
            retValue = sellItemCategories.get(index) ;
        }
        return retValue ;
    }

    public void moveSellItemCategoryFrom(int fromIndex,int toIndex)
    {
        SellItemCategoryObject objectToBeMoved = sellItemCategories.get(fromIndex) ;
        sellItemCategories.remove(fromIndex) ;
        sellItemCategories.add(toIndex,objectToBeMoved) ;
        this.saveSellItemCategoryOrder() ;
    }

    public void saveSellItemCategoryOrder()
    {
        int count = sellItemCategories.size() ;
        if(count > 1){
            String apiName = "sellitem/setcategoryorder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                SellItemCategoryObject category = sellItemCategories.get(index) ;
                if(index == 0){
                    orderString = category.getId() ;
                } else {
                    orderString = orderString  + String.format(",%s",category.getId()) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }


    public SellItemCategoryObject getSellItemCategoryForId(String sellItemCategoryId)
    {
        int count = sellItemCategories.size() ;
        SellItemCategoryObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            SellItemCategoryObject sellItemCategory = sellItemCategories.get(index) ;
            if(sellItemCategory.getId().equals(sellItemCategoryId)){
                retValue = sellItemCategory ;
                break ;
            }
        }
        return retValue ;
    }

    public String getCategoryTitleForSellItemCategory(SellItemCategoryObject sellItemCategory)
    {
        String retValue = "";
        if (sellItemCategory.getKind().equals(ConsoleUtil.VEAM_SELL_ITEM_CATEGORY_KIND_VIDEO)) {
            VideoCategoryObject videoCategory = this.getVideoCategoryForId(sellItemCategory.getTargetCategoryId());
            if (videoCategory != null) {
                retValue = videoCategory.getName();
            }
        } else if (sellItemCategory.getKind().equals(ConsoleUtil.VEAM_SELL_ITEM_CATEGORY_KIND_PDF)) {
            PdfCategoryObject pdfCategory = this.getPdfCategoryForId(sellItemCategory.getTargetCategoryId());
            if (pdfCategory != null) {
                retValue = pdfCategory.getName();
            }
        } else if (sellItemCategory.getKind().equals(ConsoleUtil.VEAM_SELL_ITEM_CATEGORY_KIND_AUDIO)) {
            AudioCategoryObject audioCategory = this.getAudioCategoryForId(sellItemCategory.getTargetCategoryId());
            if (audioCategory != null) {
                retValue = audioCategory.getName();
            }
        }
        return retValue;
    }

    public String getAudioTitleForSellAudio(SellAudioObject sellAudio)
    {
        String retValue = "";

        AudioObject audio = this.getAudioForId(sellAudio.getAudioId()) ;
        if(audio != null){
            retValue = audio.getTitle() ;
        }
        return retValue;
    }

    public String getVideoTitleForSellVideo(SellVideoObject sellVideo)
    {
        String retValue = "";

        VideoObject video = this.getVideoForId(sellVideo.getVideoId()) ;
        if(video != null){
            retValue = video.getTitle() ;
        }
        return retValue;
    }

    public String getPdfTitleForSellPdf(SellPdfObject sellPdf)
    {
        String retValue = "";

        PdfObject pdf = this.getPdfForId(sellPdf.getPdfId());
        if(pdf != null){
            retValue = pdf.getTitle() ;
        }
        return retValue;
    }


    public void setSellItemTarget(String kind,String targetCategoryId,String name)
    {
        if(kind.equals(ConsoleUtil.VEAM_SELL_ITEM_CATEGORY_KIND_VIDEO)){
            VideoCategoryObject videoCategory = this.getVideoCategoryForId(targetCategoryId) ;
            if(videoCategory != null){
                videoCategory.setName(name) ;
            } else {
                videoCategory = new VideoCategoryObject() ;
                videoCategory.setName(name) ;
                videoCategory.setId(targetCategoryId) ;
                videoCategories.add(videoCategory) ;
            }
        } else if(kind.equals(ConsoleUtil.VEAM_SELL_ITEM_CATEGORY_KIND_PDF)){
            PdfCategoryObject pdfCategory = this.getPdfCategoryForId(targetCategoryId) ;
            if(pdfCategory != null){
                pdfCategory.setName(name) ;
            } else {
                pdfCategory = new PdfCategoryObject() ;
                pdfCategory.setName(name) ;
                pdfCategory.setId(targetCategoryId) ;
                pdfCategories.add(pdfCategory) ;
            }
        } else if(kind.equals(ConsoleUtil.VEAM_SELL_ITEM_CATEGORY_KIND_AUDIO)){
            AudioCategoryObject audioCategory = this.getAudioCategoryForId(targetCategoryId) ;
            if(audioCategory != null){
                audioCategory.setName(name) ;
            } else {
                audioCategory = new AudioCategoryObject() ;
                audioCategory.setName(name) ;
                audioCategory.setId(targetCategoryId) ;
                audioCategories.add(audioCategory) ;
            }
        }

    }


















/////////////////////////////////////////////////////////////////////////////////
    // SellSectionCategory
/////////////////////////////////////////////////////////////////////////////////
    public void setSellSectionCategory(SellSectionCategoryObject sellSectionCategory,String title)
    {
        if(VeamUtil.isEmpty(sellSectionCategory.getId())){
        sellSectionCategories.add(0,sellSectionCategory) ;
    } else {
        int count = sellSectionCategories.size() ;
        for(int index = 0 ; index  < count ; index++){
            SellSectionCategoryObject workSellSectionCategory = sellSectionCategories.get(index) ;
            if(workSellSectionCategory.getId().equals(sellSectionCategory.getId())){
                sellSectionCategories.remove(index) ;
                sellSectionCategories.add(index,sellSectionCategory) ;
                break ;
            }
        }
    }
        this.saveSellSectionCategory(sellSectionCategory,title) ;
    }

    public void saveSellSectionCategory(SellSectionCategoryObject sellSectionCategory,String title)
    {
        String apiName = "sellsection/setcategory" ;
        String sellSectionCategoryId = "" ;
        if(!VeamUtil.isEmpty(sellSectionCategory.getId())){
            sellSectionCategoryId = sellSectionCategory.getId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionCategory.getKind()),"k") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(title),"n") ;
        this.sendData(apiName,params,null,sellSectionCategory) ;
        //NSLog("set post resuilt? sellSectionCategory.targetCategoryId=%",sellSectionCategory.targetCategoryId) ;
        this.appInfo.setModified("1") ;
    }

    public void removeSellSectionCategoryAt(int index)
    {
        String sellSectionCategoryIdToBeRemoved = null ;
        int count = sellSectionCategories.size() ;
        if(index < count){
            SellSectionCategoryObject sellSectionCategory = sellSectionCategories.get(index) ;
            sellSectionCategoryIdToBeRemoved = sellSectionCategory.getId() ;
            sellSectionCategories.remove(index) ;
        }

        if(!VeamUtil.isEmpty(sellSectionCategoryIdToBeRemoved)){
        String apiName = "sellsection/removecategory" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionCategoryIdToBeRemoved),"i") ;
        this.sendData(apiName,params,null,null) ;
        this.appInfo.setModified("1") ;
    }
    }

    public int getNumberOfSellSectionCategories()
    {
        return sellSectionCategories.size() ;
    }

    public ArrayList<SellSectionCategoryObject> getSellSectionCategories()
    {
        return sellSectionCategories ;
    }

    public SellSectionCategoryObject getSellSectionCategoryAt(int index)
    {
        SellSectionCategoryObject retValue = null ;
        if(index < sellSectionCategories.size()){
            retValue = sellSectionCategories.get(index) ;
        }
        return retValue ;
    }

    public void moveSellSectionCategoryFrom(int fromIndex,int toIndex)
    {
        SellSectionCategoryObject objectToBeMoved = sellSectionCategories.get(fromIndex) ;
        sellSectionCategories.remove(fromIndex) ;
        sellSectionCategories.add(toIndex,objectToBeMoved) ;
        this.saveSellSectionCategoryOrder() ;
    }

    public void saveSellSectionCategoryOrder()
    {
        int count = sellSectionCategories.size() ;
        if(count > 1){
            String apiName = "sellsection/setcategoryorder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                SellSectionCategoryObject category = sellSectionCategories.get(index) ;
                if(index == 0){
                    orderString = category.getId() ;
                } else {
                    orderString = orderString  + String.format(",%s",category.getId()) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }


    public SellSectionCategoryObject getSellSectionCategoryForId(String sellSectionCategoryId)
    {
        int count = sellSectionCategories.size() ;
        SellSectionCategoryObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            SellSectionCategoryObject sellSectionCategory = sellSectionCategories.get(index) ;
            if(sellSectionCategory.getId().equals(sellSectionCategoryId)){
                retValue = sellSectionCategory ;
                break ;
            }
        }
        return retValue ;
    }

    public String getCategoryTitleForSellSectionCategory(SellSectionCategoryObject sellSectionCategory)
    {
        String retValue = "" ;
        retValue = sellSectionCategory.getName() ;
        return retValue ;
    }

    public boolean isCategoryInSellSection(String categoryId,String categoryKind)
    {
        boolean retValue = false ;
        /*
        ArrayList<> workSellSectionCategories = this.getSellSectionCategories) ;
        if(workSellSectionCategories != null){
            int count = workSellSectionCategories.size() ;
            for(int index = 0 ; index < count ; index++){
                SellSectionCategoryObject sellSectionCategory = workSellSectionCategories.get(index) ;
                if(sellSectionCategory.kind.equals(categoryKind) &&
                   sellSectionCategory.targetCategoryId.equals(categoryId)){
                    retValue = YES ;
                    break ;
                }
            }
        }
         */
        return retValue ;
    }

    public int   getNumberOfSellSectionItemsForSellSectionCategory(String sellSectionCategoryId)
    {
        //NSLog("getNumberOfSellSectionItemsForSectionItemCategory SectionItemCategoryId=%",SectionItemCategoryId) ;
        int retValue = 0 ;
        ArrayList<SellSectionItemObject> sellSectionItemsForCategory = this.getSellSectionItemsForSellSectionCategory(sellSectionCategoryId) ;
        if(sellSectionItemsForCategory != null){
            retValue = sellSectionItemsForCategory.size() ;
        }
        return retValue ;
    }

    public ArrayList<SellSectionItemObject> getSellSectionItemsForSellSectionCategory(String sellSectionCategoryId)
    {
        ArrayList<SellSectionItemObject> retValue = new ArrayList<SellSectionItemObject>() ;
        int count = sellSectionItems.size() ;
        //NSLog("getSellVideosForVideoCategory count=%d",count) ;
        for(int index = 0 ; index < count ; index++){
            SellSectionItemObject sellSectionItem = sellSectionItems.get(index) ;
            if(sellSectionItem != null){
                if(sellSectionItem.getSellSectionCategoryId().equals(sellSectionCategoryId)){
                    retValue.add(sellSectionItem) ;
                }
            }
        }
        return retValue ;
    }

    public SellSectionItemObject getSellSectionItemForSellSectionCategory(String sellSectionCategoryId,int index,int order)
    {
        SellSectionItemObject retValue = null ;
        ArrayList<SellSectionItemObject> sellSectionItemsForCategory = this.getSellSectionItemsForSellSectionCategory(sellSectionCategoryId) ;
        if(sellSectionItemsForCategory != null){
            if(sellSectionItemsForCategory.size() > index){
                retValue = sellSectionItemsForCategory.get(index) ;
            }
        }

        return retValue ;
    }

    public SellSectionItemObject getSellSectionItemForId(String sellSectionItemId)
    {
        SellSectionItemObject retValue = null ;
        retValue = sellSectionItemsForSellSectionItemId.get(sellSectionItemId) ;
        return retValue ;
    }






    public void removeSellSectionItemForSellSectionCategory(String sellSectionCategoryId,int index)
    {
        ArrayList<SellSectionItemObject> sellSectionItemsForCategory = this.getSellSectionItemsForSellSectionCategory(sellSectionCategoryId) ;
        this.removeSellSectionItemFrom(sellSectionItemsForCategory,index) ;
    }

    public void removeSellSectionItemFrom(ArrayList<SellSectionItemObject> sellSectionItemsForCategory,int index)
    {
        if(sellSectionItemsForCategory != null){
            String sellSectionItemIdToBeRemoved = null ;
            int count = sellSectionItemsForCategory.size() ;
            if(index < count){
                SellSectionItemObject sellSectionItem = sellSectionItemsForCategory.get(index) ;
                sellSectionItemIdToBeRemoved = sellSectionItem.getId() ;
                sellSectionItemsForCategory.remove(index) ;
            }

            if(!VeamUtil.isEmpty(sellSectionItemIdToBeRemoved)){
                String apiName = "sellsection/removesellsectionitem" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionItemIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
                count = sellSectionItems.size() ;
                for(int sellSectionItemIndex = 0 ; sellSectionItemIndex < count ; sellSectionItemIndex++){
                    SellSectionItemObject sellSectionItem = sellSectionItems.get(sellSectionItemIndex) ;
                    if(sellSectionItem != null){
                        String workSellSectionItemId = sellSectionItem.getId() ;
                        if(sellSectionItemIdToBeRemoved.equals(workSellSectionItemId)){
                            sellSectionItems.remove(sellSectionItemIndex) ;
                            break ;
                        }
                    }
                }
                sellSectionItemsForSellSectionItemId.remove(sellSectionItemIdToBeRemoved) ;
            }
        }
    }








    public void setSellSectionVideo(SellSectionItemObject sellSectionItem,String videoTitle,String videoSourceUrl,String videoImageUrl)
    {
        ArrayList<SellSectionItemObject> workSellSectionItems = null ;
        workSellSectionItems = this.getSellSectionItemsForSellSectionCategory(sellSectionItem.getSellSectionCategoryId()) ;

        if(workSellSectionItems == null){
            workSellSectionItems = new ArrayList<SellSectionItemObject>() ;
        }

        if(workSellSectionItems != null){
            if(VeamUtil.isEmpty(sellSectionItem.getId())){
                workSellSectionItems.add(0,sellSectionItem) ;
            } else {
                int count = workSellSectionItems.size() ;
                for(int index = 0 ; index  < count ; index++){
                    SellSectionItemObject workSellSectionItem = workSellSectionItems.get(index) ;
                    if(workSellSectionItem.getId().equals(sellSectionItem.getId())){
                        workSellSectionItems.remove(index) ;
                        workSellSectionItems.add(index,sellSectionItem) ;
                        break ;
                    }
                }
            }
            this.saveSellSectionVideo(sellSectionItem,videoTitle,videoSourceUrl,videoImageUrl) ;
        }
    }

    public void saveSellSectionVideo(SellSectionItemObject sellSectionItem,String videoTitle,String videoSourceUrl,String videoImageUrl)
    {
        String apiName = "sellsection/setvideo" ;
        //NSLog("%",apiName) ;
        String sellSectionItemId = "" ;
        if(!VeamUtil.isEmpty(sellSectionItem.getId())){
        sellSectionItemId = sellSectionItem.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionItemId),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionItem.getSellSectionCategoryId()),"c") ;
            ConsoleUtil.putValueAndKey(params, this.escapeNull(videoTitle), "t") ;
            ConsoleUtil.putValueAndKey(params, this.escapeNull(videoSourceUrl), "su") ;
            ConsoleUtil.putValueAndKey(params, this.escapeNull(videoImageUrl), "iu") ;

        VideoObject video = new VideoObject() ;
        video.setTitle(videoTitle) ;
        video.setVideoCategoryId("0") ;

        ConsoleSellSectionItemPostHandler consoleSellSectionItemPostHandler = new ConsoleSellSectionItemPostHandler() ;
        consoleSellSectionItemPostHandler.setSellSectionItem(sellSectionItem) ;
        consoleSellSectionItemPostHandler.setVideo(video) ;

        this.sendData(apiName,params,null,consoleSellSectionItemPostHandler) ;
        this.appInfo.setModified("1") ;
    }

    public void setSellSectionPdf(SellSectionItemObject sellSectionItem,String pdfTitle,String pdfSourceUrl,String pdfImageUrl)
    {
        ArrayList<SellSectionItemObject> workSellSectionItems = null ;
        workSellSectionItems = this.getSellSectionItemsForSellSectionCategory(sellSectionItem.getSellSectionCategoryId()) ;

        if(workSellSectionItems == null){
            workSellSectionItems = new ArrayList<SellSectionItemObject>() ; ;
        }

        if(workSellSectionItems != null){
            if(VeamUtil.isEmpty(sellSectionItem.getId())){
                workSellSectionItems.add(0,sellSectionItem) ;
            } else {
                int count = workSellSectionItems.size() ;
                for(int index = 0 ; index  < count ; index++){
                    SellSectionItemObject workSellSectionItem = workSellSectionItems.get(index) ;
                    if(workSellSectionItem.getId().equals(sellSectionItem.getId())){
                        workSellSectionItems.remove(index) ;
                        workSellSectionItems.add(index,sellSectionItem) ;
                        break ;
                    }
                }
            }
            this.saveSellSectionPdf(sellSectionItem, pdfTitle, pdfSourceUrl, pdfImageUrl) ;
        }
    }

    public void saveSellSectionPdf(SellSectionItemObject sellSectionItem,String pdfTitle,String pdfSourceUrl,String pdfImageUrl)
    {
        String apiName = "sellsection/setpdf" ;
        //NSLog("%",apiName) ;
        String sellSectionItemId = "" ;
        if(!VeamUtil.isEmpty(sellSectionItem.getId())){
        sellSectionItemId = sellSectionItem.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionItemId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionItem.getSellSectionCategoryId()),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfTitle),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfSourceUrl),"su") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfImageUrl),"iu") ;

        PdfObject pdf = new PdfObject() ;
        pdf.setTitle(pdfTitle) ;
        pdf.setPdfCategoryId("0") ;

        ConsoleSellSectionItemPostHandler consoleSellSectionItemPostHandler = new ConsoleSellSectionItemPostHandler() ;
        consoleSellSectionItemPostHandler.setSellSectionItem(sellSectionItem) ;
        consoleSellSectionItemPostHandler.setPdf(pdf) ;

        this.sendData(apiName,params,null,consoleSellSectionItemPostHandler) ;
        this.appInfo.setModified("1") ;
    }

    public void setSellSectionAudio(SellSectionItemObject sellSectionItem,String audioTitle,String audioSourceUrl,String audioImageUrl ,String audioLinkUrl)
    {
        ArrayList<SellSectionItemObject> workSellSectionItems = null ;
        workSellSectionItems = this.getSellSectionItemsForSellSectionCategory(sellSectionItem.getSellSectionCategoryId()) ;

        if(workSellSectionItems == null){
            workSellSectionItems = new ArrayList<SellSectionItemObject>() ; ;
        }

        if(workSellSectionItems != null){
            if(VeamUtil.isEmpty(sellSectionItem.getId())){
                workSellSectionItems.add(0,sellSectionItem) ;
            } else {
                int count = workSellSectionItems.size() ;
                for(int index = 0 ; index  < count ; index++){
                    SellSectionItemObject workSellSectionItem = workSellSectionItems.get(index) ;
                    if(workSellSectionItem.getId().equals(sellSectionItem.getId())){
                        workSellSectionItems.remove(index) ;
                        workSellSectionItems.add(index,sellSectionItem) ;
                        break ;
                    }
                }
            }
            this.saveSellSectionAudio(sellSectionItem, audioTitle, audioSourceUrl, audioImageUrl, audioLinkUrl) ;
        }
    }

    public void saveSellSectionAudio(SellSectionItemObject sellSectionItem,String audioTitle,String audioSourceUrl,String audioImageUrl,String audioLinkUrl)
    {
        String apiName = "sellsection/setaudio" ;
        //NSLog("%",apiName) ;
        String sellSectionItemId = "" ;
        if(!VeamUtil.isEmpty(sellSectionItem.getId())){
        sellSectionItemId = sellSectionItem.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionItemId),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(sellSectionItem.getSellSectionCategoryId()),"c") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(audioTitle),"t") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(audioSourceUrl),"su") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(audioImageUrl),"iu") ;
            ConsoleUtil.putValueAndKey(params, this.escapeNull(audioLinkUrl), "lu") ;

        AudioObject audio = new AudioObject() ;
        audio.setTitle(audioTitle) ;
        audio.setAudioCategoryId("0") ;

        ConsoleSellSectionItemPostHandler consoleSellSectionItemPostHandler = new ConsoleSellSectionItemPostHandler() ;
        consoleSellSectionItemPostHandler.setSellSectionItem(sellSectionItem) ;
        consoleSellSectionItemPostHandler.setAudio(audio) ;

        this.sendData(apiName,params,null,consoleSellSectionItemPostHandler) ;
        this.appInfo.setModified("1") ;
    }

    public void updatePreparingSellSectionItemStatus(String sellSectionCategoryId)
    {
        String apiName = "sellsection/getsellsectionitemstatus" ;

        String preparingSellSectionItemIds = "" ;

        ArrayList<SellSectionItemObject> sellSectionItems = this.getSellSectionItemsForSellSectionCategory(sellSectionCategoryId) ;
        int count = sellSectionItems.size() ;
        for(int index = 0 ; index < count ; index++){
            SellSectionItemObject sellSectionItem = sellSectionItems.get(index) ;
            if(sellSectionItem.getStatus().equals(ConsoleUtil.VEAM_SELL_SECTION_ITEM_STATUS_PREPARING)){
                if(!VeamUtil.isEmpty(preparingSellSectionItemIds)){
                    preparingSellSectionItemIds = preparingSellSectionItemIds  + String.format(",%s",sellSectionItem.getId()) ;
                } else {
                    preparingSellSectionItemIds = sellSectionItem.getId() ;
                }
            }
        }

        if(!VeamUtil.isEmpty(preparingSellSectionItemIds)){
            ConsoleUpdatePreparingSellSectionItemStatusHandler handler = new ConsoleUpdatePreparingSellSectionItemStatusHandler() ;
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(preparingSellSectionItemIds),"i") ;
            this.sendData(apiName, params, null, handler) ;
        }
    }



































/////////////////////////////////////////////////////////////////////////////////
    // Pdf
/////////////////////////////////////////////////////////////////////////////////
    public void setPdfCategory(PdfCategoryObject pdfCategory)
    {
        if(VeamUtil.isEmpty(pdfCategory.getId())){
        pdfCategories.add(0,pdfCategory) ;
    } else {
        int count = pdfCategories.size() ;
        for(int index = 0 ; index  < count ; index++){
            PdfCategoryObject workPdfCategory = pdfCategories.get(index) ;
            if(workPdfCategory.getId().equals(pdfCategory.getId())){
                pdfCategories.remove(index) ;
                pdfCategories.add(index,pdfCategory) ;
                break ;
            }
        }
    }
        this.savePdfCategory(pdfCategory) ;
    }

    public void savePdfCategory(PdfCategoryObject pdfCategory)
    {
        String apiName = "pdf/setcategory" ;
        String pdfCategoryId = "" ;
        if(!VeamUtil.isEmpty(pdfCategory.getId())){
        pdfCategoryId = pdfCategory.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfCategoryId),"i") ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfCategory.getName()),"n") ;
        this.sendData(apiName,params,null,pdfCategory) ;
        this.appInfo.setModified("1") ;
    }

    public void removePdfCategoryAt(int index)
    {
        String pdfCategoryIdToBeRemoved = null ;
        int count = pdfCategories.size() ;
        if(index < count){
            PdfCategoryObject pdfCategory = pdfCategories.get(index) ;
            pdfCategoryIdToBeRemoved = pdfCategory.getId() ;
            pdfCategories.remove(index) ;
        }

        if(!VeamUtil.isEmpty(pdfCategoryIdToBeRemoved)){
        String apiName = "pdf/removecategory" ;
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfCategoryIdToBeRemoved),"i") ;
        this.sendData(apiName,params,null,null) ;
        this.appInfo.setModified("1") ;
    }
    }

    public int getNumberOfPdfCategories()
    {
        return pdfCategories.size() ;
    }

    public ArrayList<PdfCategoryObject> getPdfCategories()
    {
        return pdfCategories ;
    }

    public PdfCategoryObject getPdfCategoryAt(int index)
    {
        PdfCategoryObject retValue = null ;
        if(index < pdfCategories.size()){
            retValue = pdfCategories.get(index) ;
        }
        return retValue ;
    }

    public void movePdfCategoryFrom(int fromIndex,int toIndex)
    {
        PdfCategoryObject objectToBeMoved = pdfCategories.get(fromIndex) ;
        pdfCategories.remove(fromIndex) ;
        pdfCategories.add(toIndex,objectToBeMoved) ;
        this.savePdfCategoryOrder() ;
    }

    public void savePdfCategoryOrder()
    {
        int count = pdfCategories.size() ;
        if(count > 1){
            String apiName = "pdf/setcategoryorder" ;
            String orderString = "" ;
            for(int index = 0 ; index < count ; index++){
                PdfCategoryObject category = pdfCategories.get(index) ;
                if(index == 0){
                    orderString = category.getId() ;
                } else {
                    orderString = orderString  + String.format(",%s",category.getId()) ;
                }
            }
            Map<String,String> params = new HashMap<String,String>() ;
            ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
            this.sendData(apiName,params,null,null) ;
            this.appInfo.setModified("1") ;
        }
    }


    public PdfCategoryObject getPdfCategoryForId(String pdfCategoryId)
    {
        int count = pdfCategories.size() ;
        PdfCategoryObject retValue = null ;
        for(int index = 0 ; index < count ; index++){
            PdfCategoryObject pdfCategory = pdfCategories.get(index) ;
            if(pdfCategory.getId().equals(pdfCategoryId)){
                retValue = pdfCategory ;
                break ;
            }
        }
        return retValue ;
    }

    /*
    public ArrayList<> getPdfSubCategories(String pdfCategoryId)
    {
        ArrayList<> retValue = pdfSubCategoriesPerCategory.get(pdfCategoryId) ;
        return retValue ;
    }

    public int   getNumberOfPdfSubCategories(String pdfCategoryId)
    {
        return this.getPdfSubCategories(pdfCategoryId).size() ;
    }

    public PdfSubCategory *)getPdfSubCategoryAt(int index,String pdfCategoryId)
    {
        PdfSubCategory *retValue = null ;
        if(index < this.getPdfSubCategories(pdfCategoryId).size()){
        retValue = this.getPdfSubCategories(pdfCategoryId).get(index) ;
    }
        return retValue ;
    }

    public void movePdfSubCategoryFrom(int fromIndex,int toIndex,String pdfCategoryId)
    {
        ArrayList<> subCategories = this.getPdfSubCategories(pdfCategoryId) ;
        if(subCategories != null){
            PdfSubCategory *objectToBeMoved = subCategories.get(fromIndex) ;
            subCategories.remove(fromIndex) ;
            subCategories.add(xxx,objectToBeMoved,toIndex) ;
            this.savePdfSubCategoryOrder(pdfCategoryId) ;
        }
    }

    public void savePdfSubCategoryOrder(String pdfCategoryId)
    {

        ArrayList<> subCategories = this.getPdfSubCategories(pdfCategoryId) ;
        if(subCategories != null){
            int count = subCategories.size() ;
            if(count > 1){
                String apiName = "pdf/setsubcategoryorder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    PdfSubCategory *subCategory = subCategories.get(index) ;
                    if(index == 0){
                        orderString = subCategory.pdfSubCategoryId ;
                    } else {
                        orderString = orderString  + String.format(",%s",subCategory.pdfSubCategoryId) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setPdfSubCategory(PdfSubCategory *)pdfSubCategory
    {
        ArrayList<> subCategories = this.getPdfSubCategories(pdfSubCategory.pdfCategoryId) ;
        if(subCategories == null){
            subCategories = new ArrayList<>() ; ;
            pdfSubCategoriesPerCategory.put(__KEY__,subCategories,pdfSubCategory.pdfCategoryId) ;
        }

        if(subCategories != null){
            if(VeamUtil.isEmpty(pdfSubCategory.pdfSubCategoryId)){
                subCategories.add(xxx,pdfSubCategory,0) ;
            } else {
                int count = subCategories.size() ;
                for(int index = 0 ; index  < count ; index++){
                    PdfSubCategory *workPdfSubCategory = subCategories.get(index) ;
                    if(workPdfSubCategory.pdfSubCategoryId.equals(pdfSubCategory.pdfSubCategoryId)){
                        subCategories.remove(index) ;
                        subCategories.add(xxx,pdfSubCategory,index) ;
                        break ;
                    }
                }
            }
            this.savePdfSubCategory(pdfSubCategory) ;
        }
    }

    public void savePdfSubCategory(PdfSubCategory *)pdfSubCategory
    {
        String apiName = "pdf/setsubcategory" ;
        String pdfSubCategoryId = "" ;
        if(!VeamUtil.isEmpty(pdfSubCategory.pdfSubCategoryId)){
        pdfSubCategoryId = pdfSubCategory.pdfSubCategoryId ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfSubCategoryId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfSubCategory.pdfCategoryId),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfSubCategory.getName()),"n") ;
        this.sendData(apiName,params,null,pdfSubCategory) ;
        this.appInfo.setModified("1") ;
    }

    public void removePdfSubCategoryAt(int index,String pdfCategoryId)
    {
        ArrayList<> subCategories = this.getPdfSubCategories(pdfCategoryId) ;
        if(subCategories != null){
            String pdfSubCategoryIdToBeRemoved = null ;
            int count = subCategories.size() ;
            if(index < count){
                PdfSubCategory *pdfSubCategory = subCategories.get(index) ;
                pdfSubCategoryIdToBeRemoved = pdfSubCategory.pdfSubCategoryId ;
                subCategories.remove(index) ;
            }

            if(!VeamUtil.isEmpty(pdfSubCategoryIdToBeRemoved)){
                String apiName = "pdf/removesubcategory" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfSubCategoryIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }
    */

    public int   getNumberOfPdfsForCategory(String pdfCategoryId)
    {
        return this.getPdfsForCategory(pdfCategoryId).size() ;
    }

    /*
    public int   getNumberOfPdfsForSubCategory(String pdfSubCategoryId)
    {
        return this.getPdfsForSubCategory(pdfSubCategoryId).size() ;
    }
    */

    public ArrayList<PdfObject> getPdfsForCategory(String pdfCategoryId)
    {
        ArrayList<PdfObject> retValue = pdfsPerCategory.get(pdfCategoryId) ;
        if(retValue == null){
            retValue = new ArrayList<PdfObject>() ;
        }

        return retValue ;
    }


    /*
    public ArrayList<PdfObject> getPdfsForSubCategory(String pdfSubCategoryId)
    {
        ArrayList<PdfObject> retValue = pdfsPerSubCategory.get(pdfSubCategoryId) ;
        return retValue ;
    }
    */

    public PdfObject getPdfForId(String pdfId)
    {
        PdfObject retValue = null ;
        retValue = pdfsForPdfId.get(pdfId) ;
        return retValue ;
    }

    public PdfObject getPdfForCategory(String pdfCategoryId,int index)
    {
        PdfObject retValue = null ;
        ArrayList<PdfObject> pdfs = this.getPdfsForCategory(pdfCategoryId) ;
        retValue = pdfs.get(index) ;
        return retValue ;
    }

    /*
    public PdfObject getPdfForSubCategory(String pdfSubCategoryId,int index)
    {
        PdfObject retValue = null ;
        ArrayList<PdfObject> pdfs = this.getPdfsForSubCategory(pdfSubCategoryId) ;
        retValue = pdfs.get(index) ;
        return retValue ;
    }
    */

    public void movePdfForCategory(String pdfCategoryId,int fromIndex,int toIndex)
    {
        ArrayList<PdfObject> pdfs = this.getPdfsForCategory(pdfCategoryId) ;
        if(pdfs != null){
            PdfObject objectToBeMoved = pdfs.get(fromIndex) ;
            pdfs.remove(fromIndex) ;
            pdfs.add(toIndex,objectToBeMoved) ;
            this.savePdfOrder(pdfs) ;
        }
    }

    /*
    public void movePdfForSubCategory(String pdfSubCategoryId,int fromIndex,int toIndex)
    {
        ArrayList<PdfObject> pdfs = this.getPdfsForSubCategory(pdfSubCategoryId) ;
        if(pdfs != null){
            PdfObject objectToBeMoved = pdfs.get(fromIndex) ;
            pdfs.remove(fromIndex) ;
            pdfs.add(toIndex,objectToBeMoved) ;
            this.savePdfOrder(pdfs) ;
        }
    }
    */

    public void savePdfOrder(ArrayList<PdfObject> pdfs)
    {
        if(pdfs != null){
            int count = pdfs.size() ;
            if(count > 1){
                String apiName = "pdf/setpdforder" ;
                String orderString = "" ;
                for(int index = 0 ; index < count ; index++){
                    PdfObject pdf = pdfs.get(index) ;
                    if(index == 0){
                        orderString = pdf.getId() ;
                    } else {
                        orderString = orderString  + String.format(",%s",pdf.getId()) ;
                    }
                }
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(orderString),"o") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }

    public void setPdf(PdfObject pdf,String thumbnailImage)
    {
        ArrayList<PdfObject> pdfs = null ;
        if(pdf.getPdfSubCategoryId().equals("0")){
            pdfs = this.getPdfsForCategory(pdf.getPdfCategoryId()) ;
        } else {
            //pdfs = this.getPdfsForSubCategory(pdf.pdfSubCategoryId) ;
        }

        if(pdfs == null){
            pdfs = new ArrayList<>() ; ;
            if(pdf.getPdfSubCategoryId().equals("0")){
                pdfsPerCategory.put(pdf.getPdfCategoryId(),pdfs) ;
            } else {
                //pdfsPerSubCategory.put(pdf.getPdfSubCategoryId(),pdfs) ;
            }
        }

        if(pdfs != null){
            if(VeamUtil.isEmpty(pdf.getId())){
                pdfs.add(0,pdf) ;
            } else {
                int count = pdfs.size() ;
                for(int index = 0 ; index  < count ; index++){
                    PdfObject workPdf = pdfs.get(index) ;
                    if(workPdf.getId().equals(pdf.getId())){
                        pdfs.remove(index) ;
                        pdfs.add(index,pdf) ;
                        break ;
                    }
                }
            }
            this.savePdf(pdf,thumbnailImage) ;
        }
    }

    public void savePdf(PdfObject pdf,String thumbnailImage)
    {
        String apiName = "pdf/setpdf" ;
        //NSLog("%",apiName) ;
        String pdfId = "" ;
        if(!VeamUtil.isEmpty(pdf.getId())){
            pdfId = pdf.getId() ;
        }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdf.getPdfCategoryId()),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdf.getPdfSubCategoryId()),"sub") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdf.getTitle()),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdf.getKind()),"k") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdf.getSourceUrl()),"su") ;
        this.sendData(apiName,params,thumbnailImage,pdf) ;
        this.appInfo.setModified("1") ;
    }

    public void removePdfForCategory(String pdfCategoryId,int index)
    {
        ArrayList<PdfObject> pdfs = this.getPdfsForCategory(pdfCategoryId) ;
        this.removePdfFrom(pdfs,index) ;
    }

    /*
    public void removePdfForSubCategory(String pdfSubCategoryId,int index)
    {
        ArrayList<> pdfs = this.getPdfsForSubCategory(pdfSubCategoryId) ;
        this.removePdfFrom(pdfs,index) ;
    }
    */

    public void removePdfFrom(ArrayList<PdfObject> pdfs,int index)
    {
        if(pdfs != null){
            String pdfIdToBeRemoved = null ;
            int count = pdfs.size() ;
            if(index < count){
                PdfObject pdf = pdfs.get(index) ;
                pdfIdToBeRemoved = pdf.getId() ;
                pdfs.remove(index) ;
            }

            if(!VeamUtil.isEmpty(pdfIdToBeRemoved)){
                String apiName = "pdf/removepdf" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfIdToBeRemoved),"i") ;
                this.sendData(apiName,params,null,null) ;
                this.appInfo.setModified("1") ;
            }
        }
    }







    public int   getNumberOfSellPdfsForPdfCategory(String pdfCategoryId)
    {
        //NSLog("getNumberOfSellPdfsForPdfCategory pdfCategoryId=%",pdfCategoryId) ;
        int retValue = 0 ;
        ArrayList<SellPdfObject> sellPdfsForCategory = this.getSellPdfsForPdfCategory(pdfCategoryId) ;
        if(sellPdfsForCategory != null){
            retValue = sellPdfsForCategory.size() ;
        }
        return retValue ;
    }

    public ArrayList<SellPdfObject> getSellPdfsForPdfCategory(String pdfCategoryId)
    {
        ArrayList<SellPdfObject> retValue = new ArrayList<SellPdfObject>() ; ;
        int count = sellPdfs.size() ;
        //NSLog("getSellPdfsForPdfCategory count=%d",count) ;
        for(int index = 0 ; index < count ; index++){
            SellPdfObject sellPdf = sellPdfs.get(index) ;
            if(sellPdf != null){
                PdfObject pdf = this.getPdfForId(sellPdf.getPdfId()) ;
                if(pdf != null){
                    if(pdf.getPdfCategoryId().equals(pdfCategoryId)){
                        retValue.add(sellPdf) ;
                    }
                }
            }
        }
        return retValue ;
    }

    public SellPdfObject getSellPdfForPdfCategory(String pdfCategoryId,int index,int order)
    {
        SellPdfObject retValue = null ;
        ArrayList<SellPdfObject> sellPdfsForCategory = this.getSellPdfsForPdfCategory(pdfCategoryId) ;
        if(sellPdfsForCategory != null){
            if(sellPdfsForCategory.size() >index){
                retValue = sellPdfsForCategory.get(index) ;
            }
        }

        return retValue ;
    }

    public SellPdfObject getSellPdfForId(String sellPdfId)
    {
        SellPdfObject retValue = null ;
        retValue = sellPdfsForSellPdfId.get(sellPdfId) ;
        return retValue ;
    }


    public void removeSellPdfForPdfCategory(String pdfCategoryId,int index)
    {
        ArrayList<SellPdfObject> sellPdfsForCategory = this.getSellPdfsForPdfCategory(pdfCategoryId) ;
        this.removeSellPdfFrom(sellPdfsForCategory,index) ;
    }

    public void removeSellPdfFrom(ArrayList<SellPdfObject> sellPdfsForCategory,int index)
    {
        if(sellPdfsForCategory != null){
            String sellPdfIdToBeRemoved = null ;
            int count = sellPdfsForCategory.size() ;
            if(index < count){
                SellPdfObject sellPdf = sellPdfsForCategory.get(index) ;
                sellPdfIdToBeRemoved = sellPdf.getId() ;
                sellPdfsForCategory.remove(index) ;
            }

            if(!VeamUtil.isEmpty(sellPdfIdToBeRemoved)){
                String apiName = "sellitem/removesellpdf" ;
                Map<String,String> params = new HashMap<String,String>() ;
                ConsoleUtil.putValueAndKey(params,this.escapeNull(sellPdfIdToBeRemoved),"i") ;
                this.sendData(apiName, params, null, null) ;
                this.appInfo.setModified("1") ;
                count = sellPdfs.size() ;
                for(int sellPdfIndex = 0 ; sellPdfIndex < count ; sellPdfIndex++){
                    SellPdfObject sellPdf = sellPdfs.get(sellPdfIndex) ;
                    if(sellPdf != null){
                        String workSellPdfId = sellPdf.getId() ;
                        if(sellPdfIdToBeRemoved.equals(workSellPdfId)){
                            sellPdfs.remove(sellPdfIndex) ;
                            break ;
                        }
                    }
                }
                sellPdfsForSellPdfId.remove(sellPdfIdToBeRemoved) ;
            }
        }
    }




    public void setSellPdf(SellPdfObject sellPdf,String pdfCategoryId,String pdfTitle,String pdfSourceUrl,String pdfImageUrl)
    {
        ArrayList<SellPdfObject> workSellPdfs = null ;
        workSellPdfs = this.getSellPdfsForPdfCategory(pdfCategoryId) ;

        if(workSellPdfs == null){
            workSellPdfs = new ArrayList<SellPdfObject>() ; ;
        }

        if(workSellPdfs != null){
            if(VeamUtil.isEmpty(sellPdf.getId())){
                workSellPdfs.add(0,sellPdf) ;
            } else {
                int count = workSellPdfs.size() ;
                for(int index = 0 ; index  < count ; index++){
                    SellPdfObject workSellPdf = workSellPdfs.get(index) ;
                    if(workSellPdf.getId().equals(sellPdf.getId())){
                        workSellPdfs.remove(index) ;
                        workSellPdfs.add(index,sellPdf) ;
                        break ;
                    }
                }
            }
            this.saveSellPdf(sellPdf,pdfCategoryId,pdfTitle,pdfSourceUrl,pdfImageUrl) ;
        }
    }

    public void saveSellPdf(SellPdfObject sellPdf,String pdfCategoryId,String pdfTitle,String pdfSourceUrl,String pdfImageUrl)
    {
        String apiName = "sellitem/setpdf" ;
        //NSLog("%",apiName) ;
        String sellPdfId = "" ;
        if(!VeamUtil.isEmpty(sellPdf.getId())){
        sellPdfId = sellPdf.getId() ;
    }
        Map<String,String> params = new HashMap<String,String>() ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellPdfId),"i") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfCategoryId),"c") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellPdf.getDescription()),"d") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(sellPdf.getPrice()),"p") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfTitle),"t") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfSourceUrl),"su") ;
        ConsoleUtil.putValueAndKey(params,this.escapeNull(pdfImageUrl),"iu") ;

        PdfObject pdf = new PdfObject() ;
        pdf.setTitle(pdfTitle) ;
        pdf.setPdfCategoryId(pdfCategoryId) ;

        ConsoleSellPdfPostHandler consoleSellPdfPostHandler = new ConsoleSellPdfPostHandler() ;
        consoleSellPdfPostHandler.setSellPdf(sellPdf) ;
        consoleSellPdfPostHandler.setPdf(pdf) ;

        this.sendData(apiName,params,null,consoleSellPdfPostHandler) ;
        this.appInfo.setModified("1") ;
    }






}
