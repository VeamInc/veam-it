//
//  VideoViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"
#import "VideoDownloader.h"
#import "PreviewDownloader.h"

@interface VideoViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate,PreviewDownloaderDelegate>
{
    UITableView *videoListTableView ;
    NSInteger indexOffset ;
    NSArray *videos ;
    NSInteger lastIndex ;
    
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture
    NSMutableDictionary *videoDownloadsInProgress ;  // the set of ImageDownloader objects for each picture
    //VideoDownloader *videoDownloader ;
    
    Video *currentVideo ;
    NSIndexPath *currentIndexPath ;
    Video *downloadingVideo ;
    
    CGFloat progressWidth ;
    
    NSInteger listMode ;
    UILabel *doneLabel ;
    UIImageView *topDeleteImageView ;
    
    PreviewDownloader *previewDownloader ;
}

@property (nonatomic, retain) NSString *categoryId ;
@property (nonatomic, retain) NSString *subCategoryId ;


@end
