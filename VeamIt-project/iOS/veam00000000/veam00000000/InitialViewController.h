//
//  InitialViewController.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"


@interface InitialViewController : GAITrackedViewController
{
    UIView *bottomBarView ;
    UIImageView *blurredImageView ;
    UIImageView *splashImageView ;
    NSInteger selectedTab ;
    
    UIView *poweredView ;
    UIView *dummyView ;
}


@end
