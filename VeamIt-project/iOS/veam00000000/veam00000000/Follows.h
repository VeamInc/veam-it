//
//  Follows.h
//  veam31000000
//
//  Created by veam on 2/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Follow.h"
#import "Comment.h"

@interface Follows : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary* dictionary ;
    NSMutableArray* follows ;
    BOOL isParsing ;
    BOOL lastPageLoaded ;
}

- (id)init ;
- (void)parseWithData:(NSData *)data ;
- (NSInteger)getNumberOfFollows ;
- (Follow *)getFollowAt:(NSInteger)index ;
- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;
- (void)deleteFollow:(Follow *)follow ;
- (BOOL)noMoreFollows ;

@end
