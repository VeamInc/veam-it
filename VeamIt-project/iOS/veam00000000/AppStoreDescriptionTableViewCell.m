//
//  AppStoreDescriptionTableViewCell.m
//  ColorPickerTest
//
//  Created by veam on 8/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppStoreDescriptionTableViewCell.h"
#import "VeamUtil.h"

@implementation AppStoreDescriptionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier description:(NSString *)description
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 320, 15)] ;
        self.titleLabel.font = [UIFont systemFontOfSize:17] ;
        self.titleLabel.numberOfLines = 1 ;
        self.titleLabel.text = NSLocalizedString(@"app_store_description", nil) ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;
        
        self.descriptionLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, 38, 290, 75)] ;
        self.descriptionLabel.font = [UIFont systemFontOfSize:11.5] ;
        self.descriptionLabel.numberOfLines = 5 ;
        self.descriptionLabel.text = description ;
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft ;
        self.descriptionLabel.textColor = [UIColor redColor] ;
        self.descriptionLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.descriptionLabel] ;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, [AppStoreDescriptionTableViewCell getCellHeight:description showFull:NO]-1, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
        [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
        [self.contentView addSubview:separatorView] ;

    }
    return self;
}

+ (CGFloat)getCellHeight:(NSString *)description showFull:(BOOL)showFull
{
    return 125 ;
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
