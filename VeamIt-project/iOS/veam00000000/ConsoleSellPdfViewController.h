//
//  ConsoleSellPdfViewController.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleSellPdfViewController : ConsoleViewController<UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfSellPdfs ;
    NSInteger indexToBeDeleted ;
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;
    NSTimer *updateTimer ;
    BOOL needTimer ;
    SellPdf *currentSellPdf ;
    BOOL isAppReleased ;
    NSArray *prices ;
    BOOL isSellSection ;
}

@property(nonatomic,retain)PdfCategory *pdfCategory ;
@property(nonatomic,retain)PdfSubCategory *pdfSubCategory ;
@property(nonatomic,assign)BOOL showCustomizeFirst ;


@end
