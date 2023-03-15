//
//  ConsoleAppStoreViewController.h
//  ColorPickerTest
//
//  Created by veam on 8/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsoleViewController.h"
#import "ConsoleContents.h"
#import "ConsoleImageInputBarView.h"

@interface ConsoleAppStoreViewController : ConsoleViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *appTableView ;
    ConsoleContents *contents ;
    NSMutableDictionary *imageDownloadsInProgressForIcon ;
    ConsoleImageInputBarView *screenShot1ImageInputBarView ;
    ConsoleImageInputBarView *screenShot2ImageInputBarView ;
    ConsoleImageInputBarView *screenShot3ImageInputBarView ;
    ConsoleImageInputBarView *screenShot4ImageInputBarView ;
    ConsoleImageInputBarView *screenShot5ImageInputBarView ;
    NSMutableArray *screenShotUploading ;
    
}

@end
