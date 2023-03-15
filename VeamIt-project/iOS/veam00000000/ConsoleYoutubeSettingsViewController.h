//
//  ConsoleYoutubeSettingsViewController.h
//  veam00000000
//
//  Created by veam on 5/30/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleSwitchBarView.h"
#import "ConsoleImageInputBarView.h"

@interface ConsoleYoutubeSettingsViewController : ConsoleViewController <ConsoleImageInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    /*
    ConsoleSwitchBarView *embedFlagInputBarView ;
    ConsoleTextInputBarView *embedUrlInputBarView ;
     */
    ConsoleImageInputBarView *leftImageInputBarView ;
    ConsoleImageInputBarView *rightImageInputBarView ;
}

- (id)init ;

@end
