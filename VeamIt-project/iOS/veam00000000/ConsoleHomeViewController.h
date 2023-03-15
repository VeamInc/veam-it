//
//  ConsoleHomeViewController.h
//  veam00000000
//
//  Created by veam on 8/29/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartsView.h"

#define VEAM_CONSOLE_HOME_MODE_NOT_INSTALLED        1
#define VEAM_CONSOLE_HOME_MODE_INSTALLING           2
#define VEAM_CONSOLE_HOME_MODE_INSTALLED            3

@interface ConsoleHomeViewController : UIViewController
{
    UIView *iconMaskView ;
    UILabel *iconLabel ;
    UILabel *countDownLabel ;
    UILabel *countDownView ;
    NSInteger currentCount ;
    NSInteger countDownIndex ;
    NSArray *countDownText ;
    NSArray *countDownStartAlpha ;
    NSArray *countDownEndAlpha ;
    NSArray *countDownSize ;
    NSArray *countDownDuration ;
    NSTimer *countDownTimer ;
    BOOL notCountDownYet ;
    PieChartsView *pieView ;
    CGFloat currentProgress ;
    
    UIImageView *iconImageView ;
    UIImageView *launchImageView ;
}

@property (nonatomic, retain) UIImage *targetIconImage ;
@property (nonatomic, assign) NSInteger mode ;
@property (nonatomic, assign) BOOL withoutCountDown ;


@end
