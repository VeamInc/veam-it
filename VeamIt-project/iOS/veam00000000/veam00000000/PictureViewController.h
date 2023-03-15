//
//  PictureViewController.h
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "Pictures.h"
#import "ImageDownloader.h"
#import "Three20/Three20.h"
#import "AppDelegate.h"

#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADBannerView.h>
#endif

@interface PictureViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate,LoginPendingOperationDelegate,TTNavigatorDelegate>
{
    Pictures *pictures ;
    UITableView *pictureListTableView ;
    UIActivityIndicatorView *indicator ;
    
    Picture *currentPicture ;
    NSInteger currentPageNo ;
    NSInteger numberOfPictures ;
    
    NSMutableDictionary *imageDownloadsInProgressForUser ;  // the set of ImageDownloader objects for each picture
    NSMutableDictionary *imageDownloadsInProgressForPicture ;  // the set of ImageDownloader objects for each picture
    
    BOOL isPostViewShown ;
    BOOL isUpdating ;
    BOOL isLikeSending ;
    
    NSInteger pendingOperation ;
    NSInteger pendingTag ;
    
    TTNavigator *ttNavigator ;
    
    NSMutableDictionary *showAllCommentsFlags ;
    
    UIImage *reportImage ;
    UIAlertView *reportAlertView ;
    UIAlertView *deleteAlertView ;
    NSString *currentReportMessage ;
    
    NSInteger targetSocialUserId ;
    
    UITableViewCell *bannerCell ;
    
    UIImageView *cameraButtonImageView ;
    
#ifndef DO_NOT_USE_ADMOB
    GADBannerView *bannerView ;
    GADNativeExpressAdView *nativeExpressAdView ;
#endif
    
    CGFloat nativeAdHeight ;
    CGFloat nativeAdCellHeight ;
    NSInteger numberOfPicturesBetweenAds ;
    NSMutableDictionary *pictureNativeViewCells ;
    NSMutableArray *pictureNativeAdLoadRows ;

}

@property (nonatomic, retain) NSString *forumId ;
@property (nonatomic, retain) NSString *forumKind ;
@property (nonatomic, assign) NSInteger targetSocialUserId ;

- (void)doPendingOperation ;

@end
