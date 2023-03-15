//
//  ConsoleAppDelegate.m
//  veam00000000
//
//  Created by veam on 5/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVAudioSession.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"
#import "Three20/Three20.h"
#import "StyleSheet.h"
#import "InitialViewController.h"
#import "YoutubeCategoryViewController.h"
#import "RecipeCategoryViewController.h"
#import "WebListViewController.h"
#import "ForumViewController.h"
#import "VeamUtil.h"
#import "VeamNavigationController.h"
#import "CameraViewController.h"
#import "SettingsViewController.h"
#import "ConsoleTopViewController.h"
#import "DRMMovieViewController.h"
#import "AudioPlayViewController.h"
#import "ConsoleSideMenuViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "ConsoleForumViewController.h"
#import "ConsoleWebViewController.h"
#import "ConsoleYoutubeCategoryViewController.h"
#import "ConsoleVideoViewController.h"
#import "ConsoleMixedForGridViewController.h"
#import "VideoViewController.h"
#import "ConsoleMixedViewController.h"
#import "MixedGridViewController.h"
#import "ConsoleEditSubscriptionDescriptionViewController.h"
#import "ConsoleSelectLoginViewController.h"
#import "ConsoleHomeViewController.h"
#import "RootViewController.h"
#import "ConsoleSellItemCategoryViewController.h"
#import "ConsoleSellSectionCategoryViewController.h"
#import "SellVideoViewController.h"
#import "SellPdfViewController.h"
#import "SellAudioViewController.h"
#import "SellSectionItemViewController.h"
#import "ConsoleSellVideoViewController.h"
#import "ConsoleSellPdfViewController.h"
#import "ConsoleSellAudioViewController.h"
#import "ConsoleSellSectionItemViewController.h"
#import "ConsoleShootVideoViewController.h"
#import "ProfileViewController.h"
#import "PictureViewController.h"
#import "EmailTopViewController.h"

#import <QuartzCore/QuartzCore.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

static AppDelegate *_sharedInstance = nil ;

@implementation AppDelegate

@synthesize configurations ;
@synthesize contents ;
@synthesize consoleContents ;
@synthesize shouldUpdate ;
@synthesize picturePosted ;
@synthesize questionPosted ;
@synthesize descriptionPosted ;
@synthesize loginPendingOperationDelegate ;
@synthesize currentAppId ;
@synthesize movieKey ;
@synthesize rewardString ;
@synthesize shouldShowCalendar ;
@synthesize calendarYear ;
@synthesize calendarMonth ;
@synthesize appIconImage ;
@synthesize sellVideoPurchased ;
@synthesize sellPdfPurchased ;
@synthesize sellAudioPurchased ;
@synthesize isContentsChanged ;
@synthesize sellSectionPurchased ;
@synthesize shotMovieUrl ;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] ;
    if(userInfo){
        /*
         //NSLog(@"didFinishLaunchingWithOptions has remote notification") ;
         for (id key in userInfo) {
            //NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]) ;
         }
         */
        [self setUserNotification:userInfo] ;
    }
    
    
    
    // Set these variables before launching the app
    NSString *appKey = @"vju__DROPBOX_KEY__ba1okx6m8hfg" ;
	NSString *appSecret = @"__DROPBOX_SECRET__" ;
	NSString *root = kDBRootDropbox ; // Should be set to either kDBRootAppFolder or kDBRootDropbox
	
	DBSession *session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root] ;
	session.delegate = self ; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session] ;
	
	[DBRequest setNetworkRequestDelegate:self] ;
    
    
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil] ; // to play sound on silent mode
    shouldUpdate = YES ;
    
    /*
#if INCLUDE_KIIP == 1
    //NSLog(@"kiip included") ;
    Kiip *kiip = [[Kiip alloc] initWithAppKey:@"__KIIP_APP_KEY__" andSecret:@"__KIIP_SECRET__"];
    kiip.delegate = self;
    [Kiip setSharedInstance:kiip];
#endif
     */

    // google analytics
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set debug to YES for extra debugging information.
    //[GAI sharedInstance].debug = YES;
    
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"__GA_PROPERTY_ID__"] ;
    
    [Fabric with:@[CrashlyticsKit]];

    NSString *initialTutorialDoneString = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_TUTORIAL_DONE] ;
    initialTutorialDone = [initialTutorialDoneString isEqualToString:@"1"] ;

    loginPendingOperationDelegate = nil ;
    
    [TTStyleSheet setGlobalStyleSheet:[[StyleSheet alloc] init]];

    self.configurations = [[Configurations alloc] initWithResourceFile] ;
    self.consoleContents = [[ConsoleContents alloc] initWithResourceFile] ;
    
    //NSLog(@"contents check=%@",[self.contents getValueForKey:@"check"]) ;
    //NSLog(@"app_id=%@",[self.configurations getValueForKey:@"app_id"]) ;
    appId = [configurations getValueForKey:@"app_id"] ;

    //[self loadTabBarController] ;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.floatingMenuWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.footerImageWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.initialTutorialWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;

    if([ConsoleUtil isConsoleLoggedin]){
        ConsoleHomeViewController *viewController ;
        NSString *appStatus = self.consoleContents.appInfo.status ;
        if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_INITIALIZED]){
            viewController = [[ConsoleHomeViewController alloc] init] ;
            [viewController setMode:VEAM_CONSOLE_HOME_MODE_NOT_INSTALLED] ;
        } else {
            AlternativeImage *alternativeImage = [consoleContents getAlternativeImageForFileName:@"c_veam_icon.png"] ;
            UIImage *iconImage = [VeamUtil getCachedImage:alternativeImage.url downloadIfNot:YES] ;
            //NSLog(@"icon=%@",alternativeImage.url) ;
            viewController = [[ConsoleHomeViewController alloc] init] ;
            [viewController setMode:VEAM_CONSOLE_HOME_MODE_INSTALLING] ;
            [viewController setWithoutCountDown:YES] ;
            [viewController setTargetIconImage:iconImage] ;
        }
        
        dashboardNavigationController = [[VeamNavigationController alloc] initWithRootViewController:viewController] ;
    } else {
        ConsoleSelectLoginViewController *viewController = [[ConsoleSelectLoginViewController alloc] init] ;
        dashboardNavigationController = [[VeamNavigationController alloc] initWithRootViewController:viewController] ;
    }
    [dashboardNavigationController setNavigationBarHidden:YES] ;

    
    //[self analyzeView:self.consoleTabBarController.tabBar indent:0] ;
    
    //self.window.rootViewController = self.consoleTabBarController ;
    self.window.rootViewController = dashboardNavigationController ;
    [self.window setBackgroundColor:[UIColor whiteColor]] ;
    
    [self.window makeKeyAndVisible];
    [self.floatingMenuWindow makeKeyAndVisible] ;
    [self.footerImageWindow makeKeyAndVisible] ;
    [self.initialTutorialWindow makeKeyAndVisible] ;

    [self.floatingMenuWindow setHidden:YES] ;
    [self.footerImageWindow setHidden:YES] ;
    [self.initialTutorialWindow setHidden:YES] ;

    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_CONSOLE") ;
    screenStatus = VEAM_SCREEN_STATUS_CONSOLE ;

    return YES;
}

- (void)restartConsoleHome
{
    if([ConsoleUtil isConsoleLoggedin]){
        ConsoleHomeViewController *viewController ;
        NSString *appStatus = self.consoleContents.appInfo.status ;
        if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_INITIALIZED]){
            viewController = [[ConsoleHomeViewController alloc] init] ;
            [viewController setMode:VEAM_CONSOLE_HOME_MODE_NOT_INSTALLED] ;
        } else {
            AlternativeImage *alternativeImage = [consoleContents getAlternativeImageForFileName:@"c_veam_icon.png"] ;
            UIImage *iconImage = [VeamUtil getCachedImage:alternativeImage.url downloadIfNot:YES] ;
            //NSLog(@"icon=%@",alternativeImage.url) ;
            viewController = [[ConsoleHomeViewController alloc] init] ;
            [viewController setMode:VEAM_CONSOLE_HOME_MODE_INSTALLING] ;
            [viewController setWithoutCountDown:YES] ;
            [viewController setTargetIconImage:iconImage] ;
        }
        
        dashboardNavigationController = [[VeamNavigationController alloc] initWithRootViewController:viewController] ;
    } else {
        ConsoleSelectLoginViewController *viewController = [[ConsoleSelectLoginViewController alloc] init] ;
        dashboardNavigationController = [[VeamNavigationController alloc] initWithRootViewController:viewController] ;
    }
    [dashboardNavigationController setNavigationBarHidden:YES] ;
    
    self.window.rootViewController = dashboardNavigationController ;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if(shouldUpdate){
        [self performSelectorInBackground:@selector(updateConsoleContents) withObject:nil] ;
    } else {
        shouldUpdate = YES ;
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0 ;

    if(userNotification != nil){
        [self showTabBarController:forumTabIndex] ;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)sharedInstance
{
    return _sharedInstance;
}

- (id) init
{
    self = [super init];
    if (!self)
        return nil;
    
    _sharedInstance = self;
    return self;
}

-(void)updateConsoleContents
{
    @autoreleasepool
    {
        NSLog(@"update console contents start") ;
        
        BOOL forceSignOut = NO ;
        NSString *userName = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
        if(![VeamUtil isEmpty:userName]){
            NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;
            //NSLog(@"username=%@",userName) ;
            
            NSString *consoleDeviceToken = [VeamUtil getUserDefaultString:@"CONSOLE_DEVICE_TOKEN"] ;
            if([VeamUtil isEmpty:consoleDeviceToken]){
                consoleDeviceToken = @"" ;
            }
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    userName,@"u",
                                    password,@"p",
                                    consoleDeviceToken,@"t",
                                    nil] ;
            
            ConsolePostData *postData = [[ConsolePostData alloc] init] ;
            [postData setApiName:@"account/login"] ;
            [postData setParams:params] ;
            
            

            NSArray *results = [ConsoleUtil doPost:postData] ;
            if(results != nil){
                int count = [results count] ;
                if(count > 0){
                    NSString *code = [results objectAtIndex:0] ;
                    if([code isEqual:@"OK"]){
                        if(count >= 5){
                            [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_APP_ID value:[results objectAtIndex:1]] ;
                            [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_APP_SECRET value:[results objectAtIndex:2]] ;
                            [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_USER_PRIVILAGES value:[results objectAtIndex:3]] ;
                            [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_MCN_ID value:[results objectAtIndex:4]] ;
                            //NSLog(@"user privilages=%@",[results objectAtIndex:3]) ;
                        } else {
                            forceSignOut = YES ;
                        }
                    } if([code isEqual:@"ERROR_MESSAGE"]){
                        forceSignOut = YES ;
                    }
                } else {
                    forceSignOut = YES ;
                }
            } else {
                forceSignOut = YES ;
            }
        }
        
        if(forceSignOut){
            //NSLog(@"forceSignOut") ;
            [self performSelectorOnMainThread:@selector(doSignOut) withObject:nil waitUntilDone:NO] ;
        }

        
        BOOL shouldPostNotification = NO ;
        
        ConsoleContents *workContents = [[ConsoleContents alloc] initWithServerData] ;
        if([workContents isValid]){
            //NSLog(@"set contents from server") ;
            consoleContents = workContents ;

            shouldPostNotification = YES ;
        }

        NSLog(@"update console contents end") ;
    }
}

- (void)doSignOut
{
    [self hideFloatingMenu] ;
    [ConsoleUtil logout] ;
    [ConsoleUtil clearPreviewData] ;
    ConsoleSelectLoginViewController *loginViewController = [[ConsoleSelectLoginViewController alloc] init] ;
    [self pushViewControllerFromSideMenu:loginViewController] ;
}


-(void)updateContents
{
    @autoreleasepool
    {
        //NSLog(@"update contents start") ;
        
        BOOL shouldPostNotification = NO ;
        
        [VeamUtil setUserDefaultString:VEAM_USER_DEFAULT_KEY_CURRENT_CONTENT_ID value:@"0"] ;

        Contents *workContents = [[Contents alloc] initWithServerData] ;
        if([workContents isValid]){
            //NSLog(@"set contents from server") ;
            contents = workContents ;
           
            [TTStyleSheet setGlobalStyleSheet:[[StyleSheet alloc] init]];
            shouldPostNotification = YES ;
        }
        
        NSArray *alternativeImages = [contents getAlternativeImages] ;
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
                        shouldPostNotification = YES ;
                    }
                }
            }
        }
        
        TemplateSubscription *templateSubscription = [contents getTemplateSubscription] ;
        if(templateSubscription != nil){
            if([templateSubscription.isFree isEqualToString:@"1"]){
                //NSLog(@"Free Subscription Set") ;
                [VeamUtil setSubscriptionStartTime:@"946652400" index:[VeamUtil getSubscriptionIndex]] ; // 2000/01/01 00:00:00
                [VeamUtil setSubscriptionEndTime:@"1893423600" index:[VeamUtil getSubscriptionIndex]] ; // 2030/01/01 00:00:00
            }
        }

        // TODO
        /*
        // update calendar
        NSString *storeReceipt = [VeamUtil getStoreReceipt] ;
        if((storeReceipt != nil) && ![storeReceipt isEqualToString:@""]){
            //NSLog(@"AppDelegage verifyReceipt") ;
            [VeamUtil verifyReceipt:storeReceipt clearIfExpired:YES forced:YES] ;
        }
        [self performSelectorOnMainThread:@selector(updateTextline) withObject:nil waitUntilDone:NO] ;
         */

        if(shouldPostNotification){
            [VeamUtil postContentsUpdateNotification] ;
        }
        //NSLog(@"update contents end") ;
        
        /*
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey] ;
        //NSLog(@"version : %@",version) ;
        NSString *latestVersion = [contents getValueForKey:@"latest_version"] ;
        if((latestVersion != nil) && ![latestVersion isEqualToString:@""]){
            //NSLog(@"latest version : %@",latestVersion) ;
            CGFloat versionFloat = [version floatValue] ;
            CGFloat latestVersionFloat = [latestVersion floatValue] ;
            if((versionFloat != 0) && (latestVersionFloat != 0)){
                if(versionFloat < latestVersionFloat){
                    //NSLog(@"%f < %f",versionFloat,latestVersionFloat) ;
                    if(![VeamUtil getVersionChecked:latestVersion]){
                        [VeamUtil setVersionChecked:latestVersion checked:YES] ;
                        [self performSelectorOnMainThread:@selector(showUpdateCheck) withObject:nil waitUntilDone:NO] ;
                    }
                }
            }
        }
        */
    }
    [self performSelectorOnMainThread:@selector(hideUpdateContentsIndicator) withObject:nil waitUntilDone:NO] ;
}

- (NSString *)makeScreenName:(NSString *)viewName
{
    NSString *screenName ;
    switch (screenStatus) {
        case VEAM_SCREEN_STATUS_TAB:
            screenName = [NSString stringWithFormat:@"/%@/tab%d/%@",appId,self.tabBarController.selectedIndex+1,viewName] ;
            break;
        default:
            screenName = [NSString stringWithFormat:@"/%@/tab0/%@",appId,viewName] ;
            break;
    }
    return screenName ;
}

- (void)showCameraView:(NSString *)forumId
{
    picturePosted = NO ;

    /*
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [VeamUtil dispError:@"Camera is not available."] ;
        return ;
    }
     */
    
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_CAMERA") ;
    screenStatus = VEAM_SCREEN_STATUS_CAMERA ;
    
    CameraViewController *cameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    [cameraViewController setForumId:forumId] ;
    VeamNavigationController *cameraNavigationController = [[VeamNavigationController alloc] initWithRootViewController:cameraViewController] ;
    
    
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:cameraNavigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}

- (void)backFromVideoCamera
{
    //NSLog(@"backFromVideoCamera") ;
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO] ;
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;
                        [self.window setRootViewController:videoCameraBackViewController] ;
                        [UIView setAnimationsEnabled:oldState] ;
                        //[self.window bringSubviewToFront:previewBackButton] ;
                    }
                    completion:nil];
    
    videoCameraBackViewController = nil ;

}


- (void)showVideoCameraView
{
    //NSLog(@"showVideoCameraView") ;
    //picturePosted = NO ;
    
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_CAMERA") ;
    //screenStatus = VEAM_SCREEN_STATUS_CAMERA ;
    
    self.shotMovieUrl = nil ;
    videoCameraBackViewController = self.window.rootViewController ;
    
    ConsoleShootVideoViewController *shootVideoViewController = [[ConsoleShootVideoViewController alloc] init] ;
    VeamNavigationController *cameraNavigationController = [[VeamNavigationController alloc] initWithRootViewController:shootVideoViewController] ;
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:cameraNavigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
    
    /*
    CameraViewController *cameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    [cameraViewController setForumId:forumId] ;
    VeamNavigationController *cameraNavigationController = [[VeamNavigationController alloc] initWithRootViewController:cameraViewController] ;
    
    
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:cameraNavigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
     */
}

- (void)showSettingsView
{
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_SETTINGS") ;
    screenStatus = VEAM_SCREEN_STATUS_SETTINGS ;
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [settingsViewController setTitleName:@"Settings"] ;
    
    VeamNavigationController *settingsNavigationController = [[VeamNavigationController alloc] initWithRootViewController:settingsViewController] ;
    
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:settingsNavigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];}

- (void)setTabBarControllerIndex:(NSInteger)index
{
    self.tabBarController.selectedIndex = index ;
}

- (BOOL)isShowingPreview
{
    return (self.window.rootViewController == self.tabBarController) ;
}

- (void)backtoPreviewWithAnimation
{
    CATransition *animation = [CATransition animation] ;
    [animation setDelegate:self] ;
    [animation setValue:@"ConsoleToPreview" forKey:@"AnimationKind"] ;
    [animation setType:kCATransitionPush] ;
    [animation setSubtype:kCATransitionFromLeft] ;
    [animation setDuration:0.3] ;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]] ;
    [self.window.layer addAnimation:animation forKey:nil] ;
    [self.window setRootViewController:self.tabBarController] ;

}

- (void)backToPreview
{
    //NSLog(@"ConsoleAppDelegate::backToPreview") ;
    if(self.window.rootViewController == dashboardNavigationController){
        [self performSelectorOnMainThread:@selector(showFooterImageWindow) withObject:nil waitUntilDone:YES] ;
        //[self showFooterImageWindow] ;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;

    //[dashboardNavigationController popViewControllerAnimated:NO] ;

    [self performSelectorOnMainThread:@selector(backtoPreviewWithAnimation) withObject:nil waitUntilDone:YES] ;

    //[dashboardNavigationController popToRootViewControllerAnimated:NO] ;

    if(isContentsChanged){
        //NSLog(@"consoleContents.isChanged") ;
        isContentsChanged = NO ;
        [self reloadPreviewContents] ;
    }
    
}


- (void)didConsoleTabBarTap:(CGFloat)x
{
    CGFloat ratio = x / [VeamUtil getScreenWidth] ;
    NSInteger index = ratio * [self.tabBarController.viewControllers count] ;
    [self showTabBarController:index] ;
    //[self.window bringSubviewToFront:floatingMenuView] ;
}

- (void)showTabBarController:(NSInteger)selectedTab
{
    //NSLog(@"showTabBarController") ;
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_TAB") ;
    screenStatus = VEAM_SCREEN_STATUS_TAB ;
    if(selectedTab >= 0){
        self.tabBarController.selectedIndex = selectedTab ;
    }
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO] ;
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;
                        [self.window setRootViewController:self.tabBarController] ;
                        [UIView setAnimationsEnabled:oldState] ;
                        //[self.window bringSubviewToFront:previewBackButton] ;
                    }
                    completion:nil];

    if((selectedTab == forumTabIndex) && (userNotification != nil)){
        UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:forumTabIndex] ;
        if([userNotification.kind isEqualToString:USER_NOTIFICATION_KIND_FOLLOW]){
            ProfileViewController *profileViewController = [[ProfileViewController alloc] init] ;
            [profileViewController setSocialUserId:userNotification.fromUserId] ;
            [profileViewController setSocialUserName:@""] ;
            [profileViewController setTitleName:@"Profile"] ;
            [navigationController pushViewController:profileViewController animated:NO] ;
        } else if([userNotification.kind isEqualToString:USER_NOTIFICATION_KIND_COMMENT_PICTURE] ||
                  [userNotification.kind isEqualToString:USER_NOTIFICATION_KIND_LIKE_PICTURE]){
            NSString *pictureId = userNotification.pictureId ;
            if(![VeamUtil isEmpty:pictureId] && ![pictureId isEqualToString:@"0"]){
                PictureViewController *notificationPictureViewController = [[PictureViewController alloc] init] ;
                [notificationPictureViewController setForumId:[NSString stringWithFormat:@"f:%@",pictureId]] ;
                [notificationPictureViewController setTitleName:@"My post"] ;
                [navigationController pushViewController:notificationPictureViewController animated:NO] ;
            }
        } else if([userNotification.kind isEqualToString:USER_NOTIFICATION_KIND_MESSAGE]){
            /*
             if([VeamUtil isLoggedIn]){
             MessageViewController *messageViewController = [[MessageViewController alloc] init] ;
             //[messageViewController setUserImageUrl:messageUser.imageUrl] ;
             [messageViewController setHidesBottomBarWhenPushed:YES] ;
             [messageViewController setSocialUserId:userNotification.fromUserId] ;
             [messageViewController setTitleName:@""] ;
             [navigationController pushViewController:messageViewController animated:NO] ;
             }
             */
        }
        userNotification = nil ;
    }
}



- (CGFloat)getTabBarHeight
{
    //NSLog(@"getTabBarHeight screenStatus=%d",screenStatus) ;
    CGFloat retValue = 0 ;
    if(screenStatus == VEAM_SCREEN_STATUS_TAB){
        retValue = 49.0 ;
    }
    
    return retValue ;
}


- (void)showLoginSelector
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"login", nil)
                          message:NSLocalizedString(@"login_selection", nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"cancel",nil)
                          otherButtonTitles:@"Facebook", @"Twitter", @"Email",nil] ;
    [alert setTag:VEAM_ALERT_VIEW_LOGIN_SELECTOR] ;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == VEAM_ALERT_VIEW_LOGIN_SELECTOR){
        switch (buttonIndex) {
            case 1: // Button1が押されたとき
                //NSLog(@"facebook");
                [self openFacebookSession] ;
                break;
                
            case 2: // Button2が押されたとき
                //NSLog(@"twitter");
                [VeamUtil openTwitterSession] ;
                break;
            case 3: // Emailが押されたとき
                //NSLog(@"Email");
                [self openEmailSession] ;
                break;
            default: // キャンセルが押されたとき
                //NSLog(@"Cancel");
                break;
        }
    } else if(alertView.tag == VEAM_ALERT_VIEW_UPDATE_CHECK){
        switch (buttonIndex) {
            case 1: // Button1が押されたとき
                //NSLog(@"app store");
                break;
            default: // キャンセルが押されたとき
                //NSLog(@"Cancel");
                break;
        }
    }
}

/*
- (void)openTwitterSession
{
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:
     ^(BOOL granted, NSError *error)
     {
         if (granted) {
             NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
             if ([twitterAccounts count] > 0) {
                 ACAccount *twitterAccount = [twitterAccounts objectAtIndex:0];
                 
                 // "https://api.twitter.com/1.1/statuses/update_with_media.json"
                 TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"] parameters:nil requestMethod:TWRequestMethodGET];
                 
                 // Set the account used to post the tweet.
                 [postRequest setAccount:twitterAccount] ;
                 
                 // Perform the request created above and create a handler block to handle the response.
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      //NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                      
                      //NSString *str= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                      //NSLog(@"res=%@",str) ;
                      if(!error){
                          NSLog(@"twitter : completed successfully") ;
                          
                          // Parse the responseData, which we asked to be in JSON format for this request
                          NSError *jsonParsingError = nil;
                          //this is an array of dictionaries
                          NSDictionary *aTweet = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
                          
                          //point to the first tweet
                          //NSDictionary *aTweet = [arrayTweets objectAtIndex:0];
                          
                          //write to log
                          NSLog(@"id_str: %@", [aTweet objectForKey:@"id_str"]);
                          NSLog(@"name: %@", [aTweet objectForKey:@"name"]);
                          NSLog(@"screen_name: %@", [aTweet objectForKey:@"screen_name"]);
                          NSLog(@"profile_image_url: %@", [aTweet objectForKey:@"profile_image_url"]);
                          
                          NSString *twitterId = [aTweet objectForKey:@"id_str"] ;
                          NSString *twitterName = [aTweet objectForKey:@"name"] ;
                          NSString *twitterUser = [aTweet objectForKey:@"screen_name"] ;
                          NSString *twitterImageUrl = [aTweet objectForKey:@"profile_image_url"] ;
                          [VeamUtil loginWithTwitter:twitterId name:twitterName user:twitterUser imageUrl:twitterImageUrl] ;
                          
                          if(loginPendingOperationDelegate != nil){
                              //NSLog(@"loginPendingOperationDelegate::doPendingOperation1") ;
                              [loginPendingOperationDelegate doPendingOperation] ;
                              loginPendingOperationDelegate = nil ;
                          } else {
                              //NSLog(@"loginPendingOperationDelegate is nil 1") ;
                          }
                      } else {
                          NSString *message = [error localizedDescription];
                          NSLog(@"twitter : completed with error : %@",message) ;
                      }
                  }
                  ] ;
                 
             } else {
                 NSLog(@"No Twitter Account") ;
                 [self performSelectorOnMainThread:@selector(showNoTwitterMessage) withObject:nil waitUntilDone:NO] ;
             }
         } else {
             NSLog(@"Not Granted") ;
             [self performSelectorOnMainThread:@selector(showNoTwitterMessage) withObject:nil waitUntilDone:NO] ;
         }
     }
     ];
}
 */

- (void)handleTwitterCredential:(NSData *)responseData
{
    // Parse the responseData, which we asked to be in JSON format for this request
    NSError *jsonParsingError = nil;
    //this is an array of dictionaries
    NSDictionary *aTweet = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
    
    //point to the first tweet
    //NSDictionary *aTweet = [arrayTweets objectAtIndex:0];
    
    //write to log
    /*
     NSLog(@"id_str: %@", [aTweet objectForKey:@"id_str"]);
     NSLog(@"name: %@", [aTweet objectForKey:@"name"]);
     NSLog(@"screen_name: %@", [aTweet objectForKey:@"screen_name"]);
     NSLog(@"profile_image_url: %@", [aTweet objectForKey:@"profile_image_url"]);
     */
    
    NSString *twitterId = [aTweet objectForKey:@"id_str"] ;
    NSString *twitterName = [aTweet objectForKey:@"name"] ;
    NSString *twitterUser = [aTweet objectForKey:@"screen_name"] ;
    NSString *twitterImageUrl = [aTweet objectForKey:@"profile_image_url"] ;
    if([VeamUtil isEmpty:twitterImageUrl]){
        twitterImageUrl = [aTweet objectForKey:@"profile_image_url_https"] ;
    }
    
    if(![VeamUtil isEmpty:twitterId]){
        [VeamUtil loginWithTwitter:twitterId name:twitterName user:twitterUser imageUrl:twitterImageUrl] ;
        if(loginPendingOperationDelegate != nil){
            //NSLog(@"loginPendingOperationDelegate::doPendingOperation1") ;
            [loginPendingOperationDelegate doPendingOperation] ;
            loginPendingOperationDelegate = nil ;
        } else {
            //NSLog(@"loginPendingOperationDelegate is nil 1") ;
        }
    } else {
        [self performSelectorOnMainThread:@selector(dispErrorMessage:) withObject:@"Something wrong with your twitter account.\nPlease re-register your Twitter account on iOS settings." waitUntilDone:NO] ;
    }
}

- (void)operateTwitterInfo:(NSInteger)accountIndex
{
    ACAccount *twitterAccount = [twitterAccounts objectAtIndex:accountIndex];
    
    // "https://api.twitter.com/1.1/statuses/update_with_media.json"
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"] parameters:nil requestMethod:TWRequestMethodGET];
    
    // Set the account used to post the tweet.
    [postRequest setAccount:twitterAccount] ;
    
    // Perform the request created above and create a handler block to handle the response.
    [postRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSInteger statusCode = urlResponse.statusCode ;
         /*
          NSLog([NSString stringWithFormat:@"HTTP response status: %i", statusCode]) ;
          NSString *str= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
          NSLog(@"res=%@",str) ;
          */
         
         if((400 <= statusCode) && (statusCode < 500)){ // auth failed
             if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
                 [accountStore renewCredentialsForAccount:twitterAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                     // https://twittercommunity.com/t/ios-6-twitter-accounts-with-no-password-stored/6183/5
                     // if you want to ensure that the system account is still valid,
                     // make a request using SLRequest with an attached ACAccount instance.
                     // The "verify_credentials" endpoint is a good target to use.
                     // If this call fails with something in the 4xx HTTP status code range, you can assume that the account is invalid.
                     // The ACAccountStore includes a -[renewCredentialsForAccount:completion:] method
                     // that you can call to have the system inform the user that he or she should re-enter the account's password in Settings.
                     /*
                      if(renewResult == ACAccountCredentialRenewResultRenewed){
                      NSLog(@"renewed");
                      } else if(renewResult == ACAccountCredentialRenewResultRejected){
                      NSLog(@"rejected");
                      } else if(renewResult == ACAccountCredentialRenewResultFailed){
                      NSLog(@"failed");
                      }
                      */
                 }] ;
             } else {
                 [self performSelectorOnMainThread:@selector(dispErrorMessage:) withObject:@"Something wrong with your twitter account.\nPlease re-register your Twitter account on iOS settings." waitUntilDone:NO] ;
             }
         } else {
             if(!error){
                 NSLog(@"twitter : completed successfully") ;
                 [self handleTwitterCredential:responseData] ;
             } else {
                 NSString *message = [error localizedDescription];
                 NSLog(@"twitter : completed with error : %@",message) ;
                 [self performSelectorOnMainThread:@selector(dispErrorMessage:) withObject:message waitUntilDone:NO] ;
             }
         }
     }
     ] ;
}


- (void)openTwitter
{
    //NSLog(@"AppDelegate::openTwitter") ;
    if(accountStore == nil){
        accountStore = [[ACAccountStore alloc] init] ;
    }
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:
     ^(BOOL granted, NSError *error)
     {
         if (granted) {
             //NSLog(@"granted") ;
             twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
             NSInteger twitterCount = [twitterAccounts count] ;
             if (twitterCount > 0) {
                 //NSLog(@"number of accounts = %d",[twitterAccounts count]) ;
                 if(twitterCount == 1){
                     [self operateTwitterInfo:0] ;
                 } else {
                     // show action sheet to select account
                     [self performSelectorOnMainThread:@selector(showTwitterSelectActionSheet) withObject:nil waitUntilDone:NO] ;
                 }
             } else {
                 //NSLog(@"No Twitter Account") ;
                 [self performSelectorOnMainThread:@selector(showNoTwitterMessage) withObject:nil waitUntilDone:NO] ;
             }
         } else {
             //NSLog(@"Not Granted") ;
             [self performSelectorOnMainThread:@selector(showNoTwitterMessage) withObject:nil waitUntilDone:NO] ;
         }
     }
     ];
}

- (void)showTwitterSelectActionSheet
{
    NSInteger count = [twitterAccounts count] ;
    //NSLog(@"showTwitterSelectActionSheet count=%d",count) ;
    if(count > 0){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Twitter"
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:nil] ;
        
        for(int index = 0 ; index < count ; index++){
            ACAccount *twitterAccount = [twitterAccounts objectAtIndex:index] ;
            [actionSheet addButtonWithTitle:twitterAccount.username] ;
        }
        [actionSheet addButtonWithTitle:@"Cancel"] ;
        [actionSheet setCancelButtonIndex:count] ;
        
        
        // アクションシートの表示
        [actionSheet showInView:self.window] ;
    }
}

/**
 * アクションシートのボタンが押されたとき
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger count = [twitterAccounts count] ;
    //NSLog(@"clickedButtonAtIndex index=%d",buttonIndex) ;
    if(buttonIndex < count){
        [self operateTwitterInfo:buttonIndex] ;
    }
}


- (void)dispErrorMessage:(NSString *)message
{
    [VeamUtil dispError:message] ;
}

- (void)showNoTwitterMessage
{
    [VeamUtil dispMessage:@"Please go into your device's settings menu to add your Twitter account." title:@"No Twitter Account Detected"] ;
}

- (void)backFromEmailLogin
{
    //NSLog(@"backFromVideoCamera") ;
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO] ;
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;
                        [self.window setRootViewController:emailLoginBackViewController] ;
                        [UIView setAnimationsEnabled:oldState] ;
                        //[self.window bringSubviewToFront:previewBackButton] ;
                    }
                    completion:nil];
    
    emailLoginBackViewController = nil ;
    
}


- (void)openEmailSession
{
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_CAMERA") ;
    screenStatus = VEAM_SCREEN_STATUS_EMAIL_SESSION ;
    
    EmailTopViewController *viewController = [[EmailTopViewController alloc] init];
    VeamNavigationController *navigationController = [[VeamNavigationController alloc] initWithRootViewController:viewController] ;
    
    emailLoginBackViewController = self.window.rootViewController ;

    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:navigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}

- (void)emailSessionOpen:(NSString *)emailUserId name:(NSString *)name secret:(NSString *)secret
{
    //NSLog(@"sessionStateChanged") ;
    //NSLog(@"FBSessionStateOpen") ;
    if(![VeamUtil isLoggedIn]){
         //NSLog(@"user name : %@  id : %@",user.name,user.id) ;
        [VeamUtil loginWithEmail:emailUserId name:name secret:secret] ;
         
         if(loginPendingOperationDelegate != nil){
             //NSLog(@"loginPendingOperationDelegate::doPendingOperation1") ;
             [loginPendingOperationDelegate doPendingOperation] ;
             loginPendingOperationDelegate = nil ;
         } else {
             //NSLog(@"loginPendingOperationDelegate is nil 1") ;
         }
    } else {
        if(loginPendingOperationDelegate != nil){
            //NSLog(@"loginPendingOperationDelegate::doPendingOperation2") ;
            [loginPendingOperationDelegate doPendingOperation] ;
            loginPendingOperationDelegate = nil ;
        } else {
            //NSLog(@"loginPendingOperationDelegate is nil2") ;
        }
    }
}


- (void)openFacebookSession
{
    //NSLog(@"openSession") ;
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    /*
     [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:
     ^(FBSession *session,FBSessionState state, NSError *error) {
     [self sessionStateChanged:session state:state error:error];
     }];
     */
    
    [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:
     ^(FBSession *session,FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    //NSLog(@"sessionStateChanged") ;
    switch (state) {
        case FBSessionStateOpen:
        {
            //NSLog(@"FBSessionStateOpen") ;
            if(![VeamUtil isLoggedIn]){
                [[FBRequest requestForMe] startWithCompletionHandler:
                 ^(FBRequestConnection *connection,NSDictionary<FBGraphUser> *user,NSError *error)
                 {
                     if(!error){
                         //NSLog(@"user name : %@  id : %@",user.name,user.id) ;
                         [VeamUtil loginWithFacebook:user.id name:user.name] ;
                         
                         if(loginPendingOperationDelegate != nil){
                             //NSLog(@"loginPendingOperationDelegate::doPendingOperation1") ;
                             [loginPendingOperationDelegate doPendingOperation] ;
                             loginPendingOperationDelegate = nil ;
                         } else {
                             //NSLog(@"loginPendingOperationDelegate is nil 1") ;
                         }
                     }
                 }];
            } else {
                if(loginPendingOperationDelegate != nil){
                    //NSLog(@"loginPendingOperationDelegate::doPendingOperation2") ;
                    [loginPendingOperationDelegate doPendingOperation] ;
                    loginPendingOperationDelegate = nil ;
                } else {
                    //NSLog(@"loginPendingOperationDelegate is nil2") ;
                }
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            //NSLog(@"FBSessionStateClosed") ;
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if(error != nil){
                if(error.fberrorShouldNotifyUser){
                    NSString *alertTitle ;
                    NSString *alertMessage ;
                    if ([[error userInfo][FBErrorLoginFailedReason] isEqualToString:FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue]) {
                        // Show a different error message
                        alertTitle = @"App Disabled" ;
                        alertMessage = [NSString stringWithFormat:@"Go to Settings > Facebook and turn ON %@.",[VeamUtil getAppName]] ;
                        // Perform any additional customizations
                    } else {
                        // If the SDK has a message for the user, surface it.
                        alertTitle = @"Something Went Wrong" ;
                        alertMessage = error.fberrorUserMessage ;
                    }
                    [VeamUtil dispMessage:alertMessage title:alertTitle] ;
                }
                NSLog(@"error localizedDescription = %@",[error localizedDescription]) ;
            }
            //NSString *description = @"user denied";
            //NSString *recoverySuggestion = @"let the user accept";
            //NSInteger errorCode = -1;
            //NSArray *keys = [NSArray arrayWithObjects: NSLocalizedDescriptionKey, NSLocalizedRecoverySuggestionErrorKey, nil];
            //NSArray *values = [NSArray arrayWithObjects:description, recoverySuggestion, nil];
            //NSDictionary *userDict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //NSLog(@"application openURL : %@",[url absoluteString]) ;
    if([[DBSession sharedSession] handleOpenURL:url]){
        if([[DBSession sharedSession] isLinked]){
            //NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }

    return [FBSession.activeSession handleOpenURL:url] ;
}

- (void)showFloatingMenuWithClassName:(NSString *)className instance:(id)instance
{
    //NSLog(@"%@::showFloatingMenuWithClassName %@",NSStringFromClass([self class]),className) ;
    currentInstance = instance ;
    if([className isEqualToString:@"ForumViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"WebListViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"SellItemCategoryViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"SellSectionCategoryViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"YoutubeCategoryViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"SellVideoViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"SellPdfViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"SellAudioViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"SellSectionItemViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"VideoViewController"]){
        VideoViewController *videoViewController = currentInstance ;
        NSInteger numberOfWaitingVideos = [[ConsoleUtil getConsoleContents] getNumberOfWaitingVideoForCategory:videoViewController.categoryId] ;
        NSString *badgeString = @"" ;
        if(numberOfWaitingVideos > 0){
            badgeString = [NSString stringWithFormat:@"%d",numberOfWaitingVideos] ;
        }
        
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",badgeString,@"BADGE",nil] ;
        NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
    } else if([className isEqualToString:@"MixedGridViewController"]){
        MixedGridViewController *mixedGridViewController = currentInstance ;
        NSInteger numberOfWaitingMixeds = [[ConsoleUtil getConsoleContents] getNumberOfWaitingMixedForCategory:@"0"] ;
        NSString *badgeString = @"" ;
        if(numberOfWaitingMixeds > 0){
            badgeString = [NSString stringWithFormat:@"%d",numberOfWaitingMixeds] ;
        }
        
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"NO",@"SELECTED",badgeString,@"BADGE",nil] ;
        NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
        /*
    } else if([className isEqualToString:@"SubscriptionPurchaseViewController"]){
        NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"YES",@"SELECTED",nil] ;
        NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Upload",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Customize",@"TITLE", @"NO",@"SELECTED",nil] ;
        NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3,nil] ;
        [VeamUtil showFloatingMenu:elements delegate:self] ;
         */
    } else {
        //NSLog(@"hide floating menu") ;
        [VeamUtil hideFloatingMenu] ;
    }
}

- (BOOL)canChangeSettings
{
    NSString *appStatus = consoleContents.appInfo.status ;
    //NSLog(@"canChangeSettings appStatus=%@",appStatus) ;
    if(
       [appStatus isEqualToString:VEAM_APP_INFO_STATUS_MCN_REVIEW] ||
       [appStatus isEqualToString:VEAM_APP_INFO_STATUS_BUILDING] ||
       [appStatus isEqualToString:VEAM_APP_INFO_STATUS_APPLE_REVIEW]
       ){
        [VeamUtil dispMessage:@"You can't change.\nNow submitting this app." title:@""] ;
        return NO ;
    }
    return YES ;
}

- (void)didTapFloatingMenu:(NSInteger)index
{
    //NSLog(@"%@::didTapFloatingMenu index=%d",NSStringFromClass([self class]),index) ;
    if([ConsoleUtil hasUserPrivilage:VEAM_CONSOLE_USER_PRIVILAGE_CONTENTS_WRITE]){
        NSString *className = NSStringFromClass([currentInstance class]) ;
        if([className isEqualToString:@"ForumViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    ConsoleForumViewController *viewController = [[ConsoleForumViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"forum_theme",nil)] ;
                    [viewController setNumberOfHeaderDots:3] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"WebListViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    ConsoleWebViewController *viewController = [[ConsoleWebViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"links_url",nil)] ;
                    [viewController setNumberOfHeaderDots:3] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"SellItemCategoryViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    ConsoleSellItemCategoryViewController *viewController = [[ConsoleSellItemCategoryViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"sell_content_category",nil)] ;
                    [viewController setNumberOfHeaderDots:2] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"SellSectionCategoryViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    ConsoleSellSectionCategoryViewController *viewController = [[ConsoleSellSectionCategoryViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"sell_content_category",nil)] ;
                    [viewController setNumberOfHeaderDots:2] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"YoutubeCategoryViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    ConsoleYoutubeCategoryViewController *viewController = [[ConsoleYoutubeCategoryViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:@"YouTube - Playlists"] ;
                    [viewController setNumberOfHeaderDots:3] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"SellVideoViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    SellVideoViewController *videoViewController = currentInstance ;
                    VideoCategory *videoCategory = [contents getVideoCategoryForId:videoViewController.categoryId] ;
                    //NSLog(@"videoCategoryId:%@",videoCategory.videoCategoryId) ;
                    
                    ConsoleSellVideoViewController *viewController = [[ConsoleSellVideoViewController alloc] init] ;
                    [viewController setVideoCategory:videoCategory] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"sell_video_upload",nil)] ;
                    [viewController setNumberOfHeaderDots:2] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"SellPdfViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    SellPdfViewController *pdfViewController = currentInstance ;
                    PdfCategory *pdfCategory = [contents getPdfCategoryForId:pdfViewController.categoryId] ;
                    //NSLog(@"pdfCategoryId:%@",pdfCategory.pdfCategoryId) ;
                    
                    ConsoleSellPdfViewController *viewController = [[ConsoleSellPdfViewController alloc] init] ;
                    [viewController setPdfCategory:pdfCategory] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"sell_pdf_upload",nil)] ;
                    [viewController setNumberOfHeaderDots:2] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"SellAudioViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    SellAudioViewController *audioViewController = currentInstance ;
                    AudioCategory *audioCategory = [contents getAudioCategoryForId:audioViewController.categoryId] ;
                    //NSLog(@"audioCategoryId:%@",audioCategory.audioCategoryId) ;
                    
                    ConsoleSellAudioViewController *viewController = [[ConsoleSellAudioViewController alloc] init] ;
                    [viewController setAudioCategory:audioCategory] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"sell_audio_upload",nil)] ;
                    [viewController setNumberOfHeaderDots:2] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"SellSectionItemViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    SellSectionItemViewController *currentViewController = currentInstance ;
                    SellSectionCategory *category = [contents getSellSectionCategoryForId:currentViewController.categoryId] ;
                    
                    ConsoleSellSectionItemViewController *viewController = [[ConsoleSellSectionItemViewController alloc] init] ;
                    [viewController setSellSectionCategory:category] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"sell_section_item_upload",nil)] ;
                    [viewController setNumberOfHeaderDots:2] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"VideoViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    VideoViewController *videoViewController = currentInstance ;
                    VideoCategory *videoCategory = [contents getVideoCategoryForId:videoViewController.categoryId] ;
                    ConsoleVideoViewController *viewController = [[ConsoleVideoViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"exclusive_upload",nil)] ;
                    [viewController setNumberOfHeaderDots:3] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    [viewController setVideoCategory:videoCategory] ;
                    [viewController setVideoSubCategory:nil] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
        } else if([className isEqualToString:@"MixedGridViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    MixedGridViewController *mixedGridViewController = currentInstance ;
                    ConsoleMixedForGridViewController *viewController = [[ConsoleMixedForGridViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [viewController setHeaderTitle:NSLocalizedString(@"exclusive_upload",nil)] ;
                    [viewController setNumberOfHeaderDots:3] ;
                    [viewController setSelectedHeaderDot:1] ;
                    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    //[viewController setVideoCategory:videoCategory] ;
                    //[viewController setVideoSubCategory:nil] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
            /*
        } else if([className isEqualToString:@"SubscriptionPurchaseViewController"]){
            if((index == 1) || (index == 2)){
                if([self canChangeSettings]){
                    ConsoleEditSubscriptionDescriptionViewController *viewController = [[ConsoleEditSubscriptionDescriptionViewController alloc] init] ;
                    [viewController setLaunchFromPreview:YES] ;
                    [viewController setFooterImage:[self getFooterImage]] ;
                    if(index == 2){
                        [viewController setShowCustomizeFirst:YES] ;
                    } else {
                        [viewController setShowCustomizeFirst:NO] ;
                    }
                    [self pushViewControllerFromSideMenu:viewController] ;
                }
            }
             */
        } else {
            
        }
    } else {
        NSLog(@"no privilage") ;
    }
}

- (UIImage *)getFooterImage
{
    CGFloat scale = 1.0 ;
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        scale = [UIScreen mainScreen].scale ;
    }
    return [VeamUtil cropImage:[self getScreenShot] toRect:CGRectMake(0, ([VeamUtil getScreenHeight]-49)*scale, [VeamUtil getScreenWidth]*scale, 49*scale)] ;
}


- (void)showFloatingMenu:(NSArray *)elements delegate:(id)delegate
{
    if([ConsoleUtil hasUserPrivilage:VEAM_CONSOLE_USER_PRIVILAGE_CONTENTS_WRITE]){
        //NSLog(@"%@::showFloatingMenu elements",NSStringFromClass([self class])) ;
        if(floatingMenuView != nil){
            [floatingMenuView setDelegate:nil] ;
            [floatingMenuView removeFromSuperview] ;
            floatingMenuView = nil ;
        }
        //NSLog(@"floatingMenuView is nil") ;
        floatingMenuView = [[ConsoleFloatingMenuView alloc] initWithFrame:CGRectMake(0, [VeamUtil getScreenHeight]-85, [VeamUtil getScreenWidth], [ConsoleFloatingMenuView getMenuHeight])] ;
        [floatingMenuView setAlpha:0.0] ;
        //[self.window addSubview:floatingMenuView] ;
        
        [floatingMenuView setDelegate:delegate] ;
        
        NSString *highlightedColorString = [contents getValueForKey:VEAM_CONFIG_NEW_VIDEOS_TEXT_COLOR] ;
        UIColor *highlightedColor = nil ;
        if([VeamUtil isEmpty:highlightedColorString]){
            highlightedColor = [VeamUtil getColorFromArgbString:@"FFC875EC"] ;
        } else {
            highlightedColor = [VeamUtil getColorFromArgbString:highlightedColorString] ;
        }
        
        
        [floatingMenuView setHighlightedBackgroundColor:highlightedColor] ;
        [floatingMenuView setHighlightedTextColor:[UIColor whiteColor]] ;
        
        [floatingMenuView setMenuElement:elements] ;
        
        if(!showingFloatingMenu){
            [UIView beginAnimations:nil context:NULL] ;
            [UIView setAnimationDuration:0.3] ;
            [floatingMenuView setAlpha:1.0] ;
            [UIView commitAnimations] ;
        } else {
            [floatingMenuView setAlpha:1.0] ;
        }
        showingFloatingMenu = YES ;
        
        //[self.window bringSubviewToFront:floatingMenuView] ;
        
        [self.floatingMenuWindow setFrame:floatingMenuView.frame] ;
        CGRect frame = floatingMenuView.frame ;
        frame.origin.x = 0 ;
        frame.origin.y = 0 ;
        [floatingMenuView setFrame:frame] ;
        [self.floatingMenuWindow addSubview:floatingMenuView] ;
        [self.floatingMenuWindow setHidden:NO] ;
        
        if(!initialTutorialDone){
            [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_TUTORIAL_DONE value:@"1"] ;
            initialTutorialDone = YES ;
            [self showInitialTutorial] ;
        }

    } else {
        NSLog(@"%@::showFloatingMenu no privilage",NSStringFromClass([self class])) ;
    }
}

- (void)showInitialTutorial
{
    if([ConsoleUtil hasUserPrivilage:VEAM_CONSOLE_USER_PRIVILAGE_CONTENTS_WRITE]){
        //NSLog(@"%@::showInitialTutorial",NSStringFromClass([self class])) ;
        if(initialTutorialView == nil){
            //NSLog(@"initialTutorialView is nil") ;
            initialTutorialView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
            [initialTutorialView setBackgroundColor:[VeamUtil getColorFromArgbString:@"33000000"]] ;
            [self.initialTutorialWindow addSubview:initialTutorialView] ;
            
            NSArray *titles = [NSArray arrayWithObjects:
                               NSLocalizedString(@"initial_tutorial_title_1",nil),
                               NSLocalizedString(@"initial_tutorial_title_2",nil),
                               NSLocalizedString(@"initial_tutorial_title_3",nil),
                               nil] ;
            NSArray *subTitles = [NSArray arrayWithObjects:
                                  NSLocalizedString(@"initial_tutorial_sub_title_1",nil),
                                  NSLocalizedString(@"initial_tutorial_sub_title_2",nil),
                                  NSLocalizedString(@"initial_tutorial_sub_title_3",nil),
                                  nil] ;

            buttonTexts = [NSArray arrayWithObjects:
                           NSLocalizedString(@"initial_tutorial_button_1",nil),
                           NSLocalizedString(@"initial_tutorial_button_2",nil),
                           NSLocalizedString(@"initial_tutorial_button_3",nil),
                           nil] ;

            
            numberOfTutorials = [titles count] ;
            titleLabels = [NSMutableArray array] ;
            subTitleLabels = [NSMutableArray array] ;
            buttonLabel = nil ;
            tutorialDotImageViews = [NSMutableArray array] ;
            currentTutorialIndex = 0 ;
            tutorialDotOffImage = [UIImage imageNamed:@"initial_tutorial_dot_off.png"] ;
            tutorialDotOnImage = [UIImage imageNamed:@"initial_tutorial_dot_on.png"] ;
            
            CGFloat dotGap = 3 ;
            CGFloat titleSize = 48 / 2 ;
            CGFloat subTitleSize = 24 / 2 ;
            CGFloat buttonSize = 36 / 2 ;
            
            tutorialDialogWidth = 287 ;
            tutorialDialogHeight = 183 ;
            UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-tutorialDialogWidth)/2, ([VeamUtil getScreenHeight]-tutorialDialogHeight)/2, tutorialDialogWidth, tutorialDialogHeight)] ;
            [dialogView setBackgroundColor:[UIColor whiteColor]] ;
            dialogView.layer.cornerRadius = 3 ;
            dialogView.clipsToBounds = YES ;

            [initialTutorialView addSubview:dialogView] ;
            
            CGFloat currentY = 21 ;
            
            UIImage *tutorialImage = [UIImage imageNamed:@"tutorial_icon.png"] ;
            CGFloat imageWidth = tutorialImage.size.width / 2 ;
            CGFloat imageHeight = tutorialImage.size.height / 2 ;
            UIImageView *tutorialImageView = [[UIImageView alloc] initWithFrame:CGRectMake((tutorialDialogWidth-imageWidth)/2, currentY, imageWidth, imageHeight)] ;
            [tutorialImageView setImage:tutorialImage] ;
            [dialogView addSubview:tutorialImageView] ;
            
            currentY += imageHeight ;
            currentY += 8 ;

            imageWidth = tutorialDotOffImage.size.width / 2 ;
            imageHeight = tutorialDotOffImage.size.height / 2 ;
            CGFloat currentX = (tutorialDialogWidth / 2)  - (numberOfTutorials - 1) * (dotGap + imageWidth) / 2  - (imageWidth / 2) ;
            for(int index = 0 ; index < numberOfTutorials ; index++){
                UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, currentY, imageWidth, imageHeight)] ;
                if(index == currentTutorialIndex){
                    [dotImageView setImage:tutorialDotOnImage] ;
                } else {
                    [dotImageView setImage:tutorialDotOffImage] ;
                }
                [dialogView addSubview:dotImageView] ;
                [tutorialDotImageViews addObject:dotImageView] ;
                currentX += dotGap + imageWidth ;
                
                NSString *title = [titles objectAtIndex:index] ;
                NSString *subTitle = [subTitles objectAtIndex:index] ;
                NSString *buttonText = [buttonTexts objectAtIndex:index] ;
                
                CGFloat titleY = currentY + imageHeight + 8 ;
                CGFloat subTitleY = titleY + titleSize + 5 ;
                CGFloat buttonY = subTitleY + subTitleSize * 3 + 20 ;
                if([VeamUtil isEmpty:subTitle]){
                    titleY += 6 ;
                }
                CGFloat movableLabelX = 0 ;
                if(index != currentTutorialIndex){
                    movableLabelX = tutorialDialogWidth ;
                }
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(movableLabelX, titleY, tutorialDialogWidth, titleSize+2)] ;
                [titleLabel setText:title] ;
                [titleLabel setNumberOfLines:1] ;
                [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:titleSize]] ;
                [titleLabel setAdjustsFontSizeToFitWidth:YES] ;
                [titleLabel setMinimumScaleFactor:0.2f] ;
                [titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF6C7177"]] ;
                [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
                [dialogView addSubview:titleLabel] ;
                [titleLabels addObject:titleLabel] ;
                
                
                
                
                
                
                UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(movableLabelX, subTitleY, tutorialDialogWidth, (subTitleSize+3)*3)] ;
                [subTitleLabel setText:subTitle] ;
                [subTitleLabel setNumberOfLines:3] ;
                [subTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:subTitleSize]] ;
                [subTitleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF6C7177"]] ;
                [subTitleLabel setTextAlignment:NSTextAlignmentCenter] ;
                [dialogView addSubview:subTitleLabel] ;
                [subTitleLabels addObject:subTitleLabel] ;
                /*
                [subTitleLabel sizeToFit] ;
                CGRect frame = subTitleLabel.frame ;
                CGFloat newX = movableLabelX + (tutorialDialogWidth - frame.size.width) / 2 ;
                NSLog(@"%f -> %f",movableLabelX,newX) ;
                frame.origin.x = newX ;
                [subTitleLabel setFrame:frame] ;
                 */
                

                if(index == currentTutorialIndex){
                    buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonY, tutorialDialogWidth, buttonSize+2)] ;
                    [buttonLabel setText:buttonText] ;
                    [buttonLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:buttonSize]] ;
                    [buttonLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFFF0000"]] ;
                    [buttonLabel setTextAlignment:NSTextAlignmentCenter] ;
                    [dialogView addSubview:buttonLabel] ;
                    [VeamUtil registerTapAction:buttonLabel target:self selector:@selector(didTapTutorial)] ;
                }
            }
        }
        
        [self.initialTutorialWindow setHidden:NO] ;
    } else {
        NSLog(@"%@::showInitialTutorial no privilage",NSStringFromClass([self class])) ;
    }
}

- (void)didTapTutorial
{
    //NSLog(@"didTapTutorial") ;
    
    currentTutorialIndex++ ;
    if(currentTutorialIndex >= numberOfTutorials){
        //NSLog(@"last tutorial end") ;
        [self hideInitialTutorial] ;
        [self showPreview] ;
    } else {
        if(currentTutorialIndex == 1){
            [self didTapFloatingMenu:1] ;
        } else if(currentTutorialIndex == 2){
            tutorialSideMenu = YES ;
            [self showSideMenu:NO] ;
            tutorialTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(animateTutorialSideMenu) userInfo:nil repeats:YES] ;
        }
        UILabel *currentTitleLabel = [titleLabels objectAtIndex:currentTutorialIndex-1] ;
        CGRect currentTitleFrame = currentTitleLabel.frame ;
        UILabel *nextTitleLabel = [titleLabels objectAtIndex:currentTutorialIndex] ;
        CGRect nextTitleFrame = nextTitleLabel.frame ;
        UILabel *currentSubTitleLabel = [subTitleLabels objectAtIndex:currentTutorialIndex-1] ;
        CGRect currentSubTitleFrame = currentSubTitleLabel.frame ;
        UILabel *nextSubTitleLabel = [subTitleLabels objectAtIndex:currentTutorialIndex] ;
        CGRect nextSubTitleFrame = nextSubTitleLabel.frame ;
        
        currentTitleFrame.origin.x = -tutorialDialogWidth ;
        nextTitleFrame.origin.x = 0 ;
        currentSubTitleFrame.origin.x = -tutorialDialogWidth ;
        nextSubTitleFrame.origin.x = 0 ;
        
        [UIView beginAnimations:nil context:NULL] ;
        [UIView setAnimationDuration:0.3] ;
        [UIView setAnimationDelegate:self] ;
        [UIView setAnimationDidStopSelector:@selector(updateTutorial)] ;
        [currentTitleLabel setFrame:currentTitleFrame] ;
        [nextTitleLabel setFrame:nextTitleFrame] ;
        [currentSubTitleLabel setFrame:currentSubTitleFrame] ;
        [nextSubTitleLabel setFrame:nextSubTitleFrame] ;
        [UIView commitAnimations] ;
    }
    
}

- (void)updateTutorial
{
    if(currentTutorialIndex < numberOfTutorials){
        NSString *buttonText = [buttonTexts objectAtIndex:currentTutorialIndex] ;
        [buttonLabel setText:buttonText] ;
        for(int index = 0 ; index < numberOfTutorials ; index++){
            UIImageView *imageView = [tutorialDotImageViews objectAtIndex:index] ;
            if(index == currentTutorialIndex){
                [imageView setImage:tutorialDotOnImage] ;
            } else {
                [imageView setImage:tutorialDotOffImage] ;
            }
        }
    }
}

- (void)animateTutorialSideMenu
{
    if(tutorialSideMenu){
        tutorialSideMenu = NO ;
        //[self hideSideMenu] ;
        [sideMenuViewController initialImageTap] ;
    } else {
        tutorialSideMenu = YES ;
        [self showSideMenu:NO] ;
    }
}
- (void)hideInitialTutorial
{
    //NSLog(@"%@::hideInitialTutorial",NSStringFromClass([self class])) ;
    if(tutorialTimer != nil){
        //NSLog(@"updateTimer invalidate") ;
        [tutorialTimer invalidate] ;
        tutorialTimer = nil ;
        
    }
    [self.initialTutorialWindow setHidden:YES] ;
}


- (void)hideFloatingMenu
{
    //NSLog(@"%@::hideFloatingMenu",NSStringFromClass([self class])) ;
    showingFloatingMenu = NO ;
    if(floatingMenuView != nil){
        [UIView beginAnimations:nil context:NULL] ;
        [UIView setAnimationDuration:0.3] ;
        [floatingMenuView setAlpha:0.0] ;
        [UIView commitAnimations] ;
    }
    [self.floatingMenuWindow setHidden:YES] ;
}


- (void)showFooterImageWindow
{
    //NSLog(@"%@::showFooterImageWindow",NSStringFromClass([self class])) ;
    if(footerImageView != nil){
        [footerImageView removeFromSuperview] ;
        footerImageView = nil ;
    }
    
    UIImage *footerImage = [self getFooterImage] ;
    CGFloat imageWidth = [VeamUtil getScreenWidth] ;
    CGFloat imageHeight = footerImage.size.height * imageWidth / footerImage.size.width ;
    footerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [VeamUtil getScreenHeight]-imageHeight,imageWidth,imageHeight)] ;
    [footerImageView setImage:footerImage] ;
    
    [self.footerImageWindow setFrame:footerImageView.frame] ;
    CGRect frame = footerImageView.frame ;
    frame.origin.x = 0 ;
    frame.origin.y = 0 ;
    [footerImageView setFrame:frame] ;
    [self.footerImageWindow addSubview:footerImageView] ;
    [self.footerImageWindow setHidden:NO] ;
}

- (void)hideFooterImageWindow
{
    //NSLog(@"%@::hideFooterImageView",NSStringFromClass([self class])) ;
    [self.footerImageWindow setHidden:YES] ;
}


- (void)setIsPurchasing:(BOOL)isPurchasingToBeSet
{
    isPurchasing = isPurchasingToBeSet ;
    if(isPurchasing){
        self.shouldUpdate = NO ;
    }
}

- (BOOL)getIsPurchasing
{
    return isPurchasing ;
}

- (void)loadTabBarController
{
    NSArray *templateIds = [VeamUtil getTemplateIds] ;
    NSInteger numberOfTabs = [templateIds count] ;

    VeamTabBarController *workTabBarController = [[VeamTabBarController alloc] init] ;

    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:numberOfTabs] ;
    for(int index = 0 ; index < numberOfTabs ; index++){
        UIViewController *viewController = [VeamUtil createViewControllerFor:[templateIds objectAtIndex:index]] ;
        if(viewController != nil){
            [viewControllers addObject:viewController] ;
            if([[templateIds objectAtIndex:index] isEqualToString:VEAM_TEMPLATE_ID_FORUM]){
                forumTabIndex = index ;
            }
        }
    }
    numberOfTabs = [viewControllers count] ;
    
    workTabBarController.viewControllers = viewControllers ;
    workTabBarController.selectedIndex = 0 ;
    workTabBarController.delegate = self ;
    if(self.tabBarController != nil){
        self.tabBarController.delegate = nil ;
    }
    self.tabBarController = workTabBarController ;
    
    //タブバー設定
    [[UITabBar appearance] setBackgroundImage:[VeamUtil imageNamed:@"tab_back.png"]] ;
    [[UITabBar appearance] setSelectionIndicatorImage:[VeamUtil imageNamed:@"tab_selected_back.png"]] ;
    // [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)]; // 64bit OS で iAd が正しく動かなくなる。
    [[UITabBar appearance] setContentMode:UIViewContentModeScaleAspectFit] ;
    
    UITabBarItem *item ;
    UITabBar *tabBar = self.tabBarController.tabBar ;
    UIColor *textColor = [VeamUtil getTabTextColor] ;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    textColor, UITextAttributeTextColor,
                                    [UIFont systemFontOfSize:9.0], UITextAttributeFont,
                                    //[UIFont boldSystemFontOfSize:11.0], UITextAttributeFont,
                                    nil] ;
    for(int index = 0 ; index < numberOfTabs ; index++){
        NSString *templateId = [templateIds objectAtIndex:index] ;
        //NSLog(@"set tab item for %@",templateId) ;
        NSString *selectedImageName = [NSString stringWithFormat:@"t%@_tab_on.png",templateId] ;
        NSString *unselectedImageName = [NSString stringWithFormat:@"t%@_tab_off.png",templateId] ;
        item = [tabBar.items objectAtIndex:index] ;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            //NSLog(@"set tab item images for ios 8") ;
            [item setImage:[[VeamUtil imageNamed:unselectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [item setSelectedImage:[[VeamUtil imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        } else {
            [item setFinishedSelectedImage:[UIImage imageNamed:selectedImageName] withFinishedUnselectedImage:[UIImage imageNamed:unselectedImageName]] ;
            [item setSelectedImage:[UIImage imageNamed:selectedImageName]] ;
        }
        [item setTitleTextAttributes:textAttributes forState:UIControlStateNormal] ;
        [item setTitleTextAttributes:textAttributes forState:UIControlStateSelected] ;
        [item setTitlePositionAdjustment:UIOffsetMake(0, -2)] ;
    }
    
    
}

- (void)analyzeView:(UIView *)view indent:(int)indent
{
    //NSLog(@"%d:%@",indent,NSStringFromClass([view class])) ;
    [view setBackgroundColor:[UIColor clearColor]] ;
    
    NSString *className = NSStringFromClass([view class]) ;
    if([className isEqualToString:@"UITabBarSwappableImageView"]){
        //[view setContentMode:UIViewContentModeScaleAspectFit] ;
        //[view setBackgroundColor:[UIColor redColor]] ;
    }
    NSArray *subViews = [view subviews] ;
    int count = [subViews count] ;
    for(int index = 0 ; index < count ; index++){
        UIView *subView = [subViews objectAtIndex:index] ;
        [self analyzeView:subView indent:indent+1] ;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //NSLog(@"tabBarController didSelectViewController") ;
    
    NSUInteger selectedIndex = tabBarController.selectedIndex ;
    int count = [tabBarController.viewControllers count] ;
    for(int index = 0 ; index < count ; index++){
        if(index != selectedIndex){
            //[[tabBarController.viewControllers objectAtIndex:index] popToRootViewControllerAnimated:NO] ;
            NSArray *viewControllers = [[tabBarController.viewControllers objectAtIndex:index] viewControllers] ;
            int viewCount = [viewControllers count] ;
            UIViewController *targetViewController = nil ;
            for(int viewIndex = 0 ; viewIndex < viewCount ; viewIndex++){
                UIViewController *viewController = [viewControllers objectAtIndex:viewIndex] ;
                NSString* className = NSStringFromClass([viewController class]);
                //NSLog(@"%d-%d:%@",index,viewIndex,className) ;
                if([className isEqualToString:@"ProfileViewController"]){
                    [[tabBarController.viewControllers objectAtIndex:index] popToViewController:targetViewController animated:NO] ;
                    break ;
                }
                targetViewController = viewController ;
            }
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //NSLog(@"tabBarController shouldSelectViewController %d",tabBarController.selectedIndex) ;
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView){
        return YES ;
    }
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.3
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return YES ;
}

- (void)showUpdateContentsIndicator
{
    //NSLog(@"showUpdateContentsIndicator") ;
    if(updateContentsIndicator != nil){
        [updateContentsIndicator removeFromSuperview] ;
        updateContentsIndicator = nil ;
    }
    updateContentsIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    updateContentsIndicator.center = self.window.center ;
    [self.window addSubview:updateContentsIndicator] ;
    [updateContentsIndicator startAnimating] ;
}

- (void)hideUpdateContentsIndicator
{
    //NSLog(@"hideUpdateContentsIndicator") ;
    if(updateContentsIndicator != nil){
        [updateContentsIndicator stopAnimating] ;
        [updateContentsIndicator removeFromSuperview] ;
        updateContentsIndicator = nil ;
    }
}

- (void)reloadPreviewContents
{
    [self performSelectorOnMainThread:@selector(showUpdateContentsIndicator) withObject:nil waitUntilDone:NO] ;
    [self performSelectorInBackground:@selector(updateContents) withObject:nil] ;
}

- (void)showPreview
{
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_INITIAL") ;
    screenStatus = VEAM_SCREEN_STATUS_INITIAL ;
    [self loadTabBarController] ;
    InitialViewController *initialViewController = [[InitialViewController alloc] initWithNibName:@"InitialViewController" bundle:nil] ;
    //NSLog(@"set initial controller as root view controller") ;
    self.window.rootViewController = initialViewController ;
    
    /*
    previewBackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    [previewBackButton setFrame:CGRectMake(0, 300, 30, 30)] ;
    [previewBackButton setBackgroundColor:[UIColor clearColor]] ;
    [previewBackButton setTitle:@"<-" forState:UIControlStateNormal] ;
    [VeamUtil registerTapAction:previewBackButton target:self selector:@selector(showDashboard)] ;
    [self.window addSubview:previewBackButton] ;
     */
}

- (void)showDashboard
{
    /*
    [previewBackButton removeFromSuperview] ;
    previewBackButton = nil ;
     */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;
    self.window.rootViewController = dashboardNavigationController ;
}

- (void)showHome
{
    [self showDashboard] ;
    NSArray *viewControllers = [dashboardNavigationController viewControllers] ;
    for(int i = [viewControllers count]-1 ; i >= 0 ; i--){
        id obj = [viewControllers objectAtIndex:i] ;
        if([obj isKindOfClass:[ConsoleHomeViewController class]]){
            [dashboardNavigationController popToViewController:obj animated:NO] ;
            return;
        }
    }
    
    ConsoleHomeViewController *viewController ;
    NSString *appStatus = self.consoleContents.appInfo.status ;
    if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_INITIALIZED]){
        viewController = [[ConsoleHomeViewController alloc] init] ;
        [viewController setMode:VEAM_CONSOLE_HOME_MODE_NOT_INSTALLED] ;
    } else {
        AlternativeImage *alternativeImage = [consoleContents getAlternativeImageForFileName:@"c_veam_icon.png"] ;
        UIImage *iconImage = [VeamUtil getCachedImage:alternativeImage.url downloadIfNot:YES] ;
        //NSLog(@"icon=%@",alternativeImage.url) ;
        viewController = [[ConsoleHomeViewController alloc] init] ;
        [viewController setMode:VEAM_CONSOLE_HOME_MODE_INSTALLING] ;
        [viewController setWithoutCountDown:YES] ;
        [viewController setTargetIconImage:iconImage] ;
    }
    [dashboardNavigationController pushViewController:viewController animated:NO] ;

}

- (UIImage *)getScreenShot
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        //NSLog(@"scale %f",[UIScreen mainScreen].scale) ;
        //UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO, [UIScreen mainScreen].scale) ;
        UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO, 0) ;
        //UIGraphicsBeginImageContext(self.window.bounds.size) ;
    } else {
        UIGraphicsBeginImageContext(self.window.bounds.size) ;
    }
    
    
    
    // get screenshot
    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()] ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;

    return image ;
}

- (void)setRootViewControllerToSideMenu
{
    self.window.rootViewController = sideMenuViewController   ;
}

- (void)showSideMenu:(BOOL)launchFromPreview
{
    //NSLog(@"showSideMenu") ;
    
    UIImage *image = [self getScreenShot] ;
    
    sideMenuViewController = [[ConsoleSideMenuViewController alloc] init] ;
    [sideMenuViewController setLaunchFromPreview:launchFromPreview] ;
    [sideMenuViewController setInitialImage:image] ;
    
    menuBackController = self.window.rootViewController ;
    [self performSelectorOnMainThread:@selector(setRootViewControllerToSideMenu) withObject:nil waitUntilDone:NO] ;
}

- (void)showStats
{
    NSString *previewAppId = [VeamUtil getAppId] ;
    //NSLog(@"showStats appId=%@",previewAppId) ;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Stats" bundle:nil] ;
    RootViewController *statsViewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"] ;
    [statsViewController setAppId:previewAppId] ;
    //NSLog(@"statsViewController setAppId:%@",previewAppId) ;
    
    VeamNavigationController *statsNavigationController = [[VeamNavigationController alloc] initWithRootViewController:statsViewController] ;
    [statsNavigationController setNavigationBarHidden:YES] ;

    
    CATransition *animation = [CATransition animation] ;
    [animation setDelegate:self] ;
    //[animation setValue:@"PreviewToConsole" forKey:@"AnimationKind"];
    [animation setDuration:0.3] ;
    [animation setType:kCATransitionPush] ;
    [animation setSubtype:kCATransitionFromRight] ;
    [animation setFillMode:kCAFillModeForwards] ;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]] ;
    [[self.window layer] addAnimation:animation forKey:nil] ;
    [self.window setRootViewController:statsNavigationController] ;
}

- (void)backFromStats
{
    CATransition *animation = [CATransition animation] ;
    [animation setDelegate:self] ;
    //[animation setValue:@"PreviewToConsole" forKey:@"AnimationKind"];
    [animation setDuration:0.3] ;
    [animation setType:kCATransitionPush] ;
    [animation setSubtype:kCATransitionFromLeft] ;
    [animation setFillMode:kCAFillModeForwards] ;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]] ;
    [[self.window layer] addAnimation:animation forKey:nil] ;
    [self.window setRootViewController:menuBackController] ;
}

- (void)pushViewControllerFromPreviewToDashboard:(UIViewController *)viewController
{
    [dashboardNavigationController pushViewController:viewController animated:NO] ;
    self.window.rootViewController = dashboardNavigationController ;
}

- (void)showDashboardWithAnimation
{
    //NSLog(@"showDashboardWithAnimation") ;
    CATransition *animation = [CATransition animation] ;
    [animation setDelegate:self] ;
    [animation setValue:@"PreviewToConsole" forKey:@"AnimationKind"];
    [animation setDuration:0.3] ;
    [animation setType:kCATransitionPush] ;
    [animation setSubtype:kCATransitionFromRight] ;
    [animation setFillMode:kCAFillModeForwards] ;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]] ;
    [[self.window layer] addAnimation:animation forKey:nil] ;
    //self.window.rootViewController = dashboardNavigationController ;
    [self.window setRootViewController:dashboardNavigationController] ;

    
}

- (void)pushViewControllerFromSideMenu:(ConsoleViewController *)viewController
{
    //NSLog(@"pushViewControllerFromSideMenu") ;
    if(self.window.rootViewController == self.tabBarController){
        [self showFooterImageWindow] ;
    }
    
    if(viewController.launchFromPreview){
        [dashboardNavigationController popToRootViewControllerAnimated:NO] ;
    }
    [dashboardNavigationController pushViewController:viewController animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;
    
    //[self performSelectorOnMainThread:@selector(showDashboardWithAnimation) withObject:nil waitUntilDone:NO] ;
    [self showDashboardWithAnimation] ;
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSString *animationKind = [theAnimation valueForKey:@"AnimationKind"];
    //NSLog(@"%@ end",animationKind) ;
    if([animationKind isEqualToString:@"PreviewToConsole"]){
        [self hideFooterImageWindow] ;
    } else if([animationKind isEqualToString:@"ConsoleToPreview"]){
        [self hideFooterImageWindow] ;
    }
}

- (void)hideSideMenu
{
    self.window.rootViewController = menuBackController ;
    //[self.window bringSubviewToFront:floatingMenuView] ;
}



- (void)playVideo:(Video *)video title:(NSString *)title
{
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_MOVIE") ;
    screenStatus = VEAM_SCREEN_STATUS_MOVIE ;
    [self setMovieKey:[video key]] ;
    DRMMovieViewController* movieViewController = [[DRMMovieViewController alloc] init];
    [movieViewController setVideoTitleName:[video title]] ;
    movieViewController.strPathName = getHttpUrl([video videoId]) ;
    [movieViewController setContentId:[video videoId]] ;
    [movieViewController setVideo:video] ;
    [movieViewController setTitleName:title] ;
    [movieViewController setLinkUrl:[video linkUrl]] ;
    
    UINavigationController *movieNavigationController = [[UINavigationController alloc] initWithRootViewController:movieViewController] ;

    
    //[self.window setRootViewController:movieViewController] ;
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:movieNavigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}


- (void)playAudio:(Audio *)audio title:(NSString *)title
{
    //NSLog(@"screenStatus = VEAM_SCREEN_STATUS_AUDIO") ;
    screenStatus = VEAM_SCREEN_STATUS_AUDIO ;
    AudioPlayViewController* audioPlayViewController = [[AudioPlayViewController alloc] init];
    [audioPlayViewController setAudio:audio] ;
    [audioPlayViewController setTitleName:title] ;
    //[audioPlayViewController setVideoTitleName:[video title]] ;
    //[audioPlayViewController setTitleName:@"Exclusive Video"] ;
    
    VeamNavigationController *audioNavigationController = [[VeamNavigationController alloc] initWithRootViewController:audioPlayViewController] ;
    
    
    //[self.window setRootViewController:movieViewController] ;
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:audioNavigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}

- (void)setAnswers:(Questions *)targetAnswers
{
    answers = targetAnswers ;
}

- (Questions *)getAnswers
{
    return answers ;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    //NSLog(@"deviceToken: %@", devToken);
    //NSLog(@"deviceToken: %@", [devToken description]) ;
    
    NSInteger length = devToken.length ;
    NSMutableString* tokenString = [NSMutableString stringWithCapacity:length * 2] ;
    unsigned char *devTokenBytes = (unsigned char *)[devToken bytes] ;
    for(int i = 0; i < length ; i++){
        [tokenString appendFormat:@"%02x", devTokenBytes[i]  ];
    }

    //NSLog(@"console deviceToken: %@", tokenString) ;
    [VeamUtil setUserDefaultString:@"CONSOLE_DEVICE_TOKEN" value:tokenString] ;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSLog(@"didReceiveRemoteNotification");
    for (id key in userInfo) {
        //NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }

    NSInteger kind = 0 ;
    id kindValue = [userInfo objectForKey:@"kind"] ;
    if(kindValue != nil){
        kind = [kindValue integerValue] ;
    }
    //NSLog(@"kind=%d",kind) ;

    /*
    if(kind > 0){
        if(!hasNewNotification){
            hasNewNotification = YES ;
            NSDictionary *noUserInfo = [NSDictionary dictionary] ;
            NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_NEW_NOTIFICATION_CHANGED object:self userInfo:noUserInfo] ;
            [[NSNotificationCenter defaultCenter] postNotification:notification] ;
        }
        
        NSString *notidicationId = [NSString stringWithFormat:NOTIFICATION_RECEIVED_ID_FORMAT,kind] ;
        NSNotification *notification = [NSNotification notificationWithName:notidicationId object:self userInfo:userInfo] ;
        [[NSNotificationCenter defaultCenter] postNotification:notification] ;
    }
     */
    
    // アプリケーションの状態を見る。
    UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState] ;
    if(applicationState != UIApplicationStateActive){
        [self setUserNotification:userInfo] ;
    }
}
    
    - (void)setUserNotification:(NSDictionary *)userInfo
    {
        id kindValue = [userInfo objectForKey:@"kind"] ;
        id pictureIdValue = [userInfo objectForKey:@"picture_id"] ;
        id socialUserIdValue = [userInfo objectForKey:@"social_user_id"] ;
        NSInteger kind = 0 ;
        NSInteger pictureId = 0 ;
        NSInteger socialUserId = 0 ;
        
        if(kindValue != nil){
            kind = [kindValue integerValue] ;
        }
        
        if(pictureIdValue != nil){
            pictureId = [pictureIdValue integerValue] ;
        }
        
        if(socialUserIdValue != nil){
            socialUserId = [socialUserIdValue integerValue] ;
        }
        
        userNotification = [[UserNotification alloc] init];
        [userNotification setUserNotificationId:@"0"] ;
        [userNotification setFromUserId:[NSString stringWithFormat:@"%d",socialUserId]] ;
        [userNotification setCreatedAt:@"0"] ;
        [userNotification setMessage:@""] ;
        [userNotification setText:@""] ;
        [userNotification setKind:[NSString stringWithFormat:@"%d",kind]] ;
        [userNotification setReadFlag:@"0"] ;
        [userNotification setPictureId:[NSString stringWithFormat:@"%d",pictureId]] ;
    }


/*
- (void)updateContoleContents
{
    [self performSelectorInBackground:@selector(updateConsoleContents) withObject:nil] ;
}
*/




@end
