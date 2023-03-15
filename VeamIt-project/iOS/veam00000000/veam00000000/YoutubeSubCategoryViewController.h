//
//  YoutubeSubCategoryViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"

@interface YoutubeSubCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *subCategoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    NSArray *subCategories ;
}

@property (nonatomic, retain) NSString *categoryId ;

@end
