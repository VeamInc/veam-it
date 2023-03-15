package co.veam.veam31000287;

import android.content.Context;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import java.io.FileInputStream;
import java.util.ArrayList;

/**
 * Created by veam on 10/27/16.
 */
public class UpdateConsoleXmlHandler  extends DefaultHandler {

    SharedPreferences.Editor editor ;
    private boolean shouldLoadAlternativeImage ;

    private static final String ELEMENT_NAME_LIST              		= "content" ;
    private static final String ELEMENT_NAME_YOUTUBE_CATEGORY		= "youtube_category" ;
    private static final String ELEMENT_NAME_YOUTUBE_SUB_CATEGORY   = "youtube_sub_category" ;
    private static final String ELEMENT_NAME_YOUTUBE                = "youtube" ;
    private static final String ELEMENT_NAME_FORUM					= "forum" ;
    private static final String ELEMENT_NAME_WEB    				= "web" ;
    private static final String ELEMENT_NAME_ALTERNATIVE_IMAGE		= "alternative_image" ;
    private static final String ELEMENT_NAME_ALTERNATIVE_IMAGE_ML	= "alternative_image_ml" ;
    private static final String ELEMENT_NAME_VIDEO   				= "video" ;
    private static final String ELEMENT_NAME_VIDEO_CATEGORY			= "video_category" ;
    private static final String ELEMENT_NAME_SELL_VIDEO   			= "sell_video" ;
    private static final String ELEMENT_NAME_PDF   			    	= "pdf" ;
    private static final String ELEMENT_NAME_PDF_CATEGORY			= "pdf_category" ;
    private static final String ELEMENT_NAME_SELL_PDF   			= "sell_pdf" ;
    private static final String ELEMENT_NAME_SELL_ITEM_CATEGORY		= "sell_item_category" ;
    private static final String ELEMENT_NAME_AUDIO   				= "audio" ;
    private static final String ELEMENT_NAME_AUDIO_CATEGORY			= "audio_category" ;
    private static final String ELEMENT_NAME_SELL_AUDIO   			= "sell_audio" ;
    private static final String ELEMENT_NAME_TEMPLATE_SUBSCRIPTION  = "template_subscription" ;
    private static final String ELEMENT_NAME_SELL_SECTION_CATEGORY	= "sell_section_category" ;
    private static final String ELEMENT_NAME_SELL_SECTION_ITEM		= "sell_section_item" ;

    private static final String YOUTUBE_CATEGORY_ATTR_ID     		= "id" ;
    private static final String YOUTUBE_CATEGORY_ATTR_NAME   		= "name" ;

    private static final String YOUTUBE_SUB_CATEGORY_ATTR_ID     		= "id" ;
    private static final String YOUTUBE_SUB_CATEGORY_ATTR_CATEGORY_ID	= "c" ;
    private static final String YOUTUBE_SUB_CATEGORY_ATTR_NAME   		= "name" ;

    private static final String FORUM_ATTR_ID  				   		= "id" ;
    private static final String FORUM_ATTR_NAME   					= "name" ;
    private static final String FORUM_ATTR_KIND   					= "kind" ;

    private static final String WEB_ATTR_ID  				   		= "id" ;
    private static final String WEB_ATTR_TITLE   					= "t" ;
    private static final String WEB_ATTR_URL   					= "u" ;
    private static final String WEB_ATTR_WEB_CATEGORY_ID			= "c" ;

    private static final String ALTERNATIVE_IMAGE_ATTR_ID  				   		= "id" ;
    private static final String ALTERNATIVE_IMAGE_ATTR_FILENAME 				= "f" ;
    private static final String ALTERNATIVE_IMAGE_ATTR_LANGUAGE   				= "l" ;
    private static final String ALTERNATIVE_IMAGE_ATTR_URL   					= "u" ;


    private static final String YOUTUBE_ATTR_ID     				= "id" ;
    private static final String YOUTUBE_ATTR_DURATION 				= "d" ;
    private static final String YOUTUBE_ATTR_TITLE     				= "t" ;
    private static final String YOUTUBE_ATTR_DESCRIPTION			= "e" ;
    private static final String YOUTUBE_ATTR_CATEGORY_ID     		= "c" ;
    private static final String YOUTUBE_ATTR_SUB_CATEGORY_ID		= "s" ;
    private static final String YOUTUBE_ATTR_YOUTUBE_VIDEO_ID		= "v" ;
    private static final String YOUTUBE_ATTR_IS_NEW					= "n" ;
    private static final String YOUTUBE_ATTR_KIND					= "k" ;
    private static final String YOUTUBE_ATTR_LINK					= "l" ;

    private static final String AUDIO_ATTR_ID  				   		= "id" ;
    private static final String AUDIO_ATTR_DURATION				   	= "d" ;
    private static final String AUDIO_ATTR_TITLE  				       	= "t" ;
    private static final String AUDIO_ATTR_AUDIO_CATEGORY_ID  		= "c" ;
    private static final String AUDIO_ATTR_AUDIO_SUB_CATEGORY_ID  	= "s" ;
    private static final String AUDIO_ATTR_KIND  				       	= "k" ;
    private static final String AUDIO_ATTR_THUMBNAIL_URL  			= "i" ;
    private static final String AUDIO_ATTR_RECTANGLE_THUMBNAIL_URL  = "ri" ;
    private static final String AUDIO_ATTR_DATA_URL      				= "v" ;
    private static final String AUDIO_ATTR_BASE64_URL      				= "bu" ;
    private static final String AUDIO_ATTR_DATA_SIZE  				= "vs" ;
    private static final String AUDIO_ATTR_LINK_URL  	  	            = "l" ;
    private static final String AUDIO_ATTR_CREATED_AT  				= "cr" ;
    private static final String AUDIO_ATTR_MIXED_ID  	      			= "mi" ;
    private static final String AUDIO_ATTR_MIXED_CATEGORY_ID  		= "mc" ;
    private static final String AUDIO_ATTR_MIXED_SUB_CATEGORY_ID  	= "ms" ;
    private static final String AUDIO_ATTR_MIXED_KIND  				= "mk" ;
    private static final String AUDIO_ATTR_MIXED_THUMBNAIL_URL  	= "mt" ;
    private static final String AUDIO_ATTR_MIXED_DISPLAY_TYPE  		= "mdt" ;
    private static final String AUDIO_ATTR_MIXED_DISPLAY_NAME  		= "mdn" ;

    private static final String SELL_SECTION_CATEGORY_ATTR_ID     		= "id" ;
    private static final String SELL_SECTION_CATEGORY_ATTR_NAME   		= "name" ;

    private static final String VIDEO_CATEGORY_ATTR_ID     		= "id" ;
    private static final String VIDEO_CATEGORY_ATTR_NAME   		= "name" ;
    private static final String VIDEO_CATEGORY_ATTR_EMBED   	= "e" ;
    private static final String VIDEO_CATEGORY_ATTR_URL   		= "u" ;

    private static final String PDF_CATEGORY_ATTR_ID     		= "id" ;
    private static final String PDF_CATEGORY_ATTR_NAME   		= "name" ;

    private static final String AUDIO_CATEGORY_ATTR_ID     		= "id" ;
    private static final String AUDIO_CATEGORY_ATTR_NAME   		= "name" ;

    private static final String SELL_ITEM_CATEGORY_ATTR_ID     		= "id" ;
    private static final String SELL_ITEM_CATEGORY_ATTR_KIND   		= "kind" ;
    private static final String SELL_ITEM_CATEGORY_ATTR_TARGET_CATEGORY_ID   		= "target" ;

    private static final String SELL_SECTION_ITEM_ATTR_ID  				   		    = "id" ;
    private static final String SELL_SECTION_ITEM_ATTR_CONTENT__ID  	            = "v" ;
    private static final String SELL_SECTION_ITEM_ATTR_SELL_SECTION_CATEGORY_ID  	= "c" ;
    private static final String SELL_SECTION_ITEM_ATTR_SELL_SECTION_SUB_CATEGORY_ID = "s" ;
    private static final String SELL_SECTION_ITEM_ATTR_KIND  				       	= "k" ;
    private static final String SELL_SECTION_ITEM_ATTR_TITLE  				       	= "t" ;
    private static final String SELL_SECTION_ITEM_ATTR_CREATED_AT  				    = "cr" ;

    private static final String VIDEO_ATTR_ID  				   		= "id" ;
    private static final String VIDEO_ATTR_DURATION				   	= "d" ;
    private static final String VIDEO_ATTR_TITLE  				       	= "t" ;
    private static final String VIDEO_ATTR_VIDEO_CATEGORY_ID  		= "c" ;
    private static final String VIDEO_ATTR_VIDEO_SUB_CATEGORY_ID  	= "s" ;
    private static final String VIDEO_ATTR_KIND  				       	= "k" ;
    private static final String VIDEO_ATTR_THUMBNAIL_URL  			= "i" ;
    private static final String VIDEO_ATTR_DATA_URL      				= "v" ;
    private static final String VIDEO_ATTR_DATA_SIZE  				= "vs" ;
    private static final String VIDEO_ATTR_VIDEO_KEY 	  	            = "vk" ;
    private static final String VIDEO_ATTR_CREATED_AT  				= "cr" ;
    private static final String VIDEO_ATTR_MIXED_ID  	      			= "mi" ;
    private static final String VIDEO_ATTR_MIXED_CATEGORY_ID  		= "mc" ;
    private static final String VIDEO_ATTR_MIXED_SUB_CATEGORY_ID  	= "ms" ;
    private static final String VIDEO_ATTR_MIXED_KIND  				= "mk" ;
    private static final String VIDEO_ATTR_MIXED_THUMBNAIL_URL  	= "mt" ;
    private static final String VIDEO_ATTR_MIXED_DISPLAY_TYPE  		= "mdt" ;
    private static final String VIDEO_ATTR_MIXED_DISPLAY_NAME  		= "mdn" ;

    //<pdf id="6" t="Meghan Trainor - Dear Future Husband" c="1" s="0" k="1" i="http://__CLOUD_FRONT_HOST__/a/31000287/images/c_31000287_2015101514065701_6.jpg" cr="1444914471" />
    private static final String PDF_ATTR_ID  				   		= "id" ;
    private static final String PDF_ATTR_TITLE  				    = "t" ;
    private static final String PDF_ATTR_PDF_CATEGORY_ID  		    = "c" ;
    private static final String PDF_ATTR_PDF_SUB_CATEGORY_ID      	= "s" ;
    private static final String PDF_ATTR_KIND  			    	    = "k" ;
    private static final String PDF_ATTR_THUMBNAIL_URL  			= "i" ;
    private static final String PDF_ATTR_DATA_URL     				= "v" ;
    private static final String PDF_ATTR_DATA_SIZE  				= "vs" ;
    private static final String PDF_ATTR_ENCODED_URL  				= "bu" ;
    private static final String PDF_ATTR_ENCODED_TOKEN 				= "bt" ;
    private static final String PDF_ATTR_CREATED_AT  				= "cr" ;

    private static final String SELL_VIDEO_ATTR_ID     				  = "id" ;
    private static final String SELL_VIDEO_ATTR_VIDEO_ID 			   = "v" ;
    private static final String SELL_VIDEO_ATTR_PRODUCT_ID 			   = "pro" ;
    private static final String SELL_VIDEO_ATTR_PRICE 			       = "pri" ;
    private static final String SELL_VIDEO_ATTR_PRICE_TEXT 			       = "ptx" ;
    private static final String SELL_VIDEO_ATTR_DESCRIPTION 			   = "des" ;
    private static final String SELL_VIDEO_ATTR_BUTTON_TEXT 			   = "but" ;

    //<sell_pdf id="23" v="12" pro="co.veam.veam31000287.pdf.12" pri="299" ptx="$2.99" des="This is the sheet music.&#xA;&#xA;" but="Tap to purchase - $2.99" />
    private static final String SELL_PDF_ATTR_ID     			        = "id" ;
    private static final String SELL_PDF_ATTR_PDF_ID 		    	    = "v" ;
    private static final String SELL_PDF_ATTR_PRODUCT_ID 			    = "pro" ;
    private static final String SELL_PDF_ATTR_PRICE 			        = "pri" ;
    private static final String SELL_PDF_ATTR_PRICE_TEXT 			    = "ptx" ;
    private static final String SELL_PDF_ATTR_DESCRIPTION 			    = "des" ;
    private static final String SELL_PDF_ATTR_BUTTON_TEXT 			    = "but" ;

    private static final String SELL_AUDIO_ATTR_ID     			        = "id" ;
    private static final String SELL_AUDIO_ATTR_AUDIO_ID 		    	= "v" ;
    private static final String SELL_AUDIO_ATTR_PRODUCT_ID 			    = "pro" ;
    private static final String SELL_AUDIO_ATTR_PRICE 			        = "pri" ;
    private static final String SELL_AUDIO_ATTR_PRICE_TEXT 			    = "ptx" ;
    private static final String SELL_AUDIO_ATTR_DESCRIPTION 			= "des" ;
    private static final String SELL_AUDIO_ATTR_BUTTON_TEXT 			= "but" ;

    private static final String TEMPLATE_SUBSCRIPTION_ATTR_ID       = "id" ;
    private static final String TEMPLATE_SUBSCRIPTION_ATTR_TITLE    = "t" ;
    private static final String TEMPLATE_SUBSCRIPTION_ATTR_LAYOUT   = "l" ;
    private static final String TEMPLATE_SUBSCRIPTION_ATTR_KIND     = "k" ;
    private static final String TEMPLATE_SUBSCRIPTION_ATTR_IS_FREE  = "f" ;


    private static final String LIST_ATTR_ID                = "id" ;

    private int displayOrder = 1 ;

    private Context mContext ;
    ConsoleContents mConsoleContents ;
    String mUpdateId ;
    public boolean updateFailed ;
    private boolean skipParse = false ;
    private boolean youtubeSkip ;


    public boolean updateFailed(){
        return updateFailed ;
    }

    public UpdateConsoleXmlHandler(Context context,ConsoleContents consoleContents,SharedPreferences.Editor editor,boolean shouldLoadAlternativeImage,boolean youtubeSkip){
        super() ;
        mContext = context ;
        mConsoleContents = consoleContents ;
        updateFailed = false ;
        skipParse = false ;
        mUpdateId = "" ;
        this.editor = editor ;
        this.shouldLoadAlternativeImage = shouldLoadAlternativeImage ;
        this.youtubeSkip = youtubeSkip ;
    }


    /**
     * ドキュメント開始時
     */
    public void startDocument() {
        //VeamUtil.log("debug", "UpdateConsoleXmlHandler::startDocument") ;
        //mDb.beginTransaction();
        mConsoleContents.init() ;
    }

    /**
     * 要素の開始タグ読み込み時
     */
    public void startElement(String uri,String localName,String qName,Attributes attributes) {
        if(!skipParse){
            VeamUtil.log("debug", "startElement:" + qName + " localName=" + localName) ;

            String tag = "" ;
            if(localName.equals("")){
                tag = qName ;
            } else {
                tag = localName ;
            }


            if(tag.equals("content")){
                String contentId = attributes.getValue("id") ;

            } else if(tag.equals("app_info")){
                mConsoleContents.appInfo = new AppInfo(attributes) ;
                //NSLog(@"add app : %@",appInfo.status) ;
                String imageUrl = mConsoleContents.appInfo.getScreenShot1Url() ;
                if(!VeamUtil.isEmpty(imageUrl)) {
                    VeamUtil.log("debug","load image from " + imageUrl) ;
                    FileInputStream inputStream = VeamUtil.getCachedFileInputStream(mContext, imageUrl, true);
                }
                imageUrl = mConsoleContents.appInfo.getScreenShot2Url() ;
                if(!VeamUtil.isEmpty(imageUrl)) {
                    VeamUtil.log("debug","load image from " + imageUrl) ;
                    FileInputStream inputStream = VeamUtil.getCachedFileInputStream(mContext, imageUrl, true);
                }
                imageUrl = mConsoleContents.appInfo.getScreenShot3Url() ;
                if(!VeamUtil.isEmpty(imageUrl)) {
                    VeamUtil.log("debug","load image from " + imageUrl) ;
                    FileInputStream inputStream = VeamUtil.getCachedFileInputStream(mContext, imageUrl, true);
                }
                imageUrl = mConsoleContents.appInfo.getScreenShot4Url() ;
                if(!VeamUtil.isEmpty(imageUrl)) {
                    VeamUtil.log("debug","load image from " + imageUrl) ;
                    FileInputStream inputStream = VeamUtil.getCachedFileInputStream(mContext, imageUrl, true);
                }
                imageUrl = mConsoleContents.appInfo.getScreenShot5Url() ;
                if(!VeamUtil.isEmpty(imageUrl)) {
                    VeamUtil.log("debug","load image from " + imageUrl) ;
                    FileInputStream inputStream = VeamUtil.getCachedFileInputStream(mContext, imageUrl, true);
                }


            } else if(tag.equals("bank_info")){
                /*
                bankAccountInfo = [[BankAccountInfo alloc] initWithAttributes:attributeDict] ;
                //NSLog(@"add bank : %@",bankAccountInfo.accountName) ;
                */
            } else if(tag.equals("app_rating_question")){
                AppRatingQuestion appRatingQuestion = new AppRatingQuestion(attributes) ;
                mConsoleContents.appRatingQuestions.add(appRatingQuestion) ;
                //NSLog(@"add AppRatingQuestion : %@ %@",[appRatingQuestion question],[appRatingQuestion answer]) ;

                //// subscription
            } else if(tag.equals("template_subscription")){
                mConsoleContents.templateSubscription = new TemplateSubscription(attributes) ;
                //NSLog(@"add template_subscription : %@",[templateSubscription title]) ;

                //////// forum
            } else if(tag.equals("template_forum")){
                mConsoleContents.templateForum = new TemplateForum(attributes) ;
                //NSLog(@"add template_forum : %@",[templateForum title]) ;

            } else if(tag.equals("forum")){
                ForumObject forum = new ForumObject(attributes) ;
                if(!forum.getKind().equals(VeamUtil.VEAM_FORUM_KIND_HOT)){
                    mConsoleContents.forums.add(forum) ;
                    ////NSLog(@"add forum : %@ %@",[forum forumId],[forum forumName]) ;
                }
                //// youtube
            } else if(tag.equals("template_youtube")){
                mConsoleContents.templateYoutube = new TemplateYoutube(attributes) ;
                ////NSLog(@"add template_youtube : %@",[templateYoutube title]) ;

            } else if(tag.equals("youtube_category")){
                YoutubeCategoryObject youtubeCategory = new YoutubeCategoryObject(attributes) ;
                mConsoleContents.youtubeCategories.add(youtubeCategory) ;

                //NSLog(@"add category : %@ %@ %@",youtubeCategory.name,youtubeCategory.embed,youtubeCategory.embedUrl) ;

            } else if(tag.equals("youtube_sub_category")){
                /*
                YoutubeSubCategory *youtubeSubCategory = [[YoutubeSubCategory alloc] initWithAttributes:attributeDict] ;
                String youtubeCategoryId = [youtubeSubCategory youtubeCategoryId] ;

                NSMutableArray *subCategories = [youtubeSubCategoriesPerCategory objectForKey:youtubeCategoryId] ;
                if(subCategories == nil){
                    subCategories = [[NSMutableArray alloc] init] ;
                    [youtubeSubCategoriesPerCategory setObject:subCategories forKey:youtubeCategoryId] ;
                }
                [subCategories addObject:youtubeSubCategory] ;
                //NSLog(@"add sub category : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
                */
            } else if(tag.equals("youtube")){
                YoutubeObject youtube = new YoutubeObject(attributes) ;

                String youtubeSubCategoryId = youtube.getYoutubeSubCategoryId() ;

                /*
                ArrayList<YoutubeObject> youtubes = youtubesPerSubCategory.get objectForKey:youtubeSubCategoryId] ;
                if(youtubes == nil){
                    youtubes = [[NSMutableArray alloc] init] ;
                    [youtubesPerSubCategory setObject:youtubes forKey:youtubeSubCategoryId] ;
                }
                */
                //mConsoleContents.youtubes.a addObject:youtube] ;

                if(youtubeSubCategoryId.equals("0")){
                    String youtubeCategoryId = youtube.getYoutubeCategoryId() ;
                    ArrayList<YoutubeObject> youtubes = mConsoleContents.youtubesPerCategory.get(youtubeCategoryId) ;
                    if(youtubes == null){
                        youtubes = new ArrayList<YoutubeObject>() ;
                        mConsoleContents.youtubesPerCategory.put(youtubeCategoryId,youtubes) ;
                    }
                    youtubes.add(youtube) ;
                }

                mConsoleContents.youtubesForYoutubeId.put(youtube.getId(),youtube) ;
                //NSLog(@"add youtube video : %@ %@ %@",[youtube youtubeId],[youtube categoryId],[youtube subCategoryId]) ;


                //// mixed
            } else if(tag.equals("template_mixed")){
                mConsoleContents.templateMixed = new TemplateMixed(attributes) ;
                //NSLog(@"add template_mixed : %@",[templateMixed title]) ;

            } else if(tag.equals("mixed_category")){
                /*
                MixedCategoryObject mixedCategory = new MixedCategoryObject(attributes) ;
                mConsoleContents.mixedCategories.add(mixedCategory) ;

                //NSLog(@"add category : %@",[mixedCategory name]) ;
                */
            } else if(tag.equals("mixed_sub_category")){
                /*
                MixedSubCategory *mixedSubCategory = [[MixedSubCategory alloc] initWithAttributes:attributeDict] ;
                String mixedCategoryId = [mixedSubCategory mixedCategoryId] ;

                NSMutableArray *subCategories = [mixedSubCategoriesPerCategory objectForKey:mixedCategoryId] ;
                if(subCategories == nil){
                    subCategories = [[NSMutableArray alloc] init] ;
                    [mixedSubCategoriesPerCategory setObject:subCategories forKey:mixedCategoryId] ;
                }
                [subCategories addObject:mixedSubCategory] ;
                //NSLog(@"add sub category : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
                */
            } else if(tag.equals("mixed")){
                MixedObject mixed = new MixedObject(attributes) ;

                mConsoleContents.addMixed(mixed) ;
                VeamUtil.log("debug", "add mixed : " + mixed.getId() + " " + mixed.getTitle() + " " + mixed.getMixedCategoryId()) ;


                //// sell item category
            } else if(tag.equals("sell_item_category")){
                SellItemCategoryObject sellItemCategory = new SellItemCategoryObject(attributes) ;
                mConsoleContents.sellItemCategories.add(sellItemCategory) ;
                //NSLog(@"add sell item category : %@ %@",[sellItemCategory kind],[sellItemCategory targetCategoryId]) ;

                //// sell section category
            } else if(tag.equals("sell_section_category")){
                SellSectionCategoryObject sellSectionCategory = new SellSectionCategoryObject(attributes) ;
                mConsoleContents.sellSectionCategories.add(sellSectionCategory) ;
                //NSLog(@"add sell Section category : %@ %@",[sellSectionCategory kind],[sellSectionCategory name]) ;

                //// video
            } else if(tag.equals("video_category")){
                VideoCategoryObject videoCategory = new VideoCategoryObject(attributes) ;
                mConsoleContents.videoCategories.add(videoCategory) ;
                //NSLog(@"add video category : %@ %@",videoCategory.videoCategoryId,videoCategory.name) ;

            } else if(tag.equals("video_sub_category")){
                /*
                VideoSubCategoryObject videoSubCategory = new VideoSubCategoryObject(attributes) ;
                String videoCategoryId = [videoSubCategory videoCategoryId] ;

                NSMutableArray *videoSubCategories = [videoSubCategoriesPerCategory objectForKey:videoCategoryId] ;
                if(videoSubCategories == nil){
                    videoSubCategories = [[NSMutableArray alloc] init] ;
                    [videoSubCategoriesPerCategory setObject:videoSubCategories forKey:videoCategoryId] ;
                }
                [videoSubCategories addObject:videoSubCategory] ;
                //NSLog(@"add video sub category : %@ %@",[videoSubCategory subCategoryId],[videoSubCategory name]) ;
                */
            } else if(tag.equals("video")){
                VideoObject video = new VideoObject(attributes) ;
                String videoSubCategoryId = video.getVideoSubCategoryId() ;

                /*
                NSMutableArray *videos = [videosPerSubCategory objectForKey:videoSubCategoryId] ;
                if(videos == nil){
                    videos = [[NSMutableArray alloc] init] ;
                    [videosPerSubCategory setObject:videos forKey:videoSubCategoryId] ;
                }
                [mConsoleContents.videos addObject:video] ;
                */

                mConsoleContents.videosForVideoId.put(video.getId(),video) ;

                if(videoSubCategoryId.equals("0")){
                    String videoCategoryId = video.getVideoCategoryId() ;
                    ArrayList<VideoObject> videos = mConsoleContents.videosPerCategory.get(videoCategoryId) ;
                    if(videos == null){
                        videos = new ArrayList<VideoObject>() ;
                        mConsoleContents.videosPerCategory.put(videoCategoryId,videos) ;
                    }
                    videos.add(video) ;
                }

                //NSLog(@"add video : %@ %@",video.title,video.videoCategoryId) ;

            } else if(tag.equals("sell_video")){
                SellVideoObject sellVideo = new SellVideoObject() ;
                sellVideo.setId(attributes.getValue("id")) ;
                sellVideo.setVideoId(attributes.getValue("v")) ;
                sellVideo.setProductId(attributes.getValue("pro")) ;
                sellVideo.setPrice(attributes.getValue("pri")) ;
                sellVideo.setPriceText(attributes.getValue("ptx")) ;
                String description = attributes.getValue("des") ;
                String button = attributes.getValue("but") ;
                String status = attributes.getValue("st") ;
                String statusText = attributes.getValue("stt") ;

                if(VeamUtil.isEmpty(description)){
                    description = "" ;
                }
                sellVideo.setDescription(description) ;

                if(VeamUtil.isEmpty(button)){
                    button = "" ;
                }
                sellVideo.setButtonText(button) ;

                if(VeamUtil.isEmpty(status)){
                    status = "" ;
                }
                sellVideo.setStatus(status) ;

                if(VeamUtil.isEmpty(statusText)){
                    statusText = "" ;
                }
                sellVideo.setStatusText(statusText) ;

                mConsoleContents.sellVideos.add(sellVideo) ;
                mConsoleContents.sellVideosForSellVideoId.put(sellVideo.getId(),sellVideo) ;

                //NSLog(@"add sell video : %@ %@ %@ %@",[sellVideo videoId],[sellVideo description],sellVideo.status,sellVideo.status) ;

            } else if(tag.equals("sell_pdf")){
                SellPdfObject sellPdf = new SellPdfObject() ;
                sellPdf.setId(attributes.getValue("id")) ;
                sellPdf.setPdfId(attributes.getValue("v")) ;
                sellPdf.setProductId(attributes.getValue("pro")) ;
                sellPdf.setPrice(attributes.getValue("pri")) ;
                sellPdf.setPriceText(attributes.getValue("ptx")) ;
                String description = attributes.getValue("des") ;
                String button = attributes.getValue("but") ;
                String status = attributes.getValue("st") ;
                String statusText = attributes.getValue("stt") ;

                if(VeamUtil.isEmpty(description)){
                    description = "" ;
                }
                sellPdf.setDescription(description) ;

                if(VeamUtil.isEmpty(button)){
                    button = "" ;
                }
                sellPdf.setButtonText(button) ;

                if(VeamUtil.isEmpty(status)){
                    status = "" ;
                }
                sellPdf.setStatus(status) ;

                if(VeamUtil.isEmpty(statusText)){
                    statusText = "" ;
                }
                sellPdf.setStatusText(statusText) ;

                mConsoleContents.sellPdfs.add(sellPdf) ;
                mConsoleContents.sellPdfsForSellPdfId.put(sellPdf.getId(), sellPdf) ;

                //NSLog(@"add sell Pdf : %@ %@ %@ %@",sellPdf.pdfId,sellPdf.description,sellPdf.status,sellPdf.status) ;

            } else if(tag.equals("sell_section_item")){
                SellSectionItemObject sellSectionItem = new SellSectionItemObject() ;
                sellSectionItem.setId(attributes.getValue("id")) ;
                sellSectionItem.setSellSectionCategoryId(attributes.getValue("c")) ;
                sellSectionItem.setTitle(attributes.getValue("t")) ;
                sellSectionItem.setKind(attributes.getValue("k")) ;
                sellSectionItem.setContentId(attributes.getValue("v")) ;
                String status = attributes.getValue("st") ;
                String statusText = attributes.getValue("stt") ;

                if(VeamUtil.isEmpty(status)){
                    status = "" ;
                }
                sellSectionItem.setStatus(status) ;

                if(VeamUtil.isEmpty(statusText)){
                    statusText = "" ;
                }
                sellSectionItem.setStatusText(statusText) ;

                mConsoleContents.sellSectionItems.add(sellSectionItem) ;
                mConsoleContents.sellSectionItemsForSellSectionItemId.put(sellSectionItem.getId(),sellSectionItem) ;

                //NSLog(@"add sell SectionItem : %@ %@",[sellSectionItem sellSectionItemId],sellSectionItem.title) ;

            } else if(tag.equals("pdf_category")){
                PdfCategoryObject pdfCategory = new PdfCategoryObject(attributes) ;
                mConsoleContents.pdfCategories.add(pdfCategory) ;
                //NSLog(@"add pdf category : %@ %@",pdfCategory.pdfCategoryId,pdfCategory.name) ;

            } else if(tag.equals("pdf_sub_category")){
                /*
                PdfSubCategory *pdfSubCategory = [[PdfSubCategory alloc] initWithAttributes:attributeDict] ;
                String pdfCategoryId = [pdfSubCategory pdfCategoryId] ;

                NSMutableArray *pdfSubCategories = [pdfSubCategoriesPerCategory objectForKey:pdfCategoryId] ;
                if(pdfSubCategories == nil){
                    pdfSubCategories = [[NSMutableArray alloc] init] ;
                    [pdfSubCategoriesPerCategory setObject:pdfSubCategories forKey:pdfCategoryId] ;
                }
                [pdfSubCategories addObject:pdfSubCategory] ;
                //NSLog(@"add pdf sub category : %@ %@",[pdfSubCategory subCategoryId],[pdfSubCategory name]) ;
                */
            } else if(tag.equals("pdf")){
                PdfObject pdf = new PdfObject(attributes) ;
                String pdfSubCategoryId = pdf.getPdfSubCategoryId() ;

                /*
                NSMutableArray *pdfs = [pdfsPerSubCategory objectForKey:pdfSubCategoryId] ;
                if(pdfs == nil){
                    pdfs = [[NSMutableArray alloc] init] ;
                    [pdfsPerSubCategory setObject:pdfs forKey:pdfSubCategoryId] ;
                }
                [pdfs addObject:pdf] ;
                */
                mConsoleContents.pdfsForPdfId.put(pdf.getId(),pdf) ;

                if(pdfSubCategoryId.equals("0")){
                    String pdfCategoryId = pdf.getPdfCategoryId() ;
                    ArrayList<PdfObject> pdfs = mConsoleContents.pdfsPerCategory.get(pdfCategoryId) ;
                    if(pdfs == null){
                        pdfs = new ArrayList<PdfObject>() ;
                        mConsoleContents.pdfsPerCategory.put(pdfCategoryId,pdfs) ;
                    }
                    pdfs.add(pdf) ;
                }

                //NSLog(@"add pdf : %@ %@",pdf.title,pdf.imageUrl) ;

            } else if(tag.equals("sell_audio")){
                SellAudioObject sellAudio = new SellAudioObject() ;
                sellAudio.setId(attributes.getValue("id")) ;
                sellAudio.setAudioId(attributes.getValue("v")) ;
                sellAudio.setProductId(attributes.getValue("pro")) ;
                sellAudio.setPrice(attributes.getValue("pri")) ;
                sellAudio.setPriceText(attributes.getValue("ptx")) ;
                String description = attributes.getValue("des") ;
                String button = attributes.getValue("but") ;
                String status = attributes.getValue("st") ;
                String statusText = attributes.getValue("stt") ;

                if(VeamUtil.isEmpty(description)){
                    description = "" ;
                }
                sellAudio.setDescription(description) ;

                if(VeamUtil.isEmpty(button)){
                    button = "" ;
                }
                sellAudio.setButtonText(button) ;

                if(VeamUtil.isEmpty(status)){
                    status = "" ;
                }
                sellAudio.setStatus(status) ;

                if(VeamUtil.isEmpty(statusText)){
                    statusText = "" ;
                }
                sellAudio.setStatusText(statusText) ;

                mConsoleContents.sellAudios.add(sellAudio) ;
                mConsoleContents.sellAudiosForSellAudioId.put(sellAudio.getId(), sellAudio) ;

                //NSLog(@"console add sell Audio : %@ %@ %@ %@",[sellAudio audioId],[sellAudio description],sellAudio.status,sellAudio.status) ;

            } else if(tag.equals("audio_category")){
                AudioCategoryObject audioCategory = new AudioCategoryObject(attributes) ;
                mConsoleContents.audioCategories.add(audioCategory) ;
                //NSLog(@"add Audio category : %@ %@",AudioCategory.AudioCategoryId,AudioCategory.name) ;

            } else if(tag.equals("audio_sub_category")){
                /*
                AudioSubCategory *audioSubCategory = [[AudioSubCategory alloc] initWithAttributes:attributeDict] ;
                String audioCategoryId = [audioSubCategory audioCategoryId] ;

                NSMutableArray *audioSubCategories = [audioSubCategoriesPerCategory objectForKey:audioCategoryId] ;
                if(audioSubCategories == nil){
                    audioSubCategories = [[NSMutableArray alloc] init] ;
                    [audioSubCategoriesPerCategory setObject:audioSubCategories forKey:audioCategoryId] ;
                }
                [audioSubCategories addObject:audioSubCategory] ;
                //NSLog(@"add audio sub category : %@ %@",[audioSubCategory subCategoryId],[audioSubCategory name]) ;
                */
            } else if(tag.equals("audio")){
                AudioObject audio = new AudioObject(attributes) ;
                String audioSubCategoryId = audio.getAudioSubCategoryId() ;

                /*
                NSMutableArray *audios = [audiosPerSubCategory objectForKey:audioSubCategoryId] ;
                if(audios == nil){
                    audios = [[NSMutableArray alloc] init] ;
                    [audiosPerSubCategory setObject:audios forKey:audioSubCategoryId] ;
                }
                [audios addObject:audio] ;
                */
                mConsoleContents.audiosForAudioId.put(audio.getId(),audio) ;

                if(audioSubCategoryId.equals("0")){
                    String audioCategoryId = audio.getAudioCategoryId() ;
                    ArrayList<AudioObject> audios = mConsoleContents.audiosPerCategory.get(audioCategoryId) ;
                    if(audios == null){
                        audios = new ArrayList<AudioObject>() ;
                        mConsoleContents.audiosPerCategory.put(audioCategoryId,audios) ;
                    }
                    audios.add(audio) ;
                }

                VeamUtil.log("debug","add audio : "+audio.getId()+" "+audio.getTitle()) ;

        /*
    } else if(tag.equals("recipe_category")){
        RecipeCategory *recipeCategory = [[RecipeCategory alloc] initWithAttributes:attributeDict] ;
        [recipeCategories addObject:recipeCategory] ;
        //NSLog(@"add recipe category : %@ %@",[recipeCategory recipeCategoryId],[recipeCategory name]) ;
        */
            } else if(tag.equals("recipe")){
                /*
                Recipe *recipe = [[Recipe alloc] initWithAttributes:attributeDict] ;
                Mixed *mixed = recipe.mixed ;
                this.addMixed:mixed] ;

                [recipes addObject:recipe] ;
                //[recipesForId setObject:recipe forKey:[recipe recipeId)) ;
                //NSLog(@"add recipe : %@ %@ %@",[recipe recipeId],[recipe title],recipe.mixed.mixedId) ;
                */
                //// youtube
            } else if(tag.equals("template_web")){
                mConsoleContents.templateWeb = new TemplateWeb(attributes) ;
                //NSLog(@"add template_web : %@",[templateWeb title]) ;

            } else if(tag.equals("web")){
                WebObject web = new WebObject(attributes) ;
                mConsoleContents.webs.add(web) ;
                //NSLog(@"add web : %@ %@",[web webId],[web title]) ;

            } else if(tag.equals("alternative_image")){
                AlternativeImageObject alternativeImage = new AlternativeImageObject(attributes) ;
                mConsoleContents.alternativeImages.add(alternativeImage) ;
                mConsoleContents.alternativeImagesForFileName.put(alternativeImage.getFileName(),alternativeImage) ;
                //NSLog(@"add alternative image : %@ %@ %@",[alternativeImage alternativeImageId],[alternativeImage fileName],[alternativeImage url]) ;
                String imageUrl = alternativeImage.getUrl() ;
                if(!VeamUtil.isEmpty(imageUrl)) {
                    VeamUtil.log("debug","load image from " + imageUrl) ;
                    FileInputStream inputStream = VeamUtil.getCachedFileInputStream(mContext, imageUrl, true);
                }


            } else {
                //NSLog(@"elementName=%@",elementName) ;
                String value = attributes.getValue("value");
                if(value != null){
                    //NSLog(@"elementName=%@ value=%@",elementName,value) ;
                    mConsoleContents.dictionary.put(tag,value) ;
                }
            }
        }
    }

    /**
     * テキストデータ読み込み時
     */
    public void characters(char[] ch,int offset,int length) {
        //System.out.println("テキストデータ：" + new String(ch, offset, length));
    }

    /**
     * 要素の終了タグ読み込み時
     */
    public void endElement(String uri,String localName,String qName) {
        //System.out.println("要素終了:" + qName);
    }

    /**
     * ドキュメント終了時
     */
    public void endDocument() {
        //VeamUtil.log("debug","UpdateConsoleXmlHandler::endDocument");
    }


    private String getOrderString(){
        return String.format("%d",displayOrder++) ;
    }
}
