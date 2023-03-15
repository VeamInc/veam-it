//
//  Pictures.h
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileData : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary* dictionary ;
    BOOL isParsing ;

    NSString *socialUserId ;
    NSString *name ;
    NSString *description ;
    NSString *imageUrl ;
    NSInteger numberOfPosts ;
    NSInteger numberOfFollowers ;
    NSInteger numberOfFollowings ;
    
    BOOL isFollowing ;
}

@property (nonatomic, retain) NSString *socialUserId ;
@property (nonatomic, retain) NSString *name ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *imageUrl ;
@property (nonatomic, assign) NSInteger numberOfPosts ;
@property (nonatomic, assign) NSInteger numberOfFollowers ;
@property (nonatomic, assign) NSInteger numberOfFollowings ;
@property (nonatomic, assign) BOOL isFollowing ;

- (id)init ;
- (void)parseWithData:(NSData *)data ;
- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;

@end
