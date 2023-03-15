//
//  SellItemCategory.h
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface SellItemCategory : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *sellItemCategoryId ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *targetCategoryId ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

- (NSString *)getTargetName ;

@end
