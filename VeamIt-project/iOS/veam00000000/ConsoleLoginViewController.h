//
//  ConsoleLoginViewController.h
//  veam00000000
//
//  Created by veam on 2/16/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleLoginViewController : UIViewController
{
    UIView *maskView ;
    UIActivityIndicatorView *maskIndicator ;
    CGFloat contentWidth ;
    CGFloat contentHeight ;
    UIView *contentView ;
    UITextField *emailField ;
    UITextField *passwordField ;
    
    UIView *loginButtonView ;
    UIImage *loginImageGray ;
    UIImage *loginImageWhite ;
    UIImageView *loginImageView ;
    
    BOOL isEmailEntered ;
    BOOL isPasswordEntered ;

}

@end
