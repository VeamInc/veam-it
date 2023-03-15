//
//  ConsoleMixedForGridTableViewCell.m
//  veam00000000
//
//  Created by veam on 1/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleMixedForGridTableViewCell.h"
#import "VeamUtil.h"

#define CONSOLE_MIXED_CELL_HEIGHT       88
#define CONSOLE_MIXED_CELL_LEFTMARGIN   10
#define CONSOLE_MIXED_CELL_RIGHTMARGIN  6

@implementation ConsoleMixedForGridTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier mixed:(Mixed *)mixed isLast:(BOOL)isLast
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *moveImage = [UIImage imageNamed:@"list_move_on.png"] ;
        UIImage *moveOffImage = [UIImage imageNamed:@"list_move_off.png"] ;
        UIImage *deleteImage = [UIImage imageNamed:@"list_delete_on.png"] ;
        UIImage *rightImage = nil ;
        
        if([mixed.status isEqualToString:VEAM_MIXED_STATUS_WAITING]){
            rightImage = [UIImage imageNamed:@"list_delete_on.png"] ;
        } else {
            rightImage = [UIImage imageNamed:@"list_delete_on.png"] ;
        }
        
        
        
        CGFloat currentX = [VeamUtil getScreenWidth] - CONSOLE_MIXED_CELL_RIGHTMARGIN - rightImage.size.width/2 ;
        
        self.rightImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, (CONSOLE_MIXED_CELL_HEIGHT-rightImage.size.height/2)/2, rightImage.size.width/2, rightImage.size.height/2)] ;
        self.rightImageView.image = rightImage ;
        [self.contentView addSubview:self.rightImageView] ;
        
        
        /*
        self.moveImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(CONSOLE_MIXED_CELL_LEFTMARGIN, (CONSOLE_MIXED_CELL_HEIGHT-moveImage.size.height/2)/2, moveImage.size.width/2, moveImage.size.height/2)] ;
        [self.contentView addSubview:self.moveImageView] ;
         */
        
        // thumbnail 68x68
        CGFloat thumbnailWidth = 68 ;
        CGFloat thumbnailHeight = 68 ;
        self.thumbnailImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(CONSOLE_MIXED_CELL_LEFTMARGIN, (CONSOLE_MIXED_CELL_HEIGHT-thumbnailHeight)/2, thumbnailWidth, thumbnailHeight)] ;
        [self.contentView addSubview:self.thumbnailImageView] ;
        
        CGFloat titleX = self.thumbnailImageView.frame.origin.x + self.thumbnailImageView.frame.size.width + 12 ;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, currentX-titleX, CONSOLE_MIXED_CELL_HEIGHT)] ;
        self.titleLabel.text = mixed.title ;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17] ;
        self.titleLabel.textColor = [UIColor blackColor] ;
        self.titleLabel.highlightedTextColor = self.titleLabel.textColor ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;
        
        if([mixed.status isEqualToString:VEAM_MIXED_STATUS_READY]){
            [self.thumbnailImageView setBackgroundColor:[UIColor clearColor]] ;
            [self.titleLabel setTextColor:[UIColor blackColor]] ;
            self.moveImageView.image = moveImage ;
        } else {
            [self.thumbnailImageView setBackgroundColor:[UIColor redColor]] ;
            CGRect frame = self.thumbnailImageView.frame ;
            frame.origin.x += frame.size.width * 0.05 ;
            frame.size.width *= 0.9 ;
            self.statusLabel = [[UILabel alloc] initWithFrame:frame] ;
            self.statusLabel.text = mixed.statusText ;
            self.statusLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:42] ;
            self.statusLabel.adjustsFontSizeToFitWidth = YES ;
            self.statusLabel.minimumFontSize = 6 ;
            self.statusLabel.textColor = [UIColor whiteColor] ;
            self.statusLabel.highlightedTextColor = self.statusLabel.textColor ;
            self.statusLabel.backgroundColor = [UIColor clearColor] ;
            self.statusLabel.textAlignment = NSTextAlignmentCenter ;
            self.statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters ;
            [self.contentView addSubview:self.statusLabel] ;
            
            if([mixed.statusText isEqualToString:@"Preparing"]){
                [self blinkLabel:self.statusLabel] ;
            }
            
            if(![VeamUtil isEmpty:mixed.deadlineString]){
                
                self.statusLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20] ;
                frame.size.height = 22 ;
                frame.origin.y += 18 ;
                [self.statusLabel setFrame:frame] ;
                
                CGRect dateFrame = self.thumbnailImageView.frame ;
                dateFrame.origin.x += dateFrame.size.width * 0.05 ;
                dateFrame.size.width *= 0.9 ;
                dateFrame.size.height = 10 ;
                dateFrame.origin.y = frame.origin.y + frame.size.height ;
                self.deadlineLabel = [[UILabel alloc] initWithFrame:dateFrame] ;
                self.deadlineLabel.text = mixed.deadlineString ;
                self.deadlineLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:8] ;
                self.deadlineLabel.adjustsFontSizeToFitWidth = YES ;
                self.deadlineLabel.minimumFontSize = 4 ;
                self.deadlineLabel.textColor = [UIColor whiteColor] ;
                self.deadlineLabel.highlightedTextColor = self.deadlineLabel.textColor ;
                self.deadlineLabel.backgroundColor = [UIColor clearColor] ;
                self.deadlineLabel.textAlignment = NSTextAlignmentCenter ;
                self.deadlineLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters ;
                [self.contentView addSubview:self.deadlineLabel] ;
            }
            
            [self.titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFB4B4B4"]] ;
            self.moveImageView.image = moveOffImage ;
        }
        
        
        
        if(isLast){
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CONSOLE_MIXED_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        } else {
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_MIXED_CELL_LEFTMARGIN, CONSOLE_MIXED_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        }
        self.separatorView.backgroundColor = [UIColor blackColor] ;
        [self.contentView addSubview:self.separatorView] ;
        
        self.deleteTapView = [[UIView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-CONSOLE_MIXED_CELL_HEIGHT, 0, CONSOLE_MIXED_CELL_HEIGHT, CONSOLE_MIXED_CELL_HEIGHT)] ;
        [self.deleteTapView setBackgroundColor:[UIColor clearColor]] ;
        [self.contentView addSubview:self.deleteTapView] ;

        
        
        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [VeamUtil getColorFromArgbString:@"19E6E6E6"] ;
    }
    return self;
}

- (void)blinkLabel:(UILabel *)target
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"] ;
    animation.duration = 0.8f ;
    animation.autoreverses = YES ;
    animation.repeatCount = HUGE_VAL ; //infinite loop -> HUGE_VAL
    animation.fromValue = [NSNumber numberWithFloat:1.0f] ; //MAX opacity
    animation.toValue = [NSNumber numberWithFloat:0.0f] ; //MIN opacity
    [target.layer addAnimation:animation forKey:@"blink"] ;
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
    return CONSOLE_MIXED_CELL_HEIGHT ;
}

@end
