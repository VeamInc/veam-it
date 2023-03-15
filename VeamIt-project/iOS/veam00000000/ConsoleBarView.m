//
//  ConsoleBarView.m
//  veam00000000
//
//  Created by veam on 5/30/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"
#import "VeamUtil.h"

#define BAR_TITLE_MAX_WIDTH     250

@implementation ConsoleBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addBottomLine] ;
        [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"80FFFFFF"]] ;
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

- (void)addBottomLine
{
    if(bottomLine == nil){
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width,0.5)] ;
        [bottomLine setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFCCCCCC"]] ;
        [self addSubview:bottomLine] ;
    }
}

- (void)setFullBottomLine:(BOOL)full
{
    [self addBottomLine] ;
    CGRect bottomLineFrame = bottomLine.frame ;
    if(full){
        bottomLineFrame.origin.x = 0 ;
        bottomLineFrame.size.width = self.frame.size.width ;
    } else {
        bottomLineFrame.origin.x = VEAM_CONSOLE_BAR_LEFT_MARGIN ;
        bottomLineFrame.size.width = self.frame.size.width - VEAM_CONSOLE_BAR_LEFT_MARGIN ;
    }
    [bottomLine setFrame:bottomLineFrame] ;
}


- (void)titleWidthChanged
{
    //NSLog(@"%@::titleWidthChanged",NSStringFromClass([self class])) ;
}

- (void)setTitle:(NSString *)title
{
    [self addTitleLabel] ;
    [titleLabel setText:title] ;
    
    CGRect frame = titleLabel.frame ;
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [titleLabel setNumberOfLines:1] ;
    [titleLabel sizeToFit] ;
    CGRect resizedFrame = titleLabel.frame ;
    resizedFrame.size.height = frame.size.height ;
    if(resizedFrame.size.width > BAR_TITLE_MAX_WIDTH){
        resizedFrame.size.width = BAR_TITLE_MAX_WIDTH ;
    }
    [titleLabel setFrame:resizedFrame] ;
    titleRight = resizedFrame.size.width + VEAM_CONSOLE_BAR_LEFT_MARGIN ;
    
    //NSLog(@"title %@ right:%f",title,titleRight) ;
    [self titleWidthChanged] ;
}

- (void)addTitleLabel
{
    if(titleLabel == nil){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VEAM_CONSOLE_BAR_LEFT_MARGIN, 0, [VeamUtil getScreenWidth]-VEAM_CONSOLE_BAR_LEFT_MARGIN, 44)] ;
        [titleLabel setBackgroundColor:[UIColor clearColor]] ;
        [titleLabel setTextColor:[UIColor redColor]] ;
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
        [titleLabel setAdjustsFontSizeToFitWidth:YES] ;
        [titleLabel setMinimumScaleFactor:0.2f] ;
        [self addSubview:titleLabel] ;
    }
}

- (void)hideBottomLine
{
    [bottomLine setAlpha:0.0] ;
}


@end
