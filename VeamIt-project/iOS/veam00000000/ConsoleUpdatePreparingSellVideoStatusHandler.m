
//  ConsoleUpdatePreparingSellVideoStatusHandler.m
//  veam00000000
//
//  Created by veam on 11/2/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleUpdatePreparingSellVideoStatusHandler.h"
#import "ConsoleUtil.h"

@implementation ConsoleUpdatePreparingSellVideoStatusHandler

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
            NSString *elementString = [results objectAtIndex:1] ;
            //NSLog(@"elementString=%@",elementString) ;
            NSArray *elements = [elementString componentsSeparatedByString:@","] ;
            int numberOfElements = [elements count] ;
            for(int index = 0 ; index < numberOfElements ; index++){
                NSString *valueString = [elements objectAtIndex:index] ;
                NSArray *values = [valueString componentsSeparatedByString:@"|"] ;
                if([values count] >= 3){
                    NSString *sellVideoId = [values objectAtIndex:0] ;
                    NSString *status = [values objectAtIndex:1] ;
                    NSString *statusText = [values objectAtIndex:2] ;
                    SellVideo *sellVideo = [contents getSellVideoForId:sellVideoId] ;
                    if(sellVideo != nil){
                        [sellVideo setStatus:status] ;
                        [sellVideo setStatusText:statusText] ;
                    }
                } else {
                    //NSLog(@"%@ less than 3",valueString) ;
                }
            }
        }
    }
}

@end
