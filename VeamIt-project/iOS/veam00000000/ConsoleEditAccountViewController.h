//
//  ConsoleEditAccountViewController.h
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditAccountViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *emailInputBarView ;
    ConsoleTextInputBarView *passwordInputBarView ;
}

@end
