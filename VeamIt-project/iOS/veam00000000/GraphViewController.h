//
//  GraphViewController.h
//  Stats
//
//  Created by veam on 2014/09/20.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "ViewController.h"

@interface GraphViewController : ViewController{
    CGFloat _graphData[7];
    CGFloat _graphMax;
}

@property NSInteger pageNumber;

-(void)updateView;

@end
