//
//  ConsoleMixedViewController.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleMixedViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSInteger cancelIndex ;
}

@property(nonatomic,retain)MixedCategory *mixedCategory ;
@property(nonatomic,retain)MixedSubCategory *mixedSubCategory ;

@end
