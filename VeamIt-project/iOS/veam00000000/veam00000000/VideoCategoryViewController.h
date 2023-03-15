//
//  VideoCategoryViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"

@interface VideoCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *categoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    BOOL hasNewVideo ;
    
    BOOL isBought ;
    BOOL shouldShowDescription ;
    NSString *embededDescription ;
    
    NSMutableDictionary *imageDownloadsInProgressForBulletin ;  // the set of ImageDownloader objects for each picture
}

- (void)updateList ;

@end
