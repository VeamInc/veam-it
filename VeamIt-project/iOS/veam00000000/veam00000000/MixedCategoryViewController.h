//
//  MixedCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"

@interface MixedCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource/*,ImageDownloaderDelegate*/>
{
    UITableView *categoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    BOOL hasNewVideo ;
    
    //NSMutableDictionary *imageDownloadsInProgressForBulletin ;  // the set of ImageDownloader objects for each picture
}

- (void)updateList ;

@end
