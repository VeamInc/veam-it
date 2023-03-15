//
//  MixedGridViewController.h
//  veam00000000
//
//  Created by veam on 7/7/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "AQGridView.h"
#import "ImageDownloader.h"
#import "Video.h"
#import "PreviewDownloader.h"

/*
#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADBannerView.h>
#endif
*/



@interface MixedGridViewController : VeamViewController<AQGridViewDelegate, AQGridViewDataSource,ImageDownloaderDelegate,PreviewDownloaderDelegate>
{
    NSArray *mixeds ;
    NSMutableDictionary *imageDownloadsInProgressForSmallImage ;
    BOOL isBought ;
    Video *currentVideo ;
    PreviewDownloader *previewDownloader ;
    
    UIView *poweredView ;
    UIView *dummyView ;
    BOOL shouldShowPowered ;
    BOOL contentShown ;
    
/*
#ifndef DO_NOT_USE_ADMOB
    GADBannerView *bannerView ;
#endif
*/
    
    UITableViewCell *bannerCell ;

}

@property (nonatomic, retain) AQGridView *gridView;

@end
