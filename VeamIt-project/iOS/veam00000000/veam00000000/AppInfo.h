//
//  AppInfo.h
//  veam00000000
//
//  Created by veam on 6/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface AppInfo : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *appId ;
@property (nonatomic, retain) NSString *name ;
@property (nonatomic, retain) NSString *storeAppName ;
@property (nonatomic, retain) NSString *category ;
@property (nonatomic, retain) NSString *subCategory ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *keyword ;
@property (nonatomic, retain) NSString *backgroundImageUrl ;
@property (nonatomic, retain) NSString *splashImageUrl ;
@property (nonatomic, retain) NSString *iconImageUrl ;
@property (nonatomic, retain) NSString *screenShot1Url ;
@property (nonatomic, retain) NSString *screenShot2Url ;
@property (nonatomic, retain) NSString *screenShot3Url ;
@property (nonatomic, retain) NSString *screenShot4Url ;
@property (nonatomic, retain) NSString *screenShot5Url ;
@property (nonatomic, retain) NSString *status ;
@property (nonatomic, retain) NSString *statusText ;
@property (nonatomic, retain) NSString *termsAcceptedAt ;
@property (nonatomic, retain) NSString *releasedAt ;
@property (nonatomic, retain) NSString *modified ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end