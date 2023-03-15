//
//  TemplateMixed.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface TemplateMixed : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *templateMixedId ;
@property (nonatomic, retain) NSString *title ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
