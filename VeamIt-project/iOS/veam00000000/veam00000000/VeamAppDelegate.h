//
//  AppDelegate.h
//  veam31000000
//
//  Created by veam on 5/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamTabBarController.h"
#import "Configurations.h"
#import "Contents.h"
#import "LoginPendingOperationDelegate.h"
#import "Questions.h"
#import "DeviceToken.h"
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
    Questions *answers ;
    DeviceToken *deviceToken ;
    NSArray *twitterAccounts ;
    ACAccountStore *accountStore ;
    
    NSInteger forumTabIndex ;
    UserNotification *userNotification ;
    UIViewController *emailLoginBackViewController ;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) VeamTabBarController *tabBarController ;
@property (nonatomic, retain) Configurations *configurations ;
@property (nonatomic, retain) Contents *contents ;
@property (nonatomic, assign) BOOL shouldUpdate ;
@property (nonatomic, assign) BOOL picturePosted ;
@property (nonatomic, assign) BOOL questionPosted ;
@property (nonatomic, assign) BOOL descriptionPosted ;
@property (nonatomic, retain) id <LoginPendingOperationDelegate> loginPendingOperationDelegate ;
@property (nonatomic, retain) NSString *movieKey ;
@property (nonatomic, retain) NSString *rewardString ;
@property (nonatomic, assign) BOOL shouldShowCalendar ;
@property (nonatomic, assign) NSInteger calendarYear ;
@property (nonatomic, assign) NSInteger calendarMonth ;
@property (nonatomic, assign) BOOL sellVideoPurchased ;
@property (nonatomic, assign) BOOL sellPdfPurchased ;
@property (nonatomic, assign) BOOL sellAudioPurchased ;
@property (nonatomic, assign) BOOL sellSectionPurchased ;






+ (id)sharedInstance ;
- (NSString *)makeScreenName:(NSString *)viewName ;
- (CGFloat)getTabBarHeight ;
- (void)setTabBarControllerIndex:(NSInteger)index ;
- (void)showTabBarController:(NSInteger)selectedTab ;
- (void)showLoginSelector ;
- (void)playVideo:(Video *)video title:(NSString *)title ;
- (void)playAudio:(Audio *)audio title:(NSString *)title ;
- (void)setAnswers:(Questions *)targetAnswers ;
- (Questions *)getAnswers ;
- (void)openTwitter ;
- (void)setUserNotification:(NSDictionary *)userInfo ;
- (void)emailSessionOpen:(NSString *)emailUserId name:(NSString *)name secret:(NSString *)secret ;
- (void)backFromEmailLogin ;


@end
