//
//  ConsoleSellPdfPostHandler.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellPdf.h"
#import "Pdf.h"

@interface ConsoleSellPdfPostHandler : NSObject

<HandlePostResultDelegate>

@property (nonatomic,retain) SellPdf *sellPdf ;
@property (nonatomic,retain) Pdf *pdf ;

@end
