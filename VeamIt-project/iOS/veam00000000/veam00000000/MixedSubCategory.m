//
//  MixedSubCategory.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "MixedSubCategory.h"

@implementation MixedSubCategory

@synthesize mixedSubCategoryId ;
@synthesize mixedCategoryId ;
@synthesize name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setMixedSubCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    [self setMixedCategoryId:[attributeDict objectForKey:@"c"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setMixedSubCategoryId:[results objectAtIndex:1]] ;
            //NSLog(@"set mixedSubCategoryId:%@",self.mixedSubCategoryId) ;
        }
    }
}

@end
