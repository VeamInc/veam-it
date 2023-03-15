//
//  VeamTabBarController.m
//  veam31000000
//
//  Created by veam on 7/26/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamTabBarController.h"
//#import "DRMMovieViewController.h"

@interface VeamTabBarController ()

@end

@implementation VeamTabBarController

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"VeamTabBarController::supportedInterfaceOrientations") ;
    return UIInterfaceOrientationMaskPortrait ;
    
    /*
     
    //NSLog(@"MyTabBarController::supportedInterfaceOrientations") ;
    if ([[self.viewControllers lastObject] isKindOfClass:[DRMMovieViewController class]]) {
    //if (NO) {
        //NSLog(@"movie") ;
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        //NSLog(@"not movie") ;
        return UIInterfaceOrientationMaskPortrait;
    }
    */
}

- (BOOL)shouldAutorotate
{
    //NSLog(@"MyTabBarController::shouldAutorotate") ;
    return YES;
}

@end