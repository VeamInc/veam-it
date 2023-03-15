//
//  TemplateSubscription.h
//  veam00000000
//
//  Created by veam on 6/17/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface TemplateSubscription : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *templateSubscriptionId ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *layout ;
@property (nonatomic, retain) NSString *price ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *rightImageUrl ;
@property (nonatomic, retain) NSString *uploadSpan ;
@property (nonatomic, retain) NSString *isFree ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
