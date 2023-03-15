//
//  RecipeViewController.h
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"

@interface RecipeViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,ImageDownloaderDelegate>
{
    UITableView *recipeListTableView ;
    NSInteger indexOffset ;
    NSArray *recipes ;
    NSInteger lastIndex ;
    
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture
}

@property (nonatomic, retain) NSString *recipeCategoryId ;

@end
