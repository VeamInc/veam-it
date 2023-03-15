//
//  ConsoleSellVideoPostHandler.m
//  veam00000000
//
//  Created by veam on 11/4/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleSellVideoPostHandler.h"
#import "ConsoleUtil.h"

@implementation ConsoleSellVideoPostHandler

@synthesize sellVideo ;
@synthesize video ;

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            NSString *sellVideoId = [results objectAtIndex:1] ;
            NSString *videoId = [results objectAtIndex:2] ;
            
            [sellVideo setSellVideoId:sellVideoId] ;
            [video setVideoId:videoId] ;
        }
    }
}

@end
