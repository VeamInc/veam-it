//
//  ConsoleEditSectionPaymentDescriptionViewController.h
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditSectionPaymentDescriptionViewController : ConsoleViewController
{
    ConsoleContents *contents ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
}

@property(nonatomic,assign)BOOL showCustomizeFirst ;

@end
