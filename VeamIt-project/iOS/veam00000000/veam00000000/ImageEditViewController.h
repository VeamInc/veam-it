//
//  ImageEditViewController.h
//  CameraTest
//
//  Created by veam on 7/9/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"

@interface ImageEditViewController : VeamViewController
{
    CGFloat currentDegree ;
    UIImageView *imageView ;
}

@property (nonatomic, retain) UIImage *targetImage ;
@property (nonatomic, retain) NSString *forumId ;

@end
