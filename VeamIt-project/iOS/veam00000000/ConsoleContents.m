//
//  ConsoleContents.m
//  veam00000000
//
//  Created by veam on 6/2/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleContents.h"
#import "AppDelegate.h"
#import "ConsolePostData.h"
#import "ConsoleUtil.h"
#import "VeamUtil.h"
#import "HandlePostResultDelegate.h"
#import "ConsoleCustomizeElement.h"
#import "ConsoleUpdatePreparingVideoStatusHandler.h"
#import "ConsoleUpdatePreparingMixedStatusHandler.h"
#import "ConsoleUpdatePreparingSellVideoStatusHandler.h"
#import "ConsoleUpdatePreparingSellPdfStatusHandler.h"
#import "ConsoleUpdatePreparingSellAudioStatusHandler.h"
#import "ConsoleUpdatePreparingSellSectionItemStatusHandler.h"
#import "ConsoleSellVideoPostHandler.h"
#import "ConsoleSellPdfPostHandler.h"
#import "ConsoleSellAudioPostHandler.h"
#import "ConsoleSellSectionItemPostHandler.h"


@implementation ConsoleContents

@synthesize appInfo ;
@synthesize bankAccountInfo ;
@synthesize appRatingQuestions ;
@synthesize templateSubscription ;
@synthesize templateYoutube ;
@synthesize templateMixed ;
@synthesize templateWeb ;
@synthesize templateForum ;
//@synthesize isChanged ;

- (NSString *)escapeNull:(NSString *)string
{
    NSString *retValue = string ;
    if(retValue == nil){
        retValue = @"" ;
    }
    return retValue ;
}



/////////////////////////////////////////////////////////////////////////////////
#pragma mark App
/////////////////////////////////////////////////////////////////////////////////
- (void)setAppBackgroundImage:(UIImage *)image
{
    NSString *apiName = @"app/setbackgroundimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"background.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:appInfo] ;
}

- (void)setAppCustomBackgroundImage:(UIImage *)image
{
    NSString *apiName = @"app/setcustombackgroundimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"background.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:appInfo] ;
}

- (void)setAppSplashImage:(UIImage *)image
{
    NSString *apiName = @"app/setsplashimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"initial_background.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:appInfo] ;
}

- (void)setAppTermsAccepted
{
    
    NSString *userName = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
    NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;

    NSString *apiName = @"app/acceptterms" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userName,@"un",
                            password,@"pw",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)submitToMcn
{
    
    NSString *userName = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
    NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;
    
    NSString *apiName = @"app/submittomcn" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userName,@"un",
                            password,@"pw",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (BOOL)canSubmitToMcn
{
    NSArray *requiredOperations = [self getRequiredOperationsToSubmit] ;
    return ([requiredOperations count] == 0) ;
}

- (void)deployContents
{
    
    NSString *userName = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
    NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;
    
    NSString *apiName = @"app/deploycontents" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userName,@"un",
                            password,@"pw",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (NSArray *)getRequiredOperationsToSubmit
{
    //NSLog(@"getRequiredOperationsToSubmit") ;
    
    NSMutableArray *requiredOperations = [NSMutableArray array] ;
    
    if([VeamUtil isEmpty:appInfo.backgroundImageUrl]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_background", nil)] ;
    }
    
    //// Subscription //////////////////////////////////////
    if(![self isSubscriptionContentCompleted]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_subscription", nil)] ;
    }

    if(![self isSubscriptionDescriptionCompleted]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_subscription_description", nil)] ;
    }
    


    //// Forum //////////////////////////////////////
    if(![self isForumCompleted]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_forum", nil)] ;
    }
    
    //// Links //////////////////////////////////////
    if(![self isLinksCompleted]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_links", nil)] ;
    }
    
    //// App Info //////////////////////////////////////
    if([VeamUtil isEmpty:appInfo.termsAcceptedAt]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_terms", nil)] ;
    }
    NSString *appDescriptionSet = [self getValueForKey:@"app_description_set"] ;
    if([VeamUtil isEmpty:appInfo.description]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_description", nil)] ;
    } else if([VeamUtil isEmpty:appDescriptionSet]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_description", nil)] ;
    }
    
    if([VeamUtil isEmpty:appInfo.keyword]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_keywords", nil)] ;
    }
    if([VeamUtil isEmpty:appInfo.category]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_category", nil)] ;
    }
    
    if(![self isRatingCompleted]){
        [requiredOperations addObject:NSLocalizedString(@"required_operation_rating", nil)] ;
    }

    //// Bank account //////////////////////////////////////
    /*
    if(![self isBankCompleted]){
        [requiredOperations addObject:@"Register Bank Account"] ;
    }
     */
    
    return requiredOperations ;
}

- (BOOL)isAppDescriptionCompleted
{
    BOOL completed = NO ;
    NSString *appDescriptionSet = [self getValueForKey:@"app_description_set"] ;
    if(![VeamUtil isEmpty:appDescriptionSet]){
        completed = YES ;
    }
    return completed ;
}


- (BOOL)isSubscriptionContentCompleted
{
    // at least 1 content
    
    NSArray *mixeds = [self getMixedsForCategory:@"0"] ;
    BOOL subscruptionContentCompleted = YES ;
    
    if([templateSubscription.kind isEqualToString:VEAM_SUBSCRIPTION_KIND_MIXED_GRID]){
        NSInteger count = [mixeds count] ;
        if(count < 1){
            subscruptionContentCompleted = NO ;
        } else {
            NSInteger mixedCount = 0 ;
            for(int index = 0 ; index < count ; index++){
                Mixed *mixed = [mixeds objectAtIndex:index] ;
                NSString *contentId = mixed.contentId ;
                if(![VeamUtil isEmpty:contentId] && ![contentId isEqualToString:@"0"]){
                    mixedCount++ ;
                }
            }
            //NSLog(@"mixedCount %d",mixedCount) ;
            if(mixedCount < 1){
                subscruptionContentCompleted = NO ;
            }
        }
    } else if([templateSubscription.kind isEqualToString:VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS]){
        NSInteger videoCount = [sellVideos count] ;
        NSInteger audioCount = [sellAudios count] ;
        NSInteger pdfCount = [sellPdfs count] ;
        if((videoCount < 1) && (audioCount < 1) && (pdfCount < 1)){
            subscruptionContentCompleted = NO ;
        }
    } else if([templateSubscription.kind isEqualToString:VEAM_SUBSCRIPTION_KIND_SELL_SECTION]){
        NSInteger count = [sellSectionItems count] ;
        if(count < 1){
            subscruptionContentCompleted = NO ;
        }
    }
    return subscruptionContentCompleted ;
}

- (BOOL)isSubscriptionDescriptionCompleted
{
    // at least 1 content
    
    BOOL subscruptionDescriptionCompleted = YES ;
    
    if([templateSubscription.kind isEqualToString:VEAM_SUBSCRIPTION_KIND_MIXED_GRID]){
        NSString *subscriptionDescriptionSet = [self getValueForKey:@"subscription_description_set"] ;
        if([VeamUtil isEmpty:subscriptionDescriptionSet]){
            subscruptionDescriptionCompleted = NO ;
        }
    }
    return subscruptionDescriptionCompleted ;
}


- (BOOL)isForumCompleted
{
    BOOL forumCompleted = YES ;
    NSInteger count = [forums count] ;
    //NSLog(@"forum count %d",count) ;
    if(count < 2){
        forumCompleted = NO ;
    }
    return forumCompleted ;
}

- (BOOL)isLinksCompleted
{
    BOOL linksCompleted = YES ;
    NSInteger count = [webs count] ;
    //NSLog(@"web count %d",count) ;
    if(count < 0){
        linksCompleted = NO ;
    } else {
        for(int index = 0 ; index < count ; index++){
            Web *web = [webs objectAtIndex:index] ;
            if([web.url isEqualToString:@"https://www.facebook.com/VeamApp"] || [web.url isEqualToString:@"https://twitter.com/VeamApp"]){
                linksCompleted = NO ;
            }
        }
    }
    return linksCompleted ;
}



- (BOOL)isRatingCompleted
{
    BOOL ratingCompleted = YES ;
    NSInteger count = [appRatingQuestions count] ;
    for(int index = 0 ; index < count ; index++){
        AppRatingQuestion *appRatingQuestion = [appRatingQuestions objectAtIndex:index] ;
        if([VeamUtil isEmpty:appRatingQuestion.answer]){
            ratingCompleted = NO ;
        }
    }
    return ratingCompleted ;
}

- (BOOL)isBankCompleted
{
    BOOL bankCompleted = YES ;
    if(![bankAccountInfo isCompleted]){
        bankCompleted = NO ;
    }
    return bankCompleted ;
}

- (CGFloat)getSettingCompletionRatio
{
    CGFloat ratio = 0 ;
    
    NSArray *requiredOperations = [self getRequiredOperationsToSubmit] ;
    if([requiredOperations count] == 0){
        ratio = 1.0 ;
    } else {
        //// Subscription //////////////////////////////////////
        if([self isSubscriptionContentCompleted]){
            ratio += 0.5 ;
        }
        
        //// Forum //////////////////////////////////////
        if([self isForumCompleted]){
            ratio += 0.1 ;
        }
        
        //// Links //////////////////////////////////////
        if([self isLinksCompleted]){
            ratio += 0.1 ;
        }
        
        //// App Info //////////////////////////////////////
        if(![VeamUtil isEmpty:appInfo.termsAcceptedAt]){
            ratio += 0.1 ;
        }
        if(![VeamUtil isEmpty:appInfo.description]){
            ratio += 0.05 ;
        }
        if(![VeamUtil isEmpty:appInfo.keyword]){
            ratio += 0.05 ;
        }
        if(![VeamUtil isEmpty:appInfo.category]){
            ratio += 0.05 ;
        }
        
        if([self isRatingCompleted]){
            ratio += 0.05 ;
        }
        
        if(ratio >= 1.0){
            ratio = 0.99 ;
        }
    }
    return ratio ;
}


- (void)setAppIconImage:(UIImage *)image
{
    NSString *apiName = @"app/seticonimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"icon.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:appInfo] ;
}

- (void)setAppCustomIconImage:(UIImage *)image
{
    NSString *apiName = @"app/setcustomiconimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"icon.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:appInfo] ;
}

- (void)setAppScreenShot:(UIImage *)image name:(NSString *)name
{
    NSString *apiName = @"app/setscreenshot" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name,@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:appInfo] ;
}

- (void)setAppColor:(NSString *)colorString name:(NSString *)name
{
    [dictionary setObject:colorString forKey:name] ;
    NSString *apiName = @"app/setcolor" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name,@"n",
                            colorString,@"c",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)setAppData:(NSString *)value name:(NSString *)name
{
    [dictionary setObject:value forKey:name] ;
    NSString *apiName = @"app/setvalue" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name,@"n",
                            value,@"v",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)setAppName:(NSString *)name
{
    [appInfo setName:name] ;
    [self saveAppInfo] ;
}

- (void)setAppStoreAppName:(NSString *)name
{
    [appInfo setStoreAppName:name] ;
    [self saveAppInfo] ;
}

- (void)setAppDescription:(NSString *)description
{
    [appInfo setDescription:description] ;
    [self saveAppInfo] ;
}

- (void)setAppKeyword:(NSString *)keyword
{
    [appInfo setKeyword:keyword] ;
    [self saveAppInfo] ;
}

- (void)setAppCategory:(NSString *)category
{
    [appInfo setCategory:category] ;
    [self saveAppInfo] ;
}

- (void)saveAppInfo
{
    NSString *apiName = @"app/setdata" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:appInfo.name],@"n",
                            [self escapeNull:appInfo.storeAppName],@"sn",
                            [self escapeNull:appInfo.category],@"c",
                            [self escapeNull:appInfo.subCategory],@"sc",
                            [self escapeNull:appInfo.description],@"d",
                            [self escapeNull:appInfo.keyword],@"k",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)saveBankAccountInfo
{
    NSString *apiName = @"app/setbankdata" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:bankAccountInfo.routingNumber],@"ro",
                            [self escapeNull:bankAccountInfo.accountNumber],@"nu",
                            [self escapeNull:bankAccountInfo.accountName],@"na",
                            [self escapeNull:bankAccountInfo.accountType],@"ty",
                            [self escapeNull:bankAccountInfo.streetAddress],@"ad",
                            [self escapeNull:bankAccountInfo.city],@"ci",
                            [self escapeNull:bankAccountInfo.state],@"st",
                            [self escapeNull:bankAccountInfo.zipCode],@"zi",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}


- (NSInteger)getNumberOfAppRatingQuestions
{
    return [appRatingQuestions count] ;
}

- (AppRatingQuestion *)getAppRatingQuestionAt:(NSInteger)index
{
    AppRatingQuestion *retValue = nil ;
    if(index < [appRatingQuestions count]){
        retValue = [appRatingQuestions objectAtIndex:index] ;
    }
    return retValue ;
}

- (AppRatingQuestion *)getAppRatingQuestionForId:(NSString *)appRatingQuestionId
{
    NSInteger count = [appRatingQuestions count] ;
    AppRatingQuestion *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        AppRatingQuestion *appRatingQuestion = [appRatingQuestions objectAtIndex:index] ;
        if([[appRatingQuestion appRatingQuestionId] isEqualToString:appRatingQuestionId]){
            retValue = appRatingQuestion ;
            break ;
        }
    }
    return retValue ;
}

- (void)setAppRatingQuestion:(AppRatingQuestion *)appRatingQuestion
{
    if([VeamUtil isEmpty:appRatingQuestion.appRatingQuestionId]){
        [appRatingQuestions insertObject:appRatingQuestion atIndex:0] ;
    } else {
        int count = [appRatingQuestions count] ;
        for(int index = 0 ; index  < count ; index++){
            AppRatingQuestion *workAppRatingQuestion = [appRatingQuestions objectAtIndex:index] ;
            if([workAppRatingQuestion.appRatingQuestionId isEqual:appRatingQuestion.appRatingQuestionId]){
                [appRatingQuestions removeObjectAtIndex:index] ;
                [appRatingQuestions insertObject:appRatingQuestion atIndex:index] ;
                break ;
            }
        }
    }
    [self saveAppRatingQuestion:appRatingQuestion] ;
}

- (void)saveAppRatingQuestion:(AppRatingQuestion *)appRatingQuestion
{
    NSString *apiName = @"app/setratingquestion" ;
    NSString *appRatingQuestionId = @"" ;
    if(![VeamUtil isEmpty:appRatingQuestion.appRatingQuestionId]){
        appRatingQuestionId = appRatingQuestion.appRatingQuestionId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:appRatingQuestionId],@"i",
                            [self escapeNull:appRatingQuestion.answer],@"an",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}



/////////////////////////////////////////////////////////////////////////////////
#pragma mark Subscription
/////////////////////////////////////////////////////////////////////////////////
- (void)setTemplateSubscriptionTitle:(NSString *)title
{
    [templateSubscription setTitle:title] ;
    [self saveTemplateSubscription] ;
}

- (void)setTemplateSubscriptionLayout:(NSString *)layout
{
    [templateSubscription setLayout:layout] ;
    [self saveTemplateSubscription] ;
}

- (void)setTemplateSubscriptionPrice:(NSString *)price
{
    //NSLog(@"setTemplateSubscriptionPrice %@",price) ;
    [templateSubscription setPrice:price] ;
    [self saveTemplateSubscription] ;
}

- (void)setTemplateSubscriptionKind:(NSString *)kind
{
    //NSLog(@"setTemplateSubscriptionKind %@",kind) ;
    [templateSubscription setKind:kind] ;
    [self saveTemplateSubscription] ;
}

- (void)setTemplateSubscriptionRightImage:(UIImage *)image
{
    NSString *apiName = @"subscription/setrightimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"t8_top_right.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:templateSubscription] ;
}

- (void)saveTemplateSubscription
{
    NSString *apiName = @"subscription/setdata" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:templateSubscription.title],@"t",
                            [self escapeNull:templateSubscription.layout],@"l",
                            [self escapeNull:templateSubscription.kind],@"k",
                            [self escapeNull:templateSubscription.price],@"p",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (BOOL)isAppReleased
{
    return [appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_RELEASED] ;
}

- (NSTimeInterval)getNextUploadTime
{
    NSInteger numberOfMixeds = [self getNumberOfMixedsForCategory:@"0"] ;
    NSString *previousDateString ;
    if(numberOfMixeds <= 2){
        previousDateString = appInfo.releasedAt ;
    } else {
        //Mixed *mixed = [self getMixedForCategory:@"0" at:numberOfMixeds-1 order:NSOrderedAscending] ;
        Mixed *mixed = [self getMixedForCategory:@"0" at:0 order:NSOrderedAscending] ;
        previousDateString = mixed.createdAt ;
    }
    
    double uploadSpan = [templateSubscription.uploadSpan doubleValue] ;
    double deadline = [previousDateString doubleValue] + (uploadSpan * 86400) ; // 60x60x24=86400
    
    return deadline ;
}




/////////////////////////////////////////////////////////////////////////////////
#pragma mark Video
/////////////////////////////////////////////////////////////////////////////////
- (void)setVideoCategory:(VideoCategory *)videoCategory
{
    if([VeamUtil isEmpty:videoCategory.videoCategoryId]){
        [videoCategories insertObject:videoCategory atIndex:0] ;
    } else {
        int count = [videoCategories count] ;
        for(int index = 0 ; index  < count ; index++){
            VideoCategory *workVideoCategory = [videoCategories objectAtIndex:index] ;
            if([workVideoCategory.videoCategoryId isEqual:videoCategory.videoCategoryId]){
                [videoCategories removeObjectAtIndex:index] ;
                [videoCategories insertObject:videoCategory atIndex:index] ;
                break ;
            }
        }
    }
    [self saveVideoCategory:videoCategory] ;
}

- (void)saveVideoCategory:(VideoCategory *)videoCategory
{
    NSString *apiName = @"video/setcategory" ;
    NSString *videoCategoryId = @"" ;
    if(![VeamUtil isEmpty:videoCategory.videoCategoryId]){
        videoCategoryId = videoCategory.videoCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:videoCategoryId],@"i",
                            [self escapeNull:videoCategory.name],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:videoCategory] ;
    self.appInfo.modified = @"1" ;
}

- (void)removeVideoCategoryAt:(NSInteger)index
{
    NSString *videoCategoryIdToBeRemoved = nil ;
    int count = [videoCategories count] ;
    if(index < count){
        VideoCategory *videoCategory = [videoCategories objectAtIndex:index] ;
        videoCategoryIdToBeRemoved = videoCategory.videoCategoryId ;
        [videoCategories removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:videoCategoryIdToBeRemoved]){
        NSString *apiName = @"video/removecategory" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:videoCategoryIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (NSInteger)getNumberOfVideoCategories
{
    return [videoCategories count] ;
}

- (NSMutableArray *)getVideoCategories
{
    return videoCategories ;
}

- (VideoCategory *)getVideoCategoryAt:(NSInteger)index
{
    VideoCategory *retValue = nil ;
    if(index < [videoCategories count]){
        retValue = [videoCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveVideoCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    VideoCategory *objectToBeMoved = [videoCategories objectAtIndex:fromIndex] ;
    [videoCategories removeObjectAtIndex:fromIndex] ;
    [videoCategories insertObject:objectToBeMoved atIndex:toIndex] ;
    [self saveVideoCategoryOrder] ;
}

- (void)saveVideoCategoryOrder
{
    int count = [videoCategories count] ;
    if(count > 1){
        NSString *apiName = @"video/setcategoryorder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            VideoCategory *category = [videoCategories objectAtIndex:index] ;
            if(index == 0){
                orderString = category.videoCategoryId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",category.videoCategoryId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}


- (VideoCategory *)getVideoCategoryForId:(NSString *)videoCategoryId
{
    NSInteger count = [videoCategories count] ;
    VideoCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        VideoCategory *videoCategory = [videoCategories objectAtIndex:index] ;
        if([[videoCategory videoCategoryId] isEqualToString:videoCategoryId]){
            retValue = videoCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSMutableArray *)getVideoSubCategories:(NSString *)videoCategoryId
{
    NSMutableArray *retValue = [videoSubCategoriesPerCategory objectForKey:videoCategoryId] ;
    return retValue ;
}

- (NSInteger)getNumberOfVideoSubCategories:(NSString *)videoCategoryId
{
    return [[self getVideoSubCategories:videoCategoryId] count] ;
}

- (VideoSubCategory *)getVideoSubCategoryAt:(NSInteger)index videoCategoryId:(NSString *)videoCategoryId
{
    VideoSubCategory *retValue = nil ;
    if(index < [[self getVideoSubCategories:videoCategoryId] count]){
        retValue = [[self getVideoSubCategories:videoCategoryId] objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveVideoSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex videoCategoryId:(NSString *)videoCategoryId
{
    NSMutableArray *subCategories = [self getVideoSubCategories:videoCategoryId] ;
    if(subCategories != nil){
        VideoSubCategory *objectToBeMoved = [subCategories objectAtIndex:fromIndex] ;
        [subCategories removeObjectAtIndex:fromIndex] ;
        [subCategories insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveVideoSubCategoryOrder:videoCategoryId] ;
    }
}

- (void)saveVideoSubCategoryOrder:(NSString *)videoCategoryId
{
    
    NSMutableArray *subCategories = [self getVideoSubCategories:videoCategoryId] ;
    if(subCategories != nil){
        int count = [subCategories count] ;
        if(count > 1){
            NSString *apiName = @"video/setsubcategoryorder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                VideoSubCategory *subCategory = [subCategories objectAtIndex:index] ;
                if(index == 0){
                    orderString = subCategory.videoSubCategoryId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",subCategory.videoSubCategoryId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setVideoSubCategory:(VideoSubCategory *)videoSubCategory
{
    NSMutableArray *subCategories = [self getVideoSubCategories:videoSubCategory.videoCategoryId] ;
    if(subCategories == nil){
        subCategories = [NSMutableArray array] ;
        [videoSubCategoriesPerCategory setObject:subCategories forKey:videoSubCategory.videoCategoryId] ;
    }
    
    if(subCategories != nil){
        if([VeamUtil isEmpty:videoSubCategory.videoSubCategoryId]){
            [subCategories insertObject:videoSubCategory atIndex:0] ;
        } else {
            int count = [subCategories count] ;
            for(int index = 0 ; index  < count ; index++){
                VideoSubCategory *workVideoSubCategory = [subCategories objectAtIndex:index] ;
                if([workVideoSubCategory.videoSubCategoryId isEqual:videoSubCategory.videoSubCategoryId]){
                    [subCategories removeObjectAtIndex:index] ;
                    [subCategories insertObject:videoSubCategory atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveVideoSubCategory:videoSubCategory] ;
    }
}

- (void)saveVideoSubCategory:(VideoSubCategory *)videoSubCategory
{
    NSString *apiName = @"video/setsubcategory" ;
    NSString *videoSubCategoryId = @"" ;
    if(![VeamUtil isEmpty:videoSubCategory.videoSubCategoryId]){
        videoSubCategoryId = videoSubCategory.videoSubCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:videoSubCategoryId],@"i",
                            [self escapeNull:videoSubCategory.videoCategoryId],@"c",
                            [self escapeNull:videoSubCategory.name],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:videoSubCategory] ;
    self.appInfo.modified = @"1" ;
}

- (void)removeVideoSubCategoryAt:(NSInteger)index videoCategoryId:(NSString *)videoCategoryId
{
    NSMutableArray *subCategories = [self getVideoSubCategories:videoCategoryId] ;
    if(subCategories != nil){
        NSString *videoSubCategoryIdToBeRemoved = nil ;
        int count = [subCategories count] ;
        if(index < count){
            VideoSubCategory *videoSubCategory = [subCategories objectAtIndex:index] ;
            videoSubCategoryIdToBeRemoved = videoSubCategory.videoSubCategoryId ;
            [subCategories removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:videoSubCategoryIdToBeRemoved]){
            NSString *apiName = @"video/removesubcategory" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:videoSubCategoryIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (NSInteger)getNumberOfVideosForCategory:(NSString *)videoCategoryId
{
    return [[self getVideosForCategory:videoCategoryId] count] ;
}

- (NSInteger)getNumberOfVideosForSubCategory:(NSString *)videoSubCategoryId
{
    return [[self getVideosForSubCategory:videoSubCategoryId] count] ;
}

- (NSMutableArray *)getVideosForCategory:(NSString *)videoCategoryId
{
    NSMutableArray *retValue = [videosPerCategory objectForKey:videoCategoryId] ;
    return retValue ;
}

- (NSInteger)getNumberOfWaitingVideoForCategory:(NSString *)videoCategoryId
{
    NSInteger numberOfWaitingVideos = 0 ;
    NSMutableArray *videos = [self getVideosForCategory:videoCategoryId] ;
    NSInteger count = [videos count] ;
    for(int index = 0 ; index < count ; index++){
        Video *video = [videos objectAtIndex:index] ;
        if([video.status isEqual:VEAM_VIDEO_STATUS_WAITING]){
            numberOfWaitingVideos++ ;
        }
    }
    return numberOfWaitingVideos ;
}


- (NSInteger)getNumberOfWaitingMixedForCategory:(NSString *)mixedCategoryId
{
    NSInteger numberOfWaitingMixeds = 0 ;
    NSMutableArray *mixeds = [self getMixedsForCategory:mixedCategoryId] ;
    NSInteger count = [mixeds count] ;
    for(int index = 0 ; index < count ; index++){
        Mixed *mixed = [mixeds objectAtIndex:index] ;
        if([mixed.status isEqual:VEAM_MIXED_STATUS_WAITING]){
            numberOfWaitingMixeds++ ;
        }
    }
    return numberOfWaitingMixeds ;
}



- (NSMutableArray *)getVideosForSubCategory:(NSString *)videoSubCategoryId
{
    NSMutableArray *retValue = [videosPerSubCategory objectForKey:videoSubCategoryId] ;
    return retValue ;
}

- (Video *)getVideoForId:(NSString *)videoId
{
    Video *retValue = nil ;
    retValue = [videosForVideoId objectForKey:videoId] ;
    return retValue ;
}

- (Video *)getVideoForCategory:(NSString *)videoCategoryId at:(NSInteger)index
{
    Video *retValue = nil ;
    NSArray *videos = [self getVideosForCategory:videoCategoryId] ;
    retValue = [videos objectAtIndex:index] ;
    return retValue ;
}

- (Video *)getVideoForSubCategory:(NSString *)videoSubCategoryId at:(NSInteger)index
{
    Video *retValue = nil ;
    NSArray *videos = [self getVideosForSubCategory:videoSubCategoryId] ;
    retValue = [videos objectAtIndex:index] ;
    return retValue ;
}

- (void)moveVideoForCategory:(NSString *)videoCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *videos = [self getVideosForCategory:videoCategoryId] ;
    if(videos != nil){
        Video *objectToBeMoved = [videos objectAtIndex:fromIndex] ;
        [videos removeObjectAtIndex:fromIndex] ;
        [videos insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveVideoOrder:videos] ;
    }
}

- (void)moveVideoForSubCategory:(NSString *)videoSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *videos = [self getVideosForSubCategory:videoSubCategoryId] ;
    if(videos != nil){
        Video *objectToBeMoved = [videos objectAtIndex:fromIndex] ;
        [videos removeObjectAtIndex:fromIndex] ;
        [videos insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveVideoOrder:videos] ;
    }
}

- (void)saveVideoOrder:(NSMutableArray *)videos
{
    if(videos != nil){
        int count = [videos count] ;
        if(count > 1){
            NSString *apiName = @"video/setvideoorder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                Video *video = [videos objectAtIndex:index] ;
                if(index == 0){
                    orderString = video.videoId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",video.videoId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setVideo:(Video *)video thumbnailImage:(UIImage *)thumbnailImage
{
    NSMutableArray *videos = nil ;
    if([video.videoSubCategoryId isEqual:@"0"]){
        videos = [self getVideosForCategory:video.videoCategoryId] ;
    } else {
        videos = [self getVideosForSubCategory:video.videoSubCategoryId] ;
    }
    
    if(videos == nil){
        videos = [NSMutableArray array] ;
        if([video.videoSubCategoryId isEqual:@"0"]){
            [videosPerCategory setObject:videos forKey:video.videoCategoryId] ;
        } else {
            [videosPerSubCategory setObject:videos forKey:video.videoSubCategoryId] ;
        }
    }
    
    if(videos != nil){
        if([VeamUtil isEmpty:video.videoId]){
            [videos insertObject:video atIndex:0] ;
        } else {
            int count = [videos count] ;
            for(int index = 0 ; index  < count ; index++){
                Video *workVideo = [videos objectAtIndex:index] ;
                if([workVideo.videoId isEqual:video.videoId]){
                    [videos removeObjectAtIndex:index] ;
                    [videos insertObject:video atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveVideo:video thumbnailImage:thumbnailImage] ;
    }
}

- (void)saveVideo:(Video *)video thumbnailImage:(UIImage *)thumbnailImage
{
    Mixed *mixed = video.mixed ;
    if((mixed != nil) && ![VeamUtil isEmpty:mixed.kind]){
        NSString *apiName = @"mixed/setvideo" ;
        //NSLog(@"%@",apiName) ;
        NSString *videoId = @"" ;
        if(![VeamUtil isEmpty:video.videoId]){
            videoId = video.videoId ;
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:mixed.mixedId],@"i",
                                [self escapeNull:mixed.mixedCategoryId],@"c",
                                [self escapeNull:mixed.mixedSubCategoryId],@"sub",
                                [self escapeNull:mixed.kind],@"k",
                                [self escapeNull:@""],@"vi",
                                [self escapeNull:video.title],@"t",
                                [self escapeNull:video.sourceUrl],@"su",
                                [self escapeNull:video.imageUrl],@"iu",
                                nil] ;
        [self sendData:apiName params:params image:thumbnailImage handlePostResultDelegate:mixed] ;
        self.appInfo.modified = @"1" ;
    } else {
        NSString *apiName = @"video/setvideo" ;
        //NSLog(@"%@",apiName) ;
        NSString *videoId = @"" ;
        if(![VeamUtil isEmpty:video.videoId]){
            videoId = video.videoId ;
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:videoId],@"i",
                                [self escapeNull:video.videoCategoryId],@"c",
                                [self escapeNull:video.videoSubCategoryId],@"sub",
                                [self escapeNull:video.title],@"t",
                                [self escapeNull:video.kind],@"k",
                                //[self escapeNull:video.duration],@"dur",
                                [self escapeNull:video.sourceUrl],@"su",
                                nil] ;
        [self sendData:apiName params:params image:thumbnailImage handlePostResultDelegate:video] ;
        self.appInfo.modified = @"1" ;
    }
}

- (void)updatePreparingVideoStatus:(NSString *)videoCategoryId
{
    NSString *apiName = @"video/getvideostatus" ;

    NSString *preparingVideoIds = @"" ;
    
    NSMutableArray *videos = [self getVideosForCategory:videoCategoryId] ;
    NSInteger count = [videos count] ;
    for(int index = 0 ; index < count ; index++){
        Video *video = [videos objectAtIndex:index] ;
        if([video.status isEqual:VEAM_VIDEO_STATUS_PREPARING]){
            if(![VeamUtil isEmpty:preparingVideoIds]){
                preparingVideoIds = [preparingVideoIds stringByAppendingFormat:@",%@",video.videoId] ;
            } else {
                preparingVideoIds = video.videoId ;
            }
        }
    }
    
    if(![VeamUtil isEmpty:preparingVideoIds]){
        ConsoleUpdatePreparingVideoStatusHandler *handler = [[ConsoleUpdatePreparingVideoStatusHandler alloc] init] ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:preparingVideoIds],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:handler] ;
    }
}



- (void)removeVideoForCategory:(NSString *)videoCategoryId at:(NSInteger)index
{
    NSMutableArray *videos = [self getVideosForCategory:videoCategoryId] ;
    [self removeVideoFrom:videos at:index] ;
}

- (void)removeVideoForSubCategory:(NSString *)videoSubCategoryId at:(NSInteger)index
{
    NSMutableArray *videos = [self getVideosForSubCategory:videoSubCategoryId] ;
    [self removeVideoFrom:videos at:index] ;
}

- (void)removeVideoFrom:(NSMutableArray *)videos at:(NSInteger)index
{
    if(videos != nil){
        NSString *videoIdToBeRemoved = nil ;
        int count = [videos count] ;
        if(index < count){
            Video *video = [videos objectAtIndex:index] ;
            videoIdToBeRemoved = video.videoId ;
            [videos removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:videoIdToBeRemoved]){
            NSString *apiName = @"video/removevideo" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:videoIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}


- (NSInteger)getNumberOfSellVideosForVideoCategory:(NSString *)videoCategoryId
{
    //NSLog(@"getNumberOfSellVideosForVideoCategory videoCategoryId=%@",videoCategoryId) ;
    NSInteger retValue = 0 ;
    NSArray *sellVideosForCategory = [self getSellVideosForVideoCategory:videoCategoryId] ;
    if(sellVideosForCategory != nil){
        retValue = [sellVideosForCategory count] ;
    }
    return retValue ;
}

- (NSArray *)getSellVideosForVideoCategory:(NSString *)videoCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellVideos count] ;
    //NSLog(@"getSellVideosForVideoCategory count=%d",count) ;
    for(int index = 0 ; index < count ; index++){
        SellVideo *sellVideo = [sellVideos objectAtIndex:index] ;
        if(sellVideo != nil){
            Video *video = [self getVideoForId:sellVideo.videoId] ;
            if(video != nil){
                if([video.videoCategoryId isEqualToString:videoCategoryId]){
                    [retValue addObject:sellVideo] ;
                }
            }
        }
    }
    return retValue ;
}

- (SellVideo *)getSellVideoForVideoCategory:(NSString *)videoCategoryId at:(NSInteger)index order:(NSComparisonResult)order
{
    SellVideo *retValue = nil ;
    NSArray *sellVideosForCategory = [self getSellVideosForVideoCategory:videoCategoryId] ;
    if(sellVideosForCategory != nil){
        if([sellVideosForCategory count] >index){
            retValue = [sellVideosForCategory objectAtIndex:index] ;
        }
    }
    
    return retValue ;
}



- (void)removeSellVideoForVideoCategory:(NSString *)videoCategoryId at:(NSInteger)index
{
    NSMutableArray *sellVideosForCategory = [self getSellVideosForVideoCategory:videoCategoryId] ;
    [self removeSellVideoFrom:sellVideosForCategory at:index] ;
}

- (void)removeSellVideoFrom:(NSMutableArray *)sellVideosForCategory at:(NSInteger)index
{
    if(sellVideosForCategory != nil){
        NSString *sellVideoIdToBeRemoved = nil ;
        int count = [sellVideosForCategory count] ;
        if(index < count){
            SellVideo *sellVideo = [sellVideosForCategory objectAtIndex:index] ;
            sellVideoIdToBeRemoved = sellVideo.sellVideoId ;
            [sellVideosForCategory removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:sellVideoIdToBeRemoved]){
            NSString *apiName = @"sellitem/removesellvideo" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:sellVideoIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
            int count = [sellVideos count] ;
            //NSLog(@"sellVideos count=%d",count) ;
            for(int sellVideoIndex = 0 ; sellVideoIndex < count ; sellVideoIndex++){
                SellVideo *sellVideo = [sellVideos objectAtIndex:sellVideoIndex] ;
                if(sellVideo != nil){
                    NSString *workSellVideoId = [sellVideo sellVideoId] ;
                    if([sellVideoIdToBeRemoved isEqualToString:workSellVideoId]){
                        [sellVideos removeObjectAtIndex:sellVideoIndex] ;
                        break ;
                    }
                }
            }
            [sellVideosForSellVideoId removeObjectForKey:sellVideoIdToBeRemoved] ;
        }
    }
}










- (SellVideo *)getSellVideoForId:(NSString *)sellVideoId
{
    SellVideo *retValue = nil ;
    retValue = [sellVideosForSellVideoId objectForKey:sellVideoId] ;
    return retValue ;
}

- (void)setSellVideo:(SellVideo *)sellVideo videoCategoryId:(NSString *)videoCategoryId videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl videoImageUrl:(NSString *)videoImageUrl
{
    NSMutableArray *workSellVideos = nil ;
    workSellVideos = [self getSellVideosForVideoCategory:videoCategoryId] ;
    
    if(workSellVideos == nil){
        workSellVideos = [NSMutableArray array] ;
    }
    
    if(workSellVideos != nil){
        if([VeamUtil isEmpty:sellVideo.sellVideoId]){
            [workSellVideos insertObject:sellVideo atIndex:0] ;
        } else {
            int count = [workSellVideos count] ;
            for(int index = 0 ; index  < count ; index++){
                SellVideo *workSellVideo = [workSellVideos objectAtIndex:index] ;
                if([workSellVideo.sellVideoId isEqual:sellVideo.sellVideoId]){
                    [workSellVideos removeObjectAtIndex:index] ;
                    [workSellVideos insertObject:sellVideo atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveSellVideo:sellVideo videoCategoryId:videoCategoryId videoTitle:videoTitle videoSourceUrl:videoSourceUrl videoImageUrl:videoImageUrl] ;
    }
}

- (void)saveSellVideo:(SellVideo *)sellVideo videoCategoryId:(NSString *)videoCategoryId videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl videoImageUrl:(NSString *)videoImageUrl
{
    NSString *apiName = @"sellitem/setvideo" ;
    //NSLog(@"%@",apiName) ;
    NSString *sellVideoId = @"" ;
    if(![VeamUtil isEmpty:sellVideo.sellVideoId]){
        sellVideoId = sellVideo.sellVideoId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellVideoId],@"i",
                            [self escapeNull:videoCategoryId],@"c",
                            [self escapeNull:sellVideo.description],@"d",
                            [self escapeNull:sellVideo.price],@"p",
                            [self escapeNull:videoTitle],@"t",
                            [self escapeNull:videoSourceUrl],@"su",
                            [self escapeNull:videoImageUrl],@"iu",
                            nil] ;
    
    Video *video = [[Video alloc] init] ;
    [video setTitle:videoTitle] ;
    [video setVideoCategoryId:videoCategoryId] ;
    
    ConsoleSellVideoPostHandler *consoleSellVideoPostHandler = [[ConsoleSellVideoPostHandler alloc] init] ;
    [consoleSellVideoPostHandler setSellVideo:sellVideo] ;
    [consoleSellVideoPostHandler setVideo:video] ;
    
    [self sendData:apiName params:params image:nil handlePostResultDelegate:consoleSellVideoPostHandler] ;
    self.appInfo.modified = @"1" ;
}















/////////////////////////////////////////////////////////////////////////////////
#pragma mark Audio
/////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray *)getAudiosForSubCategory:(NSString *)audioSubCategoryId
{
    NSMutableArray *retValue = [audiosPerSubCategory objectForKey:audioSubCategoryId] ;
    return retValue ;
}

- (NSMutableArray *)getAudiosForCategory:(NSString *)audioCategoryId
{
    NSMutableArray *retValue = [audiosPerCategory objectForKey:audioCategoryId] ;
    return retValue ;
}

- (void)setAudio:(Audio *)audio thumbnailImage:(UIImage *)thumbnailImage
{
    NSMutableArray *audios = nil ;
    if([audio.audioSubCategoryId isEqual:@"0"]){
        audios = [self getAudiosForCategory:audio.audioCategoryId] ;
    } else {
        audios = [self getAudiosForSubCategory:audio.audioSubCategoryId] ;
    }
    
    if(audios == nil){
        audios = [NSMutableArray array] ;
        if([audio.audioSubCategoryId isEqual:@"0"]){
            [audiosPerCategory setObject:audios forKey:audio.audioCategoryId] ;
        } else {
            [audiosPerSubCategory setObject:audios forKey:audio.audioSubCategoryId] ;
        }
    }
    
    if(audios != nil){
        if([VeamUtil isEmpty:audio.audioId]){
            [audios insertObject:audio atIndex:0] ;
        } else {
            int count = [audios count] ;
            for(int index = 0 ; index  < count ; index++){
                Audio *workAudio = [audios objectAtIndex:index] ;
                if([workAudio.audioId isEqual:audio.audioId]){
                    [audios removeObjectAtIndex:index] ;
                    [audios insertObject:audio atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveAudio:audio thumbnailImage:thumbnailImage] ;
    }
}

- (void)saveAudio:(Audio *)audio thumbnailImage:(UIImage *)thumbnailImage
{
    Mixed *mixed = audio.mixed ;
    if((mixed != nil) && ![VeamUtil isEmpty:mixed.kind]){
        NSString *apiName = @"mixed/setaudio" ;
        //NSLog(@"%@",apiName) ;
        NSString *audioId = @"" ;
        if(![VeamUtil isEmpty:audio.audioId]){
            audioId = audio.audioId ;
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:mixed.mixedId],@"i",
                                [self escapeNull:mixed.mixedCategoryId],@"c",
                                [self escapeNull:mixed.mixedSubCategoryId],@"sub",
                                [self escapeNull:mixed.kind],@"k",
                                [self escapeNull:@""],@"ai",
                                [self escapeNull:audio.title],@"t",
                                [self escapeNull:audio.dataUrl],@"su",
                                [self escapeNull:audio.linkUrl],@"lu",
                                [self escapeNull:audio.imageUrl],@"iu",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:mixed] ;
        self.appInfo.modified = @"1" ;
    } else {
        /* not implemented
        NSString *apiName = @"audio/setaudio" ;
        NSLog(@"%@",apiName) ;
        NSString *audioId = @"" ;
        if(![VeamUtil isEmpty:audio.audioId]){
            audioId = audio.audioId ;
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:audioId],@"i",
                                [self escapeNull:audio.audioCategoryId],@"c",
                                [self escapeNull:audio.audioSubCategoryId],@"sub",
                                [self escapeNull:audio.title],@"t",
                                [self escapeNull:audio.kind],@"k",
                                //[self escapeNull:audio.duration],@"dur",
                                [self escapeNull:audio.sourceUrl],@"su",
                                nil] ;
        [self sendData:apiName params:params image:thumbnailImage handlePostResultDelegate:audio] ;
         */
    }
}




- (Audio *)getAudioForId:(NSString *)audioId
{
    Audio *retValue = nil ;
    retValue = [audiosForAudioId objectForKey:audioId] ;
    return retValue ;
}






- (NSInteger)getNumberOfSellAudiosForAudioCategory:(NSString *)audioCategoryId
{
    //NSLog(@"getNumberOfSellAudiosForAudioCategory audioCategoryId=%@",audioCategoryId) ;
    NSInteger retValue = 0 ;
    NSArray *sellAudiosForCategory = [self getSellAudiosForAudioCategory:audioCategoryId] ;
    if(sellAudiosForCategory != nil){
        retValue = [sellAudiosForCategory count] ;
    }
    return retValue ;
}

- (NSArray *)getSellAudiosForAudioCategory:(NSString *)audioCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellAudios count] ;
    //NSLog(@"getSellAudiosForAudioCategory count=%d",count) ;
    for(int index = 0 ; index < count ; index++){
        SellAudio *sellAudio = [sellAudios objectAtIndex:index] ;
        if(sellAudio != nil){
            Audio *audio = [self getAudioForId:sellAudio.audioId] ;
            if(audio != nil){
                if([audio.audioCategoryId isEqualToString:audioCategoryId]){
                    [retValue addObject:sellAudio] ;
                }
            }
        }
    }
    return retValue ;
}

- (SellAudio *)getSellAudioForAudioCategory:(NSString *)audioCategoryId at:(NSInteger)index order:(NSComparisonResult)order
{
    SellAudio *retValue = nil ;
    NSArray *sellAudiosForCategory = [self getSellAudiosForAudioCategory:audioCategoryId] ;
    if(sellAudiosForCategory != nil){
        if([sellAudiosForCategory count] >index){
            retValue = [sellAudiosForCategory objectAtIndex:index] ;
        }
    }
    
    return retValue ;
}

- (SellAudio *)getSellAudioForId:(NSString *)sellAudioId
{
    SellAudio *retValue = nil ;
    retValue = [sellAudiosForSellAudioId objectForKey:sellAudioId] ;
    return retValue ;
}




- (void)removeSellAudioForAudioCategory:(NSString *)audioCategoryId at:(NSInteger)index
{
    NSMutableArray *sellAudiosForCategory = [self getSellAudiosForAudioCategory:audioCategoryId] ;
    [self removeSellAudioFrom:sellAudiosForCategory at:index] ;
}

- (void)removeSellAudioFrom:(NSMutableArray *)sellAudiosForCategory at:(NSInteger)index
{
    if(sellAudiosForCategory != nil){
        NSString *sellAudioIdToBeRemoved = nil ;
        int count = [sellAudiosForCategory count] ;
        if(index < count){
            SellAudio *sellAudio = [sellAudiosForCategory objectAtIndex:index] ;
            sellAudioIdToBeRemoved = sellAudio.sellAudioId ;
            [sellAudiosForCategory removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:sellAudioIdToBeRemoved]){
            NSString *apiName = @"sellitem/removesellaudio" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:sellAudioIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
            int count = [sellAudios count] ;
            for(int sellAudioIndex = 0 ; sellAudioIndex < count ; sellAudioIndex++){
                SellAudio *sellAudio = [sellAudios objectAtIndex:sellAudioIndex] ;
                if(sellAudio != nil){
                    NSString *workSellAudioId = [sellAudio sellAudioId] ;
                    if([sellAudioIdToBeRemoved isEqualToString:workSellAudioId]){
                        [sellAudios removeObjectAtIndex:sellAudioIndex] ;
                        break ;
                    }
                }
            }
            [sellAudiosForSellAudioId removeObjectForKey:sellAudioIdToBeRemoved] ;
        }
    }
}









- (void)setSellAudio:(SellAudio *)sellAudio audioCategoryId:(NSString *)audioCategoryId audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl  audioLinkUrl:(NSString *)audioLinkUrl
{
    NSMutableArray *workSellAudios = nil ;
    workSellAudios = [self getSellAudiosForAudioCategory:audioCategoryId] ;
    
    if(workSellAudios == nil){
        workSellAudios = [NSMutableArray array] ;
    }
    
    if(workSellAudios != nil){
        if([VeamUtil isEmpty:sellAudio.sellAudioId]){
            [workSellAudios insertObject:sellAudio atIndex:0] ;
        } else {
            int count = [workSellAudios count] ;
            for(int index = 0 ; index  < count ; index++){
                SellAudio *workSellAudio = [workSellAudios objectAtIndex:index] ;
                if([workSellAudio.sellAudioId isEqual:sellAudio.sellAudioId]){
                    [workSellAudios removeObjectAtIndex:index] ;
                    [workSellAudios insertObject:sellAudio atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveSellAudio:sellAudio audioCategoryId:audioCategoryId audioTitle:audioTitle audioSourceUrl:audioSourceUrl audioImageUrl:audioImageUrl audioLinkUrl:audioLinkUrl] ;
    }
}

- (void)saveSellAudio:(SellAudio *)sellAudio audioCategoryId:(NSString *)audioCategoryId audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl audioLinkUrl:(NSString *)audioLinkUrl
{
    NSString *apiName = @"sellitem/setaudio" ;
    //NSLog(@"%@",apiName) ;
    NSString *sellAudioId = @"" ;
    if(![VeamUtil isEmpty:sellAudio.sellAudioId]){
        sellAudioId = sellAudio.sellAudioId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellAudioId],@"i",
                            [self escapeNull:audioCategoryId],@"c",
                            [self escapeNull:sellAudio.description],@"d",
                            [self escapeNull:sellAudio.price],@"p",
                            [self escapeNull:audioTitle],@"t",
                            [self escapeNull:audioSourceUrl],@"su",
                            [self escapeNull:audioImageUrl],@"iu",
                            [self escapeNull:audioLinkUrl],@"lu",
                            nil] ;
    
    Audio *audio = [[Audio alloc] init] ;
    [audio setTitle:audioTitle] ;
    [audio setAudioCategoryId:audioCategoryId] ;
    
    ConsoleSellAudioPostHandler *consoleSellAudioPostHandler = [[ConsoleSellAudioPostHandler alloc] init] ;
    [consoleSellAudioPostHandler setSellAudio:sellAudio] ;
    [consoleSellAudioPostHandler setAudio:audio] ;
    
    [self sendData:apiName params:params image:nil handlePostResultDelegate:consoleSellAudioPostHandler] ;
    self.appInfo.modified = @"1" ;
}

- (AudioCategory *)getAudioCategoryForId:(NSString *)audioCategoryId
{
    NSInteger count = [audioCategories count] ;
    AudioCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        AudioCategory *audioCategory = [audioCategories objectAtIndex:index] ;
        if([[audioCategory audioCategoryId] isEqualToString:audioCategoryId]){
            retValue = audioCategory ;
            break ;
        }
    }
    return retValue ;
}
















/////////////////////////////////////////////////////////////////////////////////
#pragma mark Youtube
/////////////////////////////////////////////////////////////////////////////////
- (void)setTemplateYoutubeTitle:(NSString *)title
{
    [templateYoutube setTitle:title] ;
    [self saveTemplateYoutube] ;
}

- (void)setTemplateYoutubeEmbedFlag:(BOOL)embedFlag
{
    [templateYoutube setEmbedFlag:embedFlag?@"1":@"0"] ;
    [self saveTemplateYoutube] ;
}

- (void)setTemplateYoutubeEmbedUrl:(NSString *)url
{
    [templateYoutube setEmbedUrl:url] ;
    [self saveTemplateYoutube] ;
}

- (void)setTemplateYoutubeLeftImage:(UIImage *)image
{
    NSString *apiName = @"youtube/setleftimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"t1_top_left.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:templateYoutube] ;
}

- (void)setTemplateYoutubeRightImage:(UIImage *)image
{
    NSString *apiName = @"youtube/setrightimage" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"t1_top_right.png",@"n",
                            nil] ;
    [self sendData:apiName params:params image:(UIImage *)image handlePostResultDelegate:templateYoutube] ;
}

- (void)saveTemplateYoutube
{
    NSString *apiName = @"youtube/setdata" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:templateYoutube.title],@"t",
                            [self escapeNull:templateYoutube.embedFlag],@"e",
                            [self escapeNull:templateYoutube.embedUrl],@"u",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)setYoutubeCategory:(YoutubeCategory *)youtubeCategory
{
    if([VeamUtil isEmpty:youtubeCategory.youtubeCategoryId]){
        [youtubeCategories insertObject:youtubeCategory atIndex:0] ;
    } else {
        int count = [youtubeCategories count] ;
        for(int index = 0 ; index  < count ; index++){
            YoutubeCategory *workYoutubeCategory = [youtubeCategories objectAtIndex:index] ;
            if([workYoutubeCategory.youtubeCategoryId isEqual:youtubeCategory.youtubeCategoryId]){
                [youtubeCategories removeObjectAtIndex:index] ;
                [youtubeCategories insertObject:youtubeCategory atIndex:index] ;
                break ;
            }
        }
    }
    [self saveYoutubeCategory:youtubeCategory] ;
}

- (void)saveYoutubeCategory:(YoutubeCategory *)youtubeCategory
{
    NSString *apiName = @"youtube/setcategory" ;
    NSString *youtubeCategoryId = @"" ;
    if(![VeamUtil isEmpty:youtubeCategory.youtubeCategoryId]){
        youtubeCategoryId = youtubeCategory.youtubeCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:youtubeCategoryId],@"i",
                            [self escapeNull:youtubeCategory.name],@"n",
                            [self escapeNull:youtubeCategory.embed],@"e",
                            [self escapeNull:youtubeCategory.embedUrl],@"u",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:youtubeCategory] ;
}

- (void)removeYoutubeCategoryAt:(NSInteger)index
{
    NSString *youtubeCategoryIdToBeRemoved = nil ;
    int count = [youtubeCategories count] ;
    if(index < count){
        YoutubeCategory *youtubeCategory = [youtubeCategories objectAtIndex:index] ;
        youtubeCategoryIdToBeRemoved = youtubeCategory.youtubeCategoryId ;
        [youtubeCategories removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:youtubeCategoryIdToBeRemoved]){
        NSString *apiName = @"youtube/removecategory" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:youtubeCategoryIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (void)disableYoutubeCategoryAt:(NSInteger)index disabled:(BOOL)disabled
{
    int count = [youtubeCategories count] ;
    if(index < count){
        NSString *disableString = disabled?@"1":@"0" ;
        YoutubeCategory *youtubeCategory = [youtubeCategories objectAtIndex:index] ;
        [youtubeCategory setDisabled:disableString] ;
        
        NSString *apiName = @"youtube/disablecategory" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:youtubeCategory.youtubeCategoryId],@"i",
                                [self escapeNull:disableString],@"d",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (NSInteger)getNumberOfYoutubeCategories
{
    return [youtubeCategories count] ;
}

- (NSMutableArray *)getYoutubeCategories
{
    return youtubeCategories ;
}

- (YoutubeCategory *)getYoutubeCategoryAt:(NSInteger)index
{
    YoutubeCategory *retValue = nil ;
    if(index < [youtubeCategories count]){
        retValue = [youtubeCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveYoutubeCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    YoutubeCategory *objectToBeMoved = [youtubeCategories objectAtIndex:fromIndex] ;
    [youtubeCategories removeObjectAtIndex:fromIndex] ;
    [youtubeCategories insertObject:objectToBeMoved atIndex:toIndex] ;
    [self saveYoutubeCategoryOrder] ;
}

- (void)saveYoutubeCategoryOrder
{
    int count = [youtubeCategories count] ;
    if(count > 1){
        NSString *apiName = @"youtube/setcategoryorder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            YoutubeCategory *category = [youtubeCategories objectAtIndex:index] ;
            if(index == 0){
                orderString = category.youtubeCategoryId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",category.youtubeCategoryId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}


- (YoutubeCategory *)getYoutubeCategoryForId:(NSString *)youtubeCategoryId
{
    NSInteger count = [youtubeCategories count] ;
    YoutubeCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        YoutubeCategory *youtubeCategory = [youtubeCategories objectAtIndex:index] ;
        if([[youtubeCategory youtubeCategoryId] isEqualToString:youtubeCategoryId]){
            retValue = youtubeCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSMutableArray *)getYoutubeSubCategories:(NSString *)youtubeCategoryId
{
    NSMutableArray *retValue = [youtubeSubCategoriesPerCategory objectForKey:youtubeCategoryId] ;
    return retValue ;
}

- (NSInteger)getNumberOfYoutubeSubCategories:(NSString *)youtubeCategoryId
{
    return [[self getYoutubeSubCategories:youtubeCategoryId] count] ;
}

- (YoutubeSubCategory *)getYoutubeSubCategoryAt:(NSInteger)index youtubeCategoryId:(NSString *)youtubeCategoryId
{
    YoutubeSubCategory *retValue = nil ;
    if(index < [[self getYoutubeSubCategories:youtubeCategoryId] count]){
        retValue = [[self getYoutubeSubCategories:youtubeCategoryId] objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveYoutubeSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex youtubeCategoryId:(NSString *)youtubeCategoryId
{
    NSMutableArray *subCategories = [self getYoutubeSubCategories:youtubeCategoryId] ;
    if(subCategories != nil){
        YoutubeSubCategory *objectToBeMoved = [subCategories objectAtIndex:fromIndex] ;
        [subCategories removeObjectAtIndex:fromIndex] ;
        [subCategories insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveYoutubeSubCategoryOrder:youtubeCategoryId] ;
    }
}

- (void)saveYoutubeSubCategoryOrder:(NSString *)youtubeCategoryId
{
    
    NSMutableArray *subCategories = [self getYoutubeSubCategories:youtubeCategoryId] ;
    if(subCategories != nil){
        int count = [subCategories count] ;
        if(count > 1){
            NSString *apiName = @"youtube/setsubcategoryorder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                YoutubeSubCategory *subCategory = [subCategories objectAtIndex:index] ;
                if(index == 0){
                    orderString = subCategory.youtubeSubCategoryId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",subCategory.youtubeSubCategoryId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setYoutubeSubCategory:(YoutubeSubCategory *)youtubeSubCategory
{
    NSMutableArray *subCategories = [self getYoutubeSubCategories:youtubeSubCategory.youtubeCategoryId] ;
    if(subCategories == nil){
        subCategories = [NSMutableArray array] ;
        [youtubeSubCategoriesPerCategory setObject:subCategories forKey:youtubeSubCategory.youtubeCategoryId] ;
    }
    
    if(subCategories != nil){
        if([VeamUtil isEmpty:youtubeSubCategory.youtubeSubCategoryId]){
            [subCategories insertObject:youtubeSubCategory atIndex:0] ;
        } else {
            int count = [subCategories count] ;
            for(int index = 0 ; index  < count ; index++){
                YoutubeSubCategory *workYoutubeSubCategory = [subCategories objectAtIndex:index] ;
                if([workYoutubeSubCategory.youtubeSubCategoryId isEqual:youtubeSubCategory.youtubeSubCategoryId]){
                    [subCategories removeObjectAtIndex:index] ;
                    [subCategories insertObject:youtubeSubCategory atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveYoutubeSubCategory:youtubeSubCategory] ;
    }
}

- (void)saveYoutubeSubCategory:(YoutubeSubCategory *)youtubeSubCategory
{
    NSString *apiName = @"youtube/setsubcategory" ;
    NSString *youtubeSubCategoryId = @"" ;
    if(![VeamUtil isEmpty:youtubeSubCategory.youtubeSubCategoryId]){
        youtubeSubCategoryId = youtubeSubCategory.youtubeSubCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:youtubeSubCategoryId],@"i",
                            [self escapeNull:youtubeSubCategory.youtubeCategoryId],@"c",
                            [self escapeNull:youtubeSubCategory.name],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:youtubeSubCategory] ;
    self.appInfo.modified = @"1" ;
}

- (void)removeYoutubeSubCategoryAt:(NSInteger)index youtubeCategoryId:(NSString *)youtubeCategoryId
{
    NSMutableArray *subCategories = [self getYoutubeSubCategories:youtubeCategoryId] ;
    if(subCategories != nil){
        NSString *youtubeSubCategoryIdToBeRemoved = nil ;
        int count = [subCategories count] ;
        if(index < count){
            YoutubeSubCategory *youtubeSubCategory = [subCategories objectAtIndex:index] ;
            youtubeSubCategoryIdToBeRemoved = youtubeSubCategory.youtubeSubCategoryId ;
            [subCategories removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:youtubeSubCategoryIdToBeRemoved]){
            NSString *apiName = @"youtube/removesubcategory" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:youtubeSubCategoryIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (NSInteger)getNumberOfYoutubesForCategory:(NSString *)youtubeCategoryId
{
    return [[self getYoutubesForCategory:youtubeCategoryId] count] ;
}

- (NSInteger)getNumberOfYoutubesForSubCategory:(NSString *)youtubeSubCategoryId
{
    return [[self getYoutubesForSubCategory:youtubeSubCategoryId] count] ;
}

- (NSMutableArray *)getYoutubesForCategory:(NSString *)youtubeCategoryId
{
    NSMutableArray *retValue = [youtubesPerCategory objectForKey:youtubeCategoryId] ;
    return retValue ;
}

- (NSMutableArray *)getYoutubesForSubCategory:(NSString *)youtubeSubCategoryId
{
    NSMutableArray *retValue = [youtubesPerSubCategory objectForKey:youtubeSubCategoryId] ;
    return retValue ;
}

- (Youtube *)getYoutubeForId:(NSString *)youtubeId
{
    Youtube *retValue = nil ;
    retValue = [youtubesForYoutubeId objectForKey:youtubeId] ;
    return retValue ;
}

- (Youtube *)getYoutubeForCategory:(NSString *)youtubeCategoryId at:(NSInteger)index
{
    Youtube *retValue = nil ;
    NSArray *youtubes = [self getYoutubesForCategory:youtubeCategoryId] ;
    retValue = [youtubes objectAtIndex:index] ;
    return retValue ;
}

- (Youtube *)getYoutubeForSubCategory:(NSString *)youtubeSubCategoryId at:(NSInteger)index
{
    Youtube *retValue = nil ;
    NSArray *youtubes = [self getYoutubesForSubCategory:youtubeSubCategoryId] ;
    retValue = [youtubes objectAtIndex:index] ;
    return retValue ;
}

- (void)moveYoutubeForCategory:(NSString *)youtubeCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *youtubes = [self getYoutubesForCategory:youtubeCategoryId] ;
    if(youtubes != nil){
        Youtube *objectToBeMoved = [youtubes objectAtIndex:fromIndex] ;
        [youtubes removeObjectAtIndex:fromIndex] ;
        [youtubes insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveYoutubeOrder:youtubes] ;
    }
}

- (void)moveYoutubeForSubCategory:(NSString *)youtubeSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *youtubes = [self getYoutubesForSubCategory:youtubeSubCategoryId] ;
    if(youtubes != nil){
        Youtube *objectToBeMoved = [youtubes objectAtIndex:fromIndex] ;
        [youtubes removeObjectAtIndex:fromIndex] ;
        [youtubes insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveYoutubeOrder:youtubes] ;
    }
}

- (void)saveYoutubeOrder:(NSMutableArray *)youtubes
{
    if(youtubes != nil){
        int count = [youtubes count] ;
        if(count > 1){
            NSString *apiName = @"youtube/setyoutubeorder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                Youtube *youtube = [youtubes objectAtIndex:index] ;
                if(index == 0){
                    orderString = youtube.youtubeId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",youtube.youtubeId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setYoutube:(Youtube *)youtube
{
    NSMutableArray *youtubes = nil ;
    if([youtube.youtubeSubCategoryId isEqual:@"0"]){
        youtubes = [self getYoutubesForCategory:youtube.youtubeCategoryId] ;
    } else {
        youtubes = [self getYoutubesForSubCategory:youtube.youtubeSubCategoryId] ;
    }
    
    if(youtubes == nil){
        youtubes = [NSMutableArray array] ;
        if([youtube.youtubeSubCategoryId isEqual:@"0"]){
            [youtubesPerCategory setObject:youtubes forKey:youtube.youtubeCategoryId] ;
        } else {
            [youtubesPerSubCategory setObject:youtubes forKey:youtube.youtubeSubCategoryId] ;
        }
    }
    
    if(youtubes != nil){
        if([VeamUtil isEmpty:youtube.youtubeId]){
            [youtubes insertObject:youtube atIndex:0] ;
        } else {
            int count = [youtubes count] ;
            for(int index = 0 ; index  < count ; index++){
                Youtube *workYoutube = [youtubes objectAtIndex:index] ;
                if([workYoutube.youtubeId isEqual:youtube.youtubeId]){
                    [youtubes removeObjectAtIndex:index] ;
                    [youtubes insertObject:youtube atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveYoutube:youtube] ;
    }
}

- (void)saveYoutube:(Youtube *)youtube
{
    NSString *apiName = @"youtube/setyoutube" ;
    NSString *youtubeId = @"" ;
    if(![VeamUtil isEmpty:youtube.youtubeId]){
        youtubeId = youtube.youtubeId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:youtubeId],@"i",
                            [self escapeNull:youtube.youtubeCategoryId],@"c",
                            [self escapeNull:youtube.youtubeSubCategoryId],@"sub",
                            [self escapeNull:youtube.kind],@"k",
                            [self escapeNull:youtube.title],@"t",
                            [self escapeNull:youtube.youtubeVideoId],@"v",
                            [self escapeNull:youtube.duration],@"dur",
                            [self escapeNull:youtube.description],@"des",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:youtube] ;
    self.appInfo.modified = @"1" ;
}


- (void)removeYoutubeForCategory:(NSString *)youtubeCategoryId at:(NSInteger)index
{
    NSMutableArray *youtubes = [self getYoutubesForCategory:youtubeCategoryId] ;
    [self removeYoutubeFrom:youtubes at:index] ;
}

- (void)removeYoutubeForSubCategory:(NSString *)youtubeSubCategoryId at:(NSInteger)index
{
    NSMutableArray *youtubes = [self getYoutubesForSubCategory:youtubeSubCategoryId] ;
    [self removeYoutubeFrom:youtubes at:index] ;
}

- (void)removeYoutubeFrom:(NSMutableArray *)youtubes at:(NSInteger)index
{
    if(youtubes != nil){
        NSString *youtubeIdToBeRemoved = nil ;
        int count = [youtubes count] ;
        if(index < count){
            Youtube *youtube = [youtubes objectAtIndex:index] ;
            youtubeIdToBeRemoved = youtube.youtubeId ;
            [youtubes removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:youtubeIdToBeRemoved]){
            NSString *apiName = @"youtube/removeyoutube" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:youtubeIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}







/////////////////////////////////////////////////////////////////////////////////
#pragma mark AlternativeImage
/////////////////////////////////////////////////////////////////////////////////
- (AlternativeImage *)getAlternativeImageForFileName:(NSString *)fileName
{
    return [alternativeImagesForFileName objectForKey:fileName] ;
}






/////////////////////////////////////////////////////////////////////////////////
#pragma mark Mixed
/////////////////////////////////////////////////////////////////////////////////
- (void)setTemplateMixedTitle:(NSString *)title
{
    [templateMixed setTitle:title] ;
    [self saveTemplateMixed] ;
}

- (void)saveTemplateMixed
{
    NSString *apiName = @"mixed/setdata" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:templateMixed.title],@"t",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)setMixedCategory:(MixedCategory *)mixedCategory
{
    if([VeamUtil isEmpty:mixedCategory.mixedCategoryId]){
        [mixedCategories insertObject:mixedCategory atIndex:0] ;
    } else {
        int count = [mixedCategories count] ;
        for(int index = 0 ; index  < count ; index++){
            MixedCategory *workMixedCategory = [mixedCategories objectAtIndex:index] ;
            if([workMixedCategory.mixedCategoryId isEqual:mixedCategory.mixedCategoryId]){
                [mixedCategories removeObjectAtIndex:index] ;
                [mixedCategories insertObject:mixedCategory atIndex:index] ;
                break ;
            }
        }
    }
    [self saveMixedCategory:mixedCategory] ;
}

- (void)saveMixedCategory:(MixedCategory *)mixedCategory
{
    NSString *apiName = @"mixed/setcategory" ;
    NSString *mixedCategoryId = @"" ;
    if(![VeamUtil isEmpty:mixedCategory.mixedCategoryId]){
        mixedCategoryId = mixedCategory.mixedCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:mixedCategoryId],@"i",
                            [self escapeNull:mixedCategory.name],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:mixedCategory] ;
    self.appInfo.modified = @"1" ;
}

- (void)removeMixedCategoryAt:(NSInteger)index
{
    NSString *mixedCategoryIdToBeRemoved = nil ;
    int count = [mixedCategories count] ;
    if(index < count){
        MixedCategory *mixedCategory = [mixedCategories objectAtIndex:index] ;
        mixedCategoryIdToBeRemoved = mixedCategory.mixedCategoryId ;
        [mixedCategories removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:mixedCategoryIdToBeRemoved]){
        NSString *apiName = @"mixed/removecategory" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:mixedCategoryIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (NSInteger)getNumberOfMixedCategories
{
    return [mixedCategories count] ;
}

- (NSMutableArray *)getMixedCategories
{
    return mixedCategories ;
}

- (MixedCategory *)getMixedCategoryAt:(NSInteger)index
{
    MixedCategory *retValue = nil ;
    if(index < [mixedCategories count]){
        retValue = [mixedCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveMixedCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    MixedCategory *objectToBeMoved = [mixedCategories objectAtIndex:fromIndex] ;
    [mixedCategories removeObjectAtIndex:fromIndex] ;
    [mixedCategories insertObject:objectToBeMoved atIndex:toIndex] ;
    [self saveMixedCategoryOrder] ;
}

- (void)saveMixedCategoryOrder
{
    int count = [mixedCategories count] ;
    if(count > 1){
        NSString *apiName = @"mixed/setcategoryorder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            MixedCategory *category = [mixedCategories objectAtIndex:index] ;
            if(index == 0){
                orderString = category.mixedCategoryId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",category.mixedCategoryId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}


- (MixedCategory *)getMixedCategoryForId:(NSString *)mixedCategoryId
{
    NSInteger count = [mixedCategories count] ;
    MixedCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        MixedCategory *mixedCategory = [mixedCategories objectAtIndex:index] ;
        if([[mixedCategory mixedCategoryId] isEqualToString:mixedCategoryId]){
            retValue = mixedCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSMutableArray *)getMixedSubCategories:(NSString *)mixedCategoryId
{
    NSMutableArray *retValue = [mixedSubCategoriesPerCategory objectForKey:mixedCategoryId] ;
    return retValue ;
}

- (NSInteger)getNumberOfMixedSubCategories:(NSString *)mixedCategoryId
{
    return [[self getMixedSubCategories:mixedCategoryId] count] ;
}

- (MixedSubCategory *)getMixedSubCategoryAt:(NSInteger)index mixedCategoryId:(NSString *)mixedCategoryId
{
    MixedSubCategory *retValue = nil ;
    if(index < [[self getMixedSubCategories:mixedCategoryId] count]){
        retValue = [[self getMixedSubCategories:mixedCategoryId] objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveMixedSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex mixedCategoryId:(NSString *)mixedCategoryId
{
    NSMutableArray *subCategories = [self getMixedSubCategories:mixedCategoryId] ;
    if(subCategories != nil){
        MixedSubCategory *objectToBeMoved = [subCategories objectAtIndex:fromIndex] ;
        [subCategories removeObjectAtIndex:fromIndex] ;
        [subCategories insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveMixedSubCategoryOrder:mixedCategoryId] ;
    }
}

- (void)saveMixedSubCategoryOrder:(NSString *)mixedCategoryId
{
    
    NSMutableArray *subCategories = [self getMixedSubCategories:mixedCategoryId] ;
    if(subCategories != nil){
        int count = [subCategories count] ;
        if(count > 1){
            NSString *apiName = @"mixed/setsubcategoryorder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                MixedSubCategory *subCategory = [subCategories objectAtIndex:index] ;
                if(index == 0){
                    orderString = subCategory.mixedSubCategoryId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",subCategory.mixedSubCategoryId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setMixedSubCategory:(MixedSubCategory *)mixedSubCategory
{
    NSMutableArray *subCategories = [self getMixedSubCategories:mixedSubCategory.mixedCategoryId] ;
    if(subCategories == nil){
        subCategories = [NSMutableArray array] ;
        [mixedSubCategoriesPerCategory setObject:subCategories forKey:mixedSubCategory.mixedCategoryId] ;
    }
    
    if(subCategories != nil){
        if([VeamUtil isEmpty:mixedSubCategory.mixedSubCategoryId]){
            [subCategories insertObject:mixedSubCategory atIndex:0] ;
        } else {
            int count = [subCategories count] ;
            for(int index = 0 ; index  < count ; index++){
                MixedSubCategory *workMixedSubCategory = [subCategories objectAtIndex:index] ;
                if([workMixedSubCategory.mixedSubCategoryId isEqual:mixedSubCategory.mixedSubCategoryId]){
                    [subCategories removeObjectAtIndex:index] ;
                    [subCategories insertObject:mixedSubCategory atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveMixedSubCategory:mixedSubCategory] ;
    }
}

- (void)saveMixedSubCategory:(MixedSubCategory *)mixedSubCategory
{
    NSString *apiName = @"mixed/setsubcategory" ;
    NSString *mixedSubCategoryId = @"" ;
    if(![VeamUtil isEmpty:mixedSubCategory.mixedSubCategoryId]){
        mixedSubCategoryId = mixedSubCategory.mixedSubCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:mixedSubCategoryId],@"i",
                            [self escapeNull:mixedSubCategory.mixedCategoryId],@"c",
                            [self escapeNull:mixedSubCategory.name],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:mixedSubCategory] ;
    self.appInfo.modified = @"1" ;
}

- (void)removeMixedSubCategoryAt:(NSInteger)index mixedCategoryId:(NSString *)mixedCategoryId
{
    NSMutableArray *subCategories = [self getMixedSubCategories:mixedCategoryId] ;
    if(subCategories != nil){
        NSString *mixedSubCategoryIdToBeRemoved = nil ;
        int count = [subCategories count] ;
        if(index < count){
            MixedSubCategory *mixedSubCategory = [subCategories objectAtIndex:index] ;
            mixedSubCategoryIdToBeRemoved = mixedSubCategory.mixedSubCategoryId ;
            [subCategories removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:mixedSubCategoryIdToBeRemoved]){
            NSString *apiName = @"mixed/removesubcategory" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:mixedSubCategoryIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (NSInteger)getNumberOfMixedsForCategory:(NSString *)mixedCategoryId
{
    return [[self getMixedsForCategory:mixedCategoryId] count] ;
}

- (NSInteger)getNumberOfMixedsForSubCategory:(NSString *)mixedSubCategoryId
{
    return [[self getMixedsForSubCategory:mixedSubCategoryId] count] ;
}

- (NSMutableArray *)getMixedsForCategory:(NSString *)mixedCategoryId
{
    NSMutableArray *retValue = [mixedsPerCategory objectForKey:mixedCategoryId] ;
    return retValue ;
}

- (NSMutableArray *)getMixedsForSubCategory:(NSString *)mixedSubCategoryId
{
    NSMutableArray *retValue = [mixedsPerSubCategory objectForKey:mixedSubCategoryId] ;
    return retValue ;
}

- (Mixed *)getMixedForId:(NSString *)mixedId
{
    Mixed *retValue = nil ;
    retValue = [mixedsForMixedId objectForKey:mixedId] ;
    return retValue ;
}

- (Mixed *)getMixedForCategory:(NSString *)mixedCategoryId at:(NSInteger)index order:(NSComparisonResult)order
{
    Mixed *retValue = nil ;
    NSArray *mixeds = [self getMixedsForCategory:mixedCategoryId] ;
    NSInteger targetIndex = index ;
    if(order == NSOrderedDescending){
        targetIndex = [mixeds count] - index - 1 ;
    }
    retValue = [mixeds objectAtIndex:targetIndex] ;
    return retValue ;
}

- (Mixed *)getMixedForSubCategory:(NSString *)mixedSubCategoryId at:(NSInteger)index
{
    Mixed *retValue = nil ;
    NSArray *mixeds = [self getMixedsForSubCategory:mixedSubCategoryId] ;
    retValue = [mixeds objectAtIndex:index] ;
    return retValue ;
}

- (void)moveMixedForCategory:(NSString *)mixedCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *mixeds = [self getMixedsForCategory:mixedCategoryId] ;
    if(mixeds != nil){
        Mixed *objectToBeMoved = [mixeds objectAtIndex:fromIndex] ;
        [mixeds removeObjectAtIndex:fromIndex] ;
        [mixeds insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveMixedOrder:mixeds] ;
    }
}

- (void)moveMixedForSubCategory:(NSString *)mixedSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *mixeds = [self getMixedsForSubCategory:mixedSubCategoryId] ;
    if(mixeds != nil){
        Mixed *objectToBeMoved = [mixeds objectAtIndex:fromIndex] ;
        [mixeds removeObjectAtIndex:fromIndex] ;
        [mixeds insertObject:objectToBeMoved atIndex:toIndex] ;
        [self saveMixedOrder:mixeds] ;
    }
}

- (void)saveMixedOrder:(NSMutableArray *)mixeds
{
    if(mixeds != nil){
        int count = [mixeds count] ;
        if(count > 1){
            NSString *apiName = @"mixed/setmixedorder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                Mixed *mixed = [mixeds objectAtIndex:index] ;
                if(index == 0){
                    orderString = mixed.mixedId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",mixed.mixedId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setMixed:(Mixed *)mixed
{
    NSMutableArray *mixeds = nil ;
    if([mixed.mixedSubCategoryId isEqual:@"0"]){
        mixeds = [self getMixedsForCategory:mixed.mixedCategoryId] ;
    } else {
        mixeds = [self getMixedsForSubCategory:mixed.mixedSubCategoryId] ;
    }
    
    if(mixeds == nil){
        mixeds = [NSMutableArray array] ;
        if([mixed.mixedSubCategoryId isEqual:@"0"]){
            [mixedsPerCategory setObject:mixeds forKey:mixed.mixedCategoryId] ;
        } else {
            [mixedsPerSubCategory setObject:mixeds forKey:mixed.mixedSubCategoryId] ;
        }
    }
    
    if(mixeds != nil){
        if([VeamUtil isEmpty:mixed.mixedId]){
            [mixeds insertObject:mixed atIndex:0] ;
        } else {
            int count = [mixeds count] ;
            for(int index = 0 ; index  < count ; index++){
                Mixed *workMixed = [mixeds objectAtIndex:index] ;
                if([workMixed.mixedId isEqual:mixed.mixedId]){
                    [mixeds removeObjectAtIndex:index] ;
                    [mixeds insertObject:mixed atIndex:index] ;
                    break ;
                }
            }
        }
        //[self saveMixed:mixed] ;
    }
}

/*
- (void)saveMixed:(Mixed *)mixed
{
    NSString *apiName = @"mixed/setmixed" ;
    NSString *mixedId = @"" ;
    if(![VeamUtil isEmpty:mixed.mixedId]){
        mixedId = mixed.mixedId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:mixedId],@"i",
                            [self escapeNull:mixed.mixedCategoryId],@"c",
                            [self escapeNull:mixed.mixedSubCategoryId],@"sub",
                            [self escapeNull:mixed.kind],@"k",
                            [self escapeNull:mixed.title],@"t",
                            [self escapeNull:mixed.contentId],@"ci",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:mixed] ;
}
*/


- (void)updatePreparingMixedStatus:(NSString *)mixedCategoryId
{
    NSString *apiName = @"mixed/getmixedstatus" ;
    
    NSString *preparingMixedIds = @"" ;
    
    NSMutableArray *mixeds = [self getMixedsForCategory:mixedCategoryId] ;
    NSInteger count = [mixeds count] ;
    for(int index = 0 ; index < count ; index++){
        Mixed *mixed = [mixeds objectAtIndex:index] ;
        if([mixed.status isEqual:VEAM_MIXED_STATUS_PREPARING]){
            if(![VeamUtil isEmpty:preparingMixedIds]){
                preparingMixedIds = [preparingMixedIds stringByAppendingFormat:@",%@",mixed.mixedId] ;
            } else {
                preparingMixedIds = mixed.mixedId ;
            }
        }
    }
    
    if(![VeamUtil isEmpty:preparingMixedIds]){
        ConsoleUpdatePreparingMixedStatusHandler *handler = [[ConsoleUpdatePreparingMixedStatusHandler alloc] init] ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:preparingMixedIds],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:handler] ;
    }
}




- (void)updatePreparingSellVideoStatus:(NSString *)videoCategoryId
{
    NSString *apiName = @"sellitem/getsellvideostatus" ;
    
    NSString *preparingSellVideoIds = @"" ;
    
    NSMutableArray *sellVideos = [self getSellVideosForVideoCategory:videoCategoryId] ;
    NSInteger count = [sellVideos count] ;
    for(int index = 0 ; index < count ; index++){
        SellVideo *sellVideo = [sellVideos objectAtIndex:index] ;
        if([sellVideo.status isEqual:VEAM_SELL_VIDEO_STATUS_PREPARING] || [sellVideo.status isEqual:VEAM_SELL_VIDEO_STATUS_SUBMITTING]){
            if(![VeamUtil isEmpty:preparingSellVideoIds]){
                preparingSellVideoIds = [preparingSellVideoIds stringByAppendingFormat:@",%@",sellVideo.sellVideoId] ;
            } else {
                preparingSellVideoIds = sellVideo.sellVideoId ;
            }
        }
    }
    
    if(![VeamUtil isEmpty:preparingSellVideoIds]){
        ConsoleUpdatePreparingSellVideoStatusHandler *handler = [[ConsoleUpdatePreparingSellVideoStatusHandler alloc] init] ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:preparingSellVideoIds],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:handler] ;
    }
}


- (void)updatePreparingSellPdfStatus:(NSString *)pdfCategoryId
{
    NSString *apiName = @"sellitem/getsellpdfstatus" ;
    
    NSString *preparingSellPdfIds = @"" ;
    
    NSMutableArray *sellPdfs = [self getSellPdfsForPdfCategory:pdfCategoryId] ;
    NSInteger count = [sellPdfs count] ;
    for(int index = 0 ; index < count ; index++){
        SellPdf *sellPdf = [sellPdfs objectAtIndex:index] ;
        if([sellPdf.status isEqual:VEAM_SELL_PDF_STATUS_PREPARING] || [sellPdf.status isEqual:VEAM_SELL_PDF_STATUS_SUBMITTING]){
            if(![VeamUtil isEmpty:preparingSellPdfIds]){
                preparingSellPdfIds = [preparingSellPdfIds stringByAppendingFormat:@",%@",sellPdf.sellPdfId] ;
            } else {
                preparingSellPdfIds = sellPdf.sellPdfId ;
            }
        }
    }
    
    if(![VeamUtil isEmpty:preparingSellPdfIds]){
        ConsoleUpdatePreparingSellPdfStatusHandler *handler = [[ConsoleUpdatePreparingSellPdfStatusHandler alloc] init] ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:preparingSellPdfIds],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:handler] ;
    }
}

- (void)updatePreparingSellAudioStatus:(NSString *)audioCategoryId
{
    NSString *apiName = @"sellitem/getsellaudiostatus" ;
    
    NSString *preparingSellAudioIds = @"" ;
    
    NSMutableArray *sellAudios = [self getSellAudiosForAudioCategory:audioCategoryId] ;
    NSInteger count = [sellAudios count] ;
    for(int index = 0 ; index < count ; index++){
        SellAudio *sellAudio = [sellAudios objectAtIndex:index] ;
        if([sellAudio.status isEqual:VEAM_SELL_PDF_STATUS_PREPARING] || [sellAudio.status isEqual:VEAM_SELL_PDF_STATUS_SUBMITTING]){
            if(![VeamUtil isEmpty:preparingSellAudioIds]){
                preparingSellAudioIds = [preparingSellAudioIds stringByAppendingFormat:@",%@",sellAudio.sellAudioId] ;
            } else {
                preparingSellAudioIds = sellAudio.sellAudioId ;
            }
        }
    }
    
    if(![VeamUtil isEmpty:preparingSellAudioIds]){
        ConsoleUpdatePreparingSellAudioStatusHandler *handler = [[ConsoleUpdatePreparingSellAudioStatusHandler alloc] init] ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:preparingSellAudioIds],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:handler] ;
    }
}



- (void)removeMixedForCategory:(NSString *)mixedCategoryId at:(NSInteger)index
{
    NSMutableArray *mixeds = [self getMixedsForCategory:mixedCategoryId] ;
    [self removeMixedFrom:mixeds at:index] ;
}

- (void)removeMixedForSubCategory:(NSString *)mixedSubCategoryId at:(NSInteger)index
{
    NSMutableArray *mixeds = [self getMixedsForSubCategory:mixedSubCategoryId] ;
    [self removeMixedFrom:mixeds at:index] ;
}

- (void)removeMixedFrom:(NSMutableArray *)mixeds at:(NSInteger)index
{
    if(mixeds != nil){
        NSString *mixedIdToBeRemoved = nil ;
        int count = [mixeds count] ;
        if(index < count){
            Mixed *mixed = [mixeds objectAtIndex:index] ;
            mixedIdToBeRemoved = mixed.mixedId ;
            if([self isAppReleased]){
                [mixeds removeObjectAtIndex:index] ;
            } else {
                mixed.kind = @"0" ;
                mixed.contentId = @"0" ;
                if(index == 0){
                    mixed.title = @"Welcome" ;
                } else {
                    mixed.title = @"Bonus" ;
                }
                mixed.displayName = @"" ;
                mixed.thumbnailUrl = @"" ;
                mixed.status = @"1" ;
                mixed.statusText = [NSString stringWithFormat:@"%d",index+1] ;
            }
        }
        
        if(![VeamUtil isEmpty:mixedIdToBeRemoved]){
            NSString *apiName = @"mixed/removemixed" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:mixedIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setRecipe:(Recipe *)recipe recipeImage:(UIImage *)recipeImage
{
    [self setMixed:recipe.mixed] ;
    
    if([VeamUtil isEmpty:recipe.recipeId]){
        [recipes insertObject:recipe atIndex:0] ;
    } else {
        int count = [recipes count] ;
        for(int index = 0 ; index  < count ; index++){
            Recipe *workRecipe = [recipes objectAtIndex:index] ;
            if([workRecipe.recipeId isEqual:recipe.recipeId]){
                [recipes removeObjectAtIndex:index] ;
                [recipes insertObject:recipe atIndex:index] ;
                break ;
            }
        }
    }
    [self saveRecipe:recipe recipeImage:recipeImage] ;
}

- (void)saveRecipe:(Recipe *)recipe recipeImage:(UIImage *)recipeImage
{
    NSString *apiName = @"mixed/setrecipe" ;
    
    Mixed *mixed = recipe.mixed ;

    NSString *mixedId = @"" ;
    if(![VeamUtil isEmpty:mixed.mixedId]){
        mixedId = mixed.mixedId ;
    }
    
    NSString *recipeId = @"" ;
    if(![VeamUtil isEmpty:recipe.recipeId]){
        recipeId = recipe.recipeId ;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:mixedId],@"i",
                            [self escapeNull:mixed.mixedCategoryId],@"c",
                            [self escapeNull:mixed.mixedSubCategoryId],@"sub",
                            [self escapeNull:mixed.kind],@"k",
                            [self escapeNull:recipe.title],@"t",
                            [self escapeNull:recipe.recipeId],@"ri",
                            [self escapeNull:recipe.ingredients],@"ing",
                            [self escapeNull:recipe.directions],@"dir",
                            [self escapeNull:recipe.nutrition],@"nut",
                            nil] ;
    [self sendData:apiName params:params image:recipeImage handlePostResultDelegate:recipe] ;
    self.appInfo.modified = @"1" ;
}

- (Recipe *)getRecipeForId:(NSString *)recipeId
{
    //NSLog(@"getRecipeForId:%@",recipeId) ;
    Recipe *retValue = nil ;
    int count = [recipes count] ;
    for(int index = 0 ; index < count ;index++){
        Recipe *workRecipe = [recipes objectAtIndex:index] ;
        if([workRecipe.recipeId isEqualToString:recipeId]){
            retValue = workRecipe ;
            break ;
        }
    }
    
    return retValue ;
}












/////////////////////////////////////////////////////////////////////////////////
#pragma mark etc
/////////////////////////////////////////////////////////////////////////////////
- (id)initWithResourceFile
{
    //NSLog(@"ConsoleContents::initWithResourceFile") ;
    // load content
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    NSString *contentsStorePath = [VeamUtil getFilePathAtCachesDirectory:CONSOLE_CONTENTS_FILE_NAME] ;
    if (![fileManager fileExistsAtPath:contentsStorePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:CONSOLE_DEFAULT_CONTENTS_FILE_NAME ofType:nil] ;
        if(defaultStorePath){
            //NSLog(@"copy contents") ;
            [fileManager copyItemAtPath:defaultStorePath toPath:contentsStorePath error:NULL];
        }
    }
    //NSLog(@"console contents url : %@",contentsStorePath) ;
    NSURL *contentsFileUrl = [NSURL fileURLWithPath:contentsStorePath] ;
    return [self initWithUrl:contentsFileUrl] ;
}

- (id)initWithUrl:(NSURL *)url ;
{
    //NSLog(@"ConsoleContents::initWithUrl url=%@",url.absoluteString) ;
    self = [super init] ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url] ;
    [self startParsing:parser] ;
    
    return self ;
}

- (id)initWithServerData
{
    //NSLog(@"ConsoleContents::initWithServerData") ;
    NSString *urlString  = [NSString stringWithFormat:@"%@",[ConsoleUtil getApiUrl:@"content/list"]] ;
	//NSLog(@"urlString String url = %@",urlString) ;
    NSURL *url = [NSURL URLWithString:urlString] ;
    //NSLog(@"update url : %@",[url absoluteString]) ;
    
    NSString *userName = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
    NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url] ;
    [request setHTTPMethod: @"POST"] ;
    NSString *boundary = @"0x0hHai1CanHazB0undar135" ;
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] ;
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"Content-Disposition: form-data; name=\"un\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[userName dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"Content-Disposition: form-data; name=\"pw\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[password dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]] ;
    
    [request setHTTPBody:body] ;
    
    //NSLog(@"url=%@",url.absoluteString) ;
    //NSLog(@"body=%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]) ;
    NSURLResponse *response = nil ;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] ;

    // error
    NSString *error_str = [error localizedDescription] ;
    if (0 == [error_str length]) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        if(![string isEqualToString:@"NO_UPDATE"]){
            // get bank accout info
            return [self initWithData:data] ; // analyze sync
        }
    }
    
    return [self init] ;
}

- (id)init
{
    //NSLog(@"ConsoleContents::init") ;
    self = [super init] ;
    return self ;
}


- (id)initWithData:(NSData *)data
{
    //NSLog(@"ConsoleContents::initWithData") ;
    self = [super init] ;
    
    xmlData = data ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data] ;
    [self startParsing:parser] ;
    
    return self ;
}

- (void)startParsing:(NSXMLParser *)parser
{
    [self setup] ;
    
    isParsing = YES ;
    
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError) {
        NSLog(@"error: %@", parseError);
    }
}

- (void)setup
{
    dictionary = [NSMutableDictionary dictionary] ;

    // app
    appRatingQuestions = [[NSMutableArray alloc] init] ;
    bankAccountInfo = [[BankAccountInfo alloc] init] ;

    // forum
    templateForum = [[TemplateForum alloc] init] ;
    forums = [[NSMutableArray alloc] init] ;

    // subscription
    templateSubscription = [[TemplateSubscription alloc] init] ;

    // youtube
    templateYoutube = [[TemplateYoutube alloc] init] ;
    youtubeCategories = [[NSMutableArray alloc] init] ;
    youtubeSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    youtubesPerCategory = [NSMutableDictionary dictionary] ;
    youtubesPerSubCategory = [NSMutableDictionary dictionary] ;
    youtubesForYoutubeId = [NSMutableDictionary dictionary] ;
    
    // mixed
    templateMixed = [[TemplateMixed alloc] init] ;
    mixedCategories = [[NSMutableArray alloc] init] ;
    mixedSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    mixedsPerCategory = [NSMutableDictionary dictionary] ;
    mixedsPerSubCategory = [NSMutableDictionary dictionary] ;
    mixedsForMixedId = [NSMutableDictionary dictionary] ;
    recipes = [[NSMutableArray alloc] init] ;
    //recipesForId = [NSMutableDictionary dictionary] ;
    
    // video
    videoCategories = [[NSMutableArray alloc] init] ;
    videoSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    videosPerCategory = [NSMutableDictionary dictionary] ;
    videosPerSubCategory = [NSMutableDictionary dictionary] ;
    videosForVideoId = [NSMutableDictionary dictionary] ;
    sellVideos = [[NSMutableArray alloc] init] ;
    sellVideosForSellVideoId = [NSMutableDictionary dictionary] ;

    // sell item
    sellItemCategories = [[NSMutableArray alloc] init] ;
    
    // sell section
    sellSectionCategories = [[NSMutableArray alloc] init] ;
    sellSectionItems = [[NSMutableArray alloc] init] ;
    sellSectionItemsForSellSectionItemId = [NSMutableDictionary dictionary] ;

    
    // pdf
    pdfCategories = [[NSMutableArray alloc] init] ;
    pdfSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    pdfsPerCategory = [NSMutableDictionary dictionary] ;
    pdfsPerSubCategory = [NSMutableDictionary dictionary] ;
    pdfsForPdfId = [NSMutableDictionary dictionary] ;
    sellPdfs = [[NSMutableArray alloc] init] ;
    sellPdfsForSellPdfId = [NSMutableDictionary dictionary] ;
    
    // audio
    audioCategories = [[NSMutableArray alloc] init] ;
    audioSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    audiosPerCategory = [NSMutableDictionary dictionary] ;
    audiosPerSubCategory = [NSMutableDictionary dictionary] ;
    audiosForAudioId = [NSMutableDictionary dictionary] ;
    sellAudios = [[NSMutableArray alloc] init] ;
    sellAudiosForSellAudioId = [NSMutableDictionary dictionary] ;
    
    // web
    templateWeb = [[TemplateWeb alloc] init] ;
    webs = [[NSMutableArray alloc] init] ;
    
    // etc
    alternativeImages = [[NSMutableArray alloc] init] ;
    alternativeImagesForFileName = [NSMutableDictionary dictionary] ;

    /*
    customizeElementsForDesign = [NSMutableArray arrayWithObjects:
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"1" title:@"Update your app design cooler!" description:@"Davey Wavey use this option service" imageFileName:@"c_custom_design_1.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"2" title:@"Update your app design cooler!" description:@"Veam use this option service" imageFileName:@"c_custom_design_2.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"3" title:@"Update your app design cooler!" description:@"Simple Pickup use this option service" imageFileName:@"c_custom_design_3.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"4" title:@"Update your app design cooler!" description:@"Recording Revolution use this option service" imageFileName:@"c_custom_design_4.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"5" title:@"Update your app design cooler!" description:@"Jessica Smith use this option service" imageFileName:@"c_custom_design_5.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  nil] ;
    */
    customizeElementsForDesign = [NSMutableArray arrayWithObjects:
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"1" title:NSLocalizedString(@"customize_design_title_1", nil) description:NSLocalizedString(@"customize_design_description_1", nil) imageFileName:@"c_custom_design_1.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"2" title:NSLocalizedString(@"customize_design_title_2", nil) description:NSLocalizedString(@"customize_design_description_2", nil) imageFileName:@"c_custom_design_2.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"3" title:NSLocalizedString(@"customize_design_title_3", nil) description:NSLocalizedString(@"customize_design_description_3", nil) imageFileName:@"c_custom_design_3.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"4" title:NSLocalizedString(@"customize_design_title_4", nil) description:NSLocalizedString(@"customize_design_description_4", nil) imageFileName:@"c_custom_design_4.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN],
                                  nil] ;
    

    customizeElementsForFeature = [NSMutableArray arrayWithObjects:
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"10001" title:@"Recipe" description:@"Veam and Davey Wavey use this option service" imageFileName:@"c_custom_feature_1.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE],
                                   /*
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"10002" title:@"Some Feature" description:@"Davey Wavey use this option service" imageFileName:@"c_custom_feature_2.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"10003" title:@"Some Feature" description:@"Davey Wavey use this option service" imageFileName:@"c_custom_feature_3.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE],
                                    */
                                  nil] ;
    

    customizeElementsForSubscription = [NSMutableArray arrayWithObjects:
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"1" title:@"Update your template - Calendar" description:@"Veam use Calendar template" imageFileName:@"c_custom_subscription_1.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION],
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"2" title:@"Update your template - Q&A" description:@"Veam use this option service" imageFileName:@"c_custom_subscription_2.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION],
                                        /*
                                  [[ConsoleCustomizeElement alloc] initWithCustomizeElementId:@"3" title:@"Update your template - Someting" description:@"Someone use this option service" imageFileName:@"c_custom_subscription_3.png" kind:VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION],
                                         */
                                  nil] ;
    

    

}

- (NSMutableArray *)getCustomizeElementsForKind:(NSInteger)kind ;
{
    NSMutableArray *retValue = nil ;
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


- (void)sendData:(NSString *)apiName params:(NSDictionary *)params image:(UIImage *)image handlePostResultDelegate:(id<HandlePostResultDelegate>)handlePostResultDelegate
{
    ConsolePostData *postData = [[ConsolePostData alloc] init] ;
    [postData setApiName:apiName] ;
    [postData setParams:params] ;
    [postData setImage:image] ;
    [postData setHandlePostResultDelegate:handlePostResultDelegate] ;
    [self performSelectorInBackground:@selector(doPost:) withObject:postData] ;
    [ConsoleUtil postContentsUpdateNotification] ;
}




- (void)doPost:(ConsolePostData *)postData
{
    //NSLog(@"ConsoleContents::doPost") ;
    @autoreleasepool
    {
        //isChanged = YES ;
        [[AppDelegate sharedInstance] setIsContentsChanged:YES] ;
        NSArray *results = [ConsoleUtil doPost:postData] ;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"CONTENT_POST_DONE",@"ACTION",postData.apiName,@"API_NAME",results,@"RESULTS",nil] ;
        [ConsoleUtil postContentsUpdateNotification:userInfo] ;
    }
}

/*
- (void)doPost:(ConsolePostData *)postData
{
    @autoreleasepool
    {
        NSLog(@"doPost") ;
        NSURL *url = [ConsoleUtil getApiUrl:[postData apiName]] ;
        //NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%d",pictureId,socialUserid]] ;
        NSArray *keys = [[postData params] allKeys] ;
        keys =[keys sortedArrayUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
            return [string1 localizedCaseInsensitiveCompare:string2] ;
        }] ;
        NSString *params = @"" ;
        int count = [keys count] ;
        NSString *planeText = @"CONSOLE" ;
        for(int index = 0 ; index < count ; index++){
            NSString *key = [keys objectAtIndex:index] ;
            NSString *value = [[postData params] objectForKey:key] ;
            NSString *urlEncodedValue = [VeamUtil urlEncode:value] ;
            if([VeamUtil isEmpty:params]){
                params = [NSString stringWithFormat:@"%@=%@",key,urlEncodedValue] ;
            } else {
                params = [params stringByAppendingFormat:@"&%@=%@",key,urlEncodedValue] ;
            }
            planeText = [planeText stringByAppendingFormat:@"_%@",value] ;
        }
        
        NSString *signature = [VeamUtil sha1:planeText] ;
        if([VeamUtil isEmpty:params]){
            params = [NSString stringWithFormat:@"s=%@",signature] ;
        } else {
            params = [params stringByAppendingFormat:@"&s=%@",signature] ;
        }
        
        NSLog(@"doPost url : %@",[url absoluteString]) ;
        NSLog(@"doPost params : %@",params) ;
        NSLog(@"doPost plane : %@",planeText) ;
        
        NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding] ;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url] ;
        [request setHTTPMethod: @"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"] ;
        [request setHTTPBody: myRequestData] ;

        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] ;
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSArray *results = [resultString componentsSeparatedByString:@"\n"];
            //NSLog(@"count=%d",[results count]) ;
            if([results count] >= 1){
                if([[results objectAtIndex:0] isEqualToString:@"OK"]){
                    NSLog(@"RESPONSE:OK") ;
                    if(postData.handlePostResultDelegate != nil){
                        NSLog(@"call handlePostResultDelegate") ;
                        [postData.handlePostResultDelegate handlePostResult:results] ;
                    }
                }
            } else {
                NSLog(@"NO RESPONSE") ;
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        NSLog(@"doPost end") ;
        //[ConsoleUtil postContentsUpdateNotification] ;
    }
}
 */


- (BOOL)isValid
{
    BOOL retValue = NO ;
    NSString *checkValue = [self getValueForKey:@"check"] ;
    if(![VeamUtil isEmpty:checkValue] && [checkValue isEqualToString:@"OK"]){
        retValue = YES ;
    }
    return retValue ;
}


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Contents::parserDidStartDocument") ;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    //NSLog(@"elementName=%@",elementName) ;
    
    if([elementName isEqualToString:@"content"]){
        NSString *contentId = [attributeDict objectForKey:@"id"] ;
        
    } else if([elementName isEqualToString:@"app_info"]){
        appInfo = [[AppInfo alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add app : %@",appInfo.status) ;
        
    } else if([elementName isEqualToString:@"bank_info"]){
        bankAccountInfo = [[BankAccountInfo alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add bank : %@",bankAccountInfo.accountName) ;
        
    } else if([elementName isEqualToString:@"app_rating_question"]){
        AppRatingQuestion *appRatingQuestion = [[AppRatingQuestion alloc] initWithAttributes:attributeDict] ;
        [appRatingQuestions addObject:appRatingQuestion] ;
        //NSLog(@"add AppRatingQuestion : %@ %@",[appRatingQuestion question],[appRatingQuestion answer]) ;
        
        //// subscription
    } else if([elementName isEqualToString:@"template_subscription"]){
        templateSubscription = [[TemplateSubscription alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_subscription : %@",[templateSubscription title]) ;
        
        //////// forum
    } else if([elementName isEqualToString:@"template_forum"]){
        templateForum = [[TemplateForum alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_forum : %@",[templateForum title]) ;
        
    } else if([elementName isEqualToString:@"forum"]){
        Forum *forum = [[Forum alloc] initWithAttributes:attributeDict] ;
        if(![forum.kind isEqualToString:VEAM_FORUM_KIND_HOT]){
            [forums addObject:forum] ;
            ////NSLog(@"add forum : %@ %@",[forum forumId],[forum forumName]) ;
        }
        //// youtube
    } else if([elementName isEqualToString:@"template_youtube"]){
        templateYoutube = [[TemplateYoutube alloc] initWithAttributes:attributeDict] ;
        ////NSLog(@"add template_youtube : %@",[templateYoutube title]) ;

    } else if([elementName isEqualToString:@"youtube_category"]){
        YoutubeCategory *youtubeCategory = [[YoutubeCategory alloc] initWithAttributes:attributeDict] ;
        [youtubeCategories addObject:youtubeCategory] ;
        
        //NSLog(@"add category : %@ %@ %@",youtubeCategory.name,youtubeCategory.embed,youtubeCategory.embedUrl) ;
        
    } else if([elementName isEqualToString:@"youtube_sub_category"]){
        YoutubeSubCategory *youtubeSubCategory = [[YoutubeSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *youtubeCategoryId = [youtubeSubCategory youtubeCategoryId] ;
        
        NSMutableArray *subCategories = [youtubeSubCategoriesPerCategory objectForKey:youtubeCategoryId] ;
        if(subCategories == nil){
            subCategories = [[NSMutableArray alloc] init] ;
            [youtubeSubCategoriesPerCategory setObject:subCategories forKey:youtubeCategoryId] ;
        }
        [subCategories addObject:youtubeSubCategory] ;
        //NSLog(@"add sub category : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
        
    } else if([elementName isEqualToString:@"youtube"]){
        Youtube *youtube = [[Youtube alloc] initWithAttributes:attributeDict] ;
        
        NSString *youtubeSubCategoryId = youtube.youtubeSubCategoryId ;
        
        NSMutableArray *youtubes = [youtubesPerSubCategory objectForKey:youtubeSubCategoryId] ;
        if(youtubes == nil){
            youtubes = [[NSMutableArray alloc] init] ;
            [youtubesPerSubCategory setObject:youtubes forKey:youtubeSubCategoryId] ;
        }
        [youtubes addObject:youtube] ;
        
        if([youtubeSubCategoryId isEqual:@"0"]){
            NSString *youtubeCategoryId = youtube.youtubeCategoryId ;
            NSMutableArray *youtubes = [youtubesPerCategory objectForKey:youtubeCategoryId] ;
            if(youtubes == nil){
                youtubes = [[NSMutableArray alloc] init] ;
                [youtubesPerCategory setObject:youtubes forKey:youtubeCategoryId] ;
            }
            [youtubes addObject:youtube] ;
        }
        
        [youtubesForYoutubeId setObject:youtube forKey:[youtube youtubeId]] ;
        //NSLog(@"add youtube video : %@ %@ %@",[youtube youtubeId],[youtube categoryId],[youtube subCategoryId]) ;
        
        
        //// mixed
    } else if([elementName isEqualToString:@"template_mixed"]){
        templateMixed = [[TemplateMixed alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_mixed : %@",[templateMixed title]) ;
        
    } else if([elementName isEqualToString:@"mixed_category"]){
        MixedCategory *mixedCategory = [[MixedCategory alloc] initWithAttributes:attributeDict] ;
        [mixedCategories addObject:mixedCategory] ;
        
        //NSLog(@"add category : %@",[mixedCategory name]) ;
        
    } else if([elementName isEqualToString:@"mixed_sub_category"]){
        MixedSubCategory *mixedSubCategory = [[MixedSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *mixedCategoryId = [mixedSubCategory mixedCategoryId] ;
        
        NSMutableArray *subCategories = [mixedSubCategoriesPerCategory objectForKey:mixedCategoryId] ;
        if(subCategories == nil){
            subCategories = [[NSMutableArray alloc] init] ;
            [mixedSubCategoriesPerCategory setObject:subCategories forKey:mixedCategoryId] ;
        }
        [subCategories addObject:mixedSubCategory] ;
        //NSLog(@"add sub category : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
        
    } else if([elementName isEqualToString:@"mixed"]){
        Mixed *mixed = [[Mixed alloc] initWithAttributes:attributeDict] ;
        
        [self addMixed:mixed] ;
        //NSLog(@"add mixed : %@ %@ %@",[mixed mixedId],[mixed title],mixed.status) ;
       
        
        //// sell item category
    } else if([elementName isEqualToString:@"sell_item_category"]){
        SellItemCategory *sellItemCategory = [[SellItemCategory alloc] initWithAttributes:attributeDict] ;
        [sellItemCategories addObject:sellItemCategory] ;
        //NSLog(@"add sell item category : %@ %@",[sellItemCategory kind],[sellItemCategory targetCategoryId]) ;
        
        //// sell section category
    } else if([elementName isEqualToString:@"sell_section_category"]){
        SellSectionCategory *sellSectionCategory = [[SellSectionCategory alloc] initWithAttributes:attributeDict] ;
        [sellSectionCategories addObject:sellSectionCategory] ;
        //NSLog(@"add sell Section category : %@ %@",[sellSectionCategory kind],[sellSectionCategory name]) ;
        
        //// video
    } else if([elementName isEqualToString:@"video_category"]){
        VideoCategory *videoCategory = [[VideoCategory alloc] initWithAttributes:attributeDict] ;
        [videoCategories addObject:videoCategory] ;
        //NSLog(@"add video category : %@ %@",videoCategory.videoCategoryId,videoCategory.name) ;
        
    } else if([elementName isEqualToString:@"video_sub_category"]){
        VideoSubCategory *videoSubCategory = [[VideoSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *videoCategoryId = [videoSubCategory videoCategoryId] ;
        
        NSMutableArray *videoSubCategories = [videoSubCategoriesPerCategory objectForKey:videoCategoryId] ;
        if(videoSubCategories == nil){
            videoSubCategories = [[NSMutableArray alloc] init] ;
            [videoSubCategoriesPerCategory setObject:videoSubCategories forKey:videoCategoryId] ;
        }
        [videoSubCategories addObject:videoSubCategory] ;
        //NSLog(@"add video sub category : %@ %@",[videoSubCategory subCategoryId],[videoSubCategory name]) ;
        
    } else if([elementName isEqualToString:@"video"]){
        Video *video = [[Video alloc] initWithAttributes:attributeDict] ;
        NSString *videoSubCategoryId = [video videoSubCategoryId] ;
        
        NSMutableArray *videos = [videosPerSubCategory objectForKey:videoSubCategoryId] ;
        if(videos == nil){
            videos = [[NSMutableArray alloc] init] ;
            [videosPerSubCategory setObject:videos forKey:videoSubCategoryId] ;
        }
        [videos addObject:video] ;
        [videosForVideoId setObject:video forKey:[video videoId]] ;
        
        if([videoSubCategoryId isEqual:@"0"]){
            NSString *videoCategoryId = video.videoCategoryId ;
            NSMutableArray *videos = [videosPerCategory objectForKey:videoCategoryId] ;
            if(videos == nil){
                videos = [[NSMutableArray alloc] init] ;
                [videosPerCategory setObject:videos forKey:videoCategoryId] ;
            }
            [videos addObject:video] ;
        }

        //NSLog(@"add video : %@ %@",video.title,video.videoCategoryId) ;
        
    } else if([elementName isEqualToString:@"sell_video"]){
        SellVideo *sellVideo = [[SellVideo alloc] init] ;
        [sellVideo setSellVideoId:[attributeDict objectForKey:@"id"]] ;
        [sellVideo setVideoId:[attributeDict objectForKey:@"v"]] ;
        [sellVideo setProductId:[attributeDict objectForKey:@"pro"]] ;
        [sellVideo setPrice:[attributeDict objectForKey:@"pri"]] ;
        [sellVideo setPriceText:[attributeDict objectForKey:@"ptx"]] ;
        NSString *description = [attributeDict objectForKey:@"des"] ;
        NSString *button = [attributeDict objectForKey:@"but"] ;
        NSString *status = [attributeDict objectForKey:@"st"] ;
        NSString *statusText = [attributeDict objectForKey:@"stt"] ;
        
        if([VeamUtil isEmpty:description]){
            description = @"" ;
        }
        [sellVideo setDescription:description] ;
        
        if([VeamUtil isEmpty:button]){
            button = @"" ;
        }
        [sellVideo setButtonText:button] ;
        
        if([VeamUtil isEmpty:status]){
            status = @"" ;
        }
        [sellVideo setStatus:status] ;
        
        if([VeamUtil isEmpty:statusText]){
            statusText = @"" ;
        }
        [sellVideo setStatusText:statusText] ;
        
        [sellVideos addObject:sellVideo] ;
        [sellVideosForSellVideoId setObject:sellVideo forKey:[sellVideo sellVideoId]] ;
        
        //NSLog(@"add sell video : %@ %@ %@ %@",[sellVideo videoId],[sellVideo description],sellVideo.status,sellVideo.status) ;
        
    } else if([elementName isEqualToString:@"sell_pdf"]){
        SellPdf *sellPdf = [[SellPdf alloc] init] ;
        [sellPdf setSellPdfId:[attributeDict objectForKey:@"id"]] ;
        [sellPdf setPdfId:[attributeDict objectForKey:@"v"]] ;
        [sellPdf setProductId:[attributeDict objectForKey:@"pro"]] ;
        [sellPdf setPrice:[attributeDict objectForKey:@"pri"]] ;
        [sellPdf setPriceText:[attributeDict objectForKey:@"ptx"]] ;
        NSString *description = [attributeDict objectForKey:@"des"] ;
        NSString *button = [attributeDict objectForKey:@"but"] ;
        NSString *status = [attributeDict objectForKey:@"st"] ;
        NSString *statusText = [attributeDict objectForKey:@"stt"] ;
        
        if([VeamUtil isEmpty:description]){
            description = @"" ;
        }
        [sellPdf setDescription:description] ;
        
        if([VeamUtil isEmpty:button]){
            button = @"" ;
        }
        [sellPdf setButtonText:button] ;
        
        if([VeamUtil isEmpty:status]){
            status = @"" ;
        }
        [sellPdf setStatus:status] ;
        
        if([VeamUtil isEmpty:statusText]){
            statusText = @"" ;
        }
        [sellPdf setStatusText:statusText] ;
        
        [sellPdfs addObject:sellPdf] ;
        [sellPdfsForSellPdfId setObject:sellPdf forKey:[sellPdf sellPdfId]] ;
        
        //NSLog(@"add sell Pdf : %@ %@ %@ %@",[sellPdf pdfId],[sellPdf description],sellPdf.status,sellPdf.status) ;
        
    } else if([elementName isEqualToString:@"sell_section_item"]){
        SellSectionItem *sellSectionItem = [[SellSectionItem alloc] init] ;
        [sellSectionItem setSellSectionItemId:[attributeDict objectForKey:@"id"]] ;
        [sellSectionItem setSellSectionCategoryId:[attributeDict objectForKey:@"c"]] ;
        [sellSectionItem setTitle:[attributeDict objectForKey:@"t"]] ;
        [sellSectionItem setKind:[attributeDict objectForKey:@"k"]] ;
        [sellSectionItem setContentId:[attributeDict objectForKey:@"v"]] ;
        NSString *status = [attributeDict objectForKey:@"st"] ;
        NSString *statusText = [attributeDict objectForKey:@"stt"] ;
        
        if([VeamUtil isEmpty:status]){
            status = @"" ;
        }
        [sellSectionItem setStatus:status] ;
        
        if([VeamUtil isEmpty:statusText]){
            statusText = @"" ;
        }
        [sellSectionItem setStatusText:statusText] ;
        
        [sellSectionItems addObject:sellSectionItem] ;
        [sellSectionItemsForSellSectionItemId setObject:sellSectionItem forKey:[sellSectionItem sellSectionItemId]] ;
        
        //NSLog(@"add sell SectionItem : %@ %@",[sellSectionItem sellSectionItemId],sellSectionItem.title) ;
        
    } else if([elementName isEqualToString:@"pdf_category"]){
        PdfCategory *pdfCategory = [[PdfCategory alloc] initWithAttributes:attributeDict] ;
        [pdfCategories addObject:pdfCategory] ;
        //NSLog(@"add pdf category : %@ %@",pdfCategory.pdfCategoryId,pdfCategory.name) ;
        
    } else if([elementName isEqualToString:@"pdf_sub_category"]){
        PdfSubCategory *pdfSubCategory = [[PdfSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *pdfCategoryId = [pdfSubCategory pdfCategoryId] ;
        
        NSMutableArray *pdfSubCategories = [pdfSubCategoriesPerCategory objectForKey:pdfCategoryId] ;
        if(pdfSubCategories == nil){
            pdfSubCategories = [[NSMutableArray alloc] init] ;
            [pdfSubCategoriesPerCategory setObject:pdfSubCategories forKey:pdfCategoryId] ;
        }
        [pdfSubCategories addObject:pdfSubCategory] ;
        //NSLog(@"add pdf sub category : %@ %@",[pdfSubCategory subCategoryId],[pdfSubCategory name]) ;
        
    } else if([elementName isEqualToString:@"pdf"]){
        Pdf *pdf = [[Pdf alloc] initWithAttributes:attributeDict] ;
        NSString *pdfSubCategoryId = [pdf pdfSubCategoryId] ;
        if([VeamUtil isEmpty:pdfSubCategoryId]){
            pdfSubCategoryId = @"0" ;
        }
        
        NSMutableArray *pdfs = [pdfsPerSubCategory objectForKey:pdfSubCategoryId] ;
        if(pdfs == nil){
            pdfs = [[NSMutableArray alloc] init] ;
            [pdfsPerSubCategory setObject:pdfs forKey:pdfSubCategoryId] ;
        }
        [pdfs addObject:pdf] ;
        [pdfsForPdfId setObject:pdf forKey:[pdf pdfId]] ;
        
        if([pdfSubCategoryId isEqual:@"0"]){
            NSString *pdfCategoryId = pdf.pdfCategoryId ;
            NSMutableArray *pdfs = [pdfsPerCategory objectForKey:pdfCategoryId] ;
            if(pdfs == nil){
                pdfs = [[NSMutableArray alloc] init] ;
                [pdfsPerCategory setObject:pdfs forKey:pdfCategoryId] ;
            }
            [pdfs addObject:pdf] ;
        }
        
        //NSLog(@"add pdf : %@ %@",pdf.title,pdf.imageUrl) ;

    } else if([elementName isEqualToString:@"sell_audio"]){
        SellAudio *sellAudio = [[SellAudio alloc] init] ;
        [sellAudio setSellAudioId:[attributeDict objectForKey:@"id"]] ;
        [sellAudio setAudioId:[attributeDict objectForKey:@"v"]] ;
        [sellAudio setProductId:[attributeDict objectForKey:@"pro"]] ;
        [sellAudio setPrice:[attributeDict objectForKey:@"pri"]] ;
        [sellAudio setPriceText:[attributeDict objectForKey:@"ptx"]] ;
        NSString *description = [attributeDict objectForKey:@"des"] ;
        NSString *button = [attributeDict objectForKey:@"but"] ;
        NSString *status = [attributeDict objectForKey:@"st"] ;
        NSString *statusText = [attributeDict objectForKey:@"stt"] ;
        
        if([VeamUtil isEmpty:description]){
            description = @"" ;
        }
        [sellAudio setDescription:description] ;
        
        if([VeamUtil isEmpty:button]){
            button = @"" ;
        }
        [sellAudio setButtonText:button] ;
        
        if([VeamUtil isEmpty:status]){
            status = @"" ;
        }
        [sellAudio setStatus:status] ;
        
        if([VeamUtil isEmpty:statusText]){
            statusText = @"" ;
        }
        [sellAudio setStatusText:statusText] ;
        
        [sellAudios addObject:sellAudio] ;
        [sellAudiosForSellAudioId setObject:sellAudio forKey:[sellAudio sellAudioId]] ;
        
        //NSLog(@"console add sell Audio : %@ %@ %@ %@",[sellAudio audioId],[sellAudio description],sellAudio.status,sellAudio.status) ;
        
    } else if([elementName isEqualToString:@"audio_category"]){
        AudioCategory *audioCategory = [[AudioCategory alloc] initWithAttributes:attributeDict] ;
        [audioCategories addObject:audioCategory] ;
        //NSLog(@"add Audio category : %@ %@",AudioCategory.AudioCategoryId,AudioCategory.name) ;
        
    } else if([elementName isEqualToString:@"audio_sub_category"]){
        AudioSubCategory *audioSubCategory = [[AudioSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *audioCategoryId = [audioSubCategory audioCategoryId] ;
        
        NSMutableArray *audioSubCategories = [audioSubCategoriesPerCategory objectForKey:audioCategoryId] ;
        if(audioSubCategories == nil){
            audioSubCategories = [[NSMutableArray alloc] init] ;
            [audioSubCategoriesPerCategory setObject:audioSubCategories forKey:audioCategoryId] ;
        }
        [audioSubCategories addObject:audioSubCategory] ;
        //NSLog(@"add audio sub category : %@ %@",[audioSubCategory subCategoryId],[audioSubCategory name]) ;
        
    } else if([elementName isEqualToString:@"audio"]){
        Audio *audio = [[Audio alloc] initWithAttributes:attributeDict] ;
        NSString *audioSubCategoryId = [audio audioSubCategoryId] ;
        
        NSMutableArray *audios = [audiosPerSubCategory objectForKey:audioSubCategoryId] ;
        if(audios == nil){
            audios = [[NSMutableArray alloc] init] ;
            [audiosPerSubCategory setObject:audios forKey:audioSubCategoryId] ;
        }
        [audios addObject:audio] ;
        [audiosForAudioId setObject:audio forKey:[audio audioId]] ;
        
        if([audioSubCategoryId isEqual:@"0"]){
            NSString *audioCategoryId = audio.audioCategoryId ;
            NSMutableArray *audios = [audiosPerCategory objectForKey:audioCategoryId] ;
            if(audios == nil){
                audios = [[NSMutableArray alloc] init] ;
                [audiosPerCategory setObject:audios forKey:audioCategoryId] ;
            }
            [audios addObject:audio] ;
        }
        
        //NSLog(@"add audio : %@ %@",audio.title,audio.imageUrl) ;
        
        /*
    } else if([elementName isEqualToString:@"recipe_category"]){
        RecipeCategory *recipeCategory = [[RecipeCategory alloc] initWithAttributes:attributeDict] ;
        [recipeCategories addObject:recipeCategory] ;
        //NSLog(@"add recipe category : %@ %@",[recipeCategory recipeCategoryId],[recipeCategory name]) ;
        */
    } else if([elementName isEqualToString:@"recipe"]){
        Recipe *recipe = [[Recipe alloc] initWithAttributes:attributeDict] ;
        Mixed *mixed = recipe.mixed ;
        [self addMixed:mixed] ;
        
        [recipes addObject:recipe] ;
        //[recipesForId setObject:recipe forKey:[recipe recipeId]] ;
        //NSLog(@"add recipe : %@ %@ %@",[recipe recipeId],[recipe title],recipe.mixed.mixedId) ;
        
        //// youtube
    } else if([elementName isEqualToString:@"template_web"]){
        templateWeb = [[TemplateWeb alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_web : %@",[templateWeb title]) ;
        
    } else if([elementName isEqualToString:@"web"]){
        Web *web = [[Web alloc] initWithAttributes:attributeDict] ;
        [webs addObject:web] ;
        //NSLog(@"add web : %@ %@",[web webId],[web title]) ;
        
    } else if([elementName isEqualToString:@"alternative_image"]){
        AlternativeImage *alternativeImage = [[AlternativeImage alloc] initWithAttributes:attributeDict] ;
        [alternativeImages addObject:alternativeImage] ;
        [alternativeImagesForFileName setObject:alternativeImage forKey:[alternativeImage fileName]] ;
        //NSLog(@"add alternative image : %@ %@ %@",[alternativeImage alternativeImageId],[alternativeImage fileName],[alternativeImage url]) ;
        
    } else {
        //NSLog(@"elementName=%@",elementName) ;
        NSString *value = [attributeDict objectForKey:@"value"];
        if(value != nil){
            //NSLog(@"elementName=%@ value=%@",elementName,value) ;
            [dictionary setObject:value forKey:elementName] ;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Contents::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"ConsoleContents::parserDidEndDocument") ;
    [parser setDelegate:nil] ;
    
    if([self isValid]){
        //BOOL shouldStoreContentId = YES ;
        if(xmlData != nil){
            NSFileManager *fileManager = [NSFileManager defaultManager] ;
            NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:CONSOLE_WORK_CONTENTS_FILE_NAME] ;
            [fileManager createFileAtPath:workFilePath contents:[NSData data] attributes:nil] ;
            NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:workFilePath] ;
            [file writeData:xmlData] ;
            [file closeFile] ;
            BOOL moved = [VeamUtil moveFile:workFilePath toPath:[VeamUtil getFilePathAtCachesDirectory:CONSOLE_CONTENTS_FILE_NAME]] ;
            //NSLog(@"saved") ;
            /*
            if(!moved){
                shouldStoreContentId = NO ;
            }
            */
        }
        
        /*
        if(shouldStoreContentId){
            [self storeContentId] ;
        }
        */
    }
    
    isParsing = NO ;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // エレメントの文字データを string で取得
}

- (NSString *)getValueForKey:(NSString *)key
{
    //NSLog(@"key=%@",key) ;
    NSString *value = [dictionary objectForKey:key] ;
    return value ;
}

- (void)setValueForKey:(NSString *)key value:(NSString *)value
{
    //NSLog(@"setValueForKey %@ %@",key,value) ;
    [dictionary setObject:value forKey:key] ;
}

- (NSInteger)getNumberOfForums
{
    return [forums count] ;
}

- (Forum *)getForumAt:(NSInteger)index
{
    Forum *retValue = nil ;
    if(index < [forums count]){
        retValue = [forums objectAtIndex:index] ;
    }
    return retValue ;
}

- (Forum *)getForumForId:(NSString *)forumId
{
    NSInteger count = [forums count] ;
    Forum *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        Forum *forum = [forums objectAtIndex:index] ;
        if([[forum forumId] isEqualToString:forumId]){
            retValue = forum ;
            break ;
        }
    }
    return retValue ;
}

- (void)setForum:(Forum *)forum
{
    if([VeamUtil isEmpty:forum.forumId]){
        [forums insertObject:forum atIndex:0] ;
    } else {
        int count = [forums count] ;
        for(int index = 0 ; index  < count ; index++){
            Forum *workForum = [forums objectAtIndex:index] ;
            if([workForum.forumId isEqual:forum.forumId]){
                [forums removeObjectAtIndex:index] ;
                [forums insertObject:forum atIndex:index] ;
                break ;
            }
        }
    }
    [self saveForum:forum] ;
}

- (void)saveForum:(Forum *)forum
{
    NSString *apiName = @"forum/setforum" ;
    NSString *forumId = @"" ;
    if(![VeamUtil isEmpty:forum.forumId]){
        forumId = forum.forumId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:forumId],@"i",
                            [self escapeNull:forum.forumName],@"n",
                            [self escapeNull:forum.kind],@"k",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:forum] ;
    self.appInfo.modified = @"1" ;
}

- (void)setTemplateForumTitle:(NSString *)title
{
    [templateForum setTitle:title] ;
    [self saveTemplateForum] ;
}

- (void)saveTemplateForum
{
    NSString *apiName = @"forum/setdata" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:templateForum.title],@"t",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)moveForumFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    Forum *objectToBeMoved = [forums objectAtIndex:fromIndex] ;
    [forums removeObjectAtIndex:fromIndex] ;
    [forums insertObject:objectToBeMoved atIndex:toIndex] ;
    [self saveForumOrder] ;
}

- (void)saveForumOrder
{
    int count = [forums count] ;
    if(count > 1){
        NSString *apiName = @"forum/setforumorder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            Forum *forum = [forums objectAtIndex:index] ;
            if(index == 0){
                orderString = forum.forumId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",forum.forumId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (void)removeForumAt:(NSInteger)index
{
    NSString *forumIdToBeRemoved = nil ;
    int count = [forums count] ;
    if(index < count){
        Forum *forum = [forums objectAtIndex:index] ;
        forumIdToBeRemoved = forum.forumId ;
        [forums removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:forumIdToBeRemoved]){
        NSString *apiName = @"forum/removeforum" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:forumIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}















- (NSInteger)getNumberOfWebs
{
    return [webs count] ;
}

- (NSArray *)getWebs
{
    return webs ;
}
- (Web *)getWebAt:(NSInteger)index
{
    Web *retValue = nil ;
    if(index < [webs count]){
        retValue = [webs objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)setWeb:(Web *)web
{
    if([VeamUtil isEmpty:web.webId]){
        [webs insertObject:web atIndex:0] ;
    } else {
        int count = [webs count] ;
        for(int index = 0 ; index  < count ; index++){
            Web *workWeb = [webs objectAtIndex:index] ;
            if([workWeb.webId isEqual:web.webId]){
                [webs removeObjectAtIndex:index] ;
                [webs insertObject:web atIndex:index] ;
                break ;
            }
        }
    }
    [self saveWeb:web] ;
}

- (void)saveWeb:(Web *)web
{
    NSString *apiName = @"web/setweb" ;
    NSString *webId = @"" ;
    if(![VeamUtil isEmpty:web.webId]){
        webId = web.webId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:webId],@"i",
                            [self escapeNull:web.title],@"t",
                            [self escapeNull:web.url],@"u",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:web] ;
    self.appInfo.modified = @"1" ;
}

- (void)setTemplateWebTitle:(NSString *)title
{
    [templateWeb setTitle:title] ;
    [self saveTemplateWeb] ;
}

- (void)saveTemplateWeb
{
    NSString *apiName = @"web/setdata" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:templateWeb.title],@"t",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
}

- (void)moveWebFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    Web *objectToBeMoved = [webs objectAtIndex:fromIndex] ;
    [webs removeObjectAtIndex:fromIndex] ;
    [webs insertObject:objectToBeMoved atIndex:toIndex] ;
    [self saveWebOrder] ;
}

- (void)saveWebOrder
{
    int count = [webs count] ;
    if(count > 1){
        NSString *apiName = @"web/setweborder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            Web *web = [webs objectAtIndex:index] ;
            if(index == 0){
                orderString = web.webId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",web.webId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (void)removeWebAt:(NSInteger)index
{
    NSString *webIdToBeRemoved = nil ;
    int count = [webs count] ;
    if(index < count){
        Web *web = [webs objectAtIndex:index] ;
        webIdToBeRemoved = web.webId ;
        [webs removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:webIdToBeRemoved]){
        NSString *apiName = @"web/removeweb" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:webIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}




- (void)addMixed:(Mixed *)mixed
{
    NSString *mixedSubCategoryId = mixed.mixedSubCategoryId ;

    NSMutableArray *mixeds = [mixedsPerSubCategory objectForKey:mixedSubCategoryId] ;
    if(mixeds == nil){
        mixeds = [[NSMutableArray alloc] init] ;
        [mixedsPerSubCategory setObject:mixeds forKey:mixedSubCategoryId] ;
    }
    [mixeds addObject:mixed] ;

    if([mixedSubCategoryId isEqual:@"0"]){
        NSString *mixedCategoryId = mixed.mixedCategoryId ;
        NSMutableArray *mixeds = [mixedsPerCategory objectForKey:mixedCategoryId] ;
        if(mixeds == nil){
            mixeds = [[NSMutableArray alloc] init] ;
            [mixedsPerCategory setObject:mixeds forKey:mixedCategoryId] ;
        }
        [mixeds addObject:mixed] ;
    }

    [mixedsForMixedId setObject:mixed forKey:[mixed mixedId]] ;
    //NSLog(@"add mixed video : %@ %@ %@",[mixed mixedId],[mixed categoryId],[mixed subCategoryId]) ;
}






























/////////////////////////////////////////////////////////////////////////////////
#pragma mark SellItemCategory
/////////////////////////////////////////////////////////////////////////////////
- (void)setSellItemCategory:(SellItemCategory *)sellItemCategory title:(NSString *)title
{
    if([VeamUtil isEmpty:sellItemCategory.sellItemCategoryId]){
        [sellItemCategories insertObject:sellItemCategory atIndex:0] ;
    } else {
        int count = [sellItemCategories count] ;
        for(int index = 0 ; index  < count ; index++){
            SellItemCategory *workSellItemCategory = [sellItemCategories objectAtIndex:index] ;
            if([workSellItemCategory.sellItemCategoryId isEqual:sellItemCategory.sellItemCategoryId]){
                [sellItemCategories removeObjectAtIndex:index] ;
                [sellItemCategories insertObject:sellItemCategory atIndex:index] ;
                break ;
            }
        }
    }
    [self saveSellItemCategory:sellItemCategory title:title] ;
}

- (void)saveSellItemCategory:(SellItemCategory *)sellItemCategory title:(NSString *)title
{
    NSString *apiName = @"sellitem/setcategory" ;
    NSString *sellItemCategoryId = @"" ;
    if(![VeamUtil isEmpty:sellItemCategory.sellItemCategoryId]){
        sellItemCategoryId = sellItemCategory.sellItemCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellItemCategoryId],@"i",
                            [self escapeNull:sellItemCategory.kind],@"k",
                            [self escapeNull:sellItemCategory.targetCategoryId],@"t",
                            [self escapeNull:title],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:sellItemCategory] ;
    //NSLog(@"set post resuilt? sellItemCategory.targetCategoryId=%@",sellItemCategory.targetCategoryId) ;
    self.appInfo.modified = @"1" ;
}

- (void)removeSellItemCategoryAt:(NSInteger)index
{
    NSString *sellItemCategoryIdToBeRemoved = nil ;
    int count = [sellItemCategories count] ;
    if(index < count){
        SellItemCategory *sellItemCategory = [sellItemCategories objectAtIndex:index] ;
        sellItemCategoryIdToBeRemoved = sellItemCategory.sellItemCategoryId ;
        [sellItemCategories removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:sellItemCategoryIdToBeRemoved]){
        NSString *apiName = @"sellitem/removecategory" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:sellItemCategoryIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (NSInteger)getNumberOfSellItemCategories
{
    return [sellItemCategories count] ;
}

- (NSMutableArray *)getSellItemCategories
{
    return sellItemCategories ;
}

- (SellItemCategory *)getSellItemCategoryAt:(NSInteger)index
{
    SellItemCategory *retValue = nil ;
    if(index < [sellItemCategories count]){
        retValue = [sellItemCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveSellItemCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    SellItemCategory *objectToBeMoved = [sellItemCategories objectAtIndex:fromIndex] ;
    [sellItemCategories removeObjectAtIndex:fromIndex] ;
    [sellItemCategories insertObject:objectToBeMoved atIndex:toIndex] ;
    [self saveSellItemCategoryOrder] ;
}

- (void)saveSellItemCategoryOrder
{
    int count = [sellItemCategories count] ;
    if(count > 1){
        NSString *apiName = @"sellitem/setcategoryorder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            SellItemCategory *category = [sellItemCategories objectAtIndex:index] ;
            if(index == 0){
                orderString = category.sellItemCategoryId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",category.sellItemCategoryId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}


- (SellItemCategory *)getSellItemCategoryForId:(NSString *)sellItemCategoryId
{
    NSInteger count = [sellItemCategories count] ;
    SellItemCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        SellItemCategory *sellItemCategory = [sellItemCategories objectAtIndex:index] ;
        if([[sellItemCategory sellItemCategoryId] isEqualToString:sellItemCategoryId]){
            retValue = sellItemCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSString *)getCategoryTitleForSellItemCategory:(SellItemCategory *)sellItemCategory
{
    NSString *retValue = @"" ;
    if([sellItemCategory.kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_VIDEO]){
        VideoCategory *videoCategory = [self getVideoCategoryForId:sellItemCategory.targetCategoryId] ;
        if(videoCategory != nil){
            retValue = videoCategory.name ;
        }
    } else if([sellItemCategory.kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_PDF]){
        PdfCategory *pdfCategory = [self getPdfCategoryForId:sellItemCategory.targetCategoryId] ;
        if(pdfCategory != nil){
            retValue = pdfCategory.name ;
        }
    } else if([sellItemCategory.kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_AUDIO]){
        AudioCategory *audioCategory = [self getAudioCategoryForId:sellItemCategory.targetCategoryId] ;
        if(audioCategory != nil){
            retValue = audioCategory.name ;
        }
    }
    return retValue ;
}

- (void)setSellItemTarget:(NSString *)kind targetCategoryId:(NSString *)targetCategoryId name:(NSString *)name
{
    if([kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_VIDEO]){
        VideoCategory *videoCategory = [self getVideoCategoryForId:targetCategoryId] ;
        if(videoCategory != nil){
            [videoCategory setName:name] ;
        } else {
            videoCategory = [[VideoCategory alloc] init] ;
            [videoCategory setName:name] ;
            [videoCategory setVideoCategoryId:targetCategoryId] ;
            [videoCategories addObject:videoCategory] ;
        }
    } else if([kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_PDF]){
        PdfCategory *pdfCategory = [self getPdfCategoryForId:targetCategoryId] ;
        if(pdfCategory != nil){
            [pdfCategory setName:name] ;
        } else {
            pdfCategory = [[PdfCategory alloc] init] ;
            [pdfCategory setName:name] ;
            [pdfCategory setPdfCategoryId:targetCategoryId] ;
            [pdfCategories addObject:pdfCategory] ;
        }
    } else if([kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_AUDIO]){
        AudioCategory *audioCategory = [self getAudioCategoryForId:targetCategoryId] ;
        if(audioCategory != nil){
            [audioCategory setName:name] ;
        } else {
            audioCategory = [[AudioCategory alloc] init] ;
            [audioCategory setName:name] ;
            [audioCategory setAudioCategoryId:targetCategoryId] ;
            [audioCategories addObject:audioCategory] ;
        }
    }

}


















/////////////////////////////////////////////////////////////////////////////////
#pragma mark SellSectionCategory
/////////////////////////////////////////////////////////////////////////////////
- (void)setSellSectionCategory:(SellSectionCategory *)sellSectionCategory title:(NSString *)title
{
    if([VeamUtil isEmpty:sellSectionCategory.sellSectionCategoryId]){
        [sellSectionCategories insertObject:sellSectionCategory atIndex:0] ;
    } else {
        int count = [sellSectionCategories count] ;
        for(int index = 0 ; index  < count ; index++){
            SellSectionCategory *workSellSectionCategory = [sellSectionCategories objectAtIndex:index] ;
            if([workSellSectionCategory.sellSectionCategoryId isEqual:sellSectionCategory.sellSectionCategoryId]){
                [sellSectionCategories removeObjectAtIndex:index] ;
                [sellSectionCategories insertObject:sellSectionCategory atIndex:index] ;
                break ;
            }
        }
    }
    [self saveSellSectionCategory:sellSectionCategory title:title] ;
}

- (void)saveSellSectionCategory:(SellSectionCategory *)sellSectionCategory title:(NSString *)title
{
    NSString *apiName = @"sellsection/setcategory" ;
    NSString *sellSectionCategoryId = @"" ;
    if(![VeamUtil isEmpty:sellSectionCategory.sellSectionCategoryId]){
        sellSectionCategoryId = sellSectionCategory.sellSectionCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellSectionCategoryId],@"i",
                            [self escapeNull:sellSectionCategory.kind],@"k",
                            [self escapeNull:title],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:sellSectionCategory] ;
    //NSLog(@"set post resuilt? sellSectionCategory.targetCategoryId=%@",sellSectionCategory.targetCategoryId) ;
    self.appInfo.modified = @"1" ;
}

- (void)removeSellSectionCategoryAt:(NSInteger)index
{
    NSString *sellSectionCategoryIdToBeRemoved = nil ;
    int count = [sellSectionCategories count] ;
    if(index < count){
        SellSectionCategory *sellSectionCategory = [sellSectionCategories objectAtIndex:index] ;
        sellSectionCategoryIdToBeRemoved = sellSectionCategory.sellSectionCategoryId ;
        [sellSectionCategories removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:sellSectionCategoryIdToBeRemoved]){
        NSString *apiName = @"sellsection/removecategory" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:sellSectionCategoryIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (NSInteger)getNumberOfSellSectionCategories
{
    return [sellSectionCategories count] ;
}

- (NSMutableArray *)getSellSectionCategories
{
    return sellSectionCategories ;
}

- (SellSectionCategory *)getSellSectionCategoryAt:(NSInteger)index
{
    SellSectionCategory *retValue = nil ;
    if(index < [sellSectionCategories count]){
        retValue = [sellSectionCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)moveSellSectionCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    SellSectionCategory *objectToBeMoved = [sellSectionCategories objectAtIndex:fromIndex] ;
    [sellSectionCategories removeObjectAtIndex:fromIndex] ;
    [sellSectionCategories insertObject:objectToBeMoved atIndex:toIndex] ;
    [self saveSellSectionCategoryOrder] ;
}

- (void)saveSellSectionCategoryOrder
{
    int count = [sellSectionCategories count] ;
    if(count > 1){
        NSString *apiName = @"sellsection/setcategoryorder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            SellSectionCategory *category = [sellSectionCategories objectAtIndex:index] ;
            if(index == 0){
                orderString = category.sellSectionCategoryId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",category.sellSectionCategoryId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}


- (SellSectionCategory *)getSellSectionCategoryForId:(NSString *)sellSectionCategoryId
{
    NSInteger count = [sellSectionCategories count] ;
    SellSectionCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        SellSectionCategory *sellSectionCategory = [sellSectionCategories objectAtIndex:index] ;
        if([[sellSectionCategory sellSectionCategoryId] isEqualToString:sellSectionCategoryId]){
            retValue = sellSectionCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSString *)getCategoryTitleForSellSectionCategory:(SellSectionCategory *)sellSectionCategory
{
    NSString *retValue = @"" ;
    /*
    if([sellSectionCategory.kind isEqualToString:VEAM_SELL_SECTION_CATEGORY_KIND_VIDEO]){
        VideoCategory *videoCategory = [self getVideoCategoryForId:sellSectionCategory.targetCategoryId] ;
        if(videoCategory != nil){
            retValue = videoCategory.name ;
        }
    } else if([sellSectionCategory.kind isEqualToString:VEAM_SELL_SECTION_CATEGORY_KIND_PDF]){
        PdfCategory *pdfCategory = [self getPdfCategoryForId:sellSectionCategory.targetCategoryId] ;
        if(pdfCategory != nil){
            retValue = pdfCategory.name ;
        }
    } else if([sellSectionCategory.kind isEqualToString:VEAM_SELL_SECTION_CATEGORY_KIND_AUDIO]){
        AudioCategory *audioCategory = [self getAudioCategoryForId:sellSectionCategory.targetCategoryId] ;
        if(audioCategory != nil){
            retValue = audioCategory.name ;
        }
    }
     */
    retValue = sellSectionCategory.name ;
    return retValue ;
}

- (BOOL)isCategoryInSellSection:(NSString *)categoryId categoryKind:(NSString *)categoryKind
{
    BOOL retValue = NO ;
    /*
    NSArray *workSellSectionCategories = [self getSellSectionCategories] ;
    if(workSellSectionCategories != nil){
        int count = [workSellSectionCategories count] ;
        for(int index = 0 ; index < count ; index++){
            SellSectionCategory *sellSectionCategory = [workSellSectionCategories objectAtIndex:index] ;
            if([sellSectionCategory.kind isEqualToString:categoryKind] &&
               [sellSectionCategory.targetCategoryId isEqualToString:categoryId]){
                retValue = YES ;
                break ;
            }
        }
    }
     */
    return retValue ;
}

- (NSInteger)getNumberOfSellSectionItemsForSellSectionCategory:(NSString *)sellSectionCategoryId
{
    //NSLog(@"getNumberOfSellSectionItemsForSectionItemCategory SectionItemCategoryId=%@",SectionItemCategoryId) ;
    NSInteger retValue = 0 ;
    NSArray *sellSectionItemsForCategory = [self getSellSectionItemsForSellSectionCategory:sellSectionCategoryId] ;
    if(sellSectionItemsForCategory != nil){
        retValue = [sellSectionItemsForCategory count] ;
    }
    return retValue ;
}

- (NSArray *)getSellSectionItemsForSellSectionCategory:(NSString *)sellSectionCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellSectionItems count] ;
    //NSLog(@"getSellVideosForVideoCategory count=%d",count) ;
    for(int index = 0 ; index < count ; index++){
        SellSectionItem *sellSectionItem = [sellSectionItems objectAtIndex:index] ;
        if(sellSectionItem != nil){
            if([sellSectionItem.sellSectionCategoryId isEqualToString:sellSectionCategoryId]){
                [retValue addObject:sellSectionItem] ;
            }
        }
    }
    return retValue ;
}

- (SellSectionItem *)getSellSectionItemForSellSectionCategory:(NSString *)sellSectionCategoryId at:(NSInteger)index order:(NSComparisonResult)order
{
    SellSectionItem *retValue = nil ;
    NSArray *sellSectionItemsForCategory = [self getSellSectionItemsForSellSectionCategory:sellSectionCategoryId] ;
    if(sellSectionItemsForCategory != nil){
        if([sellSectionItemsForCategory count] >index){
            retValue = [sellSectionItemsForCategory objectAtIndex:index] ;
        }
    }
    
    return retValue ;
}

- (SellSectionItem *)getSellSectionItemForId:(NSString *)sellSectionItemId
{
    SellSectionItem *retValue = nil ;
    retValue = [sellSectionItemsForSellSectionItemId objectForKey:sellSectionItemId] ;
    return retValue ;
}






- (void)removeSellSectionItemForSellSectionCategory:(NSString *)sellSectionCategoryId at:(NSInteger)index
{
    NSMutableArray *sellSectionItemsForCategory = [self getSellSectionItemsForSellSectionCategory:sellSectionCategoryId] ;
    [self removeSellSectionItemFrom:sellSectionItemsForCategory at:index] ;
}

- (void)removeSellSectionItemFrom:(NSMutableArray *)sellSectionItemsForCategory at:(NSInteger)index
{
    if(sellSectionItemsForCategory != nil){
        NSString *sellSectionItemIdToBeRemoved = nil ;
        int count = [sellSectionItemsForCategory count] ;
        if(index < count){
            SellSectionItem *sellSectionItem = [sellSectionItemsForCategory objectAtIndex:index] ;
            sellSectionItemIdToBeRemoved = sellSectionItem.sellSectionItemId ;
            [sellSectionItemsForCategory removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:sellSectionItemIdToBeRemoved]){
            NSString *apiName = @"sellsection/removesellsectionitem" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:sellSectionItemIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
            int count = [sellSectionItems count] ;
            for(int sellSectionItemIndex = 0 ; sellSectionItemIndex < count ; sellSectionItemIndex++){
                SellSectionItem *sellSectionItem = [sellSectionItems objectAtIndex:sellSectionItemIndex] ;
                if(sellSectionItem != nil){
                    NSString *workSellSectionItemId = [sellSectionItem sellSectionItemId] ;
                    if([sellSectionItemIdToBeRemoved isEqualToString:workSellSectionItemId]){
                        [sellSectionItems removeObjectAtIndex:sellSectionItemIndex] ;
                        break ;
                    }
                }
            }
            [sellSectionItemsForSellSectionItemId removeObjectForKey:sellSectionItemIdToBeRemoved] ;
        }
    }
}








- (void)setSellSectionVideo:(SellSectionItem *)sellSectionItem videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl videoImageUrl:(NSString *)videoImageUrl
{
    NSMutableArray *workSellSectionItems = nil ;
    workSellSectionItems = [self getSellSectionItemsForSellSectionCategory:sellSectionItem.sellSectionCategoryId] ;
    
    if(workSellSectionItems == nil){
        workSellSectionItems = [NSMutableArray array] ;
    }
    
    if(workSellSectionItems != nil){
        if([VeamUtil isEmpty:sellSectionItem.sellSectionItemId]){
            [workSellSectionItems insertObject:sellSectionItem atIndex:0] ;
        } else {
            int count = [workSellSectionItems count] ;
            for(int index = 0 ; index  < count ; index++){
                SellSectionItem *workSellSectionItem = [workSellSectionItems objectAtIndex:index] ;
                if([workSellSectionItem.sellSectionItemId isEqual:sellSectionItem.sellSectionItemId]){
                    [workSellSectionItems removeObjectAtIndex:index] ;
                    [workSellSectionItems insertObject:sellSectionItem atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveSellSectionVideo:sellSectionItem videoTitle:videoTitle videoSourceUrl:videoSourceUrl videoImageUrl:videoImageUrl] ;
    }
}

- (void)saveSellSectionVideo:(SellSectionItem *)sellSectionItem videoTitle:(NSString *)videoTitle videoSourceUrl:(NSString *)videoSourceUrl videoImageUrl:(NSString *)videoImageUrl
{
    NSString *apiName = @"sellsection/setvideo" ;
    //NSLog(@"%@",apiName) ;
    NSString *sellSectionItemId = @"" ;
    if(![VeamUtil isEmpty:sellSectionItem.sellSectionItemId]){
        sellSectionItemId = sellSectionItem.sellSectionItemId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellSectionItemId],@"i",
                            [self escapeNull:sellSectionItem.sellSectionCategoryId],@"c",
                            [self escapeNull:videoTitle],@"t",
                            [self escapeNull:videoSourceUrl],@"su",
                            [self escapeNull:videoImageUrl],@"iu",
                            nil] ;
    
    Video *video = [[Video alloc] init] ;
    [video setTitle:videoTitle] ;
    [video setVideoCategoryId:@"0"] ;
    
    ConsoleSellSectionItemPostHandler *consoleSellSectionItemPostHandler = [[ConsoleSellSectionItemPostHandler alloc] init] ;
    [consoleSellSectionItemPostHandler setSellSectionItem:sellSectionItem] ;
    [consoleSellSectionItemPostHandler setVideo:video] ;
    
    [self sendData:apiName params:params image:nil handlePostResultDelegate:consoleSellSectionItemPostHandler] ;
    self.appInfo.modified = @"1" ;
}

- (void)setSellSectionPdf:(SellSectionItem *)sellSectionItem pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl pdfImageUrl:(NSString *)pdfImageUrl
{
    NSMutableArray *workSellSectionItems = nil ;
    workSellSectionItems = [self getSellSectionItemsForSellSectionCategory:sellSectionItem.sellSectionCategoryId] ;
    
    if(workSellSectionItems == nil){
        workSellSectionItems = [NSMutableArray array] ;
    }
    
    if(workSellSectionItems != nil){
        if([VeamUtil isEmpty:sellSectionItem.sellSectionItemId]){
            [workSellSectionItems insertObject:sellSectionItem atIndex:0] ;
        } else {
            int count = [workSellSectionItems count] ;
            for(int index = 0 ; index  < count ; index++){
                SellSectionItem *workSellSectionItem = [workSellSectionItems objectAtIndex:index] ;
                if([workSellSectionItem.sellSectionItemId isEqual:sellSectionItem.sellSectionItemId]){
                    [workSellSectionItems removeObjectAtIndex:index] ;
                    [workSellSectionItems insertObject:sellSectionItem atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveSellSectionPdf:sellSectionItem pdfTitle:pdfTitle pdfSourceUrl:pdfSourceUrl pdfImageUrl:pdfImageUrl] ;
    }
}

- (void)saveSellSectionPdf:(SellSectionItem *)sellSectionItem pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl pdfImageUrl:(NSString *)pdfImageUrl
{
    NSString *apiName = @"sellsection/setpdf" ;
    //NSLog(@"%@",apiName) ;
    NSString *sellSectionItemId = @"" ;
    if(![VeamUtil isEmpty:sellSectionItem.sellSectionItemId]){
        sellSectionItemId = sellSectionItem.sellSectionItemId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellSectionItemId],@"i",
                            [self escapeNull:sellSectionItem.sellSectionCategoryId],@"c",
                            [self escapeNull:pdfTitle],@"t",
                            [self escapeNull:pdfSourceUrl],@"su",
                            [self escapeNull:pdfImageUrl],@"iu",
                            nil] ;
    
    Pdf *pdf = [[Pdf alloc] init] ;
    [pdf setTitle:pdfTitle] ;
    [pdf setPdfCategoryId:@"0"] ;
    
    ConsoleSellSectionItemPostHandler *consoleSellSectionItemPostHandler = [[ConsoleSellSectionItemPostHandler alloc] init] ;
    [consoleSellSectionItemPostHandler setSellSectionItem:sellSectionItem] ;
    [consoleSellSectionItemPostHandler setPdf:pdf] ;
    
    [self sendData:apiName params:params image:nil handlePostResultDelegate:consoleSellSectionItemPostHandler] ;
    self.appInfo.modified = @"1" ;
}

- (void)setSellSectionAudio:(SellSectionItem *)sellSectionItem audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl  audioLinkUrl:(NSString *)audioLinkUrl
{
    NSMutableArray *workSellSectionItems = nil ;
    workSellSectionItems = [self getSellSectionItemsForSellSectionCategory:sellSectionItem.sellSectionCategoryId] ;
    
    if(workSellSectionItems == nil){
        workSellSectionItems = [NSMutableArray array] ;
    }
    
    if(workSellSectionItems != nil){
        if([VeamUtil isEmpty:sellSectionItem.sellSectionItemId]){
            [workSellSectionItems insertObject:sellSectionItem atIndex:0] ;
        } else {
            int count = [workSellSectionItems count] ;
            for(int index = 0 ; index  < count ; index++){
                SellSectionItem *workSellSectionItem = [workSellSectionItems objectAtIndex:index] ;
                if([workSellSectionItem.sellSectionItemId isEqual:sellSectionItem.sellSectionItemId]){
                    [workSellSectionItems removeObjectAtIndex:index] ;
                    [workSellSectionItems insertObject:sellSectionItem atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveSellSectionAudio:sellSectionItem audioTitle:audioTitle audioSourceUrl:audioSourceUrl audioImageUrl:audioImageUrl audioLinkUrl:audioLinkUrl] ;
    }
}

- (void)saveSellSectionAudio:(SellSectionItem *)sellSectionItem audioTitle:(NSString *)audioTitle audioSourceUrl:(NSString *)audioSourceUrl audioImageUrl:(NSString *)audioImageUrl audioLinkUrl:(NSString *)audioLinkUrl
{
    NSString *apiName = @"sellsection/setaudio" ;
    //NSLog(@"%@",apiName) ;
    NSString *sellSectionItemId = @"" ;
    if(![VeamUtil isEmpty:sellSectionItem.sellSectionItemId]){
        sellSectionItemId = sellSectionItem.sellSectionItemId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellSectionItemId],@"i",
                            [self escapeNull:sellSectionItem.sellSectionCategoryId],@"c",
                            [self escapeNull:audioTitle],@"t",
                            [self escapeNull:audioSourceUrl],@"su",
                            [self escapeNull:audioImageUrl],@"iu",
                            [self escapeNull:audioLinkUrl],@"lu",
                            nil] ;
    
    Audio *audio = [[Audio alloc] init] ;
    [audio setTitle:audioTitle] ;
    [audio setAudioCategoryId:@"0"] ;
    
    ConsoleSellSectionItemPostHandler *consoleSellSectionItemPostHandler = [[ConsoleSellSectionItemPostHandler alloc] init] ;
    [consoleSellSectionItemPostHandler setSellSectionItem:sellSectionItem] ;
    [consoleSellSectionItemPostHandler setAudio:audio] ;
    
    [self sendData:apiName params:params image:nil handlePostResultDelegate:consoleSellSectionItemPostHandler] ;
    self.appInfo.modified = @"1" ;
}

- (void)updatePreparingSellSectionItemStatus:(NSString *)sellSectionCategoryId
{
    NSString *apiName = @"sellsection/getsellsectionitemstatus" ;
    
    NSString *preparingSellSectionItemIds = @"" ;
    
    NSMutableArray *sellSectionItems = [self getSellSectionItemsForSellSectionCategory:sellSectionCategoryId] ;
    NSInteger count = [sellSectionItems count] ;
    for(int index = 0 ; index < count ; index++){
        SellSectionItem *sellSectionItem = [sellSectionItems objectAtIndex:index] ;
        if([sellSectionItem.status isEqual:VEAM_SELL_SECTION_ITEM_STATUS_PREPARING]){
            if(![VeamUtil isEmpty:preparingSellSectionItemIds]){
                preparingSellSectionItemIds = [preparingSellSectionItemIds stringByAppendingFormat:@",%@",sellSectionItem.sellSectionItemId] ;
            } else {
                preparingSellSectionItemIds = sellSectionItem.sellSectionItemId ;
            }
        }
    }
    
    if(![VeamUtil isEmpty:preparingSellSectionItemIds]){
        ConsoleUpdatePreparingSellSectionItemStatusHandler *handler = [[ConsoleUpdatePreparingSellSectionItemStatusHandler alloc] init] ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:preparingSellSectionItemIds],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:handler] ;
    }
}



































/////////////////////////////////////////////////////////////////////////////////
#pragma mark Pdf
/////////////////////////////////////////////////////////////////////////////////
- (void)setPdfCategory:(PdfCategory *)pdfCategory
{
    if([VeamUtil isEmpty:pdfCategory.pdfCategoryId]){
        [pdfCategories insertObject:pdfCategory atIndex:0] ;
    } else {
        int count = [pdfCategories count] ;
        for(int index = 0 ; index  < count ; index++){
            PdfCategory *workPdfCategory = [pdfCategories objectAtIndex:index] ;
            if([workPdfCategory.pdfCategoryId isEqual:pdfCategory.pdfCategoryId]){
                [pdfCategories removeObjectAtIndex:index] ;
                [pdfCategories insertObject:pdfCategory atIndex:index] ;
                break ;
            }
        }
    }
    [self savePdfCategory:pdfCategory] ;
}

- (void)savePdfCategory:(PdfCategory *)pdfCategory
{
    NSString *apiName = @"pdf/setcategory" ;
    NSString *pdfCategoryId = @"" ;
    if(![VeamUtil isEmpty:pdfCategory.pdfCategoryId]){
        pdfCategoryId = pdfCategory.pdfCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:pdfCategoryId],@"i",
                            [self escapeNull:pdfCategory.name],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:pdfCategory] ;
    self.appInfo.modified = @"1" ;
}

- (void)removePdfCategoryAt:(NSInteger)index
{
    NSString *pdfCategoryIdToBeRemoved = nil ;
    int count = [pdfCategories count] ;
    if(index < count){
        PdfCategory *pdfCategory = [pdfCategories objectAtIndex:index] ;
        pdfCategoryIdToBeRemoved = pdfCategory.pdfCategoryId ;
        [pdfCategories removeObjectAtIndex:index] ;
    }
    
    if(![VeamUtil isEmpty:pdfCategoryIdToBeRemoved]){
        NSString *apiName = @"pdf/removecategory" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:pdfCategoryIdToBeRemoved],@"i",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}

- (NSInteger)getNumberOfPdfCategories
{
    return [pdfCategories count] ;
}

- (NSMutableArray *)getPdfCategories
{
    return pdfCategories ;
}

- (PdfCategory *)getPdfCategoryAt:(NSInteger)index
{
    PdfCategory *retValue = nil ;
    if(index < [pdfCategories count]){
        retValue = [pdfCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)movePdfCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    PdfCategory *objectToBeMoved = [pdfCategories objectAtIndex:fromIndex] ;
    [pdfCategories removeObjectAtIndex:fromIndex] ;
    [pdfCategories insertObject:objectToBeMoved atIndex:toIndex] ;
    [self savePdfCategoryOrder] ;
}

- (void)savePdfCategoryOrder
{
    int count = [pdfCategories count] ;
    if(count > 1){
        NSString *apiName = @"pdf/setcategoryorder" ;
        NSString *orderString = @"" ;
        for(int index = 0 ; index < count ; index++){
            PdfCategory *category = [pdfCategories objectAtIndex:index] ;
            if(index == 0){
                orderString = category.pdfCategoryId ;
            } else {
                orderString = [orderString stringByAppendingFormat:@",%@",category.pdfCategoryId] ;
            }
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self escapeNull:orderString],@"o",
                                nil] ;
        [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
        self.appInfo.modified = @"1" ;
    }
}


- (PdfCategory *)getPdfCategoryForId:(NSString *)pdfCategoryId
{
    NSInteger count = [pdfCategories count] ;
    PdfCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        PdfCategory *pdfCategory = [pdfCategories objectAtIndex:index] ;
        if([[pdfCategory pdfCategoryId] isEqualToString:pdfCategoryId]){
            retValue = pdfCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSMutableArray *)getPdfSubCategories:(NSString *)pdfCategoryId
{
    NSMutableArray *retValue = [pdfSubCategoriesPerCategory objectForKey:pdfCategoryId] ;
    return retValue ;
}

- (NSInteger)getNumberOfPdfSubCategories:(NSString *)pdfCategoryId
{
    return [[self getPdfSubCategories:pdfCategoryId] count] ;
}

- (PdfSubCategory *)getPdfSubCategoryAt:(NSInteger)index pdfCategoryId:(NSString *)pdfCategoryId
{
    PdfSubCategory *retValue = nil ;
    if(index < [[self getPdfSubCategories:pdfCategoryId] count]){
        retValue = [[self getPdfSubCategories:pdfCategoryId] objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)movePdfSubCategoryFrom:(NSInteger)fromIndex to:(NSInteger)toIndex pdfCategoryId:(NSString *)pdfCategoryId
{
    NSMutableArray *subCategories = [self getPdfSubCategories:pdfCategoryId] ;
    if(subCategories != nil){
        PdfSubCategory *objectToBeMoved = [subCategories objectAtIndex:fromIndex] ;
        [subCategories removeObjectAtIndex:fromIndex] ;
        [subCategories insertObject:objectToBeMoved atIndex:toIndex] ;
        [self savePdfSubCategoryOrder:pdfCategoryId] ;
    }
}

- (void)savePdfSubCategoryOrder:(NSString *)pdfCategoryId
{
    
    NSMutableArray *subCategories = [self getPdfSubCategories:pdfCategoryId] ;
    if(subCategories != nil){
        int count = [subCategories count] ;
        if(count > 1){
            NSString *apiName = @"pdf/setsubcategoryorder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                PdfSubCategory *subCategory = [subCategories objectAtIndex:index] ;
                if(index == 0){
                    orderString = subCategory.pdfSubCategoryId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",subCategory.pdfSubCategoryId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setPdfSubCategory:(PdfSubCategory *)pdfSubCategory
{
    NSMutableArray *subCategories = [self getPdfSubCategories:pdfSubCategory.pdfCategoryId] ;
    if(subCategories == nil){
        subCategories = [NSMutableArray array] ;
        [pdfSubCategoriesPerCategory setObject:subCategories forKey:pdfSubCategory.pdfCategoryId] ;
    }
    
    if(subCategories != nil){
        if([VeamUtil isEmpty:pdfSubCategory.pdfSubCategoryId]){
            [subCategories insertObject:pdfSubCategory atIndex:0] ;
        } else {
            int count = [subCategories count] ;
            for(int index = 0 ; index  < count ; index++){
                PdfSubCategory *workPdfSubCategory = [subCategories objectAtIndex:index] ;
                if([workPdfSubCategory.pdfSubCategoryId isEqual:pdfSubCategory.pdfSubCategoryId]){
                    [subCategories removeObjectAtIndex:index] ;
                    [subCategories insertObject:pdfSubCategory atIndex:index] ;
                    break ;
                }
            }
        }
        [self savePdfSubCategory:pdfSubCategory] ;
    }
}

- (void)savePdfSubCategory:(PdfSubCategory *)pdfSubCategory
{
    NSString *apiName = @"pdf/setsubcategory" ;
    NSString *pdfSubCategoryId = @"" ;
    if(![VeamUtil isEmpty:pdfSubCategory.pdfSubCategoryId]){
        pdfSubCategoryId = pdfSubCategory.pdfSubCategoryId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:pdfSubCategoryId],@"i",
                            [self escapeNull:pdfSubCategory.pdfCategoryId],@"c",
                            [self escapeNull:pdfSubCategory.name],@"n",
                            nil] ;
    [self sendData:apiName params:params image:nil handlePostResultDelegate:pdfSubCategory] ;
    self.appInfo.modified = @"1" ;
}

- (void)removePdfSubCategoryAt:(NSInteger)index pdfCategoryId:(NSString *)pdfCategoryId
{
    NSMutableArray *subCategories = [self getPdfSubCategories:pdfCategoryId] ;
    if(subCategories != nil){
        NSString *pdfSubCategoryIdToBeRemoved = nil ;
        int count = [subCategories count] ;
        if(index < count){
            PdfSubCategory *pdfSubCategory = [subCategories objectAtIndex:index] ;
            pdfSubCategoryIdToBeRemoved = pdfSubCategory.pdfSubCategoryId ;
            [subCategories removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:pdfSubCategoryIdToBeRemoved]){
            NSString *apiName = @"pdf/removesubcategory" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:pdfSubCategoryIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (NSInteger)getNumberOfPdfsForCategory:(NSString *)pdfCategoryId
{
    return [[self getPdfsForCategory:pdfCategoryId] count] ;
}

- (NSInteger)getNumberOfPdfsForSubCategory:(NSString *)pdfSubCategoryId
{
    return [[self getPdfsForSubCategory:pdfSubCategoryId] count] ;
}

- (NSMutableArray *)getPdfsForCategory:(NSString *)pdfCategoryId
{
    NSMutableArray *retValue = [pdfsPerCategory objectForKey:pdfCategoryId] ;
    return retValue ;
}


- (NSMutableArray *)getPdfsForSubCategory:(NSString *)pdfSubCategoryId
{
    NSMutableArray *retValue = [pdfsPerSubCategory objectForKey:pdfSubCategoryId] ;
    return retValue ;
}

- (Pdf *)getPdfForId:(NSString *)pdfId
{
    Pdf *retValue = nil ;
    retValue = [pdfsForPdfId objectForKey:pdfId] ;
    return retValue ;
}

- (Pdf *)getPdfForCategory:(NSString *)pdfCategoryId at:(NSInteger)index
{
    Pdf *retValue = nil ;
    NSArray *pdfs = [self getPdfsForCategory:pdfCategoryId] ;
    retValue = [pdfs objectAtIndex:index] ;
    return retValue ;
}

- (Pdf *)getPdfForSubCategory:(NSString *)pdfSubCategoryId at:(NSInteger)index
{
    Pdf *retValue = nil ;
    NSArray *pdfs = [self getPdfsForSubCategory:pdfSubCategoryId] ;
    retValue = [pdfs objectAtIndex:index] ;
    return retValue ;
}

- (void)movePdfForCategory:(NSString *)pdfCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *pdfs = [self getPdfsForCategory:pdfCategoryId] ;
    if(pdfs != nil){
        Pdf *objectToBeMoved = [pdfs objectAtIndex:fromIndex] ;
        [pdfs removeObjectAtIndex:fromIndex] ;
        [pdfs insertObject:objectToBeMoved atIndex:toIndex] ;
        [self savePdfOrder:pdfs] ;
    }
}

- (void)movePdfForSubCategory:(NSString *)pdfSubCategoryId from:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *pdfs = [self getPdfsForSubCategory:pdfSubCategoryId] ;
    if(pdfs != nil){
        Pdf *objectToBeMoved = [pdfs objectAtIndex:fromIndex] ;
        [pdfs removeObjectAtIndex:fromIndex] ;
        [pdfs insertObject:objectToBeMoved atIndex:toIndex] ;
        [self savePdfOrder:pdfs] ;
    }
}

- (void)savePdfOrder:(NSMutableArray *)pdfs
{
    if(pdfs != nil){
        int count = [pdfs count] ;
        if(count > 1){
            NSString *apiName = @"pdf/setpdforder" ;
            NSString *orderString = @"" ;
            for(int index = 0 ; index < count ; index++){
                Pdf *pdf = [pdfs objectAtIndex:index] ;
                if(index == 0){
                    orderString = pdf.pdfId ;
                } else {
                    orderString = [orderString stringByAppendingFormat:@",%@",pdf.pdfId] ;
                }
            }
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:orderString],@"o",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}

- (void)setPdf:(Pdf *)pdf thumbnailImage:(UIImage *)thumbnailImage
{
    NSMutableArray *pdfs = nil ;
    if([pdf.pdfSubCategoryId isEqual:@"0"]){
        pdfs = [self getPdfsForCategory:pdf.pdfCategoryId] ;
    } else {
        pdfs = [self getPdfsForSubCategory:pdf.pdfSubCategoryId] ;
    }
    
    if(pdfs == nil){
        pdfs = [NSMutableArray array] ;
        if([pdf.pdfSubCategoryId isEqual:@"0"]){
            [pdfsPerCategory setObject:pdfs forKey:pdf.pdfCategoryId] ;
        } else {
            [pdfsPerSubCategory setObject:pdfs forKey:pdf.pdfSubCategoryId] ;
        }
    }
    
    if(pdfs != nil){
        if([VeamUtil isEmpty:pdf.pdfId]){
            [pdfs insertObject:pdf atIndex:0] ;
        } else {
            int count = [pdfs count] ;
            for(int index = 0 ; index  < count ; index++){
                Pdf *workPdf = [pdfs objectAtIndex:index] ;
                if([workPdf.pdfId isEqual:pdf.pdfId]){
                    [pdfs removeObjectAtIndex:index] ;
                    [pdfs insertObject:pdf atIndex:index] ;
                    break ;
                }
            }
        }
        [self savePdf:pdf thumbnailImage:thumbnailImage] ;
    }
}

- (void)savePdf:(Pdf *)pdf thumbnailImage:(UIImage *)thumbnailImage
{
    NSString *apiName = @"pdf/setpdf" ;
    //NSLog(@"%@",apiName) ;
    NSString *pdfId = @"" ;
    if(![VeamUtil isEmpty:pdf.pdfId]){
        pdfId = pdf.pdfId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:pdfId],@"i",
                            [self escapeNull:pdf.pdfCategoryId],@"c",
                            [self escapeNull:pdf.pdfSubCategoryId],@"sub",
                            [self escapeNull:pdf.title],@"t",
                            [self escapeNull:pdf.kind],@"k",
                            [self escapeNull:pdf.sourceUrl],@"su",
                            nil] ;
    [self sendData:apiName params:params image:thumbnailImage handlePostResultDelegate:pdf] ;
    self.appInfo.modified = @"1" ;
}

- (void)removePdfForCategory:(NSString *)pdfCategoryId at:(NSInteger)index
{
    NSMutableArray *pdfs = [self getPdfsForCategory:pdfCategoryId] ;
    [self removePdfFrom:pdfs at:index] ;
}

- (void)removePdfForSubCategory:(NSString *)pdfSubCategoryId at:(NSInteger)index
{
    NSMutableArray *pdfs = [self getPdfsForSubCategory:pdfSubCategoryId] ;
    [self removePdfFrom:pdfs at:index] ;
}

- (void)removePdfFrom:(NSMutableArray *)pdfs at:(NSInteger)index
{
    if(pdfs != nil){
        NSString *pdfIdToBeRemoved = nil ;
        int count = [pdfs count] ;
        if(index < count){
            Pdf *pdf = [pdfs objectAtIndex:index] ;
            pdfIdToBeRemoved = pdf.pdfId ;
            [pdfs removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:pdfIdToBeRemoved]){
            NSString *apiName = @"pdf/removepdf" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:pdfIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
        }
    }
}







- (NSInteger)getNumberOfSellPdfsForPdfCategory:(NSString *)pdfCategoryId
{
    //NSLog(@"getNumberOfSellPdfsForPdfCategory pdfCategoryId=%@",pdfCategoryId) ;
    NSInteger retValue = 0 ;
    NSArray *sellPdfsForCategory = [self getSellPdfsForPdfCategory:pdfCategoryId] ;
    if(sellPdfsForCategory != nil){
        retValue = [sellPdfsForCategory count] ;
    }
    return retValue ;
}

- (NSArray *)getSellPdfsForPdfCategory:(NSString *)pdfCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellPdfs count] ;
    //NSLog(@"getSellPdfsForPdfCategory count=%d",count) ;
    for(int index = 0 ; index < count ; index++){
        SellPdf *sellPdf = [sellPdfs objectAtIndex:index] ;
        if(sellPdf != nil){
            Pdf *pdf = [self getPdfForId:sellPdf.pdfId] ;
            if(pdf != nil){
                if([pdf.pdfCategoryId isEqualToString:pdfCategoryId]){
                    [retValue addObject:sellPdf] ;
                }
            }
        }
    }
    return retValue ;
}

- (SellPdf *)getSellPdfForPdfCategory:(NSString *)pdfCategoryId at:(NSInteger)index order:(NSComparisonResult)order
{
    SellPdf *retValue = nil ;
    NSArray *sellPdfsForCategory = [self getSellPdfsForPdfCategory:pdfCategoryId] ;
    if(sellPdfsForCategory != nil){
        if([sellPdfsForCategory count] >index){
            retValue = [sellPdfsForCategory objectAtIndex:index] ;
        }
    }
    
    return retValue ;
}

- (SellPdf *)getSellPdfForId:(NSString *)sellPdfId
{
    SellPdf *retValue = nil ;
    retValue = [sellPdfsForSellPdfId objectForKey:sellPdfId] ;
    return retValue ;
}


- (void)removeSellPdfForPdfCategory:(NSString *)pdfCategoryId at:(NSInteger)index
{
    NSMutableArray *sellPdfsForCategory = [self getSellPdfsForPdfCategory:pdfCategoryId] ;
    [self removeSellPdfFrom:sellPdfsForCategory at:index] ;
}

- (void)removeSellPdfFrom:(NSMutableArray *)sellPdfsForCategory at:(NSInteger)index
{
    if(sellPdfsForCategory != nil){
        NSString *sellPdfIdToBeRemoved = nil ;
        int count = [sellPdfsForCategory count] ;
        if(index < count){
            SellPdf *sellPdf = [sellPdfsForCategory objectAtIndex:index] ;
            sellPdfIdToBeRemoved = sellPdf.sellPdfId ;
            [sellPdfsForCategory removeObjectAtIndex:index] ;
        }
        
        if(![VeamUtil isEmpty:sellPdfIdToBeRemoved]){
            NSString *apiName = @"sellitem/removesellpdf" ;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self escapeNull:sellPdfIdToBeRemoved],@"i",
                                    nil] ;
            [self sendData:apiName params:params image:nil handlePostResultDelegate:nil] ;
            self.appInfo.modified = @"1" ;
            int count = [sellPdfs count] ;
            for(int sellPdfIndex = 0 ; sellPdfIndex < count ; sellPdfIndex++){
                SellPdf *sellPdf = [sellPdfs objectAtIndex:sellPdfIndex] ;
                if(sellPdf != nil){
                    NSString *workSellPdfId = [sellPdf sellPdfId] ;
                    if([sellPdfIdToBeRemoved isEqualToString:workSellPdfId]){
                        [sellPdfs removeObjectAtIndex:sellPdfIndex] ;
                        break ;
                    }
                }
            }
            [sellPdfsForSellPdfId removeObjectForKey:sellPdfIdToBeRemoved] ;
        }
    }
}




- (void)setSellPdf:(SellPdf *)sellPdf pdfCategoryId:(NSString *)pdfCategoryId pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl pdfImageUrl:(NSString *)pdfImageUrl
{
    NSMutableArray *workSellPdfs = nil ;
    workSellPdfs = [self getSellPdfsForPdfCategory:pdfCategoryId] ;
    
    if(workSellPdfs == nil){
        workSellPdfs = [NSMutableArray array] ;
    }
    
    if(workSellPdfs != nil){
        if([VeamUtil isEmpty:sellPdf.sellPdfId]){
            [workSellPdfs insertObject:sellPdf atIndex:0] ;
        } else {
            int count = [workSellPdfs count] ;
            for(int index = 0 ; index  < count ; index++){
                SellPdf *workSellPdf = [workSellPdfs objectAtIndex:index] ;
                if([workSellPdf.sellPdfId isEqual:sellPdf.sellPdfId]){
                    [workSellPdfs removeObjectAtIndex:index] ;
                    [workSellPdfs insertObject:sellPdf atIndex:index] ;
                    break ;
                }
            }
        }
        [self saveSellPdf:sellPdf pdfCategoryId:pdfCategoryId pdfTitle:pdfTitle pdfSourceUrl:pdfSourceUrl pdfImageUrl:pdfImageUrl] ;
    }
}

- (void)saveSellPdf:(SellPdf *)sellPdf pdfCategoryId:(NSString *)pdfCategoryId pdfTitle:(NSString *)pdfTitle pdfSourceUrl:(NSString *)pdfSourceUrl pdfImageUrl:(NSString *)pdfImageUrl
{
    NSString *apiName = @"sellitem/setpdf" ;
    //NSLog(@"%@",apiName) ;
    NSString *sellPdfId = @"" ;
    if(![VeamUtil isEmpty:sellPdf.sellPdfId]){
        sellPdfId = sellPdf.sellPdfId ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self escapeNull:sellPdfId],@"i",
                            [self escapeNull:pdfCategoryId],@"c",
                            [self escapeNull:sellPdf.description],@"d",
                            [self escapeNull:sellPdf.price],@"p",
                            [self escapeNull:pdfTitle],@"t",
                            [self escapeNull:pdfSourceUrl],@"su",
                            [self escapeNull:pdfImageUrl],@"iu",
                            nil] ;
    
    Pdf *pdf = [[Pdf alloc] init] ;
    [pdf setTitle:pdfTitle] ;
    [pdf setPdfCategoryId:pdfCategoryId] ;
    
    ConsoleSellPdfPostHandler *consoleSellPdfPostHandler = [[ConsoleSellPdfPostHandler alloc] init] ;
    [consoleSellPdfPostHandler setSellPdf:sellPdf] ;
    [consoleSellPdfPostHandler setPdf:pdf] ;
    
    [self sendData:apiName params:params image:nil handlePostResultDelegate:consoleSellPdfPostHandler] ;
    self.appInfo.modified = @"1" ;
}





































@end
