//
//  ConsoleStarterLoginViewController.h
//  veam00000000
//
//  Created by veam on 9/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterViewController.h"

@interface ConsoleStarterLoginViewController : ConsoleStarterViewController<UITextFieldDelegate>
{
    UIView *inputView ;
    UITextField *userNameField ;
    UIView *passwordInputView ;
    UITextField *passwordField ;
    
    BOOL shouldContinueBlinking ;
    CGFloat totalBlinkTime ;
    NSTimer *blinkTimer ;
    NSString *channelTitle ;
}
@end
