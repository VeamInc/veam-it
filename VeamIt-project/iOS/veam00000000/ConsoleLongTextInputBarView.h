//
//  ConsoleLongTextInputBarView.h
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"
#import "CustomIOS7AlertView.h"

@protocol ConsoleLongTextInputBarViewDelegate ;

@interface ConsoleLongTextInputBarView : ConsoleBarView
{
    //UILabel *titleLabel ;
    UILabel *valueLabel ;
    UITextView *valueView ;
    CGFloat valueWidth ;
    CGFloat valueHeight ;
    NSString *hintString ;
    CustomIOS7AlertView *alertView ;
    UITextView *longTextView ;
}

@property (nonatomic, weak) id <ConsoleLongTextInputBarViewDelegate> delegate ;
@property(nonatomic,retain)NSString *inputValue ;

//- (void)setTitle:(NSString *)title ;
- (void)setInputValue:(NSString *)value ;
- (NSString *)getInputValue ;
- (void)showInputView ;
- (void)setFirstResponder ;
- (void)adjustSubViews ;

@end

@protocol ConsoleLongTextInputBarViewDelegate
- (void)didChangeLongTextInputValue:(ConsoleLongTextInputBarView *)view value:(NSString *)value ;
@end
