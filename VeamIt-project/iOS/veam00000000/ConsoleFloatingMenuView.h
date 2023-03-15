//
//  ConsoleFloatingMenuView.h
//  veam00000000
//
//  Created by veam on 9/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConsoleFloatingMenuViewDelegate ;

@interface ConsoleFloatingMenuView : UIView
{
    NSArray *menuElements ;
}

@property (nonatomic, weak) id <ConsoleFloatingMenuViewDelegate> delegate ;

- (void)setMenuElement:(NSArray *)elements ;
+ (CGFloat)getMenuHeight ;

@property (nonatomic,retain) UIColor *highlightedBackgroundColor ;
@property (nonatomic,retain) UIColor *highlightedTextColor ;

@end

@protocol ConsoleFloatingMenuViewDelegate
- (void)didTapFloatingMenu:(NSInteger)index ;
@end
