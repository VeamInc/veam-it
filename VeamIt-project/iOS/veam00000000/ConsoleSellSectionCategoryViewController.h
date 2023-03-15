//
//  ConsoleSellSectionCategoryViewController.h
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleSellSectionCategoryViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger numberOfSellSectionCategories ;
    NSInteger indexToBeDeleted ;
    BOOL isAppReleased ;
    NSArray *prices ;
}

@property(nonatomic,assign)BOOL showCustomizeFirst ;

@end
