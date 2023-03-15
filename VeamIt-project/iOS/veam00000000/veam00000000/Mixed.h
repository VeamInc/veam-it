//
//  Mixed.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface Mixed : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *mixedId ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *mixedCategoryId ;
@property (nonatomic, retain) NSString *mixedSubCategoryId ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *contentId ;
@property (nonatomic, retain) NSString *thumbnailUrl ;
@property (nonatomic, retain) NSString *createdAt ;
@property (nonatomic, retain) NSString *displayType ;
@property (nonatomic, retain) NSString *displayName ;
@property (nonatomic, retain) NSString *status ;
@property (nonatomic, retain) NSString *statusText ;

@property (nonatomic, retain) NSString *deadlineString ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
