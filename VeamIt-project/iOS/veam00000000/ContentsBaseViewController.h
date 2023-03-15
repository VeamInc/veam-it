//
//  ContentsBaseViewController.h
//  Stats
//
//  Created by veam on 2014/08/27.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "ViewController.h"

@interface ContentsBaseViewController : ViewController

@property id target;
@property SEL viewChangedSelector;
@property SEL viewChangeingSelector;

@property (nonatomic,retain) NSString *appId ;

-(void)updateView;

-(void)selectCell:(NSInteger)pageNo;

@end
