//
//  ConsoleLongTextInputBarView.m
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleLongTextInputBarView.h"
#import "VeamUtil.h"
#import "CustomIOS7AlertView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConsoleLongTextInputBarView

@synthesize delegate ;
@synthesize inputValue ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTitleLabel] ;
        [self addValueView] ;
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
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake
                      (VEAM_CONSOLE_BAR_LEFT_MARGIN,
                       0,
                       self.frame.size.width - VEAM_CONSOLE_BAR_LEFT_MARGIN,
                       40)] ;
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
    [self addValueView] ;
    [valueView setText:inputValue] ;
}

- (NSString *)getInputValue
{
    return valueView.text ;
}

/*
- (void)addValueLabel
{
    if(valueLabel == nil){
        valueWidth = self.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN*2 ;
        valueHeight = self.frame.size.height-40 ;
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               VEAM_CONSOLE_BAR_LEFT_MARGIN,
                                                               30,
                                                               valueWidth,
                                                               valueHeight)] ;
        [valueLabel setBackgroundColor:[UIColor clearColor]] ;
        [valueLabel setTextColor:[UIColor blackColor]] ;
        [valueLabel setFont:[UIFont systemFontOfSize:13]] ;
        [valueLabel setNumberOfLines:0] ;
        [self addSubview:valueLabel] ;
    }
}
*/

- (void)addValueView
{
    if(valueView == nil){
        valueWidth = self.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN*2 ;
        valueHeight = self.frame.size.height-40 ;
        valueView = [[UITextView alloc] initWithFrame:CGRectMake(
                                                               VEAM_CONSOLE_BAR_LEFT_MARGIN,
                                                               37,
                                                               valueWidth,
                                                               valueHeight)] ;
        [valueView setBackgroundColor:[UIColor clearColor]] ;
        [valueView setContentInset:UIEdgeInsetsMake(-10,-4,0,-4)] ;
        [valueView setTextColor:[UIColor blackColor]] ;
        [valueView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
        //[valueView setNumberOfLines:0] ;
        [valueView setDelegate:self] ;
        [self addSubview:valueView] ;
    }
}


-(BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    //NSLog(@"textViewShouldBeginEditing") ;
    return YES ;
}

-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    //NSLog(@"textViewShouldEndEditing") ;
    return YES ;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //NSLog(@"textViewDidChange") ;
    if(delegate != nil){
        [delegate didChangeLongTextInputValue:self value:textView.text] ;
    }
}

- (void)adjustSubViews
{
    CGRect frame = valueView.frame ;
    valueHeight = self.frame.size.height - 40 ;
    frame.size.height = valueHeight ;
    [valueView setFrame:frame] ;
}

- (void)setFirstResponder
{
    [valueView becomeFirstResponder] ;
}

- (void)showInputView
{
    
    
    
    alertView = [[CustomIOS7AlertView alloc] init] ;
    /*
     mProgressAlertView = [[UIAlertView alloc] initWithTitle: title
     message: description
     delegate: self
     cancelButtonTitle: cancel
     otherButtonTitles: nil];
     */
    
    UIView *alertBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)] ;
    [alertView setContainerView:alertBackView] ;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Ok", nil]];
    
    UILabel *alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)] ;
    [alertTitleLabel setBackgroundColor:[UIColor clearColor]] ;
    [alertTitleLabel setText:titleLabel.text] ;
    [alertTitleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [alertTitleLabel setNumberOfLines:2] ;
    [alertTitleLabel setFont:[UIFont boldSystemFontOfSize:18]] ;
    [alertBackView addSubview:alertTitleLabel] ;

    longTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 280, 100)] ;
    longTextView.layer.borderWidth = 0.5f ;
    longTextView.layer.cornerRadius = 7.0f ;
    longTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor] ;
    [longTextView setText:inputValue] ;
    //[longTextView becomeFirstResponder] ;
    [alertBackView addSubview:longTextView] ;

    /*
    UILabel *alertDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 256, 20)] ;
    [alertDescriptionLabel setBackgroundColor:[UIColor clearColor]] ;
    [alertDescriptionLabel setText:inputValue] ;
    [alertDescriptionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [alertDescriptionLabel setFont:[UIFont systemFontOfSize:16]] ;
    [alertBackView addSubview:alertDescriptionLabel] ;
     */
    
    alertView.delegate = self;
    [alertView show];

    
    /*
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init] ;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] ;
    
    [alertView setContainerView:textView] ;
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Button1", @"Button2", @"Button3", nil]];
    
    [alertView show] ;
    
    */
    
    /*
    
    
    
    
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
     
     */
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    //NSLog(@"clickedButtonAtIndex %d",buttonIndex) ;
    [alertView close] ;
    
    if(buttonIndex == 1){
        //NSLog(@"okButtonDown") ;
        inputValue = longTextView.text ;
        [valueLabel setText:inputValue] ;
        [valueLabel sizeToFit] ;
        CGRect frame = valueLabel.frame ;
        frame.size.width = valueWidth ;
        if(frame.size.height > valueHeight){
            frame.size.height = valueHeight ;
        }
        [valueLabel setFrame:frame] ;
        if(delegate != nil){
            [delegate didChangeLongTextInputValue:self value:inputValue] ;
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSString *value = [[alertView textFieldAtIndex:0] text] ;
        if(![value isEqual:inputValue]){
            inputValue = value ;
            [valueLabel setText:inputValue] ;
            [valueLabel sizeToFit] ;
            CGRect frame = valueLabel.frame ;
            frame.size.width = valueWidth ;
            if(frame.size.height > valueHeight){
                frame.size.height = valueHeight ;
            }
            [valueLabel setFrame:frame] ;
            if(delegate != nil){
                [delegate didChangeLongTextInputValue:self value:inputValue] ;
            }
        }
    }
}



@end
