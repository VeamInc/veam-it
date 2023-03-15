//
//  VeamUtil.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forum.h"
#import "YoutubeCategory.h"
#import "Youtube.h"
#import "MixedCategory.h"
#import "Mixed.h"
#import "Recipe.h"
#import "SellItemCategory.h"
#import "SellSectionCategory.h"
#import "PdfCategory.h"
#import "Pdf.h"
#import "VideoCategory.h"
#import "Video.h"
#import "SellVideo.h"
#import "SellPdf.h"
#import "SellAudio.h"
#import "AudioCategory.h"
#import "Audio.h"
#import "Questions.h"
#import "Question.h"
#import "SellSectionItem.h"


#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADRequest.h>
#endif



@interface VeamUtil : NSObject

+ (BOOL)isVeamConsole ;

// Directory and File
+ (BOOL)isEmpty:(NSString *)string ;
+ (NSString *)applicationCachesDirectory ;
+ (NSString *)getFilePathAtCachesDirectory:(NSString *)fileName ;
+ (BOOL)moveFile:(NSString *)fromPath toPath:(NSString *)toPath ;
+ (BOOL)fileExistsAtCachesDirectory:(NSString *)fileName ;
+ (BOOL)fileExists:(NSString *)fileName ;
+ (NSInteger)fileSizeOf:(NSString *)fileName ;
+ (NSInteger)fileSizeAtCachesDirectory:(NSString *)fileName ;
+ (void)removeVideoFile:(NSString *)videoId ;
+ (BOOL)videoExists:(Video *)video ;

// User defaults
+ (void)setUserDefaultString:(NSString *)key value:(NSString *)value ;
+ (NSString *)getUserDefaultString:(NSString *)key ;
+ (void)setFavoritesForKind:(NSString *)kind value:(NSString *)value ;
+ (NSString *)getFavoritesForKind:(NSString *)kind ;
+ (BOOL)isFavoriteForKind:(NSString *)kind targetId:(NSString *)targetId ;
+ (void)addFavoriteForKind:(NSString *)kind targetId:(NSString *)targetId ;
+ (void)deleteFavoriteForKind:(NSString *)kind targetId:(NSString *)targetId ;
+ (BOOL)isFavoriteYoutube:(NSString *)youtubeId ;
+ (void)addFavoriteYoutube:(NSString *)youtubeId ;
+ (void)deleteFavoriteYoutube:(NSString *)youtubeId ;
+ (BOOL)isFavoriteVideo:(NSString *)videoId ;
+ (void)addFavoriteVideo:(NSString *)videoId ;
+ (void)deleteFavoriteVideo:(NSString *)videoId ;
+ (BOOL)isFavoriteRecipe:(NSString *)recipeId ;
+ (void)addFavoriteRecipe:(NSString *)recipeId ;
+ (void)deleteFavoriteRecipe:(NSString *)recipeId ;
+ (BOOL)isFavoriteMixed:(NSString *)mixedId ;
+ (void)addFavoriteMixed:(NSString *)mixedId ;
+ (void)deleteFavoriteMixed:(NSString *)mixedId ;
+ (BOOL)isFavoritePicture:(NSString *)pictureId ;
+ (void)addFavoritePicture:(NSString *)pictureId ;
+ (void)deleteFavoritePicture:(NSString *)pictureId ;
+ (void)setStoreReceipt:(NSString *)storeReceipt index:(NSInteger)index ;
+ (NSString *)getStoreReceipt:(NSInteger)index ;
+ (void)setSubscriptionStartTime:(NSString *)startTime index:(NSInteger)index ;
+ (NSString *)getSubscriptionStartTime:(NSInteger)index ;
+ (void)setSubscriptionEndTime:(NSString *)endTime index:(NSInteger)index ;
+ (NSString *)getSubscriptionEndTime:(NSInteger)index ;
+ (NSInteger)getSubscriptionIndex ;
+ (NSString *)getSubscriptionPrice:(NSInteger)index ;
+ (void)setQuestionString:(NSString *)questionString questionId:(NSString *)questionId ;
+ (NSString *)getQuestionStringForQuestionId:(NSString *)questionId ;
+ (void)setQuestionIds:(NSMutableArray *)questionIds ;
+ (NSArray *)getQuestionIds ;
+ (UIActivityIndicatorViewStyle)getActivityIndicatorViewStyle ;
+ (NSInteger)getNumberOfGoodJobImages ;




// Utility
+ (NSURL *)getApiUrl:(NSString *)apiName ;
+ (NSString *)getSecureUrl:(NSString *)urlString ;
+ (CGFloat)getTopBarHeight ;
+ (CGFloat)getTopBarTitleFontSize ;
+ (NSString *)getTopBarTitleFont ;
+ (UIColor *)getTopBarTitleColor ;
+ (UIColor *)getTopBarColor ;
+ (UIColor *)getTabTextColor ;
+ (UIColor *)getBaseTextColor ;
+ (UIColor *)getBackgroundColor ;
+ (CGFloat)getScreenWidth ;
+ (CGFloat)getScreenHeight ;
+ (BOOL)isShortDevice ;
+ (CGFloat)getViewTopOffset ;
+ (CGFloat)getStatusBarHeight ;
+ (NSString *)makeScreenName:(NSString *)viewName ;
+ (UIColor *)getColorFromArgbString:(NSString *)argbString ;
+ (NSString *)getArgbStringFromColor:(UIColor *)color ;
+ (void)registerTapAction:(UIView *)view target:(id)target selector:(SEL)selector ;
+ (void)showCameraView:(NSString *)forumId ;
+ (void)showSettingsView ;
+ (NSString *)getTrackingId ;
+ (NSInteger)getNumberOfForums ;
+ (Forum *)getForumAt:(NSInteger)index ;
+ (NSInteger)getNumberOfYoutubeCategories ;
+ (BOOL)isAllYoutubeCategoryEmbed ;
+ (YoutubeCategory *)getYoutubeCategoryAt:(NSInteger)index ;
+ (NSArray *)getYoutubeSubCategories:(NSString *)categoryId ;
+ (Youtube *)getYoutubeForId:(NSString *)youtubeId ;

+ (NSInteger)getNumberOfMixedCategories ;
+ (MixedCategory *)getMixedCategoryAt:(NSInteger)index ;
+ (NSArray *)getMixedSubCategories:(NSString *)categoryId ;
+ (Mixed *)getMixedForId:(NSString *)mixedId ;
+ (NSArray *)getMixedsForSubscription:(BOOL)includeYearObject ;


+ (NSInteger)getNumberOfVideoCategories ;
+ (Video *)getVideoForId:(NSString *)videoId ;
+ (VideoCategory *)getVideoCategoryAt:(NSInteger)index ;
+ (VideoCategory *)getVideoCategoryForId:(NSString *)videoCategoryId ;
+ (NSArray *)getVideoSubCategories:(NSString *)categoryId ;

+ (NSInteger)getNumberOfPdfCategories ;
+ (Pdf *)getPdfForId:(NSString *)pdfId ;
+ (PdfCategory *)getPdfCategoryAt:(NSInteger)index ;
+ (PdfCategory *)getPdfCategoryForId:(NSString *)pdfCategoryId ;

+ (NSInteger)getNumberOfSellItemCategories ;
+ (SellItemCategory *)getSellItemCategoryAt:(NSInteger)index ;
+ (SellItemCategory *)getSellItemCategoryForId:(NSString *)sellItemCategoryId ;

+ (NSInteger)getNumberOfSellSectionCategories ;
+ (SellSectionCategory *)getSellSectionCategoryAt:(NSInteger)index ;
+ (SellSectionCategory *)getSellSectionCategoryForId:(NSString *)sellSectionCategoryId ;


+ (NSInteger)getNumberOfAudioCategories ;
+ (Audio *)getAudioForId:(NSString *)audioId ;
+ (AudioCategory *)getAudioCategoryAt:(NSInteger)index ;
+ (AudioCategory *)getAudioCategoryForId:(NSString *)audioCategoryId ;
+ (NSArray *)getAudioSubCategories:(NSString *)categoryId ;

+ (NSArray *)getSellPdfsForCategory:(NSString *)audioCategoryId ;
+ (NSArray *)getSellPdfs ;
+ (NSString *)getSellPdfReceiptKey:(NSString *)sellPdfId ;
+ (void)setSellPdfReceipt:(NSString *)sellPdfReceipt sellPdfId:(NSString *)sellPdfId ;
+ (NSString *)getSellPdfReceipt:(NSString *)sellPdfId ;
+ (NSInteger)verifySellPdfReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced ;
+ (BOOL)isSellPdfProduct:(NSString *)productId ;
+ (SellPdf *)getSellPdfForProduct:(NSString *)productId ;
+ (void)setSellPdfPurchased:(BOOL)sellPdfPurchased ;
+ (BOOL)getSellPdfPurchased ;

+ (NSString *)getPdfUrlKey:(NSString *)audioId ;
+ (void)setPdfUrl:(NSString *)audioUrl audioId:(NSString *)audioId ;
+ (NSString *)getPdfUrl:(NSString *)audioId ;
+ (NSString *)getPdfTokenKey:(NSString *)audioId ;
+ (void)setPdfToken:(NSString *)pdfToken pdfId:(NSString *)pdfId ;
+ (NSString *)getPdfToken:(NSString *)audioId ;





+ (NSInteger)getNumberOfAnswers ;
+ (Question *)getAnswerAt:(NSInteger)index ;
+ (Questions *)getAnswers ;

+ (NSArray *)getRecipeCategories ;
+ (NSArray *)getRecipes:(NSString *)recipeCategoryId ;
+ (Recipe *)getRecipeForId:(NSString *)recipeId ;
+ (NSInteger)getnumberOfWebs:(NSString *)categoryId ;
+ (NSArray *)getWebs:(NSString *)categoryId ;
+ (UIImage *)getCachedImage:(NSString *)urlString downloadIfNot:(BOOL)downloadIfNot ;
+ (void)storeCachedImage:(NSString *)urlString data:(NSData *)data ;
+ (CGFloat)getTabBarHeight ;
+ (UIColor *)getTableSelectionColor ;
+ (NSInteger)getNumberOfTabs ;
+ (void)showTabBarController:(NSInteger)selectedTab ;
+ (void)setTabBarControllerIndex:(NSInteger)index ;
+ (BOOL)isConnected ;
+ (void)dispNotConnectedError ;
+ (NSArray *)getYoutubesForCategory:(NSString *)categoryId ;
+ (NSArray *)getYoutubesForSubCategory:(NSString *)subCategoryId ;
+ (NSArray *)getVideosForCategory:(NSString *)categoryId ;
+ (NSArray *)getVideosForSubCategory:(NSString *)subCategoryId ;
+ (NSArray *)getAudiosForCategory:(NSString *)categoryId ;
+ (NSArray *)getAudiosForSubCategory:(NSString *)subCategoryId ;
+ (NSArray *)getMixedsForCategory:(NSString *)categoryId ;
+ (NSArray *)getMixedsForSubCategory:(NSString *)subCategoryId ;

+ (NSString *)getDurationString:(NSString *)durationInSec ;
+ (NSString *)getYoutubeImageUrl:(NSString *)youtubeVideoId ;
+ (void)dispError:(NSString *)message ;
+ (NSString *)urlEncode:(NSString *)value ;
+ (NSString *)sha1:(NSString*)input ;
+ (NSString *)getUid ;
+ (void)setSocialUserId:(NSInteger)socialUserId ;
+ (NSInteger)getSocialUserId ;
+ (void)setPicturePosted:(BOOL)picturePosted ;
+ (BOOL)getPicturePosted ;
+ (void)setQuestionPosted:(BOOL)questionPosted ;
+ (BOOL)getQuestionPosted ;
+ (void)setRewardString:(NSString *)rewardString ;
+ (NSString *)getRewardString ;
+ (void)setDescriptionPosted:(BOOL)descriptionPosted ;
+ (BOOL)getDescriptionPosted ;
+ (UIColor *)getNewVideosTextColor ;
+ (UIColor *)getTopBarActionTextColor ;
+ (NSString *)getNewVideosText ;
+ (void)setSocialUserKind:(NSInteger)socialUserKind ;
+ (NSInteger)getSocialUserKind ;
+ (void)logoutFromSocial ;
+ (BOOL)isLoggedIn ;
+ (void)openTwitterSession ;
+ (void)openFacebookSession ;
+ (void)openEmailSession ;
- (void)backFromEmailLogin ;
+ (void)login ;
+ (void)loginWithFacebook:(NSString *)facebookId name:(NSString *)name ;
+ (void)loginWithTwitter:(NSString *)twitterId name:(NSString *)name user:(NSString *)user imageUrl:(NSString *)imageUrl ;
+ (void)loginWithEmail:(NSString *)emailUserId name:(NSString *)name secret:(NSString *)secret ;
+ (NSString *)getTimeDescription:(NSString *)unixTimeString ;
+ (NSString *)getSocialUserName ;
+ (void)dispMessage:(NSString *)message title:(NSString *)title ;
+ (NSString *)getAppName ;
+ (NSString *)getAppId ;
+ (NSString *)getMcnId ;
+ (BOOL)isRunningOnIpad ;
+ (BOOL)isPurchasing ;
+ (void)setIsPurchasing:(BOOL)isPurchasing ;
+ (void)setTwitterUserName:(NSString *)twitterUserName ;
+ (NSString *)getTwitterUserName ;
+ (void)setFacebookUserName:(NSString *)facebookUserName ;
+ (NSString *)getFacebookUserName ;
+ (NSString *)getContentsUpdateNotificationId ;
+ (void)postContentsUpdateNotification ;
+ (NSArray *)getTemplateIds ;
+ (NSString *)getTabTitleFor:(NSString *)templateId ;
+ (NSString *)getTemplateTitleFor:(NSString *)templateId ;
+ (UIImage *)getSquareImage:(UIImage *)image ;
+ (UIImage *)imageNamed:(NSString *)imageName ;
+ (UIImage *)getUpdatedImage:(NSString *)urlString ;
+ (void)storeUpdatedImage:(NSString *)urlString data:(NSData *)data ;
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height backgroundColor:(UIColor *)backgroundColor ;
+ (UIViewController *)createViewControllerFor:(NSString *)templateId ;
+ (NSString *)getNameForMonth:(NSInteger)month ;
+ (NSString *)getShorthandForWeekday:(NSInteger)weekday format:(NSInteger)format ;
+ (NSString *)getShorthandForMonth:(NSInteger)month format:(NSInteger)format ;
+ (void)playVideo:(Video *)video title:(NSString *)title ;
+ (void)playAudio:(Audio *)audio title:(NSString *)title ;
+ (void)setMovieKey:(NSString *)key ;
+ (NSString *)getSubscriptionProductId:(NSInteger)index ;
+ (NSString *)base64Encode:(const uint8_t *)input length:(NSInteger)length ;
+ (NSData*)base64Decode:(NSString*)string ;
+ (NSString *)bbDecode:(NSString *)encodedString ;
+ (NSInteger)verifySubscriptionReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced ;
+ (BOOL)receiptIsExpired:(NSData *)receipt ;
+ (BOOL)isSubscriptionBought:(NSInteger)index ;
+ (BOOL)isSubscriptionFree ;
+ (NSString *)getConfigurationString:(NSString *)key default:(NSString *)defaultValue ;
+ (NSString *)getDateString:(NSNumber *)timeFrom1970 format:(NSInteger)format ;
+ (NSString *)getMessageDateString:(NSString *)timeFrom1970 ;
+ (NSString *)getMessageTimeString:(NSString *)timeFrom1970 ;
+ (NSInteger)getYear:(NSNumber *)timeFrom1970 ;
+ (void)setTextWithLineHeight:(UILabel *)label text:(NSString *)text lineHeight:(CGFloat)lineHeight ;
+ (NSString *)getShortTimeDescription:(NSString *)unixTimeString ;
+ (UIColor *)getSeparatorColor ;
+ (NSString *)getAnswerDateString:(NSString *)timeFrom1970 ;
+ (UIColor *)getQuestionHeaderColor ;
+ (UIColor *)changeColor:(UIColor *)color alpha:(CGFloat)targetAlpha ;
+ (void)setShouldShowCalendar:(BOOL)shouldShowCalendar ;
+ (BOOL)getShouldShowCalendar ;
+ (NSInteger)getSubscriptionStartYear:(NSInteger)index ;
+ (NSInteger)getSubscriptionStartMonth:(NSInteger)index ;
+ (NSInteger)getSubscriptionStartDay:(NSInteger)index ;
+ (NSDateComponents *)getCurrentDateComponents ;
+ (void)setCalendarYear:(NSInteger)year month:(NSInteger)month ;
+ (NSInteger)getCalendarYear ;
+ (NSInteger)getCalendarMonth ;
+ (void)setWorkoutDone:(NSInteger)year month:(NSInteger)month day:(NSInteger)day index:(NSInteger)index done:(BOOL)done ;
+ (BOOL)getWorkoutDone:(NSInteger)year month:(NSInteger)month day:(NSInteger)day index:(NSInteger)index ;

+ (UIColor *)getCalendarTextColor ;
+ (UIColor *)getCalendarLineColor ;
+ (UIColor *)getCalendarTodayColor ;
+ (NSString *)getCalendarDefaultWorkoutTitle ;
+ (NSString *)getSkipInitial ;
+ (UIImage*)cropImage:(UIImage *)image toRect:(CGRect)rect ;
+ (BOOL)isStoredAlternativeImage:(NSString *)alternativeImageId ;

+ (NSArray *)getYoutubeExclusionUrls ;

+ (void)showSideMenu:(BOOL)launchFromPreview ;
+ (void)hideSideMenu ;
+ (void)showFloatingMenu:(NSArray *)elements delegate:(id)delegate ;
+ (void)showFloatingMenuWithClassName:(NSString *)className instance:(id)instance ;
+ (void)hideFloatingMenu ;
+ (void)backToPreview ;
+ (void)didTapFloatingMenu:(NSInteger)index ;
+ (void)showStats ;

+ (NSString *)getTranslatedString:(NSString *)string ;
+ (BOOL)isLocaleJapanese ;
+ (NSString *)getLanguageId ;

+ (NSArray *)getSellVideos ;
+ (NSArray *)getSellVideosForCategory:(NSString *)videoCategoryId ;
+ (NSString *)getSellVideoReceiptKey:(NSString *)sellVideoId ;
+ (void)setSellVideoReceipt:(NSString *)sellVideoReceipt sellVideoId:(NSString *)sellVideoId ;
+ (NSString *)getSellVideoReceipt:(NSString *)sellVideoId ;
+ (NSInteger)verifySellVideoReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced ;
+ (BOOL)isSellVideoProduct:(NSString *)productId ;
+ (SellVideo *)getSellVideoForProduct:(NSString *)productId ;
+ (void)setSellVideoPurchased:(BOOL)sellVideoPurchased ;
+ (BOOL)getSellVideoPurchased ;

+ (NSArray *)getSellAudiosForCategory:(NSString *)pdfCategoryId ;
+ (NSArray *)getSellAudios ;
+ (NSString *)getSellAudioReceiptKey:(NSString *)sellAudioId ;
+ (void)setSellAudioReceipt:(NSString *)sellAudioReceipt sellAudioId:(NSString *)sellAudioId ;
+ (NSString *)getSellAudioReceipt:(NSString *)sellAudioId ;
+ (NSInteger)verifySellAudioReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced ;
+ (BOOL)isSellAudioProduct:(NSString *)productId ;
+ (SellAudio *)getSellAudioForProduct:(NSString *)productId ;
+ (void)setSellAudioPurchased:(BOOL)sellAudioPurchased ;
+ (BOOL)getSellAudioPurchased ;

+ (NSString *)getAudioUrlKey:(NSString *)pdfId ;
+ (void)setAudioUrl:(NSString *)pdfUrl pdfId:(NSString *)pdfId ;
+ (NSString *)getAudioUrl:(NSString *)pdfId ;
+ (NSString *)getAudioTokenKey:(NSString *)pdfId ;
+ (void)setAudioToken:(NSString *)pdfToken pdfId:(NSString *)pdfId ;
+ (NSString *)getAudioToken:(NSString *)pdfId ;

+ (NSString *)getPaymentTypeString:(NSString *)paymentTypeId price:(NSString *)price ;

+ (NSArray *)getSellSectionItemsForCategory:(NSString *)sellSectionCategoryId ;
+ (NSArray *)getSellSectionItems ;
+ (NSInteger)verifySellSectionReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced ;
+ (BOOL)isSellSectionProduct:(NSString *)productId ;
+ (void)setSellSectionPurchased:(BOOL)sellSectionPurchased ;
+ (BOOL)getSellSectionPurchased ;
+ (SellSectionItem *)getSellSectionItemForId:(NSString *)sellSectionItemId ;
+ (NSString *)getSellSectionPaymentDescription ;
+ (NSString *)getSellSectionPaymentButtonText ;
+ (NSString *)getSellSectionProductId ;
+ (NSString *)getSellSectionDescription ;
+ (NSInteger)getNumberOfPicturesBetweenAds ;
+ (NSInteger)getPictureNativeAdHeight ;
+ (BOOL)getSellSectionIsBought:(NSString *)index ;
+ (void)setSellSectionReceipt:(NSString *)sellSectionReceipt sellSectionId:(NSString *)sellSectionId ;

#ifndef DO_NOT_USE_ADMOB
+ (GADRequest *)getAdRequest ;
#endif

+ (BOOL)isTestPurchase ;

+ (NSString *)getApsEnvironmentString ;
+ (void)setDeviceToken:(NSString *)deviceToken environment:(NSString *)envString ;
+ (void)setDeviceToken:(NSString *)deviceToken ;
+ (NSString *)getDeviceToken ;
+ (void)setDeviceTokenEnv:(NSString *)deviceTokenEnv ;
+ (NSString *)getDeviceTokenEnv ;


/*
+ (void)kickKiip:(NSString *)rewardString ;
 */
@end

