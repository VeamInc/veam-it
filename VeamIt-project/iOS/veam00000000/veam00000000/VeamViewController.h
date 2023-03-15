//
//  VeamViewController.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface VeamViewController : GAITrackedViewController
{
    UIView *topBarView ;
    UILabel *topBarLabel ;
    CGFloat topBarTitleMinLeft ;
    CGFloat topBarTitleMaxRight ;

    UIImageView *topBarImageView ;
    UIImageView *topBarVeamImageView ;
    UIImageView *backgroundImageView ;
    UIImageView *topBarBackImageView ;
    UIImageView *settingsImageView ;
    CGFloat topBarTitleLeftPosition ;
    UIView *statusBarBackView ;
    BOOL preventVeamIcon ;
}

@property (nonatomic, retain) NSString *titleName ;
@property (nonatomic, retain) UIImage *topBarIcon ;
@property (nonatomic, assign) NSInteger topBarIconKind ;

- (void)addTopBar:(BOOL)showBackButton showSettingsButton:(BOOL)showSettingsButton ;
- (void)restrictTopBarLabelWidth ;
- (void)setViewName:(NSString *)viewName ;
-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter ;

@end
