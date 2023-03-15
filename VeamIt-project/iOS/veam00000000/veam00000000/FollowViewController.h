//
//  FollowViewController.h
//  veam31000000
//
//  Created by veam on 2/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"
#import "ImageDownloader.h"
#import "Follows.h"

@interface FollowViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    
    NSInteger indexOffset ;
    NSArray *recipes ;
    NSInteger lastIndex ;

    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture
    
    
    
    
    Follows *follows ;
    UITableView *followListTableView ;
    UIActivityIndicatorView *indicator ;
    
    NSInteger currentPageNo ;
    NSInteger numberOfFollows ;
    
    NSMutableDictionary *imageDownloadsInProgressForUser ;  // the set of ImageDownloader objects for each picture
    
    BOOL isUpdating ;
    
    NSInteger targetSocialUserId ;
    
}

@property (nonatomic, retain) NSString *socialUserId ;
@property (nonatomic, assign) NSInteger followKind ;
@property (nonatomic, retain) NSString *pictureId ;

@end
