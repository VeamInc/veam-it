//
//  ConsoleFloatingMenuView.m
//  veam00000000
//
//  Created by veam on 9/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleFloatingMenuView.h"
#import "VeamUtil.h"
#import <QuartzCore/QuartzCore.h>

#define VEAM_CONSOLE_FLOATING_MENU_ELEMENT_WIDTH            68
#define VEAM_CONSOLE_FLOATING_MENU_ELEMENT_HEIGHT           16
#define VEAM_CONSOLE_FLOATING_MENU_SIDE_MARGIN              14
#define VEAM_CONSOLE_FLOATING_MENU_BADGE_VERTICAL_MARGIN    -6
#define VEAM_CONSOLE_FLOATING_MENU_BADGE_HORIZONTAL_MARGIN  72

@implementation ConsoleFloatingMenuView

@synthesize delegate ;
@synthesize highlightedBackgroundColor ;
@synthesize highlightedTextColor ;

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

+ (CGFloat)getMenuHeight
{
    return VEAM_CONSOLE_FLOATING_MENU_ELEMENT_HEIGHT - VEAM_CONSOLE_FLOATING_MENU_BADGE_VERTICAL_MARGIN ;
}

- (void)setMenuElement:(NSArray *)elements
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
    NSInteger numberOfElements = [elements count] ;
    
    CGFloat currentX = VEAM_CONSOLE_FLOATING_MENU_SIDE_MARGIN ;
    
    CGFloat baseX = currentX - VEAM_CONSOLE_FLOATING_MENU_SIDE_MARGIN ;
    CGFloat baseY = -VEAM_CONSOLE_FLOATING_MENU_BADGE_VERTICAL_MARGIN ;
    CGFloat baseWidth = numberOfElements * VEAM_CONSOLE_FLOATING_MENU_ELEMENT_WIDTH + VEAM_CONSOLE_FLOATING_MENU_SIDE_MARGIN * 2 ;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(baseX, baseY, baseWidth, VEAM_CONSOLE_FLOATING_MENU_ELEMENT_HEIGHT)] ;
    [baseView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFDADADA"]] ;
    baseView.layer.cornerRadius = VEAM_CONSOLE_FLOATING_MENU_ELEMENT_HEIGHT / 2 ;
    baseView.clipsToBounds = true ;
    [self addSubview:baseView] ;
    
    for(int index = 0 ; index < numberOfElements ; index++){
        NSDictionary *element = [elements objectAtIndex:index] ;
        NSString *badge = [element objectForKey:@"BADGE"] ;
        NSString *title = [element objectForKey:@"TITLE"] ;
        NSString *selected = [element objectForKey:@"SELECTED"] ;
        
        UILabel *elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, baseY, VEAM_CONSOLE_FLOATING_MENU_ELEMENT_WIDTH, VEAM_CONSOLE_FLOATING_MENU_ELEMENT_HEIGHT)] ;
        [elementLabel setTextAlignment:NSTextAlignmentCenter] ;
        [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]] ;
        [elementLabel setText:title] ;
        [elementLabel setTag:index] ;
        [VeamUtil registerTapAction:elementLabel target:self selector:@selector(didTapElement:)] ;

        if([selected isEqualToString:@"YES"]){
            [elementLabel setBackgroundColor:highlightedBackgroundColor] ;
            [elementLabel setTextColor:highlightedTextColor] ;
        } else {
            [elementLabel setBackgroundColor:[UIColor clearColor]] ;
            [elementLabel setTextColor:[UIColor whiteColor]] ;
        }
        
        [self addSubview:elementLabel] ;
        
        if(![VeamUtil isEmpty:badge]){
            UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)] ;
            [badgeLabel setBackgroundColor:[UIColor redColor]] ;
            [badgeLabel setText:badge] ;
            [badgeLabel setTextColor:[UIColor whiteColor]] ;
            [badgeLabel setTextAlignment:NSTextAlignmentCenter] ;
            [badgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
            [badgeLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
            [badgeLabel setNumberOfLines:1] ;
            [badgeLabel sizeToFit] ;
            CGRect badgeFrame = badgeLabel.frame ;
            badgeFrame.size.width += 8 ;
            badgeFrame.size.height = 16 ;
            badgeFrame.origin.y = 0 ;
            badgeFrame.origin.x = currentX + VEAM_CONSOLE_FLOATING_MENU_BADGE_HORIZONTAL_MARGIN - badgeFrame.size.width ;
            [badgeLabel setFrame:badgeFrame] ;
            badgeLabel.layer.cornerRadius = 8 ;
            badgeLabel.clipsToBounds = true ;
            [self addSubview:badgeLabel] ;
        }
        
        currentX += VEAM_CONSOLE_FLOATING_MENU_ELEMENT_WIDTH ;
    }
    
    CGRect myFrame = self.frame ;
    myFrame.size.width = baseWidth ;
    myFrame.origin.x = ([VeamUtil getScreenWidth] - baseWidth) / 2 ;
    [self setFrame:myFrame] ;
}

- (void)didTapElement:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger index = singleTapGesture.view.tag ;
    if(delegate != nil){
        [delegate didTapFloatingMenu:index] ;
    }
}


@end
