//
//  AppCreatorMessages.h
//  veam31000015
//
//  Created by veam on 10/28/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppCreatorMessage.h"

#define MESSAGES_KEY_IS_BLOCKED @"is_blocked"

@interface AppCreatorMessages : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary* dictionary ;
    NSMutableArray* messages ;
    BOOL isParsing ;
    BOOL lastPageLoaded ;
    
    NSInteger latestAddCount ;
    
    NSString *previousDateString ;
    
    BOOL shouldGenerateDateElement ;
}

@property (nonatomic, retain) NSString *appCreatorName ;
@property (nonatomic, retain) NSString *mcnName ;

- (id)init ;
- (void)parseWithData:(NSData *)data generateDateElement:(BOOL)generate ;
- (NSInteger)getNumberOfMessages ;
- (AppCreatorMessage *)getMessageAt:(NSInteger)index ;
- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;
- (void)deleteMessage:(AppCreatorMessage *)message ;
- (BOOL)noMoreMessages ;
- (NSInteger)getLatestAddCount ;

@end
