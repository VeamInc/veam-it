//
//  ConsoleColorPickBarView.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"
#import "NEOColorPickerViewController.h"

@protocol ConsoleColorPickBarViewDelegate ;

@interface ConsoleColorPickBarView : ConsoleBarView <NEOColorPickerViewControllerDelegate>
{
    //UILabel *titleLabel ;
    UIView *valueLabel ;
}

@property (nonatomic, weak) id <ConsoleColorPickBarViewDelegate> delegate ;
@property(nonatomic,retain)NSString *inputValue ;

//- (void)setTitle:(NSString *)title ;
- (void)setInputValue:(NSString *)value ;
- (void)showInputView ;

@end

@protocol ConsoleColorPickBarViewDelegate
- (void)showColorPicker:(NEOColorPickerViewController *)colorPickerViewController ;
- (void)didChangeColorPickValue:(ConsoleColorPickBarView *)view value:(NSString *)value ;
@end

