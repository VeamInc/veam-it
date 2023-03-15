//
//  UIColor+RGB.m
//  TestWebapi2
//
//  Created by veam on 2014/01/24.
//  Copyright (c) 2014年 veam All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor *)colorWithRGB:(float)alpha red:(float)red green:(float)green blue:(float)blue
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}
@end
