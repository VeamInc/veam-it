//
//  ConsoleStarterViewController.h
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleStarterViewController : UIViewController
{
    UIView *headerView ;
    
    UIImageView *headerBackImageView ;
    UILabel *headerBackLabel ;
    UILabel *headerNextLabel ;
    UIActivityIndicatorView *nextIndicator ;
    UIActivityIndicatorView *maskIndicator ;
    UIView *maskView ;
    
}

@property (nonatomic,assign) BOOL launchFromPreview ;
@property (nonatomic,assign) BOOL showBackButton ;
@property (nonatomic,retain) NSString *nextButtonText ;

- (void)showHeader:(NSString *)title backgroundColor:(UIColor *)backgroundColor ;
- (void)hideHeader ;
- (void)showMask:(BOOL)show ;
- (void)didHeaderBackTap ;

@end
