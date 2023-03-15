//
//  ConsoleSubscriptionSettingsViewController.h
//  veam00000000
//
//  Created by veam on 6/17/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleTextSelectBarView.h"
#import "ConsoleSwitchBarView.h"
#import "ConsoleImageInputBarView.h"

@interface ConsoleSubscriptionSettingsViewController : ConsoleViewController <ConsoleImageInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleTextSelectBarView *priceInputBarView ;
    ConsoleSwitchBarView *layoutInputBarView ;
    ConsoleTextSelectBarView *kindInputBarView ;
    ConsoleImageInputBarView *rightImageInputBarView ;
}

- (id)init ;

@end
