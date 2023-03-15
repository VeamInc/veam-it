//
//  ConsoleSideMenuViewController.h
//  veam00000000
//
//  Created by veam on 8/27/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleSideMenuViewController : ConsoleViewController
{
    UIView *grayView ;
    UIScrollView *menuScrollView ;
    UIImageView *initialImageView ;
    BOOL animationDone ;
    
    UIView *progressView ;
    UIActivityIndicatorView *progressIndicator ;

}

@property (nonatomic, retain) UIImage *initialImage ;

- (void)initialImageTap ;

@end
