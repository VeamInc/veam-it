//
//  ConsoleMixedSettingsViewController.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleMixedSettingsViewController : ConsoleViewController <ConsoleImageInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
}

- (id)init ;

@end
