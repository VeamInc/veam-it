//
//  MixedSubCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "VeamViewController.h"

@interface MixedSubCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *subCategoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    NSArray *subCategories ;
}

@property (nonatomic, retain) NSString *categoryId ;

@end
