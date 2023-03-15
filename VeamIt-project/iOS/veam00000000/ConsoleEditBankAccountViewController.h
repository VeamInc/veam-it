//
//  ConsoleEditBankAccountViewController.h
//  veam00000000
//
//  Created by veam on 2/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleLongTextInputBarView.h"

@interface ConsoleEditBankAccountViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleLongTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *routingNumberInputBarView ;
    ConsoleTextInputBarView *accountNumberInputBarView ;
    ConsoleTextInputBarView *accountNameInputBarView ;
    ConsoleTextInputBarView *accountTypeInputBarView ;
    ConsoleLongTextInputBarView *streetAddressInputBarView ;
    ConsoleTextInputBarView *cityInputBarView ;
    ConsoleTextInputBarView *stateInputBarView ;
    ConsoleTextInputBarView *zipCodeInputBarView ;
    
    ConsoleContents *contents ;
}

@property(nonatomic,retain)AppInfo *appInfo ;

- (id)init ;

@end
