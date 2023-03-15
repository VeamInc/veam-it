//
//  ConsoleIconEditViewController.m
//  veam00000000
//
//  Created by veam on 9/3/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleIconEditViewController.h"
#import "VeamUtil.h"
#import "ConsoleUtil.h"
#import "ConsoleHomeViewController.h"

@interface ConsoleIconEditViewController ()

@end

@implementation ConsoleIconEditViewController

@synthesize targetImage ;

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
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter] ;
    [notificationCenter addObserver:self selector:@selector(requestDidPost:) name:CONSOLE_REQUEST_POSTED_NOTIFICATION_ID object:nil] ;
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [maskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF222222"]] ;
    [self.view addSubview:maskView] ;
    
    currentDegree = 0 ;
    
    CGFloat topBarHeight = 44 ;
    CGFloat bottomBarHeight = 84 ;
    CGFloat screenHeight = [VeamUtil getScreenHeight] ;
    
    CGFloat bottomY = screenHeight - bottomBarHeight ;
    
    CGFloat margin = 4 ;
    CGFloat imageViewSize = [VeamUtil getScreenWidth] - margin * 2 ;
    CGFloat topMargin = (screenHeight - topBarHeight - bottomBarHeight - imageViewSize) / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, topBarHeight+topMargin, imageViewSize, imageViewSize)] ;
    [imageView setImage:targetImage] ;
    [self.view addSubview:imageView] ;
    
    UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0,bottomY,[VeamUtil getScreenWidth],bottomBarHeight)] ;
    [bottomBarView setBackgroundColor:[UIColor blackColor]] ;
    [self.view addSubview:bottomBarView] ;
    
    UIImage *image = [VeamUtil imageNamed:@"rotate.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    UIImageView *rotateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth] - imageWidth)/2,bottomY + (bottomBarHeight - imageHeight)/2, imageWidth, imageHeight)] ;
    [rotateImageView setImage:image] ;
    [VeamUtil registerTapAction:rotateImageView target:self selector:@selector(onRotateButtonTap)] ;
    [self.view addSubview:rotateImageView] ;
    
    [self showHeader:@"Upload Your Photo" backgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
}

- (void)onReturnButtonTap
{
    //NSLog(@"return button tapped") ;
}

- (void)showProgress
{
    iconSending = YES ;
    [nextIndicator startAnimating] ;
    [nextIndicator setAlpha:1.0] ;
    
}

- (void)hideProgress
{
    iconSending = NO ;
    [nextIndicator setAlpha:0.0] ;
    [nextIndicator stopAnimating] ;
}

- (void)didHeaderNextTap
{
    //NSLog(@"next button tapped") ;
    if(!iconSending){
        [self showProgress] ;
        rotatedImage = [self rotateImage:targetImage] ;
        [[ConsoleUtil getConsoleContents] setAppIconImage:rotatedImage] ;
    }
}

- (void)onRotateButtonTap
{
    //NSLog(@"rotate button tapped") ;
    currentDegree -= 90 ;
    if(currentDegree < 0){
        currentDegree += 360 ;
    }
    CGFloat angle = currentDegree * M_PI / 180.0;
    [imageView setTransform:CGAffineTransformMakeRotation(angle)] ;
}

- (UIImage*)rotateImage:(UIImage *)image
{
	CGSize imgSize = [image size] ;
	UIGraphicsBeginImageContext(imgSize) ;
	CGContextRef context = UIGraphicsGetCurrentContext() ;
    if(currentDegree == 90){
        CGContextRotateCTM(context, M_PI/2) ;
        CGContextTranslateCTM(context, 0, -imgSize.height) ;
    } else if(currentDegree == 180){
        CGContextRotateCTM(context, M_PI) ;
        CGContextTranslateCTM(context, -imgSize.width, -imgSize.height) ;
    } else if(currentDegree == 270){
        CGContextRotateCTM(context, M_PI*3/2) ;
        CGContextTranslateCTM(context, -imgSize.width, 0) ;
    } else {
        CGContextRotateCTM(context, 0) ;
    }
    
	[image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)] ;
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext() ;
	UIGraphicsEndImageContext() ;
	return newImage ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestDidPost:(NSNotification *)notification
{
    //NSLog(@"ConsoleIconEditViewController::requestDidPost") ;

    NSString *apiName = [[notification userInfo] objectForKey:@"API_NAME"] ;
    
    //NSLog(@"API_NAME:%@",apiName) ;
    
    if([apiName isEqualToString:@"app/seticonimage"]){
        NSString *status = [[notification userInfo] objectForKey:@"STATUS"] ;
        //NSLog(@"STATUS:%@",status) ;
        if([status isEqualToString:@"1"]){
            //[[[ConsoleUtil getConsoleContents] appInfo] setStatus:VEAM_APP_INFO_STATUS_SETTING] ;
            [ConsoleUtil updateConsoleContents] ;
            
            ConsoleHomeViewController *homeViewController = [[ConsoleHomeViewController alloc] init] ;
            [homeViewController setMode:VEAM_CONSOLE_HOME_MODE_INSTALLING] ;
            [homeViewController setTargetIconImage:rotatedImage] ;
            [self.navigationController pushViewController:homeViewController animated:NO] ;
        } else {
            [self hideProgress] ;
            [VeamUtil dispError:@"Failed to send icon"] ;
        }
    }
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
