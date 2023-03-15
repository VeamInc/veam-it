//
//  ConsoleSwitchBarView.h
//  veam00000000
//
//  Created by veam on 6/6/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"

@protocol ConsoleSwitchBarViewDelegate ;

@interface ConsoleSwitchBarView : ConsoleBarView
{
    //UILabel *titleLabel ;
    UISwitch *valueSwitch ;
}

@property (nonatomic, weak) id <ConsoleSwitchBarViewDelegate> delegate ;

//- (void)setTitle:(NSString *)title ;
- (BOOL)getInputValue ;
- (void)setInputValue:(BOOL)on ;

@end

@protocol ConsoleSwitchBarViewDelegate
- (void)didChangeSwitchValue:(ConsoleSwitchBarView *)view value:(BOOL)value ;
@end

