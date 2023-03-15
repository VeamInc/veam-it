//
//  ConsoleSwitchBarView.m
//  veam00000000
//
//  Created by veam on 6/6/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleSwitchBarView.h"

#define VEAM_CONSOLE_SWITCH_BAR_TITLE_WIDTH 200

@implementation ConsoleSwitchBarView

@synthesize delegate ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTitleLabel] ;
        [self addValueSwitch] ;
        //[VeamUtil registerTapAction:self target:self selector:@selector(showInputView)] ;
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

/*
- (void)setTitle:(NSString *)title
{
    [self addTitleLabel] ;
    [titleLabel setText:title] ;
}

- (void)addTitleLabel
{
    if(titleLabel == nil){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VEAM_CONSOLE_BAR_LEFT_MARGIN, 0, VEAM_CONSOLE_SWITCH_BAR_TITLE_WIDTH, self.frame.size.height)] ;
        [titleLabel setBackgroundColor:[UIColor clearColor]] ;
        [titleLabel setTextColor:[UIColor redColor]] ;
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
        [self addSubview:titleLabel] ;
    }
}
*/

/*
- (void)setInputValue:(NSString *)value
{
    inputValue = value ;
    [self addValueLabel] ;
    [valueLabel setText:inputValue] ;
}
*/

- (void)addValueSwitch
{
    if(valueSwitch == nil){
        valueSwitch = [[UISwitch alloc] init] ;
        CGRect frame = valueSwitch.frame ;
        frame.origin.x = self.frame.size.width - frame.size.width - VEAM_CONSOLE_BAR_LEFT_MARGIN ;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2 ;
        [valueSwitch setFrame:frame] ;
        [valueSwitch setOnTintColor:[UIColor redColor]] ;
        [valueSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged] ;
        [self addSubview:valueSwitch] ;
    }
}

- (BOOL)getInputValue
{
    return valueSwitch.on ;
}

- (void)setInputValue:(BOOL)on
{
    valueSwitch.on = on ;
}

- (void)setState:(id)sender
{
    BOOL state = [sender isOn] ;
    if(delegate != nil){
        [delegate didChangeSwitchValue:self value:state] ;
    }
}

@end
