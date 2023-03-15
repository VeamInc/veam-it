//
//  ConsoleUpdatePreparingMixedStatusHandler.m
//  veam00000000
//
//  Created by veam on 1/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleUpdatePreparingMixedStatusHandler.h"
#import "ConsoleUtil.h"

@implementation ConsoleUpdatePreparingMixedStatusHandler

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
                if([values count] >= 4){
                    NSString *mixedId = [values objectAtIndex:0] ;
                    NSString *status = [values objectAtIndex:1] ;
                    NSString *statusText = [values objectAtIndex:2] ;
                    NSString *thumbnailUrl = [values objectAtIndex:3] ;
                    Mixed *mixed = [contents getMixedForId:mixedId] ;
                    if(mixed != nil){
                        [mixed setStatus:status] ;
                        [mixed setStatusText:statusText] ;
                        [mixed setThumbnailUrl:thumbnailUrl] ;
                    }
                }
            }
        }
    }
}

@end
