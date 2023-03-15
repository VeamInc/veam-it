//
//  Web.h
//  veam31000000
//
//  Created by veam on 2/26/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface Web : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *webId ;
@property (nonatomic, retain) NSString *webCategoryId ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *url ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
