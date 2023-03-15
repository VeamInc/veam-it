//
//  ConsoleShootVideoViewController.h
//  veam00000000
//
//  Created by veam on 7/11/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsoleViewController.h"
#import "CircleProgressView.h"
#import "VeamImagePickerController.h"


@interface ConsoleShootVideoViewController : ConsoleViewController<UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *baseView ;
    UIView *topBarView ;
    UIView *bottomBarView ;
    UIButton *cancelButton ;
    UIButton *changeCameraButton ;
    UIButton *shutterButton ;
    UIButton *selectButton ;
    UIImagePickerControllerCameraDevice currentCameraDevice ;
    BOOL isNotAllowedCamra ;
    CGFloat cameraTop ;
    UIImage *resizedImage ;
    NSURL *movieUrl ;
    BOOL launchingEditViewController ;
    BOOL recording ;
    NSTimeInterval startTime ;
    NSTimer *timer ;
    CircleProgressView *circleProgressView ;
    UIImageView *shutterImageView ;
    BOOL recordStopped ;
}

@property (nonatomic, retain) VeamImagePickerController *imagePickerController ;



@end
