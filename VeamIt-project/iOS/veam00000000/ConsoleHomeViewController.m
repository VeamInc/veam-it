//
//  ConsoleHomeViewController.m
//  veam00000000
//
//  Created by veam on 8/29/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleHomeViewController.h"
#import "VeamUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "ConsoleStarterTutorialViewController.h"
#import "ConsoleUtil.h"
#import "PieChartsView.h"
#import "Contents.h"
#import "AppDelegate.h"


@interface ConsoleHomeViewController ()

@end

@implementation ConsoleHomeViewController

@synthesize targetIconImage ;
@synthesize mode ;
@synthesize withoutCountDown ;


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
    
    NSInteger numberOfImages = 1 ;
    srand(time(nil)) ;
    NSInteger imageIndex = rand() % numberOfImages ;
    UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"c_home_background%d.png",imageIndex]] ;
    /*
    CGFloat imageWidth = backgroundImage.size.width / 2 ;
    CGFloat imageHeight = backgroundImage.size.height / 2 ;
     */
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [backgroundImageView setImage:backgroundImage] ;
    [self.view addSubview: backgroundImageView] ;
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,25,60,60)] ;
    [iconImageView setImage:[UIImage imageNamed:@"c_veam_icon.png"]] ;
    iconImageView.layer.cornerRadius = 15.0;
    iconImageView.layer.masksToBounds = YES;
    [VeamUtil registerTapAction:iconImageView target:self selector:@selector(didIconTap)] ;
    [self.view addSubview:iconImageView] ;
    
    CGRect iconFrame = iconImageView.frame ;
    iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconFrame.origin.x-8, iconFrame.origin.y+iconFrame.size.height, iconFrame.size.width+16, 22)] ;
    [iconLabel setBackgroundColor:[UIColor clearColor]] ;
    [iconLabel setTextColor:[UIColor whiteColor]] ;
    [iconLabel setTextAlignment:NSTextAlignmentCenter] ;
    [iconLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
    [self.view addSubview:iconLabel] ;
    
    UIImage *dockImage = [UIImage imageNamed:@"home_dock.png"] ;
    CGFloat imageWidth = dockImage.size.width / 2 ;
    CGFloat imageHeight = dockImage.size.height / 2 ;
    UIImageView *dockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,[VeamUtil getScreenHeight] - imageHeight,imageWidth,imageHeight)] ;
    [dockImageView setImage:dockImage] ;
    [self.view addSubview:dockImageView] ;
    
    if(self.mode == VEAM_CONSOLE_HOME_MODE_NOT_INSTALLED){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
        [iconImageView setImage:[UIImage imageNamed:@"c_veam_icon.png"]] ;
        [iconLabel setText:@"Start"] ;
    } else if(self.mode == VEAM_CONSOLE_HOME_MODE_INSTALLED){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
        [iconImageView setImage:[VeamUtil imageNamed:@"c_veam_icon.png"]] ;
        [iconLabel setText:[ConsoleUtil getConsoleContents].appInfo.name] ;
    } else if(self.mode == VEAM_CONSOLE_HOME_MODE_INSTALLING){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
        [iconImageView setImage:targetIconImage] ;
        [iconLabel setText:@"Loading..."] ;
        
        CGRect iconMaskFrame = iconImageView.frame ;
        iconMaskFrame.origin.x -= 0.5 ;
        iconMaskFrame.origin.y -= 0.5 ;
        iconMaskFrame.size.width += 1 ;
        iconMaskFrame.size.height += 1 ;
        iconMaskView = [[UIView alloc] initWithFrame:iconMaskFrame] ;
        [iconMaskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"A0000000"]] ;
        iconMaskView.layer.cornerRadius = 14.0;
        iconMaskView.layer.masksToBounds = YES;
        
        CAShapeLayer *aCircle = [CAShapeLayer layer] ;
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 61, 61)] ;
        [rectPath appendPath:[[UIBezierPath bezierPathWithArcCenter:CGPointMake(30, 30) radius:18 startAngle:0 endAngle:2*M_PI clockwise:YES] bezierPathByReversingPath]] ;
        aCircle.path = rectPath.CGPath ;
        aCircle.fillColor = [UIColor blackColor].CGColor ;
        iconMaskView.layer.mask = aCircle ;
        [self.view addSubview:iconMaskView] ;

        pieView = [[PieChartsView alloc] initWithFrame:CGRectMake(iconMaskFrame.origin.x+15, iconMaskFrame.origin.y+15, 30, 30)] ;
        [pieView setPercentage:0] ;
        [self.view addSubview:pieView] ;

        withoutCountDown = YES ; // prevent crashing
        if(!withoutCountDown){
            currentCount = 3 ;
            notCountDownYet = YES ;
            
            countDownView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
            [countDownView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
            [self.view addSubview:countDownView] ;

            countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
            [countDownLabel setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
            [countDownLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF6C6C6C"]] ;
            [countDownLabel setTextAlignment:NSTextAlignmentCenter] ;
            [self.view addSubview:countDownLabel] ;
        }
        
        currentProgress = 0 ;
        [self performSelectorInBackground:@selector(updateContents) withObject:nil] ;
    }
}

- (void)removeLaunchImage
{
    if(launchImageView != nil){
        [launchImageView removeFromSuperview] ;
        launchImageView = nil ;
    }
}

- (void)performCountdownOnMailThread
{
    [self performSelectorOnMainThread:@selector(startCountDown) withObject:nil waitUntilDone:NO] ;
}

- (void)startCountDown
{
    //countDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(doCountDown) userInfo:nil repeats:YES] ;
    
    countDownText           = [NSArray arrayWithObjects:@""    ,@"3"   ,@"3"   ,@""    ,@"2"   ,@"2"   ,@""    ,@"1"   ,@"1"   ,nil] ;
    countDownStartAlpha     = [NSArray arrayWithObjects:@"0.00",@"1.00",@"0.99",@"0.00",@"1.00",@"0.99",@"0.00",@"1.00",@"0.99",nil] ;
    countDownEndAlpha       = [NSArray arrayWithObjects:@"0.01",@"0.99",@"0.00",@"0.01",@"0.99",@"0.00",@"0.01",@"0.99",@"0.00",nil] ;
    countDownSize           = [NSArray arrayWithObjects:@"150" ,@"150" ,@"150" ,@"100" ,@"100" ,@"100" ,@"50"  ,@"50"  ,@"50"  ,nil] ;
    countDownDuration       = [NSArray arrayWithObjects:@"0.30",@"0.20",@"0.30",@"0.20",@"0.20",@"0.40",@"0.10",@"0.10",@"0.50",nil] ;
    countDownIndex = 0 ;
    [self doCountDown] ;
}

- (void)doCountDown
{
    NSInteger numberOfAnimations = [countDownText count] ;
    if(countDownIndex < numberOfAnimations){
        
        [countDownLabel setText:[countDownText objectAtIndex:countDownIndex]] ;
        [countDownLabel setAlpha:[[countDownStartAlpha objectAtIndex:countDownIndex] floatValue]] ;
        [countDownLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:[[countDownSize objectAtIndex:countDownIndex] floatValue]]] ;

        [UIView beginAnimations:nil context:NULL] ;
        [UIView setAnimationDuration:[[countDownDuration objectAtIndex:countDownIndex] floatValue]] ;
        [UIView setAnimationDelegate:self] ;
        [UIView setAnimationDidStopSelector:@selector(doCountDown)] ;
        [countDownLabel setAlpha:[[countDownEndAlpha objectAtIndex:countDownIndex] floatValue]] ;
        [UIView commitAnimations] ;

        countDownIndex++ ;
    } else {
        [countDownLabel setAlpha:0.0] ;
        [UIView beginAnimations:nil context:NULL] ;
        [UIView setAnimationDuration:2.5] ;
        [UIView setAnimationDelegate:self] ;
        [UIView setAnimationDidStopSelector:@selector(showStatusBar)] ;
        [countDownView setAlpha:0.0] ;
        [UIView commitAnimations] ;
    }
}


/*
- (void)doCountDown
{
    //NSLog(@"doCountDown") ;
    NSInteger blancSpan = 6 ;
    NSInteger countSpan = 2 ;
    NSInteger routineSpan = blancSpan + countSpan ;
    NSInteger index = countDownIndex % routineSpan ;
    
    ////NSLog(@"doCountDown %d",countdownin) ;
    
    if(index == 0){
        [countDownLabel setText:@""] ;
    } else if(index == blancSpan){
        if(currentCount == 0){
            // end count down
            [countDownTimer invalidate] ;
            countDownTimer = nil ;
            
            [UIView beginAnimations:nil context:NULL] ;
            [UIView setAnimationDuration:2.0] ;
            [UIView setAnimationDelegate:self] ;
            [UIView setAnimationDidStopSelector:@selector(showStatusBar)] ;
            [countDownLabel setAlpha:0.0] ;
            [UIView commitAnimations] ;
        } else {
            [countDownLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:50*currentCount]] ;
            [countDownLabel setText:[NSString stringWithFormat:@"%d",currentCount]] ;
            currentCount-- ;
        }
    }
    
    countDownIndex++ ;
}
 */


- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"ConsoleHomeViewController::viewDidAppear") ;
    [super viewDidAppear:animated] ;

    if(notCountDownYet){
        //NSLog(@"notCountDownYet") ;
        notCountDownYet = NO ;
        //[self performSelectorOnMainThread:@selector(startCountDown) withObject:nil waitUntilDone:NO] ;
        //[self performSelector:@selector(performCountdownOnMailThread) withObject:nil afterDelay:0.2f] ;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [VeamUtil hideFloatingMenu] ;
    [self removeLaunchImage] ;
}

- (void)showStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;
}



- (void)didIconTap
{
    //NSLog(@"didIconTap") ;
    if(self.mode == VEAM_CONSOLE_HOME_MODE_NOT_INSTALLED){
        ConsoleStarterTutorialViewController *viewController = [[ConsoleStarterTutorialViewController alloc] init] ;
        [UIView transitionWithView:self.navigationController.view duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.navigationController pushViewController:viewController animated:NO] ;
                        } completion:nil];
    } else if(self.mode == VEAM_CONSOLE_HOME_MODE_INSTALLED){
        if([ConsoleUtil isConsoleLoggedin]){
            //[self showMask:YES] ;
            CGFloat statusBarHeight = 0 ;
            if([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
                statusBarHeight = [VeamUtil getStatusBarHeight] ;
            }
            [self removeLaunchImage] ;
            [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
            UIImage *launchImage ;
            if([VeamUtil getScreenHeight] <= 480){
                launchImage = [VeamUtil imageNamed:@"splash_short.png"] ;
            } else {
                launchImage = [VeamUtil imageNamed:@"splash.png"] ;
            }
            if(launchImage == nil){
                launchImage = [VeamUtil imageNamed:@"initial_background.png"] ;
            }
            CGFloat imageWidth = launchImage.size.width / 2 ;
            CGFloat imageHeight = launchImage.size.height / 2 ;
            launchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-[VeamUtil getScreenWidth]/2, -[VeamUtil getScreenHeight]/2, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
            [launchImageView setCenter:iconImageView.center] ;
            [launchImageView setImage:launchImage] ;
            [launchImageView setTransform:CGAffineTransformMakeScale(0.1, 0.1)] ;
            [launchImageView setAlpha:0.0] ;
            [self.view addSubview:launchImageView] ;
            
            CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]) ;
            
            [UIView beginAnimations:nil context:NULL] ;
            [UIView setAnimationDuration:0.4] ;
            [launchImageView setTransform:CGAffineTransformMakeScale(1.0, 1.0)] ;
            [launchImageView setFrame:CGRectMake(0, ([VeamUtil getScreenHeight] - imageHeight)/2 - statusBarHeight, imageWidth, imageHeight)] ;
            [launchImageView setAlpha:1.0] ;
            [UIView commitAnimations] ;

            
            [self performSelectorInBackground:@selector(preparePreview) withObject:nil] ;
        } else {
            [VeamUtil dispMessage:@"Please Login" title:@""] ;
        }
    }
}

- (void)preparePreview
{
    [ConsoleUtil preparePreview] ;
    [self performSelectorOnMainThread:@selector(showPreview) withObject:nil waitUntilDone:NO] ;
}

- (void)showPreview
{
    //[self showMask:NO] ;
    [ConsoleUtil showPreview] ;
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

- (void)updateProgress
{
    [pieView setPercentage:currentProgress] ;
}

- (void)didUpdateContents
{
    //NSLog(@"%@::didUpdateContents",NSStringFromClass([self class])) ;
    
    [pieView setAlpha:0.0] ;
    [iconLabel setText:[ConsoleUtil getConsoleContents].appInfo.name] ;
    [self performSelectorOnMainThread:@selector(setIconImage) withObject:nil waitUntilDone:NO] ;

    [self setMode:VEAM_CONSOLE_HOME_MODE_INSTALLED] ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:1.0] ;
    [UIView setAnimationDelegate:self] ;
    [iconMaskView setAlpha:0.0] ;
    [UIView commitAnimations] ;
    
}

- (void)setIconImage
{
    [iconImageView setImage:[VeamUtil imageNamed:@"c_veam_icon.png"]] ;
}

- (void)setIconImageWithTargetImage
{
    [iconImageView setImage:targetIconImage] ;
}

-(void)updateContents
{
    @autoreleasepool
    {

        //NSLog(@"%@::updateContents",NSStringFromClass([self class])) ;

        // 0:waiting 1:done 2:error 3:executing
        NSString *apiName = @"app/getcommandstatus" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"UPDATE_CONCEPT_COLOR",@"n",
                                nil] ;
        NSString *commandStatus = @"0" ;
        NSInteger retryMax = 20 ;
        NSInteger retryCount = 0 ;
        while(![commandStatus isEqualToString:@"1"] && (retryCount < retryMax)){
            if(retryCount != 0){
                [NSThread sleepForTimeInterval:5.0f];
            }
            ConsolePostData *postData = [[ConsolePostData alloc] init] ;
            [postData setApiName:apiName] ;
            [postData setParams:params] ;
            [postData setImage:nil] ;
            [postData setHandlePostResultDelegate:nil] ;
            NSArray *results = [ConsoleUtil doPost:postData] ;
            if([results count] >= 2){
                NSString *result = [results objectAtIndex:0] ;
                if([result isEqualToString:@"OK"]){
                    commandStatus = [results objectAtIndex:1] ;
                    //NSLog(@"command status=%@",commandStatus) ;
                }
            }
            
            retryCount++ ;
            currentProgress = retryCount ;
            [self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO] ;
        }
        
        
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"UPDATE_SCREEN_SHOT",@"n",
                                nil] ;
        commandStatus = @"0" ;
        NSInteger startCount = retryCount ;
        while(![commandStatus isEqualToString:@"1"] && (retryCount < retryMax)){
            if(retryCount != startCount){
                [NSThread sleepForTimeInterval:5.0f];
            }
            ConsolePostData *postData = [[ConsolePostData alloc] init] ;
            [postData setApiName:apiName] ;
            [postData setParams:params] ;
            [postData setImage:nil] ;
            [postData setHandlePostResultDelegate:nil] ;
            NSArray *results = [ConsoleUtil doPost:postData] ;
            if([results count] >= 2){
                NSString *result = [results objectAtIndex:0] ;
                if([result isEqualToString:@"OK"]){
                    commandStatus = [results objectAtIndex:1] ;
                    //NSLog(@"command status=%@",commandStatus) ;
                }
            }
            
            retryCount++ ;
            currentProgress = retryCount ;
            [self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO] ;
        }
        
        [ConsoleUtil updateConsoleContents] ;

        //NSLog(@"update contents start") ;
        
        [VeamUtil setUserDefaultString:VEAM_USER_DEFAULT_KEY_CURRENT_CONTENT_ID value:@"0"] ;
        
        Contents *workContents = [[Contents alloc] initWithServerData] ;
        if([workContents isValid]){
            //NSLog(@"set contents from server") ;
            [[AppDelegate sharedInstance] setContents:workContents] ;
            NSArray *alternativeImages = [workContents getAlternativeImages] ;
            int count = (int)[alternativeImages count] ;
            for(int index = 0 ; index < count ; index++){
                AlternativeImage *alternativeImage = [alternativeImages objectAtIndex:index] ;
                NSString *urlString = [alternativeImage url] ;
                if(![VeamUtil isEmpty:urlString]){
                    UIImage *workImage = [VeamUtil getUpdatedImage:urlString] ;
                    if(workImage == nil){
                        NSURL *url = [NSURL URLWithString:[VeamUtil getSecureUrl:urlString]] ;
                        NSData *data = [NSData dataWithContentsOfURL:url] ;
                        workImage = [[UIImage alloc] initWithData:data] ;
                        //NSLog(@"image size %fx%f",retImage.size.width,retImage.size.height) ;
                        if((workImage != nil) && (workImage.size.width > 0)){
                            [VeamUtil storeUpdatedImage:urlString data:data] ;
                        }
                    }
                }
                currentProgress = retryMax + (100.0 - retryMax) * (CGFloat)index / (CGFloat)count ;
                [self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO] ;
            }
        }
        
        //NSLog(@"update contents end") ;
        [self performSelectorOnMainThread:@selector(didUpdateContents) withObject:nil waitUntilDone:NO] ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@::viewWillAppear",NSStringFromClass([self class])) ;
    [super viewWillAppear:animated];
    
    UIImage *newIcon = [ConsoleUtil getNewIcon] ;
    if(newIcon){
        targetIconImage = newIcon ;
        [ConsoleUtil setNewIcon:nil] ;
        [self performSelectorOnMainThread:@selector(setIconImageWithTargetImage) withObject:nil waitUntilDone:NO] ;
    }
}

@end
