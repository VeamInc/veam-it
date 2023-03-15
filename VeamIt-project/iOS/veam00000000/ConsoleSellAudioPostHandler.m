//
//  ConsoleSellAudioPostHandler.m
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleSellAudioPostHandler.h"

@implementation ConsoleSellAudioPostHandler

@synthesize sellAudio ;
@synthesize audio ;

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            NSString *sellAudioId = [results objectAtIndex:1] ;
            NSString *audioId = [results objectAtIndex:2] ;
            
            [sellAudio setSellAudioId:sellAudioId] ;
            [audio setAudioId:audioId] ;
        }
    }
}

@end
