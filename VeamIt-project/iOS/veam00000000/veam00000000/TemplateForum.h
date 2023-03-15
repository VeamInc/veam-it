//
//  TemplateForum.h
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateForum : NSObject

@property (nonatomic, retain) NSString *templateForumId ;
@property (nonatomic, retain) NSString *title ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
