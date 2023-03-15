//
//  RecipeCategory.m
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "RecipeCategory.h"

@implementation RecipeCategory

@synthesize recipeCategoryId ;
@synthesize name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setRecipeCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    
    return self ;
}

@end
