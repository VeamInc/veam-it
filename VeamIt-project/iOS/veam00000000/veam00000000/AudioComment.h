//
//  AudioComment.h
//  veam31000016
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioComment : NSObject
{
}

@property (nonatomic, retain) NSString *commentId ;
@property (nonatomic, retain) NSString *audioId ;
@property (nonatomic, retain) NSString *ownerUserId ;
@property (nonatomic, retain) NSString *ownerName ;
@property (nonatomic, retain) NSString *comment ;


@end
