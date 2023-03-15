//
//  VideoCategory.h
//  veam31000000
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface VideoCategory : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *videoCategoryId ;
@property (nonatomic, retain) NSString *name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
