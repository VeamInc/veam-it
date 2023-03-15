//
//  VeamConsts.h
//  veam31000000
//
//  Created by veam on 5/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#ifndef veam31000000_VeamConsts_h
#define veam31000000_VeamConsts_h

#define VEAM_IS_TEST_PURCHASE   @"1"
//#define VEAM_IS_TEST_PURCHASE   @"0"


//#define VEAM_SERVER_FORMAT  @"https://app-work.veam.co/api2.php/%@/?a=%@&loc=%@&adid=%@"
//#define VEAM_SERVER_FORMAT @"https://app-preview.veam.co/api2.php/%@/?a=%@&loc=%@&adid=%@"
#define VEAM_SERVER_FORMAT @"https://app.veam.co/api2.php/%@/?a=%@&loc=%@&adid=%@"

///////////////////////////////
#ifdef BUILD_VEAM_CONSOLE

#define IS_VEAM_CONSOLE YES
//#define CONSOLE_SERVER_FORMAT  @"https://app-work.veam.co/console.php/%@/?a=%@&loc=%@&ver=%@"
#define CONSOLE_SERVER_FORMAT  @"https://app-preview.veam.co/console.php/%@/?a=%@&loc=%@&ver=%@"

//#define CONSOLE_UPLOAD_SERVER_FORMAT  @"https://console-work.veam.co/api.php/%@/?a=%@&loc=%@&ver=%@"
#define CONSOLE_UPLOAD_SERVER_FORMAT  @"https://console-preview.veam.co/api.php/%@/?a=%@&loc=%@&ver=%@"

#define CONSOLE_CONTENTS_UPDATED_NOTIFICATION_ID    @"CONSOLE_CONTENTS_UPDATED"
#define CONSOLE_REQUEST_POSTED_NOTIFICATION_ID      @"CONSOLE_REQUEST_POSTED"

#define CONSOLE_CONFIGURATION_FILE_NAME            @"console_config.xml"
#define CONSOLE_CONTENTS_FILE_NAME                 @"console_contents.xml"
#define CONSOLE_DEFAULT_CONTENTS_FILE_NAME         @"default_console_contents.xml"
#define CONSOLE_WORK_CONTENTS_FILE_NAME            @"console_contents_work.xml"

#define CONSOLE_API_CALL_VERSION                   @"2"

// Admob for VeamIt!
#define VEAM_ADMOB_UNIT_ID_EXCLUSIVE            @"ca-app-pub-2879481225031994/9169620662"
#define VEAM_ADMOB_UNIT_ID_PLAYLISTCATEGORY     @"ca-app-pub-2879481225031994/1646353865"
#define VEAM_ADMOB_UNIT_ID_PLAYLIST             @"ca-app-pub-2879481225031994/3123087068"
#define VEAM_ADMOB_UNIT_ID_FORUMCATEGORY        @"ca-app-pub-2879481225031994/6076553460"
#define VEAM_ADMOB_UNIT_ID_FORUM                @"ca-app-pub-2879481225031994/7553286662"
#define VEAM_ADMOB_UNIT_ID_FORUM_NATIVE         @"ca-app-pub-2879481225031994/4019536263"
#define VEAM_ADMOB_UNIT_ID_LINKSCATEGORY        @"ca-app-pub-2879481225031994/9030019866"
#define VEAM_ADMOB_UNIT_ID_POSTPICTURE          @"ca-app-pub-2879481225031994/2983486263"
#define VEAM_ADMOB_UNIT_ID_POSTPICTURECOMMENT   @"ca-app-pub-2879481225031994/5936952665"


///////////////////////////////
#else
///////////////////////////////

#define IS_VEAM_CONSOLE NO
#define CONSOLE_SERVER_FORMAT  @""

#define VEAM_ADMOB_UNIT_ID_EXCLUSIVE            @"ca-app-pub-3940256099942544/2934735716"
#define VEAM_ADMOB_UNIT_ID_PLAYLISTCATEGORY     @"ca-app-pub-3940256099942544/2934735716"
#define VEAM_ADMOB_UNIT_ID_PLAYLIST             @"ca-app-pub-3940256099942544/2934735716"
#define VEAM_ADMOB_UNIT_ID_FORUMCATEGORY        @"ca-app-pub-3940256099942544/2934735716"
#define VEAM_ADMOB_UNIT_ID_FORUM                @"ca-app-pub-3940256099942544/2934735716"
#define VEAM_ADMOB_UNIT_ID_FORUM_NATIVE         @"ca-app-pub-3940256099942544/2562852117"
#define VEAM_ADMOB_UNIT_ID_LINKSCATEGORY        @"ca-app-pub-3940256099942544/2934735716"
#define VEAM_ADMOB_UNIT_ID_POSTPICTURE          @"ca-app-pub-3940256099942544/4411468910"
#define VEAM_ADMOB_UNIT_ID_POSTPICTURECOMMENT   @"ca-app-pub-3940256099942544/4411468910"


#endif
///////////////////////////////



#define VEAM_CONFIGURATION_FILE_NAME            @"config.xml"
#define VEAM_CONTENTS_FILE_NAME                 @"contents.xml"
#define VEAM_DEFAULT_CONTENTS_FILE_NAME         @"default_contents.xml"
#define VEAM_WORK_CONTENTS_FILE_NAME            @"contents_work.xml"

#define VEAM_YOUTUBE_CATEGORY_ID_FAVORITES  @"FAVORITES"
#define VEAM_VIDEO_CATEGORY_ID_FAVORITES    @"FAVORITES"
#define VEAM_FORUM_ID_FAVORITES             @"FAVORITES"
#define VEAM_BLOG_CATEGORY_ID_FAVORITES     @"FAVORITES"
#define VEAM_RECIPE_CATEGORY_ID_FAVORITES   @"FAVORITES"
#define VEAM_MIXED_CATEGORY_ID_FAVORITES    @"FAVORITES"
#define VEAM_MIXED_CATEGORY_ID_SUBSCRIPTION @"SUBSCRIPTION"

#define VEAM_FAVORITE_KIND_YOUTUBE  @"VIDEO"
#define VEAM_FAVORITE_KIND_VIDEO    @"DOWNLOAD_VIDEO"
#define VEAM_FAVORITE_KIND_RECIPE   @"RECIPE"
#define VEAM_FAVORITE_KIND_PICTURE  @"PICTURE"
#define VEAM_FAVORITE_KIND_MIXED    @"MIXED"

#define VEAM_QUESTION_ANSWER_KIND_VIDEO     @"1"
#define VEAM_QUESTION_ANSWER_KIND_YOUTUBE   @"2"
#define VEAM_QUESTION_ANSWER_KIND_AUDIO     @"3"

#define VEAM_VIDEO_STATUS_READY             @"0"
#define VEAM_VIDEO_STATUS_WAITING           @"1"
#define VEAM_VIDEO_STATUS_PREPARING         @"2"

#define VEAM_MIXED_STATUS_READY             @"0"
#define VEAM_MIXED_STATUS_WAITING           @"1"
#define VEAM_MIXED_STATUS_PREPARING         @"2"

#define VEAM_SELL_VIDEO_STATUS_READY             @"0"
#define VEAM_SELL_VIDEO_STATUS_WAITING           @"1"
#define VEAM_SELL_VIDEO_STATUS_PREPARING         @"2"
#define VEAM_SELL_VIDEO_STATUS_SUBMITTING        @"3"

#define VEAM_SELL_PDF_STATUS_READY             @"0"
#define VEAM_SELL_PDF_STATUS_WAITING           @"1"
#define VEAM_SELL_PDF_STATUS_PREPARING         @"2"
#define VEAM_SELL_PDF_STATUS_SUBMITTING        @"3"

#define VEAM_SELL_AUDIO_STATUS_READY             @"0"
#define VEAM_SELL_AUDIO_STATUS_WAITING           @"1"
#define VEAM_SELL_AUDIO_STATUS_PREPARING         @"2"
#define VEAM_SELL_AUDIO_STATUS_SUBMITTING        @"3"

#define VEAM_SELL_SECTION_ITEM_STATUS_READY             @"0"
#define VEAM_SELL_SECTION_ITEM_STATUS_WAITING           @"1"
#define VEAM_SELL_SECTION_ITEM_STATUS_PREPARING         @"2"
#define VEAM_SELL_SECTION_ITEM_STATUS_SUBMITTING        @"3"


// 0:released 1:setting 2:veamreview 3:applereview 4:initialized 5:building
#define VEAM_APP_INFO_STATUS_RELEASED       @"0"
#define VEAM_APP_INFO_STATUS_SETTING        @"1"
#define VEAM_APP_INFO_STATUS_MCN_REVIEW     @"2"
#define VEAM_APP_INFO_STATUS_APPLE_REVIEW   @"3"
#define VEAM_APP_INFO_STATUS_INITIALIZED    @"4"
#define VEAM_APP_INFO_STATUS_BUILDING       @"5"

#define VEAM_SELL_ITEM_CATEGORY_KIND_VIDEO  @"1"
#define VEAM_SELL_ITEM_CATEGORY_KIND_PDF    @"2"
#define VEAM_SELL_ITEM_CATEGORY_KIND_AUDIO  @"3"

#define VEAM_SELL_SECTION_CATEGORY_KIND_VIDEO  @"1"
#define VEAM_SELL_SECTION_CATEGORY_KIND_PDF    @"2"
#define VEAM_SELL_SECTION_CATEGORY_KIND_AUDIO  @"3"

#define VEAM_SELL_SECTION_ITEM_KIND_VIDEO  @"1"
#define VEAM_SELL_SECTION_ITEM_KIND_PDF    @"2"
#define VEAM_SELL_SECTION_ITEM_KIND_AUDIO  @"3"



#define VEAM_USER_DEFAULT_KEY_CURRENT_CONTENT_ID  @"CURRENT_CONTENT_ID"
#define VEAM_USER_DEFAULT_KEY_FAVORITE_FORMAT    @"FAVORITE_%@"
#define USERDEFAULT_KEY_VEAM_ID    @"VEAM_UNIQUE_ID"
#define USERDEFAULT_KEY_SOCIAL_USER_ID    @"SOCIAL_USER_ID"
#define USERDEFAULT_KEY_SOCIAL_USER_KIND    @"SOCIAL_USER_KIND"
#define USERDEFAULT_KEY_TWITTER_USER_NAME    @"TWITTER_USER_NAME"
#define USERDEFAULT_KEY_FACEBOOK_USER_NAME    @"FACEBOOK_USER_NAME"
#define USERDEFAULT_KEY_EMAIL_USER_NAME    @"EMAIL_USER_NAME"
#define USERDEFAULT_KEY_EMAIL_PASSWORD    @"EMAIL_PASSWORD"
#define USERDEFAULT_KEY_STORE_RECEIPT_FORMAT    @"STORE_RECEIPT_%d"
#define USERDEFAULT_KEY_SUBSCRIPTION_START_TIME_FORMAT @"SUBSCRIPTION_START_TIME_%d"
#define USERDEFAULT_KEY_SUBSCRIPTION_END_TIME_FORMAT @"SUBSCRIPTION_END_TIME_%d"



#define SOCIAL_USER_KIND_TWITTER    1
#define SOCIAL_USER_KIND_FACEBOOK   2
#define SOCIAL_USER_KIND_EMAIL      3


#define VEAM_DEFAULT_COMMENT_COUNT  3
#define VEAM_VIEW_COMMENT_SCHEMA        @"viewallcomments"
#define VEAM_CLOSE_COMMENT_SCHEMA       @"closeallcomments"


//// Configurations
#define VEAM_CONFIG_MCN_ID  @"mcn_id"
#define VEAM_CONFIG_APP_ID  @"app_id"
#define VEAM_CONFIG_BASE_TEXT_COLOR  @"base_text_color_argb"
#define VEAM_CONFIG_BASE_BACKGROUND  @"base_background_color_argb"
#define VEAM_CONFIG_TOP_BAR_HEIGHT  @"top_bar_height"
#define VEAM_CONFIG_TOP_BAR_TITLE_FONT_SIZE  @"top_bar_title_font_size"
#define VEAM_CONFIG_TOP_BAR_TITLE_FONT  @"top_bar_title_font"
#define VEAM_CONFIG_TOP_BAR_TITLE_COLOR  @"top_bar_title_color_argb"
#define VEAM_CONFIG_TOP_BAR_COLOR  @"top_bar_color_argb"
#define VEAM_CONFIG_TABLE_SELECTION_COLOR  @"table_selection_color_argb"
#define VEAM_CONFIG_NUMBER_OF_TABS  @"number_of_tabs"
#define VEAM_CONFIG_NEW_VIDEOS_TEXT_COLOR  @"new_videos_text_color_argb"
#define VEAM_CONFIG_NEW_VIDEOS_TEXT  @"new_videos_text"
#define VEAM_CONFIG_APP_NAME  @"app_name"
#define VEAM_CONFIG_TEMPLATE_IDS  @"template_ids"
#define VEAM_CONFIG_TAB_TITLE_FORMAT  @"tab_title_%@"
#define VEAM_CONFIG_TAB_TEXT_COLOR  @"tab_text_color_argb"
#define VEAM_CONFIG_TEMPLATE_TITLE_FORMAT  @"template_title_%@"
#define VEAM_CONFIG_SUBSCRIPTION_PRICE_FORMAT  @"subscription_price_%d"
#define VEAM_CONFIG_SUBSCRIPTION_EMBEDED_DESCRIPTION_FORMAT  @"subscription_%d_embeded_description"
#define VEAM_CONFIG_SUBSCRIPTION_INDEX @"subscription_index"
#define VEAM_CONFIG_SUBSCRIPTION_DESCRIPTION_FORMAT @"subscription_%d_description"
#define VEAM_CONFIG_SUBSCRIPTION_NOTE_FORMAT @"subscription_%d_note"
#define VEAM_CONFIG_SUBSCRIPTION_LINK_FORMAT @"subscription_%d_link"
#define VEAM_CONFIG_SUBSCRIPTION_BUTTON_TEXT_FORMAT @"subscription_%d_button_text"
#define VEAM_CONFIG_QA_HEADER_BACKGROUND_COLOR  @"qa_header_background_color_argb"
#define VEAM_CONFIG_QA_HEADER_TEXT_COLOR  @"qa_header_text_color_argb"
#define VEAM_CONFIG_QA_HEADER_HIGHLIGHT_COLOR  @"qa_header_highlight_color_argb"
#define VEAM_CONFIG_SEPARATOR_COLOR  @"separator_color_argb"
#define VEAM_CONFIG_QA_HEADER_TITLE  @"qa_header_title"
#define VEAM_CONFIG_QA_HEADER_SUB_TITLE  @"qa_header_sub_title"
#define VEAM_CONFIG_QA_HEADER_ASK_BUTTON_TITLE  @"qa_header_ask_button_title"
#define VEAM_CONFIG_QA_HEADER_VOTE_BUTTON_TITLE  @"qa_header_vote_button_title"
#define VEAM_CONFIG_QA_HEADER_RANKING_BUTTON_TITLE  @"qa_header_ranking_button_title"
#define VEAM_CONFIG_QA_HEADER_ANSWER_BUTTON_TITLE  @"qa_header_answer_button_title"
#define VEAM_CONFIG_GRID_YEAR_TEXT_COLOR  @"grid_year_text_color_argb"
#define VEAM_CONFIG_ACTIVITY_INDICATOR_STYLE  @"activity_indicator_style"
#define VEAM_CONFIG_CALENDAR_TITLE  @"calendar_title"
#define VEAM_CONFIG_CALENDAR_MONTHLY_CONTENT_TITLE  @"calendar_monthly_content_title"
#define VEAM_CONFIG_NUMBER_OF_GOOD_JOB_IMAGES  @"number_of_good_job_images"
#define VEAM_CONFIG_EXCLUSIVE_TOP_LEFT_COLOR @"exclusive_top_left_color"
#define VEAM_CONFIG_EXCLUSIVE_TOP_LEFT_TEXT_COLOR @"exclusive_top_left_text_color"
#define VEAM_CONFIG_CALENDAR_WEEKDAY_BACK_COLOR @"calendar_weekday_back_color"
#define VEAM_CONFIG_TOP_BAR_ACTION_TEXT_COLOR @"top_bar_action_text_color"
#define VEAM_CONFIG_CALENDAR_LINE_COLOR @"calendar_line_color"
#define VEAM_CONFIG_CALENDAR_TEXT_COLOR @"calendar_text_color"
#define VEAM_CONFIG_CALENDAR_TODAY_COLOR @"calendar_today_color"
#define VEAM_CONFIG_CALENDAR_DEFAULT_WORKOUT_TITLE @"calendar_default_workout_title"
#define VEAM_CONFIG_STORED_ALTERNATIVE_IMAGE_IDS @"stored_alternative_image_ids"
#define VEAM_CONFIG_SKIP_INITIAL @"skip_initial"



#define VEAM_TEMPLATE_ID_YOUTUBE_LIST               @"1"
#define VEAM_TEMPLATE_ID_FORUM                      @"2"
#define VEAM_TEMPLATE_ID_WEB_LIST                   @"3"
#define VEAM_TEMPLATE_ID_BLOG                       @"4"
#define VEAM_TEMPLATE_ID_RECIPE                     @"5"
#define VEAM_TEMPLATE_ID_UNLISTED_YOUTUBE_LIST      @"6"
#define VEAM_TEMPLATE_ID_MIXED                      @"7"
#define VEAM_TEMPLATE_ID_SUBSCRIPTION               @"8"
#define VEAM_TEMPLATE_ID_WEB_LIST_CAT1              @"9"

#define VEAM_SUBSCRIPTION_LAYOUT_LIST               @"1"
#define VEAM_SUBSCRIPTION_LAYOUT_GRID               @"2"

#define VEAM_SUBSCRIPTION_KIND_VIDEOS               @"1"
#define VEAM_SUBSCRIPTION_KIND_QA                   @"2"
#define VEAM_SUBSCRIPTION_KIND_CALENDAR             @"3"
#define VEAM_SUBSCRIPTION_KIND_MIXED_GRID           @"4"
#define VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS          @"5"
#define VEAM_SUBSCRIPTION_KIND_SELL_SECTION         @"6"


#define VEAM_SCREEN_STATUS_INITIAL          1
#define VEAM_SCREEN_STATUS_TAB              2
#define VEAM_SCREEN_STATUS_CAMERA           3
#define VEAM_SCREEN_STATUS_MOVIE            4
#define VEAM_SCREEN_STATUS_SETTINGS         5
#define VEAM_SCREEN_STATUS_RECIPE_DETAIL    6
#define VEAM_SCREEN_STATUS_CONSOLE          7
#define VEAM_SCREEN_STATUS_AUDIO            8
#define VEAM_SCREEN_STATUS_EMAIL_SESSION    9

#define VEAM_TOP_BAR_ICON_NORMAL    1
#define VEAM_TOP_BAR_ICON_CIRCLE    2


#define VEAM_SETTINGS_DONE_WIDTH    50.0

#define VEAM_YOUTUBE_KIND_NORMAL    @"1"
#define VEAM_YOUTUBE_KIND_WEB       @"2"
#define VEAM_YOUTUBE_KIND_IMAGE     @"3"
#define VEAM_YOUTUBE_KIND_POPUP     @"4"

/*
#define VEAM_YOUTUBE_CATEGORY_KIND_NORMAL       @"0"
#define VEAM_YOUTUBE_CATEGORY_KIND_UNLISTED     @"1"
 */

#define VEAM_SPECIAL_FORUM_ID_MY_POST       @"MYPOST"
#define VEAM_SPECIAL_FORUM_ID_USER_POST     @"USERPOST"
#define VEAM_SPECIAL_FORUM_ID_FAVORITES     @"FAVORITES"
#define VEAM_SPECIAL_FORUM_ID_FOLLOWINGS    @"FOLLOWINGS"

#define VEAM_FORUM_KIND_MY_POSTS            @"0"
#define VEAM_FORUM_KIND_NORMAL              @"1"
#define VEAM_FORUM_KIND_HOT                 @"2"
#define VEAM_FORUM_KIND_SWATCH              @"3"
#define VEAM_FORUM_KIND_BEFORE_AFTER        @"4"
//#define VEAM_FORUM_KIND_                  @"5"
#define VEAM_FORUM_KIND_RESTRICTED          @"6"


#define VEAM_ALERT_VIEW_LOGIN_SELECTOR  1
#define VEAM_ALERT_VIEW_UPDATE_CHECK    2

#define VEAM_FOLLOW_KIND_FOLLOWINGS     1
#define VEAM_FOLLOW_KIND_FOLLOWERS      2
#define VEAM_FOLLOW_KIND_PICTURE_LIKER  3

#define VEAM_INITIAL_BOTTOM_BAR_HEIGHT 49.5

#define VEAM_VIDEO_KIND_NORMAL          @"5"
#define VEAM_VIDEO_KIND_PERIODICAL      @"6"

#define VEAM_SHORTHAND_MONTH_FORMAT_3CHAR   1
#define VEAM_SHORTHAND_MONTH_FORMAT_MAX5    2

#define VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL  1

#define VEAM_SUBSCRIPTION_PRODUCT_ID_FORMAT            @"co.veam.veam%@.subscription%d.1m"

#define VEAM_STORE_RECEIPT_VERIFY_SUCCESS   1
#define VEAM_STORE_RECEIPT_VERIFY_FAILED    2
#define VEAM_STORE_RECEIPT_VERIFY_EXPIRED   3


#define VEAM_DATE_STRING_MONTH_DAY          1
#define VEAM_DATE_STRING_MONTH_DAY_YEAR     2

#define VEAM_CALENDAR_LABEL_WIDTH  36.0
#define VEAM_CALENDAR_LABEL_GAP  7.0
#define VEAM_CALENDAR_DOT_WIDTH  5.0

/*
#define VEAM_KIIP_PICTURE_FAVORITE          @"PictureFavorite"
#define VEAM_KIIP_PICTURE_LIKE              @"PictureLike"
#define VEAM_KIIP_PICTURE_COMMENT           @"PictureComment"
#define VEAM_KIIP_USER_FOLLOW               @"UserFollow"
#define VEAM_KIIP_YOUTUBE_FAVORITE          @"YoutubeFavorite"
#define VEAM_KIIP_YOUTUBE_CATEGORY          @"YoutubeCategory"
#define VEAM_KIIP_FORUM_CATEGORY            @"ForumCategory"
#define VEAM_KIIP_LINK_LIST                 @"LinkList"
 */


//////////////////// CONSOLE /////////////////////////
#define VEAM_CONSOLE_FOOTER_HEIGHT  90.0
#define VEAM_CONSOLE_HEADER_HEIGHT  45.0

#define VEAM_CONSOLE_ELEMENT_WIDTH      75.0
#define VEAM_CONSOLE_ELEMENT_HEIGHT     85.0
#define VEAM_CONSOLE_ELEMENT_ICON_SIZE  60.0

#define VEAM_CONSOLE_BAR_LEFT_MARGIN    15.0

#define CONSOLE_TABLE_SEPARATOR_MARGIN  15
#define CONSOLE_TABLE_SEPARATOR_COLOR   @"FFB5B5B5"

#define VEAM_CONSOLE_HEADER_STYLE_NONE              0x00000000
#define VEAM_CONSOLE_HEADER_STYLE_CLOSE             0x00000001
#define VEAM_CONSOLE_HEADER_STYLE_BACK              0x00000002
#define VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE        0x00000004
#define VEAM_CONSOLE_HEADER_STYLE_CENTER_TITLE      0x00000008
#define VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT        0x00000010
#define VEAM_CONSOLE_HEADER_STYLE_6                 0x00000020
#define VEAM_CONSOLE_HEADER_STYLE_7                 0x00000040
#define VEAM_CONSOLE_HEADER_STYLE_8                 0x00000080
#define VEAM_CONSOLE_HEADER_STYLE_9                 0x00000100
#define VEAM_CONSOLE_HEADER_STYLE_10                0x00000200
#define VEAM_CONSOLE_HEADER_STYLE_11                0x00000400
#define VEAM_CONSOLE_HEADER_STYLE_12                0x00000800
#define VEAM_CONSOLE_HEADER_STYLE_13                0x00001000
#define VEAM_CONSOLE_HEADER_STYLE_14                0x00002000
#define VEAM_CONSOLE_HEADER_STYLE_15                0x00004000
#define VEAM_CONSOLE_HEADER_STYLE_16                0x00008000
#define VEAM_CONSOLE_HEADER_STYLE_17                0x00010000
#define VEAM_CONSOLE_HEADER_STYLE_18                0x00020000
#define VEAM_CONSOLE_HEADER_STYLE_19                0x00040000
#define VEAM_CONSOLE_HEADER_STYLE_20                0x00080000

#define VEAM_CONSOLE_SETTING_MODE   1
#define VEAM_CONSOLE_UPLOAD_MODE    2

#define VEAM_CONSOLE_KEY_USERNAME           @"VEAM_CONSOLE_USERNAME"
#define VEAM_CONSOLE_KEY_PASSWORD           @"VEAM_CONSOLE_PASSWORD"
#define VEAM_CONSOLE_KEY_USER_PRIVILAGES    @"VEAM_CONSOLE_USER_PRIVILAGES"
#define VEAM_CONSOLE_KEY_APP_SECRET         @"VEAM_CONSOLE_APP_SECRET"
#define VEAM_CONSOLE_KEY_APP_ID             @"VEAM_CONSOLE_APP_ID"
#define VEAM_CONSOLE_KEY_MCN_ID             @"VEAM_CONSOLE_MCN_ID"
#define VEAM_CONSOLE_KEY_TUTORIAL_DONE      @"VEAM_CONSOLE_TUTORIAL_DONE"

#define VEAM_CONSOLE_USER_PRIVILAGE_CONTENTS_WRITE  0x00000001
#define VEAM_CONSOLE_USER_PRIVILAGE_VEAM_MENU       0x00000002


// 1:recipe 2:mini-blog 3:picture 4:unlisted-youtube 5:video 6:audio
#define VEAM_CONSOLE_MIXED_KIND_YEAR                                @"-1"
#define VEAM_CONSOLE_MIXED_KIND_RECIPE                              @"1"
#define VEAM_CONSOLE_MIXED_KIND_MINI_BLOG                           @"2"
#define VEAM_CONSOLE_MIXED_KIND_PICTURE                             @"3"
#define VEAM_CONSOLE_MIXED_KIND_UNLISTED_YOUTUBE                    @"4"
#define VEAM_CONSOLE_MIXED_KIND_VIDEO                               @"5"
#define VEAM_CONSOLE_MIXED_KIND_AUDIO                               @"6"
#define VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO            @"7"
#define VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO       @"8"
#define VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO            @"9"
#define VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO       @"10"
#define VEAM_CONSOLE_MIXED_KIND_YOUTUBE                             @"11"


#define VEAM_QUESTION_ANSWER_KIND_FIXED_VIDEO           @"7"
#define VEAM_QUESTION_ANSWER_KIND_PERIODICAL_VIDEO      @"8"
#define VEAM_QUESTION_ANSWER_KIND_FIXED_AUDIO           @"9"
#define VEAM_QUESTION_ANSWER_KIND_PERIODICAL_AUDIO      @"10"
#define VEAM_QUESTION_ANSWER_KIND_FREE_VIDEO            @"11"
#define VEAM_QUESTION_ANSWER_KIND_FREE_AUDIO            @"12"

#endif
