//
//  Picture.m
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Picture.h"
#import "Comment.h"

@implementation Picture


@synthesize pictureId ;
@synthesize pictureUrl ;
@synthesize ownerUserId ;
@synthesize ownerName ;
@synthesize ownerIconUrl ;
@synthesize createdAt ;
@synthesize comments ;
@synthesize isLike ;
@synthesize numberOfLikes ;

- (id)init
{
    self = [super init] ;
    if(self != nil){
        comments = [[NSMutableArray alloc] init] ;
        isLike = NO ;
    }
    return self ;
}


- (NSInteger)getCommentIndexForId:(NSString *)commentId
{
    NSInteger retValue = -1 ;
    NSInteger count = [comments count] ;
    for(int index = 0 ; index < count ; index++){
        Comment *comment = [comments objectAtIndex:index] ;
        if([[comment commentId] isEqualToString:commentId]){
            retValue = index ;
            break ;
        }
    }
    return retValue ;
}

@end
