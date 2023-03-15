//
//  ConsoleSellSectionItemPostHandler.m
//  veam00000000
//
//  Created by veam on 11/26/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleSellSectionItemPostHandler.h"

@implementation ConsoleSellSectionItemPostHandler

@synthesize sellSectionItem ;
@synthesize video ;
@synthesize pdf ;
@synthesize audio ;

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 6){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            NSString *sellSectionItemId = [results objectAtIndex:1] ;
            NSString *contentId = [results objectAtIndex:2] ;
            NSString *kind = [results objectAtIndex:3] ;
            NSString *status = [results objectAtIndex:4] ;
            NSString *statusText = [results objectAtIndex:5] ;
            
            [sellSectionItem setSellSectionItemId:sellSectionItemId] ;
            if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_VIDEO]){
                [video setVideoId:contentId] ;
            } else if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_PDF]){
                [pdf setPdfId:contentId] ;
            } else if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_AUDIO]){
                [audio setAudioId:contentId] ;
            }
            
            [sellSectionItem setStatus:status] ;
            [sellSectionItem setStatusText:statusText] ;
        }
        
    }
}

@end
