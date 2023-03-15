//
//  RecipeCategoryViewController.h
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"

@interface RecipeCategoryViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *recipeCategoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    NSArray *recipeCategories ;
}

- (void)updateList ;
@end
