//
//  MixedViewController.h
//  veam00000000
//
//  Created by veam on 6/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"
#import "Video.h"
#import "PreviewDownloader.h"

@interface MixedViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate,PreviewDownloaderDelegate>
{
    UITableView *mixedListTableView ;
    NSInteger indexOffset ;
    NSArray *mixeds ;
    NSInteger lastIndex ;
    
    Video *currentVideo ;
    PreviewDownloader *previewDownloader ;

    
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture
}

@property (nonatomic, retain) NSString *categoryId ;
@property (nonatomic, retain) NSString *subCategoryId ;
@property (nonatomic, retain) NSString *categoryKind ;
@property (nonatomic, assign) BOOL showBackButton ;


@end
