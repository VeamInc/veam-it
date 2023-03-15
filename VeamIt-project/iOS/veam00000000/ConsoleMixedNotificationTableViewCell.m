//
//  ConsoleMixedNotificationTableViewCell.m
//  veam00000000
//
//  Created by veam on 1/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleMixedNotificationTableViewCell.h"
#import "VeamUtil.h"

#define CONSOLE_MIXED_NOTIFICATION_CELL_HEIGHT       44
#define CONSOLE_MIXED_NOTIFICATION_CELL_LEFTMARGIN   10
#define CONSOLE_MIXED_NOTIFICATION_CELL_RIGHTMARGIN  6


@implementation ConsoleMixedNotificationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONSOLE_MIXED_NOTIFICATION_CELL_LEFTMARGIN, 0, [VeamUtil getScreenWidth]-CONSOLE_MIXED_NOTIFICATION_CELL_LEFTMARGIN-CONSOLE_MIXED_NOTIFICATION_CELL_RIGHTMARGIN, CONSOLE_MIXED_NOTIFICATION_CELL_HEIGHT)] ;
        self.titleLabel.numberOfLines = 0 ;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12] ;
        self.titleLabel.textColor = [UIColor blackColor] ;
        self.titleLabel.highlightedTextColor = self.titleLabel.textColor ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;
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
