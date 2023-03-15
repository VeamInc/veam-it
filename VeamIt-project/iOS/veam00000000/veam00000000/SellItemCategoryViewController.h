//
//  SellItemCategoryViewController.h
//  veam31000000
//
//  Created by veam on 7/17/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"

@interface SellItemCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *categoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    BOOL hasNewVideo ;
    
    NSMutableDictionary *imageDownloadsInProgressForBulletin ;  // the set of ImageDownloader objects for each picture
    BOOL isAllYoutubeCategoryEmbed ;
}

- (void)updateList ;

@end
