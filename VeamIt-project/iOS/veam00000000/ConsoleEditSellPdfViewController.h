//
//  ConsoleEditSellPdfViewController.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditSellPdfViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleSwitchBarView *periodicalFlagInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
    ConsoleTextSelectBarView *priceSelectBarView ;
    NSArray *prices ;
    
    UIImage *thumbnailImage ;
}

@property(nonatomic,retain)PdfCategory *pdfCategory ;
@property(nonatomic,retain)PdfSubCategory *pdfSubCategory ;
@property(nonatomic,retain)Pdf *pdf ;
@property(nonatomic,retain)SellPdf *sellPdf ;
@property(nonatomic,assign)BOOL isSellSection ;

- (id)init ;

@end
