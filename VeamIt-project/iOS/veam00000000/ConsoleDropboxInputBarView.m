//
//  ConsoleDropboxInputBarView.m
//  veam00000000
//
//  Created by veam on 9/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleDropboxInputBarView.h"
#import "VeamUtil.h"
#import <DropboxSDK/DropboxSDK.h>




#define VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH 100

@implementation ConsoleDropboxInputBarView

@synthesize delegate ;
@synthesize inputValue ;
@synthesize extensions ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTitleLabel] ;
        [self addValueField] ;
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

- (void)setInputValue:(NSString *)value
{
    inputValue = value ;
    [self addValueField] ;
    [valueField setText:inputValue] ;
}

- (void)didFetchDropboxFileUrl:(NSString *)url
{
    [self setInputValue:url] ;
}

- (NSString *)getInputValue
{
    return valueField.text ;
}

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
        valueField = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   VEAM_CONSOLE_BAR_LEFT_MARGIN+VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH,
                                                                   0,
                                                                   self.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN-VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH-VEAM_CONSOLE_BAR_LEFT_MARGIN,
                                                                   self.frame.size.height)] ;
        [valueField setBackgroundColor:[UIColor clearColor]] ;
        [valueField setTextAlignment:NSTextAlignmentRight] ;
        [valueField setTextColor:[UIColor blackColor]] ;
        [valueField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
        [valueField setLineBreakMode:NSLineBreakByTruncatingHead] ;
        [self addSubview:valueField] ;
    }
}

- (void)showInputView
{
    //NSLog(@"%@::showInputView",NSStringFromClass([self class])) ;
    
    //NSLog(@"dropboxTap") ;
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self.delegate] ;
        return ;
    }
    //NSLog(@"after link") ;
    
   [delegate showDropboxViewController:self] ;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSString *value = [[alertView textFieldAtIndex:0] text] ;
        if(![value isEqual:inputValue]){
            inputValue = value ;
            [valueField setText:inputValue] ;
            if(delegate != nil){
                [delegate didChangeDropboxInputValue:self value:inputValue] ;
            }
        }
    }
}



@end
