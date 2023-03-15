//
//  AppStoreDescriptionTableViewCell.h
//  ColorPickerTest
//
//  Created by veam on 8/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppStoreDescriptionTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *descriptionLabel ;
@property (nonatomic, retain) UILabel *moreLabel ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier description:(NSString *)description ;
+ (CGFloat)getCellHeight:(NSString *)description showFull:(BOOL)showFull ;

@end
