//
//  ConsoleTutorialViewController.h
//  veam00000000
//
//  Created by veam on 2/17/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTutorialElement.h"


@interface ConsoleTutorialViewController : ConsoleViewController
{
    NSMutableArray *elements ;
    NSInteger currentIndex ;
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
    
}

@property(nonatomic,assign)NSInteger tutorialKind ;


@end
