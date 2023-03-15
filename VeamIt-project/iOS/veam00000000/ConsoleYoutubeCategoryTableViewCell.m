//
//  ConsoleYoutubeCategoryTableViewCell.m
//  veam00000000
//
//  Created by veam on 9/8/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleYoutubeCategoryTableViewCell.h"
#import "VeamUtil.h"

#define CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT       44
#define CONSOLE_YOUTUBE_CATEGORY_CELL_LEFTMARGIN   15
#define CONSOLE_YOUTUBE_CATEGORY_CELL_RIGHTMARGIN  6

@implementation ConsoleYoutubeCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title isLast:(BOOL)isLast
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *moveImage = [UIImage imageNamed:@"list_move_on.png"] ;
        UIImage *deleteImage = [UIImage imageNamed:@"list_disable_off.png"] ;
        CGFloat currentX = [VeamUtil getScreenWidth] - CONSOLE_YOUTUBE_CATEGORY_CELL_RIGHTMARGIN - deleteImage.size.width/2 ;
        
        self.deleteImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, (CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT-deleteImage.size.height/2)/2, deleteImage.size.width/2, deleteImage.size.height/2)] ;
        self.deleteImageView.image = deleteImage ;
        [self.contentView addSubview:self.deleteImageView] ;
        
        currentX -= 10 ;
        currentX -= moveImage.size.width / 2 ;
        
        self.moveImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, (CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT-moveImage.size.height/2)/2, moveImage.size.width/2, moveImage.size.height/2)] ;
        self.moveImageView.image = moveImage ;
        [self.contentView addSubview:self.moveImageView] ;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONSOLE_YOUTUBE_CATEGORY_CELL_LEFTMARGIN, 0, currentX-CONSOLE_YOUTUBE_CATEGORY_CELL_LEFTMARGIN, CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT)] ;
        self.titleLabel.text = title ;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17] ;
        self.titleLabel.textColor = [UIColor blackColor] ;
        self.titleLabel.highlightedTextColor = self.titleLabel.textColor ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;
        
        if(isLast){
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        } else {
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_YOUTUBE_CATEGORY_CELL_LEFTMARGIN, CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        }
        self.separatorView.backgroundColor = [UIColor blackColor] ;
        [self.contentView addSubview:self.separatorView] ;
        
        self.deleteTapView = [[UIView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT, 0, CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT, CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT)] ;
        [self.deleteTapView setBackgroundColor:[UIColor clearColor]] ;
        [self.contentView addSubview:self.deleteTapView] ;

        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [VeamUtil getColorFromArgbString:@"19E6E6E6"] ;
    }
    return self;
}

- (void)setDisabled:(BOOL)disabled
{
    if(disabled){
        [self.deleteImageView setImage:[UIImage imageNamed:@"list_disable_on.png"]] ;
        [self.titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFC0C0C0"]] ;
    } else {
        [self.deleteImageView setImage:[UIImage imageNamed:@"list_disable_off.png"]] ;
        [self.titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
    }
}

+ (CGFloat)getCellHeight
{
    return CONSOLE_YOUTUBE_CATEGORY_CELL_HEIGHT ;
}



@end
