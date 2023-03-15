//
//  ConsoleElementView.m
//  veam00000000
//
//  Created by veam on 5/28/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleElementView.h"

@implementation ConsoleElementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithX:(CGFloat)x y:(CGFloat)y iconImage:(UIImage *)iconImage title:(NSString *)title
{
    self = [super init] ;
    if(self != nil){
        [self setFrame:CGRectMake(x, y, VEAM_CONSOLE_ELEMENT_WIDTH, VEAM_CONSOLE_ELEMENT_HEIGHT)] ;
        if(iconImage != nil){
            CGFloat margin = (VEAM_CONSOLE_ELEMENT_WIDTH - VEAM_CONSOLE_ELEMENT_ICON_SIZE) / 2 ;
            iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, VEAM_CONSOLE_ELEMENT_ICON_SIZE, VEAM_CONSOLE_ELEMENT_ICON_SIZE)] ;
            [iconImageView setImage:iconImage] ;
            [self addSubview:iconImageView] ;
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, margin+VEAM_CONSOLE_ELEMENT_ICON_SIZE, VEAM_CONSOLE_ELEMENT_WIDTH, 15)] ;
            [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
            [titleLabel setTextColor:[UIColor blackColor]] ;
            [titleLabel setText:title] ;
            [titleLabel setFont:[UIFont systemFontOfSize:10.0]] ;
            [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail] ;
            [titleLabel setNumberOfLines:1] ;
            [self addSubview:titleLabel] ;
        }
    }
    
    return self ;
}

- (void)setIconImage:(UIImage *)image
{
    [iconImageView setImage:image] ;
}

- (void)setTitle:(NSString *)title
{
    [titleLabel setText:title] ;
}

@end
