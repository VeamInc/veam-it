//
//  Forum.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Forum.h"

@implementation Forum

@synthesize forumId ;
@synthesize forumName ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;

    [self setForumId:[attributeDict objectForKey:@"id"]] ;
    [self setForumName:[attributeDict objectForKey:@"name"]] ;
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
            [self setForumId:[results objectAtIndex:1]] ;
            //NSLog(@"set forumId:%@",self.forumId) ;
        }
    }
}

@end
