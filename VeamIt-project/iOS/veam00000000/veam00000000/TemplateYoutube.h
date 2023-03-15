//
//  TemplateYoutube.h
//  veam00000000
//
//  Created by veam on 6/3/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface TemplateYoutube : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *templateYoutubeId ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *embedFlag ;
@property (nonatomic, retain) NSString *embedUrl ;
@property (nonatomic, retain) NSString *leftImageUrl ;
@property (nonatomic, retain) NSString *rightImageUrl ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
