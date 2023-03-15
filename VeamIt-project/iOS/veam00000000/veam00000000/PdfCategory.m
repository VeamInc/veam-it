//
//  PdfCategory.m
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "PdfCategory.h"
#import "VeamUtil.h"

@implementation PdfCategory

@synthesize pdfCategoryId ;
@synthesize name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setPdfCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setPdfCategoryId:[results objectAtIndex:1]] ;
            //NSLog(@"set PdfCategoryId:%@",self.PdfCategoryId) ;
        }
    }
}

@end
