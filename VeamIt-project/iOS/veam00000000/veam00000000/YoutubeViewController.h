//
//  YoutubeViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"

/*
#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADBannerView.h>
#endif
*/

@interface YoutubeViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *youtubeListTableView ;
    NSInteger indexOffset ;
    NSArray *youtubes ;
    NSInteger lastIndex ;
    
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture

    UITableViewCell *bannerCell ;
    
/*
#ifndef DO_NOT_USE_ADMOB
    GADBannerView *bannerView ;
#endif
*/
    
}

@property (nonatomic, retain) NSString *categoryId ;
@property (nonatomic, retain) NSString *subCategoryId ;
@property (nonatomic, retain) NSString *categoryKind ;
@property (nonatomic, assign) BOOL showBackButton ;


@end
