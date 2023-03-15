//
//  Pictures.h
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"
#import "Comment.h"

@interface Pictures : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary* dictionary ;
    NSMutableArray* pictures ;
    BOOL isParsing ;
    BOOL lastPageLoaded ;
    
}

- (id)init ;
- (void)parseWithData:(NSData *)data ;
- (NSInteger)getNumberOfPictures ;
- (Picture *)getPictureAt:(NSInteger)index ;
- (void)addComment:(Comment *)comment ;
- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;
- (void)deletePicture:(Picture *)picture ;
- (BOOL)noMorePictures ;

@property (nonatomic, assign) NSInteger numberOfPicturesBetweenAds ;

@end
