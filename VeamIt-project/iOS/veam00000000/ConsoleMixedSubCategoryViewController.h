//
//  ConsoleMixedSubCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "MixedCategory.h"

@interface ConsoleMixedSubCategoryViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)MixedCategory *mixedCategory ;

@end
