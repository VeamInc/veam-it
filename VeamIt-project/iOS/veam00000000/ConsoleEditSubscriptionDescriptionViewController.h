//
//  ConsoleEditSubscriptionDescriptionViewController.h
//  veam00000000
//
//  Created by veam on 9/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditSubscriptionDescriptionViewController : ConsoleViewController
{
    ConsoleContents *contents ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
}

@property(nonatomic,assign)BOOL showCustomizeFirst ;

@end
