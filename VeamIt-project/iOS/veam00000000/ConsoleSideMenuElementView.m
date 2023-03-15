//
//  ConsoleSideMenuElementView.m
//  ColorPickerTest
//
//  Created by veam on 8/26/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleSideMenuElementView.h"
#import <QuartzCore/QuartzCore.h>


#define SIDE_MENU_ICON_SIZE             40
#define SIDE_MENU_TITLE_LEFT_MARGIN     8

@implementation ConsoleSideMenuElementView

@synthesize titleLabel ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIconFileName:(NSString *)iconFileName title:(NSString *)title badge:(NSInteger)badge
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-SIDE_MENU_ICON_SIZE)/2, SIDE_MENU_ICON_SIZE, SIDE_MENU_ICON_SIZE)] ;
    [self.iconImageView setImage:[UIImage imageNamed:iconFileName]] ;
    [self addSubview:self.iconImageView] ;

    CGFloat labelMaxWidth = self.frame.size.width-SIDE_MENU_ICON_SIZE ;
    self.title = title ;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, labelMaxWidth, self.frame.size.height)] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [titleLabel setText:title] ;
    [titleLabel setTextColor:[UIColor whiteColor]] ;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [titleLabel setNumberOfLines:1] ;
    [titleLabel sizeToFit] ;
    CGRect labelFrame = titleLabel.frame ;
    if(labelFrame.size.width > labelMaxWidth){
        labelFrame.size.width = labelMaxWidth ;
    }
    labelFrame.origin.y = (self.frame.size.height - labelFrame.size.height) / 2 ;
    [titleLabel setFrame:labelFrame] ;
    [self addSubview:titleLabel] ;
    
    if(badge > 0){
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelFrame.origin.x+labelFrame.size.width+4, 0, 16, 16)] ;
        [badgeLabel setBackgroundColor:[UIColor redColor]] ;
        [badgeLabel setText:[NSString stringWithFormat:@"%ld",(long)badge]] ;
        [badgeLabel setTextColor:[UIColor whiteColor]] ;
        [badgeLabel setTextAlignment:NSTextAlignmentCenter] ;
        [badgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
        [badgeLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
        [badgeLabel setNumberOfLines:1] ;
        [badgeLabel sizeToFit] ;
        CGRect badgeFrame = badgeLabel.frame ;
        badgeFrame.size.width += 8 ;
        badgeFrame.size.height = 16 ;
        badgeFrame.origin.y = (self.frame.size.height - badgeFrame.size.height) / 2 + 1 ;
        [badgeLabel setFrame:badgeFrame] ;
        badgeLabel.layer.cornerRadius = 8 ;
        badgeLabel.clipsToBounds = true ;
        [self addSubview:badgeLabel] ;
    }
    

}

- (void)setTitle:(NSString *)title badge:(NSInteger)badge
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
    
    CGFloat labelMaxWidth = self.frame.size.width - SIDE_MENU_TITLE_LEFT_MARGIN ;
    self.title = title ;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_MENU_TITLE_LEFT_MARGIN, 0, labelMaxWidth, self.frame.size.height)] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [titleLabel setText:title] ;
    [titleLabel setTextColor:[UIColor whiteColor]] ;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [titleLabel setNumberOfLines:1] ;
    [titleLabel sizeToFit] ;
    CGRect labelFrame = titleLabel.frame ;
    if(labelFrame.size.width > labelMaxWidth){
        labelFrame.size.width = labelMaxWidth ;
    }
    labelFrame.origin.y = (self.frame.size.height - labelFrame.size.height) / 2 ;
    [titleLabel setFrame:labelFrame] ;
    [self addSubview:titleLabel] ;
    
}

- (void)setTitleColor:(UIColor *)color
{
    if(titleLabel){
        [titleLabel setTextColor:color] ;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
