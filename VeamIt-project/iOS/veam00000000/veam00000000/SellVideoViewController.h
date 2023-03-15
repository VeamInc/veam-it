//
//  SellVideoViewController.h
//  veam31000015
//
//  Created by veam on 4/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"
#import "PreviewDownloader.h"
#import "InAppPurchaseManager.h"


@interface SellVideoViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *sellListTableView ;
    NSInteger indexOffset ;
    NSArray *sellVideos ;
    NSInteger lastIndex ;
    
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture
    
    PreviewDownloader *previewDownloader ;

    UIActivityIndicatorView *indicator ;
    UIView *purchaseView ;
    UIView *thankyouView ;
    
    BOOL needReload ;

}

@property (nonatomic, retain) NSString *categoryId ;
@property (nonatomic, retain) NSString *subCategoryId ;


@end
