//
//  CircleBaseViewController.h
//  Stats
//
//  Created by veam on 2014/08/28.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "ViewController.h"

@interface CircleBaseViewController : ViewController

@property (strong, nonatomic) UIColor* lineColor;
@property (nonatomic) CGFloat percent;

-(void)updateView;

@end
