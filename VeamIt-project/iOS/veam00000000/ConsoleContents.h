//
//  ConsoleContents.h
//  veam00000000
//
//  Created by veam on 6/2/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forum.h"
#import "YoutubeCategory.h"
#import "YoutubeSubCategory.h"
#import "Youtube.h"
#import "MixedCategory.h"
#import "MixedSubCategory.h"
#import "Mixed.h"
#import "VideoCategory.h"
#import "VideoSubCategory.h"
#import "Video.h"
#import "SellVideo.h"
#import "SellSectionItem.h"
#import "Audio.h"
#import "SellAudio.h"
#import "AudioCategory.h"
#import "RecipeCategory.h"
#import "Recipe.h"
#import "AlternativeImage.h"
#import "Web.h"
#import "TemplateSubscription.h"
#import "TemplateYoutube.h"
#import "TemplateMixed.h"
#import "TemplateWeb.h"
#import "TemplateForum.h"
#import "AppInfo.h"
#import "BankAccountInfo.h"
#import "AppRatingQuestion.h"
#import "SellItemCategory.h"
#import "SellSectionCategory.h"
#import "PdfCategory.h"
#import "PdfSubCategory.h"
#import "Pdf.h"
#import "SellPdf.h"


@interface ConsoleContents : NSObject <NSXMLParserDelegate>
{
    NSData *xmlData ;
    BOOL isParsing ;
    NSMutableDictionary *dictionary ;
    
    AppInfo *appInfo ;
    BankAccountInfo *bankAccountInfo ;
    NSMutableArray *appRatingQuestions ;

    //// subscription
    TemplateSubscription *templateSubscription ;

    
    //// youtube
    TemplateYoutube *templateYoutube ;
    NSMutableArray *youtubeCategories ;
    NSMutableDictionary *youtubeSubCategoriesPerCategory ;
    NSMutableDictionary *youtubesPerCategory ;
    NSMutableDictionary *youtubesPerSubCategory ;
    NSMutableDictionary *youtubesForYoutubeId ;
    //NSMutableArray *newyoutubes ;
    
    //// forum
    TemplateForum *templateForum ;
    NSMutableArray *forums ;
    
    //// mixed
    TemplateMixed *templateMixed ;
    NSMutableArray *mixedCategories ;
    NSMutableDictionary *mixedSubCategoriesPerCategory ;
    NSMutableDictionary *mixedsPerCategory ;
    NSMutableDictionary *mixedsPerSubCategory ;
    NSMutableDictionary *mixedsForMixedId ;
    NSMutableArray *recipes ;
    //NSMutableDictionary *recipesForId ;
    
    //// video
    NSMutableArray *videoCategories ;
    NSMutableDictionary *videoSubCategoriesPerCategory ;
    NSMutableDictionary *videosPerCategory ;
    NSMutableDictionary *videosPerSubCategory ;
    NSMutableDictionary *videosForVideoId ;
    NSMutableDictionary *sellVideosForSellVideoId ;
    NSMutableArray *sellVideos ;

    //// sell item
    NSMutableArray *sellItemCategories ;

    //// sell section
    NSMutableArray *sellSectionCategories ;
    NSMutableDictionary *sellSectionItemsForSellSectionItemId ;
    NSMutableArray *sellSectionItems ;
    
    //// pdf
    NSMutableArray *pdfCategories ;
    NSMutableDictionary *pdfSubCategoriesPerCategory ;
    NSMutableDictionary *pdfsPerCategory ;
    NSMutableDictionary *pdfsPerSubCategory ;
    NSMutableDictionary *pdfsForPdfId ;
    NSMutableDictionary *sellPdfsForSellPdfId ;
    NSMutableArray *sellPdfs ;
    
    //// audio
    NSMutableArray *audioCategories ;
    NSMutableDictionary *audioSubCategoriesPerCategory ;
    NSMutableDictionary *audiosPerCategory ;
    NSMutableDictionary *audiosPerSubCategory ;
    NSMutableDictionary *audiosForAudioId ;
    NSMutableDictionary *sellAudiosForSellAudioId ;
    NSMutableArray *sellAudios ;
    
    //// recipe
    /*
    NSMutableArray *recipeCategories ;
    NSMutableDictionary *recipesPerCategory ;
     */
    
    //// web
    TemplateWeb *templateWeb ;
    NSMutableArray *webs ;
    
    
    //// etc
    NSMutableArray *alternativeImages ;
    NSMutableDictionary *alternativeImagesForFileName ;
    
    NSMutableArray *customizeElementsForDesign ;
    NSMutableArray *customizeElementsForFeature ;
    NSMutableArray *customizeElementsForSubscription ;
}

@property(nonatomic,retain)AppInfo *appInfo ;
@property(nonatomic,retain)BankAccountInfo *bankAccountInfo ;
@property(nonatomic,retain)NSMutableArray *appRatingQuestions ;
@property(nonatomic,retain)TemplateSubscription *templateSubscription ;
@property(nonatomic,retain)TemplateYoutube *templateYoutube ;
@property(nonatomic,retain)TemplateMixed *templateMixed ;
@property(nonatomic,retain)TemplateWeb *templateWeb ;
@property(nonatomic,retain)TemplateForum *templateForum ;
//@property(nonatomic,assign)BOOL isChanged ;


// initialize
- (id)initWithResourceFile ;
- (id)initWithServerData ;
- (id)initWithData:(NSData *)data ;
- (id)initWithUrl:(NSURL *)url ;
- (BOOL)isValid ;


- (BOOL)isRatingCompleted ;
- (BOOL)isAppDescriptionCompleted ;
- (BOOL)isSubscriptionDescriptionCompleted ;
- (BOOL)isBankCompleted ;
- (CGFloat)getSettingCompletionRatio ;

///////////////////////////////////////////////////////////
#pragma mark App
- (void)setAppBackgroundImage:(UIImage *)image ;
- (void)setAppCustomBackgroundImage:(UIImage *)image ;
- (void)setAppSplashImage:(UIImage *)image ;
- (void)setAppIconImage:(UIImage *)image ;
- (void)setAppCustomIconImage:(UIImage *)image ;
- (void)setAppScreenShot:(UIImage *)image name:(NSString *)name ;
- (void)setAppColor:(NSString *)colorString name:(NSString *)name ;
- (void)setAppData:(NSString *)value name:(NSString *)name ;
- (void)setAppName:(NSString *)name ;
- (void)setAppStoreAppName:(NSString *)name ;
- (void)setAppDescription:(NSString *)description ;
- (void)setAppKeyword:(NSString *)keyword ;
- (void)setAppCategory:(NSString *)category ;
- (void)setAppRatingQuestion:(AppRatingQuestion *)appRatingQuestion ;
- (void)saveAppInfo ;
- (void)saveBankAccountInfo ;
- (void)setAppTermsAccepted ;
- (void)submitToMcn ;
- (BOOL)canSubmitToMcn ;
- (void)deployContents ;
- (NSArray *)getRequiredOperationsToSubmit ;
- (BOOL)isAppReleased ;

///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
#pragma mark Subscription
- (void)setTemplateSubscriptionTitle:(NSString *)title ;
- (void)setTemplateSubscriptionLayout:(NSString *)layout ;
- (void)setTemplateSubscriptionPrice:(NSString *)price ;
- (void)setTemplateSubscriptionKind:(NSString *)kind ;
- (void)setTemplateSubscriptionRightImage:(UIImage *)image ;
- (void)saveTemplateSubscription ;
- (NSTimeInterval)getNextUploadTime ;
///////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////
#pragma mark Video
- (void)setVideoCategory:(VideoCategory *)videoCategory ;
- (NSInteger)getNumberOfVideoCategories ;
- (VideoCategory *)getVideoCategoryAt:(NSInteger)index ;
- (VideoCategory *)getVideoCategoryForId:(NSString *)videoCategoryId ;
- (void)moveVideoCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeVideoCategoryAt:(NSInteger)index ;

- (void)setVideoSubCategory:(VideoSubCategory *)videoSubCategory ;
- (NSMutableArray *)getVideoSubCategories:(NSString *)videoCategoryId ;
- (NSInteger)getNumberOfVideoSubCategories:(NSString *)videoCategoryId ;
- (VideoSubCategory *)getVideoSubCategoryAt:(NSInteger)index videoCategoryId:(NSString *)videoCategoryId ;
- (void)moveVideoSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex videoCategoryId:(NSString *)videoCategoryId ;
- (void)removeVideoSubCategoryAt:(NSInteger)index videoCategoryId:(NSString *)videoCategoryId ;

- (void)setVideo:(Video *)video thumbnailImage:(UIImage *)thumbnailImage ;
- (NSInteger)getNumberOfVideosForCategory:(NSString *)videoCategoryId ;
- (NSInteger)getNumberOfWaitingVideoForCategory:(NSString *)videoCategoryId ;
- (NSInteger)getNumberOfVideosForSubCategory:(NSString *)videoSubCategoryId ;
- (NSMutableArray *)getVideosForCategory:(NSString *)videoCategoryId ;
- (NSMutableArray *)getVideosForSubCategory:(NSString *)videoSubCategoryId ;
- (Video *)getVideoForId:(NSString *)videoId ;
- (Video *)getVideoForCategory:(NSString *)videoCategoryId at:(NSInteger)index ;
- (Video *)getVideoForSubCategory:(NSString *)videoSubCategoryId at:(NSInteger)index ;
- (void)moveVideoForCategory:(NSString *)videoCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)moveVideoForSubCategory:(NSString *)videoSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeVideoForCategory:(NSString *)videoCategoryId at:(NSInteger)index ;
- (void)removeVideoForSubCategory:(NSString *)videoSubCategoryId at:(NSInteger)index ;

- (void)updatePreparingVideoStatus:(NSString *)videoCategoryId ;

- (NSInteger)getNumberOfSellVideosForVideoCategory:(NSString *)videoCategoryId ;
- (NSArray *)getSellVideosForVideoCategory:(NSString *)videoCategoryId ;
- (SellVideo *)getSellVideoForVideoCategory:(NSString *)videoCategoryId at:(NSInteger)index order:(NSComparisonResult)order ;
- (SellVideo *)getSellVideoForId:(NSString *)sellVideoId ;
- (void)removeSellVideoForVideoCategory:(NSString *)videoCategoryId at:(NSInteger)index ;
- (void)removeSellVideoFrom:(NSMutableArray *)sellVideos at:(NSInteger)index ;
- (void)updatePreparingSellVideoStatus:(NSString *)videoCategoryId ;
- (void)setSellVideo:(SellVideo *)sellVideo videoCategoryId:(NSString *)videoCategoryId videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl videoImageUrl:(NSString *)videoImageUrl ;
- (void)saveSellVideo:(SellVideo *)sellVideo videoCategoryId:(NSString *)videoCategoryId videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl ;

///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
#pragma mark Audio
//- (void)setAudioCategory:(AudioCategory *)audioCategory ;
//- (NSInteger)getNumberOfAudioCategories ;
//- (AudioCategory *)getAudioCategoryAt:(NSInteger)index ;
//- (AudioCategory *)getAudioCategoryForId:(NSString *)audioCategoryId ;
//- (void)moveAudioCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
//- (void)removeAudioCategoryAt:(NSInteger)index ;

//- (void)setAudioSubCategory:(AudioSubCategory *)audioSubCategory ;
//- (NSMutableArray *)getAudioSubCategories:(NSString *)audioCategoryId ;
//- (NSInteger)getNumberOfAudioSubCategories:(NSString *)audioCategoryId ;
//- (AudioSubCategory *)getAudioSubCategoryAt:(NSInteger)index audioCategoryId:(NSString *)audioCategoryId ;
//- (void)moveAudioSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex audioCategoryId:(NSString *)audioCategoryId ;
//- (void)removeAudioSubCategoryAt:(NSInteger)index audioCategoryId:(NSString *)audioCategoryId ;

- (void)setAudio:(Audio *)audio thumbnailImage:(UIImage *)thumbnailImage ;
//- (NSInteger)getNumberOfAudiosForCategory:(NSString *)audioCategoryId ;
//- (NSInteger)getNumberOfWaitingAudioForCategory:(NSString *)audioCategoryId ;
//- (NSInteger)getNumberOfAudiosForSubCategory:(NSString *)audioSubCategoryId ;
- (NSMutableArray *)getAudiosForCategory:(NSString *)audioCategoryId ;
- (NSMutableArray *)getAudiosForSubCategory:(NSString *)audioSubCategoryId ;
//- (Audio *)getAudioForId:(NSString *)audioId ;
//- (Audio *)getAudioForCategory:(NSString *)audioCategoryId at:(NSInteger)index ;
//- (Audio *)getAudioForSubCategory:(NSString *)audioSubCategoryId at:(NSInteger)index ;
//- (void)moveAudioForCategory:(NSString *)audioCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
//- (void)moveAudioForSubCategory:(NSString *)audioSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
//- (void)removeAudioForCategory:(NSString *)audioCategoryId at:(NSInteger)index ;
//- (void)removeAudioForSubCategory:(NSString *)audioSubCategoryId at:(NSInteger)index ;

//- (void)updatePreparingAudioStatus:(NSString *)audioCategoryId ;

- (Audio *)getAudioForId:(NSString *)audioId ;

- (NSInteger)getNumberOfSellAudiosForAudioCategory:(NSString *)audioCategoryId ;
- (NSArray *)getSellAudiosForAudioCategory:(NSString *)audioCategoryId ;
- (SellAudio *)getSellAudioForAudioCategory:(NSString *)audioCategoryId at:(NSInteger)index order:(NSComparisonResult)order ;
- (SellAudio *)getSellAudioForId:(NSString *)sellAudioId ;
- (void)setSellAudio:(SellAudio *)sellAudio audioCategoryId:(NSString *)audioCategoryId audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl  audioLinkUrl:(NSString *)audioLinkUrl ;
- (void)saveSellAudio:(SellAudio *)sellAudio audioCategoryId:(NSString *)audioCategoryId audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl ;
- (void)updatePreparingSellAudioStatus:(NSString *)audioCategoryId ;
- (AudioCategory *)getAudioCategoryForId:(NSString *)audioCategoryId ;

- (void)removeSellAudioForAudioCategory:(NSString *)audioCategoryId at:(NSInteger)index ;

///////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////
#pragma mark Youtube
- (void)setTemplateYoutubeTitle:(NSString *)title ;
- (void)setTemplateYoutubeEmbedFlag:(BOOL)embedFlag ;
- (void)setTemplateYoutubeEmbedUrl:(NSString *)url ;
- (void)setTemplateYoutubeLeftImage:(UIImage *)image ;
- (void)setTemplateYoutubeRightImage:(UIImage *)image ;
- (void)saveTemplateYoutube ;

- (void)setYoutubeCategory:(YoutubeCategory *)youtubeCategory ;
- (NSInteger)getNumberOfYoutubeCategories ;
- (YoutubeCategory *)getYoutubeCategoryAt:(NSInteger)index ;
- (YoutubeCategory *)getYoutubeCategoryForId:(NSString *)youtubeCategoryId ;
- (void)moveYoutubeCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeYoutubeCategoryAt:(NSInteger)index ;
- (void)disableYoutubeCategoryAt:(NSInteger)index disabled:(BOOL)disabled ;

- (void)setYoutubeSubCategory:(YoutubeSubCategory *)youtubeSubCategory ;
- (NSMutableArray *)getYoutubeSubCategories:(NSString *)youtubeCategoryId ;
- (NSInteger)getNumberOfYoutubeSubCategories:(NSString *)youtubeCategoryId ;
- (YoutubeSubCategory *)getYoutubeSubCategoryAt:(NSInteger)index youtubeCategoryId:(NSString *)youtubeCategoryId ;
- (void)moveYoutubeSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex youtubeCategoryId:(NSString *)youtubeCategoryId ;
- (void)removeYoutubeSubCategoryAt:(NSInteger)index youtubeCategoryId:(NSString *)youtubeCategoryId ;

- (void)setYoutube:(Youtube *)youtube ;
- (NSInteger)getNumberOfYoutubesForCategory:(NSString *)youtubeCategoryId ;
- (NSInteger)getNumberOfYoutubesForSubCategory:(NSString *)youtubeSubCategoryId ;
- (NSMutableArray *)getYoutubesForCategory:(NSString *)youtubeCategoryId ;
- (NSMutableArray *)getYoutubesForSubCategory:(NSString *)youtubeSubCategoryId ;
- (Youtube *)getYoutubeForId:(NSString *)youtubeId ;
- (Youtube *)getYoutubeForCategory:(NSString *)youtubeCategoryId at:(NSInteger)index ;
- (Youtube *)getYoutubeForSubCategory:(NSString *)youtubeSubCategoryId at:(NSInteger)index ;
- (void)moveYoutubeForCategory:(NSString *)youtubeCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)moveYoutubeForSubCategory:(NSString *)youtubeSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeYoutubeForCategory:(NSString *)youtubeCategoryId at:(NSInteger)index ;
- (void)removeYoutubeForSubCategory:(NSString *)youtubeSubCategoryId at:(NSInteger)index ;

///////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////
#pragma mark Mixed
- (void)setTemplateMixedTitle:(NSString *)title ;
- (void)saveTemplateMixed ;

- (void)setMixedCategory:(MixedCategory *)mixedCategory ;
- (NSInteger)getNumberOfMixedCategories ;
- (MixedCategory *)getMixedCategoryAt:(NSInteger)index ;
- (MixedCategory *)getMixedCategoryForId:(NSString *)mixedCategoryId ;
- (void)moveMixedCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeMixedCategoryAt:(NSInteger)index ;

- (void)setMixedSubCategory:(MixedSubCategory *)mixedSubCategory ;
- (NSMutableArray *)getMixedSubCategories:(NSString *)mixedCategoryId ;
- (NSInteger)getNumberOfMixedSubCategories:(NSString *)mixedCategoryId ;
- (MixedSubCategory *)getMixedSubCategoryAt:(NSInteger)index mixedCategoryId:(NSString *)mixedCategoryId ;
- (void)moveMixedSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex mixedCategoryId:(NSString *)mixedCategoryId ;
- (void)removeMixedSubCategoryAt:(NSInteger)index mixedCategoryId:(NSString *)mixedCategoryId ;

- (void)setMixed:(Mixed *)mixed ;
- (NSInteger)getNumberOfMixedsForCategory:(NSString *)mixedCategoryId ;
- (NSInteger)getNumberOfMixedsForSubCategory:(NSString *)mixedSubCategoryId ;
- (NSInteger)getNumberOfWaitingMixedForCategory:(NSString *)mixedCategoryId ;
- (NSMutableArray *)getMixedsForCategory:(NSString *)mixedCategoryId ;
- (NSMutableArray *)getMixedsForSubCategory:(NSString *)mixedSubCategoryId ;
- (Mixed *)getMixedForId:(NSString *)mixedId ;
//- (Mixed *)getMixedForCategory:(NSString *)mixedCategoryId at:(NSInteger)index ;
- (Mixed *)getMixedForCategory:(NSString *)mixedCategoryId at:(NSInteger)index order:(NSComparisonResult)order ;
- (Mixed *)getMixedForSubCategory:(NSString *)mixedSubCategoryId at:(NSInteger)index ;
- (void)moveMixedForCategory:(NSString *)mixedCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)moveMixedForSubCategory:(NSString *)mixedSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeMixedForCategory:(NSString *)mixedCategoryId at:(NSInteger)index ;
- (void)removeMixedForSubCategory:(NSString *)mixedSubCategoryId at:(NSInteger)index ;

- (void)setRecipe:(Recipe *)recipe recipeImage:(UIImage *)recipeImage ;
- (Recipe *)getRecipeForId:(NSString *)recipeId ;

- (void)updatePreparingMixedStatus:(NSString *)mixedCategoryId ;
///////////////////////////////////////////////////////////




// forum
- (NSInteger)getNumberOfForums ;
- (Forum *)getForumAt:(NSInteger)index ;
- (Forum *)getForumForId:(NSString *)forumId ;
- (void)setTemplateForumTitle:(NSString *)title ;
- (void)saveTemplateForum ;
- (void)setForum:(Forum *)forum ;
- (void)moveForumFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeForumAt:(NSInteger)index ;


// recipe
- (NSArray *)getRecipeCategories ;
- (NSArray *)getRecipes:(NSString *)recipeCategoryId ;

// web
- (void)setTemplateWebTitle:(NSString *)title ;
- (void)saveTemplateWeb ;
- (void)setWeb:(Web *)web ;
- (NSInteger)getNumberOfWebs ;
- (NSArray *)getWebs ;
- (Web *)getWebAt:(NSInteger)index ;
- (void)moveWebFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)removeWebAt:(NSInteger)index ;

// etc
- (NSArray *)getAlternativeImages ;
- (AlternativeImage *)getAlternativeImageForFileName:(NSString *)fileName ;

- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;

- (NSMutableArray *)getCustomizeElementsForKind:(NSInteger)kind ;

- (void)setSellItemTarget:(NSString *)kind targetCategoryId:(NSString *)targetCategoryId name:(NSString *)name ;













/////////////////////////////////////////////////////////////////////////////////
#pragma mark Pdf
/////////////////////////////////////////////////////////////////////////////////
- (void)setPdfCategory:(PdfCategory *)pdfCategory ;
- (void)savePdfCategory:(PdfCategory *)pdfCategory ;
- (void)removePdfCategoryAt:(NSInteger)index ;
- (NSInteger)getNumberOfPdfCategories ;
- (NSMutableArray *)getPdfCategories ;
- (PdfCategory *)getPdfCategoryAt:(NSInteger)index ;
- (void)movePdfCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)savePdfCategoryOrder ;
- (PdfCategory *)getPdfCategoryForId:(NSString *)pdfCategoryId ;
- (NSMutableArray *)getPdfSubCategories:(NSString *)pdfCategoryId ;
- (NSInteger)getNumberOfPdfSubCategories:(NSString *)pdfCategoryId ;
- (PdfSubCategory *)getPdfSubCategoryAt:(NSInteger)index pdfCategoryId:(NSString *)pdfCategoryId ;
- (void)movePdfSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex pdfCategoryId:(NSString *)pdfCategoryId ;
- (void)savePdfSubCategoryOrder:(NSString *)pdfCategoryId ;
- (void)setPdfSubCategory:(PdfSubCategory *)pdfSubCategory ;
- (void)savePdfSubCategory:(PdfSubCategory *)pdfSubCategory ;
- (void)removePdfSubCategoryAt:(NSInteger)index pdfCategoryId:(NSString *)pdfCategoryId ;
- (NSInteger)getNumberOfPdfsForCategory:(NSString *)pdfCategoryId ;
- (NSInteger)getNumberOfPdfsForSubCategory:(NSString *)pdfSubCategoryId ;
- (NSMutableArray *)getPdfsForCategory:(NSString *)pdfCategoryId ;
- (NSMutableArray *)getPdfsForSubCategory:(NSString *)pdfSubCategoryId ;
- (Pdf *)getPdfForId:(NSString *)pdfId ;
- (Pdf *)getPdfForCategory:(NSString *)pdfCategoryId at:(NSInteger)index ;
- (Pdf *)getPdfForSubCategory:(NSString *)pdfSubCategoryId at:(NSInteger)index ;
- (void)movePdfForCategory:(NSString *)pdfCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)movePdfForSubCategory:(NSString *)pdfSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)savePdfOrder:(NSMutableArray *)pdfs ;
- (void)setPdf:(Pdf *)pdf thumbnailImage:(UIImage *)thumbnailImage ;
- (void)savePdf:(Pdf *)pdf thumbnailImage:(UIImage *)thumbnailImage ;
- (void)removePdfForCategory:(NSString *)pdfCategoryId at:(NSInteger)index ;
- (void)removePdfForSubCategory:(NSString *)pdfSubCategoryId at:(NSInteger)index ;
- (void)removePdfFrom:(NSMutableArray *)pdfs at:(NSInteger)index ;

- (NSInteger)getNumberOfSellPdfsForPdfCategory:(NSString *)pdfCategoryId ;
- (NSArray *)getSellPdfsForPdfCategory:(NSString *)pdfCategoryId ;
- (SellPdf *)getSellPdfForPdfCategory:(NSString *)pdfCategoryId at:(NSInteger)index order:(NSComparisonResult)order ;
- (SellPdf *)getSellPdfForId:(NSString *)sellPdfId ;
- (void)removeSellPdfForPdfCategory:(NSString *)pdfCategoryId at:(NSInteger)index ;
- (void)removeSellPdfFrom:(NSMutableArray *)sellPdfs at:(NSInteger)index ;
- (void)updatePreparingSellPdfStatus:(NSString *)pdfCategoryId ;
- (void)setSellPdf:(SellPdf *)sellPdf pdfCategoryId:(NSString *)pdfCategoryId pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl pdfImageUrl:(NSString *)pdfImageUrl ;
- (void)saveSellPdf:(SellPdf *)sellPdf pdfCategoryId:(NSString *)pdfCategoryId pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl ;
















/////////////////////////////////////////////////////////////////////////////////
#pragma mark SellItemCategory
/////////////////////////////////////////////////////////////////////////////////
- (void)setSellItemCategory:(SellItemCategory *)sellItemCategory title:(NSString *)title ;
- (void)saveSellItemCategory:(SellItemCategory *)sellItemCategory title:(NSString *)title ;
- (void)removeSellItemCategoryAt:(NSInteger)index ;
- (NSInteger)getNumberOfSellItemCategories ;
- (NSMutableArray *)getSellItemCategories ;
- (SellItemCategory *)getSellItemCategoryAt:(NSInteger)index ;
- (void)moveSellItemCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)saveSellItemCategoryOrder ;
- (SellItemCategory *)getSellItemCategoryForId:(NSString *)sellItemCategoryId ;
- (NSString *)getCategoryTitleForSellItemCategory:(SellItemCategory *)sellItemCategory ;

/////////////////////////////////////////////////////////////////////////////////
#pragma mark SellSectionCategory
/////////////////////////////////////////////////////////////////////////////////
- (void)setSellSectionCategory:(SellSectionCategory *)sellSectionCategory title:(NSString *)title ;
- (void)saveSellSectionCategory:(SellSectionCategory *)sellSectionCategory title:(NSString *)title ;
- (void)removeSellSectionCategoryAt:(NSInteger)index ;
- (NSInteger)getNumberOfSellSectionCategories ;
- (NSMutableArray *)getSellSectionCategories ;
- (SellSectionCategory *)getSellSectionCategoryAt:(NSInteger)index ;
- (void)moveSellSectionCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex ;
- (void)saveSellSectionCategoryOrder ;
- (SellSectionCategory *)getSellSectionCategoryForId:(NSString *)sellSectionCategoryId ;
- (NSString *)getCategoryTitleForSellSectionCategory:(SellSectionCategory *)sellSectionCategory ;
- (BOOL)isCategoryInSellSection:(NSString *)categoryId categoryKind:(NSString *)categoryKind ;

- (NSInteger)getNumberOfSellSectionItemsForSellSectionCategory:(NSString *)sellSectionCategoryId ;
- (NSArray *)getSellSectionItemsForsellSectionCategory:(NSString *)sellSectionCategoryId ;
- (SellSectionItem *)getSellSectionItemForSellSectionCategory:(NSString *)sellSectionCategoryId at:(NSInteger)index order:(NSComparisonResult)order ;
- (SellSectionItem *)getSellSectionItemForId:(NSString *)sellSectionItemId ;
- (void)removeSellSectionItemForSellSectionCategory:(NSString *)sellSectionCategoryId at:(NSInteger)index ;
- (void)removeSellSectionItemFrom:(NSMutableArray *)sellSectionItems at:(NSInteger)index ;
- (void)updatePreparingSellSectionItemStatus:(NSString *)sellSectionCategoryId ;
- (void)setSellSectionVideo:(SellSectionItem *)sellSectionItem videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl videoImageUrl:(NSString *)videoImageUrl ;
- (void)saveSellSectionVideo:(SellSectionItem *)sellSectionItem videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl videoImageUrl:(NSString *)videoImageUrl ;
- (void)setSellSectionPdf:(SellSectionItem *)sellSectionItem pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl pdfImageUrl:(NSString *)pdfImageUrl ;
- (void)saveSellSectionPdf:(SellSectionItem *)sellSectionItem pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl pdfImageUrl:(NSString *)pdfImageUrl ;
- (void)setSellSectionAudio:(SellSectionItem *)sellSectionItem audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl  audioLinkUrl:(NSString *)audioLinkUrl ;
- (void)saveSellSectionAudio:(SellSectionItem *)sellSectionItem audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl audioLinkUrl:(NSString *)audioLinkUrl ;

@end
