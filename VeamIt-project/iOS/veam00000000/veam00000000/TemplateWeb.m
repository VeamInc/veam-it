//
//  TemplateWeb.m
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "TemplateWeb.h"

@implementation TemplateWeb

@synthesize templateWebId ;
@synthesize title ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setTemplateWebId:[attributeDict objectForKey:@"id"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    
    return self ;
}

@end
