//
//  Video.h
//  veam31000000
//
//  Created by veam on 2/27/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"
#import "Mixed.h"

@interface Video : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) Mixed *mixed ;
@property (nonatomic, retain) NSString *videoId ;
@property (nonatomic, retain) NSString *duration ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *videoCategoryId ;
@property (nonatomic, retain) NSString *videoSubCategoryId ;
@property (nonatomic, retain) NSString *imageUrl ;
@property (nonatomic, retain) NSString *imageSize ;
@property (nonatomic, retain) NSString *dataUrl ;
@property (nonatomic, retain) NSString *dataSize ;
@property (nonatomic, retain) NSString *key ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *linkUrl ;
@property (nonatomic, retain) NSString *sourceUrl ;
@property (nonatomic, retain) NSString *createdAt ;
@property (nonatomic, retain) NSString *status ;
@property (nonatomic, retain) NSString *statusText ;


- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
