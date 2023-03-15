//
//  AppInfo.m
//  veam00000000
//
//  Created by veam on 6/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

@synthesize appId ;
@synthesize name ;
@synthesize storeAppName ;
@synthesize category ;
@synthesize subCategory ;
@synthesize description ;
@synthesize keyword ;
@synthesize backgroundImageUrl ;
@synthesize splashImageUrl ;
@synthesize iconImageUrl ;
@synthesize screenShot1Url ;
@synthesize screenShot2Url ;
@synthesize screenShot3Url ;
@synthesize screenShot4Url ;
@synthesize screenShot5Url ;
@synthesize status ;
@synthesize statusText ;
@synthesize termsAcceptedAt ;
@synthesize releasedAt ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setAppId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"n"]] ;
    [self setStoreAppName:[attributeDict objectForKey:@"sn"]] ;
    [self setCategory:[attributeDict objectForKey:@"c"]] ;
    [self setSubCategory:[attributeDict objectForKey:@"sc"]] ;
    [self setDescription:[attributeDict objectForKey:@"d"]] ;
    [self setKeyword:[attributeDict objectForKey:@"k"]] ;
    [self setBackgroundImageUrl:[attributeDict objectForKey:@"bu"]] ;
    [self setSplashImageUrl:[attributeDict objectForKey:@"su"]] ;
    [self setIconImageUrl:[attributeDict objectForKey:@"iu"]] ;
    [self setScreenShot1Url:[attributeDict objectForKey:@"s1"]] ;
    [self setScreenShot2Url:[attributeDict objectForKey:@"s2"]] ;
    [self setScreenShot3Url:[attributeDict objectForKey:@"s3"]] ;
    [self setScreenShot4Url:[attributeDict objectForKey:@"s4"]] ;
    [self setScreenShot5Url:[attributeDict objectForKey:@"s5"]] ;
    [self setStatus:[attributeDict objectForKey:@"st"]] ;
    [self setStatusText:[attributeDict objectForKey:@"stt"]] ;
    [self setTermsAcceptedAt:[attributeDict objectForKey:@"at"]] ;
    [self setReleasedAt:[attributeDict objectForKey:@"rt"]] ;
    [self setModified:[attributeDict objectForKey:@"mo"]] ;
    
    return self ;
}


- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 10){
        //NSLog(@"count >= 10") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setAppId:[results objectAtIndex:1]] ;
            [self setBackgroundImageUrl:[results objectAtIndex:2]] ;
            [self setSplashImageUrl:[results objectAtIndex:3]] ;
            [self setIconImageUrl:[results objectAtIndex:4]] ;
            [self setScreenShot1Url:[results objectAtIndex:5]] ;
            [self setScreenShot2Url:[results objectAtIndex:6]] ;
            [self setScreenShot3Url:[results objectAtIndex:7]] ;
            [self setScreenShot4Url:[results objectAtIndex:8]] ;
            [self setScreenShot5Url:[results objectAtIndex:9]] ;
            //NSLog(@"set backgroundImageUrl:%@",self.backgroundImageUrl) ;
            //NSLog(@"set splashImageUrl:%@",self.splashImageUrl) ;
            //NSLog(@"set iconImageUrl:%@",self.iconImageUrl) ;
        }
    }
}

@end
