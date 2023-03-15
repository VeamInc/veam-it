//
//  ConsoleBarView.h
//  veam00000000
//
//  Created by veam on 5/30/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleBarView : UIView
{
    UILabel *titleLabel ;
    UIView *bottomLine ;
    BOOL fullBottomLine ;
    CGFloat titleRight ;
}

- (void)setFullBottomLine:(BOOL)full ;
- (void)hideBottomLine ;
- (void)setTitle:(NSString *)title ;
- (void)addTitleLabel ;


@end
