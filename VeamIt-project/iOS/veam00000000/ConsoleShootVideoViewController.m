//
//  ConsoleShootVideoViewController.m
//  veam00000000
//
//  Created by veam on 7/11/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "ConsoleShootVideoViewController.h"
#import "VeamUtil.h"
#import "ConsoleAppDelegate.h"

#define VEAM_MAX_RECORD_TIME 180

@interface ConsoleShootVideoViewController ()

@end

@implementation ConsoleShootVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.screenName = [VeamUtil makeScreenName:@"Camera/"] ;
    
    launchingEditViewController = NO ;
    
    if([VeamImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        isNotAllowedCamra = NO ;
    } else {
        isNotAllowedCamra = YES ;
    }
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self.navigationController setNavigationBarHidden:YES] ;
    [self.view setBackgroundColor:[UIColor blackColor]] ;
    
    self.imagePickerController = [[VeamImagePickerController alloc] init];
    self.imagePickerController.delegate = self ;
    
}

- (void)showCamera
{
    if(!launchingEditViewController){
        if(!isNotAllowedCamra){
            [self setupImagePicker:UIImagePickerControllerSourceTypeCamera] ;
        } else {
            //[self showLibrary] ;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"viewDidAppear");
    /*
     id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker] ;  // Get the tracker object.
     [tracker set:[GAIFields customDimensionForIndex:1] value:[VeamUtil getTrackingId]] ;
     */
    [super viewDidAppear:animated];
    
    [self performSelectorOnMainThread:@selector(showCamera) withObject:nil waitUntilDone:NO] ;
    recordStopped = NO ;
    [shutterImageView setImage:[UIImage imageNamed:@"snap_record_off.png"]] ;
    [circleProgressView setElapsedTime:0] ;
}

/*
- (void)showLibrary
{
    VeamImagePickerController *imagePickerControllerLibrary = [[VeamImagePickerController alloc] init];
    imagePickerControllerLibrary.allowsImageEditing = YES ;
    imagePickerControllerLibrary.delegate = self ;
    imagePickerControllerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    //self.navigationController.navigationBar.hidden=YES;
    [self presentModalViewController:imagePickerControllerLibrary animated:YES];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    currentCameraDevice = UIImagePickerControllerCameraDeviceRear ;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera){
        // user wants to use the camera interface
        //
        self.imagePickerController.showsCameraControls = NO;
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0){
            
            // 動画撮影用の設定
            self.imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
            // UIImagePickerControllerCameraCaptureModeVideo
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo ;
            
            
            //baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] ;
            baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [VeamUtil getScreenHeight])] ;
            
            CGFloat topBarHeight = [VeamUtil getTopBarHeight] ;
            //CGFloat buttonHeight = 35 ;
            CGFloat bottomBarHeight = 110 ;
            CGFloat bottomY = [VeamUtil getScreenHeight] - bottomBarHeight ;
            
            topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], topBarHeight)] ;
            [topBarView setBackgroundColor:[UIColor blackColor]] ;
            [baseView addSubview: topBarView] ;
            
            bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, [VeamUtil getScreenWidth], bottomBarHeight)] ;
            [bottomBarView setBackgroundColor:[UIColor blackColor]] ;
            [baseView addSubview:bottomBarView] ;
            
            UIImageView *cancelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)] ;
            [cancelImageView setImage:[UIImage imageNamed:@"top_bar_back.png"]] ;
            [VeamUtil registerTapAction:cancelImageView target:self selector:@selector(onCancelButtonTap)] ;
            [baseView addSubview:cancelImageView] ;
            
            UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 160, topBarHeight)] ;
            [cancelLabel setBackgroundColor:[UIColor clearColor]] ;
            [cancelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
            [cancelLabel setTextColor:[UIColor whiteColor]] ;
            [cancelLabel setText:NSLocalizedString(@"cancel",nil)] ;
            [VeamUtil registerTapAction:cancelLabel target:self selector:@selector(onCancelButtonTap)] ;
            [baseView addSubview:cancelLabel] ;
            
            UIImage *image = [UIImage imageNamed:@"change_camera.png"] ;
            CGFloat imageWidth = image.size.width / 2 ;
            CGFloat imageHeight = image.size.height / 2 ;
            UIImageView *changeCameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-50, bottomY+(bottomBarHeight-imageHeight)/2, imageWidth, imageHeight)] ;
            [changeCameraImageView setImage:image] ;
            [VeamUtil registerTapAction:changeCameraImageView target:self selector:@selector(onChangeCameraButtonTap)] ;
            [baseView addSubview:changeCameraImageView] ;
            
            image = [UIImage imageNamed:@"snap_record_off.png"] ;
            imageWidth = image.size.width / 2 ;
            imageHeight = image.size.height / 2 ;
            shutterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, bottomY+(bottomBarHeight-imageHeight)/2, imageWidth, imageHeight)] ;
            [shutterImageView setImage:image] ;
            [shutterImageView setUserInteractionEnabled:YES] ;
            //[baseView setUserInteractionEnabled:YES] ;
            //[VeamUtil registerTapAction:shutterImageView target:self selector:@selector(onShutterButtonTap)] ;
            [baseView addSubview:shutterImageView] ;
            
            CGFloat margin = 3.5 ;
            CGRect frame = shutterImageView.frame ;
            frame.origin.x += margin ;
            frame.origin.y += margin ;
            frame.size.width -= margin * 2 ;
            frame.size.height -= margin * 2 ;
            circleProgressView = [[CircleProgressView alloc] initWithFrame:frame] ;
            [circleProgressView setTimeLimit:VEAM_MAX_RECORD_TIME] ;
            [circleProgressView setElapsedTime:0] ;
            [circleProgressView setUserInteractionEnabled:NO] ;
            [baseView addSubview:circleProgressView] ;
            
            /*
             CGFloat selecteLabelHeight = 30 ;
             UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, bottomY+(bottomBarHeight-selecteLabelHeight)/2, 60, selecteLabelHeight)] ;
             [selectLabel setBackgroundColor:[UIColor clearColor]] ;
             [selectLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
             [selectLabel setTextColor:[UIColor whiteColor]] ;
             [selectLabel setText:NSLocalizedString(@"select",nil)] ;
             [VeamUtil registerTapAction:selectLabel target:self selector:@selector(onSelectButtonTap)] ;
             [baseView addSubview:selectLabel] ;
             */
            
            UIView *leftMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, 4, [VeamUtil getScreenHeight]-topBarHeight-bottomBarHeight)] ;
            [leftMaskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF222222"]] ;
            [baseView addSubview:leftMaskView] ;
            
            UIView *rightMaskView = [[UIView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-4, topBarHeight, 4, [VeamUtil getScreenHeight]-topBarHeight-bottomBarHeight)] ;
            [rightMaskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF222222"]] ;
            [baseView addSubview:rightMaskView] ;
            
            CGFloat maskViewHeight = (([VeamUtil getScreenHeight] - topBarHeight - bottomBarHeight) - [VeamUtil getScreenWidth]) / 2 ;
            UIView *topMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, [VeamUtil getScreenWidth],maskViewHeight)] ;
            [topMaskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF222222"]] ;
            [baseView addSubview:topMaskView] ;
            cameraTop = topBarHeight + maskViewHeight ;
            
            UIView *bottomMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight+maskViewHeight+[VeamUtil getScreenWidth], [VeamUtil getScreenWidth],maskViewHeight)] ;
            [bottomMaskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF222222"]] ;
            [baseView addSubview:bottomMaskView] ;
            
            self.imagePickerController.cameraOverlayView = baseView;
            [self.imagePickerController setShutterImageView:shutterImageView] ;
            [self.imagePickerController setShutterDelegate:self] ;
        }
        //[self presentViewController:self.imagePickerController animated:YES completion:nil];
        //[self presentModalViewController:self.imagePickerController animated:YES];
        
        /*
         UIView *controllerView = self.imagePickerController.view;
         
         controllerView.alpha = 0.0;
         controllerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
         
         [[[[UIApplication sharedApplication] delegate] window] addSubview:controllerView];
         
         [UIView animateWithDuration:0.3
         delay:0.0
         options:UIViewAnimationOptionCurveLinear
         animations:^{
         controllerView.alpha = 1.0;
         }
         completion:nil
         ];
         */
        
        [self presentModalViewController:self.imagePickerController animated:NO];
    }
}

- (void)onCancelButtonTap
{
    //NSLog(@"cancel tapped") ;
    [[AppDelegate sharedInstance] backFromVideoCamera] ;
    //[VeamUtil showTabBarController:-1] ;
}

- (void)onChangeCameraButtonTap
{
    
    //NSLog(@"change camera tapped") ;
    if(currentCameraDevice == UIImagePickerControllerCameraDeviceRear){        currentCameraDevice = UIImagePickerControllerCameraDeviceFront ;
    } else {
        currentCameraDevice = UIImagePickerControllerCameraDeviceRear ;
    }
    [self.imagePickerController setCameraDevice:currentCameraDevice] ;
}


-(void)countTime:(NSTimer*)timer
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] ;
    CGFloat recordTime = currentTime - startTime ;
    [circleProgressView setElapsedTime:recordTime] ;
    if(recordTime > VEAM_MAX_RECORD_TIME){
        [self shutterTouchesEnded] ;
    }
    //NSLog(@"recorded %f",recordTime) ;
}

- (void)shutterImageOn
{
    [shutterImageView setImage:[UIImage imageNamed:@"snap_record_on.png"]] ;
}

- (void) shutterTouchesBegan
{
    //NSLog(@"shutter touch down") ;
    [self performSelectorOnMainThread:@selector(shutterImageOn) withObject:nil waitUntilDone:NO] ;
    [self.imagePickerController startVideoCapture] ;
    startTime = [[NSDate date] timeIntervalSince1970] ;
    [self stopTimer] ;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(countTime:) userInfo:nil repeats:YES] ;
}

- (void)stopTimer
{
    if(timer != nil){
        [timer invalidate] ;
        timer = nil ;
    }
}

- (void) shutterTouchesEnded
{
    //NSLog(@"shutter touch up") ;
    [self stopTimer] ;
    if(!recordStopped){
        recordStopped = YES ;
        [self.imagePickerController stopVideoCapture] ;
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970] ;
        CGFloat recordTime = endTime - startTime ;
        //NSLog(@"recorded %f",recordTime) ;
    }
}

- (void)onShutterButtonTap
{
    //NSLog(@"shutter tapped") ;
    //[self.imagePickerController takePicture];
    if(recording){
        [self.imagePickerController stopVideoCapture] ;
        recording = NO ;
    } else {
        [self.imagePickerController startVideoCapture] ;
        recording = YES ;
    }
}

- (void)onSelectButtonTap
{
    //NSLog(@"select tapped") ;
    isNotAllowedCamra = YES ;
    
    [self dismissModalViewControllerAnimated:YES] ;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(VeamImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"didFinishPickingMediaWithInfo url=%@",[info valueForKey:@"UIImagePickerControllerMediaURL"]) ;
    movieUrl = [info valueForKey:@"UIImagePickerControllerMediaURL"] ;
    
    if(movieUrl != nil){
        launchingEditViewController = YES ;
        [self dismissViewControllerAnimated:YES completion:^{
            //NSLog(@"completion : show edit view controller") ;
            [self performSelectorOnMainThread:@selector(launchImageEditViewController) withObject:nil waitUntilDone:NO] ;
        }] ;
    }
}

- (void)launchImageEditViewController
{
    //NSLog(@"launchImageShareViewController") ;
    [[AppDelegate sharedInstance] setShotMovieUrl:movieUrl] ;
    [self onCancelButtonTap] ;
    /*
    ImageShareViewController *imageShareViewController = [[ImageShareViewController alloc] initWithNibName:@"ImageShareViewController" bundle:nil] ;
    [imageShareViewController setTargetMovieUrl:movieUrl] ;
    [imageShareViewController setTitleName:@"Share"] ;
    [imageShareViewController setForumId:forumId] ;
    [self.navigationController pushViewController:imageShareViewController animated:YES] ;
    launchingEditViewController = NO ;
     */
}


// アラートを表示させる部分は、image:didFinishSavingWithError:contextInfo:という書式が必須らしい
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // アラートを表示する
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存終了" message:@"画像を保存しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
}


- (void)imagePickerControllerDidCancel:(VeamImagePickerController *)picker
{
    //NSLog(@"canceled") ;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        isNotAllowedCamra = NO ;
    } else {
        [self onCancelButtonTap] ;
    }
    [self dismissModalViewControllerAnimated:YES] ;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}



@end
