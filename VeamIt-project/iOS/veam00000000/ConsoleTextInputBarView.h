//
//  ConsoleTextInputBarView.h
//  veam00000000
//
//  Created by veam on 6/2/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"

@protocol ConsoleTextInputBarViewDelegate ;

@interface ConsoleTextInputBarView : ConsoleBarView
{
    UILabel *valueLabel ;
    UITextField *valueField ;
    NSString *hintString ;
}

@property (nonatomic, weak) id <ConsoleTextInputBarViewDelegate> delegate ;
@property(nonatomic,retain)NSString *inputValue ;

- (void)setInputValue:(NSString *)value ;
- (NSString *)getInputValue ;
- (void)showInputView ;

@end

@protocol ConsoleTextInputBarViewDelegate
- (void)didChangeTextInputValue:(ConsoleTextInputBarView *)view value:(NSString *)value ;
@end

