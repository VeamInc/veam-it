//
//  YoutubeCategory.h
//  veam31000000
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface YoutubeCategory : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *youtubeCategoryId ;
@property (nonatomic, retain) NSString *name ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *embed ;
@property (nonatomic, retain) NSString *embedUrl ;
@property (nonatomic, retain) NSString *disabled ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
