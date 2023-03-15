//
//  SellPdf.h
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellPdf : NSObject

@property (nonatomic, retain) NSString *sellPdfId ;
@property (nonatomic, retain) NSString *pdfId ;
@property (nonatomic, retain) NSString *productId ;
@property (nonatomic, retain) NSString *price ;
@property (nonatomic, retain) NSString *priceText ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *buttonText ;
@property (nonatomic, retain) NSString *status ;
@property (nonatomic, retain) NSString *statusText ;

- (BOOL)isBought ;
- (BOOL)isDownloaded ;

@end
