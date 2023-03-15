//
//  AppStoreSummaryTableViewCell.m
//  ColorPickerTest
//
//  Created by veam on 8/25/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppStoreSummaryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "VeamUtil.h"

@implementation AppStoreSummaryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.iconImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 100, 100)] ;
        self.iconImageView.backgroundColor = [UIColor whiteColor] ;
        self.iconImageView.layer.cornerRadius = 18 ;
        self.iconImageView.layer.borderColor = [VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR].CGColor ;
        self.iconImageView.layer.borderWidth = 0.5 ;
        self.iconImageView.clipsToBounds = true ;
        [self.contentView addSubview:self.iconImageView] ;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 15, 175, 1)] ;
        self.titleLabel.text = title ;
        self.titleLabel.font = [UIFont systemFontOfSize:16.8] ;
        self.titleLabel.textColor = [UIColor redColor] ;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
        self.titleLabel.numberOfLines = 2 ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.titleLabel sizeToFit] ;
        [self.contentView addSubview:self.titleLabel] ;
        
        CGRect titleFrame = self.titleLabel.frame ;
        self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, titleFrame.origin.y+titleFrame.size.height, 175, 14)] ;
        self.companyLabel.text = @"Veam Inc." ;
        self.companyLabel.font = [UIFont systemFontOfSize:14.0] ;
        self.companyLabel.textColor = [UIColor blackColor] ;
        self.companyLabel.lineBreakMode = NSLineBreakByWordWrapping ;
        self.companyLabel.numberOfLines = 1 ;
        self.companyLabel.backgroundColor = [UIColor clearColor] ;
        [self.companyLabel sizeToFit] ;
        [self.contentView addSubview:self.companyLabel] ;
        
        CGRect companyFrame = self.companyLabel.frame ;
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(companyFrame.origin.x,companyFrame.origin.y+companyFrame.size.height+1, 30, companyFrame.size.height)] ;
        self.noteLabel.text = NSLocalizedString(@"app_store_offers_iap", nil) ;
        self.noteLabel.font = [UIFont systemFontOfSize:10.0] ;
        self.noteLabel.textColor = [UIColor grayColor] ;
        self.noteLabel.lineBreakMode = NSLineBreakByWordWrapping ;
        self.noteLabel.numberOfLines = 1 ;
        self.noteLabel.backgroundColor = [UIColor clearColor] ;
        [self.noteLabel sizeToFit] ;
        [self.contentView addSubview:self.noteLabel] ;

        self.reviewImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(130, 89, 175, 26)] ;
        self.reviewImageView.image = [UIImage imageNamed:@"app_store_review.png"] ;
        [self.contentView addSubview:self.reviewImageView] ;
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
