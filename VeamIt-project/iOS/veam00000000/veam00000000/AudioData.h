//
//  AudioData.h
//  veam31000016
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioComment.h"

@interface AudioData : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary* dictionary ;
    BOOL isParsing ;
    NSMutableArray *comments ;
    BOOL isLike ;
    NSInteger numberOfLikes ;
}

@property (nonatomic, retain) NSString *contentVideoId ;
@property (nonatomic, retain) NSMutableArray *comments ;
@property (nonatomic, assign) BOOL isLike ;
@property (nonatomic, assign) NSInteger numberOfLikes ;

- (NSInteger)getCommentIndexForId:(NSString *)commentId ;
- (id)init ;
- (void)parseWithData:(NSData *)data ;
- (NSInteger)getNumberOfComments ;
- (AudioComment *)getCommentAt:(NSInteger)index ;
- (void)addComment:(AudioComment *)comment ;
- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;

@end
