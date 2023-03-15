//
//  SellPdf.m
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellPdf.h"
#import "VeamUtil.h"

@implementation SellPdf

@synthesize sellPdfId ;
@synthesize pdfId ;
@synthesize productId ;
@synthesize price ;
@synthesize priceText ;
@synthesize description ;
@synthesize buttonText ;
@synthesize status ;
@synthesize statusText ;

- (BOOL)isBought
{
    NSString *receipt = [VeamUtil getSellPdfReceipt:sellPdfId] ;
    return ![VeamUtil isEmpty:receipt] ;
}

@end
