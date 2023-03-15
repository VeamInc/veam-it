//
//  SellVideo.m
//  veam31000015
//
//  Created by veam on 4/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellVideo.h"
#import "VeamUtil.h"

@implementation SellVideo

@synthesize sellVideoId ;
@synthesize videoId ;
@synthesize productId ;
@synthesize price ;
@synthesize priceText ;
@synthesize description ;
@synthesize buttonText ;
@synthesize status ;
@synthesize statusText ;

- (BOOL)isBought
{
    NSString *receipt = [VeamUtil getSellVideoReceipt:sellVideoId] ;
    return ![VeamUtil isEmpty:receipt] ;
}

- (BOOL)isDownloaded
{
    BOOL retValue = NO ;
    Video *video = [VeamUtil getVideoForId:videoId] ;
    if(video){
        //NSLog(@"%@ tapped",[downloadableVideo title]) ;
        if([VeamUtil videoExists:video]){
            retValue = YES ;
        }
    }
    return retValue ;
}

@end
