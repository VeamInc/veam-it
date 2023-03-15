//
//  ConsoleTextSelectBarView.h
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"

@protocol ConsoleTextSelectBarViewDelegate ;

@interface ConsoleTextSelectBarView : ConsoleBarView
{
    //UILabel *titleLabel ;
    UILabel *valueLabel ;
    NSString *hintString ;
}

@property (nonatomic, weak) id <ConsoleTextSelectBarViewDelegate> delegate ;
@property(nonatomic,retain)NSString *inputValue ;
@property(nonatomic,retain)NSString *selectionValue ;
@property(nonatomic,retain)NSArray *selections ;
@property(nonatomic,retain)NSArray *selectionValues ;

//- (void)setTitle:(NSString *)title ;
- (void)setInputValue:(NSString *)value ;
- (NSString *)getInputValue ;
- (void)setSelectionValue:(NSString *)selectionValue ;
- (NSString *)getSelectionValue ;
- (void)showInputView ;

@end

@protocol ConsoleTextSelectBarViewDelegate
- (void)didChangeTextSelectValue:(ConsoleTextSelectBarView *)view inputValue:(NSString *)inputValue selectionValue:(NSString *)selectionValue ;
@end

