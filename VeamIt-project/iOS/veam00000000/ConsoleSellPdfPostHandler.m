//
//  ConsoleSellPdfPostHandler.m
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleSellPdfPostHandler.h"
#import "ConsoleUtil.h"

@implementation ConsoleSellPdfPostHandler

@synthesize sellPdf ;
@synthesize pdf ;

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            NSString *sellPdfId = [results objectAtIndex:1] ;
            NSString *pdfId = [results objectAtIndex:2] ;
            
            [sellPdf setSellPdfId:sellPdfId] ;
            [pdf setPdfId:pdfId] ;
        }
    }
}

@end
