//
//  Contents.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forum.h"
#import "YoutubeCategory.h"
#import "YoutubeSubCategory.h"
#import "Youtube.h"
#import "Mixed.h"
#import "MixedCategory.h"
#import "MixedSubCategory.h"
#import "SellItemCategory.h"
#import "SellSectionCategory.h"
#import "VideoCategory.h"
#import "VideoSubCategory.h"
#import "Video.h"
#import "SellVideo.h"
#import "SellSectionItem.h"
#import "PdfCategory.h"
#import "PdfSubCategory.h"
#import "Pdf.h"
#import "SellPdf.h"
#import "AudioCategory.h"
#import "AudioSubCategory.h"
#import "Audio.h"
#import "SellAudio.h"
#import "RecipeCategory.h"
#import "Recipe.h"
#import "AlternativeImage.h"
#import "Web.h"
#import "TemplateSubscription.h"
#import "TemplateYoutube.h"
#import "TemplateMixed.h"
#import "TemplateWeb.h"
#import "Question.h"

/*
#import "DownloadableVideo.h"
#import "Bulletin.h"
#import "WeekdayText.h"
#import "Textlines.h"
#import "TextlineCategory.h"
#import "TextlinePackage.h"
 */


@interface Contents : NSObject <NSXMLParserDelegate>
{
    
    NSData *xmlData ;
    
    NSString *contentId ;
    
    NSMutableDictionary *dictionary ;
    
    //// forum
    NSMutableArray *forums ;

    //// subscription
    TemplateSubscription *templateSubscription ;

    
    //// youtube
    TemplateYoutube *templateYoutube ;
    NSMutableArray *youtubeCategories ;
    NSMutableDictionary *youtubeSubCategoriesPerCategory ;
    NSMutableDictionary *youtubesPerSubCategory ;
    NSMutableDictionary *youtubesForYoutubeId ;
    //NSMutableArray *newyoutubes ;
    
    //// mixed
    TemplateMixed *templateMixed ;
    NSMutableArray *mixedCategories ;
    NSMutableDictionary *mixedSubCategoriesPerCategory ;
    NSMutableDictionary *mixedsPerSubCategory ;
    NSMutableDictionary *mixedsForMixedId ;
    
    //// video
    NSMutableArray *videoCategories ;
    NSMutableDictionary *videoSubCategoriesPerCategory ;
    NSMutableDictionary *videosPerSubCategory ;
    NSMutableDictionary *videosForVideoId ;
    NSMutableArray *sellVideos ;

    //// pdf
    NSMutableArray *pdfCategories ;
    NSMutableDictionary *pdfSubCategoriesPerCategory ;
    NSMutableDictionary *pdfsPerSubCategory ;
    NSMutableDictionary *pdfsForPdfId ;
    NSMutableArray *sellPdfs ;
    
    //// audio
    NSMutableArray *audioCategories ;
    NSMutableDictionary *audioSubCategoriesPerCategory ;
    NSMutableDictionary *audiosPerSubCategory ;
    NSMutableDictionary *audiosForAudioId ;
    NSMutableArray *sellAudios ;
    
    //// recipe
    NSMutableArray *recipeCategories ;
    NSMutableDictionary *recipesPerCategory ;
    NSMutableDictionary *recipesForId ;

    //// web
    TemplateWeb *templateWeb ;
    NSMutableArray *webs ;
    NSMutableDictionary *websPerCategory ;

    //// question
    NSMutableArray *answers ;
    
    //// etc
    NSMutableArray *alternativeImages ;
    NSMutableDictionary *alternativeImagesForFileName ;
    
    NSMutableArray *sellItemCategories ;
    
    //// sell section
    NSMutableArray *sellSectionCategories ;
    NSMutableDictionary *sellSectionItemsForSellSectionItemId ;
    NSMutableArray *sellSectionItems ;



    /*
    NSMutableArray *textlineCategories ;
    NSMutableDictionary *textlineSubCategoriesPerCategory ;
    Textlines *textlines ;
    NSMutableArray *textlineYears ;
    NSMutableDictionary *textlinesForYear ;
    Textline *latestTextline ;
    NSInteger latestTextlineTime ;
    NSMutableArray *textlinePackages ;
     */

    /*
    NSMutableDictionary *youtubesForYoutubeId ;
    NSMutableArray *downloadableVideos ;
    NSMutableDictionary *downloadableVideosForYearMonth ;
    NSMutableArray *bulletins ;
    NSMutableArray *weekdayTexts ;
    */
    BOOL isParsing ;
}

// initialize
- (id)initWithResourceFile ;
- (id)initWithServerData ;
- (id)initWithData:(NSData *)data ;
- (id)initWithUrl:(NSURL *)url ;

- (BOOL)isValid ;

// forum
- (NSInteger)getNumberOfForums ;
- (Forum *)getForumAt:(NSInteger)index ;
- (Forum *)getForumForId:(NSString *)forumId ;

// subscription
- (TemplateSubscription *)getTemplateSubscription ;

// youtube
- (TemplateYoutube *)getTemplateYoutube ;
- (NSInteger)getNumberOfYoutubeCategories ;
- (YoutubeCategory *)getYoutubeCategoryAt:(NSInteger)index ;
- (YoutubeCategory *)getYoutubeCategoryForId:(NSString *)youtubeCategoryId ;
//- (SubCategory *)getSubCategoryForId:(NSString *)subCategoryId ;
- (NSArray *)getYoutubeSubCategories:(NSString *)youtubeCategoryId ;
- (NSArray *)getYoutubesForCategory:(NSString *)youtubeCategoryId ;
- (NSArray *)getYoutubesForSubCategory:(NSString *)youtubeSubCategoryId ;
- (Youtube *)getYoutubeForId:(NSString *)youtubeId ;

// question
- (NSInteger)getNumberOfAnswers ;
- (Question *)getAnswerAt:(NSInteger)index ;
- (Question *)getQuestionForId:(NSString *)questionId ;
- (NSMutableArray *)getAnswers ;

// mixed
- (TemplateMixed *)getTemplateMixed ;
- (NSInteger)getNumberOfMixedCategories ;
- (MixedCategory *)getMixedCategoryAt:(NSInteger)index ;
- (MixedCategory *)getMixedCategoryForId:(NSString *)mixedCategoryId ;
//- (SubCategory *)getSubCategoryForId:(NSString *)subCategoryId ;
- (NSArray *)getMixedSubCategories:(NSString *)mixedCategoryId ;
- (NSArray *)getMixedsForCategory:(NSString *)mixedCategoryId ;
- (NSArray *)getMixedsForSubCategory:(NSString *)mixedSubCategoryId ;
- (Mixed *)getMixedForId:(NSString *)mixedId ;
- (NSArray *)getMixedsForSubscription:(BOOL)includeYearObject ;

// sell
- (NSInteger)getNumberOfSellItemCategories ;
- (SellItemCategory *)getSellItemCategoryAt:(NSInteger)index ;
- (SellItemCategory *)getSellItemCategoryForId:(NSString *)sellItemCategoryId ;




// video
- (NSInteger)getNumberOfVideoCategories ;
- (VideoCategory *)getVideoCategoryAt:(NSInteger)index ;
- (VideoCategory *)getVideoCategoryForId:(NSString *)videoCategoryId ;
- (NSArray *)getVideoSubCategories:(NSString *)videoCategoryId ;
- (NSArray *)getVideosForCategory:(NSString *)videoCategoryId ;
- (NSArray *)getVideosForSubCategory:(NSString *)videoSubCategoryId ;
- (Video *)getVideoForId:(NSString *)videoId ;
- (NSInteger)getNumberOfSellVideos ;
- (SellVideo *)getSellVideoAt:(NSInteger)index ;
- (NSArray *)getSellVideos ;
- (NSArray *)getSellVideosForCategory:(NSString *)videoCategoryId ;
- (SellVideo *)getSellVideoForProduct:(NSString *)productId ;
- (BOOL)isSellVideoProduct:(NSString *)productId ;

// pdf
- (NSInteger)getNumberOfPdfCategories ;
- (PdfCategory *)getPdfCategoryAt:(NSInteger)index ;
- (PdfCategory *)getPdfCategoryForId:(NSString *)pdfCategoryId ;
- (NSArray *)getPdfSubCategories:(NSString *)pdfCategoryId ;
- (NSArray *)getPdfsForCategory:(NSString *)pdfCategoryId ;
- (NSArray *)getPdfsForSubCategory:(NSString *)pdfSubCategoryId ;
- (Pdf *)getPdfForId:(NSString *)pdfId ;
- (NSInteger)getNumberOfSellPdfs ;
- (SellPdf *)getSellPdfAt:(NSInteger)index ;
- (NSArray *)getSellPdfs ;
- (NSArray *)getSellPdfsForCategory:(NSString *)pdfCategoryId ;
- (SellPdf *)getSellPdfForProduct:(NSString *)productId ;
- (BOOL)isSellPdfProduct:(NSString *)productId ;

// audio
- (NSInteger)getNumberOfAudioCategories ;
- (AudioCategory *)getAudioCategoryAt:(NSInteger)index ;
- (AudioCategory *)getAudioCategoryForId:(NSString *)audioCategoryId ;
- (NSArray *)getAudioSubCategories:(NSString *)audioCategoryId ;
- (NSArray *)getAudiosForCategory:(NSString *)audioCategoryId ;
- (NSArray *)getAudiosForSubCategory:(NSString *)audioSubCategoryId ;
- (Audio *)getAudioForId:(NSString *)audioId ;
- (NSInteger)getNumberOfSellAudios ;
- (SellAudio *)getSellAudioAt:(NSInteger)index ;
- (NSArray *)getSellAudios ;
- (NSArray *)getSellAudiosForCategory:(NSString *)audioCategoryId ;
- (SellAudio *)getSellAudioForProduct:(NSString *)productId ;
- (BOOL)isSellAudioProduct:(NSString *)productId ;

// recipe
- (NSArray *)getRecipeCategories ;
- (NSArray *)getRecipes:(NSString *)recipeCategoryId ;
- (Recipe *)getRecipeForId:(NSString *)recipeId ;

// web
- (NSInteger)getNumberOfWebs:(NSString *)categoryId ;
- (NSArray *)getWebs:(NSString *)categoryId ;

// etc
- (NSArray *)getAlternativeImages ;
- (AlternativeImage *)getAlternativeImageForFileName:(NSString *)fileName ;

- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;

// sell section
- (NSInteger)getNumberOfSellSectionCategories ;
- (SellSectionCategory *)getSellSectionCategoryAt:(NSInteger)index ;
- (SellSectionCategory *)getSellSectionCategoryForId:(NSString *)sellSectionCategoryId ;
- (NSArray *)getSellSectionItems ;
- (NSArray *)getSellSectionItemsForCategory:(NSString *)sellSectionCategoryId ;
- (SellSectionItem *)getSellSectionItemForId:(NSString *)sellsectionItemId ;

/*
// textline
- (NSInteger)getNumberOfTextlinePackages ;
- (TextlinePackage *)getTextlinePackageAt:(NSInteger)index ;
- (TextlinePackage *)getTextlinePackageForId:(NSString *)textlinePackageId ;
- (NSInteger)getNumberOfTextlineCategories ;
- (TextlineCategory *)getTextlineCategoryAt:(NSInteger)index ;
- (TextlineCategory *)getTextlineCategoryForId:(NSString *)categoryId ;
//- (NSArray *)getTextlinesForCategory:(NSString *)categoryId ;
- (Textline *)getLatestTextline ;
- (Textlines *)getTextlines ;
*/

/*
- (NSInteger)getNumberOfNewYoutubeVideos ;
- (NSArray *)getNewYoutubeVideos ;

- (NSInteger)getNumberOfDownloadableVideos ;
- (NSArray *)getDownloadableVideos ;

- (NSInteger)getNumberOfDownloadableVideosForYearMonth:(NSString *)yearMonth ;
- (NSArray *)getDownloadableVideosForYearMonth:(NSString *)yearMonth ;




- (Video *)getVideoForVideoId:(NSString *)videoId ;


- (Bulletin *)getCurrentBulletin:(NSInteger)index ;
- (WeekdayText *)getWeekdayText:(NSInteger)targetTime weekday:(NSInteger)weekday ;

*/


@end
