//
//  VeamNavigationController.m
//  veam31000000
//
//  Created by veam on 7/26/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamNavigationController.h"

@interface VeamNavigationController ()

@end

@implementation VeamNavigationController

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"VeamNavigationController::supportedInterfaceOrientations") ;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    //NSLog(@"VeamNavigationController::shouldAutorotate") ;
    return YES;
}


@end
