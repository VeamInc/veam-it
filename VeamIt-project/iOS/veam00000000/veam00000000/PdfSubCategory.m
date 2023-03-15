//
//  PdfSubCategory.m
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "PdfSubCategory.h"

@implementation PdfSubCategory

@synthesize pdfSubCategoryId ;
@synthesize pdfCategoryId ;
@synthesize name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setPdfSubCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    [self setPdfCategoryId:[attributeDict objectForKey:@"c"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setPdfSubCategoryId:[results objectAtIndex:1]] ;
            //NSLog(@"set pdfSubCategoryId:%@",self.pdfSubCategoryId) ;
        }
    }
}


@end

