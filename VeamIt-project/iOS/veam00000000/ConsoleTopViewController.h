//
//  ConsoleTopViewController.h
//  veam00000000
//
//  Created by veam on 5/28/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "AQGridView.h"
#import "GKImagePicker.h"

@interface ConsoleTopViewController : ConsoleViewController<AQGridViewDataSource,AQGridViewDelegate,GKImagePickerDelegate>
{
    AQGridView *gridView ;
    NSArray *consoleElements ;
}

@end
