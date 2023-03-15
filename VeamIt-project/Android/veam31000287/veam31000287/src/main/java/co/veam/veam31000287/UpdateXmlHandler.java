package co.veam.veam31000287;

import android.content.Context;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import java.io.FileInputStream;

/**
 * Created by veam on 2015/06/18.
 */
public class UpdateXmlHandler extends DefaultHandler {

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
    SQLiteDatabase mDb ;
    String mUpdateId ;
    public boolean updateFailed ;
    private boolean skipParse = false ;
    private boolean youtubeSkip ;

    private UpdateXmlHandlerInterface progressHandler ;

    public boolean updateFailed(){
        return updateFailed ;
    }

    public UpdateXmlHandler(Context context,SQLiteDatabase db,SharedPreferences.Editor editor,boolean shouldLoadAlternativeImage,boolean youtubeSkip,UpdateXmlHandlerInterface progressHandler){
        super() ;
        mContext = context ;
        mDb = db ;
        updateFailed = false ;
        skipParse = false ;
        mUpdateId = "" ;
        this.editor = editor ;
        this.shouldLoadAlternativeImage = shouldLoadAlternativeImage ;
        this.youtubeSkip = youtubeSkip ;
        this.progressHandler = progressHandler ;
    }


    /**
     * ドキュメント開始時
     */
    public void startDocument() {
        VeamUtil.log("debug", "UpdateXmlHandler::startDocument") ;
        //mDb.beginTransaction();
    }

    /**
     * 要素の開始タグ読み込み時
     */
    public void startElement(String uri,String localName,String qName,Attributes attributes) {
        if(!skipParse){
            VeamUtil.log("debug","startElement:" + qName + " localName=" + localName) ;

            String tag = "" ;
            if(localName.equals("")){
                tag = qName ;
            } else {
                tag = localName ;
            }

            if (tag.equals(ELEMENT_NAME_LIST)){
                if(progressHandler != null){
                    progressHandler.onUpdateContentProgress(20);
                }
                mUpdateId = attributes.getValue(LIST_ATTR_ID) ;
                //VeamUtil.log("debug","updateId="+mUpdateId) ;
                String latestUpdateId = VeamUtil.getPreferenceString(mContext, VeamUtil.PREFERENCE_KEY_LATEST_UPDATE_ID) ;
                if((mUpdateId != null) && (latestUpdateId != null)){
                    if(mUpdateId.equals(latestUpdateId)){
                        skipParse = true ;
                    }
                }
            } else if(tag.equals(ELEMENT_NAME_YOUTUBE_CATEGORY)){
                String id = attributes.getValue(YOUTUBE_CATEGORY_ATTR_ID) ;
                String name = attributes.getValue(YOUTUBE_CATEGORY_ATTR_NAME) ;

                YoutubeCategoryObject youtubeCategoryObject = new YoutubeCategoryObject(mDb,id) ;
                if(youtubeCategoryObject.getId() == null){
                    youtubeCategoryObject.setId(id) ;
                }
                youtubeCategoryObject.setName(name) ;
                youtubeCategoryObject.setDisplayOrder(this.getOrderString()) ;
                youtubeCategoryObject.setUpdateTimeId(mUpdateId) ;
                youtubeCategoryObject.save() ;
            } else if(tag.equals(ELEMENT_NAME_FORUM)){
                String id = attributes.getValue(FORUM_ATTR_ID) ;
                String name = attributes.getValue(FORUM_ATTR_NAME) ;
                String kind = attributes.getValue(FORUM_ATTR_KIND) ;

                ForumObject forumObject = new ForumObject(mDb,id) ;
                if(forumObject.getId() == null){
                    forumObject.setId(id) ;
                }
                forumObject.setName(name) ;
                forumObject.setKind(kind) ;
                forumObject.setDisplayOrder(this.getOrderString()) ;
                forumObject.setUpdateTimeId(mUpdateId) ;
                forumObject.save() ;
            } else if(tag.equals(ELEMENT_NAME_WEB)){
                String id = attributes.getValue(WEB_ATTR_ID) ;
                String title = attributes.getValue(WEB_ATTR_TITLE) ;
                String url = attributes.getValue(WEB_ATTR_URL) ;
                String webCategoryId = attributes.getValue(WEB_ATTR_WEB_CATEGORY_ID) ;

                WebObject webObject = new WebObject(mDb,id) ;
                if(webObject.getId() == null){
                    webObject.setId(id) ;
                }
                webObject.setTitle(title) ;
                webObject.setUrl(url) ;
                webObject.setWebCategoryId(webCategoryId) ;
                webObject.setDisplayOrder(this.getOrderString()) ;
                webObject.setUpdateTimeId(mUpdateId) ;
                webObject.save() ;







            } else if(tag.equals(ELEMENT_NAME_AUDIO_CATEGORY)){
                String id = attributes.getValue(AUDIO_CATEGORY_ATTR_ID) ;
                String name = attributes.getValue(AUDIO_CATEGORY_ATTR_NAME) ;

                AudioCategoryObject audioCategoryObject = new AudioCategoryObject(mDb,id) ;
                if(audioCategoryObject.getId() == null){
                    audioCategoryObject.setId(id) ;
                }
                audioCategoryObject.setName(name) ;
                audioCategoryObject.setDisplayOrder(this.getOrderString()) ;
                audioCategoryObject.setUpdateTimeId(mUpdateId) ;
                audioCategoryObject.save() ;
                //VeamUtil.log("debug", "AudioCategoryObject" + audioCategoryObject.getName()) ;

            } else if(tag.equals(ELEMENT_NAME_SELL_AUDIO)){
                String id = attributes.getValue(SELL_AUDIO_ATTR_ID) ;
                String audioId = attributes.getValue(SELL_AUDIO_ATTR_AUDIO_ID) ;
                String productId = attributes.getValue(SELL_AUDIO_ATTR_PRODUCT_ID) ;
                String price = attributes.getValue(SELL_AUDIO_ATTR_PRICE) ;
                String priceText = attributes.getValue(SELL_AUDIO_ATTR_PRICE_TEXT) ;
                String description = attributes.getValue(SELL_AUDIO_ATTR_DESCRIPTION) ;
                String buttonText = attributes.getValue(SELL_AUDIO_ATTR_BUTTON_TEXT) ;

                SellAudioObject sellAudioObject = new SellAudioObject(mDb,id) ;
                if(sellAudioObject.getId() == null){
                    sellAudioObject.setId(id) ;
                }

                sellAudioObject.setAudioId(audioId) ;
                sellAudioObject.setProductId(productId) ;
                sellAudioObject.setPrice(price) ;
                sellAudioObject.setPriceText(priceText) ;
                sellAudioObject.setDescription(description) ;
                sellAudioObject.setButtonText(buttonText) ;

                sellAudioObject.setDisplayOrder(this.getOrderString()) ;
                sellAudioObject.setUpdateTimeId(mUpdateId) ;
                sellAudioObject.save() ;

                //VeamUtil.log("debug", "sellAudioObject" + sellAudioObject.getProductId()) ;
            } else if(tag.equals(ELEMENT_NAME_AUDIO)){
                String id = attributes.getValue(AUDIO_ATTR_ID) ;

                String duration = attributes.getValue(AUDIO_ATTR_DURATION) ;
                String title = attributes.getValue(AUDIO_ATTR_TITLE) ;
                String audioCategoryId = attributes.getValue(AUDIO_ATTR_AUDIO_CATEGORY_ID) ;
                String audioSubCategoryId = attributes.getValue(AUDIO_ATTR_AUDIO_SUB_CATEGORY_ID) ;
                String kind = attributes.getValue(AUDIO_ATTR_KIND) ;
                String thumbnailUrl = attributes.getValue(AUDIO_ATTR_THUMBNAIL_URL) ;
                String rectangleThumbnailUrl = attributes.getValue(AUDIO_ATTR_RECTANGLE_THUMBNAIL_URL) ;
                String dataUrl = attributes.getValue(AUDIO_ATTR_DATA_URL) ;
                String encodedUrl = attributes.getValue(AUDIO_ATTR_BASE64_URL) ;
                String dataSize = attributes.getValue(AUDIO_ATTR_DATA_SIZE) ;
                String linkUrl = attributes.getValue(AUDIO_ATTR_LINK_URL) ;
                String createdAt = attributes.getValue(AUDIO_ATTR_CREATED_AT) ;
                String mixedId = attributes.getValue(AUDIO_ATTR_MIXED_ID) ;
                String mixedCategoryId = attributes.getValue(AUDIO_ATTR_MIXED_CATEGORY_ID) ;
                String mixedSubCategoryId = attributes.getValue(AUDIO_ATTR_MIXED_SUB_CATEGORY_ID) ;
                String mixedKind = attributes.getValue(AUDIO_ATTR_MIXED_KIND) ;
                String mixedThumbnailUrl = attributes.getValue(AUDIO_ATTR_MIXED_THUMBNAIL_URL) ;
                String mixedDisplayType = attributes.getValue(AUDIO_ATTR_MIXED_DISPLAY_TYPE) ;
                String mixedDisplayName = attributes.getValue(AUDIO_ATTR_MIXED_DISPLAY_NAME) ;

                if(dataUrl == null){
                    dataUrl = "" ;
                }

                if(rectangleThumbnailUrl == null){
                    rectangleThumbnailUrl = "" ;
                }

                if(!VeamUtil.isEmpty(encodedUrl)){
                    //VeamUtil.log("debug","Audio Encoded Url = " + encodedUrl) ;
                    dataUrl = VeamUtil.bbDecode(encodedUrl) ;
                    //VeamUtil.log("debug","Audio Decoded Url = " + dataUrl) ;
                }

                AudioObject audioObject = new AudioObject(mDb,id) ;
                if(audioObject.getId() == null){
                    audioObject.setId(id) ;
                }
                audioObject.setDuration(duration) ;
                audioObject.setTitle(title) ;
                audioObject.setAudioCategoryId(audioCategoryId) ;
                audioObject.setAudioSubCategoryId(audioSubCategoryId) ;
                audioObject.setKind(kind) ;
                audioObject.setThumbnailUrl(thumbnailUrl) ;
                audioObject.setRectangleThumbnailUrl(rectangleThumbnailUrl) ;
                audioObject.setDataUrl(dataUrl) ;
                audioObject.setDataSize(dataSize) ;
                audioObject.setLinkUrl(linkUrl) ;
                audioObject.setCreatedAt(createdAt) ;

                audioObject.setDisplayOrder(this.getOrderString()) ;
                audioObject.setUpdateTimeId(mUpdateId) ;
                audioObject.save() ;

                if(!VeamUtil.isEmpty(mixedId)){
                    MixedObject mixedObject = new MixedObject(mDb,mixedId) ;
                    if(mixedObject.getId() == null){
                        mixedObject.setId(id) ;
                    }
                    mixedObject.setMixedCategoryId(mixedCategoryId);
                    mixedObject.setMixedSubCategoryId(mixedSubCategoryId);
                    mixedObject.setKind(mixedKind);
                    mixedObject.setThumbnailUrl(mixedThumbnailUrl);
                    mixedObject.setDisplayType(mixedDisplayType);
                    mixedObject.setDisplayName(mixedDisplayName);
                    mixedObject.setCreatedAt(createdAt) ;
                    mixedObject.setContentId(id);

                    mixedObject.setDisplayOrder(this.getOrderString()) ;
                    mixedObject.setUpdateTimeId(mUpdateId) ;
                    mixedObject.save() ;
                }
                //VeamUtil.log("debug", "audioObject" + audioObject.getTitle()  +" category="+audioObject.getAudioCategoryId() + " rectangleImage="+audioObject.getRectangleThumbnailUrl()) ;
            } else if(tag.equals(ELEMENT_NAME_SELL_SECTION_CATEGORY)){
                String id = attributes.getValue(SELL_SECTION_CATEGORY_ATTR_ID) ;
                String name = attributes.getValue(SELL_SECTION_CATEGORY_ATTR_NAME) ;

                SellSectionCategoryObject sellSectionCategoryObject = new SellSectionCategoryObject(mDb,id) ;
                if(sellSectionCategoryObject.getId() == null){
                    sellSectionCategoryObject.setId(id) ;
                }
                sellSectionCategoryObject.setName(name) ;
                sellSectionCategoryObject.setDisplayOrder(this.getOrderString()) ;
                sellSectionCategoryObject.setUpdateTimeId(mUpdateId) ;
                sellSectionCategoryObject.save() ;


            } else if(tag.equals(ELEMENT_NAME_SELL_SECTION_ITEM)){
                String id = attributes.getValue(SELL_SECTION_ITEM_ATTR_ID) ;
                String contentId = attributes.getValue(SELL_SECTION_ITEM_ATTR_CONTENT__ID) ;
                String categoryId = attributes.getValue(SELL_SECTION_ITEM_ATTR_SELL_SECTION_CATEGORY_ID) ;
                String subCategoryId = attributes.getValue(SELL_SECTION_ITEM_ATTR_SELL_SECTION_SUB_CATEGORY_ID) ;
                String kind = attributes.getValue(SELL_SECTION_ITEM_ATTR_KIND) ;
                String title = attributes.getValue(SELL_SECTION_ITEM_ATTR_TITLE) ;
                String createdAt = attributes.getValue(SELL_SECTION_ITEM_ATTR_CREATED_AT) ;

                if(createdAt == null){
                    createdAt = "" ;
                }

                SellSectionItemObject sellSectionItemObject = new SellSectionItemObject(mDb,id) ;
                if(sellSectionItemObject.getId() == null){
                    sellSectionItemObject.setId(id) ;
                }

                sellSectionItemObject.setContentId(contentId) ;
                sellSectionItemObject.setSellSectionCategoryId(categoryId) ;
                sellSectionItemObject.setSellSectionSubCategoryId(subCategoryId);
                sellSectionItemObject.setKind(kind);
                sellSectionItemObject.setTitle(title);
                sellSectionItemObject.setCreatedAt(createdAt);

                sellSectionItemObject.setDisplayOrder(this.getOrderString()) ;
                sellSectionItemObject.setUpdateTimeId(mUpdateId) ;
                sellSectionItemObject.save() ;

            } else if(tag.equals(ELEMENT_NAME_VIDEO_CATEGORY)){
                String id = attributes.getValue(VIDEO_CATEGORY_ATTR_ID) ;
                String name = attributes.getValue(VIDEO_CATEGORY_ATTR_NAME) ;

                VideoCategoryObject videoCategoryObject = new VideoCategoryObject(mDb,id) ;
                if(videoCategoryObject.getId() == null){
                    videoCategoryObject.setId(id) ;
                }
                videoCategoryObject.setName(name) ;
                videoCategoryObject.setDisplayOrder(this.getOrderString()) ;
                videoCategoryObject.setUpdateTimeId(mUpdateId) ;
                videoCategoryObject.save() ;

            } else if(tag.equals(ELEMENT_NAME_SELL_VIDEO)){
                String id = attributes.getValue(SELL_VIDEO_ATTR_ID) ;
                String videoId = attributes.getValue(SELL_VIDEO_ATTR_VIDEO_ID) ;
                String productId = attributes.getValue(SELL_VIDEO_ATTR_PRODUCT_ID) ;
                String price = attributes.getValue(SELL_VIDEO_ATTR_PRICE) ;
                String priceText = attributes.getValue(SELL_VIDEO_ATTR_PRICE_TEXT) ;
                String description = attributes.getValue(SELL_VIDEO_ATTR_DESCRIPTION) ;
                String buttonText = attributes.getValue(SELL_VIDEO_ATTR_BUTTON_TEXT) ;

                SellVideoObject sellVideoObject = new SellVideoObject(mDb,id) ;
                if(sellVideoObject.getId() == null){
                    sellVideoObject.setId(id) ;
                }

                sellVideoObject.setVideoId(videoId) ;
                sellVideoObject.setProductId(productId) ;
                sellVideoObject.setPrice(price) ;
                sellVideoObject.setPriceText(priceText) ;
                sellVideoObject.setDescription(description) ;
                sellVideoObject.setButtonText(buttonText) ;

                sellVideoObject.setDisplayOrder(this.getOrderString()) ;
                sellVideoObject.setUpdateTimeId(mUpdateId) ;
                sellVideoObject.save() ;

                //VeamUtil.log("debug", "sellVideoObject" + sellVideoObject.getProductId()) ;
            } else if(tag.equals(ELEMENT_NAME_VIDEO)){
                String id = attributes.getValue(VIDEO_ATTR_ID) ;

                String duration = attributes.getValue(VIDEO_ATTR_DURATION) ;
                String title = attributes.getValue(VIDEO_ATTR_TITLE) ;
                String videoCategoryId = attributes.getValue(VIDEO_ATTR_VIDEO_CATEGORY_ID) ;
                String videoSubCategoryId = attributes.getValue(VIDEO_ATTR_VIDEO_SUB_CATEGORY_ID) ;
                String kind = attributes.getValue(VIDEO_ATTR_KIND) ;
                String thumbnailUrl = attributes.getValue(VIDEO_ATTR_THUMBNAIL_URL) ;
                String dataUrl = attributes.getValue(VIDEO_ATTR_DATA_URL) ;
                String dataSize = attributes.getValue(VIDEO_ATTR_DATA_SIZE) ;
                String videoKey = attributes.getValue(VIDEO_ATTR_VIDEO_KEY) ;
                String createdAt = attributes.getValue(VIDEO_ATTR_CREATED_AT) ;
                String mixedId = attributes.getValue(VIDEO_ATTR_MIXED_ID) ;
                String mixedCategoryId = attributes.getValue(VIDEO_ATTR_MIXED_CATEGORY_ID) ;
                String mixedSubCategoryId = attributes.getValue(VIDEO_ATTR_MIXED_SUB_CATEGORY_ID) ;
                String mixedKind = attributes.getValue(VIDEO_ATTR_MIXED_KIND) ;
                String mixedThumbnailUrl = attributes.getValue(VIDEO_ATTR_MIXED_THUMBNAIL_URL) ;
                String mixedDisplayType = attributes.getValue(VIDEO_ATTR_MIXED_DISPLAY_TYPE) ;
                String mixedDisplayName = attributes.getValue(VIDEO_ATTR_MIXED_DISPLAY_NAME) ;

                VideoObject videoObject = new VideoObject(mDb,id) ;
                if(videoObject.getId() == null){
                    videoObject.setId(id) ;
                }
                videoObject.setDuration(duration) ;
                videoObject.setTitle(title) ;
                videoObject.setVideoCategoryId(videoCategoryId) ;
                videoObject.setVideoSubCategoryId(videoSubCategoryId) ;
                videoObject.setKind(kind) ;
                videoObject.setThumbnailUrl(thumbnailUrl) ;
                videoObject.setDataUrl(dataUrl) ;
                videoObject.setDataSize(dataSize) ;
                videoObject.setVideoKey(videoKey) ;
                videoObject.setCreatedAt(createdAt) ;

                videoObject.setDisplayOrder(this.getOrderString()) ;
                videoObject.setUpdateTimeId(mUpdateId) ;
                videoObject.save() ;

                if(!VeamUtil.isEmpty(mixedId)){
                    MixedObject mixedObject = new MixedObject(mDb,mixedId) ;
                    if(mixedObject.getId() == null){
                        mixedObject.setId(id) ;
                    }
                    mixedObject.setMixedCategoryId(mixedCategoryId);
                    mixedObject.setMixedSubCategoryId(mixedSubCategoryId);
                    mixedObject.setKind(mixedKind);
                    mixedObject.setThumbnailUrl(mixedThumbnailUrl);
                    mixedObject.setDisplayType(mixedDisplayType);
                    mixedObject.setDisplayName(mixedDisplayName);
                    mixedObject.setCreatedAt(createdAt) ;
                    mixedObject.setContentId(id) ;

                    mixedObject.setDisplayOrder(this.getOrderString()) ;
                    mixedObject.setUpdateTimeId(mUpdateId) ;
                    mixedObject.save() ;
                }
            } else if(tag.equals(ELEMENT_NAME_ALTERNATIVE_IMAGE) || tag.equals(ELEMENT_NAME_ALTERNATIVE_IMAGE_ML)){
                String id = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_ID) ;
                if(!VeamUtil.isStoredAlternativeImage(mContext,id)) {
                    String fileName = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_FILENAME);
                    String language = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_LANGUAGE);
                    String url = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_URL);

                    AlternativeImageObject alternativeImageObject = new AlternativeImageObject(mDb, id);
                    if (alternativeImageObject.getId() == null) {
                        alternativeImageObject.setId(id);
                    }
                    alternativeImageObject.setFileName(fileName);
                    alternativeImageObject.setLanguage(language);
                    alternativeImageObject.setUrl(url);
                    alternativeImageObject.setDisplayOrder(this.getOrderString());
                    alternativeImageObject.setUpdateTimeId(mUpdateId);
                    alternativeImageObject.save();
                    VeamUtil.log("debug",fileName + "="+url) ;
                } else {
                    //VeamUtil.log("debug","pre-stored") ;
                }







            } else if(tag.equals(ELEMENT_NAME_SELL_ITEM_CATEGORY)){
                String id = attributes.getValue(SELL_ITEM_CATEGORY_ATTR_ID) ;
                String kind = attributes.getValue(SELL_ITEM_CATEGORY_ATTR_KIND) ;
                String targetCategoryId = attributes.getValue(SELL_ITEM_CATEGORY_ATTR_TARGET_CATEGORY_ID) ;

                SellItemCategoryObject sellItemCategoryObject = new SellItemCategoryObject(mDb,id) ;
                if(sellItemCategoryObject.getId() == null){
                    sellItemCategoryObject.setId(id) ;
                }
                sellItemCategoryObject.setKind(kind) ;
                sellItemCategoryObject.setTargetCategoryId(targetCategoryId); ;
                sellItemCategoryObject.setDisplayOrder(this.getOrderString()) ;
                sellItemCategoryObject.setUpdateTimeId(mUpdateId) ;
                sellItemCategoryObject.save() ;

                //VeamUtil.log("debug","add SellItemCategory id="+ sellItemCategoryObject.getId() + " kind="+ sellItemCategoryObject.getKind() + " targetCategoryId="+ sellItemCategoryObject.getTargetCategoryId()) ;






            } else if(tag.equals(ELEMENT_NAME_PDF_CATEGORY)){
                String id = attributes.getValue(PDF_CATEGORY_ATTR_ID) ;
                String name = attributes.getValue(PDF_CATEGORY_ATTR_NAME) ;

                PdfCategoryObject pdfCategoryObject = new PdfCategoryObject(mDb,id) ;
                if(pdfCategoryObject.getId() == null){
                    pdfCategoryObject.setId(id) ;
                }
                pdfCategoryObject.setName(name) ;
                pdfCategoryObject.setDisplayOrder(this.getOrderString()) ;
                pdfCategoryObject.setUpdateTimeId(mUpdateId) ;
                pdfCategoryObject.save() ;

            } else if(tag.equals(ELEMENT_NAME_SELL_PDF)){
                String id = attributes.getValue(SELL_PDF_ATTR_ID) ;
                String pdfId = attributes.getValue(SELL_PDF_ATTR_PDF_ID) ;
                String productId = attributes.getValue(SELL_PDF_ATTR_PRODUCT_ID) ;
                String price = attributes.getValue(SELL_PDF_ATTR_PRICE) ;
                String priceText = attributes.getValue(SELL_PDF_ATTR_PRICE_TEXT) ;
                String description = attributes.getValue(SELL_PDF_ATTR_DESCRIPTION) ;
                String buttonText = attributes.getValue(SELL_PDF_ATTR_BUTTON_TEXT) ;

                SellPdfObject sellPdfObject = new SellPdfObject(mDb,id) ;
                if(sellPdfObject.getId() == null){
                    sellPdfObject.setId(id) ;
                }

                sellPdfObject.setPdfId(pdfId) ;
                sellPdfObject.setProductId(productId) ;
                sellPdfObject.setPrice(price) ;
                sellPdfObject.setPriceText(priceText) ;
                sellPdfObject.setDescription(description) ;
                sellPdfObject.setButtonText(buttonText) ;

                sellPdfObject.setDisplayOrder(this.getOrderString()) ;
                sellPdfObject.setUpdateTimeId(mUpdateId) ;
                sellPdfObject.save() ;

                //VeamUtil.log("debug", "sellVideoObject" + sellpdfObject.getProductId()) ;
            } else if(tag.equals(ELEMENT_NAME_PDF)){
                String id = attributes.getValue(PDF_ATTR_ID) ;

                String title = attributes.getValue(PDF_ATTR_TITLE) ;
                String pdfCategoryId = attributes.getValue(PDF_ATTR_PDF_CATEGORY_ID) ;
                String pdfSubCategoryId = attributes.getValue(PDF_ATTR_PDF_SUB_CATEGORY_ID) ;
                String kind = attributes.getValue(PDF_ATTR_KIND) ;
                String thumbnailUrl = attributes.getValue(PDF_ATTR_THUMBNAIL_URL) ;
                String createdAt = attributes.getValue(PDF_ATTR_CREATED_AT) ;

                String dataUrl = attributes.getValue(PDF_ATTR_DATA_URL) ;
                String dataSize = attributes.getValue(PDF_ATTR_DATA_SIZE) ;
                String encodedUrl = attributes.getValue(PDF_ATTR_ENCODED_URL) ;
                String encodedToken = attributes.getValue(PDF_ATTR_ENCODED_TOKEN) ;

                String token = "" ;

                if(!VeamUtil.isEmpty(encodedUrl)){
                    dataUrl = VeamUtil.bbDecode(encodedUrl) ;
                }

                if(!VeamUtil.isEmpty(encodedToken)){
                    token = VeamUtil.bbDecode(encodedToken) ;
                }

                if(VeamUtil.isEmpty(dataSize)){
                    dataSize = "" ;
                }


                PdfObject pdfObject = new PdfObject(mDb,id) ;
                if(pdfObject.getId() == null){
                    pdfObject.setId(id) ;
                }
                pdfObject.setTitle(title) ;
                pdfObject.setPdfCategoryId(pdfCategoryId);
                pdfObject.setPdfSubCategoryId(pdfSubCategoryId);
                pdfObject.setKind(kind) ;
                pdfObject.setThumbnailUrl(thumbnailUrl) ;
                pdfObject.setCreatedAt(createdAt) ;
                pdfObject.setDataUrl(dataUrl);
                pdfObject.setDataSize(dataSize);
                pdfObject.setToken(token);

                pdfObject.setDisplayOrder(this.getOrderString()) ;
                pdfObject.setUpdateTimeId(mUpdateId) ;
                pdfObject.save() ;

            } else if(tag.equals(ELEMENT_NAME_ALTERNATIVE_IMAGE) || tag.equals(ELEMENT_NAME_ALTERNATIVE_IMAGE_ML)){
                String id = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_ID) ;
                if(!VeamUtil.isStoredAlternativeImage(mContext,id)) {
                    String fileName = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_FILENAME);
                    String language = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_LANGUAGE);
                    String url = attributes.getValue(ALTERNATIVE_IMAGE_ATTR_URL);

                    AlternativeImageObject alternativeImageObject = new AlternativeImageObject(mDb, id);
                    if (alternativeImageObject.getId() == null) {
                        alternativeImageObject.setId(id);
                    }
                    alternativeImageObject.setFileName(fileName);
                    alternativeImageObject.setLanguage(language);
                    alternativeImageObject.setUrl(url);
                    alternativeImageObject.setDisplayOrder(this.getOrderString());
                    alternativeImageObject.setUpdateTimeId(mUpdateId);
                    alternativeImageObject.save();
                } else {
                    //VeamUtil.log("debug","pre-stored") ;
                }

















            } else if(tag.equals(ELEMENT_NAME_YOUTUBE_SUB_CATEGORY)){
                String id = attributes.getValue(YOUTUBE_SUB_CATEGORY_ATTR_ID) ;
                String youtubeCategoryId = attributes.getValue(YOUTUBE_SUB_CATEGORY_ATTR_CATEGORY_ID) ;
                String name = attributes.getValue(YOUTUBE_SUB_CATEGORY_ATTR_NAME) ;

                YoutubeSubCategoryObject youtubeSubCategoryObject = new YoutubeSubCategoryObject(mDb,id) ;
                if(youtubeSubCategoryObject.getId() == null){
                    youtubeSubCategoryObject.setId(id) ;
                }
                youtubeSubCategoryObject.setYoutubeCategoryId(youtubeCategoryId) ;
                youtubeSubCategoryObject.setName(name) ;
                youtubeSubCategoryObject.setDisplayOrder(this.getOrderString()) ;
                youtubeSubCategoryObject.setUpdateTimeId(mUpdateId) ;
                youtubeSubCategoryObject.save() ;
            } else if(tag.equals(ELEMENT_NAME_YOUTUBE)) {
                if(!youtubeSkip) {
                    String id = attributes.getValue(YOUTUBE_ATTR_ID);
                    String duration = attributes.getValue(YOUTUBE_ATTR_DURATION);
                    String title = attributes.getValue(YOUTUBE_ATTR_TITLE);
                    String description = attributes.getValue(YOUTUBE_ATTR_DESCRIPTION);
                    String youtubeCategoryId = attributes.getValue(YOUTUBE_ATTR_CATEGORY_ID);
                    String youtubeSubCategoryId = attributes.getValue(YOUTUBE_ATTR_SUB_CATEGORY_ID);
                    String youtubeVideoId = attributes.getValue(YOUTUBE_ATTR_YOUTUBE_VIDEO_ID);
                    String isNew = attributes.getValue(YOUTUBE_ATTR_IS_NEW);
                    String kind = attributes.getValue(YOUTUBE_ATTR_KIND);
                    String link = attributes.getValue(YOUTUBE_ATTR_LINK);

                    YoutubeObject youtubeObject = new YoutubeObject(mDb, id);
                    if (youtubeObject.getId() == null) {
                        youtubeObject.setId(id);
                    }

                    youtubeObject.setDuration(duration);
                    youtubeObject.setTitle(title);
                    youtubeObject.setDescription(description);
                    youtubeObject.setYoutubeCategoryId(youtubeCategoryId);
                    youtubeObject.setYoutubeSubCategoryId(youtubeSubCategoryId);
                    youtubeObject.setYoutubeVideoId(youtubeVideoId);
                    youtubeObject.setIsNew(isNew);
                    youtubeObject.setKind(kind);
                    youtubeObject.setLink(link);

                    youtubeObject.setDisplayOrder(this.getOrderString());
                    youtubeObject.setUpdateTimeId(mUpdateId);
                    youtubeObject.save();
                }
            } else if(tag.equals(ELEMENT_NAME_TEMPLATE_SUBSCRIPTION)){
                String id = attributes.getValue(TEMPLATE_SUBSCRIPTION_ATTR_ID);
                String title = attributes.getValue(TEMPLATE_SUBSCRIPTION_ATTR_TITLE);
                String layout = attributes.getValue(TEMPLATE_SUBSCRIPTION_ATTR_LAYOUT);
                String kind = attributes.getValue(TEMPLATE_SUBSCRIPTION_ATTR_KIND);
                String isFree = attributes.getValue(TEMPLATE_SUBSCRIPTION_ATTR_IS_FREE);
                if(VeamUtil.isEmpty(isFree)){
                    isFree = "0" ;
                }

                if(editor == null){
                    VeamUtil.setPreferenceString(mContext, VeamUtil.PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_KIND, kind) ;
                    VeamUtil.setPreferenceString(mContext, VeamUtil.PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_IS_FREE, isFree) ;
                    if(isFree.equals("1")) {
                        VeamUtil.setPreferenceString(mContext, String.format(VeamUtil.USERDEFAULT_KEY_SUBSCRIPTION_START_FORMAT, 0), "946652400"); // 2000/01/01 00:00:00
                    }

                } else {
                    editor.putString( VeamUtil.PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_KIND, kind);
                    editor.putString( VeamUtil.PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_IS_FREE, isFree);
                    if(isFree.equals("1")) {
                        editor.putString( String.format(VeamUtil.USERDEFAULT_KEY_SUBSCRIPTION_START_FORMAT, 0), "946652400"); // 2000/01/01 00:00:00
                    }
                }

                //VeamUtil.log("debug","template subscription isFree : " + isFree) ;

            } else {
                String value = attributes.getValue("value") ;
                if((value != null) && !value.equals("")){
                    //VeamUtil.log("debug","preference : " + tag + "->" + value) ;
                    if(editor == null){
                        VeamUtil.setPreferenceString(mContext, tag, value) ;
                    } else {
                        editor.putString( tag, value);
                    }
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
        VeamUtil.log("debug","UpdateXmlHandler::endDocument");

        if(progressHandler != null){
            progressHandler.onUpdateContentProgress(60);
        }

        if(!updateFailed && !mUpdateId.equals("") && !skipParse){
            // 不要なものを削除する

            // comment
            String where = "updatetimeid<>?" ;
            String[] params = new String[]{mUpdateId} ;

            VeamUtil.log("debug","UpdateXmlHandler remove record");
            mDb.delete("youtube_category", where, params) ;
            mDb.delete("youtube_sub_category", where, params) ;
            mDb.delete("youtube", where, params) ;
            mDb.delete("forum", where, params) ;
            mDb.delete("web", where, params) ;
            mDb.delete("audio", where, params) ;
            mDb.delete("video_category", where, params) ;
            mDb.delete("video", where, params) ;
            mDb.delete("sell_video", where, params) ;
            mDb.delete("mixed", where, params) ;
            mDb.delete("alternative_image", where, params) ;
            mDb.delete("sell_item_category", where, params) ;
            mDb.delete("sell_section_category", where, params) ;
            mDb.delete("sell_pdf", where, params) ;
            mDb.delete("pdf", where, params) ;
            mDb.delete("pdf_category", where, params) ;

            if(editor == null){
                VeamUtil.setPreferenceString(mContext, VeamUtil.PREFERENCE_KEY_LATEST_UPDATE_ID, mUpdateId) ;
            } else {
                //VeamUtil.log("debug","mUpdateId="+mUpdateId) ;
                editor.putString(VeamUtil.PREFERENCE_KEY_LATEST_UPDATE_ID, mUpdateId) ;
            }
        }

        if(shouldLoadAlternativeImage) {
            if(progressHandler != null){
                progressHandler.onUpdateContentProgress(80);
            }
            //VeamUtil.log("debug", "download alternativeImages");
            AlternativeImageObject[] alternativeImageObjects = VeamUtil.getAlternativeImageObjects(mDb);
            if(alternativeImageObjects != null) {
                int count = alternativeImageObjects.length;
                for (int index = 0; index < count; index++) {
                    AlternativeImageObject alternativeImageObject = alternativeImageObjects[index];
                    String imageUrl = alternativeImageObject.getUrl();
                    if (!VeamUtil.isEmpty(imageUrl)) {
                        FileInputStream inputStream = VeamUtil.getCachedFileInputStream(mContext, imageUrl, true);
                    }
                }
            }
        }

        //mDb.setTransactionSuccessful();
        //mDb.endTransaction() ;
        if(progressHandler != null){
            progressHandler.onUpdateContentProgress(100);
        }
    }


    private String getOrderString(){
        return String.format("%d",displayOrder++) ;
    }


    public interface  UpdateXmlHandlerInterface {
        public void onUpdateContentProgress(Integer percentage) ;
    }

}
