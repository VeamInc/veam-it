//
//  ConsoleAppDelegate.h
//  veam00000000
//
//  Created by veam on 5/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamTabBarController.h"
#import "Configurations.h"
#import "Contents.h"
#import "ConsoleContents.h"
#import "LoginPendingOperationDelegate.h"
#import "ConsoleTabBarController.h"
#import "Questions.h"
#import "DeviceToken.h"
#import "ConsoleFloatingMenuView.h"
#import "ConsoleSideMenuViewController.h"
#import "VeamNavigationController.h"
#import "UserNotification.h"
#import <Accounts/Accounts.h>


/*
#if INCLUDE_KIIP == 1
#import <KiipSDK/KiipSDK.h>
#endif
*/

/*
#if INCLUDE_KIIP == 1
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,KiipDelegate>
#else
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
#endif
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    NSString *appId ;
    NSInteger screenStatus ;
    BOOL isPurchasing ;
    //UIButton *previewBackButton ;
    VeamNavigationController *dashboardNavigationController ;
    Questions *answers ;
    DeviceToken *deviceToken ;
    UIViewController *menuBackController ;
    id currentInstance ;
    
    ConsoleFloatingMenuView *floatingMenuView ;
    UIImageView *footerImageView ;
    
    UIActivityIndicatorView *updateContentsIndicator ;
    
    BOOL showingFloatingMenu ;
    ConsoleSideMenuViewController *sideMenuViewController ;
    
    NSArray *twitterAccounts ;
    ACAccountStore *accountStore ;

    UIView *initialTutorialView ;
    BOOL initialTutorialDone ;
    NSInteger numberOfTutorials ;
    NSMutableArray *titleLabels ;
    NSMutableArray *subTitleLabels ;
    UILabel *buttonLabel ;
    NSMutableArray *tutorialDotImageViews ;
    NSInteger currentTutorialIndex ;
    UIImage *tutorialDotOffImage ;
    UIImage *tutorialDotOnImage ;
    NSArray *buttonTexts ;
    CGFloat tutorialDialogWidth ;
    CGFloat tutorialDialogHeight ;
    BOOL tutorialSideMenu ;
    NSTimer *tutorialTimer ;
    
    UIViewController *videoCameraBackViewController ;
    UIViewController *emailLoginBackViewController ;
    
    NSInteger forumTabIndex ;
    UserNotification *userNotification ;

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *floatingMenuWindow;
@property (strong, nonatomic) UIWindow *footerImageWindow;
@property (strong, nonatomic) UIWindow *initialTutorialWindow;

//@property (nonatomic, retain) ConsoleTabBarController *consoleTabBarController ;
@property (nonatomic, retain) UITabBarController *consoleTabBarController ;
@property (nonatomic, retain) VeamTabBarController *tabBarController ;
@property (nonatomic, retain) Configurations *configurations ;
@property (nonatomic, retain) Contents *contents ;
@property (nonatomic, retain) ConsoleContents *consoleContents ;
@property (nonatomic, assign) BOOL shouldUpdate ;
@property (nonatomic, assign) BOOL picturePosted ;
@property (nonatomic, assign) BOOL questionPosted ;
@property (nonatomic, assign) BOOL descriptionPosted ;
@property (nonatomic, retain) id <LoginPendingOperationDelegate> loginPendingOperationDelegate ;
@property (nonatomic, retain) NSString *currentAppId ;
@property (nonatomic, retain) NSString *movieKey ;
@property (nonatomic, retain) NSString *rewardString ;
@property (nonatomic, assign) BOOL shouldShowCalendar ;
@property (nonatomic, assign) NSInteger calendarYear ;
@property (nonatomic, assign) NSInteger calendarMonth ;
@property (nonatomic, retain) UIImage *appIconImage ;
@property (nonatomic, assign) BOOL sellVideoPurchased ;
@property (nonatomic, assign) BOOL sellPdfPurchased ;
@property (nonatomic, assign) BOOL sellAudioPurchased ;
@property (nonatomic, assign) BOOL isContentsChanged ;
@property (nonatomic, assign) BOOL sellSectionPurchased ;


@property (nonatomic, retain) NSURL *shotMovieUrl ;



+ (id)sharedInstance ;
- (NSString *)makeScreenName:(NSString *)viewName ;
- (CGFloat)getTabBarHeight ;
- (void)setTabBarControllerIndex:(NSInteger)index ;
- (void)showTabBarController:(NSInteger)selectedTab ;
- (void)backToPreview ;
- (void)showLoginSelector ;
- (void)showPreview ;
- (void)showHome ;
- (void)updateConsoleContents ;
- (void)updateContents ;
- (void)playVideo:(Video *)video title:(NSString *)title ;
- (void)playAudio:(Audio *)audio title:(NSString *)title ;
- (void)setAnswers:(Questions *)targetAnswers ;
- (Questions *)getAnswers ;
- (void)showStats ;
- (void)backFromStats ;
- (void)showSideMenu:(BOOL)launchFromPreview ;
- (void)hideSideMenu ;
- (void)pushViewControllerFromSideMenu:(ConsoleViewController *)viewController ;
- (void)showFloatingMenu:(NSArray *)elements delegate:(id)delegate ;
- (void)showFloatingMenuWithClassName:(NSString *)className instance:(id)instance ;
- (void)hideFloatingMenu ;
- (void)didConsoleTabBarTap:(CGFloat)x ;
- (BOOL)isShowingPreview ;
- (void)openTwitter ;
- (void)restartConsoleHome ;
- (void)showVideoCameraView ;
- (void)backFromVideoCamera ;
- (void)setUserNotification:(NSDictionary *)userInfo ;

- (void)emailSessionOpen:(NSString *)emailUserId name:(NSString *)name secret:(NSString *)secret ;
- (void)backFromEmailLogin ;

@end
