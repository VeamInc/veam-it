//
//  ConsoleTextInputBarView.m
//  veam00000000
//
//  Created by veam on 6/2/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTextInputBarView.h"
#import "VeamUtil.h"


#define VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH 100

@implementation ConsoleTextInputBarView

@synthesize delegate ;
@synthesize inputValue ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTitleLabel] ;
        [self addValueField] ;
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
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VEAM_CONSOLE_BAR_LEFT_MARGIN, 0, VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH, self.frame.size.height)] ;
        [titleLabel setBackgroundColor:[UIColor clearColor]] ;
        [titleLabel setTextColor:[UIColor redColor]] ;
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
        [self addSubview:titleLabel] ;
    }
}
*/

- (void)setInputValue:(NSString *)value
{
    inputValue = value ;
    [self addValueField] ;
    [valueField setText:inputValue] ;
}

- (NSString *)getInputValue
{
    return valueField.text ;
}

/*
- (void)addValueLabel
{
    if(valueLabel == nil){
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                               VEAM_CONSOLE_BAR_LEFT_MARGIN+VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH,
                               0,
                               self.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN-VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH,
                               self.frame.size.height)] ;
        [valueLabel setBackgroundColor:[UIColor clearColor]] ;
        [valueLabel setTextColor:[UIColor blackColor]] ;
        [valueLabel setFont:[UIFont systemFontOfSize:13]] ;
        [self addSubview:valueLabel] ;
    }
}
*/

- (void)titleWidthChanged
{
    //NSLog(@"%@::titleWidthChanged",NSStringFromClass([self class])) ;
    if(valueField != nil){
        CGRect frame = valueField.frame ;
        frame.origin.x = titleRight + VEAM_CONSOLE_BAR_LEFT_MARGIN ;
        frame.size.width = [VeamUtil getScreenWidth] - frame.origin.x - VEAM_CONSOLE_BAR_LEFT_MARGIN ;
        [valueField setFrame:frame] ;
    }
}


- (void)addValueField
{
    if(valueField == nil){
        valueField = [[UITextField alloc] initWithFrame:CGRectMake(
                                                               VEAM_CONSOLE_BAR_LEFT_MARGIN+VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH,
                                                               0,
                                                               self.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN-VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH-VEAM_CONSOLE_BAR_LEFT_MARGIN,
                                                               self.frame.size.height)] ;
        [valueField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
        [valueField setBackgroundColor:[UIColor clearColor]] ;
        [valueField setTextAlignment:NSTextAlignmentRight] ;
        [valueField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter] ;
        [valueField setTextColor:[UIColor blackColor]] ;
        [valueField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
        [self addSubview:valueField] ;
    }
}

- (void)showInputView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[titleLabel text]
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil] ;
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput] ;
    
    if(![VeamUtil isEmpty:inputValue]){
        UITextField* textField = [alertView textFieldAtIndex:0] ;
        textField.text = inputValue ;
    }
    
    [alertView show] ;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSString *value = [[alertView textFieldAtIndex:0] text] ;
        if(![value isEqual:inputValue]){
            inputValue = value ;
            [valueField setText:inputValue] ;
            if(delegate != nil){
                [delegate didChangeTextInputValue:self value:inputValue] ;
            }
        }
    }
}



@end
