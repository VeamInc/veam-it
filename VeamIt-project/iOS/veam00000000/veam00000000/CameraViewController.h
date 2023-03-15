//
//  CameraViewController.h
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface CameraViewController : GAITrackedViewController<UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
    BOOL launchingEditViewController ;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController ;
@property (nonatomic, retain) NSString *forumId ;

@end
