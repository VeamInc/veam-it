//
//  VideoSubCategoryViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"

@interface VideoSubCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *videoSubCategoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    NSArray *videoSubCategories ;
}

@property (nonatomic, retain) NSString *categoryId ;

@end
