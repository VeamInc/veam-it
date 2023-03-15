//
//  AppStoreInformationTableViewCell.h
//  ColorPickerTest
//
//  Created by veam on 8/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_STORE_INFORMATION_CELL_HEIGHT   236

@interface AppStoreInformationTableViewCell : UITableViewCell


@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *sellerTitleLabel ;
@property (nonatomic, retain) UILabel *developerTitleLabel ;
@property (nonatomic, retain) UILabel *categoryTitleLabel ;
@property (nonatomic, retain) UILabel *updatedTitleLabel ;
@property (nonatomic, retain) UILabel *versionTitleLabel ;
@property (nonatomic, retain) UILabel *sizeTitleLabel ;
@property (nonatomic, retain) UILabel *ratingTitleLabel ;
@property (nonatomic, retain) UILabel *compatibilityTitleLabel ;

@property (nonatomic, retain) UILabel *sellerLabel ;
@property (nonatomic, retain) UILabel *developerLabel ;
@property (nonatomic, retain) UILabel *categoryLabel ;
@property (nonatomic, retain) UILabel *updatedLabel ;
@property (nonatomic, retain) UILabel *versionLabel ;
@property (nonatomic, retain) UILabel *sizeLabel ;
@property (nonatomic, retain) UILabel *ratingLabel ;
@property (nonatomic, retain) UILabel *compatibilityLabel ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier category:(NSString *)category ;

@end
