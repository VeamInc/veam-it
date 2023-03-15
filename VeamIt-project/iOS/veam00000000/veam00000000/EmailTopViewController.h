//
//  EmailTopViewController.h
//  veam00000000
//
//  Created by veam on 12/22/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"

@interface EmailTopViewController : VeamViewController
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

@end
