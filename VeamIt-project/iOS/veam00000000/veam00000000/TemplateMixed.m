//
//  TemplateMixed.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "TemplateMixed.h"

@implementation TemplateMixed

@synthesize templateMixedId ;
@synthesize title ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setTemplateMixedId:[attributeDict objectForKey:@"id"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    
    return self ;
}


- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 1){
        //NSLog(@"count >= 1") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
        }
    }
}


@end
