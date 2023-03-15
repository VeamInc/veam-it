package co.veam.veam31000287;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.telephony.TelephonyManager;
import android.text.Layout;
import android.text.TextPaint;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.ads.AdRequest;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/*
import me.kiip.sdk.Kiip;
import me.kiip.sdk.Poptart;
*/

public class VeamUtil {

    //#define VEAM_SERVER_FORMAT  @"http://app-work.veam.co/api2.php/%@/?a=%@&adid=%@"


	//// VeamIt Release ////
	/*
	public static final boolean IN_APP_BILLING_TEST = true ;
	public static final String SERVER_FORMAT = "http://app-preview.veam.co/api2.php/%s/?a=%s&loc=%s&adid=%s" ;
	public static final String CONSOLE_SERVER_FORMAT = "http://app-preview.veam.co/console.php/%s/?a=%s&loc=%s&ver=2" ;
	public static final String CONSOLE_UPLOAD_SERVER_FORMAT = "http://console-preview.veam.co/api.php/%s/?a=%s&loc=%s&ver=%s" ;
	public static final boolean IS_ACTIVE_DEBUG_LOG = false ;
	public static final boolean IS_PREVIEW_MODE = true ;
	//*/

	//// Template Release ////
	///*
	public static final boolean IN_APP_BILLING_TEST = false ;
	public static final String SERVER_FORMAT = "http://app.veam.co/api2.php/%s/?a=%s&loc=%s&adid=%s" ;
	public static final String CONSOLE_SERVER_FORMAT = "http://app-preview.veam.co/console.php/%s/?a=%s&loc=%s&ver=2" ;
	public static final String CONSOLE_UPLOAD_SERVER_FORMAT = "http://console-preview.veam.co/api.php/%s/?a=%s&loc=%s&ver=%s" ;
	public static final boolean IS_ACTIVE_DEBUG_LOG = false ;
	public static final boolean IS_PREVIEW_MODE = false ;
	//*/

	//// VeamIt Work ////
	/*
	public static final boolean IN_APP_BILLING_TEST = true ; public static final String SERVER_FORMAT = "http://app-work.veam.co/api2.php/%s/?a=%s&loc=%s&adid=%s" ; public static final String CONSOLE_SERVER_FORMAT = "http://app-work.veam.co/console.php/%s/?a=%s&loc=%s&ver=2" ;public static final String CONSOLE_UPLOAD_SERVER_FORMAT = "http://console-work.veam.co/api.php/%s/?a=%s&loc=%s&ver=%s" ;
	public static final boolean IS_ACTIVE_DEBUG_LOG = true ;
	public static final boolean IS_PREVIEW_MODE = true ;
	//*/

	//// VeamIt Custom ////
	/*
	public static final boolean IN_APP_BILLING_TEST = true ;
	public static final String SERVER_FORMAT = "http://app-preview.veam.co/api2.php/%s/?a=%s&loc=%s&adid=%s" ;
	public static final String CONSOLE_SERVER_FORMAT = "http://app-preview.veam.co/console.php/%s/?a=%s&loc=%s&ver=2" ;
	public static final String CONSOLE_UPLOAD_SERVER_FORMAT = "http://console-preview.veam.co/api.php/%s/?a=%s&loc=%s&ver=%s" ;
	public static final boolean IS_ACTIVE_DEBUG_LOG = true ;
	public static final boolean IS_PREVIEW_MODE = true ;
	//*/



	/*
	//public static final boolean IN_APP_BILLING_TEST = true ; public static final String SERVER_FORMAT = "http://app-work.veam.co/api2.php/%s/?a=%s&loc=%s&adid=%s" ; public static final String CONSOLE_SERVER_FORMAT = "http://app-work.veam.co/console.php/%s/?a=%s&loc=%s&ver=2" ;public static final String CONSOLE_UPLOAD_SERVER_FORMAT = "http://console-work.veam.co/api.php/%s/?a=%s&loc=%s&ver=%s" ;
	//public static final boolean IN_APP_BILLING_TEST = true ; public static final String SERVER_FORMAT = "http://app-preview.veam.co/api2.php/%s/?a=%s&loc=%s&adid=%s" ; public static final String CONSOLE_SERVER_FORMAT = "http://app-preview.veam.co/console.php/%s/?a=%s&loc=%s&ver=2" ;public static final String CONSOLE_UPLOAD_SERVER_FORMAT = "http://console-preview.veam.co/api.php/%s/?a=%s&loc=%s&ver=%s" ;
	public static final boolean IN_APP_BILLING_TEST = false ; public static final String SERVER_FORMAT = "http://app.veam.co/api2.php/%s/?a=%s&loc=%s&adid=%s" ; public static final String CONSOLE_SERVER_FORMAT = "http://app-preview.veam.co/console.php/%s/?a=%s&loc=%s&ver=2" ;public static final String CONSOLE_UPLOAD_SERVER_FORMAT = "http://console-preview.veam.co/api.php/%s/?a=%s&loc=%s&ver=%s" ;

	public static final boolean IS_ACTIVE_DEBUG_LOG = false ;

	//public static final boolean IS_PREVIEW_MODE = true ;  // VeamIt リリースの場合は SERVER_FORMAT は preview  にする
	public static final boolean IS_PREVIEW_MODE = false ;
	*/


	public static final boolean isActiveAdmob = false ;
	public static final String CONSOLE_API_CALL_VERSION = "2" ;



	// Client ID from https://code.google.com/apis/console API Access
	public static final String CLIENT_ID = "__GOOGLE_CLIENT_ID__";
	public static final String CLIENT_SECRET = "__GOOGLE_CLIENT_SECRET__";
	
	// Callback URL from https://code.google.com/apis/console API Access
	public static final String CALLBACK_URL = "http://localhost";

	public static final String OAUTH_URL =
										"https://accounts.google.com/o/oauth2/auth?" +
										"client_id=" + CLIENT_ID + "&" +
										"redirect_uri=" + CALLBACK_URL + "&" +
										"scope=https://gdata.youtube.com https://www.googleapis.com/auth/userinfo.email&" +
										"response_type=code&" +
										"access_type=offline";

	public static final String AUTH_CODE_PARAM = "?code=";
	// This is the url used to exchange your auth code for an access token
	public static final String TOKENS_URL = "https://accounts.google.com/o/oauth2/token";
	
    public static final String IAB_PUBLIC = "__IAB_PUBLIC__" ; // for co.veam.veam31000287 only // TO_BE_REPLACED
	public static final String SKU_SUBSCRIPTION_CALENDAR	= "co.veam.veam31000287.calendar.1m" ;
	public static final String SKU_BEGINNERS_CALENDAR		= "co.veam.veam31000287.calendar.beginners.4w" ;

	public static final String GCM_SENDER_ID = "186474333396" ;

	public static final String PREFERENCE_KEY_LATEST_UPDATE_ID			= "PREFERENCE_KEY_LATEST_UPDATE_ID" ;
	public static final String PREFERENCE_KEY_CALENDAR_DAY				= "CALENDAR_DAY_%s" ;
	public static final String PREFERENCE_KEY_FIXED_CALENDAR_DAY_FORMAT	= "FIXED_CALENDAR_%s_DAY_%s" ;
	public static final String PREFERENCE_KEY_SUBSCRIPTION_IS_BOUGHT	= "SUBSCRIPTION_IS_BOUGHT" ;
	public static final String PREFERENCE_KEY_BEGINNERS_IS_BOUGHT		= "BEGINNERS_IS_BOUGHT" ;
	public static final String PREFERENCE_KEY_FIXED_CALENDAR_IS_BOUGHT_FORMAT	= "FIXED_CALENDAR_%s_IS_BOUGHT" ;

	public static final String PREFERENCE_KEY_HAS_NEW_NOTIFICATION		= "HAS_NEW_NOTIFICATION" ;

	public static final String PREFERENCE_KEY_REGISTRATION_ID		= "RAGISTRATION_ID" ;

	public final static String PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_KIND 	= "TEMPLATE_SUBSCRIPTION_KIND" ;
	public final static String PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_IS_FREE	= "TEMPLATE_SUBSCRIPTION_IS_FREE" ;
	public static final String PREFERENCE_KEY_SELL_VIDEO_IS_BOUGHT_FORMAT	= "SELL_VIDEO_%s_IS_BOUGHT" ;
	public static final String PREFERENCE_KEY_SELL_PDF_IS_BOUGHT_FORMAT		= "SELL_PDF_%s_IS_BOUGHT" ;
	public static final String PREFERENCE_KEY_SELL_AUDIO_IS_BOUGHT_FORMAT 	= "SELL_AUDIO_%s_IS_BOUGHT" ;
	public static final String PREFERENCE_KEY_SELL_SECTION_IS_BOUGHT_FORMAT 	= "SELL_SECTION_%s_IS_BOUGHT" ;
	public static final String PREFERENCE_KEY_PDF_URL	= "PDF_%s_URL" ;
	public static final String PREFERENCE_KEY_PDF_TOKEN	= "PDF_%s_TOKEN" ;
	public static final String PREFERENCE_KEY_AUDIO_URL	= "AUDIO_%s_URL" ;


	public static final String NOTICE_UPDATE_FINISHED			= "UPDATE_FINISHED" ;
	public static final String NOTICE_NEW_NOTIFICATION_CHANGED	= "NEW_NOTIFICATION_CHANGED" ;
	public static final String NOTICE_NEW_PROFILE_NOTIFICATION	= "NEW_PROFILE_NOTIFICATION" ;
	public static final String NOTICE_NEW_MESSAGE				= "NEW_MESSAGE" ;

	
	public static final String YOUTUBE_DEVELOPER_KEY = "__YOUTUBE_API_KEY__";
	
	public static final String SOCIAL_USER_ID					= "SOCIAL_USER_ID" ;
	public static final String SOCIAL_USER_KIND					= "SOCIAL_USER_KIND" ;
	public static final String SOCIAL_USER_KIND_FACEBOOK		= "FACEBOOK" ;
	public static final String SOCIAL_USER_KIND_TWITTER			= "TWITTER" ;
	public static final String TWITTER_TOKEN_SECRET				= "PREFERENCE_DATA1" ;
	public static final String TWITTER_TOKEN					= "PREFERENCE_DATA2" ;
	public static final String TWITTER_USER_ID					= "TWITTER_USER_ID" ;
	public static final String TWITTER_USER						= "TWITTER_USER" ;
	public static final String TWITTER_USER_NAME				= "TWITTER_USER_NAME" ;
	public static final String TWITTER_IMAGE_URL				= "TWITTER_IMAGE_URL" ;
	public static final String FACEBOOK_TOKEN_SECRET			= "PREFERENCE_DATA3" ;
	public static final String FACEBOOK_TOKEN					= "PREFERENCE_DATA4" ;
	public static final String FACEBOOK_USER_ID					= "FACEBOOK_USER_ID" ;
	public static final String FACEBOOK_USER					= "FACEBOOK_USER" ;
	public static final String FACEBOOK_USER_NAME				= "FACEBOOK_USER_NAME" ;
	public static final String FACEBOOK_IMAGE_URL				= "FACEBOOK_IMAGE_URL" ;
	
	public static final String SPECIAL_FORUM_ID_MY_POSTS		= "MYPOST" ; 
	public static final String SPECIAL_FORUM_ID_USER_POST		= "USERPOST" ; 
	public static final String SPECIAL_FORUM_ID_FAVORITES		= "FAVORITES" ;
	public static final String SPECIAL_FORUM_ID_FOLLOWINGS		= "FOLLOWINGS" ;
	public static final String SPECIAL_FORUM_ID_MY_PROFILE		= "MYPROFILE" ;

	public static final String VEAM_FORUM_KIND_MY_POSTS            	= "0" ;
	public static final String VEAM_FORUM_KIND_NORMAL      			= "1" ;
	public static final String VEAM_FORUM_KIND_HOT                 	= "2" ;
	public static final String VEAM_FORUM_KIND_SWATCH              	= "3" ;
	public static final String VEAM_FORUM_KIND_BEFORE_AFTER        	= "4" ;
	public static final String VEAM_FORUM_KIND_RESTRICTED          	= "6" ;


	public static final String SPECIAL_YOUTUBE_CATEGORY_ID_FAVORITES = "FAVORITES" ;

	public static final String SPECIAL_RECIPE_CATEGORY_ID_FAVORITES = "FAVORITES" ;
	
	public static final String IS_CHECKED_IN					= "IS_CHECKED_IN" ;

	public static final int COORDINATE_CONVERT_VALUE	= 1000000 ;

    /*
    public static final String TWITTER_CONSUMER_KEY = "__TWITTER_CONSUMER_KEY__"; // TO_BE_REPLACED
    public static final String TWITTER_CONSUMER_SECRET = "__TWITTER_CONSUMER_SECRET__"; // TO_BE_REPLACED
    */
    public static final String TWITTER_CONSUMER_KEY = "__TWITTER_CONSUMER_KEY__"; // T005
    public static final String TWITTER_CONSUMER_SECRET = "__TWITTER_CONSUMER_SECRET__"; // T005

	
    private static SharedPreferences mPreferences = null ;
    private static String mUniqueId = null ;
    
    public static final int FORUM_PICTURE_SIZE = 600 ;


	public static int getDrawableId(Context context,String name)
	{
		return context.getResources().getIdentifier(name, "drawable", "co.veam.veam31000287") ;
	}

	public static int getStringId(Context context,String name)
	{
		return context.getResources().getIdentifier(name, "string", "co.veam.veam31000287") ;
	}

	public static boolean isConnected(Context context){
        ConnectivityManager cm = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo ni = cm.getActiveNetworkInfo();
        if( ni != null ){
            return cm.getActiveNetworkInfo().isConnected();
        }
        return false;
	}

	public static String getTemplateTitle(Context context,int templateId){
		String title = context.getString(VeamUtil.getStringId(context, String.format("tab_title_%d", templateId))) ;
		if(title == null){
			title = "" ;
		}
		return title ;
	}

	public static String getApiUrlString(Context context,String apiName)
	{
		return String.format(SERVER_FORMAT, apiName, VeamUtil.getAppId(), Locale.getDefault().toString(), AdvertisingIdHelper.getInstance(context).getAdvertisingId()) ;
	}

	public static String getConsoleApiUrlString(Context context,String apiName)
	{
		return String.format(CONSOLE_SERVER_FORMAT, apiName, VeamUtil.getAppId(), Locale.getDefault().toString()) ;
	}

	public static String getUploadApiUrl(String apiName) {
		return String.format(CONSOLE_UPLOAD_SERVER_FORMAT, apiName, VeamUtil.getAppId(), Locale.getDefault().toString(),CONSOLE_API_CALL_VERSION) ;

	}


	public static void notifyUpdateFinished(Context context)
	{
		//VeamUtil.log("debug","notifyUpdateFinished") ;
		Intent broadcastIntent = new Intent() ;
		broadcastIntent.putExtra("KIND", NOTICE_UPDATE_FINISHED);
		broadcastIntent.setAction("co.veam.veam31000287.OPERATION_COMPLETED");
		context.sendBroadcast(broadcastIntent);
		/*
		String favoriteChange = VEAMUtil.getPreferenceString(context, VEAMConsts.NOTICE_UPDATE_FINISHED) ;
		if(favoriteChange.equals("1")){
			VEAMUtil.setPreferenceString(context, VEAMConsts.NOTICE_UPDATE_FINISHED, "0") ;
		} else {
			VEAMUtil.setPreferenceString(context, VEAMConsts.NOTICE_UPDATE_FINISHED, "1") ;
		}
		*/
	}
	
    public static SharedPreferences getPreferences(Context context){
    	if(mPreferences == null){
    		mPreferences = context.getSharedPreferences( "veam31000287_PREFERENCE", Context.MODE_PRIVATE);
    	}
    	
    	return mPreferences ;
    }
    
    public static String getPreferenceString(Context context,String name){
    	return getPreferences(context).getString(name, "");
    }
    
    public static void setPreferenceString(Context context,String name,String value){
		SharedPreferences preferences = getPreferences(context) ;
		SharedPreferences.Editor editor = preferences.edit();
		editor.putString(name, value);
		editor.commit();
    }
    
    
	public static void insertNameAndValues(SQLiteDatabase db,String tableName,String [][]nameValues){
		String sqlString = String.format("INSERT INTO %s (",tableName) ;
		
		int length = nameValues.length ;
		for (int index = 0 ; index < length ; index++) {
			sqlString += nameValues[index][0] ;
			if(index < (length-1)){
				sqlString += "," ;
			}
		}
		
		sqlString += ") VALUES (" ;

		for (int index = 0 ; index < length ; index++) {
			String value = nameValues[index][1] ;
			if(value != null){
				value  = value.replaceAll("'", "''") ;
			} else {
				value = "" ;
			}
			
			sqlString += "'" + value + "'" ;
			if(index < (length-1)){
				sqlString += "," ;
			}
		}
		
		sqlString += ") ;" ;
		//VeamUtil.log("debug","sql = " + sqlString) ;
		db.execSQL(sqlString) ;
	}


	public static void updateNameAndValues(SQLiteDatabase db,String tableName,String id,String [][]nameValues){
    	String where = "id=?" ;
    	String[] params = new String[]{id} ;
    	ContentValues cv = new ContentValues();
    	int count = nameValues.length ;
    	for(int index = 0 ; index < count ; index++){
    		cv.put(nameValues[index][0], nameValues[index][1]);
    	}
		db.update(tableName, cv, where, params) ;
	}


    
	public static void insertYoutubeCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "youtube_category", nameValues) ;
	}
	
	public static void updateYoutubeCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "youtube_category", id, nameValues) ;
	}

	
	public static void insertForumGroupCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		//VeamUtil.log("debug","insertForumGroupCategory "+name) ;
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "forum_group_category", nameValues) ;
	}
	
	public static void updateForumGroupCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		//VeamUtil.log("debug","updateForumGroupCategory "+name) ;
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "forum_group_category", id, nameValues) ;
	}


    public static void insertForum(SQLiteDatabase db,String id,String name,String kind,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},{"name",name},{"kind",kind},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
        VeamUtil.insertNameAndValues(db, "forum", nameValues) ;
    }

    public static void updateForum(SQLiteDatabase db,String id,String name,String kind,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},{"name",name},{"kind",kind},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
        VeamUtil.updateNameAndValues(db, "forum", id, nameValues) ;
    }

    public static void insertWeb(SQLiteDatabase db,String id,String title,String url,String webCategoryId,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},{"title",title},{"url",url},{"web_category_id",webCategoryId},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
        VeamUtil.insertNameAndValues(db, "web", nameValues) ;
    }

    public static void updateWeb(SQLiteDatabase db,String id,String title,String url,String webCategoryId,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},{"title",title},{"url",url},{"web_category_id",webCategoryId},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
        VeamUtil.updateNameAndValues(db, "web", id, nameValues) ;
    }


    public static void insertAudio(SQLiteDatabase db,String id,String duration,String title,String audioCategoryId,String audioSubCategoryId,String kind,String thumbnailUrl,String rectangleThumbnailUrl,String dataUrl,String dataSize,String linkUrl,String createdAt,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},
                {"duration",duration},
                {"title",title},
                {"audio_category_id",audioCategoryId},
                {"audio_sub_category_id",audioSubCategoryId},
                {"kind",kind},
				{"thumbnail_url",thumbnailUrl},
				{"rectangle_thumbnail_url",rectangleThumbnailUrl},
                {"data_url",dataUrl},
                {"data_size",dataSize},
                {"link_url",linkUrl},
                {"created_at",createdAt},
                {"display_order",displayOrder},
                {"updatetimeid",updateTimeId}} ;
        VeamUtil.insertNameAndValues(db, "audio", nameValues) ;
    }

    public static void updateAudio(SQLiteDatabase db,String id,String duration,String title,String audioCategoryId,String audioSubCategoryId,String kind,String thumbnailUrl,String rectangleThumbnailUrl,String dataUrl,String dataSize,String linkUrl,String createdAt,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},
                {"duration",duration},
                {"title",title},
                {"audio_category_id",audioCategoryId},
                {"audio_sub_category_id",audioSubCategoryId},
                {"kind",kind},
				{"thumbnail_url",thumbnailUrl},
				{"rectangle_thumbnail_url",rectangleThumbnailUrl},
                {"data_url",dataUrl},
                {"data_size",dataSize},
                {"link_url",linkUrl},
                {"created_at",createdAt},
                {"display_order",displayOrder},
                {"updatetimeid",updateTimeId}} ;
        VeamUtil.updateNameAndValues(db, "audio", id, nameValues) ;
    }

    public static void insertVideo(SQLiteDatabase db,String id,String duration,String title,String videoCategoryId,String videoSubCategoryId,String kind,String thumbnailUrl,String dataUrl,String dataSize,String videoKey,String createdAt,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},
                {"duration",duration},
                {"title",title},
                {"video_category_id",videoCategoryId},
                {"video_sub_category_id",videoSubCategoryId},
                {"kind",kind},
                {"thumbnail_url",thumbnailUrl},
                {"data_url",dataUrl},
                {"data_size",dataSize},
                {"video_key",videoKey},
                {"created_at",createdAt},
                {"display_order",displayOrder},
                {"updatetimeid",updateTimeId}} ;
        VeamUtil.insertNameAndValues(db, "video", nameValues) ;
    }

    public static void updateVideo(SQLiteDatabase db,String id,String duration,String title,String videoCategoryId,String videoSubCategoryId,String kind,String thumbnailUrl,String dataUrl,String dataSize,String videoKey,String createdAt,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},
                {"duration",duration},
                {"title",title},
                {"video_category_id",videoCategoryId},
                {"video_sub_category_id",videoSubCategoryId},
                {"kind",kind},
                {"thumbnail_url",thumbnailUrl},
                {"data_url",dataUrl},
                {"data_size",dataSize},
                {"video_key",videoKey},
                {"created_at",createdAt},
                {"display_order",displayOrder},
                {"updatetimeid",updateTimeId}} ;
        VeamUtil.updateNameAndValues(db, "video", id, nameValues) ;
    }






























































	public static void insertPdf(SQLiteDatabase db,String id,String title,String pdfCategoryId,String pdfSubCategoryId,String kind,String thumbnailUrl,String createdAt,String displayOrder,String updateTimeId,String dataUrl,String dataSize,String token){
		String[][] nameValues = {{"id",id},
				{"title",title},
				{"pdf_category_id",pdfCategoryId},
				{"pdf_sub_category_id",pdfSubCategoryId},
				{"kind",kind},
				{"thumbnail_url",thumbnailUrl},
				{"created_at",createdAt},
				{"display_order",displayOrder},
				{"updatetimeid",updateTimeId},
				{"data_url",dataUrl},
				{"data_size",dataSize},
				{"token",token}
		} ;
		VeamUtil.insertNameAndValues(db, "pdf", nameValues) ;
	}

	public static void updatePdf(SQLiteDatabase db,String id,String title,String pdfCategoryId,String pdfSubCategoryId,String kind,String thumbnailUrl,String createdAt,String displayOrder,String updateTimeId,String dataUrl,String dataSize,String token){
		String[][] nameValues = {{"id",id},
				{"title",title},
				{"kind",kind},
				{"thumbnail_url",thumbnailUrl},
				{"created_at",createdAt},
				{"display_order",displayOrder},
				{"updatetimeid",updateTimeId},
				{"data_url",dataUrl},
				{"data_size",dataSize},
				{"token",token}
		} ;
		VeamUtil.updateNameAndValues(db, "pdf", id, nameValues) ;
	}



















	public static void insertSellVideo(SQLiteDatabase db,String id,String videoId,String productId,String price,String priceText,String description,String buttonText,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"video_id",videoId},{"product_id",productId},{"price",price},{"price_text",priceText},{"description",description},{"button_text",buttonText},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "sell_video", nameValues) ;
	}

	public static void updateSellVideo(SQLiteDatabase db,String id,String videoId,String productId,String price,String priceText,String description,String buttonText,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"video_id",videoId},{"product_id",productId},{"price",price},{"price_text",priceText},{"description",description},{"button_text",buttonText},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "sell_video", id, nameValues) ;
	}


	public static void insertSellPdf(SQLiteDatabase db,String id,String pdfId,String productId,String price,String priceText,String description,String buttonText,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"pdf_id",pdfId},{"product_id",productId},{"price",price},{"price_text",priceText},{"description",description},{"button_text",buttonText},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "sell_pdf", nameValues) ;
	}

	public static void updateSellPdf(SQLiteDatabase db,String id,String pdfId,String productId,String price,String priceText,String description,String buttonText,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"pdf_id",pdfId},{"product_id",productId},{"price",price},{"price_text",priceText},{"description",description},{"button_text",buttonText},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "sell_pdf", id, nameValues) ;
	}


	public static void insertSellAudio(SQLiteDatabase db,String id,String audioId,String productId,String price,String priceText,String description,String buttonText,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"audio_id",audioId},{"product_id",productId},{"price",price},{"price_text",priceText},{"description",description},{"button_text",buttonText},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "sell_audio", nameValues) ;
	}

	public static void updateSellAudio(SQLiteDatabase db,String id,String audioId,String productId,String price,String priceText,String description,String buttonText,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"audio_id",audioId},{"product_id",productId},{"price",price},{"price_text",priceText},{"description",description},{"button_text",buttonText},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "sell_audio", id, nameValues) ;
	}


	public static void insertVideoCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "video_category", nameValues) ;
	}

	public static void updateVideoCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "video_category", id, nameValues) ;
	}

	public static void insertPdfCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "pdf_category", nameValues) ;
	}

	public static void updatePdfCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "pdf_category", id, nameValues) ;
	}

	public static void insertAudioCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "audio_category", nameValues) ;
	}

	public static void updateAudioCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "audio_category", id, nameValues) ;
	}

	public static void insertSellItemCategory(SQLiteDatabase db,String id,String kind,String targetCategoryId,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"kind",kind},{"target_category_id",targetCategoryId},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "sell_item_category", nameValues) ;
	}

	public static void updateSellItemCategory(SQLiteDatabase db,String id,String kind,String targetCategoryId,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"kind",kind},{"target_category_id",targetCategoryId},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "sell_item_category", id, nameValues) ;
	}

	public static void insertSellSectionCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "sell_section_category", nameValues) ;
	}

	public static void updateSellSectionCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "sell_section_category", id, nameValues) ;
	}

	public static void insertMixed(SQLiteDatabase db,String id,String kind,String mixedCategoryId,String mixedSubCategoryId,String title,String contentId,String thumbnailUrl,String createdAt,String displayType,String displayName,String displayOrder,String updateTimeId){
        String[][] nameValues = {
                {"id",id},
                {"kind",kind},
                {"mixed_category_id",mixedCategoryId},
                {"mixed_sub_category_id",mixedSubCategoryId},
                {"title",title},
                {"content_id",contentId},
                {"thumbnail_url",thumbnailUrl},
                {"created_at",createdAt},
                {"display_type",displayType},
                {"display_name",displayName},
                {"display_order",displayOrder},
                {"updatetimeid",updateTimeId}} ;
        VeamUtil.insertNameAndValues(db, "mixed", nameValues) ;
    }

    public static void updateMixed(SQLiteDatabase db,String id,String kind,String mixedCategoryId,String mixedSubCategoryId,String title,String contentId,String thumbnailUrl,String createdAt,String displayType,String displayName,String displayOrder,String updateTimeId){
        String[][] nameValues = {
                {"id",id},
                {"kind",kind},
                {"mixed_category_id",mixedCategoryId},
                {"mixed_sub_category_id",mixedSubCategoryId},
                {"title",title},
                {"content_id",contentId},
                {"thumbnail_url",thumbnailUrl},
                {"created_at",createdAt},
                {"display_type",displayType},
                {"display_name",displayName},
                {"display_order",displayOrder},
                {"updatetimeid",updateTimeId}} ;
        VeamUtil.updateNameAndValues(db, "mixed", id, nameValues) ;
    }


	public static void insertSellSectionItem(SQLiteDatabase db,String id,String kind,String sellSectionCategoryId,String sellSectionSubCategoryId,String title,String contentId,String createdAt,String displayOrder,String updateTimeId){
		String[][] nameValues = {
				{"id",id},
				{"kind",kind},
				{"sell_section_category_id",sellSectionCategoryId},
				{"sell_section_sub_category_id",sellSectionSubCategoryId},
				{"title",title},
				{"content_id",contentId},
				{"created_at",createdAt},
				{"display_order",displayOrder},
				{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "sell_section_item", nameValues) ;
	}

	public static void updateSellSectionItem(SQLiteDatabase db,String id,String kind,String sellSectionCategoryId,String sellSectionSubCategoryId,String title,String contentId,String createdAt,String displayOrder,String updateTimeId){
		String[][] nameValues = {
				{"id",id},
				{"kind",kind},
				{"sell_section_category_id",sellSectionCategoryId},
				{"sell_section_sub_category_id",sellSectionSubCategoryId},
				{"title",title},
				{"content_id",contentId},
				{"created_at",createdAt},
				{"display_order",displayOrder},
				{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "sell_section_item", id, nameValues) ;
	}




	public static void insertAlternativeImage(SQLiteDatabase db,String id,String fileName,String language,String url,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},{"file_name",fileName},{"language",language},{"url",url},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
        VeamUtil.insertNameAndValues(db, "alternative_image", nameValues) ;
    }

    public static void updateAlternativeImage(SQLiteDatabase db,String id,String fileName,String language,String url,String displayOrder,String updateTimeId){
        String[][] nameValues = {{"id",id},{"file_name",fileName},{"language",language},{"url",url},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
        VeamUtil.updateNameAndValues(db, "alternative_image", id, nameValues) ;
    }


    public static void insertBulletin(SQLiteDatabase db,String id,String kind,String start,String end,String position,String backgroundColor,String textColor,String message,String imageUrl,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"kind",kind},{"start",start},{"end",end},{"position",position},{"background_color",backgroundColor},{"text_color",textColor},{"message",message},{"image_url",imageUrl},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;		
		VeamUtil.insertNameAndValues(db, "bulletin", nameValues) ;
	}
	
	public static void updateBulletin(SQLiteDatabase db,String id,String kind,String start,String end,String position,String backgroundColor,String textColor,String message,String imageUrl,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"kind",kind},{"start",start},{"end",end},{"position",position},{"background_color",backgroundColor},{"text_color",textColor},{"message",message},{"image_url",imageUrl},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "bulletin", id, nameValues) ;
	}

	public static void insertWeekdayText(SQLiteDatabase db,String id,String start,String end,String weekday,String action,String title,String description,String linkUrl,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"start",start},{"end",end},{"weekday",weekday},{"action",action},{"title",title},{"description",description},{"link_url",linkUrl},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "weekday_text", nameValues) ;
	}
	
	public static void updateWeekdayText(SQLiteDatabase db,String id,String start,String end,String weekday,String action,String title,String description,String linkUrl,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"start",start},{"end",end},{"weekday",weekday},{"action",action},{"title",title},{"description",description},{"link_url",linkUrl},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "weekday_text", id, nameValues) ;
	}
	
	public static void insertFixedCalendarMessage(SQLiteDatabase db,String id,String fixedCalendarId,String targetDay,String action,String title,String description,String linkUrl,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"fixed_calendar_id",fixedCalendarId},{"target_day",targetDay},{"action",action},{"title",title},{"description",description},{"link_url",linkUrl},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "fixed_calendar_message", nameValues) ;
	}
	
	public static void updateFixedCalendarMessage(SQLiteDatabase db,String id,String fixedCalendarId,String targetDay,String action,String title,String description,String linkUrl,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"fixed_calendar_id",fixedCalendarId},{"target_day",targetDay},{"action",action},{"title",title},{"description",description},{"link_url",linkUrl},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "fixed_calendar_message", id, nameValues) ;
	}
	
	public static void insertMonthlyVideo(SQLiteDatabase db,String id,String duration,String title,String imageUrl,String imageSize,String videoUrl,String videoSize,String videoKey,String yearMonth,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"duration",duration},{"title",title},{"image_url",imageUrl},{"image_size",imageSize},{"video_url",videoUrl},{"video_size",videoSize},{"video_key",videoKey},{"year_month",yearMonth},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "monthly_video", nameValues) ;
	}
	
	public static void updateMonthlyVideo(SQLiteDatabase db,String id,String duration,String title,String imageUrl,String imageSize,String videoUrl,String videoSize,String videoKey,String yearMonth,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"duration",duration},{"title",title},{"image_url",imageUrl},{"image_size",imageSize},{"video_url",videoUrl},{"video_size",videoSize},{"video_key",videoKey},{"year_month",yearMonth},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "monthly_video", id, nameValues) ;
	}

	public static void insertYoutubeSubCategory(SQLiteDatabase db,String id,String youtubeCategoryId, String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"youtube_category_id",youtubeCategoryId},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "youtube_sub_category", nameValues) ;
	}
	
	public static void updateYoutubeSubCategory(SQLiteDatabase db,String id,String youtubeCategoryId, String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"youtube_category_id",youtubeCategoryId},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "youtube_sub_category", id, nameValues) ;
	}

	public static void insertYoutube(SQLiteDatabase db,String id,String duration,String title,String description,String youtubeCategoryId,String youtubeSubCategoryId,String youtubeVideoId,String isNew,String kind,String link,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"duration",duration},{"title",title},{"description",description},{"youtube_category_id",youtubeCategoryId},{"youtube_sub_category_id",youtubeSubCategoryId},
				{"youtube_video_id",youtubeVideoId},{"is_new",isNew},{"kind",kind},{"link",link},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "youtube", nameValues) ;
	}
	
	public static void updateYoutube(SQLiteDatabase db,String id,String duration,String title,String description,String youtubeCategoryId,String youtubeSubCategoryId,String youtubeVideoId,String isNew,String kind,String link,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"duration",duration},{"title",title},{"description",description},{"youtube_category_id",youtubeCategoryId},{"youtube_sub_category_id",youtubeSubCategoryId},
				{"youtube_video_id",youtubeVideoId},{"is_new",isNew},{"kind",kind},{"link",link},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "youtube", id, nameValues) ;
	}

	
	public static void insertFixedCalendar(SQLiteDatabase db,String id,String displayName,String shortName,String description,String purchaseDescription,String product,String price,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"display_name",displayName},{"short_name",shortName},{"description",description},{"purchase_description",purchaseDescription},{"product",product},{"price",price},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "fixed_calendar", nameValues) ;
	}
	
	public static void updateFixedCalendar(SQLiteDatabase db,String id,String displayName,String shortName,String description,String purchaseDescription,String product,String price,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"display_name",displayName},{"short_name",shortName},{"description",description},{"purchase_description",purchaseDescription},{"product",product},{"price",price},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "fixed_calendar", id, nameValues) ;
	}


	public static void insertRecipeCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "recipe_category", nameValues) ;
	}
	
	public static void updateRecipeCategory(SQLiteDatabase db,String id,String name,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"name",name},{"display_order",displayOrder},{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "recipe_category", id, nameValues) ;
	}

	public static void insertRecipe(SQLiteDatabase db,String id,String recipeCategoryId,String imageUrl,String title,
			String ingredients,String directions,String nutrition,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"recipe_category_id",recipeCategoryId},{"image_url",imageUrl},{"title",title},
				{"ingredients",ingredients},{"directions",directions},{"nutrition",nutrition},{"display_order",displayOrder},
				{"updatetimeid",updateTimeId}} ;
		VeamUtil.insertNameAndValues(db, "recipe", nameValues) ;
	}
	
	public static void updateRecipe(SQLiteDatabase db,String id,String recipeCategoryId,String imageUrl,String title,
			String ingredients,String directions,String nutrition,String displayOrder,String updateTimeId){
		String[][] nameValues = {{"id",id},{"recipe_category_id",recipeCategoryId},{"image_url",imageUrl},{"title",title},
				{"ingredients",ingredients},{"directions",directions},{"nutrition",nutrition},{"display_order",displayOrder},
				{"updatetimeid",updateTimeId}} ;
		VeamUtil.updateNameAndValues(db, "recipe", id, nameValues) ;
	}

	
	/*
	public static BulletinObject getCurrentBulletin(SQLiteDatabase db){
		BulletinObject bulletinObject = null ;
		
    	String[] columns = new String[]{
    			"id",
    			"kind",
    			"start",
    			"end",
    			"position",
    			"background_color",
    			"text_color",
    			"message",
    			"image_url",
    			"display_order",
    			"updatetimeid",
    			} ;

    	Calendar calendar = new GregorianCalendar();  
        int gmtOffset = calendar.get(Calendar.ZONE_OFFSET);
        
    	long currentTimeLong = (System.currentTimeMillis() + gmtOffset) / 1000L  ;
    	String currentTimeString = String.format("%d", currentTimeLong) ;
    	//VeamUtil.log("debug","currentTimeString:"+currentTimeString ) ;
    	
    	String where = "start<=? and end>=?" ;
    	String[] params = new String[]{currentTimeString,currentTimeString} ;

		Cursor cursor = db.query("bulletin", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();
		
		int count = cursor.getCount() ;
		if(count > 0){
			bulletinObject = new BulletinObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),
					cursor.getString(5),cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10)) ;
			
			//VeamUtil.log("debug","start:"+bulletinObject.getStart()+" end:"+bulletinObject.getEnd()+" message:"+bulletinObject.getMessage()) ;
    	}
		cursor.close() ;
		
		return bulletinObject ;
	}
	*/


	
	public static YoutubeCategoryObject[] getYoutubeCategoryObjects(SQLiteDatabase db){
		YoutubeCategoryObject[] youtubeCategoryObjects = null ;
		
    	String[] columns = new String[]{
    			"id",
    			"name",
    			"display_order",
    			"updatetimeid",
    			} ;

		Cursor cursor = db.query("youtube_category", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();
		
		int count = cursor.getCount() ;
		if(count > 0){
			youtubeCategoryObjects = new YoutubeCategoryObject[count] ;
			for(int index = 0 ; index < count ; index++){
				youtubeCategoryObjects[index] = new YoutubeCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3)) ;
				cursor.moveToNext() ;
			}
    	}
		cursor.close() ;
		
		return youtubeCategoryObjects ;
	}
	
	public static ForumGroupCategoryObject[] getForumGroupCategoryObjects(SQLiteDatabase db){
		ForumGroupCategoryObject[] forumGroupCategoryObjects = null ;
		
    	String[] columns = new String[]{
    			"id",
    			"name",
    			"display_order",
    			"updatetimeid",
    			} ;

		Cursor cursor = db.query("forum_group_category", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();
		
		int count = cursor.getCount() ;
		//VeamUtil.log("debug","getForumGroupCategoryObjects count="+count) ;
		if(count > 0){
			forumGroupCategoryObjects = new ForumGroupCategoryObject[count] ;
			for(int index = 0 ; index < count ; index++){
				forumGroupCategoryObjects[index] = new ForumGroupCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3)) ;
				cursor.moveToNext() ;
			}
    	}
		cursor.close() ;
		
		return forumGroupCategoryObjects ;
	}
	
	public static ForumObject[] getForumObjects(SQLiteDatabase db){
		ForumObject[] forumObjects = null ;
		
    	String[] columns = new String[]{
    			"id",
                "name",
                "kind",
    			"display_order",
    			"updatetimeid",
    			} ;

		Cursor cursor = db.query("forum", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();
		
		int count = cursor.getCount() ;
		if(count > 0){
			forumObjects = new ForumObject[count] ;
			for(int index = 0 ; index < count ; index++){
				forumObjects[index] = new ForumObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),false,0) ;
				cursor.moveToNext() ;
			}
    	}
		cursor.close() ;
		
		return forumObjects ;
	}

	public static WebObject[] getWebObjects(SQLiteDatabase db,String webCategoryId) {
		WebObject[] webObjects = null;

		String[] columns = new String[]{
				"id",
				"title",
				"url",
				"web_category_id",
				"display_order",
				"updatetimeid",
		};

		String where = "web_category_id=?";
		String[] params = new String[]{webCategoryId};
		Cursor cursor = db.query("web", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount();
		if (count > 0) {
			webObjects = new WebObject[count];
			for (int index = 0; index < count; index++) {
				webObjects[index] = new WebObject(cursor.getString(0), cursor.getString(1), cursor.getString(2), cursor.getString(3), cursor.getString(4), cursor.getString(5));
				cursor.moveToNext();
			}
		}
		cursor.close();

		return webObjects;
	}

/*
	public static WebObject[] getWebObjects(SQLiteDatabase db){
        WebObject[] webObjects = null ;

        String[] columns = new String[]{
                "id",
                "title",
                "url",
                "web_category_id",
                "display_order",
                "updatetimeid",
        } ;

        Cursor cursor = db.query("web", columns, null, null, null, null, "display_order");
        cursor.moveToFirst();

        int count = cursor.getCount() ;
        if(count > 0){
            webObjects = new WebObject[count] ;
            for(int index = 0 ; index < count ; index++){
                webObjects[index] = new WebObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5)) ;
                cursor.moveToNext() ;
            }
        }
        cursor.close() ;

        return webObjects ;
    }
*/
	public static VideoObject[] getVideoObjects(Context context,SQLiteDatabase db,String videoCategoryId,String videoSubCategoryId){
		//VeamUtil.log("debug","VeamUtil.getVideoObjects " + videoCategoryId) ;
		VideoObject[] videoObjects = null ;

		String[] columns = new String[]{
				"id",
				"duration",
				"title",
				"video_category_id",
				"video_sub_category_id",
				"kind",
				"thumbnail_url",
				"data_url",
				"data_size",
				"video_key",
				"created_at",
				"display_order",
				"updatetimeid",
		} ;

		String where = "video_category_id=? and video_sub_category_id=?" ;
		String[] params = new String[]{videoCategoryId,videoSubCategoryId} ;
		Cursor cursor = db.query("video", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			videoObjects = new VideoObject[count] ;
			for(int index = 0 ; index < count ; index++){
				videoObjects[index] = new VideoObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),
						cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11),cursor.getString(12)) ;
				cursor.moveToNext() ;
				//VeamUtil.log("debug","video "+videoObjects[index].getKind() + " " + videoObjects[index].getTitle()) ;
			}
		}
		cursor.close() ;

		return videoObjects ;
	}


	public static SellSectionItemObject[] getSellSectionItemObjects(Context context,SQLiteDatabase db,String sellSectionCategoryId,String sellSectionSubCategoryId){
		//VeamUtil.log("debug","VeamUtil.getVideoObjects " + videoCategoryId) ;
		SellSectionItemObject[] sellSectionItemObjects = null ;

		String[] columns = new String[]{
				"id",
				"kind",
				"sell_section_category_id",
				"sell_section_sub_category_id",
				"title",
				"content_id",
				"created_at",
				"display_order",
				"updatetimeid",
		} ;

		/*
		String where = "sell_section_category_id=? and sell_section_sub_category_id=?" ;
		String[] params = new String[]{sellSectionCategoryId,sellSectionSubCategoryId} ;
		*/
		String where = "sell_section_category_id=?" ;
		String[] params = new String[]{sellSectionCategoryId} ;
		Cursor cursor = db.query("sell_section_item", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			sellSectionItemObjects = new SellSectionItemObject[count] ;
			for(int index = 0 ; index < count ; index++){
				sellSectionItemObjects[index] = new SellSectionItemObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),
						cursor.getString(5),cursor.getString(6),cursor.getString(7),cursor.getString(8)) ;
				cursor.moveToNext() ;
				//VeamUtil.log("debug","video "+videoObjects[index].getKind() + " " + videoObjects[index].getTitle()) ;
			}
		}
		cursor.close() ;

		return sellSectionItemObjects ;
	}


	public static VideoObject getVideoObject(SQLiteDatabase db,String videoId){
       //VeamUtil.log("debug","VeamUtil.getVideoObject " + videoId) ;

        VideoObject videoObject = null ;

        String[] columns = new String[]{
                "id",
                "duration",
                "title",
                "video_category_id",
                "video_sub_category_id",
                "kind",
                "thumbnail_url",
                "data_url",
                "data_size",
                "video_key",
                "created_at",
                "display_order",
                "updatetimeid",
        } ;

        String where = "id=?" ;
        String[] params = new String[]{videoId} ;

        Cursor cursor = db.query("video", columns, where, params, null, null, "display_order");
        cursor.moveToFirst();

        int count = cursor.getCount() ;
        if(count > 0){
           //VeamUtil.log("debug","found") ;
            videoObject = new VideoObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),
                    cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11),cursor.getString(12)) ;
        }
        cursor.close() ;

        return videoObject ;
    }




























	public static PdfObject[] getPdfObjects(Context context,SQLiteDatabase db,String pdfCategoryId,String pdfSubCategoryId){
		//VeamUtil.log("debug","VeamUtil.getPdfObjects " + pdfCategoryId) ;
		PdfObject[] pdfObjects = null ;

		String[] columns = new String[]{
				"id",
				"title",
				"pdf_category_id",
				"pdf_sub_category_id",
				"kind",
				"thumbnail_url",
				"created_at",
				"display_order",
				"updatetimeid",
				"data_url",
				"data_size",
				"token",
		} ;

		String where = "pdf_category_id=? and pdf_sub_category_id=?" ;
		String[] params = new String[]{pdfCategoryId,pdfSubCategoryId} ;
		Cursor cursor = db.query("pdf", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			pdfObjects = new PdfObject[count] ;
			for(int index = 0 ; index < count ; index++){
				pdfObjects[index] = new PdfObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),
						cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11)) ;
				cursor.moveToNext() ;
				//VeamUtil.log("debug","Pdf "+PdfObjects[index].getKind() + " " + PdfObjects[index].getTitle()) ;
			}
		}
		cursor.close() ;

		return pdfObjects ;
	}

	public static PdfObject getPdfObject(SQLiteDatabase db,String pdfId){
		//VeamUtil.log("debug","VeamUtil.getPdfObject " + pdfId) ;

		PdfObject pdfObject = null ;

		String[] columns = new String[]{
				"id",
				"title",
				"pdf_category_id",
				"pdf_sub_category_id",
				"kind",
				"thumbnail_url",
				"created_at",
				"display_order",
				"updatetimeid",
				"data_url",
				"data_size",
				"token",
		} ;

		String where = "id=?" ;
		String[] params = new String[]{pdfId} ;

		Cursor cursor = db.query("pdf", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			//VeamUtil.log("debug","found") ;
			pdfObject = new PdfObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),
					cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11)) ;
		}
		cursor.close() ;

		return pdfObject ;
	}



	/*
	public static AudioObject (SQLiteDatabase db,String audioId){
		//VeamUtil.log("debug","VeamUtil.getAudioObjegetAudioObjectct " + audioId) ;

		AudioObject audioObject = null ;

		String[] columns = new String[]{
				"id",
				"title",
				"audio_category_id",
				"audio_sub_category_id",
				"kind",
				"thumbnail_url",
				"created_at",
				"display_order",
				"updatetimeid",
		} ;

		String where = "id=?" ;
		String[] params = new String[]{audioId} ;

		Cursor cursor = db.query("audio", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			//VeamUtil.log("debug","found") ;
			audioObject = new AudioObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),
					cursor.getString(6),cursor.getString(7),cursor.getString(8)) ;
		}
		cursor.close() ;

		return audioObject ;
	}

	*/



















	public static SellItemCategoryObject[] getSellItemCategoryObjects(SQLiteDatabase db){
		SellItemCategoryObject[] sellItemCategoryObjects = null ;

		String[] columns = new String[]{
				"id",
				"kind",
				"target_category_id",
				"display_order",
				"updatetimeid",
		} ;

		Cursor cursor = db.query("sell_item_category", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		//VeamUtil.log("debug","getSellItemCategoryObjects count="+count) ;
		if(count > 0){
			sellItemCategoryObjects = new SellItemCategoryObject[count] ;
			for(int index = 0 ; index < count ; index++){
				sellItemCategoryObjects[index] = new SellItemCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4)) ;
				cursor.moveToNext() ;
			}
		}
		cursor.close() ;

		return sellItemCategoryObjects ;
	}

	public static VideoCategoryObject[] getVideoCategoryObjects(SQLiteDatabase db){
		VideoCategoryObject[] videoCategoryObjects = null ;

		String[] columns = new String[]{
				"id",
				"name",
				"display_order",
				"updatetimeid",
		} ;

		Cursor cursor = db.query("video_category", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		//VeamUtil.log("debug","getVideoCategoryObjects count="+count) ;
		if(count > 0){
			videoCategoryObjects = new VideoCategoryObject[count] ;
			for(int index = 0 ; index < count ; index++){
				videoCategoryObjects[index] = new VideoCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3)) ;
				cursor.moveToNext() ;
			}
		}
		cursor.close() ;

		return videoCategoryObjects ;
	}





	public static SellSectionCategoryObject[] getSellSectionCategoryObjects(SQLiteDatabase db){
		SellSectionCategoryObject[] sellSectionCategoryObjects = null ;

		String[] columns = new String[]{
				"id",
				"name",
				"display_order",
				"updatetimeid",
		} ;

		Cursor cursor = db.query("sell_section_category", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		//VeamUtil.log("debug","getSellSectionCategoryObjects count="+count) ;
		if(count > 0){
			sellSectionCategoryObjects = new SellSectionCategoryObject[count] ;
			for(int index = 0 ; index < count ; index++){
				sellSectionCategoryObjects[index] = new SellSectionCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3)) ;
				cursor.moveToNext() ;
			}
		}
		cursor.close() ;

		return sellSectionCategoryObjects ;
	}






	public static VideoCategoryObject getVideoCategoryObject(SQLiteDatabase db,String videoCategoryId){
		//VeamUtil.log("debug","VeamUtil.getVideoCategoryObject " + videoCategoryId) ;
		VideoCategoryObject videoCategoryObject = null ;

		String[] columns = new String[]{
				"id",
				"name",
				"display_order",
				"updatetimeid",
		} ;

		String where = "id=?" ;
		String[] params = new String[]{videoCategoryId} ;
		Cursor cursor = db.query("video_category", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		//VeamUtil.log("debug","getVideoCategoryObjects count="+count) ;
		if(count > 0){
			videoCategoryObject = new VideoCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3)) ;
		}
		cursor.close() ;

		return videoCategoryObject ;

	}



	public static PdfCategoryObject getPdfCategoryObject(SQLiteDatabase db,String pdfCategoryId){
		//VeamUtil.log("debug","VeamUtil.getPdfCategoryObject " + pdfCategoryId) ;
		PdfCategoryObject pdfCategoryObject = null ;

		String[] columns = new String[]{
				"id",
				"name",
				"display_order",
				"updatetimeid",
		} ;

		String where = "id=?" ;
		String[] params = new String[]{pdfCategoryId} ;
		Cursor cursor = db.query("pdf_category", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		//VeamUtil.log("debug","getPdfCategoryObjects count="+count) ;
		if(count > 0){
			pdfCategoryObject = new PdfCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3)) ;
		}
		cursor.close() ;

		return pdfCategoryObject ;

	}




	public static AudioCategoryObject getAudioCategoryObject(SQLiteDatabase db,String audioCategoryId){
		//VeamUtil.log("debug","VeamUtil.getAudioCategoryObject " + audioCategoryId) ;
		AudioCategoryObject audioCategoryObject = null ;

		String[] columns = new String[]{
				"id",
				"name",
				"display_order",
				"updatetimeid",
		} ;

		String where = "id=?" ;
		String[] params = new String[]{audioCategoryId} ;
		Cursor cursor = db.query("audio_category", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		//VeamUtil.log("debug","getAudioCategoryObjects count="+count) ;
		if(count > 0){
			audioCategoryObject = new AudioCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3)) ;
		}
		cursor.close() ;

		return audioCategoryObject ;

	}




	public static SellVideoObject[] getSellVideoObjects(SQLiteDatabase db){
		SellVideoObject[] sellVideoObjects = null ;

		String[] columns = new String[]{"id","video_id","product_id","price","price_text","description","button_text","display_order","updatetimeid"} ;

		Cursor cursor = db.query("sell_video", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			sellVideoObjects = new SellVideoObject[count] ;
			for(int index = 0 ; index < count ; index++){
				sellVideoObjects[index] = new SellVideoObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),cursor.getString(6),cursor.getString(7),cursor.getString(8)) ;
				cursor.moveToNext() ;
			}
		}
		cursor.close() ;

		return sellVideoObjects ;
	}

	public static SellVideoObject[] getSellVideoObjectsForVideoCategory(SQLiteDatabase db,String videoCategoryId){
		SellVideoObject[] sellVideoObjects = VeamUtil.getSellVideoObjects(db) ;
		SellVideoObject[] retValue = null ;
		if(sellVideoObjects != null){
			List<SellVideoObject> sellVideoList = new ArrayList<SellVideoObject>();
			int count = sellVideoObjects.length ;
			for(int index = 0 ; index < count ; index++){
				SellVideoObject sellVideoObject = sellVideoObjects[index] ;
				if(sellVideoObject != null) {
					VideoObject videoObject = VeamUtil.getVideoObject(db, sellVideoObject.getVideoId());
					if(videoObject != null){
						if(videoObject.getVideoCategoryId().equals(videoCategoryId)){
							sellVideoList.add(sellVideoObject);
						}
					}
				}
			}
			retValue =(SellVideoObject[])sellVideoList.toArray(new SellVideoObject[sellVideoList.size()]);
		}

		return retValue ;

	}













	public static SellPdfObject[] getSellPdfObjects(SQLiteDatabase db){
		SellPdfObject[] sellPdfObjects = null ;

		String[] columns = new String[]{"id","pdf_id","product_id","price","price_text","description","button_text","display_order","updatetimeid"} ;

		Cursor cursor = db.query("sell_pdf", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			sellPdfObjects = new SellPdfObject[count] ;
			for(int index = 0 ; index < count ; index++){
				sellPdfObjects[index] = new SellPdfObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),cursor.getString(6),cursor.getString(7),cursor.getString(8)) ;
				cursor.moveToNext() ;
			}
		}
		cursor.close() ;

		return sellPdfObjects ;
	}

	public static SellPdfObject[] getSellPdfObjectsForPdfCategory(SQLiteDatabase db,String pdfCategoryId){
		SellPdfObject[] sellPdfObjects = VeamUtil.getSellPdfObjects(db) ;
		SellPdfObject[] retValue = null ;
		if(sellPdfObjects != null){
			List<SellPdfObject> sellPdfList = new ArrayList<SellPdfObject>();
			int count = sellPdfObjects.length ;
			for(int index = 0 ; index < count ; index++){
				SellPdfObject sellPdfObject = sellPdfObjects[index] ;
				if(sellPdfObject != null) {
					PdfObject pdfObject = VeamUtil.getPdfObject(db, sellPdfObject.getPdfId());
					if(pdfObject != null){
						if(pdfObject.getPdfCategoryId().equals(pdfCategoryId)){
							sellPdfList.add(sellPdfObject);
						}
					}
				}
			}
			retValue =(SellPdfObject[])sellPdfList.toArray(new SellPdfObject[sellPdfList.size()]);
		}

		return retValue ;

	}
























	public static SellAudioObject[] getSellAudioObjects(SQLiteDatabase db){
		SellAudioObject[] sellAudioObjects = null ;

		String[] columns = new String[]{"id","audio_id","product_id","price","price_text","description","button_text","display_order","updatetimeid"} ;

		Cursor cursor = db.query("sell_audio", columns, null, null, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			sellAudioObjects = new SellAudioObject[count] ;
			for(int index = 0 ; index < count ; index++){
				sellAudioObjects[index] = new SellAudioObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),cursor.getString(6),cursor.getString(7),cursor.getString(8)) ;
				cursor.moveToNext() ;
			}
		}
		cursor.close() ;

		return sellAudioObjects ;
	}

	public static SellAudioObject[] getSellAudioObjectsForAudioCategory(SQLiteDatabase db,String audioCategoryId){
		SellAudioObject[] sellAudioObjects = VeamUtil.getSellAudioObjects(db) ;
		SellAudioObject[] retValue = null ;
		if(sellAudioObjects != null){
			List<SellAudioObject> sellAudioList = new ArrayList<SellAudioObject>();
			int count = sellAudioObjects.length ;
			//VeamUtil.log("debug","getSellAudioObjectsForAudioCategory count="+count) ;
			for(int index = 0 ; index < count ; index++){
				SellAudioObject sellAudioObject = sellAudioObjects[index] ;
				if(sellAudioObject != null) {
					AudioObject audioObject = VeamUtil.getAudioObject(db, sellAudioObject.getAudioId());
					if(audioObject != null){
						if(audioObject.getAudioCategoryId().equals(audioCategoryId)){
							sellAudioList.add(sellAudioObject);
						}
					}
				}
			}
			retValue =(SellAudioObject[])sellAudioList.toArray(new SellAudioObject[sellAudioList.size()]);
		}

		return retValue ;

	}


























	public static AudioObject[] getAudioObjects(Context context,SQLiteDatabase db,String audioCategoryId,String audioSubCategoryId){
		//VeamUtil.log("debug","VeamUtil.getAudioObjects " + audioCategoryId) ;
		AudioObject[] audioObjects = null ;

		String[] columns = new String[]{
				"id",
				"duration",
				"title",
				"audio_category_id",
				"audio_sub_category_id",
				"kind",
				"thumbnail_url",
				"rectangle_thumbnail_url",
				"data_url",
				"data_size",
				"link_url",
				"created_at",
				"display_order",
				"updatetimeid",
		} ;

		String where = "audio_category_id=? and audio_sub_category_id=?" ;
		String[] params = new String[]{audioCategoryId,audioSubCategoryId} ;
		Cursor cursor = db.query("audio", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();

		int count = cursor.getCount() ;
		if(count > 0){
			audioObjects = new AudioObject[count] ;
			for(int index = 0 ; index < count ; index++){
				audioObjects[index] = new AudioObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),
						cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11),cursor.getString(12),cursor.getString(13)) ;
				cursor.moveToNext() ;
				//VeamUtil.log("debug","Audio "+AudioObjects[index].getKind() + " " + AudioObjects[index].getTitle()) ;
			}
		}
		cursor.close() ;

		return audioObjects ;
	}

	public static AudioObject getAudioObject(SQLiteDatabase db,String audioId){
       //VeamUtil.log("debug","VeamUtil.getAudioObject " + audioId) ;

        AudioObject audioObject = null ;

        String[] columns = new String[]{
                "id",
                "duration",
                "title",
                "audio_category_id",
                "audio_sub_category_id",
                "kind",
				"thumbnail_url",
				"rectangle_thumbnail_url",
                "data_url",
                "data_size",
                "link_url",
                "created_at",
                "display_order",
                "updatetimeid",
        } ;

        String where = "id=?" ;
        String[] params = new String[]{audioId} ;

        Cursor cursor = db.query("audio", columns, where, params, null, null, "display_order");
        cursor.moveToFirst();

        int count = cursor.getCount() ;
        if(count > 0){
           //VeamUtil.log("debug","found") ;
            audioObject = new AudioObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5),
                    cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11),cursor.getString(12),cursor.getString(13)) ;
        }
        cursor.close() ;

        return audioObject ;
    }

    public static MixedObject[] getMixedObjectsForExclusive(SQLiteDatabase db,String start){
        int startTimeInt = 0 ;
        if(!VeamUtil.isEmpty(start)){
            startTimeInt = VeamUtil.parseInt(start) ;
        }
        MixedObject[] mixedObjects = VeamUtil.getMixedObjects(db, "0", "0") ;
        if(mixedObjects != null){
            List<MixedObject> list = new ArrayList<MixedObject>() ;
            int currentYear = 0 ;
            for(int index = 0 ; index < mixedObjects.length ; index++){
                MixedObject mixed = mixedObjects[index] ;
                int createdAtInt = VeamUtil.parseInt(mixed.getCreatedAt()) ;
                String kind = mixed.getKind() ;
                if(kind.equals(MixedObject.KIND_PERIODICAL_AUDIO) || kind.equals(MixedObject.KIND_PERIODICAL_VIDEO)){
                    if((startTimeInt == 0) || (createdAtInt < startTimeInt)){
                        continue ;
                    }
                }
                int mixedYear = VeamUtil.getYearFromIntString(mixed.getCreatedAt()) ;
                if(mixedYear != currentYear){
                    currentYear = mixedYear ;
                    list.add(new MixedObject("0",MixedObject.KIND_YEAR,"0","0","","","",mixed.getCreatedAt(),"","","","")) ;
                }
                list.add(mixed);
            }

            mixedObjects = (MixedObject[])list.toArray(new MixedObject[0]) ;
        }

        return mixedObjects ;
    }


        public static MixedObject[] getMixedObjects(SQLiteDatabase db,String mixedCategoryId,String mixedSubCategoryId){
       //VeamUtil.log("debug","VeamUtil.getMixedObjects") ;
        MixedObject[] mixedObjects = null ;

        String[] columns = new String[]{
                "id",
                "kind",
                "mixed_category_id",
                "mixed_sub_category_id",
                "title",
                "content_id",
                "thumbnail_url",
                "created_at",
                "display_type",
                "display_name",
                "display_order",
                "updatetimeid"
        } ;

        String where = "mixed_category_id=? and mixed_sub_category_id=?" ;
        String[] params = new String[]{mixedCategoryId,mixedSubCategoryId} ;
        Cursor cursor = db.query("mixed", columns, where, params, null, null, "display_order");
        cursor.moveToFirst();

        int count = cursor.getCount() ;
       //VeamUtil.log("debug","count="+count) ;
        if(count > 0){
            mixedObjects = new MixedObject[count] ;
            for(int index = 0 ; index < count ; index++){
                mixedObjects[index] = new MixedObject(
                        cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),
                        cursor.getString(4),cursor.getString(5),cursor.getString(6),cursor.getString(7),
                        cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11)) ;
                cursor.moveToNext() ;
            }
        }
        cursor.close() ;

        return mixedObjects ;
    }



    public static AlternativeImageObject[] getAlternativeImageObjects(SQLiteDatabase db){
        AlternativeImageObject[] alternativeImageObjects = null ;

        String[] columns = new String[]{
                "id",
                "file_name",
                "language",
                "url",
                "display_order",
                "updatetimeid",
        } ;

        Cursor cursor = db.query("alternative_image", columns, null, null, null, null, "display_order");
        cursor.moveToFirst();

        int count = cursor.getCount() ;
        if(count > 0){
            alternativeImageObjects = new AlternativeImageObject[count] ;
            for(int index = 0 ; index < count ; index++){
                alternativeImageObjects[index] = new AlternativeImageObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5)) ;
                cursor.moveToNext() ;
            }
        }
        cursor.close() ;

        return alternativeImageObjects ;
    }

    public static AlternativeImageObject[] getAlternativeImageObjects(SQLiteDatabase db,String fileName){
        AlternativeImageObject[] alternativeImageObjects = null ;

        String[] columns = new String[]{
                "id",
                "file_name",
                "language",
                "url",
                "display_order",
                "updatetimeid",
        } ;

        String where = "file_name=?" ;
        String[] params = new String[]{fileName} ;
        Cursor cursor = db.query("alternative_image", columns, where, params, null, null, "display_order");
        cursor.moveToFirst();

        int count = cursor.getCount() ;
        if(count > 0){
            alternativeImageObjects = new AlternativeImageObject[count] ;
            for(int index = 0 ; index < count ; index++){
                alternativeImageObjects[index] = new AlternativeImageObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),cursor.getString(5)) ;
                cursor.moveToNext() ;
            }
        }
        cursor.close() ;

        return alternativeImageObjects ;
    }

    public static AlternativeImageObject getAlternativeImageObject(SQLiteDatabase db,String fileName){
        AlternativeImageObject alternativeImageObject = null ;

        AlternativeImageObject[] alternativeImageObjects = VeamUtil.getAlternativeImageObjects(db, fileName) ;

        if(alternativeImageObjects != null) {
            int count = alternativeImageObjects.length;
            if (count > 0) {
                if(count == 1) {
                   //VeamUtil.log("debug","one alternative found") ;
                    alternativeImageObject = alternativeImageObjects[0];
                } else {
                   //VeamUtil.log("debug","several alternatives found : " + fileName) ;
                    String language = Locale.getDefault().getLanguage() ;
                    for(int index = 0 ; index < count ; index++){
                        AlternativeImageObject workObject = alternativeImageObjects[index] ;
                       //VeamUtil.log("debug","fileName="+ workObject.getFileName() + " language="+workObject.getLanguage()) ;
                        if((alternativeImageObject == null) || workObject.getLanguage().equals(language)){
                            alternativeImageObject = alternativeImageObjects[index];
                        }
                    }
                }
            }
        }

        return alternativeImageObject ;
    }



	public static YoutubeSubCategoryObject[] getYoutubeSubCategoryObjects(SQLiteDatabase db,String youtubeCategoryId){
		YoutubeSubCategoryObject[] youtubeSubCategoryObjects = null ;
		
    	String[] columns = new String[]{"id","youtube_category_id","name","display_order","updatetimeid"} ;

    	String where = "youtube_category_id=?" ;
    	String[] params = new String[]{youtubeCategoryId} ;
		Cursor cursor = db.query("youtube_sub_category", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();
		
		int count = cursor.getCount() ;
		if(count > 0){
			youtubeSubCategoryObjects = new YoutubeSubCategoryObject[count] ;
			for(int index = 0 ; index < count ; index++){
				youtubeSubCategoryObjects[index] = new YoutubeSubCategoryObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4)) ;
				cursor.moveToNext() ;
			}
    	}
		cursor.close() ;
		
		return youtubeSubCategoryObjects ;
	}
	
	public static YoutubeObject[] getYoutubeObjects(Context context,SQLiteDatabase db,String youtubeCategoryId,String youtubeSubCategoryId){
		YoutubeObject[] youtubeObjects = null ;
		
		if(youtubeCategoryId.equals(VeamUtil.SPECIAL_YOUTUBE_CATEGORY_ID_FAVORITES)){
			ArrayList<YoutubeObject> arrayList = new ArrayList<YoutubeObject>() ;
			String favoriteVideos = VeamUtil.getFavoriteVideos(context) ;
			String[] ids = favoriteVideos.split("_") ;
			int count = ids.length ;
			if(count > 0){
				for(int index = 0 ; index < count ; index++){
					String id = ids[index] ;
					if(!VeamUtil.isEmpty(id)){
						YoutubeObject youtubeObject = new YoutubeObject(db,id) ;
						if(id.equals(youtubeObject.getId())){
							arrayList.add(youtubeObject) ;
						}
					}
				}
				youtubeObjects = arrayList.toArray(new YoutubeObject[]{}) ;
			}
		} else {
	    	String[] columns = new String[]{"id","duration","title","description","youtube_category_id","youtube_sub_category_id","youtube_video_id","is_new","kind","link","display_order","updatetimeid"} ;
	    	
	    	String where = "youtube_category_id=? and youtube_sub_category_id=?" ;
	    	String[] params = new String[]{youtubeCategoryId,youtubeSubCategoryId} ;
			Cursor cursor = db.query("youtube", columns, where, params, null, null, "display_order");
			cursor.moveToFirst();
			
			int count = cursor.getCount() ;
			if(count > 0){
				youtubeObjects = new YoutubeObject[count] ;
				for(int index = 0 ; index < count ; index++){
					youtubeObjects[index] = new YoutubeObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),cursor.getString(4),
							cursor.getString(5),cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9),cursor.getString(10),cursor.getString(11)) ;
					cursor.moveToNext() ;
				}
	    	}
			cursor.close() ;
		}
		
		return youtubeObjects ;
	}
	
    private static final int BUFFER_SIZE = 10240;
    public static boolean downloadFile(String urlString,String outputPath){
    	boolean retBool = false ;
		try {
	        File file = new File(outputPath);
	        BufferedOutputStream out;
			out = new BufferedOutputStream(new FileOutputStream(file, false), BUFFER_SIZE);
			
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
			BufferedInputStream in = new BufferedInputStream(is, BUFFER_SIZE);  
      
			byte buf[] = new byte[BUFFER_SIZE];  
	        int size = -1;  
	        while((size = in.read(buf)) != -1) {
	        	// System.out.println("downloading") ;
	        	out.write(buf, 0, size);  
	        }
	        // http から https にリダイレクトされているときはファイルが取得できないのでリトライ処理を書く必要がある
	        out.flush();  
	        out.close();  
	        in.close();
	        retBool = true ;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}  
		return retBool ;
    }

	 public static String getCachedFileName(String urlString)
	 {
		 
		 MessageDigest messageDigest = null ;
		 try {
			 messageDigest = MessageDigest.getInstance("SHA-1");
		 } catch (NoSuchAlgorithmException e) {
			 e.printStackTrace();
		 }
		 byte[] digest = messageDigest.digest(urlString.getBytes()) ;
		 String sha1String = asHex(digest) ;
		 String fileName = String.format("cache_%s", sha1String) ;
		 //System.out.println("Cache file name : "+fileName) ;
		 return fileName ;
	 }
	 
	 public static String sha1(String string)
	 {
		 MessageDigest messageDigest = null ;
		 try {
			 messageDigest = MessageDigest.getInstance("SHA-1");
		 } catch (NoSuchAlgorithmException e) {
			 e.printStackTrace();
		 }
		 byte[] digest = messageDigest.digest(string.getBytes()) ;
		 String sha1String = asHex(digest) ;
		 return sha1String ;
	 }
	 
	 
	 public static Bitmap getCachedFileBitmap(Context context,String urlString,boolean downloadIfNot){
		 Bitmap retBitmap = null ;
		 FileInputStream inputStream = VeamUtil.getCachedFileInputStream(context, urlString, downloadIfNot) ;
		 if(inputStream != null){
			 retBitmap = BitmapFactory.decodeStream(inputStream) ;
			 if(retBitmap == null){
				 // 削除してリトライ
				 try {
					inputStream.close() ;
				} catch (IOException e) {
					e.printStackTrace();
				}
				 inputStream = null ;
				 context.deleteFile(VeamUtil.getCachedFileName(urlString)) ;
				 inputStream = VeamUtil.getCachedFileInputStream(context, urlString, downloadIfNot) ;
				 if(inputStream != null){
					 retBitmap = BitmapFactory.decodeStream(inputStream) ;
					 try {
						inputStream.close() ;
					} catch (IOException e) {
						e.printStackTrace();
					}
					 inputStream = null ;
				 }
			 } else {
				 try {
					inputStream.close() ;
				} catch (IOException e) {
					e.printStackTrace();
				}
				 inputStream = null ;
			 }
		 }
		 
		 return retBitmap ;
	 }

	 public static FileInputStream getCachedFileInputStream(Context context,String urlString,boolean downloadIfNot)
	 {
	//VeamUtil.log("debug","getCachedFileInputStream:" + urlString) ;
         FileInputStream retValue = null ;
         FileInputStream inputStream = null ;
		 String fileName = getCachedFileName(urlString) ;
		 try {
			inputStream = context.openFileInput(fileName) ;
		//VeamUtil.log("debug",urlString + " : " + inputStream.available()) ;
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
			e.printStackTrace();
		}

         try {
             if((inputStream == null) || (inputStream.available() == 0)) {
                 if (downloadIfNot) {
                    //VeamUtil.log("debug", "download " + urlString);
                     // なければダウンロード
                     try {
                         FileOutputStream outputStream = context.openFileOutput(fileName, Activity.MODE_PRIVATE);
                         BufferedOutputStream bufferedOutputStream;
                         bufferedOutputStream = new BufferedOutputStream(outputStream, BUFFER_SIZE);

                         // HTTP経由でアクセスし、InputStreamを取得する
                         URL url = new URL(urlString);
                         //URL url = new URL("https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c15.0.50.50/p50x50/10354686_10150004552801856_220367501106153455_n.jpg?oh=df51bdad5f6befdfc3639f16c16c3475&oe=54E5752F&__gda__=1424631769_4444d9c7e49f8c304bcb7cb105242827") ;

						 HttpURLConnection connection = (HttpURLConnection)url.openConnection();
						 connection.setInstanceFollowRedirects(true);
						 connection.connect();
						 int responseCode = connection.getResponseCode();
						 int retry = 0 ;
						 while((responseCode == 302) && (retry <= 10)){
							 String location = connection.getHeaderField("Location");
							 urlString = location ;
							 url = new URL(urlString);
							 connection = (HttpURLConnection)url.openConnection();
							 connection.setInstanceFollowRedirects(true);
							 connection.connect();
							 responseCode = connection.getResponseCode();
							 retry++ ;
						 }
						 InputStream is = connection.getInputStream();
						 BufferedInputStream in = new BufferedInputStream(is, BUFFER_SIZE);

						 byte buf[] = new byte[BUFFER_SIZE];
						 int totalBytes = 0;
						 int size = -1;
						 //VeamUtil.log("debug","before while ") ;
						 while ((size = in.read(buf)) != -1) {
							 bufferedOutputStream.write(buf, 0, size);
							 totalBytes += size;
						 }
						 //VeamUtil.log("debug","after while " + connection.getURL()) ;
						 String finalUrlString = connection.getURL().toString();
						 bufferedOutputStream.flush();
						 bufferedOutputStream.close();
						 in.close();

						 if (totalBytes == 0) {
							 if (!urlString.equals(finalUrlString)) {
								 // リダイレクトされてファイルが0なら最終的なURLで再挑戦（httpからhttpsにリダイレクトされるとファイルが取得できない？）
								 outputStream = context.openFileOutput(fileName, Activity.MODE_PRIVATE);
								 bufferedOutputStream = new BufferedOutputStream(outputStream, BUFFER_SIZE);
								 url = new URL(finalUrlString);
								 connection = (HttpURLConnection)url.openConnection();
								 is = connection.getInputStream();
								 in = new BufferedInputStream(is, BUFFER_SIZE);

								 size = -1;
								 //VeamUtil.log("debug","before while (retry)") ;
								 while ((size = in.read(buf)) != -1) {
									 bufferedOutputStream.write(buf, 0, size);
									 //VeamUtil.log("debug","downloading (retry)") ;
								 }
								 //VeamUtil.log("debug","after while (retry)" + connection.getURL()) ;
								 bufferedOutputStream.flush();
								 bufferedOutputStream.close();
								 in.close();
							 }
						 }

                         inputStream = context.openFileInput(fileName);
                     } catch (FileNotFoundException e2) {
                         e2.printStackTrace();
                     } catch (IOException e2) {
                         e2.printStackTrace();
                     }
                 }
             }
         } catch (IOException e) {
             e.printStackTrace();
         }

         try {
             if((inputStream != null) && (inputStream.available() == 0)){
                 inputStream = null ;
             } else {
                 retValue = inputStream ;
             }
         } catch (IOException e) {
             e.printStackTrace();
         }

         return retValue ;
	 }
	 

	    /**
		 * バイト配列を16進数の文字列に変換する。
		 * 
		 * @param bytes バイト配列
		 * @return 16進数の文字列
		 */
		public static String asHex(byte bytes[]) {
			// バイト配列の２倍の長さの文字列バッファを生成。
			StringBuffer strbuf = new StringBuffer(bytes.length * 2);

			// バイト配列の要素数分、処理を繰り返す。
			for (int index = 0; index < bytes.length; index++) {
				// バイト値を自然数に変換。
				int bt = bytes[index] & 0xff;

				// バイト値が0x10以下か判定。
				if (bt < 0x10) {
					// 0x10以下の場合、文字列バッファに0を追加。
					strbuf.append("0");
				}

				// バイト値を16進数の文字列に変換して、文字列バッファに追加。
				strbuf.append(Integer.toHexString(bt));
			}

			/// 16進数の文字列を返す。
			return strbuf.toString();
		}
		
		
	public static Bitmap getCachedFileBitmapWithWidth(Context context,String urlString,int width,int sampleLevel,boolean downloadIfNot) {
		//VeamUtil.log("debug","getCachedFileBitmapWithWidth:"+urlString) ;
		Bitmap retBitmap = null ;
		FileInputStream inputStream = VeamUtil.getCachedFileInputStream(context, urlString, downloadIfNot) ;
		if(inputStream != null){
			BitmapFactory.Options options = new BitmapFactory.Options() ;
			options.inJustDecodeBounds = true ;
			BitmapFactory.decodeStream(inputStream,null,options) ;
			try {
				inputStream.close() ;
			} catch (IOException e2) {
				e2.printStackTrace();
			}
			inputStream = null ;
			  
			int imageHeight = options.outHeight ;  
			int imageWidth = options.outWidth ;
			options.inSampleSize  = imageWidth / width ;
			if(options.inSampleSize < 1){
				options.inSampleSize = 1 ;
			}
			options.inSampleSize *= sampleLevel ; 
			options.inJustDecodeBounds = false ;
			options.inPurgeable = true ;
			
			//VeamUtil.log("debug","displayWidth:" + width + " imageWidth:" + imageWidth + " imageHeight:" + imageHeight + " inSampleSize:" + options.inSampleSize) ;
			int retryCount = 0 ; 
			while((retBitmap == null) && (retryCount < 1)){
				try {
					inputStream = VeamUtil.getCachedFileInputStream(context, urlString, false) ;
					if(inputStream != null){
						retBitmap = BitmapFactory.decodeStream(inputStream,null,options) ;
						if(retBitmap == null){
							// 削除してリトライ
							try {
								inputStream.close() ;
							} catch (IOException e) {
								e.printStackTrace();
							}
							inputStream = null ;
							context.deleteFile(VeamUtil.getCachedFileName(urlString)) ;
							inputStream = VeamUtil.getCachedFileInputStream(context, urlString, downloadIfNot) ;
							if(inputStream != null){
								retBitmap = BitmapFactory.decodeStream(inputStream) ;
							}
						}
						try {
							if(inputStream != null){
								inputStream.close() ;
							}
						} catch (IOException e) {
							e.printStackTrace();
						}
						inputStream = null ;
					}
				} catch (OutOfMemoryError e) {
				//VeamUtil.log("debug","OutOfMemory") ;
					try {
						Thread.sleep(500) ;
					} catch (InterruptedException e1) {
						e1.printStackTrace();
					}
				}
				retryCount++ ;
			}
		}
		return retBitmap ;
	}
	
	public static String getYoutubeImageUrl(Context context,String youtubeVideoId)
	{
	    // @"http://img.youtube.com/vi/%@/hqdefault.jpg",youtubeId]
	    
	    String format = VeamUtil.getPreferenceString(context,"youtube_image_url_format_a") ;
	    if((format == null) || format.equals("")){
	        format = "http://img.youtube.com/vi/%s/hqdefault.jpg" ;
	    }
	    
	    String urlString = String.format(format, youtubeVideoId) ;
	    
	  //VeamUtil.log("debug","youtube image url : " + urlString) ;
	    return urlString ;
	}


    public static String getPdfViewerUrl(Context context,String pdfUrl)
    {
       //VeamUtil.log("debug","getPdfViewerUrl") ;

        String format = VeamUtil.getPreferenceString(context,"pdf_viewer_url_format") ;
        if(VeamUtil.isEmpty(format)){
            format = "http://docs.google.com/gview?embedded=true&url=%s" ;
        } else {
           //VeamUtil.log("debug","format found="+format) ;
        }

		String encodedPdfUrl = "";
		try {
			encodedPdfUrl = URLEncoder.encode(pdfUrl, "utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		//VeamUtil.log("debug","pdf encoded url : " + encodedPdfUrl) ;
		String urlString = String.format(format,encodedPdfUrl) ;

        return urlString ;
    }


    public static final String printableReg = "<a href=\"printable://([0-9]+)\" class=\"descLink:\">Printable</a>" ;
	public static final Pattern convPrintableLinkPtn = Pattern.compile(printableReg,Pattern.CASE_INSENSITIVE) ;
	
	public static final Pattern convURLLinkPtn = Pattern.compile("(http://|https://){1}[\\w\\.\\-/:\\#\\?\\=\\&\\;\\%\\~\\+]+",Pattern.CASE_INSENSITIVE) ;
	public static String convertUrlLink(String string) 
	{
	    Matcher matcher = convURLLinkPtn.matcher(string);
	    return matcher.replaceAll("<a href=\"$0\">$0</a>") ;
	}
	
	public static void setRegistrationId(Context context,String registrationId){
		VeamUtil.setPreferenceString(context, VeamUtil.PREFERENCE_KEY_REGISTRATION_ID, registrationId) ;
	}

	public static String getRegistrationId(Context context){
		return VeamUtil.getPreferenceString(context, VeamUtil.PREFERENCE_KEY_REGISTRATION_ID) ;
	}


	
	public static void logoutSocial(Context context){
		VeamUtil.setPreferenceString(context, VeamUtil.SOCIAL_USER_ID, "") ;
	}

	public static boolean isLogin(Context context){
		String socialUserId = VeamUtil.getPreferenceString(context, VeamUtil.SOCIAL_USER_ID) ;
		boolean isLogin = false ;
		if((socialUserId != null) && !socialUserId.equals("")){
			//VeamUtil.log("debug","social user id : "+socialUserId) ;
			isLogin = true ;
		}
		return isLogin ;
	}

	public static String getSocialUserId(Context context){
		return VeamUtil.getPreferenceString(context, VeamUtil.SOCIAL_USER_ID) ;
	}

	public static boolean isFacebook(Context context){
		boolean isFacebook = false ;
		String kind = VeamUtil.getPreferenceString(context, VeamUtil.SOCIAL_USER_KIND) ;
		if((kind != null) && !kind.equals("")){
			if(kind.equals(VeamUtil.SOCIAL_USER_KIND_FACEBOOK)){
				isFacebook = true ;
			}
		}
		return isFacebook ;
	}

	public static boolean isTwitter(Context context){
		boolean isTwitter = false ;
		String kind = VeamUtil.getPreferenceString(context, VeamUtil.SOCIAL_USER_KIND) ;
		if((kind != null) && !kind.equals("")){
			if(kind.equals(VeamUtil.SOCIAL_USER_KIND_TWITTER)){
				isTwitter = true ;
			}
		}
		return isTwitter ;
	}
	
    public static String getUniqueId(Context context){
    	if(mUniqueId != null){
    		return mUniqueId ; 
    	}
        final TelephonyManager telephonyManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
        final String deviceId;
        final String androidId;
        deviceId = "" + telephonyManager.getDeviceId();
        androidId = "" + android.provider.Settings.Secure.getString(context.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);

        String planeString = deviceId + androidId ;
        String uniqueId = "" ;
		MessageDigest md;
		try {
			md = MessageDigest.getInstance("SHA-1");
			md.update(planeString.getBytes());
			uniqueId = asHex(md.digest()) ;
		} catch (NoSuchAlgorithmException e) {
			// SHA-1できない場合はhashCodeする
			uniqueId = String.format("%08x",deviceId.hashCode()) + String.format("%08x",androidId.hashCode()) ;
		}
		
		//System.out.println("uniqueID=" + uniqueId) ;
		
		mUniqueId = uniqueId ;

        return uniqueId ;
    }
    
    public static boolean isEmpty(String string){
    	return (string == null) || string.equals("") ;
    }
    
    public static String getSocialUserName(Context context){
    	String socialUserName = "" ;
    	String socialUserKind = VeamUtil.getPreferenceString(context, VeamUtil.SOCIAL_USER_KIND) ;
    	if(!VeamUtil.isEmpty(socialUserKind)){
    		if(socialUserKind.equals(VeamUtil.SOCIAL_USER_KIND_FACEBOOK)){
    			socialUserName = VeamUtil.getPreferenceString(context, VeamUtil.FACEBOOK_USER_NAME) ;
    		} else if(socialUserKind.equals(VeamUtil.SOCIAL_USER_KIND_TWITTER)){
    			socialUserName = VeamUtil.getPreferenceString(context, VeamUtil.TWITTER_USER) ;
    		}
    	}
    	return socialUserName ;
    }


    public static void showMessage(Context context,String message){
    	Toast.makeText(context,message,Toast.LENGTH_LONG).show() ;
    }

    public static int getColorFromArgbString(String argbString){
    	int retValue = Color.TRANSPARENT ;
    	//VeamUtil.log("debug","color from:"+argbString) ;
    	if(argbString.length() == 8){
    		try {
    			int a = Integer.decode(String.format("0x%s", argbString.subSequence(0, 2))) ;
    			int r = Integer.decode(String.format("0x%s", argbString.subSequence(2, 4))) ;
    			int g = Integer.decode(String.format("0x%s", argbString.subSequence(4, 6))) ;
    			int b = Integer.decode(String.format("0x%s", argbString.subSequence(6, 8))) ;
    			//VeamUtil.log("debug","a:"+a) ;
    			retValue = Color.argb(a,r,g,b) ;
    		} catch(Exception e){
    		}
    	}
    	
    	return retValue ;
    }
    
    
    public static int VEAM_SHORTHAND_MONTH_FORMAT_3CHAR 	= 1 ;
    public static int VEAM_SHORTHAND_MONTH_FORMAT_MAX5 		= 2 ;
    public static int VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL 	= 3 ;
    public static String getShorthandForMonth(int month,int format){
        String retValue = "" ;
        if(format == VEAM_SHORTHAND_MONTH_FORMAT_3CHAR){
            switch (month) {
                case 1:
                    retValue = "Jan" ;
                    break;
                case 2:
                    retValue = "Feb" ;
                    break;
                case 3:
                    retValue = "Mar" ;
                    break;
                case 4:
                    retValue = "Apr" ;
                    break;
                case 5:
                    retValue = "May" ;
                    break;
                case 6:
                    retValue = "Jun" ;
                    break;
                case 7:
                    retValue = "Jul" ;
                    break;
                case 8:
                    retValue = "Aug" ;
                    break;
                case 9:
                    retValue = "Sep" ;
                    break;
                case 10:
                    retValue = "Oct" ;
                    break;
                case 11:
                    retValue = "Nov" ;
                    break;
                case 12:
                    retValue = "Dec" ;
                    break;
                default:
                    break;
            }
        } else if(format == VEAM_SHORTHAND_MONTH_FORMAT_MAX5){
            switch (month) {
                case 1:
                    retValue = "JAN" ;
                    break;
                case 2:
                    retValue = "FEB" ;
                    break;
                case 3:
                    retValue = "MARCH" ;
                    break;
                case 4:
                    retValue = "APRIL" ;
                    break;
                case 5:
                    retValue = "MAY" ;
                    break;
                case 6:
                    retValue = "JUNE" ;
                    break;
                case 7:
                    retValue = "JULY" ;
                    break;
                case 8:
                    retValue = "AUG" ;
                    break;
                case 9:
                    retValue = "SEPT" ;
                    break;
                case 10:
                    retValue = "OCT" ;
                    break;
                case 11:
                    retValue = "NOV" ;
                    break;
                case 12:
                    retValue = "DEC" ;
                    break;
                default:
                    break;
            }
        }
        return retValue ;
    }

    public static String getShorthandForWeekday(int weekday ,int format){
        String retValue = "" ;
        if(format == VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL){
            switch (weekday) {
                case 1:
                    retValue = "Sunday" ;
                    break;
                case 2:
                    retValue = "Monday" ;
                    break;
                case 3:
                    retValue = "Tuesday" ;
                    break;
                case 4:
                    retValue = "Wednesday" ;
                    break;
                case 5:
                    retValue = "Thursday" ;
                    break;
                case 6:
                    retValue = "Friday" ;
                    break;
                case 7:
                    retValue = "Saturday" ;
                    break;
                default:
                    break;
            }
        }
        return retValue ;
    }

    public static String getNameForMonth(int month){
        String retValue = "" ;
        switch (month) {
            case 1:
                retValue = "January" ;
                break;
            case 2:
                retValue = "February" ;
                break;
            case 3:
                retValue = "March" ;
                break;
            case 4:
                retValue = "April" ;
                break;
            case 5:
                retValue = "May" ;
                break;
            case 6:
                retValue = "June" ;
                break;
            case 7:
                retValue = "July" ;
                break;
            case 8:
                retValue = "August" ;
                break;
            case 9:
                retValue = "September" ;
                break;
            case 10:
                retValue = "October" ;
                break;
            case 11:
                retValue = "November" ;
                break;
            case 12:
                retValue = "December" ;
                break;
            default:
                break;
        }
        return retValue ;
    }
    
    
    private static final String USERDEFAULT_KEY_WORKOUT_DONE_FORMAT    = "D%02d%02d%02d%d" ;
    private static final String USERDEFAULT_KEY_FIXED_CALENDAR_WORKOUT_DONE_FORMAT    = "D%s_%02d%02d%02d%d" ;
    public static String getFixedCalendarWorkoutDoneKey(int year ,int month ,int day,int index,String fixedCalendarId){
        String key = "" ;
    	if(VeamUtil.isEmpty(fixedCalendarId) || fixedCalendarId.equals("1")){
            key = String.format(USERDEFAULT_KEY_WORKOUT_DONE_FORMAT,(year%100),month,day,index) ;
    	} else {
            key = String.format(USERDEFAULT_KEY_FIXED_CALENDAR_WORKOUT_DONE_FORMAT,fixedCalendarId,(year%100),month,day,index) ;
    	}
    	return key ;
    }
    
    public static void setWorkoutDone(Context context,int year ,int month ,int day,int index,boolean done,String fixedCalendarId){
        String key = VeamUtil.getFixedCalendarWorkoutDoneKey(year, month, day, index, fixedCalendarId) ;
        VeamUtil.setPreferenceString(context, key, done?"y":"n") ;
    }

    public static boolean getWorkoutDone(Context context,int year,int month ,int day,int index,String fixedCalendarId){
    	boolean retValue = false ;
        String key = VeamUtil.getFixedCalendarWorkoutDoneKey(year, month, day, index, fixedCalendarId) ;
        String doneString = VeamUtil.getPreferenceString(context, key) ;
        if(!VeamUtil.isEmpty(doneString) && doneString.equals("y")){
        	retValue = true ;
        }
        return retValue ;
    }
    

    public static WeekdayTextObject getWeekdayTextObject(SQLiteDatabase db,int year,int month,int day,int weekday){
    	String[] columns = new String[]{
    			"id",
    			"start",
    			"end",
    			"weekday",
    			"action",
    			"title",
    			"description",
    			"link_url",
    			"display_order",
    			"updatetimeid",
    			} ;
    	
    	String dateString = String.format("%04d%02d%02d", year,month,day) ;
    	String weekdayString = String.format("%d", weekday) ;
    	if((year == 0) || (year == 2000)){
        	dateString = String.format("%d", day) ;
        	weekdayString = "0" ;
    	}
    	
    	//VeamUtil.log("debug","get weekday : " + dateString + " " + weekdayString) ;

    	String where = "start<=? and end>=? and weekday=?" ;
    	String[] params = new String[]{dateString,dateString,weekdayString} ;

		Cursor cursor = db.query("weekday_text", columns, where, params, null, null, "display_order");
		cursor.moveToFirst();
		
		WeekdayTextObject weekdayTextObject = null ;
		int count = cursor.getCount() ;
		//VeamUtil.log("debug","get weekday : " + dateString + " " + weekdayString + " result:"+count) ;
		if(count > 0){
			weekdayTextObject = new WeekdayTextObject(cursor.getString(0),cursor.getString(1),cursor.getString(2),cursor.getString(3),
			cursor.getString(4),cursor.getString(5),cursor.getString(6),cursor.getString(7),cursor.getString(8),cursor.getString(9)) ;
    	}
		cursor.close() ;
		
		return weekdayTextObject ;
    }
    
    public static void setSubscriptionIsBought(Context context,boolean isBought){
       //VeamUtil.log("debug","VeamUtil.setSubscriptionIsBought " + isBought) ;
    	VeamUtil.setPreferenceString(context, VeamUtil.PREFERENCE_KEY_SUBSCRIPTION_IS_BOUGHT, isBought?"y":"n") ;
    }

    public static boolean getSubscriptionIsBought(Context context){
    	boolean retValue = false ;
		if(VeamUtil.isSubscriptionFree(context)){
			//VeamUtil.log("debug","VeamUtil.getSubscriptionIsBought it's free") ;
			retValue = true ;
		} else {
			String value = VeamUtil.getPreferenceString(context, VeamUtil.PREFERENCE_KEY_SUBSCRIPTION_IS_BOUGHT);
			if (!VeamUtil.isEmpty(value) && value.equals("y")) {
				retValue = true;
			}
		}
       	//VeamUtil.log("debug","VeamUtil.getSubscriptionIsBought " + retValue) ;
    	return retValue ;

    }
    
    public static void setFixedCalendarIsBought(Context context,boolean isBought,String fixedCalendarId){
    	String key = "" ;
    	if(VeamUtil.isEmpty(fixedCalendarId) || fixedCalendarId.equals("1")){
    		key = VeamUtil.PREFERENCE_KEY_BEGINNERS_IS_BOUGHT ;
    	} else {
    		key = String.format(PREFERENCE_KEY_FIXED_CALENDAR_IS_BOUGHT_FORMAT,fixedCalendarId) ;
    	}
		VeamUtil.setPreferenceString(context, key, isBought?"y":"n") ;
    }

    public static boolean getFixedCalendarIsBought(Context context,String fixedCalendarId){
    	boolean retValue = false ;
    	String key = "" ;
    	
    	if(VeamUtil.isEmpty(fixedCalendarId) || fixedCalendarId.equals("1")){
    		key = VeamUtil.PREFERENCE_KEY_BEGINNERS_IS_BOUGHT ;
    	} else {
    		key = String.format(PREFERENCE_KEY_FIXED_CALENDAR_IS_BOUGHT_FORMAT,fixedCalendarId) ;
    	}

    	String value = VeamUtil.getPreferenceString(context, key) ;
    	if(!VeamUtil.isEmpty(value) && value.equals("y")){
    		retValue = true ;
    	}
    	return retValue ;

    }
    
    public static boolean previewExists(Context context,String contentId)
    {
        String fileName = String.format("p%s.mp4",contentId) ;

        AssetFileDescriptor afd = null ;
        try {
        	afd = context.getAssets().openFd(fileName) ;
        } catch (Exception e) {
		}
        if(afd != null){
       		return true ;
        }

        if(VeamUtil.fileExistsAtVeamDirectory(context,fileName)){
            return true ;
        }
        
        return false ;
    }

    public static boolean fileExistsAtVeamDirectory(Context context,String fileName)
    {
    	String filePath = VeamUtil.getVeamPath(context) + "/" + fileName ;
       //VeamUtil.log("debug","VeamUtil.fileExistsAtVeamDirectory " + filePath) ;
    	File file = new File(filePath) ;
    	if(file.exists()){
   			return true ;
    	}
        return false ;
    }

	public static String smVeamPath = null ;
	public static String getVeamPath(Context context){
		if(smVeamPath != null){
			return smVeamPath ;
		}
		
		File externalDir = Environment.getExternalStorageDirectory() ;
		smVeamPath = externalDir + "/VEAM/" + context.getPackageName() ;
		File outputDir = new File(smVeamPath) ;
		if(!outputDir.exists()){
			if(!outputDir.mkdirs()){
				//System.out.println("mkdirs failed") ;
			}
		}

		return smVeamPath ;
	}

	public static String getVeamFilePath(Context context,String fileName){
		return VeamUtil.getVeamPath(context) + "/" + fileName ;
	}

    public static boolean fileExistsAtVeamDirectory(Context context,String fileName,int size)
    {
    	String filePath = VeamUtil.getVeamPath(context) + "/" + fileName ;
    	File file = new File(filePath) ;
    	if(file.exists()){
    		if(size == file.length()){
    			//System.out.println(fileName + " exists at AS") ;
    			return true ;
    		}
    	}
        return false ;
    }

	 public static void moveVeamFile(Context context,String fromFileName,String toFileName){
		 File file = new File(VeamUtil.getVeamFilePath(context, fromFileName)) ;
		 File toFile = new File(VeamUtil.getVeamFilePath(context, toFileName)) ;
		 file.renameTo(toFile) ;
	 }
	 
	 public static String getCalendarName(Context context,int year,int month,int index){
		 /*
		 <calendar_name_1_201310 value="ABTOBERFEST Workout Calendar" />
		 <calendar_name_1_DEFAULT value="Workout Calendar" />
		 <calendar_name_1_201309 value="SWEATEMBER Workout Calendar" />
		 <calendar_name_2_DEFAULT value="Beginners Workout Calendar" />
		 <calendar_name_2_201309 value="Beginners Workout Calendar" />
		 */
		 String retValue = null ;
		 retValue = VeamUtil.getPreferenceString(context, String.format("calendar_name_%d_%04d%02d",index,year,month)) ;
		 if(VeamUtil.isEmpty(retValue)){
			 retValue = VeamUtil.getPreferenceString(context, String.format("calendar_name_%d_DEFAULT",index)) ;
			 if(VeamUtil.isEmpty(retValue)){
				 if(index == 1){
					 retValue = "Workout Calendar" ;
				 } else if(index == 2){
					 retValue = "Beginners Workout Calendar" ;
				 }
			 }
		 }
		 return retValue ;
	 }
	 
	 
	 
	 
	 private static final String USERDEFAULT_KEY_CALENDAR_END_MONTH    = "CALENDAR_END_MONTH" ;
	 public static void setCalendarEnd(Context context,int year,int month){
		//VeamUtil.log("debug","calendar end:"+year + "/"+month) ;
	     Integer storeValue = year % 100 ;
	     storeValue *= 100 ;
	     storeValue += month ;
	     
	     VeamUtil.setPreferenceString(context, USERDEFAULT_KEY_CALENDAR_END_MONTH, String.format("%d", storeValue)) ;
	 }

	 public static Integer getCalendarEndYear(Context context){
		 String endMonthString = VeamUtil.getPreferenceString(context, USERDEFAULT_KEY_CALENDAR_END_MONTH) ;
	     Integer storeValue = 0 ;
	     if(!VeamUtil.isEmpty(endMonthString)){
	    	 storeValue = Integer.parseInt(endMonthString) ;
	     }
	     Integer year = storeValue / 100 ;
	     return year + 2000 ;
	 }

	 public static Integer getCalendarEndMonth(Context context){
		 String endMonthString = VeamUtil.getPreferenceString(context, USERDEFAULT_KEY_CALENDAR_END_MONTH) ;
	     Integer storeValue = 0 ;
	     if(!VeamUtil.isEmpty(endMonthString)){
	    	 storeValue = Integer.parseInt(endMonthString) ;
	     }
	     Integer month = storeValue % 100 ;
	     return month ;
	 }

	 private static final String USERDEFAULT_KEY_CALENDAR_START_MONTH    = "CALENDAR_START_MONTH" ;
	 public static void setCalendarStart(Context context,int year,int month){
		//VeamUtil.log("debug","calendar start:"+year + "/"+month) ;
	     Integer storeValue = year % 100 ;
	     storeValue *= 100 ;
	     storeValue += month ;
	     
	     VeamUtil.setPreferenceString(context, USERDEFAULT_KEY_CALENDAR_START_MONTH, String.format("%d", storeValue)) ;
	 }

	 public static Integer getCalendarStartYear(Context context){
		 String startMonthString = VeamUtil.getPreferenceString(context, USERDEFAULT_KEY_CALENDAR_START_MONTH) ;
	     Integer storeValue = 0 ;
	     if(!VeamUtil.isEmpty(startMonthString)){
	    	 storeValue = Integer.parseInt(startMonthString) ;
	     }
	     Integer year = storeValue / 100 ;
	     return year + 2000 ;
	 }

	 public static Integer getCalendarStartMonth(Context context){
		 String startMonthString = VeamUtil.getPreferenceString(context, USERDEFAULT_KEY_CALENDAR_START_MONTH) ;
	     Integer storeValue = 0 ;
	     if(!VeamUtil.isEmpty(startMonthString)){
	    	 storeValue = Integer.parseInt(startMonthString) ;
	     }
	     Integer month = storeValue % 100 ;
	     return month ;
	 }


	 private static final String IS_GCM_REGISTER_DONE_KEY = "IS_GCM_REGISTER_DONE" ;  
	 public static boolean getIsGcmRegisterDone(Context context){
		 boolean retBool = false ;
		 String isDoneString = VeamUtil.getPreferenceString(context,IS_GCM_REGISTER_DONE_KEY) ;
		 if((isDoneString != null) && isDoneString.equals("1")){
			 retBool = true ;
		 }
		 return retBool ;
	 }

	 public static void setIsGcmRegisterDone(Context context,boolean isDone){
		 String isDoneString = "0" ;
		 if(isDone){
			 isDoneString = "1" ;
		 }
		 VeamUtil.setPreferenceString(context, IS_GCM_REGISTER_DONE_KEY,isDoneString) ;
	 }

	 
	 
	 
	 private final static String PREFERENCE_KEY_FAVORITE_PICTURES = "FAVORITE_PICTURES" ;
	 
	 public static void setFavoritePictures(Context context,String pictures){
		 VeamUtil.setPreferenceString(context, PREFERENCE_KEY_FAVORITE_PICTURES, pictures) ;
	 }

	 public static String getFavoritePictures(Context context){
		 return VeamUtil.getPreferenceString(context, PREFERENCE_KEY_FAVORITE_PICTURES) ;
	 }

	 public static boolean isFavoritePicture(Context context,String pictureId){
	     boolean retValue = false ;
	     String favoritesString = VeamUtil.getFavoritePictures(context) ;
	     String[] favoriteIds = favoritesString.split("_") ;
	     int count = favoriteIds.length ;
	     for(int index = 0 ; index < count ; index++){
	         String workId = favoriteIds[index] ;
	         if((workId != null) && workId.equals(pictureId)){
	             retValue = true ;
	             break ;
	         }
	     }
	     
	   //VeamUtil.log("debug","isfavorite picture "+favoritesString+" "+pictureId+" "+retValue) ;
	     return retValue ;
	 }

	 public static void addFavoritePicture(Context context,String pictureId){
	     //NSLog(@"addFavoritePicture") ;
	     if(!VeamUtil.isFavoritePicture(context, pictureId)){
	         String favoritesString = VeamUtil.getFavoritePictures(context) ;
	         String newFavoritesString = null ;
	         if(VeamUtil.isEmpty(favoritesString)){
	             newFavoritesString = pictureId ;
	         } else {
	             newFavoritesString = String.format("%s_%s",pictureId,favoritesString) ;
	         }
	         //NSLog(@"new : %@",newFavoritesString) ;
	         VeamUtil.setFavoritePictures(context,newFavoritesString) ;
	     }
	 }

	 public static void deleteFavoritePicture(Context context,String pictureId){
	     //NSLog(@"deleteFavoritePicture") ;
	     String favoritesString = VeamUtil.getFavoritePictures(context) ;
	     String[] favoriteIds = favoritesString.split("_") ;
	     String newFavoritesString = null ;
	     int count = favoriteIds.length ;
	     for(int index = 0 ; index < count ; index++){
	         String workId = favoriteIds[index] ;
	         if(workId != null){
	             if(!workId.equals(pictureId)){
	                 if(newFavoritesString == null){
	                     newFavoritesString = workId ;
	                 } else {
	                     newFavoritesString = String.format("%s_%s",newFavoritesString,workId) ;
	                 }
	             }
	         }
	     }
	     //NSLog(@"new : %@",newFavoritesString) ;
	     VeamUtil.setFavoritePictures(context,newFavoritesString) ;
	 }
	 

	 
	 private final static String PREFERENCE_KEY_FAVORITE_VIDEOS = "FAVORITE_VIDEOS" ;
	 
	 public static void setFavoriteVideos(Context context,String videos){
		 VeamUtil.setPreferenceString(context, PREFERENCE_KEY_FAVORITE_VIDEOS, videos) ;
	 }

	 public static String getFavoriteVideos(Context context){
		 return VeamUtil.getPreferenceString(context, PREFERENCE_KEY_FAVORITE_VIDEOS) ;
	 }

	 public static boolean isFavoriteVideo(Context context,String videoId){
	     boolean retValue = false ;
	     String favoritesString = VeamUtil.getFavoriteVideos(context) ;
	     String[] favoriteIds = favoritesString.split("_") ;
	     int count = favoriteIds.length ;
	     for(int index = 0 ; index < count ; index++){
	         String workId = favoriteIds[index] ;
	         if((workId != null) && workId.equals(videoId)){
	             retValue = true ;
	             break ;
	         }
	     }
	     
	   //VeamUtil.log("debug","isfavorite "+favoritesString+" "+videoId+" "+retValue) ;
	     return retValue ;
	 }

	 public static void addFavoriteVideo(Context context,String videoId){
	     //NSLog(@"addFavoriteVideo") ;
	     if(!VeamUtil.isFavoriteVideo(context, videoId)){
	         String favoritesString = VeamUtil.getFavoriteVideos(context) ;
	         String newFavoritesString = null ;
	         if(VeamUtil.isEmpty(favoritesString)){
	             newFavoritesString = videoId ;
	         } else {
	             newFavoritesString = String.format("%s_%s",videoId,favoritesString) ;
	         }
	         //NSLog(@"new : %@",newFavoritesString) ;
	         VeamUtil.setFavoriteVideos(context,newFavoritesString) ;
	     }
	 }

	 public static void deleteFavoriteVideo(Context context,String videoId){
	     //NSLog(@"deleteFavoriteVideo") ;
	     String favoritesString = VeamUtil.getFavoriteVideos(context) ;
	     String[] favoriteIds = favoritesString.split("_") ;
	     String newFavoritesString = null ;
	     int count = favoriteIds.length ;
	     for(int index = 0 ; index < count ; index++){
	         String workId = favoriteIds[index] ;
	         if(workId != null){
	             if(!workId.equals(videoId)){
	                 if(newFavoritesString == null){
	                     newFavoritesString = workId ;
	                 } else {
	                     newFavoritesString = String.format("%s_%s",newFavoritesString,workId) ;
	                 }
	             }
	         }
	     }
	     //NSLog(@"new : %@",newFavoritesString) ;
	     VeamUtil.setFavoriteVideos(context,newFavoritesString) ;
	 }


	 
	 
	 

	 
	 private final static String PREFERENCE_KEY_FAVORITE_RECIPES = "FAVORITE_RECIPES" ;
	 
	 public static void setFavoriteRecipes(Context context,String recipes){
		 VeamUtil.setPreferenceString(context, PREFERENCE_KEY_FAVORITE_RECIPES, recipes) ;
	 }

	 public static String getFavoriteRecipes(Context context){
		 return VeamUtil.getPreferenceString(context, PREFERENCE_KEY_FAVORITE_RECIPES) ;
	 }

	 public static boolean isFavoriteRecipe(Context context,String recipeId){
	     boolean retValue = false ;
	     String favoritesString = VeamUtil.getFavoriteRecipes(context) ;
	     String[] favoriteIds = favoritesString.split("_") ;
	     int count = favoriteIds.length ;
	     for(int index = 0 ; index < count ; index++){
	         String workId = favoriteIds[index] ;
	         if((workId != null) && workId.equals(recipeId)){
	             retValue = true ;
	             break ;
	         }
	     }
	     
	   //VeamUtil.log("debug","isfavorite "+favoritesString+" "+recipeId+" "+retValue) ;
	     return retValue ;
	 }

	 public static void addFavoriteRecipe(Context context,String recipeId){
	     //NSLog(@"addFavoriteRecipe") ;
	     if(!VeamUtil.isFavoriteRecipe(context, recipeId)){
	         String favoritesString = VeamUtil.getFavoriteRecipes(context) ;
	         String newFavoritesString = null ;
	         if(VeamUtil.isEmpty(favoritesString)){
	             newFavoritesString = recipeId ;
	         } else {
	             newFavoritesString = String.format("%s_%s",recipeId,favoritesString) ;
	         }
	         //NSLog(@"new : %@",newFavoritesString) ;
	         VeamUtil.setFavoriteRecipes(context,newFavoritesString) ;
	     }
	 }

	 public static void deleteFavoriteRecipe(Context context,String recipeId){
	     //NSLog(@"deleteFavoriteRecipe") ;
	     String favoritesString = VeamUtil.getFavoriteRecipes(context) ;
	     String[] favoriteIds = favoritesString.split("_") ;
	     String newFavoritesString = null ;
	     int count = favoriteIds.length ;
	     for(int index = 0 ; index < count ; index++){
	         String workId = favoriteIds[index] ;
	         if(workId != null){
	             if(!workId.equals(recipeId)){
	                 if(newFavoritesString == null){
	                     newFavoritesString = workId ;
	                 } else {
	                     newFavoritesString = String.format("%s_%s",newFavoritesString,workId) ;
	                 }
	             }
	         }
	     }
	     //NSLog(@"new : %@",newFavoritesString) ;
	     VeamUtil.setFavoriteRecipes(context,newFavoritesString) ;
	 }

	public static int parseInt(String numberString){
		int retValue = 0 ;
		try {
			retValue = Integer.parseInt(numberString) ;
		} catch(Exception e){
		}
		return retValue ;
	}

	
	public static String htmlUnescape(String html){
		//VeamUtil.log("debug","html:"+html) ;
		String retValue = html ;
		retValue = retValue.replaceAll("&amp;", "&") ;
		retValue = retValue.replaceAll("&lt;", "<") ;
		retValue = retValue.replaceAll("&gt;", ">") ;
		retValue = retValue.replaceAll("&quot;", "\"") ;
		return retValue ;
	}
	
	public static boolean isSpecialForumId(String forumId){
		boolean retValue = false ;
		if( forumId.equals("0") || 
			forumId.equals(VeamUtil.SPECIAL_FORUM_ID_MY_POSTS) ||
			forumId.equals(VeamUtil.SPECIAL_FORUM_ID_USER_POST) ||
			forumId.equals(VeamUtil.SPECIAL_FORUM_ID_FAVORITES) ||
			forumId.equals(VeamUtil.SPECIAL_FORUM_ID_MY_PROFILE) ||
			forumId.equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS)){
			retValue = true ;
		} else {
			if(forumId.length() > 2){
				if(forumId.substring(0, 2).equals("f:")){
					retValue = true ;
				}
			}
		}
		return retValue ;
	}
	
	
	public static void storeBitmapFromUri(Context context,Uri uri, String fileName) {
		//VeamUtil.log("debug","storeBitmapFromUri:"+uri.getPath()) ;
		File srcFile = new File(uri.getPath()) ;

		InputStream input = null;
		FileOutputStream outputStream;
		try {
			outputStream = context.openFileOutput(fileName,Context.MODE_PRIVATE);
			input = new FileInputStream(srcFile) ;
	
			int DEFAULT_BUFFER_SIZE = 1024 * 4 ;
			byte[] buffer = new byte[DEFAULT_BUFFER_SIZE] ;
			int n = 0;
			while (-1 != (n = input.read(buffer))) {
				outputStream.write(buffer, 0, n) ;
			}
			input.close() ;
			outputStream.close() ;
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void storeBitmap(Context context,String fileName,Bitmap bitmap,Bitmap.CompressFormat compressFormat,int quality){
		FileOutputStream outputStream;
		try {
			outputStream = context.openFileOutput(fileName,Context.MODE_PRIVATE) ;
			bitmap.compress(compressFormat,quality, outputStream) ;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public static Bitmap restoreBitmap(Context context,String fileName){
		FileInputStream inputStream;
		Bitmap retValue = null ;
		try {
			inputStream = context.openFileInput(fileName) ;
			BitmapFactory.Options options = new BitmapFactory.Options() ;
			options.inJustDecodeBounds = false ;
			options.inPreferredConfig = Bitmap.Config.ARGB_8888 ;
			retValue = BitmapFactory.decodeStream(inputStream, null, options) ; 
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return retValue ;
	}
	
	
	public static Bitmap restoreBitmap(Context context,String fileName,int targetWidth){
		FileInputStream inputStream;
		Bitmap retValue = null ;
		try {
			inputStream = context.openFileInput(fileName) ;
			BitmapFactory.Options options = new BitmapFactory.Options() ;
			options.inJustDecodeBounds = true ;
			BitmapFactory.decodeStream(inputStream, null, options) ;
			inputStream.close() ;
			int width = options.outWidth ;
			float sampleSize = (float)width / (float)targetWidth ;
			if(sampleSize < 1.0){
				sampleSize = 1 ;
			}
			//VeamUtil.log("debug","decode bounds target="+targetWidth + " w="+width+" sampleSize="+sampleSize) ;
			options.inSampleSize = (int)sampleSize ;
			options.inJustDecodeBounds = false ;
			options.inPreferredConfig = Bitmap.Config.ARGB_8888 ;
			inputStream = context.openFileInput(fileName) ;
			retValue = BitmapFactory.decodeStream(inputStream, null, options) ;
			inputStream.close() ;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return retValue ;
	}

	public static String getMessageDateString(String timeSince1970){
		String retValue = "" ;
		long unixSeconds = VeamUtil.parseInt(timeSince1970) ;
		if(unixSeconds > 0){
			Calendar date = Calendar.getInstance();
			date.setTimeInMillis(unixSeconds*1000);
			int year = date.get(Calendar.YEAR) ;
			int month = date.get(Calendar.MONTH) ;
			int day = date.get(Calendar.DAY_OF_MONTH) ;
			String monthString = VeamUtil.getShorthandForMonth(month+1,VeamUtil.VEAM_SHORTHAND_MONTH_FORMAT_3CHAR) ;
			retValue = String.format("%s. %d,%d",monthString,day,year) ;
		}

		return retValue ;
	}
	
	public static String getMessageTimeString(String timeSince1970){
		String retValue = "" ;
		long unixSeconds = VeamUtil.parseInt(timeSince1970) ;
		if(unixSeconds > 0){
			Calendar date = Calendar.getInstance();
			date.setTimeInMillis(unixSeconds*1000);
			int hour = date.get(Calendar.HOUR_OF_DAY) ;
			int minute = date.get(Calendar.MINUTE) ;
			retValue = String.format("%d:%02d",hour,minute) ;
		}

		return retValue ;
	}

    /*
	public static String getSinceFromNowString(String timeSince1970){
		long currentTime = System.currentTimeMillis() / 1000L ; 
		long diff = currentTime - Long.parseLong(timeSince1970) ;
		if(diff < 0){
			diff = 0 ;
		}
		String timeString = "" ;
	    if(diff < 60){
	        if(diff == 1){
	            timeString = String.format("%d second ago",diff) ;
	        } else {
	            timeString = String.format("%d seconds ago",diff) ;
	        }
	    } else if(diff < 3600){
	    	diff = (int)(diff/60) ;
	        if(diff == 1){
	            timeString = String.format("%d minute ago",diff) ;
	        } else {
	            timeString = String.format("%d minutes ago",diff) ;
	        }
	    } else if(diff < 86400){
	    	diff = (int)(diff/3600) ;
	        if(diff == 1){
	            timeString = String.format("%d hour ago",diff) ;
	        } else {
	            timeString = String.format("%d hours ago",diff) ;
	        }
	    } else {
	    	diff = (int)(diff/86400) ;
	        if(diff == 1){
	            timeString = String.format("%d day ago",diff) ;
	        } else {
	            timeString = String.format("%d days ago",diff) ;
	        }
	    }
	    return timeString ;
	}
	*/
	
	public static boolean hasNewNotification(Context context){
		boolean retValue = false ;
		String valueString = VeamUtil.getPreferenceString(context, VeamUtil.PREFERENCE_KEY_HAS_NEW_NOTIFICATION) ;
		if(!VeamUtil.isEmpty(valueString) && valueString.equals("1")){
			retValue = true ;
		}
		return retValue ;
	}
	
	public static void setHasNewNotification(Context context,boolean hasNewNotification){
		boolean orgValue = VeamUtil.hasNewNotification(context) ;
		if(hasNewNotification != orgValue){
			if(hasNewNotification){
				VeamUtil.setPreferenceString(context, VeamUtil.PREFERENCE_KEY_HAS_NEW_NOTIFICATION,"1") ;
			} else {
				VeamUtil.setPreferenceString(context, VeamUtil.PREFERENCE_KEY_HAS_NEW_NOTIFICATION,"0") ;
			}
			VeamUtil.notifyHasNewNotificationChanged(context) ;
		}
	}
	
	public static void notifyHasNewNotificationChanged(Context context)
	{
		//VeamUtil.log("debug","notifyHasNewNotificationChanged") ;
		Intent broadcastIntent = new Intent() ;
		broadcastIntent.putExtra("KIND", VeamUtil.NOTICE_NEW_NOTIFICATION_CHANGED);
		broadcastIntent.setAction(String.format("co.veam.veam31000287.%s",VeamUtil.NOTICE_NEW_NOTIFICATION_CHANGED));
		context.sendBroadcast(broadcastIntent);
	}
	
	public static void notifyNewMessage(Context context)
	{
		//VeamUtil.log("debug","notifyNewMessage") ;
		Intent broadcastIntent = new Intent() ;
		broadcastIntent.putExtra("KIND", VeamUtil.NOTICE_NEW_MESSAGE);
		broadcastIntent.setAction(String.format("co.veam.veam31000287.%s",VeamUtil.NOTICE_NEW_MESSAGE));
		context.sendBroadcast(broadcastIntent);
	}
	
	public static void notifyNewProfileNotification(Context context)
	{
		//VeamUtil.log("debug","notifyNewProfileNotification") ;
		Intent broadcastIntent = new Intent() ;
		broadcastIntent.putExtra("KIND", VeamUtil.NOTICE_NEW_PROFILE_NOTIFICATION);
		broadcastIntent.setAction(String.format("co.veam.veam31000287.%s",VeamUtil.NOTICE_NEW_PROFILE_NOTIFICATION));
		context.sendBroadcast(broadcastIntent);
	}
	
	
	public static Integer sendRegistration(Context context,String registrationId,String socialUserId){
		//VeamUtil.log("debug","VeamUtil::sendRegistration "+socialUserId+":"+registrationId) ;
    	Integer resultCode = 0 ;

    	String encodedRegistrationId = "" ;
		try {
			encodedRegistrationId = URLEncoder.encode(registrationId,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
			encodedRegistrationId = registrationId ;
		}
    	
		if(VeamUtil.isEmpty(socialUserId)){
			socialUserId = "0" ;
		}
		
    	String signature = VeamUtil.sha1(String.format("VEAM_%s_%s", registrationId,socialUserId)) ;
    	String urlString = String.format("%s&t=%s&sid=%s&s=%s",VeamUtil.getApiUrlString(context, "gcm/register"),encodedRegistrationId,socialUserId,signature) ;
    	//VeamUtil.log("debug", "register gcm url=" + urlString);
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream inputStream = url.openConnection().getInputStream();
			
			InputStreamReader streamReader = new InputStreamReader(inputStream);
			BufferedReader bufferedReader = new BufferedReader(streamReader);
			ArrayList<String> result = new ArrayList<String>() ; 
			String line = bufferedReader.readLine() ;
			while(line != null){
				result.add(line) ;
				line = bufferedReader.readLine() ;
			}

		    if(result.size() >= 1){
		    	if(result.get(0).equals("OK")){
		    		//VeamUtil.setIsGcmRegisterDone(this, true) ;
		    	}
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return resultCode ;
	}
	
    @SuppressLint("NewApi")
    public static boolean isDocumentUri(final Context context, final Uri uri) {
        boolean retValue = false ;
    	final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT ;
        
        // DocumentProvider
        if(isKitKat && DocumentsContract.isDocumentUri(context, uri)){
        	retValue = true ;
        }
        
        return retValue ;
    }
    
	public static Uri getReadableUri(final Context context, final Uri uri) {
		/*
        //VeamUtil.log("debug" + " File -",
                "Authority: " + uri.getAuthority() +
                        ", Fragment: " + uri.getFragment() +
                        ", Port: " + uri.getPort() +
                        ", Query: " + uri.getQuery() +
                        ", Scheme: " + uri.getScheme() +
                        ", Host: " + uri.getHost() +
                        ", Segments: " + uri.getPathSegments().toString()
                );
                */
        
        String filePath = VeamUtil.getPathFromUri(context, uri) ;
  	    Uri externalContentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI ;
  	    Cursor cursor = context.getContentResolver().query( externalContentUri, null,MediaStore.Images.ImageColumns.DATA + " = ?", new String[] {filePath}, null ) ;
  	    cursor.moveToFirst();
  	    Uri contentUri = Uri.parse("content://media/external/images/media/" + cursor.getInt(cursor.getColumnIndex(MediaStore.MediaColumns._ID))) ;
  	    return contentUri ;
    }

    /**
     * Get a file path from a Uri. This will get the the path for Storage Access
     * Framework Documents, as well as the _data field for the MediaStore and
     * other file-based ContentProviders.<br>
     * <br>
     * Callers should check whether the path is local before assuming it
     * represents a local file.
     * 
     * @param context The context.
     * @param uri The Uri to query.
     * @see #isLocal(String)
     * @see #getFile(Context, Uri)
     * @author paulburke
     */
    @SuppressLint("NewApi")
    public static String getPathFromUri(final Context context, final Uri uri) {
    	/*
        //VeamUtil.log("debug" + " File -",
                "Authority: " + uri.getAuthority() +
                        ", Fragment: " + uri.getFragment() +
                        ", Port: " + uri.getPort() +
                        ", Query: " + uri.getQuery() +
                        ", Scheme: " + uri.getScheme() +
                        ", Host: " + uri.getHost() +
                        ", Segments: " + uri.getPathSegments().toString()
                );
                */

        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;

        // DocumentProvider
        if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
            if (isExternalStorageDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                if ("primary".equalsIgnoreCase(type)) {
                    return Environment.getExternalStorageDirectory() + "/" + split[1];
                }

                // TODO handle non-primary volumes
            }
            // DownloadsProvider
            else if (isDownloadsDocument(uri)) {

                final String id = DocumentsContract.getDocumentId(uri);
                final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

                return getDataColumn(context, contentUri, null, null);
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }

                final String selection = "_id=?";
                final String[] selectionArgs = new String[] {
                        split[1]
                };

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {

            // Return the remote address
            if (isGooglePhotosUri(uri))
                return uri.getLastPathSegment();

            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }

        return null;
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is ExternalStorageProvider.
     * @author paulburke
     */
    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is DownloadsProvider.
     * @author paulburke
     */
    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is MediaProvider.
     * @author paulburke
     */
    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is Google Photos.
     */
    public static boolean isGooglePhotosUri(Uri uri) {
        return "com.google.android.apps.photos.content".equals(uri.getAuthority());
    }

    /**
     * Get the value of the data column for this Uri. This is useful for
     * MediaStore Uris, and other file-based ContentProviders.
     *
     * @param context The context.
     * @param uri The Uri to query.
     * @param selection (Optional) Filter used in the query.
     * @param selectionArgs (Optional) Selection arguments used in the query.
     * @return The value of the _data column, which is typically a file path.
     * @author paulburke
     */
    public static String getDataColumn(Context context, Uri uri, String selection,String[] selectionArgs) {

        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {
                column
        };

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,null);
            if (cursor != null && cursor.moveToFirst()) {
                //DatabaseUtils.dumpCursor(cursor);
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }



















    // for theme
	/*
	private static final String THEME_ATTR_ID  				   		= "id" ;
	private static final String THEME_ATTR_BASE_URL			   		= "ub" ;
	private static final String THEME_ATTR_THUMBNAIL		   		= "thumb" ;
	private static final String THEME_ATTR_SCREENSHOTS		   		= "ss" ;
	private static final String THEME_ATTR_TITLE  				   	= "t" ;
	private static final String THEME_ATTR_DESCRIPTION  			= "d" ;
	private static final String THEME_ATTR_PRODUCT_ID  				= "pro" ;
	private static final String THEME_ATTR_PRICE  				   	= "pri" ;
	private static final String THEME_ATTR_TOP_COLOR  				= "top_color" ;
	private static final String THEME_ATTR_TOP_TEXT_COLOR  			= "top_t_color" ;
	private static final String THEME_ATTR_TOP_TEXT_FONT  			= "top_t_font" ;
	private static final String THEME_ATTR_BASE_TEXT_SIZE  			= "top_t_size" ;
	private static final String THEME_ATTR_BASE_TEXT_COLOR  		= "base_t_color" ;
	private static final String THEME_ATTR_LINK_TEXT_COLOR  		= "link_t_color" ;
	private static final String THEME_ATTR_BG_COLOR  				= "bg_color" ;
	private static final String THEME_ATTR_POST_TEXT_COLOR  		= "post_t_color" ;
	private static final String THEME_ATTR_STATUS_BAR_COLOR  		= "s_bar_color" ;
	private static final String THEME_ATTR_STATUS_BAR_STYLE  		= "s_bar_style" ;
	private static final String THEME_ATTR_SEPARATOR_COLOR  		= "sp_color" ;
	private static final String THEME_ATTR_TEXT1_COLOR  			= "t1_color" ;
	private static final String THEME_ATTR_TEXT2_COLOR  			= "t2_color" ;
	private static final String THEME_ATTR_TEXT3_COLOR  			= "t3_color" ;
	q_head_color
	q_head_t_color
	private static final String THEME_ATTR_IMAGES  				   	= "images" ;
	*/

    public static int getTopBarColor(Context context){
        String colorString = VeamUtil.getPreferenceString(context,"top_bar_color_argb") ;
        int retValue = 0 ;
        if(VeamUtil.isEmpty(colorString)) {
            retValue = VeamUtil.getColorFromArgbString("FF8B8B8B"); // default
        } else {
            retValue = VeamUtil.getColorFromArgbString(colorString);
        }
        return retValue ;
    }

    public static int getBaseTextColor(Context context){
        String colorString = VeamUtil.getPreferenceString(context,"base_text_color_argb") ;
        int retValue = 0 ;
        if(VeamUtil.isEmpty(colorString)) {
            retValue = VeamUtil.getColorFromArgbString("FF000000"); // default
        } else {
            retValue = VeamUtil.getColorFromArgbString(colorString);
        }
        return retValue ;
    }

    public static int getLinkTextColor(Context context){
        String colorString = VeamUtil.getPreferenceString(context,"new_videos_text_color_argb") ;
        int retValue = 0 ;
        if(VeamUtil.isEmpty(colorString)) {
            retValue = VeamUtil.getColorFromArgbString("FF130EFF"); // default
        } else {
            retValue = VeamUtil.getColorFromArgbString(colorString);
        }
        return retValue ;
    }

    public static int getBackgroundColor(Context context){
        String colorString = VeamUtil.getPreferenceString(context, "base_background_color_argb") ;
        int retValue = 0 ;
        if(VeamUtil.isEmpty(colorString)) {
            retValue = VeamUtil.getColorFromArgbString("33FFFFFF"); // default
        } else {
            retValue = VeamUtil.getColorFromArgbString(colorString);
        }
        return retValue ;
    }

    public static Bitmap getThemeImage(VeamActivity context,String imageName,int sampleSize){
       VeamUtil.log("debug","VeamUtil.getThemeImage " + imageName) ;
        Bitmap bitmap = null ;
        try {
            AlternativeImageObject alternativeImageObject = VeamUtil.getAlternativeImageObject(context.getDb(), imageName + ".png") ;
            String imageUrl = null ;
            if(alternativeImageObject != null) {
				imageUrl = alternativeImageObject.getUrl() ;
               VeamUtil.log("debug","AlternativeImage found " + imageUrl) ;
            }
            BitmapFactory.Options options = new BitmapFactory.Options() ;
            options.inJustDecodeBounds = false ;
            options.inSampleSize = sampleSize ;
            options.inPreferredConfig = Bitmap.Config.RGB_565 ;

            if(!VeamUtil.isEmpty(imageUrl)){
                FileInputStream inputStream = VeamUtil.getCachedFileInputStream(context, imageUrl, false) ;
                if(inputStream != null){
                	VeamUtil.log("debug","inputStream found") ;
                    bitmap = BitmapFactory.decodeStream(inputStream, null, options);
				}
            }
            if(bitmap == null){
				VeamUtil.log("debug","bitmap is null") ;
                bitmap = BitmapFactory.decodeResource(context.getResources(), VeamUtil.getDrawableId(context, imageName), options) ;
            }

        } catch (OutOfMemoryError e) {
        }
        return bitmap ;
    }



    public static String getColorString(int color){
        String colorString = String.format("%08X",color).substring(2,8) ;
        return colorString ;
    }

	public static boolean isPreviewMode(){
		return IS_PREVIEW_MODE ;
	}

	public static boolean isTestInAppBilling(){
		return IN_APP_BILLING_TEST | IS_PREVIEW_MODE ;
	}


	public static final String USERDEFAULT_KEY_PREVIEW_APP_ID = "PREVIEW_APP_ID" ;
	public static final String VEAM_CONSOLE_KEY_APP_SECRET = "PREVIEW_APP_SECRET" ;
	public static final String VEAM_CONSOLE_KEY_USER_PRIVILAGES = "PREVIEW_USER_PRIVILAGES" ;
	public static final String VEAM_CONSOLE_KEY_USER_ID = "PREVIEW_USER_ID" ;
	public static final String VEAM_CONSOLE_KEY_PASSWORD = "PREVIEW_PASSWORD" ;


	public static String getAppId(){
		String appId = "31000287" ;
		if(VeamUtil.isPreviewMode()){
			appId = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(),USERDEFAULT_KEY_PREVIEW_APP_ID) ;
		}
        return appId ;
    }

    public static String getAppName(Context context){
		String appName = context.getString(R.string.app_name) ;
		if(VeamUtil.isPreviewMode()){
			appName = VeamUtil.getPreferenceString(AnalyticsApplication.getContext(),"app_name") ;
		}
        return appName ;
    }

    public static String getMcnId(Context context){
        return context.getString(R.string.mcn_id) ;
    }

    public static int getYearFromIntString(String intString){
        int year = 0 ;
        long unixSeconds = VeamUtil.parseInt(intString) ;
        if(unixSeconds > 0){
            Calendar date = Calendar.getInstance();
            date.setTimeInMillis(unixSeconds*1000);
            year = date.get(Calendar.YEAR) ;
        }
        return year ;
    }

    public static String getMixedDateString(String intString){
        String retValue = "" ;
        long unixSeconds = VeamUtil.parseInt(intString) ;
        if(unixSeconds > 0){
            Calendar date = Calendar.getInstance();
            date.setTimeInMillis(unixSeconds*1000);
            int month = date.get(Calendar.MONTH) ;
            int day = date.get(Calendar.DAY_OF_MONTH) ;
            String monthString = VeamUtil.getShorthandForMonth(month+1,VeamUtil.VEAM_SHORTHAND_MONTH_FORMAT_3CHAR) ;
            retValue = String.format("%s.%d",monthString,day) ;
        }

        return retValue ;
    }

    public static String getMixedDateStringWithYear(String intString){
        String retValue = "" ;
        long unixSeconds = VeamUtil.parseInt(intString) ;
        if(unixSeconds > 0){
            Calendar date = Calendar.getInstance();
            date.setTimeInMillis(unixSeconds*1000);
            int year = date.get(Calendar.YEAR) ;
            int month = date.get(Calendar.MONTH) ;
            int day = date.get(Calendar.DAY_OF_MONTH) ;
            String monthString = VeamUtil.getShorthandForMonth(month + 1, VeamUtil.VEAM_SHORTHAND_MONTH_FORMAT_3CHAR) ;
            retValue = String.format("%s.%d %d", monthString, day, year) ;
        }

        return retValue ;
    }


    public static String VEAM_SUBSCRIPTION_PRODUCT_ID_FORMAT = "co.veam.veam%s.subscription%d.1m" ;

    public static String getSubscriptionProductId(int index){
        return String.format(VeamUtil.VEAM_SUBSCRIPTION_PRODUCT_ID_FORMAT,VeamUtil.getAppId(),index) ;
    }


    public static String getAudioDateString(String intString){
        String retValue = "" ;
        long unixSeconds = VeamUtil.parseInt(intString) ;
        if(unixSeconds > 0){
            Calendar date = Calendar.getInstance();
            date.setTimeInMillis(unixSeconds*1000);
            int month = date.get(Calendar.MONTH) ;
            int day = date.get(Calendar.DAY_OF_MONTH) ;
            String monthString = VeamUtil.getShorthandForMonth(month+1,VeamUtil.VEAM_SHORTHAND_MONTH_FORMAT_3CHAR) ;
            retValue = String.format("%s.%d",monthString,day) ;
        }

        return retValue ;
    }

    public static String getAudioDateStringWithYear(String intString){
        String retValue = "" ;
        long unixSeconds = VeamUtil.parseInt(intString) ;
        if(unixSeconds > 0){
            Calendar date = Calendar.getInstance();
            date.setTimeInMillis(unixSeconds*1000);
            int year = date.get(Calendar.YEAR) ;
            int month = date.get(Calendar.MONTH) ;
            int day = date.get(Calendar.DAY_OF_MONTH) ;
            String monthString = VeamUtil.getShorthandForMonth(month+1,VeamUtil.VEAM_SHORTHAND_MONTH_FORMAT_3CHAR) ;
            retValue = String.format("%s.%d %d",monthString,day,year) ;
        }

        return retValue ;
    }









    public static final String USERDEFAULT_KEY_SUBSCRIPTION_START_FORMAT    = "SUBSCRIPTION_%d_START" ;
    public static void setSubscriptionStart(Context context,int index,String start){
       //VeamUtil.log("debug","VeamUtil.setSubscriptionStart "+ start) ;
        String key = String.format(USERDEFAULT_KEY_SUBSCRIPTION_START_FORMAT, index) ;
        VeamUtil.setPreferenceString(context, key, start) ;
    }

    public static String getSubscriptionStart(Context context,int index){
        String key = String.format(USERDEFAULT_KEY_SUBSCRIPTION_START_FORMAT,index) ;
        String start = VeamUtil.getPreferenceString(context, key) ;
        return start ;
    }

    public static boolean isStoredAlternativeImage(Context context,String id){
        boolean retValue = false ;
        VeamConfiguration veamConfiguration = VeamConfiguration.getInstance(context) ;
        String storedIdsString = veamConfiguration.getValue("stored_alternative_image_ids") ;
       //VeamUtil.log("debug","VeamUtil.isStoredAlternativeImage " + id + " " + storedIdsString) ;
        String[] storedIds = storedIdsString.split(",", 0) ;
        if(Arrays.asList(storedIds).contains(id)){
            retValue = true ;
        }
        return retValue ;
    }

	public static void removeFromParentView(View view){
		ViewGroup viewGroup = (ViewGroup)view.getParent() ;
		if(viewGroup != null){
			viewGroup.removeView(view) ;
		}
	}

	public static void setSellVideoIsBought(Context context,boolean isBought,String sellVideoId){
		String key = "" ;
		key = String.format(PREFERENCE_KEY_SELL_VIDEO_IS_BOUGHT_FORMAT,sellVideoId) ;
		VeamUtil.setPreferenceString(context, key, isBought?"y":"n") ;
	}

	public static boolean getSellVideoIsBought(Context context,String sellVideoId){
		boolean retValue = false ;
		String key = "" ;

		key = String.format(PREFERENCE_KEY_SELL_VIDEO_IS_BOUGHT_FORMAT,sellVideoId) ;

		String value = VeamUtil.getPreferenceString(context, key) ;
		if(!VeamUtil.isEmpty(value) && value.equals("y")){
			retValue = true ;
		}
		return retValue ;
	}


	public static void setSellPdfIsBought(Context context,boolean isBought,String sellPdfId){
		String key = "" ;
		key = String.format(PREFERENCE_KEY_SELL_PDF_IS_BOUGHT_FORMAT,sellPdfId) ;
		VeamUtil.setPreferenceString(context, key, isBought?"y":"n") ;
	}

	public static boolean getSellPdfIsBought(Context context,String sellPdfId){
		boolean retValue = false ;
		String key = "" ;

		key = String.format(PREFERENCE_KEY_SELL_PDF_IS_BOUGHT_FORMAT,sellPdfId) ;

		String value = VeamUtil.getPreferenceString(context, key) ;
		if(!VeamUtil.isEmpty(value) && value.equals("y")){
			retValue = true ;
		}
		return retValue ;
	}




	public static void setPdfUrl(Context context,String url,String pdfId){
		String key = "" ;
		key = String.format(PREFERENCE_KEY_PDF_URL,pdfId) ;
		VeamUtil.setPreferenceString(context, key, url) ;

		//VeamUtil.log("debug","setPdfUrl key="+key+" url="+url) ;
	}

	public static String getPdfUrl(Context context,String pdfId){
		String retValue = "" ;
		String key = "" ;

		key = String.format(PREFERENCE_KEY_PDF_URL,pdfId) ;

		retValue = VeamUtil.getPreferenceString(context, key) ;
		if(VeamUtil.isEmpty(retValue)){
			retValue = "" ;
		}

		//VeamUtil.log("debug","getPdfUrl key="+key+" url="+retValue) ;

		return retValue ;
	}


	public static void setPdfToken(Context context,String token,String pdfId){
		String key = "" ;
		key = String.format(PREFERENCE_KEY_PDF_TOKEN,pdfId) ;
		VeamUtil.setPreferenceString(context, key, token) ;
	}

	public static String getPdfToken(Context context,String pdfId){
		String retValue = "" ;
		String key = "" ;

		key = String.format(PREFERENCE_KEY_PDF_TOKEN,pdfId) ;

		retValue = VeamUtil.getPreferenceString(context, key) ;
		if(VeamUtil.isEmpty(retValue)){
			retValue = "" ;
		}
		return retValue ;
	}




	public static void setSellAudioIsBought(Context context,boolean isBought,String sellAudioId){
		String key = "" ;
		key = String.format(PREFERENCE_KEY_SELL_AUDIO_IS_BOUGHT_FORMAT, sellAudioId) ;
		VeamUtil.setPreferenceString(context, key, isBought?"y":"n") ;
	}

	public static boolean getSellAudioIsBought(Context context,String sellAudioId){
		boolean retValue = false ;
		String key = "" ;

		key = String.format(PREFERENCE_KEY_SELL_AUDIO_IS_BOUGHT_FORMAT, sellAudioId) ;

		String value = VeamUtil.getPreferenceString(context, key) ;
		if(!VeamUtil.isEmpty(value) && value.equals("y")){
			retValue = true ;
		}
		return retValue ;
	}




	public static void setAudioUrl(Context context,String url,String audioId){
		String key = "" ;
		key = String.format(PREFERENCE_KEY_AUDIO_URL,audioId) ;
		VeamUtil.setPreferenceString(context, key, url) ;

		//VeamUtil.log("debug","setAudioUrl key="+key+" url="+url) ;
	}

	public static String getAudioUrl(Context context,String audioId){
		String retValue = "" ;
		String key = "" ;

		key = String.format(PREFERENCE_KEY_AUDIO_URL,audioId) ;

		retValue = VeamUtil.getPreferenceString(context, key) ;
		if(VeamUtil.isEmpty(retValue)){
			retValue = "" ;
		}

		//VeamUtil.log("debug","getAudioUrl key="+key+" url="+retValue) ;

		return retValue ;
	}


	public static String getSellSectionProductId(Context context,int index) {
		String productId = VeamUtil.getPreferenceString(context, String.format("section_%d_product_id",index));
		if(VeamUtil.isEmpty(productId)){
			productId = "" ;
		}
		return productId ;
	}

	public static String getSellSectionPurchaseButtonText(Context context,int index) {
		String buttonText = VeamUtil.getPreferenceString(context, String.format("section_payment_%d_button_text",index));
		if(VeamUtil.isEmpty(buttonText)){
			buttonText = "Tap To Purchase" ;
		}
		return buttonText ;
	}

	public static String getSellSectionPurchaseDescription(Context context,int index) {
		String description = VeamUtil.getPreferenceString(context, String.format("section_payment_%d_description",index));
		if(VeamUtil.isEmpty(description)){
			description = "" ;
		}
		return description ;
	}

	public static String getSellSectionDescription(Context context,int index) {
		String description = VeamUtil.getPreferenceString(context, String.format("section_%d_description",index));
		if(VeamUtil.isEmpty(description)){
			description = "" ;
		}
		return description ;
	}

	public static void setSellSectionIsBought(Context context,boolean isBought,int index){
		String key = "" ;
		key = String.format(PREFERENCE_KEY_SELL_SECTION_IS_BOUGHT_FORMAT,index) ;
		VeamUtil.setPreferenceString(context, key, isBought?"y":"n") ;
	}

	public static boolean getSellSectionIsBought(Context context,int index){
		boolean retValue = false ;
		String key = "" ;

		key = String.format(PREFERENCE_KEY_SELL_SECTION_IS_BOUGHT_FORMAT,index) ;

		String value = VeamUtil.getPreferenceString(context, key) ;
		if(!VeamUtil.isEmpty(value) && value.equals("y")){
			retValue = true ;
		}
		return retValue ;
	}


	public static String bbDecode(String encodedUrl){
		String decoded = null;
		try {
			decoded = new String(Base64.decode(encodedUrl, Base64.DEFAULT),"UTF-8");
			//VeamUtil.log("debug","bbDecode first="+decoded) ;
			decoded = new String(Base64.decode(decoded, Base64.DEFAULT),"UTF-8") ;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		return decoded ;
	}

	/*
	public static boolean isExcludedKiipReward(Context context,String rewardString){
		boolean retValue = false ;
		VeamConfiguration veamConfiguration = VeamConfiguration.getInstance(context) ;
		String rewardsString = veamConfiguration.getValue("kiip_exclusion") ;
		String[] rewardStrings = rewardsString.split(",", 0) ;
		if(Arrays.asList(rewardStrings).contains(rewardString)){
			retValue = true ;
		}
		return retValue ;
	}
	*/

	/*
	public static void kickKiip(VeamActivity activity,String rewardString){
		VeamUtil.log("debug","VeamUtil::kickKiip "+rewardString) ;
		if(!VeamUtil.isExcludedKiipReward(activity,rewardString)) {
			final VeamActivity veamActivity = activity;
			Kiip.getInstance().saveMoment(rewardString, new Kiip.Callback() {
				@Override
				public void onFinished(Kiip kiip, Poptart poptart) {
					if (poptart == null) {
						//VeamUtil.log("debug", "Successful moment but no reward to give.");
					} else {
						veamActivity.onPoptart(poptart);
					}
				}

				@Override
				public void onFailed(Kiip kiip, Exception exception) {
					// handle failure
				}
			});
		}
	}
	*/

	public static boolean isSubscriptionFree(Context context){
		boolean retValue = false ;
		String isFreeString = VeamUtil.getPreferenceString(context, VeamUtil.PREFERENCE_KEY_TEMPLATE_SUBSCRIPTION_IS_FREE) ;
		if(!VeamUtil.isEmpty(isFreeString)){
			if(isFreeString.equals("1")){
				retValue = true ;
			}
		}
		return retValue ;
	}


	public static AdRequest getAdRequest(){
		AdRequest adRequest = new AdRequest.Builder()
				.addTestDevice("__DEVICE_ID__") // galaxy s3 alpha
				.addTestDevice("__DEVICE_ID__") // Nexus
				.addTestDevice("__DEVICE_ID__") // Xperia
				.build();
		return adRequest ;
	}


	public static String[] getTemplateIds(Context context){
		//<template_ids value="8_1_2_3" />
		String templateIdsString = VeamUtil.getPreferenceString(context,"template_ids") ;
		//VeamUtil.log("debug","VeamUtil.isStoredAlternativeImage " + id + " " + storedIdsString) ;
		String[] templateIds = templateIdsString.split("_", 0) ;

		return templateIds ;
	}

	public static int getTemplateIndex(Context context,int templateId){
		int templateIndex = -1 ;
		String[] templateIds = VeamUtil.getTemplateIds(context) ;
		if(templateIds != null){
			for(int index = 0 ; index < templateIds.length ; index++){
				if(templateId == VeamUtil.parseInt(templateIds[index])){
					templateIndex = index ;
					break ;
				}
			}
		}
		return templateIndex ;

	}

	public static boolean shouldSkipInitial(Context context){
		boolean retValue = false ;
		String skipInitialString = VeamUtil.getPreferenceString(context, "skip_initial") ;
		if(!VeamUtil.isEmpty(skipInitialString)){
			if(skipInitialString.equals("1")){
				retValue = true ;
			}
		}
		return retValue ;
	}

	public static boolean isLocaleJapanese() {

		boolean retValue = false;
		String language = AnalyticsApplication.getContext().getString(R.string.language);
		if (!VeamUtil.isEmpty(language) && language.equals("ja")) {
			retValue = true;
		}
		return retValue;

	}

	public static void log(String tag,String message){
		if(IS_ACTIVE_DEBUG_LOG) {
			StackTraceElement[] elements = (new Throwable()).getStackTrace();
			String prefix = "";
			if ((elements != null) && (elements.length >= 2)) {
				StackTraceElement element = elements[1];
				String className = element.getClassName();
				int lastIndex = className.lastIndexOf(".");
				if (lastIndex >= 0) {
					className = className.substring(lastIndex);
				}
				prefix = String.format("%s::%s:%d ", className, element.getMethodName(), element.getLineNumber());
			}
			Log.d(tag, prefix + message);
		}
	}

	public static int getSubscriptionIndex(Context context){
		String indexString = VeamUtil.getPreferenceString(context,"subscription_index") ;
		int index = VeamUtil.parseInt(indexString) ;
		VeamUtil.log("debug","getSubscriptionIndex : "+index);
		return index ;
	}

	public static String getSubscriptionDescription(Context context,int index){
		String description = VeamUtil.getPreferenceString(context,String.format("subscription_%d_description",index)) ;
		return description ;
	}

	public static String getSubscriptionButtonText(Context context,int index){
		String buttonText = VeamUtil.getPreferenceString(context, String.format("subscription_%d_button_text", index)) ;
		return buttonText ;
	}




	public static int getTextWidth(TextView textView) {
		TextPaint paint = textView.getPaint();
		int textWidth = (int) Layout.getDesiredWidth(textView.getText(), paint);
		return textWidth;
	}

	public static void setTextSizeWithin(int width, TextView textView) {
		float textSize = textView.getTextSize();
		int textWidth = VeamUtil.getTextWidth(textView);
		if (width < textWidth) {
			textView.setTextSize(textSize);
			textWidth = VeamUtil.getTextWidth(textView);
			textSize = textSize * width / textWidth;
			textView.setTextSize(textSize);

			//VeamUtil.log("debug", "first adjusted textSize=" + textSize);

			int retry = 20;
			while ((width < VeamUtil.getTextWidth(textView)) && (retry > 0)) {
				textSize *= 0.9;
				textView.setTextSize(textSize);
				//VeamUtil.log("debug", "adjusted textSize=" + textSize);
				retry--;
			}
		}
	}



}
