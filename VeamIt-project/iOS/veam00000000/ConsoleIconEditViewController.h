//
//  ConsoleIconEditViewController.h
//  veam00000000
//
//  Created by veam on 9/3/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterViewController.h"

@interface ConsoleIconEditViewController : ConsoleStarterViewController
{
    CGFloat currentDegree ;
    UIImageView *imageView ;
    UIImage *rotatedImage ;
    BOOL iconSending ;
}


@property (nonatomic, retain) UIImage *targetImage ;

-(void)requestDidPost:(NSNotification *)notification ;

@end
