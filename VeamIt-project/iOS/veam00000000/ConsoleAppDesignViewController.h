//
//  ConsoleAppDesignViewController.h
//  veam00000000
//
//  Created by veam on 6/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleImageInputBarView.h"
#import "NEOColorPickerViewController.h"

@interface ConsoleAppDesignViewController : ConsoleViewController <ConsoleImageInputBarViewDelegate,NEOColorPickerViewControllerDelegate>
{
    ConsoleImageInputBarView *backgroundImageInputBarView ;
    ConsoleImageInputBarView *splashImageInputBarView ;
    ConsoleImageInputBarView *iconImageInputBarView ;
}
@end
