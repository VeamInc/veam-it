//
//  TemplateForum.m
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "TemplateForum.h"

@implementation TemplateForum

@synthesize templateForumId ;
@synthesize title ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setTemplateForumId:[attributeDict objectForKey:@"id"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    
    return self ;
}

@end
