//
//  ConsoleAddTableViewCell.m
//  veam00000000
//
//  Created by veam on 8/26/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleAddTableViewCell.h"
#import "VeamUtil.h"

#define CONSOLE_ADD_CELL_HEIGHT       44
#define CONSOLE_ADD_CELL_LEFTMARGIN   9
#define CONSOLE_ADD_CELL_RIGHTMARGIN  0

@implementation ConsoleAddTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title isLast:(BOOL)isLast
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *plusImage = [UIImage imageNamed:@"list_add_on.png"] ;
        CGFloat currentX = CONSOLE_ADD_CELL_LEFTMARGIN ;
        
        self.plusImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, (CONSOLE_ADD_CELL_HEIGHT-plusImage.size.height/2)/2, plusImage.size.width/2, plusImage.size.height/2)] ;
        self.plusImageView.image = plusImage ;
        [self.contentView addSubview:self.plusImageView] ;
        
        currentX += plusImage.size.width / 2 ;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, [VeamUtil getScreenWidth]-currentX, CONSOLE_ADD_CELL_HEIGHT)] ;
        self.titleLabel.text = title ;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17] ;
        self.titleLabel.textColor = [UIColor blackColor] ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;
        
        if(isLast){
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CONSOLE_ADD_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        } else {
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_ADD_CELL_LEFTMARGIN, CONSOLE_ADD_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        }
        self.separatorView.backgroundColor = [UIColor blackColor] ;
        [self.contentView addSubview:self.separatorView] ;
        
        
        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [UIColor clearColor] ;
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

+ (CGFloat)getCellHeight
{
    return CONSOLE_ADD_CELL_HEIGHT ;
}

@end
