//
//  ConsoleSideMenuElementView.h
//  ColorPickerTest
//
//  Created by veam on 8/26/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SIDE_MENU_ELEMENT_STYLE_ICON    1
#define SIDE_MENU_ELEMENT_STYLE_TEXT    2

@interface ConsoleSideMenuElementView : UIView


@property (nonatomic, assign) NSInteger elementStyle ;
@property (nonatomic, retain) UIImageView *iconImageView ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, assign) NSInteger badge ;

- (void)setIconFileName:(NSString *)iconFileName title:(NSString *)title badge:(NSInteger)badge ;
- (void)setTitle:(NSString *)title badge:(NSInteger)badge ;
- (void)setTitleColor:(UIColor *)color ;
@end
