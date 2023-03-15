//
//  VeamUtil.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamUtil.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "YoutubeCategoryViewController.h"
#import "ForumViewController.h"
#import "RecipeCategoryViewController.h"
#import "MixedCategoryViewController.h"
#import "WebListViewController.h"
#import "WebViewController.h"
#import "VideoCategoryViewController.h"
#import "MixedGridViewController.h"
#import "QAViewController.h"
#import "CalendarMenuViewController.h"
#import "SellVideo.h"
#import "SellPdf.h"
#import "SellAudio.h"
#import "SellItemCategoryViewController.h"
#import "SellSectionCategoryViewController.h"


@implementation VeamUtil

+ (BOOL)isVeamConsole
{
    return IS_VEAM_CONSOLE ;
}

#pragma mark Directory and File

+ (NSString *)applicationCachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] ;
}

+ (NSString *)getFilePathAtCachesDirectory:(NSString *)fileName
{
    NSString *applicationCachesDirectory = [VeamUtil applicationCachesDirectory] ;
    NSString *filePath = [applicationCachesDirectory stringByAppendingPathComponent:fileName] ;
    return filePath ;
}

+ (BOOL)moveFile:(NSString *)fromPath toPath:(NSString *)toPath
{
    //NSLog(@"move %@ -> %@",fromPath,toPath) ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    BOOL existsTmpFile = NO ;
    
    // remove tmp file is any
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@.tmp",toPath] error:nil] ;
    
    if([fileManager fileExistsAtPath:toPath]){
        // rename target file to tmp
        if(![fileManager moveItemAtPath:toPath toPath:[NSString stringWithFormat:@"%@.tmp",toPath] error:nil]){
            return NO ;
        }
        existsTmpFile = YES ;
    }
    
    if([fileManager moveItemAtPath:fromPath toPath:toPath error:nil]){
        // remove tmp file if moved successfully
        if(existsTmpFile){
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@.tmp",toPath] error:nil] ;
        }
        return YES ;
    } else {
        // restore tmp file if failed to move
        if(existsTmpFile){
            [fileManager moveItemAtPath:[NSString stringWithFormat:@"%@.tmp",toPath] toPath:toPath error:nil] ;
        }
        return NO ;
    }
    
    return YES ;
}



#pragma mark User Defaults


+ (void)setUserDefaultString:(NSString *)key value:(NSString *)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:value forKey:key] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getUserDefaultString:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *value = [userDefaults objectForKey:key] ;
    return value ;
}

+ (void)setFavoritesForKind:(NSString *)kind value:(NSString *)value
{
    [VeamUtil setUserDefaultString:[NSString stringWithFormat:VEAM_USER_DEFAULT_KEY_FAVORITE_FORMAT,kind] value:value] ;
}

+ (NSString *)getFavoritesForKind:(NSString *)kind
{
    return [VeamUtil getUserDefaultString:[NSString stringWithFormat:VEAM_USER_DEFAULT_KEY_FAVORITE_FORMAT,kind]] ;
}

+ (BOOL)isFavoriteForKind:(NSString *)kind targetId:(NSString *)targetId
{
    BOOL retValue = NO ;
    NSString *favoritesString = [VeamUtil getFavoritesForKind:kind] ;
    NSArray *favoriteIds = [favoritesString componentsSeparatedByString:@"_"] ;
    int count = [favoriteIds count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *workId = [favoriteIds objectAtIndex:index] ;
        if((workId != nil) && [workId isEqualToString:targetId]){
            retValue = YES ;
            break ;
        }
    }
    return retValue ;
}

+ (void)addFavoriteForKind:(NSString *)kind targetId:(NSString *)targetId
{
    //NSLog(@"addFavoriteVideo") ;
    if(![VeamUtil isFavoriteForKind:kind targetId:targetId]){
        NSString *favoritesString = [VeamUtil getFavoritesForKind:kind] ;
        NSString *newFavoritesString = nil ;
        if([VeamUtil isEmpty:favoritesString]){
            newFavoritesString = targetId ;
        } else {
            newFavoritesString = [NSString stringWithFormat:@"%@_%@",targetId,favoritesString] ;
        }
        //NSLog(@"new : %@",newFavoritesString) ;
        [VeamUtil setFavoritesForKind:kind value:newFavoritesString] ;
    }
}

+ (void)deleteFavoriteForKind:(NSString *)kind targetId:(NSString *)targetId
{
    //NSLog(@"deleteFavoriteVideo") ;
    NSString *favoritesString = [VeamUtil getFavoritesForKind:kind] ;
    NSArray *favoriteIds = [favoritesString componentsSeparatedByString:@"_"] ;
    NSString *newFavoritesString = nil ;
    int count = [favoriteIds count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *workId = [favoriteIds objectAtIndex:index] ;
        if(workId != nil){
            if(![workId isEqualToString:targetId]){
                if(newFavoritesString == nil){
                    newFavoritesString = workId ;
                } else {
                    newFavoritesString = [NSString stringWithFormat:@"%@_%@",newFavoritesString,workId] ;
                }
            }
        }
    }
    //NSLog(@"new : %@",newFavoritesString) ;
    [VeamUtil setFavoritesForKind:kind value:newFavoritesString] ;
}


+ (BOOL)isFavoriteYoutube:(NSString *)youtubeId
{
    return [VeamUtil isFavoriteForKind:VEAM_FAVORITE_KIND_YOUTUBE targetId:youtubeId] ;
}

+ (void)addFavoriteYoutube:(NSString *)youtubeId
{
    [VeamUtil addFavoriteForKind:VEAM_FAVORITE_KIND_YOUTUBE targetId:youtubeId] ;
}

+ (void)deleteFavoriteYoutube:(NSString *)youtubeId
{
    [VeamUtil deleteFavoriteForKind:VEAM_FAVORITE_KIND_YOUTUBE targetId:youtubeId] ;
}

+ (BOOL)isFavoriteVideo:(NSString *)videoId
{
    return [VeamUtil isFavoriteForKind:VEAM_FAVORITE_KIND_VIDEO targetId:videoId] ;
}

+ (void)addFavoriteVideo:(NSString *)videoId
{
    [VeamUtil addFavoriteForKind:VEAM_FAVORITE_KIND_VIDEO targetId:videoId] ;
}

+ (void)deleteFavoriteVideo:(NSString *)videoId
{
    [VeamUtil deleteFavoriteForKind:VEAM_FAVORITE_KIND_VIDEO targetId:videoId] ;
}

+ (BOOL)isFavoriteRecipe:(NSString *)recipeId
{
    return [VeamUtil isFavoriteForKind:VEAM_FAVORITE_KIND_RECIPE targetId:recipeId] ;
}

+ (void)addFavoriteRecipe:(NSString *)recipeId
{
    [VeamUtil addFavoriteForKind:VEAM_FAVORITE_KIND_RECIPE targetId:recipeId] ;
}

+ (void)deleteFavoriteRecipe:(NSString *)recipeId
{
    [VeamUtil deleteFavoriteForKind:VEAM_FAVORITE_KIND_RECIPE targetId:recipeId] ;
}

+ (BOOL)isFavoriteMixed:(NSString *)mixedId
{
    return [VeamUtil isFavoriteForKind:VEAM_FAVORITE_KIND_MIXED targetId:mixedId] ;
}

+ (void)addFavoriteMixed:(NSString *)mixedId
{
    [VeamUtil addFavoriteForKind:VEAM_FAVORITE_KIND_MIXED targetId:mixedId] ;
}

+ (void)deleteFavoriteMixed:(NSString *)mixedId
{
    [VeamUtil deleteFavoriteForKind:VEAM_FAVORITE_KIND_MIXED targetId:mixedId] ;
}

+ (BOOL)isFavoritePicture:(NSString *)pictureId
{
    return [VeamUtil isFavoriteForKind:VEAM_FAVORITE_KIND_PICTURE targetId:pictureId] ;
}

+ (void)addFavoritePicture:(NSString *)pictureId
{
    [VeamUtil addFavoriteForKind:VEAM_FAVORITE_KIND_PICTURE targetId:pictureId] ;
}

+ (void)deleteFavoritePicture:(NSString *)pictureId
{
    [VeamUtil deleteFavoriteForKind:VEAM_FAVORITE_KIND_PICTURE targetId:pictureId] ;
}

+ (void)setStoreReceipt:(NSString *)storeReceipt index:(NSInteger)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:storeReceipt forKey:[NSString stringWithFormat:USERDEFAULT_KEY_STORE_RECEIPT_FORMAT,index]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getStoreReceipt:(NSInteger)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *storeReceipt = [userDefaults objectForKey:[NSString stringWithFormat:USERDEFAULT_KEY_STORE_RECEIPT_FORMAT,index]] ;
    return storeReceipt ;
}

+ (void)setSubscriptionStartTime:(NSString *)startTime index:(NSInteger)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:startTime forKey:[NSString stringWithFormat:USERDEFAULT_KEY_SUBSCRIPTION_START_TIME_FORMAT,index]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getSubscriptionStartTime:(NSInteger)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *startTime = [userDefaults objectForKey:[NSString stringWithFormat:USERDEFAULT_KEY_SUBSCRIPTION_START_TIME_FORMAT,index]] ;
    return startTime ;
}

+ (void)setSubscriptionEndTime:(NSString *)endTime index:(NSInteger)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:endTime forKey:[NSString stringWithFormat:USERDEFAULT_KEY_SUBSCRIPTION_END_TIME_FORMAT,index]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getSubscriptionEndTime:(NSInteger)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *endTime = [userDefaults objectForKey:[NSString stringWithFormat:USERDEFAULT_KEY_SUBSCRIPTION_END_TIME_FORMAT,index]] ;
    return endTime ;
}





#pragma mark Utility
+ (CGFloat)getScreenWidth
{
    return [[UIScreen mainScreen] bounds].size.width ;
}

+ (CGFloat)getScreenHeight
{
    return [[UIScreen mainScreen] bounds].size.height ;
}

+ (BOOL)isShortDevice
{
    BOOL retValue = NO ;
    if([VeamUtil getScreenHeight] <= 480){
        retValue = YES ;
    }
    return retValue ;
}

+ (CGFloat)getViewTopOffset
{
    CGFloat retValue = 0 ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        retValue += 20 ;
    }
    return retValue ;
}

+ (CGFloat)getStatusBarHeight
{
    CGFloat retValue = 0.0 ;
    if(![UIApplication sharedApplication].statusBarHidden){
        CGRect frame = [[UIApplication sharedApplication] statusBarFrame] ;
        retValue = frame.size.height ;
    }
    return retValue ;
}

+ (BOOL)isEmpty:(NSString *)string
{
    BOOL retValue = NO ;
    if(string == nil){
        retValue = YES ;
    } else if([string isEqualToString:@""]){
        retValue = YES ;
    }
    return retValue ;
}

+ (NSURL *)getApiUrl:(NSString *)apiName
{
    return [NSURL URLWithString:[NSString stringWithFormat:VEAM_SERVER_FORMAT,apiName,[VeamUtil getAppId],[VeamUtil getLanguageId],[VeamUtil getTrackingId]]] ;
}

+ (NSString *)getSecureUrl:(NSString *)urlString
{
    NSString *secureUrl = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    
    //NSLog(@"%@ -> %@",urlString,secureUrl) ;
    return secureUrl ;
}

+ (NSString *)stringWithLanguagePostfix:(NSString *)string
{
    NSArray *languages = [NSLocale preferredLanguages] ;
    NSString *languageId = [languages objectAtIndex:0] ;
    NSString *retValue = [NSString stringWithFormat:@"%@_%@",string,languageId] ;
    return retValue ;
}

+ (NSString *)getConfigurationString:(NSString *)key default:(NSString *)defaultValue
{
    NSString *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    NSString *languageKey = [VeamUtil stringWithLanguagePostfix:key] ;
    if(contents != nil){
        NSString *value = [contents getValueForKey:languageKey] ;
        //NSLog(@"getConfigurationString key=%@",languageKey) ;
        if(![VeamUtil isEmpty:value]){
            retValue = value ;
        } else {
            NSString *value = [contents getValueForKey:key] ;
            if(![VeamUtil isEmpty:value]){
                retValue = value ;
            }
        }
    }
    if([VeamUtil isEmpty:retValue]){
        Configurations *configurations = [[AppDelegate sharedInstance] configurations] ;
        if(configurations != nil){
            NSString *value = [configurations getValueForKey:languageKey] ;
            if(![VeamUtil isEmpty:value]){
                retValue = value ;
            } else {
                NSString *value = [configurations getValueForKey:key] ;
                if(![VeamUtil isEmpty:value]){
                    retValue = value ;
                }
            }
        }
    }
    
    if([VeamUtil isEmpty:retValue]){
        retValue = defaultValue ;
    }
    return retValue ;
}

+ (CGFloat)getConfigurationFloat:(NSString *)key default:(CGFloat)defaultValue
{
    CGFloat retValue = defaultValue ;
    NSString *value = [VeamUtil getConfigurationString:key default:@""] ;
    if(![VeamUtil isEmpty:value]){
        retValue = [value floatValue] ;
    }
    return retValue ;
}

+ (NSInteger)getConfigurationInteger:(NSString *)key default:(NSInteger)defaultValue
{
    NSInteger retValue = defaultValue ;
    NSString *value = [VeamUtil getConfigurationString:key default:@""] ;
    if(![VeamUtil isEmpty:value]){
        retValue = [value integerValue] ;
    }
    return retValue ;
}

+ (UIColor *)getConfigurationColor:(NSString *)key default:(UIColor *)defaultValue
{
    UIColor *retValue = defaultValue ;
    NSString *value = [VeamUtil getConfigurationString:key default:@""] ;
    if(![VeamUtil isEmpty:value]){
        retValue = [VeamUtil getColorFromArgbString:value] ;
    }
    return retValue ;
}

+ (NSString *)getAppId
{
    NSString *appId = nil ;
    
    if([VeamUtil isVeamConsole]){
        appId = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_APP_ID] ;
    }
    
    if([VeamUtil isEmpty:appId]){
        appId = [VeamUtil getConfigurationString:VEAM_CONFIG_APP_ID default:@""] ;
    }
    return appId ;
}

+ (NSString *)getMcnId
{
    NSString *mcnId = nil ;
    
    if([VeamUtil isVeamConsole]){
        mcnId = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_MCN_ID] ;
    }
    
    if([VeamUtil isEmpty:mcnId]){
        mcnId = [VeamUtil getConfigurationString:VEAM_CONFIG_MCN_ID default:@""] ;
    }
    return mcnId ;
}

+ (BOOL)isRunningOnIpad
{
    //NSLog(@"%@",[[UIDevice currentDevice] model]) ;
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"])) ;
}


+ (NSString *)getAppName
{
    return [VeamUtil getConfigurationString:VEAM_CONFIG_APP_NAME default:@""] ;
}

+ (NSString *)getNewVideosText
{
    return [VeamUtil getConfigurationString:VEAM_CONFIG_NEW_VIDEOS_TEXT default:@"New Video"] ;
}

+ (UIColor *)getBaseTextColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_BASE_TEXT_COLOR default:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]] ;
}

+ (UIColor *)getBackgroundColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_BASE_BACKGROUND default:[VeamUtil getColorFromArgbString:@"77FFFFFF"]] ;
}

+ (UIColor *)getTabTextColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_TAB_TEXT_COLOR default:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]] ;
}

+ (NSString *)getTopBarTitleFont
{
    return [VeamUtil getConfigurationString:VEAM_CONFIG_TOP_BAR_TITLE_FONT default:@"GillSans"] ;
}

+ (NSInteger)getSubscriptionIndex
{
    NSString *indexString = [VeamUtil getConfigurationString:VEAM_CONFIG_SUBSCRIPTION_INDEX default:@"0"] ;
    //NSLog(@"getSubscriptionIndex : %@",indexString) ;
    return [indexString integerValue] ;
}

+ (NSString *)getSubscriptionPrice:(NSInteger)index
{
    NSString *key = [NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_PRICE_FORMAT,index] ;
    return [VeamUtil getConfigurationString:key default:@"0.99"] ;
}

+ (CGFloat)getTopBarTitleFontSize
{
    return [VeamUtil getConfigurationFloat:VEAM_CONFIG_TOP_BAR_TITLE_FONT_SIZE default:14.0] ;
}

+ (UIColor *)getTopBarTitleColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_TOP_BAR_TITLE_COLOR default:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]] ;
}

+ (UIColor *)getTopBarColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_TOP_BAR_COLOR default:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.820]] ;
}

+ (CGFloat)getTopBarHeight
{
    return [VeamUtil getConfigurationFloat:VEAM_CONFIG_TOP_BAR_HEIGHT default:45.0] ;
}

+ (UIColor *)getTableSelectionColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_TABLE_SELECTION_COLOR default:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]] ;
}

+ (NSInteger)getNumberOfTabs
{
    NSArray *templateIds = [VeamUtil getTemplateIds] ;
    return [templateIds count] ;
}

+ (UIColor *)getNewVideosTextColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_NEW_VIDEOS_TEXT_COLOR default:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]] ;
}

+ (UIColor *)getTopBarActionTextColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_TOP_BAR_ACTION_TEXT_COLOR default:[VeamUtil getNewVideosTextColor]] ;
}

+ (NSArray *)getTemplateIds
{
    NSString *templateIdsString = [VeamUtil getConfigurationString:VEAM_CONFIG_TEMPLATE_IDS default:@""] ;
    NSArray *templateIds = [templateIdsString componentsSeparatedByString:@"_"] ;
    return templateIds ;
}

+ (NSString *)getTabTitleFor:(NSString *)templateId
{
    NSString *key = [NSString stringWithFormat:VEAM_CONFIG_TAB_TITLE_FORMAT,templateId] ;
    NSString *retValue = [VeamUtil getConfigurationString:key default:@""] ;
    if([retValue isEqualToString:@"Exclusive"]){
        retValue = NSLocalizedString(@"exclusive",nil) ;
    }
    
    if([templateId isEqualToString:@"9"] && [VeamUtil isEmpty:retValue]){
        retValue = @"Shop" ;
    }
    
    return retValue ;
}

+ (NSString *)getTemplateTitleFor:(NSString *)templateId
{
    NSString *key = [NSString stringWithFormat:VEAM_CONFIG_TEMPLATE_TITLE_FORMAT,templateId] ;
    NSString *retValue = [VeamUtil getConfigurationString:key default:@""] ;
    if([retValue isEqualToString:@"Exclusive"]){
        retValue = NSLocalizedString(@"exclusive",nil) ;
    }
    
    if([templateId isEqualToString:@"9"] && [VeamUtil isEmpty:retValue]){
        retValue = @"Shop" ;
    }

    return retValue ;
}

+ (UIColor *)getSeparatorColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_SEPARATOR_COLOR default:[VeamUtil getColorFromArgbString:@"FFC8C8C8"]] ;
}

+ (UIActivityIndicatorViewStyle)getActivityIndicatorViewStyle
{
    UIActivityIndicatorViewStyle retValue = UIActivityIndicatorViewStyleGray ;
    NSString *styleString = [VeamUtil getConfigurationString:VEAM_CONFIG_ACTIVITY_INDICATOR_STYLE default:@"gray"] ;
    if([styleString isEqualToString:@"white"]){
        retValue = UIActivityIndicatorViewStyleWhite ;
    } else if([styleString isEqualToString:@"gray"]){
        retValue = UIActivityIndicatorViewStyleGray ;
    }
    return retValue ;
}

+ (NSInteger)getNumberOfGoodJobImages
{
    return [VeamUtil getConfigurationInteger:VEAM_CONFIG_NUMBER_OF_GOOD_JOB_IMAGES default:0] ;
}


+ (UIColor *)getCalendarTextColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_CALENDAR_TEXT_COLOR default:[VeamUtil getNewVideosTextColor]] ;
}

+ (UIColor *)getCalendarLineColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_CALENDAR_LINE_COLOR default:[VeamUtil getNewVideosTextColor]] ;
}

+ (UIColor *)getCalendarTodayColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_CALENDAR_TODAY_COLOR default:[VeamUtil getNewVideosTextColor]] ;
}


+ (NSString *)getCalendarDefaultWorkoutTitle
{
    return [VeamUtil getConfigurationString:VEAM_CONFIG_CALENDAR_DEFAULT_WORKOUT_TITLE default:@"Recommendation"] ;
}

+ (NSString *)getSkipInitial
{
    return [VeamUtil getConfigurationString:VEAM_CONFIG_SKIP_INITIAL default:@"0"] ;
}



+ (NSString *)getTrackingId
{
    NSString *trackingId = @"" ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        trackingId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return trackingId ;
}

+ (NSString *)makeScreenName:(NSString *)viewName
{
    return [[AppDelegate sharedInstance] makeScreenName:viewName] ;
}

+ (UIColor *)getColorFromArgbString:(NSString *)argbString
{
    unsigned int argb[4] ;
    if([argbString length] == 8){
        for (int i = 0; i < 4; i++) {
            NSString *component = [argbString substringWithRange:NSMakeRange(i * 2, 2)] ;
            NSScanner *scanner = [NSScanner scannerWithString:component] ;
            [scanner scanHexInt:&argb[i]] ;
        }
    } else {
       //NSLog(@"invalid color %@",argbString) ;
    }
    //NSLog(@"make color : %f %f %f %f",((CGFloat)argb[1])/255,((CGFloat)argb[2])/255,((CGFloat)argb[3])/255,((CGFloat)argb[0])/255) ;
    return [UIColor colorWithRed:((CGFloat)argb[1])/255 green:((CGFloat)argb[2])/255 blue:((CGFloat)argb[3])/255 alpha:((CGFloat)argb[0])/255] ;
}

+ (NSString *)getArgbStringFromColor:(UIColor *)color
{
    CGFloat red ;
    CGFloat green ;
    CGFloat blue ;
    CGFloat alpha ;
    [color getRed:&red green:&green blue:&blue alpha:&alpha] ;
    
    NSString *argbString = [NSString stringWithFormat:@"%02X%02X%02X%02X",(int)(alpha*255),(int)(red*255),(int)(green*255),(int)(blue*255)] ;
    return argbString ;
}

+ (void)registerTapAction:(UIView *)view target:(id)target selector:(SEL)selector
{
    view.userInteractionEnabled = YES ;
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector] ;
    singleTapGesture.numberOfTouchesRequired = 1 ;
    [view addGestureRecognizer:singleTapGesture] ;
}

+ (void)showCameraView:(NSString *)forumId
{
    [[AppDelegate sharedInstance] showCameraView:forumId] ;
}

+ (void)showSettingsView
{
    [[AppDelegate sharedInstance] showSettingsView] ;
}

+ (void)showTabBarController:(NSInteger)selectedTab
{
    [[AppDelegate sharedInstance] showTabBarController:selectedTab] ;
}

+ (void)setTabBarControllerIndex:(NSInteger)index
{
    [[AppDelegate sharedInstance] setTabBarControllerIndex:index] ;
}

+ (NSInteger)getNumberOfForums
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfForums] ;
    }
    return retValue ;
}

+ (Forum *)getForumAt:(NSInteger)index
{
    Forum *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getForumAt:index] ;
    }
    return retValue ;
}

+ (NSInteger)getNumberOfYoutubeCategories
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfYoutubeCategories] ;
    }
    return retValue ;
}

+ (BOOL)isAllYoutubeCategoryEmbed
{
    BOOL retValue = YES ;
    int count = [VeamUtil getNumberOfYoutubeCategories] ;
    for(int index = 0 ; index < count ; index++){
        YoutubeCategory *youtubeCategory = [VeamUtil getYoutubeCategoryAt:index] ;
        //NSLog(@"check %@ %@",youtubeCategory.name,youtubeCategory.embed) ;
        if(![youtubeCategory.embed isEqualToString:@"1"]){
            retValue = NO ;
        }
    }
    
    return retValue ;
}

+ (YoutubeCategory *)getYoutubeCategoryAt:(NSInteger)index
{
    YoutubeCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getYoutubeCategoryAt:index] ;
    }
    return retValue ;
}

+ (NSArray *)getYoutubeSubCategories:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getYoutubeSubCategories:categoryId] ;
    }
    return retValue ;
}

+ (Youtube *)getYoutubeForId:(NSString *)youtubeId
{
    Youtube *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getYoutubeForId:youtubeId] ;
    }
    return retValue ;
}


+ (NSInteger)getNumberOfMixedCategories
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfMixedCategories] ;
    }
    return retValue ;
}

+ (MixedCategory *)getMixedCategoryAt:(NSInteger)index
{
    MixedCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getMixedCategoryAt:index] ;
    }
    return retValue ;
}

+ (NSArray *)getMixedSubCategories:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getMixedSubCategories:categoryId] ;
    }
    return retValue ;
}

+ (Mixed *)getMixedForId:(NSString *)mixedId
{
    Mixed *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getMixedForId:mixedId] ;
    }
    return retValue ;
}


+ (NSInteger)getNumberOfVideoCategories
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfVideoCategories] ;
    }
    return retValue ;
}

+ (Video *)getVideoForId:(NSString *)videoId
{
    Video *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getVideoForId:videoId] ;
    }
    return retValue ;
}

+ (VideoCategory *)getVideoCategoryAt:(NSInteger)index
{
    VideoCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getVideoCategoryAt:index] ;
    }
    return retValue ;
}

+ (VideoCategory *)getVideoCategoryForId:(NSString *)videoCategoryId
{
    VideoCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getVideoCategoryForId:videoCategoryId] ;
    }
    return retValue ;
}



+ (PdfCategory *)getPdfCategoryAt:(NSInteger)index
{
    PdfCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getPdfCategoryAt:index] ;
    }
    return retValue ;
}

+ (PdfCategory *)getPdfCategoryForId:(NSString *)pdfCategoryId
{
    PdfCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getPdfCategoryForId:pdfCategoryId] ;
    }
    return retValue ;
}





+ (Pdf *)getPdfForId:(NSString *)pdfId
{
    Pdf *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getPdfForId:pdfId] ;
    }
    return retValue ;
}




+ (NSInteger)getNumberOfSellItemCategories
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfSellItemCategories] ;
    }
    return retValue ;
}

+ (SellItemCategory *)getSellItemCategoryAt:(NSInteger)index
{
    SellItemCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellItemCategoryAt:index] ;
    }
    return retValue ;
}

+ (SellItemCategory *)getSellItemCategoryForId:(NSString *)sellItemCategoryId
{
    SellItemCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellItemCategoryForId:sellItemCategoryId] ;
    }
    return retValue ;
}




+ (NSInteger)getNumberOfSellSectionCategories
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfSellSectionCategories] ;
    }
    return retValue ;
}

+ (SellSectionCategory *)getSellSectionCategoryAt:(NSInteger)index
{
    SellSectionCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellSectionCategoryAt:index] ;
    }
    return retValue ;
}

+ (SellSectionCategory *)getSellSectionCategoryForId:(NSString *)sellSectionCategoryId
{
    SellSectionCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellSectionCategoryForId:sellSectionCategoryId] ;
    }
    return retValue ;
}




+ (NSArray *)getVideoSubCategories:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getVideoSubCategories:categoryId] ;
    }
    return retValue ;
}


+ (NSInteger)getNumberOfAudioCategories
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfAudioCategories] ;
    }
    return retValue ;
}

+ (Audio *)getAudioForId:(NSString *)audioId
{
    Audio *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getAudioForId:audioId] ;
    }
    return retValue ;
}

+ (AudioCategory *)getAudioCategoryAt:(NSInteger)index
{
    AudioCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getAudioCategoryAt:index] ;
    }
    return retValue ;
}

+ (AudioCategory *)getAudioCategoryForId:(NSString *)audioCategoryId
{
    AudioCategory *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getAudioCategoryForId:audioCategoryId] ;
    }
    return retValue ;
}


+ (NSArray *)getAudioSubCategories:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getAudioSubCategories:categoryId] ;
    }
    return retValue ;
}







+ (NSInteger)getNumberOfAnswers
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfAnswers] ;
    }
    return retValue ;
}

+ (Question *)getAnswerAt:(NSInteger)index
{
    Question *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getAnswerAt:index] ;
    }
    return retValue ;
}

+ (Questions *)getAnswers
{
    Questions *retValue ;
    NSMutableArray *workAnswers = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        workAnswers = [contents getAnswers] ;
    }
    
    if(workAnswers != nil){
        retValue = [[Questions alloc] initWithAnswers:workAnswers] ;
    }
    
    return retValue ;
}







+ (NSArray *)getRecipeCategories
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getRecipeCategories] ;
    }
    return retValue ;
}

+ (NSArray *)getRecipes:(NSString *)recipeCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getRecipes:recipeCategoryId] ;
    }
    return retValue ;
}

+ (Recipe *)getRecipeForId:(NSString *)recipeId
{
    Recipe *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getRecipeForId:recipeId] ;
    }
    return retValue ;
}

+ (NSInteger)getnumberOfWebs:(NSString *)categoryId
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getNumberOfWebs:categoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getWebs:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getWebs:categoryId] ;
    }
    return retValue ;
}




+ (UIImage *)getCachedImage:(NSString *)urlString downloadIfNot:(BOOL)downloadIfNot
{
    //NSLog(@"getCachedImage url=%@",urlString) ;
    UIImage *retImage = nil ;
    NSString *fileId = [VeamUtil sha1:urlString] ;
    NSString *fileName = [NSString stringWithFormat:@"cache_%@",fileId] ;
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    if([fileManager fileExistsAtPath:filePath]){
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil] ;
        NSDate *creationDate = [attributes valueForKey:NSFileModificationDate] ;
        NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-172800] ; // 48hours ago
        
        NSComparisonResult result = [currentDate compare:creationDate] ;
        if(result == NSOrderedAscending){
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath] ;
            retImage = [[UIImage alloc] initWithData:data] ;
            //NSLog(@"not expired") ;
        } else {
            //NSLog(@"expired") ;
        }
    } else {
        //NSLog(@"not exists") ;
    }
    
    if((retImage == nil) && downloadIfNot){
        NSURL *url = [NSURL URLWithString:[VeamUtil getSecureUrl:urlString]] ;
        NSData *data = [NSData dataWithContentsOfURL:url] ;
        retImage = [[UIImage alloc] initWithData:data] ;
        //NSLog(@"image size %fx%f",retImage.size.width,retImage.size.height) ;
        if((retImage != nil) && (retImage.size.width > 0)){
            [data writeToFile:filePath atomically:YES] ;
        }
    }
    
    return retImage ;
}

+ (void)storeCachedImage:(NSString *)urlString data:(NSData *)data
{
    NSString *fileId = [VeamUtil sha1:urlString] ;
    NSString *fileName = [NSString stringWithFormat:@"cache_%@",fileId] ;
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    [data writeToFile:filePath atomically:YES] ;
}

+ (BOOL)fileExistsAtCachesDirectory:(NSString *)fileName
{
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    return [fileManager fileExistsAtPath:filePath] ;
}

+ (BOOL)fileExists:(NSString *)fileName
{
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    return [fileManager fileExistsAtPath:filePath] ;
}

+ (NSInteger)fileSizeOf:(NSString *)fileName
{
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    return [fileAttributes fileSize] ;
}

+ (NSInteger)fileSizeAtCachesDirectory:(NSString *)fileName
{
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    return [fileAttributes fileSize] ;
}


+ (UIImage *)getUpdatedImage:(NSString *)urlString
{
    //NSLog(@"getUpdatedImage url=%@",urlString) ;
    UIImage *retImage = nil ;
    NSString *fileId = [VeamUtil sha1:urlString] ;
    NSString *fileName = [NSString stringWithFormat:@"updated_%@",fileId] ;
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    if([fileManager fileExistsAtPath:filePath]){
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath] ;
        retImage = [[UIImage alloc] initWithData:data] ;
    }
    
    return retImage ;
}

+ (void)storeUpdatedImage:(NSString *)urlString data:(NSData *)data
{
    NSString *fileId = [VeamUtil sha1:urlString] ;
    NSString *fileName = [NSString stringWithFormat:@"updated_%@",fileId] ;
    NSString *filePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    [data writeToFile:filePath atomically:YES] ;
}


+ (NSString *)sha1:(NSString*)input
{
    /*
     const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
     NSData *data = [NSData dataWithBytes:cstr length:input.length];
     */
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    
    //NSLog(@"sha1 output=%@ input=%@ input.length=%d data.length=%d",output,input,input.length,data.length) ;
    
    return output;
}

+ (CGFloat)getTabBarHeight
{
    return [[AppDelegate sharedInstance] getTabBarHeight] ;
}

+ (BOOL)isConnected
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) ;
}

+ (void)dispNotConnectedError
{
    UIAlertView *alert = [
                          [UIAlertView alloc]
                          initWithTitle : NSLocalizedString(@"NetworkError",@"")
                          message : NSLocalizedString(@"NotConnected",@"")
                          delegate : nil
                          cancelButtonTitle : @"OK"
                          otherButtonTitles : nil
                          ];
    [alert show];
}

+ (NSArray *)getYoutubesForCategory:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getYoutubesForCategory:categoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getYoutubesForSubCategory:(NSString *)subCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getYoutubesForSubCategory:subCategoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getVideosForCategory:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getVideosForCategory:categoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getVideosForSubCategory:(NSString *)subCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getVideosForSubCategory:subCategoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getAudiosForCategory:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getAudiosForCategory:categoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getAudiosForSubCategory:(NSString *)subCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getAudiosForSubCategory:subCategoryId] ;
    }
    return retValue ;
}





+ (NSArray *)getMixedsForCategory:(NSString *)categoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getMixedsForCategory:categoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getMixedsForSubCategory:(NSString *)subCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getMixedsForSubCategory:subCategoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getMixedsForSubscription:(BOOL)includeYearObject
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getMixedsForSubscription:includeYearObject] ;
    }
    return retValue ;
}






+ (NSString *)getDurationString:(NSString *)durationInSec
{
    NSInteger duration = [durationInSec integerValue] ;
    NSString *durationString = [NSString stringWithFormat:@"%02d:%02d",duration/60,duration%60] ;
    return durationString ;
}

+ (NSString *)getYoutubeImageUrl:(NSString *)youtubeVideoId
{
    // @"http://img.youtube.com/vi/%@/hqdefault.jpg",youtubeId]
    
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    NSString *format = [contents getValueForKey:@"youtube_image_url_format"] ;
    if([VeamUtil isEmpty:format]){
        format = @"https://img.youtube.com/vi/%@/hqdefault.jpg" ;
    }
    
    NSString *urlString = [NSString stringWithFormat:format,youtubeVideoId] ;
    return urlString ;
}

+ (void)dispMessage:(NSString *)message title:(NSString *)title
{
    UIAlertView *alert = [
                          [UIAlertView alloc]
                          initWithTitle : title
                          message : message
                          delegate : nil
                          cancelButtonTitle : @"OK"
                          otherButtonTitles : nil
                          ];
    [alert show];
}

+ (void)dispError:(NSString *)message
{
    UIAlertView *alert = [
                          [UIAlertView alloc]
                          initWithTitle : NSLocalizedString(@"Error", @"")
                          message : message
                          delegate : nil
                          cancelButtonTitle : @"OK"
                          otherButtonTitles : nil
                          ];
    [alert show];
}

+ (NSString *)urlEncode:(NSString *)value
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[value UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


+ (void)setVeamId:(NSString *)veamId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:veamId forKey:USERDEFAULT_KEY_VEAM_ID] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getVeamId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *veamId = [userDefaults objectForKey:USERDEFAULT_KEY_VEAM_ID] ;
    return veamId ;
}
+ (NSString *)getUid
{
    NSString *uid ;
    uid = [VeamUtil getVeamId] ;
    if((uid == nil) || [uid isEqualToString:@""]){
        CFUUIDRef uuidObj = CFUUIDCreate(nil);
        // Get the string representation of the UUID
        NSString *newUUID = (__bridge NSString*)CFUUIDCreateString(nil, uuidObj);
        //NSLog(@"newUUID=%@",newUUID) ;
        uid = [VeamUtil sha1:newUUID] ;
        [VeamUtil setVeamId:uid] ;
    }
    
    //NSLog(@"sha1=%@",uid) ;
    return uid ;
}


+ (void)setSocialUserId:(NSInteger)socialUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setInteger:socialUserId forKey:USERDEFAULT_KEY_SOCIAL_USER_ID] ;
    [userDefaults synchronize] ;
}

+ (NSInteger)getSocialUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSInteger socialUserId = [userDefaults integerForKey:USERDEFAULT_KEY_SOCIAL_USER_ID] ;
    return socialUserId ;
}

+ (void)setPicturePosted:(BOOL)picturePosted
{
    [[AppDelegate sharedInstance] setPicturePosted:picturePosted] ;
}

+ (BOOL)getPicturePosted
{
    return [[AppDelegate sharedInstance] picturePosted] ;
}

+ (void)setRewardString:(NSString *)rewardString
{
    [[AppDelegate sharedInstance] setRewardString:rewardString] ;
}

+ (NSString *)getRewardString
{
    return [[AppDelegate sharedInstance] rewardString] ;
}

+ (void)setDescriptionPosted:(BOOL)descriptionPosted
{
    [[AppDelegate sharedInstance] setDescriptionPosted:descriptionPosted] ;
}

+ (BOOL)getDescriptionPosted
{
    return [[AppDelegate sharedInstance] descriptionPosted] ;
}




+ (void)setSocialUserKind:(NSInteger)socialUserKind
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setInteger:socialUserKind forKey:USERDEFAULT_KEY_SOCIAL_USER_KIND] ;
    [userDefaults synchronize] ;
}

+ (NSInteger)getSocialUserKind
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSInteger socialUserKind = [userDefaults integerForKey:USERDEFAULT_KEY_SOCIAL_USER_KIND] ;
    return socialUserKind ;
}

+ (void)logoutFromSocial
{
    [VeamUtil setSocialUserId:0] ;
    [VeamUtil setSocialUserKind:0] ;
}

+ (BOOL)isLoggedIn
{
    return ([VeamUtil getSocialUserId] > 0) ;
}

+ (void)openTwitterSession
{
    //[[AppDelegate sharedInstance] openTwitterSession] ;
    [[AppDelegate sharedInstance] openTwitter] ;
}

+ (void)openFacebookSession
{
    [[AppDelegate sharedInstance] openFacebookSession] ;
}

+ (void)openEmailSession
{
    [[AppDelegate sharedInstance] openEmailSession] ;
}


+ (void)loginWithEmail:(NSString *)emailUserId name:(NSString *)name secret:(NSString *)secret
{
    
    //NSLog(@"loginWithEmail %@ %@ %@",emailUserId,name,secret) ;
    NSURL *url = [VeamUtil getApiUrl:@"socialuser/login"] ;
    
    NSURLResponse *response = nil ;
    NSError *error = nil;
    
    NSString *encodedName = [VeamUtil urlEncode:name] ;
    NSString *uid = [VeamUtil getUid] ;
    
    NSString *tokenString = [VeamUtil getDeviceToken] ;
    NSString *tokenEnvString = [VeamUtil getDeviceTokenEnv] ;
    if([VeamUtil isEmpty:tokenString]){
        tokenString = @"" ;
        tokenEnvString = @"" ;
    }
    
    NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%@",uid,emailUserId]] ;
    NSString *params ;
    params = [NSString stringWithFormat:@"u=%@&e=%@&n=%@&ud=%@&ude=%@&o=i&ec=%@&s=%@",uid,emailUserId,encodedName,tokenString,tokenEnvString,secret,signature] ;
    
    //NSLog(@"params=%@",params) ;
    NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // error
    NSString *error_str = [error localizedDescription];
    if (0<[error_str length]) {
        UIAlertView *alert = [
                              [UIAlertView alloc]
                              initWithTitle : @"Login Error"
                              message : error_str
                              delegate : nil
                              cancelButtonTitle : @"OK"
                              otherButtonTitles : nil
                              ];
        [alert show];
        return ;
    }
    
    
    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    //NSLog(@"results=%@",resultString) ;
    
    NSInteger socialUserId = 0 ;
    NSString *socialUserIdString = nil ;
    NSArray *results = [resultString componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    if([results count] >= 2){
        if([[results objectAtIndex:0] compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
            socialUserIdString = [results objectAtIndex:1] ;
            socialUserId = [socialUserIdString integerValue] ;
        }
    }
    
    if(socialUserId > 0){
        [VeamUtil setSocialUserId:socialUserId] ;
        [VeamUtil setSocialUserKind:SOCIAL_USER_KIND_EMAIL] ;
        [VeamUtil setEmailUserName:name] ;
    } else {
        [VeamUtil dispError:NSLocalizedString(@"login_failed",nil)] ;
    }
}



+ (void)loginWithFacebook:(NSString *)facebookId name:(NSString *)name
{
    NSURL *url = [VeamUtil getApiUrl:@"socialuser/login"] ;
    
    NSURLResponse *response = nil ;
    NSError *error = nil;
    
    NSString *encodedName = [VeamUtil urlEncode:name] ;
    NSString *uid = [VeamUtil getUid] ;
    
    NSString *tokenString = [VeamUtil getDeviceToken] ;
    NSString *tokenEnvString = [VeamUtil getDeviceTokenEnv] ;
    if([VeamUtil isEmpty:tokenString]){
        tokenString = @"" ;
        tokenEnvString = @"" ;
    }

    NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%@",uid,facebookId]] ;
    NSString *params ;
    params = [NSString stringWithFormat:@"u=%@&f=%@&n=%@&ud=%@&ude=%@&o=i&s=%@",uid,facebookId,encodedName,tokenString,tokenEnvString,signature] ;
    
    //NSLog(@"params=%@",params) ;
    NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // error
    NSString *error_str = [error localizedDescription];
    if (0<[error_str length]) {
        UIAlertView *alert = [
                              [UIAlertView alloc]
                              initWithTitle : @"Login Error"
                              message : error_str
                              delegate : nil
                              cancelButtonTitle : @"OK"
                              otherButtonTitles : nil
                              ];
        [alert show];
        return ;
    }
    
    
    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    //NSLog(@"results=%@",resultString) ;
    
    NSInteger socialUserId = 0 ;
    NSString *socialUserIdString = nil ;
    NSArray *results = [resultString componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    if([results count] >= 2){
        if([[results objectAtIndex:0] compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
            socialUserIdString = [results objectAtIndex:1] ;
            socialUserId = [socialUserIdString integerValue] ;
        }
    }
    
    if(socialUserId > 0){
        [VeamUtil setSocialUserId:socialUserId] ;
        [VeamUtil setSocialUserKind:SOCIAL_USER_KIND_FACEBOOK] ;
        [VeamUtil setFacebookUserName:name] ;
    } else {
        [VeamUtil dispError:NSLocalizedString(@"login_failed",nil)] ;
    }
}

+ (void)login
{
    [[AppDelegate sharedInstance] showLoginSelector] ;
}

+ (void)loginWithTwitter:(NSString *)twitterId name:(NSString *)name user:(NSString *)user imageUrl:(NSString *)imageUrl
{
    NSURL *url = [VeamUtil getApiUrl:@"socialuser/login"] ;
    
    NSURLResponse *response = nil ;
    NSError *error = nil;
    
    /*
     $userId = $request->getParameter('u') ;
     $appId = $request->getParameter('a') ;
     $name = $request->getParameter('n') ;
     $twitterId = $request->getParameter('t') ;
     $twitterUser = $request->getParameter('tu') ;
     $facebookId = $request->getParameter('f') ;
     $signiture = $request->getParameter('s') ;
     $imageUrl = $request->getParameter('i') ;
     */
    
    
    NSString *encodedName = [VeamUtil urlEncode:name] ;
    NSString *encodedUser = [VeamUtil urlEncode:user] ;
    NSString *encodedImageUrl = [VeamUtil urlEncode:imageUrl] ;
    NSString *uid = [VeamUtil getUid] ;
    
    NSString *tokenString = [VeamUtil getDeviceToken] ;
    NSString *tokenEnvString = [VeamUtil getDeviceTokenEnv] ;
    if([VeamUtil isEmpty:tokenString]){
        tokenString = @"" ;
        tokenEnvString = @"" ;
    }
    
    NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%@",uid,twitterId]] ;
    NSString *params ;
    params = [NSString stringWithFormat:@"u=%@&t=%@&n=%@&tu=%@&i=%@&ud=%@&ude=%@&o=i&s=%@",uid,twitterId,encodedName,encodedUser,encodedImageUrl,tokenString,tokenEnvString,signature] ;
    
    //NSLog(@"params=%@",params) ;
    NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // error
    NSString *error_str = [error localizedDescription];
    if (0<[error_str length]) {
        UIAlertView *alert = [
                              [UIAlertView alloc]
                              initWithTitle : @"Login Error"
                              message : error_str
                              delegate : nil
                              cancelButtonTitle : @"OK"
                              otherButtonTitles : nil
                              ];
        [alert show];
        return ;
    }
    
    
    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    //NSLog(@"results=%@",resultString) ;
    
    NSInteger socialUserId = 0 ;
    NSString *socialUserIdString = nil ;
    NSArray *results = [resultString componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    if([results count] >= 2){
        if([[results objectAtIndex:0] compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
            socialUserIdString = [results objectAtIndex:1] ;
            socialUserId = [socialUserIdString integerValue] ;
        }
    }
    
    if(socialUserId > 0){
        [VeamUtil setSocialUserId:socialUserId] ;
        [VeamUtil setSocialUserKind:SOCIAL_USER_KIND_TWITTER] ;
        [VeamUtil setTwitterUserName:name] ;
    } else {
        [VeamUtil dispError:NSLocalizedString(@"login_failed",nil)] ;
    }
}


+ (void)setTwitterUserName:(NSString *)twitterUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:twitterUserName forKey:USERDEFAULT_KEY_TWITTER_USER_NAME] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getTwitterUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *twitterUserName = [userDefaults objectForKey:USERDEFAULT_KEY_TWITTER_USER_NAME] ;
    return twitterUserName ;
}

+ (void)setFacebookUserName:(NSString *)facebookUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:facebookUserName forKey:USERDEFAULT_KEY_FACEBOOK_USER_NAME] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getFacebookUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *facebookUserName = [userDefaults objectForKey:USERDEFAULT_KEY_FACEBOOK_USER_NAME] ;
    return facebookUserName ;
}

+ (void)setEmailUserName:(NSString *)emailUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:emailUserName forKey:USERDEFAULT_KEY_EMAIL_USER_NAME] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getEmailUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *facebookUserName = [userDefaults objectForKey:USERDEFAULT_KEY_EMAIL_USER_NAME] ;
    return facebookUserName ;
}

+ (NSString *)getTimeDescription:(NSString *)unixTimeString
{
    NSTimeInterval actionTime = [unixTimeString doubleValue] ;
    NSDate *date = [NSDate date] ;
    NSTimeInterval diff = date.timeIntervalSince1970 - actionTime ;
    //NSLog(@"actionTime %f sec ago",diff) ;
    NSString *timeString ;
    NSInteger value ;
    if(diff < 60){
        if(diff < 0){
            diff = 0 ;
        }
        value = (int)diff ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"second_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"seconds_ago",nil)] ;
        }
    } else if(diff < 3600){
        value = (int)(diff/60) ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"minute_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"minutes_ago",nil)] ;
        }
    } else if(diff < 86400){
        value = (int)(diff/3600) ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"hour_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"hours_ago",nil)] ;
        }
    } else {
        value = (int)(diff/86400) ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"day_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"days_ago",nil)] ;
        }
    }
    return timeString ;
}

+ (NSString *)getSocialUserName
{
    NSString *userName = nil ;
    NSInteger kind = [VeamUtil getSocialUserKind] ;
    if(kind == SOCIAL_USER_KIND_FACEBOOK){
        userName = [VeamUtil getFacebookUserName] ;
    } else if(kind == SOCIAL_USER_KIND_TWITTER){
        userName = [VeamUtil getTwitterUserName] ;
    } else if(kind == SOCIAL_USER_KIND_EMAIL){
        userName = [VeamUtil getEmailUserName] ;
    }
    return userName ;
}


+ (BOOL)isPurchasing
{
    return [[AppDelegate sharedInstance] isPurchasing] ;
}

+ (void)setIsPurchasing:(BOOL)isPurchasing
{
    [[AppDelegate sharedInstance] setIsPurchasing:isPurchasing] ;
}

+ (NSString *)getContentsUpdateNotificationId
{
    return [NSString stringWithFormat:@"VEAM%@_CONTENTS_UPDATED",[VeamUtil getAppId]] ;
}

+ (void)postContentsUpdateNotification
{
    //NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"HOGE" forKey:@"KEY"] ;
    NSDictionary *userInfo = nil ;
    NSNotification *notification = [NSNotification notificationWithName:[VeamUtil getContentsUpdateNotificationId] object:self userInfo:userInfo] ;
    [[NSNotificationCenter defaultCenter] postNotification:notification] ;
}

+ (UIImage *)getSquareImage:(UIImage *)image
{
    float w = image.size.width;
    float h = image.size.height;
    CGRect rect;
    
    if (h <= w) {
        //横長の場合
        float x = w / 2 - h / 2;
        float y = 0;
        rect = CGRectMake(x, y, h, h) ;
    } else {
        //縦長の場合
        float x = 0;
        float y = h / 2 - w / 2;
        rect = CGRectMake(x, y, w, w) ;
    }
    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, rect) ;
    UIImage *retImage = [UIImage imageWithCGImage:cgImage] ;
    CGImageRelease(cgImage) ;
    return retImage ;
}

+ (UIImage *)imageNamed:(NSString *)imageName
{
    //NSLog(@"VeamUtil::imageNamed imageName=%@",imageName) ;
    UIImage *retValue = nil ;
    NSString *url = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        //NSLog(@"contents != nil") ;
        AlternativeImage *alternativeImage = [contents getAlternativeImageForFileName:imageName] ;
        if(alternativeImage != nil){
            //NSLog(@"alternativeImage != nil") ;
            if(![VeamUtil isStoredAlternativeImage:alternativeImage.alternativeImageId]){
                //NSLog(@"alternative found") ;
                url = [alternativeImage url] ;
                if(![VeamUtil isEmpty:url]){
                    //NSLog(@"url=%@",url) ;
                    retValue = [VeamUtil getUpdatedImage:url] ;
                }
            }
        }
    }
    
    if(retValue == nil){
        //NSLog(@"load original") ;
        retValue = [UIImage imageNamed:imageName] ;
    }

    return retValue ;
}

+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height backgroundColor:(UIColor *)backgroundColor
{
    UIImage *resizedImage ;  // リサイズ後UIImage

    CGFloat xOffset = 0 ;
    CGFloat yOffset = 0 ;
    
    CGFloat expectedWidth = (image.size.width/image.size.height)*height ;
    
    CGFloat drawWidth = width ;
    CGFloat drawHeight = height ;
    
    if(expectedWidth < width){
        xOffset = (width - expectedWidth) / 2 ;
        drawWidth = expectedWidth ;
    } else if(width < expectedWidth){
        CGFloat expectedHeight = (image.size.height/image.size.width)*width ;
        yOffset = (height - expectedHeight) / 2 ;
        drawHeight = expectedHeight ;
    }
    
    //NSLog(@"resize width=%f height=%f xOffset:%f yOffset:%f drawWidth=%f drawHeight=%f",width,height,xOffset,yOffset,drawWidth,drawHeight) ;
    
    UIGraphicsBeginImageContext(CGSizeMake(floor(width), floor(height))) ;
    //[[UIColor blackColor] setFill] ;
    [backgroundColor setFill] ;
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)] fill];

    [image drawInRect:CGRectMake(xOffset, yOffset, drawWidth, drawHeight)] ;
    resizedImage = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    
    return resizedImage ;
}



+ (UIViewController *)createViewControllerFor:(NSString *)templateId
{
    //NSLog(@"createViewControllerFor %@",templateId) ;
    UINavigationController *navigationController = nil ;
    NSString *tabTitle = [VeamUtil getTabTitleFor:templateId] ;
    NSString *templateTitle = [VeamUtil getTemplateTitleFor:templateId] ;
    UIImage *tabImage = [VeamUtil imageNamed:[NSString stringWithFormat:@"t%@_tab_off.png",templateId]] ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;

    if([templateId isEqualToString:VEAM_TEMPLATE_ID_YOUTUBE_LIST]){
        TemplateYoutube *templateYoutube = [contents getTemplateYoutube] ;
        if([templateYoutube.embedFlag isEqualToString:@"1"]){
            WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil] ;
            [webViewController setTitleName:templateYoutube.title] ;
            [webViewController setTitle:templateYoutube.title] ;
            [webViewController setUrl:templateYoutube.embedUrl] ;
            [webViewController setShowBackButton:NO] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        } else {
            YoutubeCategoryViewController *youtubeCategoryViewController = [[YoutubeCategoryViewController alloc] initWithNibName:@"YoutubeCategoryViewController" bundle:nil] ;
            [youtubeCategoryViewController setTitleName:templateYoutube.title] ;
            [youtubeCategoryViewController setTitle:templateYoutube.title] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:youtubeCategoryViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        }
    } else if([templateId isEqualToString:VEAM_TEMPLATE_ID_FORUM]){
        ForumViewController *forumViewController = [[ForumViewController alloc] initWithNibName:@"ForumViewController" bundle:nil] ;
        [forumViewController setTitleName:templateTitle] ;
        //[forumViewController setTitle:@"Forum"] ;
        navigationController = [[UINavigationController alloc] initWithRootViewController:forumViewController];
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
    } else if([templateId isEqualToString:VEAM_TEMPLATE_ID_MIXED]){
        MixedCategoryViewController *mixedCategoryViewController = [[MixedCategoryViewController alloc] initWithNibName:@"MixedCategoryViewController" bundle:nil] ;
        [mixedCategoryViewController setTitleName:templateTitle] ;
        navigationController = [[UINavigationController alloc] initWithRootViewController:mixedCategoryViewController];
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
    } else if([templateId isEqualToString:VEAM_TEMPLATE_ID_RECIPE]){
        RecipeCategoryViewController *recipeCategoryViewController = [[RecipeCategoryViewController alloc] initWithNibName:@"RecipeCategoryViewController" bundle:nil] ;
        [recipeCategoryViewController setTitleName:templateTitle] ;
        navigationController = [[UINavigationController alloc] initWithRootViewController:recipeCategoryViewController];
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
    } else if([templateId isEqualToString:VEAM_TEMPLATE_ID_WEB_LIST]){
        WebListViewController *webListViewController = [[WebListViewController alloc] initWithNibName:@"WebListViewController" bundle:nil] ;
        [webListViewController setCategory:@"0"] ;
        [webListViewController setTitleName:templateTitle] ;
        navigationController = [[UINavigationController alloc] initWithRootViewController:webListViewController] ;
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
    } else if([templateId isEqualToString:VEAM_TEMPLATE_ID_WEB_LIST_CAT1]){
        WebListViewController *webListViewController = [[WebListViewController alloc] initWithNibName:@"WebListViewController" bundle:nil] ;
        [webListViewController setCategory:@"1"] ;
        [webListViewController setTitleName:templateTitle] ;
        navigationController = [[UINavigationController alloc] initWithRootViewController:webListViewController] ;
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
    } else if([templateId isEqualToString:VEAM_TEMPLATE_ID_SUBSCRIPTION]){
        TemplateSubscription *templateSubscription = [contents getTemplateSubscription] ;
        NSString *layout = templateSubscription.layout ;
        NSString *kind = templateSubscription.kind ;
        //NSLog(@"templateSubscription kind %@",kind) ;
        if([kind isEqualToString:VEAM_SUBSCRIPTION_KIND_VIDEOS]){
            VideoCategoryViewController *videoCategoryViewController = [[VideoCategoryViewController alloc] initWithNibName:@"VideoCategoryViewController" bundle:nil] ;
            [videoCategoryViewController setTitleName:templateSubscription.title] ;
            [videoCategoryViewController setTitle:templateSubscription.title] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:videoCategoryViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        } else if([kind isEqualToString:VEAM_SUBSCRIPTION_KIND_QA]){
            QAViewController *qaViewController = [[QAViewController alloc] initWithNibName:@"QAViewController" bundle:nil] ;
            [qaViewController setTitleName:templateSubscription.title] ;
            [qaViewController setTitle:templateSubscription.title] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:qaViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        } else if([kind isEqualToString:VEAM_SUBSCRIPTION_KIND_CALENDAR]){
            CalendarMenuViewController *calendarMenuViewController = [[CalendarMenuViewController alloc] initWithNibName:@"CalendarMenuViewController" bundle:nil] ;
            [calendarMenuViewController setTitleName:templateSubscription.title] ;
            [calendarMenuViewController setTitle:templateSubscription.title] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:calendarMenuViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        } else if([kind isEqualToString:VEAM_SUBSCRIPTION_KIND_MIXED_GRID]){
            MixedGridViewController *mixedGridViewController = [[MixedGridViewController alloc] initWithNibName:@"MixedGridViewController" bundle:nil] ;
            [mixedGridViewController setTitleName:[VeamUtil getTranslatedString:templateSubscription.title]] ;
            [mixedGridViewController setTitle:[VeamUtil getTranslatedString:templateSubscription.title]] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:mixedGridViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        } else if([kind isEqualToString:VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS]){
           //NSLog(@"VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS") ;
            SellItemCategoryViewController *videoCategoryViewController = [[SellItemCategoryViewController alloc] init] ;
            [videoCategoryViewController setTitleName:[VeamUtil getTranslatedString:templateSubscription.title]] ;
            [videoCategoryViewController setTitle:[VeamUtil getTranslatedString:templateSubscription.title]] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:videoCategoryViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        } else if([kind isEqualToString:VEAM_SUBSCRIPTION_KIND_SELL_SECTION]){
            //NSLog(@"VEAM_SUBSCRIPTION_KIND_SELL_SECTION") ;
            SellSectionCategoryViewController *videoCategoryViewController = [[SellSectionCategoryViewController alloc] init] ;
            [videoCategoryViewController setTitleName:[VeamUtil getTranslatedString:templateSubscription.title]] ;
            [videoCategoryViewController setTitle:[VeamUtil getTranslatedString:templateSubscription.title]] ;
            navigationController = [[UINavigationController alloc] initWithRootViewController:videoCategoryViewController] ;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:0] ;
        }
    }
    return navigationController ;
}

+ (NSString *)getTranslatedString:(NSString *)string
{
    NSString *retValue = string ;
    if(![VeamUtil isEmpty:retValue]){
        if([string isEqualToString:@"Exclusive"]){
            retValue = NSLocalizedString(@"exclusive",nil) ;
        } else if([string isEqualToString:@"Hot Topics"]){
            retValue = NSLocalizedString(@"forum_name_hot_topics",nil) ;
        }
    }
    return retValue ;
}

+ (NSString *)getNameForMonth:(NSInteger)month
{
    NSString *retValue ;
    switch (month) {
        case 1:
            retValue = @"January" ;
            break;
        case 2:
            retValue = @"February" ;
            break;
        case 3:
            retValue = @"March" ;
            break;
        case 4:
            retValue = @"April" ;
            break;
        case 5:
            retValue = @"May" ;
            break;
        case 6:
            retValue = @"June" ;
            break;
        case 7:
            retValue = @"July" ;
            break;
        case 8:
            retValue = @"August" ;
            break;
        case 9:
            retValue = @"September" ;
            break;
        case 10:
            retValue = @"October" ;
            break;
        case 11:
            retValue = @"November" ;
            break;
        case 12:
            retValue = @"December" ;
            break;
        default:
            break;
    }
    return retValue ;
}

+ (NSString *)getShorthandForWeekday:(NSInteger)weekday format:(NSInteger)format
{
    //NSLog(@"getShorthandForWeekday:%d",weekday) ;
    NSString *retValue ;
    if(format == VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL){
        switch (weekday) {
            case 1:
                retValue = @"Sunday" ;
                break;
            case 2:
                retValue = @"Monday" ;
                break;
            case 3:
                retValue = @"Tuesday" ;
                break;
            case 4:
                retValue = @"Wednesday" ;
                break;
            case 5:
                retValue = @"Thursday" ;
                break;
            case 6:
                retValue = @"Friday" ;
                break;
            case 7:
                retValue = @"Saturday" ;
                break;
            default:
                break;
        }
    }
    return retValue ;
}

+ (void)removeVideoFile:(NSString *)videoId
{
    NSString *targetFilePath = [VeamUtil getFilePathAtCachesDirectory:[NSString stringWithFormat:@"p%@.mp4",videoId]] ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    [fileManager removeItemAtPath:targetFilePath error:nil] ;
}

+ (BOOL)videoExists:(Video *)video
{
    BOOL retValue = NO ;
    NSString *videoId = [video videoId] ;
    NSString *fileName = [NSString stringWithFormat:@"p%@.mp4",videoId] ;
    if([VeamUtil fileExistsAtCachesDirectory:fileName]){
        if([VeamUtil fileSizeAtCachesDirectory:fileName] == [[video dataSize] integerValue]){
            retValue = YES ;
        }
    }
    return retValue ;
}

+ (void)playVideo:(Video *)video title:(NSString *)title
{
    [[AppDelegate sharedInstance] playVideo:video title:title] ;
}

+ (void)playAudio:(Audio *)audio title:(NSString *)title
{
    [[AppDelegate sharedInstance] playAudio:audio title:title] ;
}

+ (void)setMovieKey:(NSString *)key
{
    [[AppDelegate sharedInstance] setMovieKey:key] ;
}

+ (NSString *)getSubscriptionProductId:(NSInteger)index
{
    return [NSString stringWithFormat:VEAM_SUBSCRIPTION_PRODUCT_ID_FORMAT,[VeamUtil getAppId],index] ;
}

+ (NSString *)base64Encode:(const uint8_t *)input length:(NSInteger)length
{
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
	
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
			value <<= 8;
			
			if (j < length) {
				value |= (0xFF & input[j]);
			}
        }
		
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

const static char base64table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=" ;
+(NSData*)base64Decode:(NSString*)string
{
    if (!string || string.length == 0) return nil;
    
    unsigned char idx[4];
    unsigned char val1,val2,val3;
    char buf;
    
    unsigned long datalength = string.length;
    NSMutableData* result = [NSMutableData data];
    
    //ポインタで処理するためにchar*へ変換
    const char* src = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    for(int i=0;i<datalength;i += 4)
    {
        //base64の先頭からのインデックスを求める(4文字ずつ処理する)
        for (int j=0; j < 4; j++)
        {
            buf = *(src + i + j);
            idx[j] = (buf == '=') ? 0 : strchr(base64table, buf) - base64table;
        }
        
        //求めたインデックスからバイト値を求める（6bit×4 から 8bit×3を生成）
        val1 = ((idx[0] & 0x3F) << 2 | (idx[1] & 0x30) >> 4 );
        val2 = ((idx[1] & 0x0F) << 4 | (idx[2] & 0x3C) >> 2 );
        val3 = ((idx[2] & 0x03) << 6 | (idx[3] & 0x3F) >> 0 );
        
        //結果を保存
        [result appendBytes:&val1 length:1];
        [result appendBytes:&val2 length:1];
        [result appendBytes:&val3 length:1];
    }
    
    return result;
}

+ (NSString *)bbDecode:(NSString *)encodedString
{
    //NSLog(@"bbDecode len=%d encodedString = %@",encodedString.length,encodedString) ;
    NSData *intermediateData = [VeamUtil base64Decode:encodedString] ;
    NSString *intermediateString = [[NSString alloc] initWithData:intermediateData encoding:NSUTF8StringEncoding] ;
    char *charArray = [intermediateString UTF8String] ;
    intermediateString = [NSString stringWithCString:charArray encoding:NSUTF8StringEncoding];
    //NSLog(@"len=%d intermediateString = %@",intermediateString.length,intermediateString) ;
    NSData *decodedData = [VeamUtil base64Decode:intermediateString] ;
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding] ;
    charArray = [decodedString UTF8String] ;
    decodedString = [NSString stringWithCString:charArray encoding:NSUTF8StringEncoding];
    //NSLog(@"datalen=%d stringlen=%d",[decodedData length],[decodedString length]) ;
    decodedString = [decodedString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    decodedString = [decodedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //NSLog(@"decodedString = %@",decodedString) ;
    return decodedString ;
}

+ (NSDictionary *)decodeReceiptString:(NSString *)string
{
    
    NSMutableDictionary *retValue = nil ;
    
    NSError *error   = nil;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"\"([^\"]+)\" *= *\"([^\"]+)\" *;" options:0 error:&error] ;
    if(error != nil){
       //NSLog(@"%@", error);
    } else {
        NSRange range = NSMakeRange(0, string.length) ;
        NSArray *results = [regExp matchesInString:string options:0 range:range] ;
        NSInteger count = [results count] ;
        for(int index = 0 ; index < count ; index++){
            NSTextCheckingResult *match = [results objectAtIndex:index] ;
            //NSLog(@"%d", match.numberOfRanges) ;
            NSInteger matchCount  = match.numberOfRanges ;
            if(matchCount >= 3){
                if(retValue == nil){
                    retValue = [NSMutableDictionary dictionary] ;
                }
                NSString *key = [string substringWithRange:[match rangeAtIndex:1]] ;
                NSString *value = [string substringWithRange:[match rangeAtIndex:2]] ;
                [retValue setObject:value forKey:key] ;
            }
            /*
             for(int matchIndex = 0 ; matchIndex < matchCount ; matchIndex++){
            //NSLog(@"%@", [string substringWithRange:[match rangeAtIndex:matchIndex]]) ;
             }
             */
        }
    }
    
    return retValue ;
}

+ (BOOL)receiptIsExpired:(NSData *)receipt
{
    BOOL retValue = NO ;
    NSString *receiptString = [[NSString alloc] initWithData:receipt encoding:NSUTF8StringEncoding] ;
    //NSLog(@"receipt=%@",receiptString) ;
    
    NSDictionary *dictionary = [VeamUtil decodeReceiptString:receiptString] ;
    NSString *base64PurchaseInfo = [dictionary objectForKey:@"purchase-info"] ;
    NSData *purchaseInfo = [VeamUtil base64Decode:base64PurchaseInfo] ;
    NSString *purchaseInfoString = [[NSString alloc] initWithData:purchaseInfo encoding:NSUTF8StringEncoding] ;
    
    NSDictionary *purchaseInfoDictionary = [VeamUtil decodeReceiptString:purchaseInfoString] ;
    
    NSString *expiresDateString  = [purchaseInfoDictionary objectForKey:@"expires-date"] ;
    
    if((expiresDateString != nil) && ![expiresDateString isEqualToString:@""]){
        double expiresTime = [expiresDateString doubleValue] / 1000 ;
        NSDate *currentDate = [NSDate date] ;
        //NSLog(@"receiptIsExpired %f < %f",expiresTime,[currentDate timeIntervalSince1970]) ;
        if(expiresTime < [currentDate timeIntervalSince1970]){
            retValue = YES ;
        }
    }
    
    return retValue ;
}

// if forced == YES , the server is forced to use the apple verification server.
// if forced == NO , the server don't use the apple verification server in case of receipt is expired.
+ (NSInteger)verifySubscriptionReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced
{
    //NSLog(@"VeamUtil::verifyReceipt") ;
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone] ;
    NSInteger secondsFromGmt = [timeZone secondsFromGMT] ;
    
    NSInteger verifyStatus = VEAM_STORE_RECEIPT_VERIFY_FAILED ;
 	NSString *urlString  = [NSString stringWithFormat:@"%@&u=%@&r=%@&t=%d&f=%@&s=0",[VeamUtil getApiUrl:@"subscription/verifyreceipt"],[VeamUtil getTrackingId],storeReceipt,secondsFromGmt,forced?@"1":@"0"] ;
	//NSLog(@"urlString String url = %@",urlString) ;
	
    NSURL *urlForValidation = [NSURL URLWithString:urlString] ;
    NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:urlForValidation] ;
    [validationRequest setHTTPMethod:@"GET"] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil] ;
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] ;
    //NSLog(@"response=%@",responseString) ;
    
    NSArray *results = [responseString componentsSeparatedByString:@"\n"] ;
    if(([results count] >= 1) && [[results objectAtIndex:0] isEqualToString:@"EXPIRED"]){
        //NSLog(@"subscription has been expired") ;
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_EXPIRED ;
        if(clearIfExpired){
            [VeamUtil setStoreReceipt:@"" index:[VeamUtil getSubscriptionIndex]] ;
        }
    } else if(([results count] >= 5) && [[results objectAtIndex:0] isEqualToString:@"OK"]){
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_SUCCESS ;
        NSString *latestReceipt = [results objectAtIndex:1] ;
        NSString *startTime = [results objectAtIndex:2] ;
        NSString *endTime = [results objectAtIndex:3] ;
        NSString *subscriptionInfo = [results objectAtIndex:4] ;
        
        //NSLog(@"startTime=%@",startTime) ;
        //NSLog(@"endTime=%@",endTime) ;
        //NSLog(@"subscriptionInfo=%@",subscriptionInfo) ;
        
        [VeamUtil setSubscriptionStartTime:startTime index:[VeamUtil getSubscriptionIndex]] ;
        [VeamUtil setSubscriptionEndTime:endTime index:[VeamUtil getSubscriptionIndex]] ;
        
        NSString *receiptToBeStored = storeReceipt ;
        if(![VeamUtil isEmpty:latestReceipt]){
            receiptToBeStored = latestReceipt ;
        }
        [VeamUtil setStoreReceipt:receiptToBeStored index:[VeamUtil getSubscriptionIndex]] ;
    }
    return verifyStatus ;
}

+ (BOOL)isSubscriptionFree
{
    BOOL retValue = NO ;
    
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    TemplateSubscription *templateSubscription = [contents getTemplateSubscription] ;
    if([templateSubscription.isFree isEqualToString:@"1"]){
        retValue = YES ;
    }
    return retValue ;
}

+ (BOOL)isSubscriptionBought:(NSInteger)index
{
    BOOL retValue = NO ;
    
    if([VeamUtil isSubscriptionFree]){
        retValue = YES ;
    } else {
        NSString *receipt = [VeamUtil getStoreReceipt:index] ;
        if(![VeamUtil isEmpty:receipt]){
            retValue = YES ;
        }
    }
    return retValue ;
}


+ (NSString *)getDateString:(NSNumber *)timeFrom1970 format:(NSInteger)format
{
    
    //NSLog(@"getDateString:%d",[timeFrom1970 integerValue]) ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeFrom1970 doubleValue]] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:gregorianCalendar] ;
    [dateFormatter setDateFormat:@"yyyyMMdd"] ;
    NSString *dateString = [dateFormatter stringFromDate:date] ;
    NSInteger year = [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue] ;
    NSInteger month = [[dateString substringWithRange:NSMakeRange(4, 2)] integerValue] ;
    NSString *monthString = [VeamUtil getShorthandForMonth:month format:VEAM_SHORTHAND_MONTH_FORMAT_3CHAR] ;
    NSInteger day = [[dateString substringWithRange:NSMakeRange(6, 2)] integerValue] ;
    
    NSString *formattedString ;
    if([VeamUtil isLocaleJapanese]){
        if(format == VEAM_DATE_STRING_MONTH_DAY){
            formattedString =  [NSString stringWithFormat:@"%d/%d",month,day] ;
        } else if(format == VEAM_DATE_STRING_MONTH_DAY_YEAR){
            formattedString =  [NSString stringWithFormat:@"%d/%d/%d",year,month,day] ;
        }
    } else {
        if(format == VEAM_DATE_STRING_MONTH_DAY){
            formattedString =  [NSString stringWithFormat:@"%@.%d",monthString,day] ;
        } else if(format == VEAM_DATE_STRING_MONTH_DAY_YEAR){
            formattedString =  [NSString stringWithFormat:@"%@.%d %d",monthString,day,year] ;
        }
    }
    return formattedString ;
}

+ (NSString *)getMessageDateString:(NSString *)timeFrom1970
{
    //NSLog(@"getMessageDateString:%d",[timeFrom1970 integerValue]) ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeFrom1970 doubleValue]] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    [dateFormatter setCalendar:gregorianCalendar] ;
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle] ;
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ;
    [dateFormatter setLocale:usLocale] ;
    [dateFormatter setDateFormat:@"MMM. dd,yyyy"] ;
    NSString *dateString = [dateFormatter stringFromDate:date] ;
    return dateString ;
}

+ (NSString *)getMessageTimeString:(NSString *)timeFrom1970
{
    //NSLog(@"getMessageTimeString:%d",[timeFrom1970 integerValue]) ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeFrom1970 doubleValue]] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    [dateFormatter setCalendar:gregorianCalendar] ;
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle] ;
    [dateFormatter setDateFormat:@"HH:mm"] ;
    NSString *timeString = [dateFormatter stringFromDate:date] ;
    return timeString ;
}



+ (NSString *)getShorthandForMonth:(NSInteger)month format:(NSInteger)format
{
    NSString *retValue ;
    if(format == VEAM_SHORTHAND_MONTH_FORMAT_3CHAR){
        switch (month) {
            case 1:
                retValue = @"Jan" ;
                break;
            case 2:
                retValue = @"Feb" ;
                break;
            case 3:
                retValue = @"Mar" ;
                break;
            case 4:
                retValue = @"Apr" ;
                break;
            case 5:
                retValue = @"May" ;
                break;
            case 6:
                retValue = @"Jun" ;
                break;
            case 7:
                retValue = @"Jul" ;
                break;
            case 8:
                retValue = @"Aug" ;
                break;
            case 9:
                retValue = @"Sep" ;
                break;
            case 10:
                retValue = @"Oct" ;
                break;
            case 11:
                retValue = @"Nov" ;
                break;
            case 12:
                retValue = @"Dec" ;
                break;
            default:
                break;
        }
    } else if(format == VEAM_SHORTHAND_MONTH_FORMAT_MAX5){
        switch (month) {
                
            case 1:
                retValue = @"JAN" ;
                break;
            case 2:
                retValue = @"FEB" ;
                break;
            case 3:
                retValue = @"MARCH" ;
                break;
            case 4:
                retValue = @"APRIL" ;
                break;
            case 5:
                retValue = @"MAY" ;
                break;
            case 6:
                retValue = @"JUNE" ;
                break;
            case 7:
                retValue = @"JULY" ;
                break;
            case 8:
                retValue = @"AUG" ;
                break;
            case 9:
                retValue = @"SEPT" ;
                break;
            case 10:
                retValue = @"OCT" ;
                break;
            case 11:
                retValue = @"NOV" ;
                break;
            case 12:
                retValue = @"DEC" ;
                break;
            default:
                break;
        }
    }
    return retValue ;
}

+ (NSInteger)getYear:(NSNumber *)timeFrom1970
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeFrom1970 doubleValue]] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:gregorianCalendar] ;
    [dateFormatter setDateFormat:@"yyyy"] ;
    NSString *dateString = [dateFormatter stringFromDate:date] ;
    return [dateString integerValue] ;
}

#define USERDEFAULT_KEY_QUESTION_STRING    @"QUESTION_STRING_%@"
+ (void)setQuestionString:(NSString *)questionString questionId:(NSString *)questionId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:questionString forKey:[NSString stringWithFormat:USERDEFAULT_KEY_QUESTION_STRING,questionId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getQuestionStringForQuestionId:(NSString *)questionId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *questionString = [userDefaults objectForKey:[NSString stringWithFormat:USERDEFAULT_KEY_QUESTION_STRING,questionId]] ;
    return questionString ;
}

#define USERDEFAULT_KEY_QUESTION_IDS    @"QUESTION_IDS"
+ (void)setQuestionIds:(NSMutableArray *)questionIds
{
    NSString *questionIdsString = @"" ;
    int count = [questionIds count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *questionId = [questionIds objectAtIndex:index] ;
        if([VeamUtil isEmpty:questionIdsString]){
            questionIdsString = questionId ;
        } else {
            questionIdsString = [questionIdsString stringByAppendingFormat:@",%@",questionId] ;
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:questionIdsString forKey:USERDEFAULT_KEY_QUESTION_IDS] ;
    [userDefaults synchronize] ;
}

+ (NSArray *)getQuestionIds
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *questionIdsString = [userDefaults objectForKey:USERDEFAULT_KEY_QUESTION_IDS] ;
    NSArray *questionIds = nil ;
    if(![VeamUtil isEmpty:questionIdsString]){
        questionIds = [questionIdsString componentsSeparatedByString:@","] ;
    }
    return questionIds ;
}

+ (void)setQuestionPosted:(BOOL)questionPosted
{
    [[AppDelegate sharedInstance] setQuestionPosted:questionPosted] ;
}

+ (BOOL)getQuestionPosted
{
    return [[AppDelegate sharedInstance] questionPosted] ;
}

+ (void)setTextWithLineHeight:(UILabel *)label text:(NSString *)text lineHeight:(CGFloat)lineHeight
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        if(text == nil){
            [label setText:@""] ;
        } else {
            NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
            paragrahStyle.minimumLineHeight = lineHeight;
            paragrahStyle.maximumLineHeight = lineHeight;
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text] ;
            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, attributedText.length)] ;
            [label setAttributedText:attributedText] ;
        }
    } else {
        [label setText:text] ;
    }
}

+ (NSString *)getShortTimeDescription:(NSString *)unixTimeString
{
    NSTimeInterval actionTime = [unixTimeString doubleValue] ;
    NSDate *date = [NSDate date] ;
    NSTimeInterval diff = date.timeIntervalSince1970 - actionTime ;
    //NSLog(@"actionTime %f sec ago",diff) ;
    NSString *timeString ;
    NSInteger value ;
    if(diff < 60){
        if(diff < 0){
            diff = 0 ;
        }
        value = (int)diff ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"second_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"seconds_ago",nil)] ;
        }
    } else if(diff < 3600){
        value = (int)(diff/60) ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"minute_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"minutes_ago",nil)] ;
        }
    } else if(diff < 86400){
        value = (int)(diff/3600) ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"hour_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"hours_ago",nil)] ;
        }
    } else {
        value = (int)(diff/86400) ;
        if(value == 1){
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"day_ago",nil)] ;
        } else {
            timeString = [NSString stringWithFormat:@"%d %@",value,NSLocalizedString(@"days_ago",nil)] ;
        }
    }
    return timeString ;
}

+ (NSString *)getAnswerDateString:(NSString *)timeFrom1970
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeFrom1970 doubleValue]] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:gregorianCalendar] ;
    [dateFormatter setDateFormat:@"yyyyMMddHH"] ;
    NSString *dateString = [dateFormatter stringFromDate:date] ;
    NSInteger year = [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue] ;
    NSInteger month = [[dateString substringWithRange:NSMakeRange(4, 2)] integerValue] ;
    NSString *monthString = [VeamUtil getShorthandForMonth:month format:VEAM_SHORTHAND_MONTH_FORMAT_3CHAR] ;
    NSInteger day = [[dateString substringWithRange:NSMakeRange(6, 2)] integerValue] ;
    
    NSString *formattedString ;
    formattedString =  [NSString stringWithFormat:@"%d %@ %d",day,monthString,year] ;
    return formattedString ;
}

+ (UIColor *)getQuestionHeaderColor
{
    return [VeamUtil getConfigurationColor:VEAM_CONFIG_QA_HEADER_BACKGROUND_COLOR default:[VeamUtil getColorFromArgbString:@"77FFFFFF"]] ;
}

+ (UIColor *)changeColor:(UIColor *)color alpha:(CGFloat)targetAlpha
{
    CGFloat red ;
    CGFloat green ;
    CGFloat blue ;
    CGFloat alpha ;
    [color getRed:&red green:&green blue:&blue alpha:&alpha] ;
    UIColor *retValue = [UIColor colorWithRed:red green:green blue:blue alpha:alpha*targetAlpha] ;
    return retValue ;
}

+ (void)setShouldShowCalendar:(BOOL)shouldShowCalendar
{
    [[AppDelegate sharedInstance] setShouldShowCalendar:shouldShowCalendar] ;
}

+ (BOOL)getShouldShowCalendar
{
    return [[AppDelegate sharedInstance] shouldShowCalendar] ;
}


#define VEAM_DATE_INTEGER_YEAR      1
#define VEAM_DATE_INTEGER_MONTH     2
#define VEAM_DATE_INTEGER_DAY       3


+ (NSInteger)getDateInteger:(NSString *)timeString kind:(NSInteger)kind
{
    NSInteger retValue = 0 ;
    
    //NSLog(@"getDateInteger:%d",[timeString integerValue]) ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:gregorianCalendar] ;
    [dateFormatter setDateFormat:@"yyyyMMdd"] ;
    NSString *dateString = [dateFormatter stringFromDate:date] ;
    NSInteger year = [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue] ;
    NSInteger month = [[dateString substringWithRange:NSMakeRange(4, 2)] integerValue] ;
    NSInteger day = [[dateString substringWithRange:NSMakeRange(6, 2)] integerValue] ;
    
    switch (kind) {
        case VEAM_DATE_INTEGER_YEAR:
            retValue = year ;
            break;
        case VEAM_DATE_INTEGER_MONTH:
            retValue = month ;
            break;
        case VEAM_DATE_INTEGER_DAY:
            retValue = day ;
            break;
            
        default:
            break;
    }
    
    return retValue ;
}


+ (NSInteger)getSubscriptionStartYear:(NSInteger)index
{
    NSInteger retValue = 0 ;
    NSString *startTime = [VeamUtil getSubscriptionStartTime:0] ;
    //NSLog(@"getSubscriptionStartYear:%d",[startTime integerValue]) ;
    
    if(![VeamUtil isEmpty:startTime]){
        retValue = [VeamUtil getDateInteger:startTime kind:VEAM_DATE_INTEGER_YEAR] ;
    }
    return retValue ;
}

+ (NSInteger)getSubscriptionStartMonth:(NSInteger)index
{
    NSInteger retValue = 0 ;
    NSString *startTime = [VeamUtil getSubscriptionStartTime:0] ;
    //NSLog(@"getSubscriptionStartMonth:%d",[startTime integerValue]) ;
    
    if(![VeamUtil isEmpty:startTime]){
        retValue = [VeamUtil getDateInteger:startTime kind:VEAM_DATE_INTEGER_MONTH] ;
    }
    return retValue ;
}

+ (NSInteger)getSubscriptionStartDay:(NSInteger)index
{
    NSInteger retValue = 0 ;
    NSString *startTime = [VeamUtil getSubscriptionStartTime:0] ;
    //NSLog(@"getSubscriptionStartDay:%d",[startTime integerValue]) ;
    
    if(![VeamUtil isEmpty:startTime]){
        retValue = [VeamUtil getDateInteger:startTime kind:VEAM_DATE_INTEGER_DAY] ;
    }
    return retValue ;
}

+ (NSDateComponents *)getCurrentDateComponents
{
    //NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    NSDate *currentDate = [NSDate date] ;
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate] ;
    return components ;
}

+ (void)setCalendarYear:(NSInteger)year month:(NSInteger)month
{
    [[AppDelegate sharedInstance] setCalendarYear:year] ;
    [[AppDelegate sharedInstance] setCalendarMonth:month] ;
}

+ (NSInteger)getCalendarYear
{
    return [[AppDelegate sharedInstance] calendarYear] ;
}

+ (NSInteger)getCalendarMonth
{
    return [[AppDelegate sharedInstance] calendarMonth] ;
}

#define USERDEFAULT_KEY_WORKOUT_DONE_FORMAT    @"D%02d%02d%02d%d"
+ (void)setWorkoutDone:(NSInteger)year month:(NSInteger)month day:(NSInteger)day index:(NSInteger)index done:(BOOL)done
{
    NSString *key = [NSString stringWithFormat:USERDEFAULT_KEY_WORKOUT_DONE_FORMAT,(year%100),month,day,index] ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setBool:done forKey:key] ;
    [userDefaults synchronize] ;
}

+ (BOOL)getWorkoutDone:(NSInteger)year month:(NSInteger)month day:(NSInteger)day index:(NSInteger)index
{
    BOOL done = NO ;
    NSString *key = [NSString stringWithFormat:USERDEFAULT_KEY_WORKOUT_DONE_FORMAT,(year%100),month,day,index] ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    done = [userDefaults boolForKey:key] ;
    return done ;
}


+ (UIImage*)cropImage:(UIImage *)image toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],rect) ;
    UIImage *cropped =[UIImage imageWithCGImage:imageRef] ;
    CGImageRelease(imageRef) ;
    
    return cropped ;
}

+ (BOOL)isStoredAlternativeImage:(NSString *)alternativeImageId
{
    BOOL retValue = NO ;
    NSString *ids = [VeamUtil getConfigurationString:VEAM_CONFIG_STORED_ALTERNATIVE_IMAGE_IDS default:@""] ;
    NSArray *storedAlternativeImageIds = [ids componentsSeparatedByString:@","] ;
    NSInteger count = [storedAlternativeImageIds count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *workId = [storedAlternativeImageIds objectAtIndex:index] ;
        if(![VeamUtil isEmpty:workId]){
            if([workId isEqualToString:alternativeImageId]){
                retValue = YES ;
                break ;
            }
        }
    }
    return retValue ;
}


+ (NSArray *)getYoutubeExclusionUrls
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        NSString *youtubeExclusionUrlString = [contents getValueForKey:@"youtube_exclusion_urls"] ;
        if(![VeamUtil isEmpty:youtubeExclusionUrlString]){
            retValue = [youtubeExclusionUrlString componentsSeparatedByString:@":"] ;
        }
    }
    return retValue ;
}

+ (NSString *)getLanguageId
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *languageId = [languages objectAtIndex:0];
    return languageId ;
}

+ (BOOL)isLocaleJapanese
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *languageID = [languages objectAtIndex:0];
    if([languageID length] > 2){
        languageID = [languageID substringToIndex:2] ;
    }
    
    if ([languageID isEqualToString:@"ja"]) {
        return YES;
    }
    
    return NO;
}


+ (NSArray *)getSellVideosForCategory:(NSString *)videoCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellVideosForCategory:videoCategoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getSellVideos
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellVideos] ;
    }
    return retValue ;
}

#define USERDEFAULT_KEY_SELL_VIDEO_RECEIPT_FORMAT    @"SELL_VIDEO_%@_RECEIPT"
+ (NSString *)getSellVideoReceiptKey:(NSString *)sellVideoId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_SELL_VIDEO_RECEIPT_FORMAT,sellVideoId] ;
    return retValue ;
}

+ (void)setSellVideoReceipt:(NSString *)sellVideoReceipt sellVideoId:(NSString *)sellVideoId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:sellVideoReceipt forKey:[VeamUtil getSellVideoReceiptKey:sellVideoId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getSellVideoReceipt:(NSString *)sellVideoId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *sellVideoReceipt = [userDefaults objectForKey:[VeamUtil getSellVideoReceiptKey:sellVideoId]] ;
    return sellVideoReceipt ;
}

// if forced == YES , the server is forced to use the apple verification server.
// if forced == NO , the server don't use the apple verification server in case of receipt is expired.
+ (NSInteger)verifySellVideoReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced
{
   //NSLog(@"verifySellVideoReceipt") ;
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone] ;
    NSInteger secondsFromGmt = [timeZone secondsFromGMT] ;
    
    NSInteger verifyStatus = VEAM_STORE_RECEIPT_VERIFY_FAILED ;
    NSString *urlString  = [NSString stringWithFormat:@"%@&r=%@&t=%d&f=%@&s=0",[VeamUtil getApiUrl:@"subscription/verifysellvideoreceipt"],storeReceipt,secondsFromGmt,forced?@"1":@"0"] ;
   //NSLog(@"urlString String url = %@",urlString) ;
    
    NSURL *urlForValidation = [NSURL URLWithString:urlString] ;
    NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:urlForValidation] ;
    [validationRequest setHTTPMethod:@"GET"] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil] ;
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] ;
   //NSLog(@"response=%@",responseString) ;
    
    NSArray *results = [responseString componentsSeparatedByString:@"\n"] ;
    if(([results count] >= 1) && [[results objectAtIndex:0] isEqualToString:@"EXPIRED"]){
        //NSLog(@"subscription has been expired") ;
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_EXPIRED ;
        if(clearIfExpired){
            //[VeamUtil setStoreReceipt:@""] ;
        }
    } else if(([results count] >= 3) && [[results objectAtIndex:0] isEqualToString:@"OK"]){
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_SUCCESS ;
        NSString *latestReceipt = [results objectAtIndex:1] ;
        NSString *productId = [results objectAtIndex:2] ; // co.veam.veam__APP_ID__.video.__SELL_VIDEO_ID__
        
        NSString *receiptToBeStored = storeReceipt ;
        if((latestReceipt != nil) && ![latestReceipt isEqualToString:@""]){
            receiptToBeStored = latestReceipt ;
        }
        
        SellVideo *sellVideo = [VeamUtil getSellVideoForProduct:productId] ;
        [VeamUtil setSellVideoReceipt:receiptToBeStored sellVideoId:sellVideo.sellVideoId] ;
    }
    return verifyStatus ;
}

+ (BOOL)isSellVideoProduct:(NSString *)productId
{
    BOOL retValue = NO ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents isSellVideoProduct:productId] ;
    }
    return retValue ;
}

+ (SellVideo *)getSellVideoForProduct:(NSString *)productId
{
    SellVideo *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellVideoForProduct:productId] ;
    }
    return retValue ;
}

+ (void)setSellVideoPurchased:(BOOL)sellVideoPurchased
{
    [[AppDelegate sharedInstance] setSellVideoPurchased:sellVideoPurchased] ;
}

+ (BOOL)getSellVideoPurchased
{
    return [[AppDelegate sharedInstance] sellVideoPurchased] ;
}




// Sell PDF
+ (NSArray *)getSellPdfsForCategory:(NSString *)pdfCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellPdfsForCategory:pdfCategoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getSellPdfs
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellPdfs] ;
    }
    return retValue ;
}

#define USERDEFAULT_KEY_SELL_PDF_RECEIPT_FORMAT    @"SELL_PDF_%@_RECEIPT"
+ (NSString *)getSellPdfReceiptKey:(NSString *)sellPdfId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_SELL_PDF_RECEIPT_FORMAT,sellPdfId] ;
    return retValue ;
}

+ (void)setSellPdfReceipt:(NSString *)sellPdfReceipt sellPdfId:(NSString *)sellPdfId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:sellPdfReceipt forKey:[VeamUtil getSellPdfReceiptKey:sellPdfId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getSellPdfReceipt:(NSString *)sellPdfId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *sellPdfReceipt = [userDefaults objectForKey:[VeamUtil getSellPdfReceiptKey:sellPdfId]] ;
    return sellPdfReceipt ;
}






#define USERDEFAULT_KEY_PDF_URL_FORMAT    @"PDF_%@_URL"
+ (NSString *)getPdfUrlKey:(NSString *)pdfId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_PDF_URL_FORMAT,pdfId] ;
    return retValue ;
}

+ (void)setPdfUrl:(NSString *)pdfUrl pdfId:(NSString *)pdfId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:pdfUrl forKey:[VeamUtil getPdfUrlKey:pdfId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getPdfUrl:(NSString *)pdfId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *pdfUrl = [userDefaults objectForKey:[VeamUtil getPdfUrlKey:pdfId]] ;
    return pdfUrl ;
}

#define USERDEFAULT_KEY_PDF_TOKEN_FORMAT    @"PDF_%@_TOKEN"
+ (NSString *)getPdfTokenKey:(NSString *)pdfId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_PDF_TOKEN_FORMAT,pdfId] ;
    return retValue ;
}

+ (void)setPdfToken:(NSString *)pdfToken pdfId:(NSString *)pdfId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:pdfToken forKey:[VeamUtil getPdfTokenKey:pdfId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getPdfToken:(NSString *)pdfId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *pdfToken = [userDefaults objectForKey:[VeamUtil getPdfTokenKey:pdfId]] ;
    return pdfToken ;
}





// if forced == YES , the server is forced to use the apple verification server.
// if forced == NO , the server don't use the apple verification server in case of receipt is expired.
+ (NSInteger)verifySellPdfReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced
{
    //NSLog(@"verifySellPdfReceipt") ;
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone] ;
    NSInteger secondsFromGmt = [timeZone secondsFromGMT] ;
    
    NSInteger verifyStatus = VEAM_STORE_RECEIPT_VERIFY_FAILED ;
    NSString *urlString  = [NSString stringWithFormat:@"%@&r=%@&t=%d&f=%@&s=0",[VeamUtil getApiUrl:@"subscription/verifysellpdfreceipt"],storeReceipt,secondsFromGmt,forced?@"1":@"0"] ;
    //NSLog(@"urlString String url = %@",urlString) ;
    
    NSURL *urlForValidation = [NSURL URLWithString:urlString] ;
    NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:urlForValidation] ;
    [validationRequest setHTTPMethod:@"GET"] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil] ;
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] ;
    //NSLog(@"response=%@",responseString) ;
    
    NSArray *results = [responseString componentsSeparatedByString:@"\n"] ;
    if(([results count] >= 1) && [[results objectAtIndex:0] isEqualToString:@"EXPIRED"]){
        //NSLog(@"subscription has been expired") ;
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_EXPIRED ;
        if(clearIfExpired){
            //[VeamUtil setStoreReceipt:@""] ;
        }
    } else if(([results count] >= 5) && [[results objectAtIndex:0] isEqualToString:@"OK"]){
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_SUCCESS ;
        NSString *latestReceipt = [results objectAtIndex:1] ;
        NSString *productId = [results objectAtIndex:2] ; // co.veam.veam__APP_ID__.pdf.__SELL_PDF_ID__
        NSString *url = [results objectAtIndex:3] ;
        NSString *token = [results objectAtIndex:4] ;
        
        NSString *receiptToBeStored = storeReceipt ;
        if((latestReceipt != nil) && ![latestReceipt isEqualToString:@""]){
            receiptToBeStored = latestReceipt ;
        }
        
        SellPdf *sellPdf = [VeamUtil getSellPdfForProduct:productId] ;
        [VeamUtil setSellPdfReceipt:receiptToBeStored sellPdfId:sellPdf.sellPdfId] ;
        NSString *pdfId = sellPdf.pdfId ;
        [VeamUtil setPdfUrl:url pdfId:pdfId] ;
        [VeamUtil setPdfToken:token pdfId:pdfId] ;
        //NSLog(@"set url=%@ token=%@",url,token) ;
    }
    return verifyStatus ;
}

+ (BOOL)isSellPdfProduct:(NSString *)productId
{
    BOOL retValue = NO ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents isSellPdfProduct:productId] ;
    }
    return retValue ;
}

+ (SellPdf *)getSellPdfForProduct:(NSString *)productId
{
    SellPdf *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellPdfForProduct:productId] ;
    }
    return retValue ;
}

+ (void)setSellPdfPurchased:(BOOL)sellPdfPurchased
{
    [[AppDelegate sharedInstance] setSellPdfPurchased:sellPdfPurchased] ;
}

+ (BOOL)getSellPdfPurchased
{
    return [[AppDelegate sharedInstance] sellPdfPurchased] ;
}


















// Sell Audio
+ (NSArray *)getSellAudiosForCategory:(NSString *)audioCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellAudiosForCategory:audioCategoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getSellAudios
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellAudios] ;
    }
    return retValue ;
}

#define USERDEFAULT_KEY_SELL_AUDIO_RECEIPT_FORMAT    @"SELL_AUDIO_%@_RECEIPT"
+ (NSString *)getSellAudioReceiptKey:(NSString *)sellAudioId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_SELL_AUDIO_RECEIPT_FORMAT,sellAudioId] ;
    return retValue ;
}

+ (void)setSellAudioReceipt:(NSString *)sellAudioReceipt sellAudioId:(NSString *)sellAudioId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:sellAudioReceipt forKey:[VeamUtil getSellAudioReceiptKey:sellAudioId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getSellAudioReceipt:(NSString *)sellAudioId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *sellAudioReceipt = [userDefaults objectForKey:[VeamUtil getSellAudioReceiptKey:sellAudioId]] ;
    return sellAudioReceipt ;
}






#define USERDEFAULT_KEY_AUDIO_URL_FORMAT    @"AUDIO_%@_URL"
+ (NSString *)getAudioUrlKey:(NSString *)audioId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_AUDIO_URL_FORMAT,audioId] ;
    return retValue ;
}

+ (void)setAudioUrl:(NSString *)audioUrl audioId:(NSString *)audioId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:audioUrl forKey:[VeamUtil getAudioUrlKey:audioId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getAudioUrl:(NSString *)audioId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *audioUrl = [userDefaults objectForKey:[VeamUtil getAudioUrlKey:audioId]] ;
    return audioUrl ;
}

#define USERDEFAULT_KEY_AUDIO_TOKEN_FORMAT    @"AUDIO_%@_TOKEN"
+ (NSString *)getAudioTokenKey:(NSString *)audioId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_AUDIO_TOKEN_FORMAT,audioId] ;
    return retValue ;
}

+ (void)setAudioToken:(NSString *)audioToken audioId:(NSString *)audioId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:audioToken forKey:[VeamUtil getAudioTokenKey:audioId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getAudioToken:(NSString *)audioId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *audioToken = [userDefaults objectForKey:[VeamUtil getAudioTokenKey:audioId]] ;
    return audioToken ;
}





// if forced == YES , the server is forced to use the apple verification server.
// if forced == NO , the server don't use the apple verification server in case of receipt is expired.
+ (NSInteger)verifySellAudioReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced
{
    //NSLog(@"verifySellAudioReceipt") ;
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone] ;
    NSInteger secondsFromGmt = [timeZone secondsFromGMT] ;
    
    NSInteger verifyStatus = VEAM_STORE_RECEIPT_VERIFY_FAILED ;
    NSString *urlString  = [NSString stringWithFormat:@"%@&r=%@&t=%d&f=%@&s=0",[VeamUtil getApiUrl:@"subscription/verifysellaudioreceipt"],storeReceipt,secondsFromGmt,forced?@"1":@"0"] ;
    //NSLog(@"urlString String url = %@",urlString) ;
    
    NSURL *urlForValidation = [NSURL URLWithString:urlString] ;
    NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:urlForValidation] ;
    [validationRequest setHTTPMethod:@"GET"] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil] ;
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] ;
    //NSLog(@"response=%@",responseString) ;
    
    NSArray *results = [responseString componentsSeparatedByString:@"\n"] ;
    if(([results count] >= 1) && [[results objectAtIndex:0] isEqualToString:@"EXPIRED"]){
        //NSLog(@"subscription has been expired") ;
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_EXPIRED ;
        if(clearIfExpired){
            //[VeamUtil setStoreReceipt:@""] ;
        }
    } else if(([results count] >= 5) && [[results objectAtIndex:0] isEqualToString:@"OK"]){
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_SUCCESS ;
        NSString *latestReceipt = [results objectAtIndex:1] ;
        NSString *productId = [results objectAtIndex:2] ; // co.veam.veam__APP_ID__.audio.__SELL_AUDIO_ID__
        NSString *url = [results objectAtIndex:3] ;
        NSString *token = [results objectAtIndex:4] ;
        
        NSString *receiptToBeStored = storeReceipt ;
        if((latestReceipt != nil) && ![latestReceipt isEqualToString:@""]){
            receiptToBeStored = latestReceipt ;
        }
        
        SellAudio *sellAudio = [VeamUtil getSellAudioForProduct:productId] ;
        [VeamUtil setSellAudioReceipt:receiptToBeStored sellAudioId:sellAudio.sellAudioId] ;
        NSString *audioId = sellAudio.audioId ;
        [VeamUtil setAudioUrl:url audioId:audioId] ;
        [VeamUtil setAudioToken:token audioId:audioId] ;
        //NSLog(@"set url=%@ token=%@",url,token) ;
    }
    return verifyStatus ;
}

+ (BOOL)isSellAudioProduct:(NSString *)productId
{
    BOOL retValue = NO ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents isSellAudioProduct:productId] ;
    }
    return retValue ;
}

+ (SellAudio *)getSellAudioForProduct:(NSString *)productId
{
    SellAudio *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellAudioForProduct:productId] ;
    }
    return retValue ;
}

+ (void)setSellAudioPurchased:(BOOL)sellAudioPurchased
{
    [[AppDelegate sharedInstance] setSellAudioPurchased:sellAudioPurchased] ;
}

+ (BOOL)getSellAudioPurchased
{
    return [[AppDelegate sharedInstance] sellAudioPurchased] ;
}





















+ (BOOL)isTestPurchase
{
    NSString *testPurchaseTrue = @"1" ;
    NSString *testUrl = VEAM_SERVER_FORMAT ;
    NSRange range = [testUrl rangeOfString:@"//app-"] ;
    BOOL found = (range.location != NSNotFound) ;
    return found && [testPurchaseTrue isEqualToString:VEAM_IS_TEST_PURCHASE] ;
}

+ (NSString *)getPaymentTypeString:(NSString *)paymentTypeId price:(NSString *)price
{
    
    NSString *retValue = @"" ;
    if([paymentTypeId isEqualToString:VEAM_SUBSCRIPTION_KIND_MIXED_GRID]){
        if([price isEqualToString:@"0"]){
            retValue = NSLocalizedString(@"free_subscription",nil) ;
        } else {
            retValue = NSLocalizedString(@"subscription",nil) ;
        }
    } else if([paymentTypeId isEqualToString:VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS]){
        retValue = NSLocalizedString(@"pay_per_content",nil) ;
    } else if([paymentTypeId isEqualToString:VEAM_SUBSCRIPTION_KIND_SELL_SECTION]){
        retValue = NSLocalizedString(@"one_time_payment",nil) ;
    }
    
    return retValue ;
}






+ (NSArray *)getSellSectionItemsForCategory:(NSString *)sellSectionCategoryId
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellSectionItemsForCategory:sellSectionCategoryId] ;
    }
    return retValue ;
}

+ (NSArray *)getSellSectionItems
{
    NSArray *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellSectionItems] ;
    }
    return retValue ;
}

#define USERDEFAULT_KEY_SELL_SECTION_RECEIPT_FORMAT    @"SELL_SECTION_%@_RECEIPT"
+ (NSString *)getSellSectionReceiptKey:(NSString *)sellSectionId
{
    NSString *retValue = nil ;
    retValue = [NSString stringWithFormat:USERDEFAULT_KEY_SELL_SECTION_RECEIPT_FORMAT,sellSectionId] ;
    return retValue ;
}

+ (void)setSellSectionReceipt:(NSString *)sellSectionReceipt sellSectionId:(NSString *)sellSectionId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:sellSectionReceipt forKey:[VeamUtil getSellSectionReceiptKey:sellSectionId]] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getSellSectionReceipt:(NSString *)sellSectionId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *sellSectionReceipt = [userDefaults objectForKey:[VeamUtil getSellSectionReceiptKey:sellSectionId]] ;
    return sellSectionReceipt ;
}


// if forced == YES , the server is forced to use the apple verification server.
// if forced == NO , the server don't use the apple verification server in case of receipt is expired.
+ (NSInteger)verifySellSectionReceipt:(NSString *)storeReceipt clearIfExpired:(BOOL)clearIfExpired forced:(BOOL)forced
{
    //NSLog(@"verifySellSectionReceipt") ;
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone] ;
    NSInteger secondsFromGmt = [timeZone secondsFromGMT] ;
    
    NSInteger verifyStatus = VEAM_STORE_RECEIPT_VERIFY_FAILED ;
    NSString *urlString  = [NSString stringWithFormat:@"%@&r=%@&t=%d&f=%@&s=0",[VeamUtil getApiUrl:@"subscription/verifysellsectionreceipt"],storeReceipt,secondsFromGmt,forced?@"1":@"0"] ;
    //NSLog(@"urlString String url = %@",urlString) ;
    
    NSURL *urlForValidation = [NSURL URLWithString:urlString] ;
    NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:urlForValidation] ;
    [validationRequest setHTTPMethod:@"GET"] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil] ;
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] ;
    //NSLog(@"response=%@",responseString) ;
    
    NSArray *results = [responseString componentsSeparatedByString:@"\n"] ;
    if(([results count] >= 1) && [[results objectAtIndex:0] isEqualToString:@"EXPIRED"]){
        //NSLog(@"subscription has been expired") ;
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_EXPIRED ;
        if(clearIfExpired){
            //[VeamUtil setStoreReceipt:@""] ;
        }
    } else if(([results count] >= 3) && [[results objectAtIndex:0] isEqualToString:@"OK"]){
        verifyStatus = VEAM_STORE_RECEIPT_VERIFY_SUCCESS ;
        NSString *latestReceipt = [results objectAtIndex:1] ;
        NSString *productId = [results objectAtIndex:2] ; // co.veam.veam__APP_ID__.section.0
        
        NSString *receiptToBeStored = storeReceipt ;
        if((latestReceipt != nil) && ![latestReceipt isEqualToString:@""]){
            receiptToBeStored = latestReceipt ;
        }
        
        //SellVideo *sellVideo = [VeamUtil getSellVideoForProduct:productId] ;
        [VeamUtil setSellSectionReceipt:receiptToBeStored sellSectionId:@"0"] ;
    }
    return verifyStatus ;
}


+ (BOOL)isSellSectionProduct:(NSString *)productId
{
    BOOL retValue = NO ;
    NSString *sellSectionProductId = [VeamUtil getSellSectionProductId] ;
    if([sellSectionProductId isEqualToString:productId]){
        retValue = YES ;
    }
    return retValue ;
}

+ (void)setSellSectionPurchased:(BOOL)sellSectionPurchased
{
    [[AppDelegate sharedInstance] setSellSectionPurchased:sellSectionPurchased] ;
}

+ (BOOL)getSellSectionPurchased
{
    return [[AppDelegate sharedInstance] sellSectionPurchased] ;
}

+ (SellSectionItem *)getSellSectionItemForId:(NSString *)sellSectionItemId
{
    Video *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        retValue = [contents getSellSectionItemForId:sellSectionItemId] ;
    }
    return retValue ;
}



+ (NSString *)getSellSectionPaymentDescription
{
    NSString *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        NSString *description = [contents getValueForKey:@"section_payment_0_description"] ;
        retValue = description ;
    }
    return retValue ;
}

+ (NSString *)getSellSectionPaymentButtonText
{
    NSString *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        NSString *buttonText = [contents getValueForKey:@"section_payment_0_button_text"] ;
        if([VeamUtil isEmpty:buttonText]){
            buttonText = @"Tap to purchase" ;
        }
        retValue = buttonText ;
    }
    return retValue ;
}

+ (NSString *)getSellSectionProductId
{
    NSString *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        NSString *productId = [contents getValueForKey:@"section_0_product_id"] ;
        retValue = productId ;
    }
    return retValue ;
}

+ (NSString *)getSellSectionDescription
{
    NSString *retValue = nil ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        NSString *description = [contents getValueForKey:@"section_0_description"] ;
        retValue = description ;
    }
    return retValue ;
}

+ (NSInteger)getNumberOfPicturesBetweenAds
{
    NSInteger retValue = 0 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        NSString *numString = [contents getValueForKey:@"number_of_pictures_between_ads"] ;
        if(![VeamUtil isEmpty:numString]){
            retValue = [numString integerValue] ;
        }
    }
    return retValue ;
}

+ (NSInteger)getPictureNativeAdHeight
{
    NSInteger retValue = 280 ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    if(contents != nil){
        NSString *numString = [contents getValueForKey:@"picture_ad_height"] ;
        if(![VeamUtil isEmpty:numString]){
            retValue = [numString integerValue] ;
        }
    }
    return retValue ;
}




+ (BOOL)getSellSectionIsBought:(NSString *)index
{
    NSString *receipt = [VeamUtil getSellSectionReceipt:index] ;
    return ![VeamUtil isEmpty:receipt] ;
}





///////////////////////////////////////////////////////////////
#ifdef BUILD_VEAM_CONSOLE
+ (void)showSideMenu:(BOOL)launchFromPreview
{
    [[AppDelegate sharedInstance] showSideMenu:launchFromPreview] ;
}

+ (void)hideSideMenu
{
    [[AppDelegate sharedInstance] hideSideMenu] ;
}

+ (void)showFloatingMenu:(NSArray *)elements delegate:(id)delegate
{
    [[AppDelegate sharedInstance] showFloatingMenu:elements delegate:delegate] ;
}

+ (void)hideFloatingMenu
{
    [[AppDelegate sharedInstance] hideFloatingMenu] ;
}

+ (void)backToPreview
{
    [[AppDelegate sharedInstance] backToPreview] ;
}

+ (void)showFloatingMenuWithClassName:(NSString *)className instance:(id)instance
{
    [[AppDelegate sharedInstance] showFloatingMenuWithClassName:className instance:instance] ;
}

+ (void)didTapFloatingMenu:(NSInteger)index
{
    [[AppDelegate sharedInstance] didTapFloatingMenu:index] ;
}

+ (void)showStats
{
    [[AppDelegate sharedInstance] showStats] ;
}


///////////////////////////////////////////////////////////////
#else
///////////////////////////////////////////////////////////////
+ (void)showSideMenu{}
+ (void)hideSideMenu{}
+ (void)showFloatingMenu:(NSArray *)elements{}
+ (void)hideFloatingMenu{}
+ (void)backToPreview{}
+ (void)showFloatingMenuWithClassName:(NSString *)className instance:(id)instance{}
+ (void)didTapFloatingMenu:(NSInteger)index{}
+ (void)showStats{}
#endif
///////////////////////////////////////////////////////////////

/*
+ (void)kickKiip:(NSString *)rewardString
{
    //NSLog(@"kickKiip : %@",rewardString) ;
#if INCLUDE_KIIP==1
    //NSLog(@"implemented") ;
    Contents *contents = [[AppDelegate sharedInstance] contents] ;
    NSArray *exclusions = [NSArray array] ;
    if(contents != nil){
        NSString *exclusion = [contents getValueForKey:@"kiip_exclusion"] ;
        exclusions = [exclusion componentsSeparatedByString:@","] ;
    }
    
    BOOL excluded = NO ;
    int count = [exclusions count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *exclusion = [exclusions objectAtIndex:index] ;
        //NSLog(@"exlusion : %@",exclusion) ;
        if([exclusion isEqualToString:rewardString]){
            excluded = YES ;
            break ;
        }
    }
    
    if(!excluded){
        [[Kiip sharedInstance] saveMoment:rewardString withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
            if (error) {
                NSLog(@"something's wrong");
                // handle with an Alert dialog.
            }
            if (poptart) {
                [poptart show];
            }
            if (!poptart) {
                // handle logic when there is no reward to give.
            }
        }];
    } else {
        NSLog(@"excluded") ;
    }
#endif
}
*/


#ifndef DO_NOT_USE_ADMOB
+ (GADRequest *)getAdRequest
{
    GADRequest *request = [GADRequest request] ;
    request.testDevices = @[
                            kGADSimulatorID,
                            @"971bd67a8667a2f61b3c5fcb74f98b0a", // iPod 5
                            @"6096364a731a79f3211779c7c1004272", // iPhone 6
                            //@"7B75FC11-11A8-4C15-824B-D3497469B5BC",// iPhone 6 iOS 10.2
                            @"8a51dae04f2137dffb325c58b042e180", // iPad
                            @"d7d6bf7fd8dc23443cdfd0a88eb46b22" // iPod 4
                            ];
    return request ;
}
#endif

+ (NSString *)getApsEnvironmentString
{
    //NSLog(@"getEnvironmentString") ;
    NSString *retValue = @"P" ;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"embedded.mobileprovision" ofType:nil] ;
    NSString *xmlString = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:NULL] ;
    if(![VeamUtil isEmpty:xmlString]){
        //NSLog(@"getEnvironmentString xml=%@",xmlString) ;
        
        NSString *pattern = @"<key>aps-environment</key>\\s+<string>development</string>" ;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil] ;
        NSArray *matches = [regex matchesInString:xmlString options:0 range:NSMakeRange(0, xmlString.length)] ;
        if([matches count] > 0){
            retValue = @"D" ;
        }
    }
    
    //NSLog(@"retValue = %@",retValue) ;
    return retValue ;
    
}

+ (void)setDeviceToken:(NSString *)deviceToken environment:(NSString *)envString
{
    [VeamUtil setDeviceToken:deviceToken] ;
    [VeamUtil setDeviceTokenEnv:envString] ;
}

#define USERDEFAULT_KEY_DEVICE_TOKEN    @"DEVICE_TOKEN"
+ (void)setDeviceToken:(NSString *)deviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:deviceToken forKey:USERDEFAULT_KEY_DEVICE_TOKEN] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getDeviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *deviceToken = [userDefaults objectForKey:USERDEFAULT_KEY_DEVICE_TOKEN] ;
    return deviceToken ;
}

#define USERDEFAULT_KEY_DEVICE_TOKEN_ENV    @"DEVICE_TOKEN_ENV"
+ (void)setDeviceTokenEnv:(NSString *)deviceTokenEnv
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:deviceTokenEnv forKey:USERDEFAULT_KEY_DEVICE_TOKEN_ENV] ;
    [userDefaults synchronize] ;
}

+ (NSString *)getDeviceTokenEnv
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *deviceTokenEnv = [userDefaults objectForKey:USERDEFAULT_KEY_DEVICE_TOKEN_ENV] ;
    return deviceTokenEnv ;
}


@end
