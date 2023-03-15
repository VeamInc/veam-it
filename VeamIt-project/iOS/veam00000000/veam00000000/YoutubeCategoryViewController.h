//
//  YoutubeCategoryViewController.h
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

@interface YoutubeCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *categoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    BOOL hasNewVideo ;
    
    NSMutableDictionary *imageDownloadsInProgressForBulletin ;  // the set of ImageDownloader objects for each picture
    BOOL isAllYoutubeCategoryEmbed ;
    
    UITableViewCell *bannerCell ;

/*
#ifndef DO_NOT_USE_ADMOB
    GADBannerView *bannerView ;
#endif
*/
    
}

- (void)updateList ;

@end
