//
//  InitialViewController.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "InitialViewController.h"
#import "VeamUtil.h"
#import "GAI.h"
#import "GAIFields.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"InitialViewController::supportedInterfaceOrientations") ;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    //NSLog(@"InitialViewController::shouldAutorotate") ;
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"VEAM_ADMOB_UNIT_ID_EXCLUSIVE=%@",VEAM_ADMOB_UNIT_ID_EXCLUSIVE) ;
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert) categories:nil] ;
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting] ;
        [[UIApplication sharedApplication] registerForRemoteNotifications] ;
    } else {
        // use registerForRemoteNotifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)] ;
    }

    NSString *skipInitial = [VeamUtil getSkipInitial] ;
    if(![VeamUtil isEmpty:skipInitial] && [skipInitial isEqual:@"1"]){
        [VeamUtil showTabBarController:0] ;
    } else {
        self.screenName = [VeamUtil makeScreenName:@"Initial/"] ;
        
        selectedTab = 0 ;
        
        UIImage *image = [VeamUtil imageNamed:@"initial_background.png"] ;
        CGFloat imageWidth = image.size.width / 2 ;
        CGFloat imageHeight = image.size.height / 2 ;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([VeamUtil getScreenHeight] - imageHeight)/2 - [VeamUtil getStatusBarHeight], imageWidth, imageHeight)] ;
        [imageView setImage:image] ;
        [self.view addSubview:imageView] ;
        
        image = [VeamUtil imageNamed:@"splash.png"] ;
        if(image != nil){
            imageWidth = image.size.width / 2 ;
            imageHeight = image.size.height / 2 ;
            splashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([VeamUtil getScreenHeight] - imageHeight)/2 - [VeamUtil getStatusBarHeight], imageWidth, imageHeight)] ;
            [splashImageView setImage:image] ;
            [splashImageView setAlpha:1.0] ;
            [self.view addSubview:splashImageView] ;
        }
        
        image = [VeamUtil imageNamed:@"background.png"] ;
        imageWidth = image.size.width / 2 ;
        imageHeight = image.size.height / 2 ;
        blurredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([VeamUtil getScreenHeight] - imageHeight)/2 - [VeamUtil getStatusBarHeight], imageWidth, imageHeight)] ;
        [blurredImageView setImage:image] ;
        [blurredImageView setAlpha:0.0] ;
        [self.view addSubview:blurredImageView] ;
        
        CGRect frame = self.view.frame ;
        //NSLog(@"y=%f",frame.size.height/*-VEAM_INITIAL_BOTTOM_BAR_HEIGHT*/) ;
        bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, [VeamUtil getScreenHeight]-VEAM_INITIAL_BOTTOM_BAR_HEIGHT - [VeamUtil getStatusBarHeight], frame.size.width, VEAM_INITIAL_BOTTOM_BAR_HEIGHT)] ;
        [bottomBarView setBackgroundColor:[VeamUtil getColorFromArgbString:@"50000000"]] ;
        [self.view addSubview:bottomBarView] ;
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, VEAM_INITIAL_BOTTOM_BAR_HEIGHT)] ;
        [backImageView setImage:[VeamUtil imageNamed:@"tab_back.png"]] ;
        [bottomBarView addSubview:backImageView] ;
        
        NSArray *templateIds = [VeamUtil getTemplateIds] ;
        NSInteger numberOfTabs = [VeamUtil getNumberOfTabs] ;
        //CGFloat margin = ((CGFloat)[VeamUtil getScreenWidth]) * 0.2 ;
        CGFloat margin = 0 ;
        CGFloat span = (((CGFloat)[VeamUtil getScreenWidth]) - margin) / numberOfTabs ;
        CGFloat currentX = margin / 2 ;
        for(int index = 0 ; index < numberOfTabs ; index++){
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(currentX, 0, span, VEAM_INITIAL_BOTTOM_BAR_HEIGHT)] ;
            [button setBackgroundColor:[UIColor clearColor]] ;
            [button setTag:index] ;
            [VeamUtil registerTapAction:button target:self selector:@selector(onButtonTap:)] ;
            [bottomBarView addSubview:button] ;

            

            
            NSString *templateId = [templateIds objectAtIndex:index] ;
            image = [VeamUtil imageNamed:[NSString stringWithFormat:@"t%@_tab_off.png",templateId]] ;
            imageWidth = image.size.width ;
            imageHeight = image.size.height ;
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentX + (span-imageWidth)/2, 5, imageWidth, imageHeight)] ;
            [imageView setImage:image] ;
            [imageView setTag:index] ;
            [bottomBarView addSubview:imageView] ;
            
            
            UILabel *tabLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 35, span, 10)] ;
            [tabLabel setTextColor:[VeamUtil getTabTextColor]] ;
            [tabLabel setBackgroundColor:[UIColor clearColor]] ;
            [tabLabel setFont:[UIFont systemFontOfSize:9.0]] ;
            [tabLabel setText:[VeamUtil getTabTitleFor:templateId]] ;
            [tabLabel setTextAlignment:NSTextAlignmentCenter] ;
            [bottomBarView addSubview:tabLabel] ;
            
            

            currentX += span ;
        }
        [bottomBarView setAlpha:0.0] ;
        
        poweredView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
        [poweredView setBackgroundColor:[VeamUtil getColorFromArgbString:@"55000000"]] ;
        [self.view addSubview:poweredView] ;
        
        [dummyView = [UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)] ;
        [dummyView setBackgroundColor:[UIColor clearColor]] ;
        [dummyView setCenter:poweredView.center] ;
        [poweredView addSubview:dummyView] ;
        
        /*
        UIImage *poweredImage = [VeamUtil imageNamed:@"mcn_logo.png"] ;
        UIImageView *poweredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, poweredImage.size.width/2, poweredImage.size.height/2)] ;
        [poweredImageView setImage:poweredImage] ;
        [poweredImageView setCenter:poweredView.center] ;
        [poweredView addSubview:poweredImageView] ;
         */
        
        [poweredView setAlpha:0.0] ;
    }
}

- (void)onButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    //NSLog(@"button tapped : %d",[[singleTapGesture view] tag]) ;
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;

    selectedTab = [[singleTapGesture view] tag] ;

    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(showTabBarController)] ;
    //[bottomBarView setAlpha:0.0] ;
    [blurredImageView setAlpha:1.0] ;
    [UIView commitAnimations] ;
}

- (void)doShowTabBarController
{
    [VeamUtil showTabBarController:selectedTab] ;
}

- (void)showTabBarController
{
    [self performSelector:@selector(doShowTabBarController) withObject:nil afterDelay:NO] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"viewDidAppear");
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker] ;  // Get the tracker object.
    [tracker set:[GAIFields customDimensionForIndex:1] value:[VeamUtil getTrackingId]] ;

    [super viewDidAppear:animated];

    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(intervalAnimation)] ;
    [poweredView setAlpha:1.0] ;
    if(splashImageView != nil){
        [splashImageView setAlpha:0.0] ;
    }
    [UIView commitAnimations] ;
}

- (void)intervalAnimation
{
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(showBottomBar)] ;
    [dummyView setAlpha:0.0] ;
    [UIView commitAnimations] ;
}

- (void)showBottomBar
{
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:2.0] ;
    [poweredView setAlpha:0.0] ;
    [bottomBarView setAlpha:1.0] ;
    [UIView commitAnimations] ;
}



@end
