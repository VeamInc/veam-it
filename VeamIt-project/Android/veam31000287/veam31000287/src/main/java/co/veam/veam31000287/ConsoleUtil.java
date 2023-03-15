package co.veam.veam31000287;


import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.TextPaint;
import android.util.Log;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Locale;
import java.util.Map;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

/**
 * Created by veam on 10/27/16.
 */
public class ConsoleUtil {

    public static boolean contentsChanged = false ;

    public static boolean isContentsChanged() {
        return contentsChanged;
    }

    public static void setContentsChanged(boolean contentsChanged) {
        ConsoleUtil.contentsChanged = contentsChanged;
    }

    public static Typeface typefaceRobotoLight;
    public static Typeface typefaceRobotoThin;


    public static final String VEAM_SUBSCRIPTION_KIND_VIDEOS = "1";
    public static final String VEAM_SUBSCRIPTION_KIND_QA = "2";
    public static final String VEAM_SUBSCRIPTION_KIND_CALENDAR = "3";
    public static final String VEAM_SUBSCRIPTION_KIND_MIXED_GRID = "4";
    public static final String VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS = "5";
    public static final String VEAM_SUBSCRIPTION_KIND_SELL_SECTION = "6";

    public static final int VEAM_ORDER_ASCENDING = 1;
    public static final int VEAM_ORDER_DESCENDING = 2;

    public static final String DROPBOX_VIDEO_EXTENSIONS = "mov,mp4,mpg,m4v,mts,wmv" ;
    public static final String DROPBOX_AUDIO_EXTENSIONS = "aac,mp3,m4a" ;
    public static final String DROPBOX_IMAGE_EXTENSIONS = "jpg,png" ;
    public static final String DROPBOX_PDF_EXTENSIONS = "pdf" ;


    public static final String VEAM_QUESTION_ANSWER_KIND_VIDEO = "1";
    public static final String VEAM_QUESTION_ANSWER_KIND_YOUTUBE = "2";
    public static final String VEAM_QUESTION_ANSWER_KIND_AUDIO = "3";

    public static final String VEAM_VIDEO_STATUS_READY = "0";
    public static final String VEAM_VIDEO_STATUS_WAITING = "1";
    public static final String VEAM_VIDEO_STATUS_PREPARING = "2";

    public static final String VEAM_MIXED_STATUS_READY = "0";
    public static final String VEAM_MIXED_STATUS_WAITING = "1";
    public static final String VEAM_MIXED_STATUS_PREPARING = "2";

    public static final String VEAM_SELL_VIDEO_STATUS_READY = "0";
    public static final String VEAM_SELL_VIDEO_STATUS_WAITING = "1";
    public static final String VEAM_SELL_VIDEO_STATUS_PREPARING = "2";
    public static final String VEAM_SELL_VIDEO_STATUS_SUBMITTING = "3";

    public static final String VEAM_SELL_PDF_STATUS_READY = "0";
    public static final String VEAM_SELL_PDF_STATUS_WAITING = "1";
    public static final String VEAM_SELL_PDF_STATUS_PREPARING = "2";
    public static final String VEAM_SELL_PDF_STATUS_SUBMITTING = "3";

    public static final String VEAM_SELL_AUDIO_STATUS_READY = "0";
    public static final String VEAM_SELL_AUDIO_STATUS_WAITING = "1";
    public static final String VEAM_SELL_AUDIO_STATUS_PREPARING = "2";
    public static final String VEAM_SELL_AUDIO_STATUS_SUBMITTING = "3";

    public static final String VEAM_SELL_SECTION_ITEM_STATUS_READY = "0";
    public static final String VEAM_SELL_SECTION_ITEM_STATUS_WAITING = "1";
    public static final String VEAM_SELL_SECTION_ITEM_STATUS_PREPARING = "2";
    public static final String VEAM_SELL_SECTION_ITEM_STATUS_SUBMITTING = "3";


    // 0:released 1:setting 2:veamreview 3:applereview 4:initialized 5:building
    public static final String VEAM_APP_INFO_STATUS_RELEASED = "0";
    public static final String VEAM_APP_INFO_STATUS_SETTING = "1";
    public static final String VEAM_APP_INFO_STATUS_MCN_REVIEW = "2";
    public static final String VEAM_APP_INFO_STATUS_APPLE_REVIEW = "3";
    public static final String VEAM_APP_INFO_STATUS_INITIALIZED = "4";
    public static final String VEAM_APP_INFO_STATUS_BUILDING = "5";

    public static final String VEAM_SELL_ITEM_CATEGORY_KIND_VIDEO = "1";
    public static final String VEAM_SELL_ITEM_CATEGORY_KIND_PDF = "2";
    public static final String VEAM_SELL_ITEM_CATEGORY_KIND_AUDIO = "3";

    public static final String VEAM_SELL_SECTION_CATEGORY_KIND_VIDEO = "1";
    public static final String VEAM_SELL_SECTION_CATEGORY_KIND_PDF = "2";
    public static final String VEAM_SELL_SECTION_CATEGORY_KIND_AUDIO = "3";

    public static final String VEAM_SELL_SECTION_ITEM_KIND_VIDEO = "1";
    public static final String VEAM_SELL_SECTION_ITEM_KIND_PDF = "2";
    public static final String VEAM_SELL_SECTION_ITEM_KIND_AUDIO = "3";

    public static final int CONSOLE_TABLE_SEPARATOR_MARGIN = 15;
    public static final String CONSOLE_TABLE_SEPARATOR_COLOR = "FFB5B5B5";

    public static final int VEAM_CONSOLE_HEADER_STYLE_NONE = 0x00000000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_CLOSE = 0x00000001;
    public static final int VEAM_CONSOLE_HEADER_STYLE_BACK = 0x00000002;
    public static final int VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE = 0x00000004;
    public static final int VEAM_CONSOLE_HEADER_STYLE_CENTER_TITLE = 0x00000008;
    public static final int VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT = 0x00000010;
    public static final int VEAM_CONSOLE_HEADER_STYLE_6 = 0x00000020;
    public static final int VEAM_CONSOLE_HEADER_STYLE_7 = 0x00000040;
    public static final int VEAM_CONSOLE_HEADER_STYLE_8 = 0x00000080;
    public static final int VEAM_CONSOLE_HEADER_STYLE_9 = 0x00000100;
    public static final int VEAM_CONSOLE_HEADER_STYLE_10 = 0x00000200;
    public static final int VEAM_CONSOLE_HEADER_STYLE_11 = 0x00000400;
    public static final int VEAM_CONSOLE_HEADER_STYLE_12 = 0x00000800;
    public static final int VEAM_CONSOLE_HEADER_STYLE_13 = 0x00001000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_14 = 0x00002000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_15 = 0x00004000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_16 = 0x00008000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_17 = 0x00010000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_18 = 0x00020000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_19 = 0x00040000;
    public static final int VEAM_CONSOLE_HEADER_STYLE_20 = 0x00080000;

    public static final int VEAM_CONSOLE_SETTING_MODE = 1;
    public static final int VEAM_CONSOLE_UPLOAD_MODE = 2;


    public static final String VEAM_CONSOLE_LAUNCHFROMPREVIEW = "VEAM_CONSOLE_LAUNCHFROMPREVIEW";
    public static final String VEAM_CONSOLE_HIDEHEADERBOTTOMLINE = "VEAM_CONSOLE_HIDEHEADERBOTTOMLINE";
    public static final String VEAM_CONSOLE_HEADERSTYLE = "VEAM_CONSOLE_HEADERSTYLE";
    public static final String VEAM_CONSOLE_HEADERTITLE = "VEAM_CONSOLE_HEADERTITLE";
    public static final String VEAM_CONSOLE_NUMBEROFHEADERDOTS = "VEAM_CONSOLE_NUMBEROFHEADERDOTS";
    public static final String VEAM_CONSOLE_SELECTEDHEADERDOT = "VEAM_CONSOLE_SELECTEDHEADERDOT";
    public static final String VEAM_CONSOLE_SHOWFOOTER = "VEAM_CONSOLE_SHOWFOOTER";
    public static final String VEAM_CONSOLE_BLACKMODE = "VEAM_CONSOLE_BLACKMODE";
    public static final String VEAM_CONSOLE_CONTENTMODE = "VEAM_CONSOLE_CONTENTMODE";
    public static final String VEAM_CONSOLE_HEADERRIGHTTEXT = "VEAM_CONSOLE_HEADERRIGHTTEXT";
    public static final String VEAM_CONSOLE_MIXED_ID = "VEAM_CONSOLE_MIXED_ID";
    public static final String VEAM_CONSOLE_TEMPLATE_ID = "VEAM_CONSOLE_TEMPLATE_ID";
    public static final String VEAM_CONSOLE_FORUM_ID = "VEAM_CONSOLE_FORUM_ID";
    public static final String VEAM_CONSOLE_WEB_ID = "VEAM_CONSOLE_WEB_ID";
    public static final String VEAM_CONSOLE_TUTORIAL_KIND = "VEAM_CONSOLE_TUTORIAL_KIND" ;
    public static final String VEAM_CONSOLE_SELLITEMCATEGORY_ID = "VEAM_CONSOLE_SELLITEMCATEGORY_ID" ;
    public static final String VEAM_CONSOLE_SELLVIDEO_ID = "VEAM_CONSOLE_SELLVIDEO_ID" ;
    public static final String VEAM_CONSOLE_SELLAUDIO_ID = "VEAM_CONSOLE_SELLAUDIO_ID" ;
    public static final String VEAM_CONSOLE_SELLPDF_ID = "VEAM_CONSOLE_SELLPDF_ID" ;
    public static final String VEAM_CONSOLE_AUDIOCATEGORY_ID = "VEAM_CONSOLE_AUDIOCATEGORY_ID" ;
    public static final String VEAM_CONSOLE_VIDEOCATEGORY_ID = "VEAM_CONSOLE_VIDEOCATEGORY_ID" ;
    public static final String VEAM_CONSOLE_PDFCATEGORY_ID = "VEAM_CONSOLE_PDFCATEGORY_ID" ;
    public static final String VEAM_CONSOLE_SELLSECTIONCATEGORY_ID = "VEAM_CONSOLE_SELLSECTIONCATEGORY_ID" ;



    public static final String VEAM_CONSOLE_NOTIFICATION_ID_CONTENT_POST_COMPLETED = "co.veam.veam31000287.CONSOLE_DATA_POST_COMPLETED";

    public static final String VEAM_CONSOLE_NOTIFICATION_CONTENT_POST_DONE = "CONTENT_POST_DONE";
    public static final String VEAM_CONSOLE_NOTIFICATION_CONTENT_POST_FAILED = "CONTENT_POST_FAILED";


    // 1:recipe 2:mini-blog 3:picture 4:unlisted-youtube 5:video 6:audio
    public static final String VEAM_CONSOLE_MIXED_KIND_YEAR = "-1";
    public static final String VEAM_CONSOLE_MIXED_KIND_RECIPE = "1";
    public static final String VEAM_CONSOLE_MIXED_KIND_MINI_BLOG = "2";
    public static final String VEAM_CONSOLE_MIXED_KIND_PICTURE = "3";
    public static final String VEAM_CONSOLE_MIXED_KIND_UNLISTED_YOUTUBE = "4";
    public static final String VEAM_CONSOLE_MIXED_KIND_VIDEO = "5";
    public static final String VEAM_CONSOLE_MIXED_KIND_AUDIO = "6";
    public static final String VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO = "7";
    public static final String VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO = "8";
    public static final String VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO = "9";
    public static final String VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO = "10";
    public static final String VEAM_CONSOLE_MIXED_KIND_YOUTUBE = "11";

    public static final String VEAM_QUESTION_ANSWER_KIND_FIXED_VIDEO = "7";
    public static final String VEAM_QUESTION_ANSWER_KIND_PERIODICAL_VIDEO = "8";
    public static final String VEAM_QUESTION_ANSWER_KIND_FIXED_AUDIO = "9";
    public static final String VEAM_QUESTION_ANSWER_KIND_PERIODICAL_AUDIO = "10";
    public static final String VEAM_QUESTION_ANSWER_KIND_FREE_VIDEO = "11";
    public static final String VEAM_QUESTION_ANSWER_KIND_FREE_AUDIO = "12";

    public static final int VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE            = 1 ;
    public static final int VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED   = 2 ;
    public static final int VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE              = 3 ;
    public static final int VEAM_CONSOLE_TUTORIAL_KIND_FORUM                = 4 ;
    public static final int VEAM_CONSOLE_TUTORIAL_KIND_FORUM_RELEASED       = 5 ;
    public static final int VEAM_CONSOLE_TUTORIAL_KIND_LINK                 = 6 ;

    public static final String VEAM_CONSOLE_UPLOAD_KIND = "VEAM_CONSOLE_UPLOAD_KIND" ;
    public static final int VEAM_CONSOLE_UPLOAD_KIND_SUBSCRIPTION                 = 1 ;
    public static final int VEAM_CONSOLE_UPLOAD_KIND_SELLVIDEO                    = 2 ;
    public static final int VEAM_CONSOLE_UPLOAD_KIND_SELLSECTION                  = 3 ;


    public static final String CONSOLE_SUBSCRIPTION_DESCRIPTION_KEY    = "subscription_0_description" ;
    public static final String CONSOLE_SECTION_DESCRIPTION_KEY    = "section_0_description" ;
    public static final String CONSOLE_SECTION_PAYMENT_DESCRIPTION_KEY    = "section_payment_0_description" ;


    public static final int VEAM_MAX_RECORD_TIME = 180000 ;


    public static String getString(int stringId) {
        String retValue = AnalyticsApplication.getContext().getString(stringId);
        return retValue;
    }

    public static ConsoleContents getConsoleContents() {
        AnalyticsApplication application = (AnalyticsApplication) AnalyticsApplication.getContext();
        return application.getConsoleContents();
    }

    public static void setConsoleContents(ConsoleContents consoleContents) {
        AnalyticsApplication application = (AnalyticsApplication) AnalyticsApplication.getContext();
        application.setConsoleContents(consoleContents);
    }


    /**********************************/
    /* AppInfo */

    /**
     * ******************************
     */
    public static AppInfo getAppInfo() {
        AppInfo retValue = null;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
        if (consoleContents != null) {
            retValue = consoleContents.appInfo;
        }
        return retValue;

    }



    public static String getAppId() {
        String retValue = "";
        AppInfo appInfo = ConsoleUtil.getAppInfo();
        if (appInfo != null) {
            retValue = appInfo.getAppId();
        }
        return retValue;
    }

    public static String getAppStatus() {
        String retValue = "";
        AppInfo appInfo = ConsoleUtil.getAppInfo();
        if (appInfo != null) {
            retValue = appInfo.getStatus();
        }
        return retValue;
    }

    public static void putValueAndKey(Map<String, String> params, String value, String key) {
        params.put(key, value);
    }

    public static int getStatusBarHeight() {
        int result = 0;
        int resourceId = AnalyticsApplication.getContext().getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = AnalyticsApplication.getContext().getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }


    public static RelativeLayout.LayoutParams getRelativeLayoutPrams(int x, int y, int width, int height) {
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(width, height);
        layoutParams.setMargins(x, y, 0, 0);
        return layoutParams;
    }


    public static String getPaymentTypeString(String paymentTypeId, String price) {
        String retValue = "";
        Context context = AnalyticsApplication.getContext();
        if (paymentTypeId.equals(ConsoleUtil.VEAM_SUBSCRIPTION_KIND_MIXED_GRID)) {
            if (price.equals("0")) {
                retValue = context.getString(R.string.free_subscription);
            } else {
                retValue = context.getString(R.string.subscription);
            }
        } else if (paymentTypeId.equals(ConsoleUtil.VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS)) {
            retValue = context.getString(R.string.pay_per_content);
        } else if (paymentTypeId.equals(ConsoleUtil.VEAM_SUBSCRIPTION_KIND_SELL_SECTION)) {
            retValue = context.getString(R.string.one_time_payment);
        }

        return retValue;
    }

    public static void notifyConsoleDataPostDone(String apiName) {
        VeamUtil.log("debug", "notifyConsoleDataPostDone");
        Context context = AnalyticsApplication.getContext();
        Intent broadcastIntent = new Intent();
        broadcastIntent.putExtra("ACTION", ConsoleUtil.VEAM_CONSOLE_NOTIFICATION_CONTENT_POST_DONE);
        broadcastIntent.putExtra("API_NAME", apiName);
        broadcastIntent.setAction(ConsoleUtil.VEAM_CONSOLE_NOTIFICATION_ID_CONTENT_POST_COMPLETED);
        context.sendBroadcast(broadcastIntent);
    }

    public static void notifyConsoleDataPostFailed(String apiName) {
        VeamUtil.log("debug", "notifyConsoleDataPostFailed");
        Context context = AnalyticsApplication.getContext();
        Intent broadcastIntent = new Intent();
        broadcastIntent.putExtra("ACTION", ConsoleUtil.VEAM_CONSOLE_NOTIFICATION_CONTENT_POST_FAILED);
        broadcastIntent.putExtra("API_NAME", apiName);
        broadcastIntent.setAction(ConsoleUtil.VEAM_CONSOLE_NOTIFICATION_ID_CONTENT_POST_COMPLETED);
        context.sendBroadcast(broadcastIntent);
    }

    public static int getTextWidth(TextView textView) {
        TextPaint paint = textView.getPaint();
        int textWidth = (int) Layout.getDesiredWidth(textView.getText(), paint);
        return textWidth;
    }

    public static void setTextSizeWithin(int width, TextView textView) {
        float textSize = textView.getTextSize();
        int textWidth = ConsoleUtil.getTextWidth(textView);
        if (width < textWidth) {
            textView.setTextSize(textSize);
            textWidth = ConsoleUtil.getTextWidth(textView);
            textSize = textSize * width / textWidth;
            textView.setTextSize(textSize);

            //VeamUtil.log("debug", "first adjusted textSize=" + textSize);

            int retry = 20;
            while ((width < ConsoleUtil.getTextWidth(textView)) && (retry > 0)) {
                textSize *= 0.9;
                textView.setTextSize(textSize);
                //VeamUtil.log("debug", "adjusted textSize=" + textSize);
                retry--;
            }
        }
    }

    public static Typeface getTypefaceRobotoLight() {
        if (typefaceRobotoLight == null) {
            typefaceRobotoLight = Typeface.createFromAsset(AnalyticsApplication.getContext().getAssets(), "Roboto-Light.ttf");
        }
        return typefaceRobotoLight;
    }

    public static Typeface getTypefaceRobotoThin() {
        if (typefaceRobotoThin == null) {
            typefaceRobotoThin = Typeface.createFromAsset(AnalyticsApplication.getContext().getAssets(), "Roboto-Thin.ttf");
        }
        return typefaceRobotoThin;
    }

    public static void startViewBlinking(View view) {
        Animation anim = new AlphaAnimation(0.0f, 1.0f);
        anim.setDuration(1000); //You can manage the blinking time with this parameter
        anim.setStartOffset(0);
        anim.setRepeatMode(Animation.REVERSE);
        anim.setRepeatCount(Animation.INFINITE);
        view.startAnimation(anim);
    }

    public static String getFinalURL(String url) throws IOException {
        HttpURLConnection con = (HttpURLConnection) new URL(url).openConnection();
        con.setInstanceFollowRedirects(false);
        con.connect();
        con.getInputStream();

        if (con.getResponseCode() == HttpURLConnection.HTTP_MOVED_PERM || con.getResponseCode() == HttpURLConnection.HTTP_MOVED_TEMP) {
            String redirectUrl = con.getHeaderField("Location");
            return getFinalURL(redirectUrl);
        }
        return url;
    }

    public static String getUrlFileName(String url){
        String fileName = url ;
        int slashIndex = url.lastIndexOf("/") ;
        if((slashIndex >= 0) && (slashIndex < url.length()-1)){
            fileName = url.substring(slashIndex+1) ;
        }
        return fileName ;
    }


    public static String getThumbnailUrlFromSellSectionItem(SellSectionItemObject sellSectionItem){
        VeamUtil.log("debug","getThumbnailUrlFromSellSectionItem") ;
        String thumbnailUrl = "" ;
        String kind = sellSectionItem.getKind() ;
        ConsoleContents contents = ConsoleUtil.getConsoleContents() ;
        if(contents != null) {
            if (kind.equals(SellSectionItemObject.KIND_VIDEO)) {
                VideoObject video = contents.getVideoForId(sellSectionItem.getContentId()) ;
                if (video != null) {
                    thumbnailUrl = video.getThumbnailUrl();
                }
            } else if (kind.equals(SellSectionItemObject.KIND_PDF)) {
                PdfObject pdfObject = contents.getPdfForId(sellSectionItem.getContentId()) ;
                if (pdfObject != null) {
                    thumbnailUrl = pdfObject.getThumbnailUrl();
                }
            } else if (kind.equals(SellSectionItemObject.KIND_AUDIO)) {
                VeamUtil.log("debug","KIND_AUDIO "+sellSectionItem.getContentId()) ;
                AudioObject audioObject = contents.getAudioForId(sellSectionItem.getContentId()) ;
                if (audioObject != null) {
                    VeamUtil.log("debug","audio found") ;
                    thumbnailUrl = audioObject.getRectangleThumbnailUrl();
                    VeamUtil.log("debug","url="+thumbnailUrl) ;
                }
            }
        }
        return thumbnailUrl ;
    }

    public static String getSellSectionItemKindString(SellSectionItemObject sellSectionItem){
        String kindString = "" ;
        String kind = sellSectionItem.getKind() ;
        if (kind.equals(SellSectionItemObject.KIND_VIDEO)) {
            kindString = "Video" ;
        } else if (kind.equals(SellSectionItemObject.KIND_PDF)) {
            kindString = "PDF" ;
        } else if (kind.equals(SellSectionItemObject.KIND_AUDIO)) {
            kindString = "Audio" ;
        }
        return kindString ;
    }


}
