//
//  Youtube.h
//  veam31000000
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"
#import "Mixed.h"

@interface Youtube : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) Mixed *mixed ;
@property (nonatomic, retain) NSString *youtubeId ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *duration ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *youtubeCategoryId ;
@property (nonatomic, retain) NSString *youtubeSubCategoryId ;
@property (nonatomic, retain) NSString *youtubeVideoId ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *isNew ;
@property (nonatomic, retain) NSString *linkUrl ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
