//
//  ConsoleUtil.h
//  veam00000000
//
//  Created by veam on 6/2/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsoleContents.h"
#import "ConsolePostData.h"

@interface ConsoleUtil : NSObject

+ (NSURL *)getApiUrl:(NSString *)apiName ;
+ (NSURL *)getUploadApiUrl:(NSString *)apiName ;
+ (NSString *)getAppId ;
+ (void)postContentsUpdateNotification ;
+ (void)postContentsUpdateNotification:(NSDictionary *)userInfo ;
+ (void)postRequestPostedNotification:(NSDictionary *)userInfo ;
+ (ConsoleContents *)getConsoleContents ;
+ (void)preparePreview ;
+ (void)showPreview ;
+ (void)showHome ;
+ (void)restartHome ;
+ (void)setNewIcon:(UIImage *)iconImage ;
+ (UIImage *)getNewIcon ;
+ (NSData *)getDataFrom:(ConsolePostData *)postData ;
+ (NSArray *)doPost:(ConsolePostData *)postData ;
+ (BOOL)isConsoleLoggedin ;
+ (void)updateConsoleContents ;
+ (void)clearPreviewData ;
+ (void)logout ;
+ (BOOL)hasUserPrivilage:(NSInteger)privilage ;
+ (BOOL)isLocaleJapanese ;
+ (NSArray *)getPrices ;
+ (BOOL)isAppReleased ;

@end
