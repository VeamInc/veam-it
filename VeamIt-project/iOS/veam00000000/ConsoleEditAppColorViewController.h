//
//  ConsoleEditAppColorViewController.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleColorPickBarView.h"

@interface ConsoleEditAppColorViewController : ConsoleViewController <ConsoleColorPickBarViewDelegate>
{
    NSArray *colorNames ;

    ConsoleColorPickBarView *topBarColorPickBarView ;
    ConsoleColorPickBarView *topBarTitleColorPickBarView ;
    ConsoleColorPickBarView *tabTextColorPickBarView ;
    ConsoleColorPickBarView *hilightedTextColorPickBarView ;
    ConsoleColorPickBarView *tableSelectionColorPickBarView ;
}


- (id)init ;

@end
