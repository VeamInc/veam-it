//
//  ConsoleSellItemCategoryViewController.h
//  veam00000000
//
//  Created by veam on 10/29/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleSellItemCategoryViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger numberOfSellItemCategories ;
    NSInteger indexToBeDeleted ;
}

@property(nonatomic,assign)BOOL showCustomizeFirst ;

@end
