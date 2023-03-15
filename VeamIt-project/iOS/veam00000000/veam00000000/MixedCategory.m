//
//  MixedCategory.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "MixedCategory.h"

@implementation MixedCategory

@synthesize mixedCategoryId ;
@synthesize name ;
@synthesize kind ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setMixedCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    [self setKind:[attributeDict objectForKey:@"kind"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setMixedCategoryId:[results objectAtIndex:1]] ;
            //NSLog(@"set mixedCategoryId:%@",self.mixedCategoryId) ;
        }
    }
}

@end
