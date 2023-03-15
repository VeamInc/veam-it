//
//  ConsoleYoutubeUserInputViewController.h
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterViewController.h"

@interface ConsoleYoutubeUserInputViewController : ConsoleStarterViewController
{
    UIView *inputView ;
    UITextField *userNameField ;
    BOOL shouldContinueBlinking ;
    CGFloat totalBlinkTime ;
    NSTimer *blinkTimer ;
    NSString *channelTitle ;
    
}

@end
