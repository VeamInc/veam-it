//
//  SellSectionCategory.h
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface SellSectionCategory : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *sellSectionCategoryId ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

- (NSString *)getTargetName ;

@end
