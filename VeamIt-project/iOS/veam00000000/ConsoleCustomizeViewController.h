//
//  ConsoleCustomizeViewController.h
//  veam00000000
//
//  Created by veam on 9/8/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleCustomizeElement.h"

@interface ConsoleCustomizeViewController : ConsoleViewController
{
    NSMutableArray *elements ;
    NSInteger currentIndex ;
    NSString *imageFileNameFormat ;
    UIImageView *mainImageView ;
    UIImageView *animationImageView ;
    UIImageView *nextImageView ;
    UIImageView *prevImageView ;
    CGRect mainFrame ;
    
    UILabel *titleLabel ;
    UILabel *descriptionLabel ;
    
    UIImage *dotOffImage ;
    UIImage *dotOnImage ;
    NSInteger numberOfElements ;
    NSMutableArray *dotImageViews ;
    
    UIScrollView *contentScrollView ;
    
    ConsoleImageInputBarView *backgroundImageInputBarView ;
    ConsoleImageInputBarView *iconImageInputBarView ;
    ConsoleImageInputBarView *youtubeImageInputBarView ;
    
    UIView *progressView ;
    UIActivityIndicatorView *progressIndicator ;
    
}

@property(nonatomic,assign)NSInteger customizeKind ;

@end
