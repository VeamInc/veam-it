//
//  ConsoleYoutubeCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/3/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleYoutubeCategoryViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger numberOfCategories ;
    NSInteger indexToBeDeleted ;
}

@property(nonatomic,assign)BOOL showCustomizeFirst ;

@end
