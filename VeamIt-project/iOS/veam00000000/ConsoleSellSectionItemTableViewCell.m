//
//  ConsoleSellSectionItemTableViewCell.m
//  veam00000000
//
//  Created by veam on 11/26/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleSellSectionItemTableViewCell.h"
#import "VeamUtil.h"
#import "ConsoleUtil.h"

#define CONSOLE_SELL_VIDEO_CELL_HEIGHT       88
#define CONSOLE_SELL_VIDEO_CELL_LEFTMARGIN   10
#define CONSOLE_SELL_VIDEO_CELL_RIGHTMARGIN  6


@implementation ConsoleSellSectionItemTableViewCell

@synthesize deleteTapView ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier sellSectionItem:(SellSectionItem *)sellSectionItem isLast:(BOOL)isLast
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *moveImage = [UIImage imageNamed:@"list_move_on.png"] ;
        UIImage *moveOffImage = [UIImage imageNamed:@"list_move_off.png"] ;
        UIImage *deleteImage = [UIImage imageNamed:@"list_delete_on.png"] ;
        UIImage *rightImage = nil ;
        
        rightImage = [UIImage imageNamed:@"list_delete_on.png"] ;
        
        
        CGFloat currentX = [VeamUtil getScreenWidth] - CONSOLE_SELL_VIDEO_CELL_RIGHTMARGIN - rightImage.size.width/2 ;
        
        self.rightImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, (CONSOLE_SELL_VIDEO_CELL_HEIGHT-rightImage.size.height/2)/2, rightImage.size.width/2, rightImage.size.height/2)] ;
        self.rightImageView.image = rightImage ;
        [self.contentView addSubview:self.rightImageView] ;
        
        
        /*
         self.moveImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(CONSOLE_SELL_VIDEO_CELL_LEFTMARGIN, (CONSOLE_SELL_VIDEO_CELL_HEIGHT-moveImage.size.height/2)/2, moveImage.size.width/2, moveImage.size.height/2)] ;
         [self.contentView addSubview:self.moveImageView] ;
         */
        
        // thumbnail 68x68
        CGFloat thumbnailWidth = 90 ;
        CGFloat thumbnailHeight = 68 ;
        CGFloat thumbnailY = (CONSOLE_SELL_VIDEO_CELL_HEIGHT-thumbnailHeight)/2 ;
        self.thumbnailImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(CONSOLE_SELL_VIDEO_CELL_LEFTMARGIN, thumbnailY, thumbnailWidth, thumbnailHeight)] ;
        [self.contentView addSubview:self.thumbnailImageView] ;
        
        CGFloat titleX = self.thumbnailImageView.frame.origin.x + self.thumbnailImageView.frame.size.width + 12 ;
        
        //SellSectionItem *sellSectionItem = [[ConsoleUtil getConsoleContents] getSellSectionItemForId:sellSectionItem.sellSectionItemId] ;
        
        CGFloat bottomLabelHeight = 20 ;
        CGFloat titleHeight = thumbnailHeight - bottomLabelHeight ;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, thumbnailY, currentX-titleX, titleHeight)] ;
        self.titleLabel.text = sellSectionItem.title ;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17] ;
        self.titleLabel.textColor = [UIColor blackColor] ;
        self.titleLabel.highlightedTextColor = self.titleLabel.textColor ;
        self.titleLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.titleLabel] ;
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, thumbnailY+thumbnailHeight-bottomLabelHeight, currentX-titleX, bottomLabelHeight)] ;
        self.priceLabel.text = [sellSectionItem getKindString] ;
        self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12] ;
        self.priceLabel.textColor = [UIColor blackColor] ;
        self.priceLabel.highlightedTextColor = self.priceLabel.textColor ;
        self.priceLabel.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:self.priceLabel] ;
        
        
        //NSLog(@"sellVideo.status=%@",sellVideo.status) ;
        if([sellSectionItem.status isEqualToString:VEAM_SELL_SECTION_ITEM_STATUS_READY]){
            [self.thumbnailImageView setBackgroundColor:[UIColor clearColor]] ;
            [self.titleLabel setTextColor:[UIColor blackColor]] ;
            [self.priceLabel setTextColor:[UIColor blackColor]] ;
            self.moveImageView.image = moveImage ;
        } else {
            [self.thumbnailImageView setBackgroundColor:[UIColor redColor]] ;
            CGRect frame = self.thumbnailImageView.frame ;
            frame.origin.x += frame.size.width * 0.05 ;
            frame.size.width *= 0.9 ;
            self.statusLabel = [[UILabel alloc] initWithFrame:frame] ;
            //self.statusLabel.text = sellVideo.statusText ;
            NSAttributedString *astr = [[NSAttributedString alloc]
                                        initWithString:sellSectionItem.statusText
                                        attributes:@{
                                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                                     NSStrokeColorAttributeName : [UIColor blackColor],
                                                     NSStrokeWidthAttributeName : @-6.0
                                                     }];
            self.statusLabel.attributedText = astr;
            self.statusLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:42] ;
            self.statusLabel.adjustsFontSizeToFitWidth = YES ;
            self.statusLabel.minimumFontSize = 6 ;
            self.statusLabel.textColor = [UIColor whiteColor] ;
            self.statusLabel.highlightedTextColor = self.statusLabel.textColor ;
            self.statusLabel.backgroundColor = [UIColor clearColor] ;
            self.statusLabel.textAlignment = NSTextAlignmentCenter ;
            self.statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters ;
            [self.contentView addSubview:self.statusLabel] ;
            
            if([sellSectionItem.status isEqualToString:VEAM_SELL_SECTION_ITEM_STATUS_PREPARING] ||
               [sellSectionItem.status isEqualToString:VEAM_SELL_SECTION_ITEM_STATUS_SUBMITTING]){
                [self blinkLabel:self.statusLabel] ;
            }
            
            if([sellSectionItem.status isEqualToString:VEAM_SELL_SECTION_ITEM_STATUS_SUBMITTING]){
                if(![ConsoleUtil isAppReleased]){
                    [self.statusLabel setHidden:YES] ;
                }
            }

            
            [self.titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFB4B4B4"]] ;
            [self.priceLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFB4B4B4"]] ;
            self.moveImageView.image = moveOffImage ;
        }
        
        
        
        if(isLast){
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CONSOLE_SELL_VIDEO_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        } else {
            self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_SELL_VIDEO_CELL_LEFTMARGIN, CONSOLE_SELL_VIDEO_CELL_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        }
        self.separatorView.backgroundColor = [UIColor blackColor] ;
        [self.contentView addSubview:self.separatorView] ;
        
        self.deleteTapView = [[UIView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-CONSOLE_SELL_VIDEO_CELL_HEIGHT, 0, CONSOLE_SELL_VIDEO_CELL_HEIGHT, CONSOLE_SELL_VIDEO_CELL_HEIGHT)] ;
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
    return CONSOLE_SELL_VIDEO_CELL_HEIGHT ;
}

@end
