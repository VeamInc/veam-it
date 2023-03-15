//
//  ConsoleSellVideoPostHandler.h
//  veam00000000
//
//  Created by veam on 11/4/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellVideo.h"
#import "Video.h"

@interface ConsoleSellVideoPostHandler : NSObject<HandlePostResultDelegate>

@property (nonatomic,retain) SellVideo *sellVideo ;
@property (nonatomic,retain) Video *video ;

@end
