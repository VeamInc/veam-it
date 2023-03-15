//
//  EmailLoginViewController.h
//  veam00000000
//
//  Created by veam on 12/22/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"

@interface EmailLoginViewController : VeamViewController
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
    
    NSString *emailUserId ;
    NSString *userName ;
    NSString *secret ;
    
    
    UIAlertView *resetAlertView ;
    
    NSString *messageTitle ;
    NSString *messageBody ;
    
}

@end
