//
//  Picture.h
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject
{
}

@property (nonatomic, retain) NSString *pictureId ;
@property (nonatomic, retain) NSString *pictureUrl ;
@property (nonatomic, retain) NSString *ownerUserId ;
@property (nonatomic, retain) NSString *ownerName ;
@property (nonatomic, retain) NSString *ownerIconUrl ;
@property (nonatomic, retain) NSString *createdAt ;
@property (nonatomic, retain) NSMutableArray *comments ;
@property (nonatomic, assign) BOOL isLike ;
@property (nonatomic, assign) NSInteger numberOfLikes ;

- (NSInteger)getCommentIndexForId:(NSString *)commentId ;

@end
