//
//  MixedCategory.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface MixedCategory : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *mixedCategoryId ;
@property (nonatomic, retain) NSString *name ;
@property (nonatomic, retain) NSString *kind ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
