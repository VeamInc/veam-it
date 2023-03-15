//
//  AlternativeImage.m
//  veam00000000
//
//  Created by veam on 5/23/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AlternativeImage.h"

@implementation AlternativeImage

@synthesize alternativeImageId ;
@synthesize fileName ;
@synthesize url ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setAlternativeImageId:[attributeDict objectForKey:@"id"]] ;
    [self setFileName:[attributeDict objectForKey:@"f"]] ;
    [self setUrl:[attributeDict objectForKey:@"u"]] ;
    
    return self ;
}

@end
