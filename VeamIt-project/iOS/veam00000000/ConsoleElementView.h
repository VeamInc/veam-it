//
//  ConsoleElementView.h
//  veam00000000
//
//  Created by veam on 5/28/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleElementView : UIView
{
    UIImageView *iconImageView ;
    UILabel *titleLabel ;
}

- (id)initWithX:(CGFloat)x y:(CGFloat)y iconImage:(UIImage *)iconImage title:(NSString *)title ;

- (void)setIconImage:(UIImage *)image ;
- (void)setTitle:(NSString *)title ;

@end
