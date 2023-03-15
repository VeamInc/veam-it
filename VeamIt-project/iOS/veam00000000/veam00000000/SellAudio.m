//
//  SellAudio.m
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellAudio.h"
#import "VeamUtil.h"

@implementation SellAudio

@synthesize sellAudioId ;
@synthesize audioId ;
@synthesize productId ;
@synthesize price ;
@synthesize priceText ;
@synthesize description ;
@synthesize buttonText ;
@synthesize status ;
@synthesize statusText ;

- (BOOL)isBought
{
    NSString *receipt = [VeamUtil getSellAudioReceipt:sellAudioId] ;
    return ![VeamUtil isEmpty:receipt] ;
}

@end
