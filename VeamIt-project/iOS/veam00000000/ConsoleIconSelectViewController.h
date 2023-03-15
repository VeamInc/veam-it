//
//  ConsoleIconSelectViewController.h
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterViewController.h"
#import "GKImagePicker.h"


@interface ConsoleIconSelectViewController : ConsoleStarterViewController<UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
    BOOL isClosing ;
    UIImage *resizedImage ;
    BOOL shouldLaunchEditViewController ;
    BOOL launchingEditViewController ;
    GKImagePicker *gkImagePicker ;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController ;
@property (nonatomic, retain) NSString *forumId ;

@end
