//
//  ConsoleSideMenuViewController.m
//  veam00000000
//
//  Created by veam on 8/27/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleSideMenuViewController.h"
#import "ConsoleSideMenuElementView.h"
#import "AppDelegate.h"
#import "VeamUtil.h"
#import "ConsoleAppStoreViewController.h"
#import "ConsoleCustomizeViewController.h"
#import "ConsoleMessageViewController.h"
#import "ConsoleChangeFeatureViewController.h"
#import "ConsoleSelectLoginViewController.h"
#import "ConsoleTermsViewController.h"
#import "ConsoleEditBankAccountViewController.h"
#import "ConsoleBrowserViewController.h"
#import "VeamUtil.h"

#define SIDE_MENU_WIDTH             247
//#define SIDE_MENU_WIDTH             20
#define SIDE_MENU_LEFT_MARGIN       16
#define SIDE_MENU_RIGHT_MARGIN      11
#define SIDE_MENU_LINE_MARGIN       25


#define SIDE_MENU_TITLE_PREVIEW         @"Back to Preview"
#define SIDE_MENU_TITLE_HOME            @"Back to Home"
#define SIDE_MENU_TITLE_DESIGN          @"Customize Your App Design"
#define SIDE_MENU_TITLE_CONTENT_TYPE    @"Customize Content Type"
#define SIDE_MENU_TITLE_FEATURE         @"Add Features"
#define SIDE_MENU_TITLE_APP_INFO        @"Preparing for App Submission"
#define SIDE_MENU_TITLE_BANK_ACCOUNT    @"Register Bank Account"
#define SIDE_MENU_TITLE_HELP            @"Help and Support"
#define SIDE_MENU_TITLE_INFORMATION     @"Information from Veam"
#define SIDE_MENU_TITLE_FAQ             @"FAQ"
#define SIDE_MENU_TITLE_ABOUT           @"About This App"
#define SIDE_MENU_TITLE_SIGN_OUT        @"Sign out"
#define SIDE_MENU_TITLE_STATS           @"Stats"
#define SIDE_MENU_TITLE_TERMS           @"Accept the terms"
#define SIDE_MENU_TITLE_SUBMIT          @"App Submit"
#define SIDE_MENU_TITLE_DEPLOY          @"Publish"

#define VEAM_ALERT_VIEW_SUBMIT          1


@interface ConsoleSideMenuViewController ()

@end

@implementation ConsoleSideMenuViewController

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
    //NSLog(@"SideMenuViewController::viewDidLoad") ;
    
    animationDone = NO ;
    
    CGFloat viewTopOffset = [VeamUtil getViewTopOffset] ;
    
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [grayView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9]] ;
    [contentView addSubview:grayView] ;
    
    menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(320-SIDE_MENU_WIDTH, 0, SIDE_MENU_WIDTH, [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight])] ;
    [menuScrollView setBackgroundColor:[UIColor clearColor]] ;
    [contentView addSubview:menuScrollView] ;
    
    
    initialImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -[VeamUtil getStatusBarHeight], [VeamUtil getScreenWidth],[VeamUtil getScreenHeight])] ;
    [initialImageView setImage:self.initialImage] ;
    [contentView addSubview:initialImageView] ;
    
    [VeamUtil registerTapAction:initialImageView target:self selector:@selector(initialImageTap)] ;
    
    [self setMenu] ;
    
    menuScrollView.transform = CGAffineTransformMakeScale(0.8, 0.8) ;

    /*
    if(viewTopOffset > 0){
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], viewTopOffset)] ;
        [whiteView setBackgroundColor:[UIColor whiteColor]] ;
        [contentView addSubview:whiteView] ;
    }
     */
    
    if(self.launchFromPreview){
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getViewTopOffset])] ;
        [blackView setBackgroundColor:[UIColor blackColor]] ;
        [self.view addSubview:blackView] ;
    }

}

- (void)didPreviewTap
{
    //NSLog(@"didPreviewTap") ;
    if(self.launchFromPreview){
        [self initialImageTap] ;
    } else {
        [VeamUtil backToPreview] ;
    }
}

- (void)didHomeTap
{
    //NSLog(@"didHomeTap") ;
    [ConsoleUtil showHome] ;
}

- (void)didStatsTap
{
    //NSLog(@"didStatsTap") ;
    [VeamUtil showStats] ;
}

- (void)didDeployTap
{
    //NSLog(@"didDeployTap") ;
    // submit
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
    //NSLog(@"call contents::submitToMcn") ;
    [[ConsoleUtil getConsoleContents] deployContents] ;

}

- (void)didRequiredAppInformationTap
{
    //NSLog(@"didRequiredAppInformationTap") ;
    ConsoleAppStoreViewController *appStoreViewController = [[ConsoleAppStoreViewController alloc] init] ;
    [appStoreViewController setLaunchFromPreview:self.launchFromPreview] ;
    [appStoreViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [appStoreViewController setHeaderTitle:NSLocalizedString(@"required_app_information",nil)] ;
    [appStoreViewController setNumberOfHeaderDots:0] ;
    [appStoreViewController setSelectedHeaderDot:0] ;
    [appStoreViewController setShowFooter:NO] ;
    [appStoreViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:appStoreViewController] ;
}

- (void)didCustomizeYourAppDesignTap
{
    //NSLog(@"didCustomizeYourAppDesignTap") ;
    ConsoleCustomizeViewController *viewController = [[ConsoleCustomizeViewController alloc] init] ;
    [viewController setLaunchFromPreview:self.launchFromPreview] ;
    [viewController setCustomizeKind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN] ;
    [viewController setHideHeaderBottomLine:YES] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:NSLocalizedString(@"customize_design_caption", nil)] ;
    [viewController setNumberOfHeaderDots:0] ;
    [viewController setSelectedHeaderDot:0] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:viewController] ;
}

- (void)didCustomizeFeatureTap
{
    //NSLog(@"didCustomizeFeatureTap") ;
    
    
    ConsoleChangeFeatureViewController *changeFeatureViewController = [[ConsoleChangeFeatureViewController alloc] init] ;
    //[changeFeatureViewController setShowBackButton:YES] ;
    //[changeFeatureViewController setShowSettingsDoneButton:YES] ;
    [changeFeatureViewController setLaunchFromPreview:self.launchFromPreview] ;
    [changeFeatureViewController setHideHeaderBottomLine:NO] ;
    [changeFeatureViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [changeFeatureViewController setHeaderTitle:NSLocalizedString(@"customize_feature_caption", nil)] ;
    [changeFeatureViewController setNumberOfHeaderDots:0] ;
    [changeFeatureViewController setSelectedHeaderDot:0] ;
    [changeFeatureViewController setShowFooter:NO] ;
    [changeFeatureViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:changeFeatureViewController] ;

    
    
    /*
    ConsoleCustomizeViewController *viewController = [[ConsoleCustomizeViewController alloc] init] ;
    [viewController setLaunchFromPreview:self.launchFromPreview] ;
    [viewController setCustomizeKind:VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE] ;
    [viewController setHideHeaderBottomLine:YES] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:@"Add features"] ;
    [viewController setNumberOfHeaderDots:0] ;
    [viewController setSelectedHeaderDot:0] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:viewController] ;
     */
}

- (void)didHelperTap
{
    //NSLog(@"didHelperTap") ;
    ConsoleMessageViewController *viewController = [[ConsoleMessageViewController alloc] init] ;
    [viewController setLaunchFromPreview:self.launchFromPreview] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:NSLocalizedString(@"notification_title", nil)] ;
    [viewController setNumberOfHeaderDots:0] ;
    [viewController setSelectedHeaderDot:0] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:viewController] ;
}


- (void)didSignOutTap
{
    //NSLog(@"didSignOutTap") ;
    
    [ConsoleUtil logout] ;
    [ConsoleUtil clearPreviewData] ;
    
    ConsoleSelectLoginViewController *viewController = [[ConsoleSelectLoginViewController alloc] init] ;
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:viewController] ;
}

- (void)didBankTap
{
    //NSLog(@"didBankTap") ;
    ConsoleEditBankAccountViewController *viewController = [[ConsoleEditBankAccountViewController alloc] init] ;
    [viewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:viewController] ;
}

- (void)didSubmitTap
{
    //NSLog(@"didSubmitTap") ;
    NSArray *requiredOperations = [[ConsoleUtil getConsoleContents] getRequiredOperationsToSubmit] ;
    NSInteger count = [requiredOperations count] ;
    
    if(count > 0){
        NSString *message = @"" ;
        for(int index = 0 ; index < count ; index++){
            NSString *operationString = [requiredOperations objectAtIndex:index] ;
            //NSLog(@"%@",operationString) ;
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",operationString]] ;
        }
        [VeamUtil dispMessage:message title:NSLocalizedString(@"required_operations", nil)] ;
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"submit_confirmation_title", nil)
                              message:NSLocalizedString(@"submit_confirmation", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"submit_cancel",nil)
                              otherButtonTitles:NSLocalizedString(@"submit_ok",nil),nil] ;
        [alert setTag:VEAM_ALERT_VIEW_SUBMIT] ;
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == VEAM_ALERT_VIEW_SUBMIT){
        switch (buttonIndex) {
            case 1: // Button1が押されたとき
                //NSLog(@"doSubmit");
                [self doSubmit] ;
                break;
                
            default: // キャンセルが押されたとき
                //NSLog(@"Cancel");
                break;
        }
    }
}


- (void)doSubmit
{
    // submit
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
    //NSLog(@"call contents::submitToMcn") ;
    [[ConsoleUtil getConsoleContents] submitToMcn] ;
}

- (void)didTermsTap
{
    //NSLog(@"didTermsTap") ;
    
    ConsoleTermsViewController *webViewController = [[ConsoleTermsViewController alloc] init] ;
    [webViewController setUrl:[NSString stringWithFormat:@"https://veam.co/top/termsofserviceforyoutuber?loc=%@",[VeamUtil getLanguageId]]] ;
    [webViewController setShowBackButton:YES] ;
    [webViewController setShowSettingsDoneButton:YES] ;
    [webViewController setLaunchFromPreview:self.launchFromPreview] ;
    [webViewController setHideHeaderBottomLine:NO] ;
    [webViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [webViewController setHeaderTitle:NSLocalizedString(@"accept_the_terms", nil)] ;
    [webViewController setNumberOfHeaderDots:0] ;
    [webViewController setSelectedHeaderDot:0] ;
    [webViewController setShowFooter:NO] ;
    [webViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:webViewController] ;
}

- (void)didInformationFromVeamTap
{
    //NSLog(@"didInformationFromVeamTap") ;
}

- (void)didFaqTap
{
    //NSLog(@"didFaqTap") ;
    
    NSString *urlString = [NSString stringWithFormat:@"https://console.veam.co/creator.php/account/inquiry?kind=veamit&os=i&app=%@&lang=%@",[VeamUtil getAppId],[VeamUtil isLocaleJapanese]?@"ja":@"en"] ;
    //NSLog(@"URL=%@",urlString) ;
    ConsoleBrowserViewController *webViewController = [[ConsoleBrowserViewController alloc] init] ;
    [webViewController setUrl:urlString] ;
    [webViewController setShowBackButton:YES] ;
    [webViewController setShowSettingsDoneButton:YES] ;
    [webViewController setLaunchFromPreview:self.launchFromPreview] ;
    [webViewController setHideHeaderBottomLine:NO] ;
    [webViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [webViewController setHeaderTitle:NSLocalizedString(@"inquiry_title", nil)] ;
    [webViewController setNumberOfHeaderDots:0] ;
    [webViewController setSelectedHeaderDot:0] ;
    [webViewController setShowFooter:NO] ;
    [webViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [[AppDelegate sharedInstance] pushViewControllerFromSideMenu:webViewController] ;

}

- (void)didAboutTap
{
    //NSLog(@"didAboutTap") ;
}


- (void)setMenu
{
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *appStatus = contents.appInfo.status ;
    if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_SETTING] ||
       [appStatus isEqualToString:VEAM_APP_INFO_STATUS_INITIALIZED]){
        [self setMenuForSettingStatus] ;
    } else if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_MCN_REVIEW] ||
              [appStatus isEqualToString:VEAM_APP_INFO_STATUS_BUILDING] ||
              [appStatus isEqualToString:VEAM_APP_INFO_STATUS_APPLE_REVIEW]){
        [self setMenuForReviewStatus] ;
    } else {
        [self setMenuForReleasedStatus] ;
    }
}

- (void)setMenuForSettingStatus
{
    CGFloat currentY = 0 ;
    
    ConsoleContents *consoleContents = [ConsoleUtil getConsoleContents] ;
    BOOL termsCompleted = YES ;
    if([VeamUtil isEmpty:consoleContents.appInfo.termsAcceptedAt]){
        termsCompleted = NO ;
    }
    
    BOOL storeInfoCompleted = YES ;
    if([VeamUtil isEmpty:consoleContents.appInfo.keyword]){
        storeInfoCompleted = NO ;
    }
    if([VeamUtil isEmpty:consoleContents.appInfo.category]){
        storeInfoCompleted = NO ;
    }
    
    if(![consoleContents isRatingCompleted] || ![consoleContents isAppDescriptionCompleted]){
        storeInfoCompleted = NO ;
    }

    BOOL bankCompleted = YES ;
    if(![consoleContents isBankCompleted]){
        bankCompleted = NO ;
    }

    currentY += SIDE_MENU_LINE_MARGIN ;
    ConsoleSideMenuElementView *element ;
    element = [self setIconCell:currentY iconFileName:@"side_icon_preview.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_PREVIEW",nil) badge:0 selector:@selector(didPreviewTap)] ;
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_preview.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_HOME",nil) badge:0 selector:@selector(didHomeTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    currentY += SIDE_MENU_LINE_MARGIN ;
    
    UIView *statusCell = [self setCurrentStatus:currentY] ;
    currentY += statusCell.frame.size.height ;

    // TODO TEST
    /*
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        element = [self setIconCell:currentY iconFileName:@"side_icon_stats.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_STATS",nil) badge:0 selector:@selector(didStatsTap)] ;
        currentY += element.frame.size.height ;
    }
    */
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_customize.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_DESIGN",nil) badge:0 selector:@selector(didCustomizeYourAppDesignTap)] ;
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_features.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_FEATURE",nil) badge:0 selector:@selector(didCustomizeFeatureTap)] ;
    currentY += element.frame.size.height ;
    
    if(storeInfoCompleted){
        element = [self setIconCell:currentY iconFileName:@"side_icon_information_off.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_APP_INFO",nil) badge:0 selector:@selector(didRequiredAppInformationTap)] ;
    } else {
        element = [self setIconCell:currentY iconFileName:@"side_icon_information.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_APP_INFO",nil) badge:0 selector:@selector(didRequiredAppInformationTap)] ;
        [element setTitleColor:[UIColor redColor]] ;
    }
    currentY += element.frame.size.height ;
    
    /*
    if(bankCompleted){
        element = [self setIconCell:currentY iconFileName:@"side_icon_bank_off.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_BANK_ACCOUNT",nil) badge:0 selector:@selector(didBankTap)] ;
    } else {
        element = [self setIconCell:currentY iconFileName:@"side_icon_bank.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_BANK_ACCOUNT",nil) badge:0 selector:@selector(didBankTap)] ;
        [element setTitleColor:[UIColor redColor]] ;
    }
    currentY += element.frame.size.height ;
     */
    
    if(termsCompleted){
        element = [self setIconCell:currentY iconFileName:@"side_icon_terms_off.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_TERMS",nil) badge:0 selector:@selector(didTermsTap)] ;
    } else {
        element = [self setIconCell:currentY iconFileName:@"side_icon_terms.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_TERMS",nil) badge:0 selector:@selector(didTermsTap)] ;
        [element setTitleColor:[UIColor redColor]] ;
    }
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_submit_off.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_SUBMIT",nil) badge:0 selector:@selector(didSubmitTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    [self setMenuSeparator:currentY] ;
    currentY++ ;

    element = [self setIconCell:currentY iconFileName:@"side_icon_helper.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_HELP",nil) badge:0 selector:@selector(didHelperTap)] ;
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_faq.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_FAQ",nil) badge:0 selector:@selector(didFaqTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_SIGN_OUT",nil) badge:0 selector:@selector(didSignOutTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += 100 ;
    
    CGFloat contentHeight = currentY ;
    if(contentHeight <= menuScrollView.frame.size.height){
        contentHeight = menuScrollView.frame.size.height + 1 ;
    }
    [menuScrollView setContentSize:CGSizeMake(menuScrollView.frame.size.width, contentHeight)] ;
}


- (UIView *)setCurrentStatus:(CGFloat)currentY
{
    UIView *statusCell ;
    
    ConsoleContents *consoleContents = [ConsoleUtil getConsoleContents] ;
    
    // 0:released 1:setting 2:veamreview 3:applereview 4:initialized 5:building
    if([consoleContents.appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_SETTING]){
        CGFloat completeRatio = [consoleContents getSettingCompletionRatio] ;
        NSInteger completePercentage = completeRatio * 100 ;
        if(completeRatio < 1.0){
            statusCell = [self setStatusCell:currentY title:[NSString stringWithFormat:@"%d%% Complete",completePercentage] titleColor:[UIColor whiteColor] ratio:completeRatio leftColor:[UIColor redColor] rightColor:[VeamUtil getColorFromArgbString:@"FF404040"]] ;
        } else {
            statusCell = [self setStatusCell:currentY title:@"Required app submit" titleColor:[UIColor whiteColor] ratio:1.0 leftColor:[UIColor redColor] rightColor:[VeamUtil getColorFromArgbString:@"FF404040"]] ;
        }
    } else if([consoleContents.appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_MCN_REVIEW]){
        statusCell = [self setStatusCell:currentY title:@"Data Checking" titleColor:[UIColor redColor] ratio:0.0 leftColor:[UIColor redColor] rightColor:[VeamUtil getColorFromArgbString:@"FFEEEEEE"]] ;
    } else if([consoleContents.appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_BUILDING]){
        statusCell = [self setStatusCell:currentY title:@"App Building" titleColor:[UIColor redColor] ratio:0.0 leftColor:[UIColor redColor] rightColor:[VeamUtil getColorFromArgbString:@"FFEEEEEE"]] ;
    } else if([consoleContents.appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_APPLE_REVIEW]){
        statusCell = [self setStatusCell:currentY title:@"Submitting" titleColor:[UIColor redColor] ratio:0.0 leftColor:[UIColor redColor] rightColor:[VeamUtil getColorFromArgbString:@"FFEEEEEE"]] ;
    } else if([consoleContents.appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_RELEASED]){
        if([consoleContents.appInfo.modified isEqualToString:@"1"]){
            statusCell = [self setStatusCell:currentY title:@"Required app upload" titleColor:[UIColor whiteColor] ratio:1.0 leftColor:[UIColor redColor] rightColor:[VeamUtil getColorFromArgbString:@"FF404040"]] ;
        } else {
            statusCell = [self setStatusCell:currentY title:@"Released" titleColor:[UIColor whiteColor] ratio:0.0 leftColor:[UIColor redColor] rightColor:[VeamUtil getColorFromArgbString:@"FF404040"]] ;
        }
    }
    
    return statusCell ;
}

- (void)setMenuForReviewStatus
{
    CGFloat currentY = 0 ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    ConsoleSideMenuElementView *element ;
    element = [self setIconCell:currentY iconFileName:@"side_icon_preview.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_PREVIEW",nil) badge:0 selector:@selector(didPreviewTap)] ;
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_preview.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_HOME",nil) badge:0 selector:@selector(didHomeTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    
    UIView *statusCell = [self setCurrentStatus:currentY] ;
    currentY += statusCell.frame.size.height ;

    currentY += SIDE_MENU_LINE_MARGIN ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    
    
    
    /*
    element = [self setIconCell:currentY iconFileName:@"side_icon_customize.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_DESIGN",nil) badge:0 selector:@selector(didCustomizeYourAppDesignTap)] ;
    currentY += element.frame.size.height ;
     */
    

    
    
    
    

    element = [self setIconCell:currentY iconFileName:@"side_icon_helper.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_HELP",nil) badge:0 selector:@selector(didHelperTap)] ;
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_faq.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_FAQ",nil) badge:0 selector:@selector(didFaqTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    /*
    [self setMenuSeparator:currentY] ;
    currentY++ ;

    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_INFORMATION",nil) badge:0 selector:@selector(didInformationFromVeamTap)] ;
    currentY += element.frame.size.height ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_FAQ",nil) badge:0 selector:@selector(didFaqTap)] ;
    currentY += element.frame.size.height ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_ABOUT",nil) badge:0 selector:@selector(didAboutTap)] ;
    currentY += element.frame.size.height ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
     */
    
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_SIGN_OUT",nil) badge:0 selector:@selector(didSignOutTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += 100 ;
    
    CGFloat contentHeight = currentY ;
    if(contentHeight <= menuScrollView.frame.size.height){
        contentHeight = menuScrollView.frame.size.height + 1 ;
    }
    [menuScrollView setContentSize:CGSizeMake(menuScrollView.frame.size.width, contentHeight)] ;
}

- (void)setMenuForReleasedStatus
{
    CGFloat currentY = 0 ;

    currentY += SIDE_MENU_LINE_MARGIN ;
    ConsoleSideMenuElementView *element ;
    
    
    
    // TODO TEST
    /*
    element = [self setIconCell:currentY iconFileName:@"side_icon_customize.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_DESIGN",nil) badge:0 selector:@selector(didCustomizeYourAppDesignTap)] ;
    currentY += element.frame.size.height ;
    */
    
    
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_preview.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_PREVIEW",nil) badge:0 selector:@selector(didPreviewTap)] ;
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_preview.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_HOME",nil) badge:0 selector:@selector(didHomeTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    currentY += SIDE_MENU_LINE_MARGIN ;
    
    UIView *statusCell = [self setCurrentStatus:currentY] ;
    currentY += statusCell.frame.size.height ;
    
    /*
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        element = [self setIconCell:currentY iconFileName:@"side_icon_stats.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_STATS",nil) badge:0 selector:@selector(didStatsTap)] ;
        currentY += element.frame.size.height ;
    }
     */

    if([[ConsoleUtil getConsoleContents].appInfo.modified isEqualToString:@"1"]){
        element = [self setIconCell:currentY iconFileName:@"side_icon_submit.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_DEPLOY",nil) badge:0 selector:@selector(didDeployTap)] ;
        [element setTitleColor:[UIColor redColor]] ;
    } else {
        element = [self setIconCell:currentY iconFileName:@"side_icon_submit_off.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_DEPLOY",nil) badge:0 selector:@selector(didDeployTap)] ;
    }
    currentY += element.frame.size.height ;
    
    
    
    // for admin // TODO
    /*
    element = [self setIconCell:currentY iconFileName:@"side_icon_customize.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_DESIGN",nil) badge:0 selector:@selector(didCustomizeYourAppDesignTap)] ;
    currentY += element.frame.size.height ;
     */

    /*
#if TARGET_OS_SIMULATOR
    element = [self setIconCell:currentY iconFileName:@"side_icon_customize.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_DESIGN",nil) badge:0 selector:@selector(didCustomizeYourAppDesignTap)] ;
    currentY += element.frame.size.height ;
#endif
     */

    
    
    

    currentY += SIDE_MENU_LINE_MARGIN ;
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_helper.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_HELP",nil) badge:0 selector:@selector(didHelperTap)] ;
    currentY += element.frame.size.height ;
    
    element = [self setIconCell:currentY iconFileName:@"side_icon_faq.png" title:NSLocalizedString(@"SIDE_MENU_TITLE_FAQ",nil) badge:0 selector:@selector(didFaqTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += SIDE_MENU_LINE_MARGIN ;
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;

    /*
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_INFORMATION",nil) badge:0 selector:@selector(didInformationFromVeamTap)] ;
    currentY += element.frame.size.height ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_FAQ",nil) badge:0 selector:@selector(didFaqTap)] ;
    currentY += element.frame.size.height ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
    
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_ABOUT",nil) badge:0 selector:@selector(didAboutTap)] ;
    currentY += element.frame.size.height ;
    
    [self setMenuSeparator:currentY] ;
    currentY++ ;
     */
    
    element = [self setTextCell:currentY title:NSLocalizedString(@"SIDE_MENU_TITLE_SIGN_OUT",nil) badge:0 selector:@selector(didSignOutTap)] ;
    currentY += element.frame.size.height ;
    
    currentY += 100 ;
    
    CGFloat contentHeight = currentY ;
    if(contentHeight <= menuScrollView.frame.size.height){
        contentHeight = menuScrollView.frame.size.height + 1 ;
    }
    [menuScrollView setContentSize:CGSizeMake(menuScrollView.frame.size.width, contentHeight)] ;
}


- (void)setMenuSeparator:(CGFloat)y
{
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(SIDE_MENU_LEFT_MARGIN, y, SIDE_MENU_WIDTH-SIDE_MENU_LEFT_MARGIN-SIDE_MENU_RIGHT_MARGIN, 1)] ;
    [separatorView setBackgroundColor:[UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1.0]] ;
    if(menuScrollView != nil){
        [menuScrollView addSubview:separatorView] ;
    }
}

- (UIView *)setStatusCell:(CGFloat)y title:(NSString *)title titleColor:(UIColor *)titleColor ratio:(CGFloat)ratio leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor
{
    CGFloat statusWidth = 210 ;
    CGFloat statusHeight = 50 ;
    CGFloat statusX = (SIDE_MENU_WIDTH-statusWidth)/2 ;
    UIView *statusCell = [[UIView alloc] initWithFrame:CGRectMake(statusX, y, statusWidth, statusHeight)] ;
    [statusCell setBackgroundColor:rightColor] ;
    
    CGFloat maskWidth = statusWidth * ratio ;
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maskWidth, statusHeight)] ;
    [progressView setBackgroundColor:leftColor] ;
    [statusCell addSubview:progressView] ;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, statusWidth, statusHeight)] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [titleLabel setText:title] ;
    [titleLabel setTextColor:titleColor] ;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:18]] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [statusCell addSubview:titleLabel] ;
    
    [menuScrollView addSubview:statusCell] ;
    
    return statusCell ;
}

- (ConsoleSideMenuElementView *)setIconCell:(CGFloat)y iconFileName:(NSString *)iconFileName title:(NSString *)title badge:(NSInteger)badge selector:(SEL)selector
{
    ConsoleSideMenuElementView *element = [[ConsoleSideMenuElementView alloc] initWithFrame:CGRectMake(16, y, 220, 54)] ;
    [element setIconFileName:iconFileName title:title badge:badge] ;
    [VeamUtil registerTapAction:element target:self selector:selector] ;
    if(menuScrollView != nil){
        [menuScrollView addSubview:element] ;
    }
    
    
    return element ;
}

- (ConsoleSideMenuElementView *)setTextCell:(CGFloat)y title:(NSString *)title badge:(NSInteger)badge selector:(SEL)selector
{
    ConsoleSideMenuElementView *element = [[ConsoleSideMenuElementView alloc] initWithFrame:CGRectMake(16, y, 220, 54)] ;
    [element setTitle:title badge:badge] ;
    [VeamUtil registerTapAction:element target:self selector:selector] ;
    if(menuScrollView != nil){
        [menuScrollView addSubview:element] ;
    }
    return element ;
}

- (void)initialImageTap
{
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        CGRect imageFrame = initialImageView.frame ;
                        imageFrame.origin.x += SIDE_MENU_WIDTH ;
                        [initialImageView setFrame:imageFrame] ;
                        menuScrollView.transform = CGAffineTransformMakeScale(0.8, 0.8) ;
                    }
                    completion:^(BOOL finished) {
                        AppDelegate *appDelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate] ;
                        [appDelgate hideSideMenu] ;
                    }] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@::viewDidAppear",NSStringFromClass([self class])) ;
    [super viewDidAppear:animated];
    
    if(!animationDone){
        animationDone = YES ;
        [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            //NSLog(@"do animation") ;
                            CGRect imageFrame = initialImageView.frame ;
                            imageFrame.origin.x -= SIDE_MENU_WIDTH ;
                            [initialImageView setFrame:imageFrame] ;
                            menuScrollView.transform = CGAffineTransformMakeScale(1.0, 1.0) ;
                        }
                        completion:nil] ;
    }
    
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





- (void)showProgress
{
    //NSLog(@"%@::showProgress",NSStringFromClass([self class])) ;
    if(!progressView){
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
        [progressView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77000000"]] ;
        progressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
        progressIndicator.center = progressView.center ;
        [progressView addSubview:progressIndicator] ;
        [self.view addSubview:progressView] ;
    }
    
    [progressIndicator startAnimating] ;
    [progressView setAlpha:1.0] ;
}

- (void)hideProgress
{
    //NSLog(@"%@::hideProgress",NSStringFromClass([self class])) ;
    [progressView setAlpha:0.0] ;
    [progressIndicator stopAnimating] ;
}

- (void)contentsDidUpdate:(NSNotification *)notification
{
    [super contentsDidUpdate:notification] ;
    
    NSString *value = [[notification userInfo] objectForKey:@"ACTION"] ;
    if(![VeamUtil isEmpty:value] && [value isEqualToString:@"CONTENT_POST_DONE"]){
        NSString *apiName = [[notification userInfo] objectForKey:@"API_NAME"] ;
        if([apiName isEqualToString:@"app/submittomcn"]){
            //NSLog(@"submit finished") ;
            [self performSelectorOnMainThread:@selector(hideProgress) withObject:nil waitUntilDone:NO] ;
            NSArray *results = [[notification userInfo] objectForKey:@"RESULTS"] ;
            if(results){
                NSInteger count = [results count] ;
                if(count >= 1){
                    NSString *retValue = [results objectAtIndex:0] ;
                    if([retValue isEqualToString:@"OK"]){
                        [ConsoleUtil getConsoleContents].appInfo.status = VEAM_APP_INFO_STATUS_MCN_REVIEW ;
                        [self didHomeTap] ;
                    }
                }
            }
        } else if([apiName isEqualToString:@"app/deploycontents"]){
            //NSLog(@"deploy finished") ;
            [self performSelectorOnMainThread:@selector(hideProgress) withObject:nil waitUntilDone:NO] ;
            NSArray *results = [[notification userInfo] objectForKey:@"RESULTS"] ;
            if(results){
                //NSLog(@"results found") ;
                NSInteger count = [results count] ;
                if(count >= 1){
                    NSString *retValue = [results objectAtIndex:0] ;
                    if([retValue isEqualToString:@"OK"]){
                        //NSLog(@"OK") ;
                        [ConsoleUtil getConsoleContents].appInfo.modified = @"0" ;
                        //[self performSelectorOnMainThread:@selector(didHomeTap) withObject:nil waitUntilDone:NO] ;
                        //[VeamUtil dispMessage:@"Updated" title:@""] ;
                        [self initialImageTap] ;
                    } else if([retValue isEqualToString:@"NG"]){
                        NSString *message = [results objectAtIndex:1] ;
                        [VeamUtil dispError:message] ;
                    }
                }
            }
        }
    }
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
}


@end
