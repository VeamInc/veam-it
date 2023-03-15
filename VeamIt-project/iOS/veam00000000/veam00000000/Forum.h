//
//  Forum.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface Forum : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *forumId ;
@property (nonatomic, retain) NSString *forumName ;
@property (nonatomic, retain) NSString *kind ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
