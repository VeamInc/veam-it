//
//  SellSectionCategoryViewController.h
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"

@interface SellSectionCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *categoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    BOOL hasNewVideo ;
    
    NSMutableDictionary *imageDownloadsInProgressForBulletin ;  // the set of ImageDownloader objects for each picture
    BOOL isAllYoutubeCategoryEmbed ;
    
    BOOL shouldShowDescription ;
    NSString *embededDescription ;
}

- (void)updateList ;

@end
