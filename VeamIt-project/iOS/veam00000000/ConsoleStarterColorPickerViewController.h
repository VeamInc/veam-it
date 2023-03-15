//
//  ConsoleStarterColorPickerViewController.h
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterViewController.h"

#import "RSColorPickerView.h"
#import "RSColorFunctions.h"

@class RSBrightnessSlider ;
@class RSOpacitySlider ;

@interface ConsoleStarterColorPickerViewController : ConsoleStarterViewController<RSColorPickerViewDelegate>
{
    BOOL isSmallSize ;
    BOOL colorSending ; 
}

@property (nonatomic) RSColorPickerView *colorPicker ;
@property (nonatomic) RSBrightnessSlider *brightnessSlider ;
@property (nonatomic) RSOpacitySlider *opacitySlider ;
@property (nonatomic) UIView *colorPatch ;
@property UILabel *rgbLabel ;

@end
