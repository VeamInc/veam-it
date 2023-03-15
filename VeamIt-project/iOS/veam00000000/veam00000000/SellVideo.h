//
//  SellVideo.h
//  veam31000015
//
//  Created by veam on 4/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellVideo : NSObject

@property (nonatomic, retain) NSString *sellVideoId ;
@property (nonatomic, retain) NSString *videoId ;
@property (nonatomic, retain) NSString *productId ;
@property (nonatomic, retain) NSString *price ;
@property (nonatomic, retain) NSString *priceText ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *buttonText ;
@property (nonatomic, retain) NSString *status ;
@property (nonatomic, retain) NSString *statusText ;

- (BOOL)isBought ;
- (BOOL)isDownloaded ;

@end
