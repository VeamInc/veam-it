//
//  BarGraphViewController.h
//  Stats
//
//  Created by veam on 2014/09/29.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RANKING_MAX 6

@interface BarGraphViewController : UIViewController

@property NSInteger pageNumber;

-(void)updateView;

@end
