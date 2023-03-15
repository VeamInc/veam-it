//
//  SellPdfViewController.h
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"
#import "ImageDownloader.h"
#import "InAppPurchaseManager.h"

@interface SellPdfViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *sellListTableView ;
    NSInteger indexOffset ;
    NSArray *sellPdfs ;
    NSInteger lastIndex ;
    
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture
    
    UIActivityIndicatorView *indicator ;
    UIView *purchaseView ;
    UIView *thankyouView ;
    
    BOOL needReload ;
    
}

@property (nonatomic, retain) NSString *categoryId ;
@property (nonatomic, retain) NSString *subCategoryId ;


@end
