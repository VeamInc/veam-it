//
//  MixedSubCategory.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface MixedSubCategory : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *mixedSubCategoryId ;
@property (nonatomic, retain) NSString *mixedCategoryId ;
@property (nonatomic, retain) NSString *name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
