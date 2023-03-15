//
//  AppStoreScreenShotTableViewCell.h
//  ColorPickerTest
//
//  Created by veam on 8/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppStoreScreenShotTableViewCell : UITableViewCell

@property (nonatomic, retain) UIScrollView *scrollView ;
@property (nonatomic, retain) NSMutableArray *screenShotImageViews ;
@property (nonatomic, retain) NSMutableArray *loadIndicators ;
@property (nonatomic, retain) NSMutableArray *uploadImageViews ;
@property (nonatomic, retain) NSMutableArray *uploadIndicators ;

+ (CGFloat)getCellHeight ;

@end
