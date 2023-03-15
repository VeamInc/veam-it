//
//  AlternativeImage.h
//  veam00000000
//
//  Created by veam on 5/23/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlternativeImage : NSObject

@property (nonatomic, retain) NSString *alternativeImageId ;
@property (nonatomic, retain) NSString *fileName ;
@property (nonatomic, retain) NSString *url ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
