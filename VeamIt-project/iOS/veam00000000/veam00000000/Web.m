//
//  Web.m
//  veam31000000
//
//  Created by veam on 2/26/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "Web.h"

@implementation Web

@synthesize webId ;
@synthesize webCategoryId ;
@synthesize title ;
@synthesize url ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setWebId:[attributeDict objectForKey:@"id"]] ;
    [self setWebCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setUrl:[attributeDict objectForKey:@"u"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setWebId:[results objectAtIndex:1]] ;
            //NSLog(@"set webId:%@",self.webId) ;
        }
    }
}


@end
