//
//  ConsoleVideoSubCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "VideoCategory.h"

@interface ConsoleVideoSubCategoryViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)VideoCategory *videoCategory ;

@end
