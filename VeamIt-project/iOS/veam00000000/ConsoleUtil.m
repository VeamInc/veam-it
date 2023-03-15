//
//  ConsoleUtil.m
//  veam00000000
//
//  Created by veam on 6/2/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleUtil.h"
#import "AppDelegate.h"
#import "ConsolePostData.h"
#import "VeamUtil.h"

@implementation ConsoleUtil

+ (NSURL *)getApiUrl:(NSString *)apiName
{
    return [NSURL URLWithString:[NSString stringWithFormat:CONSOLE_SERVER_FORMAT,apiName,[ConsoleUtil getAppId],[VeamUtil getLanguageId],CONSOLE_API_CALL_VERSION]] ;
}

+ (NSURL *)getUploadApiUrl:(NSString *)apiName
{
    return [NSURL URLWithString:[NSString stringWithFormat:CONSOLE_UPLOAD_SERVER_FORMAT,apiName,[ConsoleUtil getAppId],[VeamUtil getLanguageId],CONSOLE_API_CALL_VERSION]] ;
}

+ (NSString *)getAppId
{
    NSString *appId = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_APP_ID] ;
    return appId ;
}

+ (NSString *)getMcnId
{
    NSString *appId = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_MCN_ID] ;
    return appId ;
}

+ (void)postContentsUpdateNotification
{
    [ConsoleUtil postContentsUpdateNotification:nil] ;
}

+ (void)postContentsUpdateNotification:(NSDictionary *)userInfo
{
    //NSLog(@"ConsoleUtil::postContentsUpdateNotification userInfo is %@",(userInfo == nil)?@"nil":@"not nil") ;
    //NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"HOGE" forKey:@"KEY"] ;
    NSNotification *notification = [NSNotification notificationWithName:CONSOLE_CONTENTS_UPDATED_NOTIFICATION_ID object:self userInfo:userInfo] ;
    [[NSNotificationCenter defaultCenter] postNotification:notification] ;
}

+ (void)postRequestPostedNotification:(NSDictionary *)userInfo
{
    NSNotification *notification = [NSNotification notificationWithName:CONSOLE_REQUEST_POSTED_NOTIFICATION_ID object:self userInfo:userInfo] ;
    [[NSNotificationCenter defaultCenter] postNotification:notification] ;
}

+ (ConsoleContents *)getConsoleContents
{
    return [[AppDelegate sharedInstance] consoleContents] ;
}

+ (void)showPreview
{
    return [[AppDelegate sharedInstance] showPreview] ;
}

+ (void)showHome
{
    return [[AppDelegate sharedInstance] showHome] ;
}

+ (void)restartHome
{
    return [[AppDelegate sharedInstance] restartConsoleHome] ;
}

+ (void)setNewIcon:(UIImage *)iconImage
{
    return [[AppDelegate sharedInstance] setAppIconImage:iconImage] ;
}

+ (UIImage *)getNewIcon
{
    AppDelegate *appDelegate = [AppDelegate sharedInstance] ;
    
    return appDelegate.appIconImage ;
}


+ (void)preparePreview
{
    return [[AppDelegate sharedInstance] updateContents] ;
}

+ (BOOL)isConsoleLoggedin
{
    NSString *appId = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_APP_ID] ;
    //NSLog(@"isConsoleLoggedin %@",appId) ;
    return ![VeamUtil isEmpty:appId] ;
}

+ (void)logout
{
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_APP_ID value:@""] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_APP_SECRET value:@""] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_USERNAME value:@""] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD value:@""] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_USER_PRIVILAGES value:@"0"] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_MCN_ID value:@""] ;
}

+ (NSData *)getDataFrom:(ConsolePostData *)postData
{
    NSURL *url = [ConsoleUtil getApiUrl:[postData apiName]] ;
    NSArray *keys = [[postData params] allKeys] ;
    keys =[keys sortedArrayUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
        return [string1 localizedCaseInsensitiveCompare:string2] ;
    }] ;
    int count = [keys count] ;
    NSString *planeText = @"CONSOLE" ;
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url] ;
    [request setHTTPMethod: @"POST"] ;
    NSString *boundary = @"0x0hHai1CanHazB0undar135" ;
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] ;
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    
    for(int index = 0 ; index < count ; index++) {
        NSString *key = [keys objectAtIndex:index] ;
        NSString *value = [postData.params objectForKey:key] ;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]] ;
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]] ;
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
        [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]] ;
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
        planeText = [planeText stringByAppendingFormat:@"_%@",value] ;
    }
    
    NSString *signature = [VeamUtil sha1:planeText] ;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"Content-Disposition: form-data; name=\"s\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[signature dataUsingEncoding:NSUTF8StringEncoding]] ;
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    
    
    if(postData.image != nil){
        NSData *imageData = UIImagePNGRepresentation(postData.image) ;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]] ;
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"image.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]    ] ;
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]] ;
        [body appendData:imageData] ;
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]] ;
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]] ;
    
    [request setHTTPBody:body] ;
    
    //NSLog(@"url=%@",url.absoluteString) ;
    //NSLog(@"body=%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]) ;
    NSURLResponse *response = nil ;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] ;
    
    NSString *error_str = [error localizedDescription];
    if (0 != [error_str length]) {
        //NSLog(@"error=%@",error_str) ;
    }

    return data ;
}

+ (NSArray *)doPost:(ConsolePostData *)postData
{
    //NSLog(@"doPost %@",[postData apiName]) ;
    
    NSArray *results = nil ;
    NSString *status = @"0" ;
    
    NSData *data = [self getDataFrom:postData] ;
    
    // error
    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    //NSLog(@"resultString=%@",resultString) ;
    results = [resultString componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    if([results count] >= 1){
        if([[results objectAtIndex:0] isEqualToString:@"OK"]){
            status = @"1" ;
            //NSLog(@"RESPONSE:OK") ;
            if(postData.handlePostResultDelegate != nil){
                //NSLog(@"call handlePostResultDelegate") ;
                [postData.handlePostResultDelegate handlePostResult:results] ;
            }
        } else {
            //NSLog(@"NOT OK") ;
            int count = [results count] ;
            for(int index = 0 ; index < count ; index++){
                //NSLog(@"%d:%@",index,[results objectAtIndex:index]) ;
            }
        }
    } else {
        //NSLog(@"NO RESPONSE") ;
    }
    //NSLog(@"doPost end") ;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary] ;
    [userInfo setObject:postData.apiName forKey:@"API_NAME"] ;
    [userInfo setObject:status forKey:@"STATUS"] ;
    [userInfo setObject:postData.params forKey:@"PARAMS"] ;
    [ConsoleUtil postRequestPostedNotification:userInfo] ;
    
    return results ;
}

+ (void)updateConsoleContents
{
    [[AppDelegate sharedInstance] updateConsoleContents] ;
}

+ (void)clearPreviewData
{
    //NSLog(@"didTapPreviewClearData") ;
    [VeamUtil setStoreReceipt:@"" index:[VeamUtil getSubscriptionIndex]] ;
    [VeamUtil setSubscriptionStartTime:@"" index:[VeamUtil getSubscriptionIndex]] ;
    [VeamUtil setSubscriptionEndTime:@"" index:[VeamUtil getSubscriptionIndex]] ;
    
    NSArray *sellVideos = [VeamUtil getSellVideos] ;
    int count = [sellVideos count] ;
    for(int index = 0 ; index < count ; index++){
        SellVideo *sellVideo = [sellVideos objectAtIndex:index] ;
        if(sellVideo){
            [VeamUtil setSellVideoReceipt:@"" sellVideoId:sellVideo.sellVideoId] ;
        }
    }
    
    [VeamUtil setSocialUserId:0] ;
    [VeamUtil setSocialUserKind:0] ;
    [VeamUtil setFacebookUserName:@""] ;
    [VeamUtil setTwitterUserName:@""] ;

    [VeamUtil setFavoritesForKind:VEAM_FAVORITE_KIND_YOUTUBE value:@""] ;
    [VeamUtil setFavoritesForKind:VEAM_FAVORITE_KIND_MIXED value:@""] ;
    [VeamUtil setFavoritesForKind:VEAM_FAVORITE_KIND_PICTURE value:@""] ;
    [VeamUtil setFavoritesForKind:VEAM_FAVORITE_KIND_VIDEO value:@""] ;
    [VeamUtil setFavoritesForKind:VEAM_FAVORITE_KIND_RECIPE value:@""] ;
    
    [VeamUtil setSellSectionReceipt:@"" sellSectionId:@"0"] ;
}

+ (BOOL)hasUserPrivilage:(NSInteger)privilage
{
    BOOL retValue = NO ;
    NSString *privilagesString = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USER_PRIVILAGES] ;
    NSInteger privilages = [privilagesString integerValue] ;
    if((privilages & privilage) != 0){
        retValue = YES ;
    }
    return retValue ;
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

+ (NSArray *)getPrices
{
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *priceKey = @"subscription_prices" ;
    if([ConsoleUtil isLocaleJapanese]){
        priceKey = @"subscription_prices_ja" ;
    }
    return [[contents getValueForKey:priceKey] componentsSeparatedByString:@"|"] ;
}


+ (BOOL)isAppReleased
{
    BOOL isAppReleased = NO ;
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *appStatus = contents.appInfo.status ;
    //NSLog(@"appStatus=%@",appStatus) ;
    if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_RELEASED]){
        isAppReleased = YES ;
    }
    return isAppReleased ;
}


@end
