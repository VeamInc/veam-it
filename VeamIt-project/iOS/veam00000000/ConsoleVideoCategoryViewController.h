//
//  ConsoleVideoCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleVideoCategoryViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger numberOfVideoCategories ;
    NSInteger indexToBeDeleted ;
}
@end
