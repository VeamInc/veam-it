//
//  AppDelegate.m
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
#import "DRMMovieViewController.h"
#import "AudioPlayViewController.h"
#import "ProfileViewController.h"
#import "PictureViewController.h"
#import "EmailTopViewController.h"



static AppDelegate *_sharedInstance = nil ;

@implementation AppDelegate

@synthesize configurations ;
@synthesize contents ;
@synthesize shouldUpdate ;
@synthesize picturePosted ;
@synthesize questionPosted ;
@synthesize descriptionPosted ;
@synthesize loginPendingOperationDelegate ;
@synthesize movieKey ;
@synthesize rewardString ;
@synthesize shouldShowCalendar ;
@synthesize calendarYear ;
@synthesize calendarMonth ;
@synthesize sellVideoPurchased ;
@synthesize sellPdfPurchased ;
@synthesize sellAudioPurchased ;
@synthesize sellSectionPurchased ;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] ;
    if(userInfo){
        /*
         NSLog(@"didFinishLaunchingWithOptions has remote notification") ;
         for (id key in userInfo) {
         NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]) ;
         }
         */
        [self setUserNotification:userInfo] ;
    }

    if([VeamUtil isVeamConsole]){
        NSLog(@"Console App  !!!!! inconsistent !!!!!") ;
    } else {
        NSLog(@"Veam App") ;
    }

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil] ; // to play sound on silent mode
    shouldUpdate = YES ;
    
    /*
#if INCLUDE_KIIP == 1
    Kiip *kiip = [[Kiip alloc] initWithAppKey:@"__KIIP_APP_KEY__" andSecret:@"__KIIP_APP_SECRET__"];
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

    loginPendingOperationDelegate = nil ;
    
    [TTStyleSheet setGlobalStyleSheet:[[StyleSheet alloc] init]];

    
    self.configurations = [[Configurations alloc] initWithResourceFile] ;
    self.contents = [[Contents alloc] initWithResourceFile] ;
    
    //NSLog(@"contents check=%@",[self.contents getValueForKey:@"check"]) ;
    //NSLog(@"app_id=%@",[self.configurations getValueForKey:@"app_id"]) ;
    appId = [configurations getValueForKey:@"app_id"] ;

    [self loadTabBarController] ;
    
    InitialViewController *initialViewController = [[InitialViewController alloc] initWithNibName:@"InitialViewController" bundle:nil] ;

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;

    /*
    self.window.rootViewController = self.tabBarController ;
    screenStatus = VEAM_SCREEN_STATUS_TAB ;
     */

    //NSLog(@"set initial controller as root view controller") ;
    self.window.rootViewController = initialViewController ;
    screenStatus = VEAM_SCREEN_STATUS_INITIAL ;
    
    [self.window makeKeyAndVisible];
    
    return YES;
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
        [self performSelectorInBackground:@selector(updateContents) withObject:nil] ;
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

-(void)updateContents
{
    @autoreleasepool
    {
        //NSLog(@"update contents start") ;
        
        BOOL shouldPostNotification = NO ;
        
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
            if(![VeamUtil isStoredAlternativeImage:alternativeImage.alternativeImageId]){
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
        }

        // update purchase
        NSString *storeReceipt = [VeamUtil getStoreReceipt:[VeamUtil getSubscriptionIndex]] ;
        if(![VeamUtil isEmpty:storeReceipt]){
            //NSLog(@"AppDelegage verifyReceipt") ;
            [VeamUtil verifySubscriptionReceipt:storeReceipt clearIfExpired:YES forced:YES] ;
        }
        
        TemplateSubscription *templateSubscription = [contents getTemplateSubscription] ;
        if(templateSubscription != nil){
            if([templateSubscription.isFree isEqualToString:@"1"]){
                //NSLog(@"Free Subscription Set") ;
                [VeamUtil setSubscriptionStartTime:@"946652400" index:[VeamUtil getSubscriptionIndex]] ; // 2000/01/01 00:00:00
                [VeamUtil setSubscriptionEndTime:@"1893423600" index:[VeamUtil getSubscriptionIndex]] ; // 2030/01/01 00:00:00
            }
        }
        
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
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [VeamUtil dispError:@"Camera is not available."] ;
        return ;
    }
    
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

- (void)showSettingsView
{
    screenStatus = VEAM_SCREEN_STATUS_SETTINGS ;
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [settingsViewController setTitleName:NSLocalizedString(@"settings",nil)] ;
    
    VeamNavigationController *settingsNavigationController = [[VeamNavigationController alloc] initWithRootViewController:settingsViewController] ;
    
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [self.window setRootViewController:settingsNavigationController] ;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}

- (void)setTabBarControllerIndex:(NSInteger)index
{
    self.tabBarController.selectedIndex = index ;
}

- (void)showTabBarController:(NSInteger)selectedTab
{
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
        [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel",nil)] ;
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //NSLog(@"application openURL : %@",[url absoluteString]) ;
    return [FBSession.activeSession handleOpenURL:url] ;
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
        NSString *selectedImageName = [NSString stringWithFormat:@"t%@_tab_on.png",templateId] ;
        NSString *unselectedImageName = [NSString stringWithFormat:@"t%@_tab_off.png",templateId] ;
        item = [tabBar.items objectAtIndex:index] ;

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            //NSLog(@"set tab item images for ios 8") ;
            [item setImage:[[VeamUtil imageNamed:unselectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [item setSelectedImage:[[VeamUtil imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        } else {
            [item setFinishedSelectedImage:[VeamUtil imageNamed:selectedImageName] withFinishedUnselectedImage:[VeamUtil imageNamed:unselectedImageName]] ;
            [item setSelectedImage:[VeamUtil imageNamed:selectedImageName]] ;
        }
        
        [item setTitleTextAttributes:textAttributes forState:UIControlStateNormal] ;
        [item setTitleTextAttributes:textAttributes forState:UIControlStateSelected] ;
        [item setTitlePositionAdjustment:UIOffsetMake(0, -2)] ;
    }
    
}

/*
- (void)analyzeView:(UIView *)view indent:(int)indent
{
    NSLog(@"%d:%@",indent,NSStringFromClass([view class])) ;
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
*/

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

- (void)playVideo:(Video *)video title:(NSString *)title
{
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
    screenStatus = VEAM_SCREEN_STATUS_AUDIO ;
    AudioPlayViewController* audioPlayViewController = [[AudioPlayViewController alloc] init];
    [audioPlayViewController setAudio:audio] ;
    [audioPlayViewController setTitleName:title] ;
    //[audioPlayViewController setVideoTitleName:[video title]] ;
    //[audioPlayViewController setTitleName:@"Premium Video"] ;
    
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
    
    deviceToken = [[DeviceToken alloc] init] ;
    deviceToken.token = devToken ;
    [deviceToken sendToProvider] ;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@", error);
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



@end
