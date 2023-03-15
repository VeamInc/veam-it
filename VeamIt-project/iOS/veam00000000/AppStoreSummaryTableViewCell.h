//
//  AppStoreSummaryTableViewCell.h
//  ColorPickerTest
//
//  Created by veam on 8/25/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppStoreSummaryTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *iconImageView ;
@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *companyLabel ;
@property (nonatomic, retain) UILabel *companyArrowLabel ;
@property (nonatomic, retain) UILabel *noteLabel ;
@property (nonatomic, retain) UIImageView *reviewImageView ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title ;

@end
