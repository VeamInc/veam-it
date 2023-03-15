//
//  AppStoreInformationTableViewCell.m
//  ColorPickerTest
//
//  Created by veam on 8/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppStoreInformationTableViewCell.h"
#import "VeamUtil.h"

@implementation AppStoreInformationTableViewCell

- (UILabel *)getTitleLabel:(CGFloat)y title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 75, 15)] ;
    label.font = [UIFont systemFontOfSize:12] ;
    label.numberOfLines = 1 ;
    label.text = title ;
    label.textAlignment = NSTextAlignmentRight ;
    label.textColor = [UIColor grayColor] ;
    
    return label ;
}

- (UILabel *)getValueLabel:(CGFloat)y title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(104, y, 200, 15)] ;
    label.font = [UIFont systemFontOfSize:12] ;
    label.numberOfLines = 1 ;
    label.text = title ;
    label.textAlignment = NSTextAlignmentLeft ;
    label.textColor = [UIColor blackColor] ;
    
    return label ;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier category:(NSString *)category
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 320, 15)] ;
        self.titleLabel.font = [UIFont systemFontOfSize:17] ;
        self.titleLabel.numberOfLines = 1 ;
        self.titleLabel.text = NSLocalizedString(@"app_store_information", nil) ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;

        CGFloat currentY = 38 ;
        
        self.sellerTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_seller", nil)] ;
        self.sellerTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.sellerTitleLabel] ;
        self.sellerLabel  = [self getValueLabel:currentY title:@"Veam Inc."] ;
        self.sellerLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.sellerLabel] ;
        currentY += 19 ;
        
        self.developerTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_developer", nil)] ;
        self.developerTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.developerTitleLabel] ;
        self.developerLabel  = [self getValueLabel:currentY title:@"Veam Inc."] ;
        self.developerLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.developerLabel] ;
        currentY += 19 ;
        
        self.categoryTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_category", nil)] ;
        self.categoryTitleLabel.textColor = [UIColor redColor] ;
        self.categoryTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.categoryTitleLabel] ;
        self.categoryLabel  = [self getValueLabel:currentY title:category] ;
        self.categoryLabel.textColor = [UIColor redColor] ;
        self.categoryLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.categoryLabel] ;
        currentY += 19 ;
        
        self.updatedTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_updated", nil)] ;
        self.updatedTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.updatedTitleLabel] ;
        self.updatedLabel  = [self getValueLabel:currentY title:@"2014/07/23"] ;
        self.updatedLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.updatedLabel] ;
        currentY += 19 ;
        
        self.versionTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_version", nil)] ;
        self.versionTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.versionTitleLabel] ;
        self.versionLabel  = [self getValueLabel:currentY title:@"1.0"] ;
        self.versionLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.versionLabel] ;
        currentY += 19 ;
        
        self.sizeTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_size", nil)] ;
        self.sizeTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.sizeTitleLabel] ;
        self.sizeLabel  = [self getValueLabel:currentY title:@"6.8 MB"] ;
        self.sizeLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.sizeLabel] ;
        currentY += 19 ;
        
        self.ratingTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_rating", nil)] ;
        self.ratingTitleLabel.textColor = [UIColor redColor] ;
        self.ratingTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.ratingTitleLabel] ;
        self.ratingLabel  = [self getValueLabel:currentY title:@"4+"] ;
        self.ratingLabel.textColor = [UIColor redColor] ;
        self.ratingLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.ratingLabel] ;
        currentY += 19 ;
        
        self.compatibilityTitleLabel  = [self getTitleLabel:currentY title:NSLocalizedString(@"app_store_info_compatibility", nil)] ;
        self.compatibilityTitleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.compatibilityTitleLabel] ;
        self.compatibilityLabel  = [self getValueLabel:currentY title:NSLocalizedString(@"app_store_info_compatibility_text", nil)] ;
        self.compatibilityLabel.numberOfLines = 4 ;
        CGRect frame = self.compatibilityLabel.frame ;
        frame.size.height = 60 ;
        self.compatibilityLabel.frame = frame ;
        self.compatibilityLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.compatibilityLabel] ;
        currentY += 19 ;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, APP_STORE_INFORMATION_CELL_HEIGHT-1, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
        [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
        [self.contentView addSubview:separatorView] ;

    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
