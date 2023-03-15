//
//  EmailSignUpViewController.h
//  veam00000000
//
//  Created by veam on 12/26/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "GKImagePicker.h"

@interface EmailSignUpViewController : VeamViewController
{
    UIView *maskView ;
    UIActivityIndicatorView *maskIndicator ;
    CGFloat contentWidth ;
    CGFloat contentHeight ;
    UIView *contentView ;
    UITextField *firstNameField ;
    UITextField *lastNameField ;
    UITextField *emailField ;
    UITextField *passwordField ;
    UIView *profilePictureField ;
    UILabel *profilePictureLabel ;
    
    UILabel *createButtonView ;
    UIImage *loginImageGray ;
    UIImage *loginImageWhite ;
    UIImageView *loginImageView ;
    
    BOOL isFirstNameEntered ;
    BOOL isLastNameEntered ;
    BOOL isEmailEntered ;
    BOOL isPasswordEntered ;
    BOOL isProfilePictureEntered ;
    
    NSString *emailUserId ;
    NSString *userName ;
    NSString *secret ;
    
    BOOL shouldBackScreen ;
    NSString *messageTitle ;
    NSString *messageBody ;
    
    GKImagePicker *gkImagePicker ;
    UIImage *profileImage ;
    
}

@property(nonatomic,assign)CGFloat displayWidth ;
@property(nonatomic,assign)CGFloat displayHeight ;
@property(nonatomic,assign)CGFloat cropWidth ;
@property(nonatomic,assign)CGFloat cropHeight ;

@end
