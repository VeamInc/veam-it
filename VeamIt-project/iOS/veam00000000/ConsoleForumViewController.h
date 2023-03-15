//
//  ConsoleForumViewController.h
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleForumViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfForums ;
    NSInteger indexToBeDeleted ;
}

@property(nonatomic,assign)BOOL showCustomizeFirst ;

@end
