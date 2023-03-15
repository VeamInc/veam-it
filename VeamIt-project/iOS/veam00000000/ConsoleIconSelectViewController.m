//
//  ConsoleIconSelectViewController.m
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleIconSelectViewController.h"
#import "VeamUtil.h"
#import "ConsoleUtil.h"
#import "ConsoleIconEditViewController.h"

#define VEAM_CONSOLE_ICON_SIZE  1024

@interface ConsoleIconSelectViewController ()

@end

@implementation ConsoleIconSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ConsoleUtil updateConsoleContents] ;

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        isNotAllowedCamra = NO ;
    } else {
        isNotAllowedCamra = YES ;
    }
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self.navigationController setNavigationBarHidden:YES] ;
    [self.view setBackgroundColor:[UIColor blackColor]] ;
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self ;

    
    [self showHeader:@"Upload Your Photo" backgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
}

- (void)showCamera
{
    if(!launchingEditViewController){
        if(!isNotAllowedCamra){
            [self setupImagePicker:UIImagePickerControllerSourceTypeCamera] ;
        } else {
            [self showLibrary] ;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    if(!isClosing){
        [self performSelectorOnMainThread:@selector(showCamera) withObject:nil waitUntilDone:NO] ;
    }
    
    if(shouldLaunchEditViewController){
        shouldLaunchEditViewController = NO ;
        [self performSelectorOnMainThread:@selector(launchIconEditViewController) withObject:nil waitUntilDone:NO] ;
    }
       
}

- (void)showLibrary
{
    /*
    UIImagePickerController *imagePickerControllerLibrary = [[UIImagePickerController alloc] init];
    imagePickerControllerLibrary.allowsImageEditing = YES ;
    imagePickerControllerLibrary.delegate = self ;
    imagePickerControllerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    //self.navigationController.navigationBar.hidden=YES;
    [self presentModalViewController:imagePickerControllerLibrary animated:YES];
     */
    CGFloat squareSize = [VeamUtil getScreenWidth] ;
    
    gkImagePicker = [[GKImagePicker alloc] init] ;
    gkImagePicker.cropSize = CGSizeMake(squareSize,squareSize) ;
    gkImagePicker.delegate = self ;
    gkImagePicker.resizeableCropArea = YES ;
    gkImagePicker.allowResize = NO ;
    [self presentModalViewController:gkImagePicker.imagePickerController animated:YES] ;

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
            //self.imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
            
            
            //baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] ;
            baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [VeamUtil getScreenHeight])] ;
            
            CGFloat topBarHeight = [VeamUtil getTopBarHeight] ;
            //CGFloat buttonHeight = 35 ;
            CGFloat bottomBarHeight = 84 ;
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
            
            UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, topBarHeight)] ;
            [cancelLabel setBackgroundColor:[UIColor clearColor]] ;
            [cancelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
            [cancelLabel setTextColor:[UIColor whiteColor]] ;
            [cancelLabel setText:@"Cancel"] ;
            [VeamUtil registerTapAction:cancelLabel target:self selector:@selector(onCancelButtonTap)] ;
            [baseView addSubview:cancelLabel] ;
            
            UIImage *image = [UIImage imageNamed:@"change_camera.png"] ;
            CGFloat imageWidth = image.size.width / 2 ;
            CGFloat imageHeight = image.size.height / 2 ;
            UIImageView *changeCameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-50, bottomY+(bottomBarHeight-imageHeight)/2, imageWidth, imageHeight)] ;
            [changeCameraImageView setImage:image] ;
            [VeamUtil registerTapAction:changeCameraImageView target:self selector:@selector(onChangeCameraButtonTap)] ;
            [baseView addSubview:changeCameraImageView] ;
            
            image = [UIImage imageNamed:@"shutter.png"] ;
            imageWidth = image.size.width / 2 ;
            imageHeight = image.size.height / 2 ;
            UIImageView *shutterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, bottomY+(bottomBarHeight-imageHeight)/2, imageWidth, imageHeight)] ;
            [shutterImageView setImage:image] ;
            [VeamUtil registerTapAction:shutterImageView target:self selector:@selector(onShutterButtonTap)] ;
            [baseView addSubview:shutterImageView] ;
            
            CGFloat selecteLabelHeight = 30 ;
            UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, bottomY+(bottomBarHeight-selecteLabelHeight)/2, 60, selecteLabelHeight)] ;
            [selectLabel setBackgroundColor:[UIColor clearColor]] ;
            [selectLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
            [selectLabel setTextColor:[UIColor whiteColor]] ;
            [selectLabel setText:NSLocalizedString(@"select",nil)] ;
            [VeamUtil registerTapAction:selectLabel target:self selector:@selector(onSelectButtonTap)] ;
            [baseView addSubview:selectLabel] ;
            
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
        }
        //[self presentViewController:self.imagePickerController animated:YES completion:nil];
        //[self presentModalViewController:self.imagePickerController animated:YES];
        [self presentModalViewController:self.imagePickerController animated:NO];
    }
}

- (void)onCancelButtonTap
{
    //NSLog(@"cancel tapped") ;
    isClosing = YES ;
    [self dismissModalViewControllerAnimated:YES] ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)onChangeCameraButtonTap
{
    
    //NSLog(@"change camera tapped") ;
    if(currentCameraDevice == UIImagePickerControllerCameraDeviceRear){
        currentCameraDevice = UIImagePickerControllerCameraDeviceFront ;
    } else {
        currentCameraDevice = UIImagePickerControllerCameraDeviceRear ;
    }
    [self.imagePickerController setCameraDevice:currentCameraDevice] ;
}

- (void)onShutterButtonTap
{
    //NSLog(@"shutter tapped") ;
    [self.imagePickerController takePicture];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL isResizedImage = NO ;
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        //NSLog(@"UIImagePickerControllerSourceTypePhotoLibrary") ;
        isResizedImage = YES ;
    }
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if(image == nil){
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    //NSLog(@"picked width=%f height=%f",image.size.width,image.size.height) ;
    
    // crop to 320x320
	CGFloat width = image.size.width;
	CGFloat height = image.size.height;
    
    //NSLog(@"imagew = %f imageh = %f",width,height) ;
    
    if(!isResizedImage && (width > height)){
        image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationRight] ;
        CGFloat work = width ;
        width = height ;
        height = work ;
    }
    
    // crop to square
    CGRect rect ;
    if(width == height){
        rect = CGRectMake(0, 0, width, width);
    } else {
        if(isResizedImage){
            rect = CGRectMake(0, (width - height)/2, width, width);
        } else {
            CGFloat sideMargin = 4 ;
            CGFloat topMargin = cameraTop ;
            CGFloat screenWidth = [VeamUtil getScreenWidth] ;
            if([VeamUtil isRunningOnIpad]){
                sideMargin += 17 ;
                screenWidth += 34 ;
            }
            
            CGFloat targetX = width * sideMargin / screenWidth ;
            CGFloat targetY = topMargin * (width / screenWidth) ;
            CGFloat targetSize = width - targetX * 2 ;
            
            //NSLog(@"targetX=%f targetY=%f targetSize=%f sideMargin=%f topMargin=%f screenWidth=%f",targetX,targetY,targetSize,sideMargin,topMargin,screenWidth) ;
            rect = CGRectMake(-targetX, -targetY, targetSize, targetSize) ;
        }
    }
	UIGraphicsBeginImageContext(rect.size);
	[image drawAtPoint:rect.origin];
	UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    CGFloat iconSize = VEAM_CONSOLE_ICON_SIZE ;
    // resize to iconSize x iconSize
    rect = CGRectMake(0, 0, iconSize, iconSize) ;
	CGSize size = CGSizeMake(iconSize, iconSize) ;
	UIGraphicsBeginImageContext(size);
	[squareImage drawInRect:rect];
	resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    if(resizedImage != nil){
        //UIImageWriteToSavedPhotosAlbum( resizedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil );
        
        launchingEditViewController = YES ;
        shouldLaunchEditViewController = YES ;
        [self dismissViewControllerAnimated:YES completion:^{
            //NSLog(@"completion : show ConsoleIconEditViewController 2") ;
            //[self performSelectorOnMainThread:@selector(launchIconEditViewController) withObject:nil waitUntilDone:NO] ;
        }] ;

        /*
        //NSLog(@"diss miss picker") ;
        //[self dismissViewControllerAnimated:NO completion:nil] ;
        [self dismissModalViewControllerAnimated:YES] ;
        
        //NSLog(@"show edit view controller") ;
        ConsoleIconEditViewController *viewController = [[ConsoleIconEditViewController alloc] init] ;
        [viewController setTargetImage:resizedImage] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
         */
    }
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    if(image == nil){
        NSLog(@"image is nil") ;
    }
    //NSLog(@"picked width=%f height=%f",image.size.width,image.size.height) ;
    
    // crop to 320x320
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    //NSLog(@"imagew = %f imageh = %f",width,height) ;
    
    // crop to square
    CGRect rect ;
    if(width < height){
        rect = CGRectMake((height-width)/2, 0, height, height) ;
    } else {
        rect = CGRectMake(0, (width - height)/2, width, width);
    }
    
    UIGraphicsBeginImageContext(rect.size) ;
    //[[UIColor blackColor] setFill] ;
    [[UIColor whiteColor] setFill] ;
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, rect.size.width,rect.size.height)] fill] ;
    [image drawAtPoint:rect.origin] ;
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    
    // resize to 600x600
    rect = CGRectMake(0, 0, VEAM_CONSOLE_ICON_SIZE, VEAM_CONSOLE_ICON_SIZE) ;
    CGSize size = CGSizeMake(VEAM_CONSOLE_ICON_SIZE, VEAM_CONSOLE_ICON_SIZE) ;
    UIGraphicsBeginImageContext(size) ;
    [squareImage drawInRect:rect] ;
    resizedImage = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    
    if(resizedImage != nil){
        //UIImageWriteToSavedPhotosAlbum( resizedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil );
        
        launchingEditViewController = YES ;
        shouldLaunchEditViewController = YES ;
        [self dismissViewControllerAnimated:YES completion:^{
            //NSLog(@"completion : show edit view controller 1") ;
            //[self performSelectorOnMainThread:@selector(launchIconEditViewController) withObject:nil waitUntilDone:NO] ;
        }] ;
    }
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker
{
    //NSLog(@"GKImagePicker canceled") ;
    ////NSLog(@"canceled") ;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        isNotAllowedCamra = NO ;
    } else {
        [self onCancelButtonTap] ;
    }
    [self dismissModalViewControllerAnimated:YES] ;
}



- (void)launchIconEditViewController
{
    //NSLog(@"launchIconEditViewController") ;
    
    //NSLog(@"show edit view controller") ;
    ConsoleIconEditViewController *viewController = [[ConsoleIconEditViewController alloc] init] ;
    [viewController setTargetImage:resizedImage] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    launchingEditViewController = NO ;
}


// アラートを表示させる部分は、image:didFinishSavingWithError:contextInfo:という書式が必須らしい
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	// アラートを表示する
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存終了" message:@"画像を保存しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[alert show];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
