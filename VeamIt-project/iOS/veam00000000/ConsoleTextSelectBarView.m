//
//  ConsoleTextSelectBarView.m
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTextSelectBarView.h"
#import "VeamUtil.h"

#define VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH 100

@implementation ConsoleTextSelectBarView

@synthesize delegate ;
@synthesize inputValue ;
@synthesize selectionValue ;
@synthesize selections ;
@synthesize selectionValues ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTitleLabel] ;
        [self addValueLabel] ;
        [VeamUtil registerTapAction:self target:self selector:@selector(showSelectView)] ;
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
    [self addValueLabel] ;
    [valueLabel setText:inputValue] ;
    
    int count = [selections count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *selection = [selections objectAtIndex:index] ;
        if([selection isEqualToString:value]){
            selectionValue = [selectionValues objectAtIndex:index] ;
            break ;
        }
    }
}

- (NSString *)getInputValue
{
    return valueLabel.text ;
}

- (NSString *)getSelectionValue
{
    NSString *retValue = @"" ;
    
    int count = [selections count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *workSelection = [selections objectAtIndex:index] ;
        if([workSelection isEqualToString:inputValue]){
            retValue = [selectionValues objectAtIndex:index] ;
            break ;
        }
    }

    return retValue ;
    
}

- (void)setSelectionValue:(NSString *)value
{
    selectionValue = value ;
    
    int count = [selectionValues count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *workValue = [selectionValues objectAtIndex:index] ;
        if([workValue isEqualToString:value]){
            inputValue = [selections objectAtIndex:index] ;
            break ;
        }
    }
    
    [self addValueLabel] ;
    [valueLabel setText:inputValue] ;

}

- (void)titleWidthChanged
{
    //NSLog(@"%@::titleWidthChanged",NSStringFromClass([self class])) ;
    if(valueLabel != nil){
        CGRect frame = valueLabel.frame ;
        frame.origin.x = titleRight + VEAM_CONSOLE_BAR_LEFT_MARGIN ;
        frame.size.width = [VeamUtil getScreenWidth] - frame.origin.x - VEAM_CONSOLE_BAR_LEFT_MARGIN ;
        [valueLabel setFrame:frame] ;
    }
}


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
        [valueLabel setTextAlignment:NSTextAlignmentRight] ;
        [valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]] ;
        [self addSubview:valueLabel] ;
    }
}

- (void)showSelectView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init] ;
    actionSheet.delegate = self ;
    actionSheet.title = titleLabel.text ;
    int count = [selections count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *selection = [selections objectAtIndex:index] ;
        [actionSheet addButtonWithTitle:selection] ;
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = count ;
    [actionSheet showInView:self] ;
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int count = [selections count] ;
    if(buttonIndex < count){
        NSString *value = [selections objectAtIndex:buttonIndex] ;
        if(![value isEqual:inputValue]){
            [self setInputValue:value] ;
            if(delegate != nil){
                [delegate didChangeTextSelectValue:self inputValue:inputValue selectionValue:selectionValue] ;
            }
        }
    }
}

@end
