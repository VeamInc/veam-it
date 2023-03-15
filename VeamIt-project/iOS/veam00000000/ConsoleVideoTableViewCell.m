//
//  ConsoleVideoTableViewCell.m
//  veam00000000
//
//  Created by veam on 9/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleVideoTableViewCell.h"
#import "VeamUtil.h"

#define CONSOLE_VIDEO_CELL_HEIGHT       88
#define CONSOLE_VIDEO_CELL_LEFTMARGIN   10
#define CONSOLE_VIDEO_CELL_RIGHTMARGIN  6

@implementation ConsoleVideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier video:(Video *)video isLast:(BOOL)isLast
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *moveImage = [UIImage imageNamed:@"list_move_on.png"] ;
        UIImage *moveOffImage = [UIImage imageNamed:@"list_move_off.png"] ;
        UIImage *deleteImage = [UIImage imageNamed:@"list_delete_on.png"] ;
        UIImage *rightImage = nil ;
        
        if([video.status isEqualToString:VEAM_VIDEO_STATUS_WAITING]){
            rightImage = [UIImage imageNamed:@"list_upload.png"] ;
        } else {
            rightImage = [UIImage imageNamed:@"list_arrow.png"] ;
        }
        

        
        CGFloat currentX = [VeamUtil getScreenWidth] - CONSOLE_VIDEO_CELL_RIGHTMARGIN - rightImage.size.width/2 ;
        
        self.rightImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, (CONSOLE_VIDEO_CELL_HEIGHT-rightImage.size.height/2)/2, rightImage.size.width/2, rightImage.size.height/2)] ;
        self.rightImageView.image = rightImage ;
        [self.contentView addSubview:self.rightImageView] ;
        

        
        self.moveImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(CONSOLE_VIDEO_CELL_LEFTMARGIN, (CONSOLE_VIDEO_CELL_HEIGHT-moveImage.size.height/2)/2, moveImage.size.width/2, moveImage.size.height/2)] ;
        [self.contentView addSubview:self.moveImageView] ;
        
        // thumbnail 90x68
        CGFloat thumbnailWidth = 90 ;
        CGFloat thumbnailHeight = 68 ;
        self.thumbnailImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(38, (CONSOLE_VIDEO_CELL_HEIGHT-thumbnailHeight)/2, thumbnailWidth, thumbnailHeight)] ;
        [self.contentView addSubview:self.thumbnailImageView] ;

        CGFloat titleX = self.thumbnailImageView.frame.origin.x + self.thumbnailImageView.frame.size.width + 12 ;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, currentX-titleX, CONSOLE_VIDEO_CELL_HEIGHT)] ;
        self.titleLabel.text = video.title ;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17] ;
        self.titleLabel.textColor = [UIColor blackColor] ;
        self.titleLabel.highlightedTextColor = self.titleLabel.textColor ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;

        if([video.status isEqualToString:VEAM_VIDEO_STATUS_READY]){
            [self.thumbnailImageView setBackgroundColor:[UIColor clearColor]] ;
            [self.titleLabel setTextColor:[UIColor blackColor]] ;
            self.moveImageView.image = moveImage ;
        } else {
            [self.thumbnailImageView setBackgroundColor:[UIColor redColor]] ;
            CGRect frame = self.thumbnailImageView.frame ;
            frame.origin.x += frame.size.width * 0.05 ;
            frame.size.width *= 0.9 ;
            self.statusLabel = [[UILabel alloc] initWithFrame:frame] ;
            self.statusLabel.text = video.statusText ;
            self.statusLabel.text = video.statusText ;
            self.statusLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:42] ;
            self.statusLabel.adjustsFontSizeToFitWidth = YES ;
            self.statusLabel.minimumFontSize = 6 ;
            self.statusLabel.textColor = [UIColor whiteColor] ;
            self.statusLabel.highlightedTextColor = self.statusLabel.textColor ;
            self.statusLabel.backgroundColor = [UIColor clearColor] ;
            self.statusLabel.textAlignment = NSTextAlignmentCenter ;
            self.statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters ;
            [self.contentView addSubview:self.statusLabel] ;
            
            [self.titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFB4B4B4"]] ;
            self.moveImageView.image = moveOffImage ;
        }

        
        
        if(isLast){
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CONSOLE_VIDEO_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        } else {
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_VIDEO_CELL_LEFTMARGIN, CONSOLE_VIDEO_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        }
        self.separatorView.backgroundColor = [UIColor blackColor] ;
        [self.contentView addSubview:self.separatorView] ;
        
        
        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [VeamUtil getColorFromArgbString:@"19E6E6E6"] ;
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
    return CONSOLE_VIDEO_CELL_HEIGHT ;
}

@end
