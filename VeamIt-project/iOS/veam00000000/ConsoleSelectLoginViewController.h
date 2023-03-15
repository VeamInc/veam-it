//
//  ConsoleSelectLoginViewController.h
//  veam00000000
//
//  Created by veam on 2/13/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleSelectLoginViewController : UIViewController
{
    NSInteger numberOfImages ;
    NSInteger currentImageIndex ;
    NSMutableArray *dotImageViews ;
    UIImage *dotOnImage ;
    UIImage *dotOffImage ;
    NSMutableArray *topImages ;
    UIImageView *topImageView ;
    UIImageView *topAnimationImageView ;
    CGRect initialTopImageFrame ;
    CGFloat contentWidth ;
    CGFloat contentHeight ;
}

@property (nonatomic,assign) BOOL launchFromPreview ;

@end
