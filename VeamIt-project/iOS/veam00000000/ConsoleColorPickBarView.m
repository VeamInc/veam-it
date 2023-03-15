//
//  ConsoleColorPickBarView.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleColorPickBarView.h"
#import "VeamUtil.h"
#import "NEOColorPickerViewController.h"

#define VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH 100

@implementation ConsoleColorPickBarView

@synthesize delegate ;
@synthesize inputValue ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTitleLabel] ;
        [self addValueLabel] ;
        [VeamUtil registerTapAction:self target:self selector:@selector(showInputView)] ;
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
    //NSLog(@"setInputValue %@",value) ;
    inputValue = value ;
    [self addValueLabel] ;
    if([value length] != 8){
        inputValue = @"FFFFFFFF" ;
    }
    [valueLabel setBackgroundColor:[VeamUtil getColorFromArgbString:inputValue]] ;
}

- (void)addValueLabel
{
    if(valueLabel == nil){
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               VEAM_CONSOLE_BAR_LEFT_MARGIN+VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH,
                                                               5,
                                                               30,
                                                               30)] ;
        [valueLabel setBackgroundColor:[UIColor clearColor]] ;
        [self addSubview:valueLabel] ;
    }
}

- (void)showInputView
{
    if(delegate != nil){
        NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init] ;
        controller.delegate = self ;
        controller.selectedColor = [UIColor whiteColor] ;
        controller.title = titleLabel.text ;
        [delegate showColorPicker:controller] ;
    }
    
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color
{
    //NSLog(@"didSelectColor") ;
    // Do something with the color.
    CGFloat red = 0 ;
    CGFloat green = 0 ;
    CGFloat blue = 0 ;
    CGFloat alpha = 0 ;
    [color getRed:&red green:&green blue:&blue alpha:&alpha] ;
    NSString *colorString = [NSString stringWithFormat:@"%02X%02X%02X%02X",(NSUInteger)(alpha*255),(NSUInteger)(red*255),(NSUInteger)(green*255),(NSUInteger)(blue*255)] ;
    if(![colorString isEqual:inputValue]){
        inputValue = colorString ;
        [valueLabel setBackgroundColor:color] ;
        if(delegate != nil){
            [delegate didChangeColorPickValue:self value:inputValue] ;
        }
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil] ;
}

- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil] ;
}

@end
