//
//  SellAudio.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellAudio : NSObject

@property (nonatomic, retain) NSString *sellAudioId ;
@property (nonatomic, retain) NSString *audioId ;
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
