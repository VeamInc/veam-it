//
//  ConsoleStarterLoginViewController.m
//  veam00000000
//
//  Created by veam on 9/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterLoginViewController.h"
#import "VeamUtil.h"
#import "ConsolePostData.h"
#import "AppDelegate.h"
#import "ConsoleUtil.h"
#import "ConsoleHomeViewController.h"


#define USER_NAME_FIELD_HEIGHT 37
#define USER_NAME_FIELD_MARGIN 30

@interface ConsoleStarterLoginViewController ()

@end

@implementation ConsoleStarterLoginViewController

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
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)] ;
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert) categories:nil] ;
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting] ;
        [[UIApplication sharedApplication] registerForRemoteNotifications] ;
    } else {
        // use registerForRemoteNotifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)] ;
    }
    
    
    [ConsoleUtil clearPreviewData] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
    
    CGFloat inputViewHeight = USER_NAME_FIELD_HEIGHT * 3 ;
    inputView = [[UIView alloc] initWithFrame:CGRectMake(USER_NAME_FIELD_MARGIN, ([VeamUtil getScreenHeight]-inputViewHeight)/2, [VeamUtil getScreenWidth]-USER_NAME_FIELD_MARGIN*2, inputViewHeight)] ;
    
    UIColor *color = [VeamUtil getColorFromArgbString:@"FF6D6D6D"] ;
    
    NSString *placeholderText = @" User Name" ;
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0,0,inputView.frame.size.width,USER_NAME_FIELD_HEIGHT)] ;
    [userNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [userNameField setKeyboardType:UIKeyboardTypeEmailAddress] ;
    [userNameField setTextColor:color] ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [userNameField setTintColor:color] ;
    }
    [userNameField setReturnKeyType:UIReturnKeyDone] ;
    [userNameField setDelegate:self] ;
    [userNameField setEnabled:YES] ;
    if([userNameField respondsToSelector:@selector(setAttributedPlaceholder:)]){
        userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}] ;
    } else {
        [userNameField setPlaceholder:placeholderText] ;
    }
    [userNameField setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]] ;
    [inputView addSubview:userNameField] ;
    
    UIView *underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, userNameField.frame.size.height, inputView.frame.size.width, 1)] ;
    [underLineView setBackgroundColor:color] ;
    [inputView addSubview:underLineView] ;
    
    
    
    
    placeholderText = @" Password" ;
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0,USER_NAME_FIELD_HEIGHT*2,inputView.frame.size.width,USER_NAME_FIELD_HEIGHT)] ;
    [passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [passwordField setSecureTextEntry:YES] ;
    [passwordField setTextColor:color] ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [passwordField setTintColor:color] ;
    }
    [passwordField setReturnKeyType:UIReturnKeyDone] ;
    [passwordField setDelegate:self] ;
    if([passwordField respondsToSelector:@selector(setAttributedPlaceholder:)]){
        passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}] ;
    } else {
        [passwordField setPlaceholder:placeholderText] ;
    }
    [passwordField setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]] ;
    [inputView addSubview:passwordField] ;
    
    underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, passwordField.frame.origin.y + passwordField.frame.size.height, inputView.frame.size.width, 1)] ;
    [underLineView setBackgroundColor:color] ;
    [inputView addSubview:underLineView] ;
    

    
    [self.view addSubview:inputView] ;
    
    
    [self showHeader:@"" backgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;

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






- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードを隠す
    [userNameField resignFirstResponder] ;
    return YES ;
    
}

- (void) keyboardWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo] ;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size ;
    
    //NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width) ;
    
    // move the view up by 30 pts
    
    CGRect frame = inputView.frame ;
    frame.origin.y = ([VeamUtil getScreenHeight]-kbSize.height-frame.size.height) / 2 ;
    [UIView animateWithDuration:0.3 animations:^{
        [inputView setFrame:frame] ;
    }];
}

- (void) keyboardWillHide:(NSNotification *)note
{
    
    // move the view back to the origin
    CGRect frame = inputView.frame ;
    frame.origin.y = ([VeamUtil getScreenHeight]-frame.size.height) / 2 ;
    [UIView animateWithDuration:0.3 animations:^{
        [inputView setFrame:frame] ;
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"viewDidDisappear") ;
    [super viewDidDisappear:animated] ;
    
    [headerView setAlpha:1.0] ;
    [inputView setAlpha:1.0] ;
}

- (void)didHeaderNextTap
{
    //NSLog(@"%@::didHeaderNextTap",NSStringFromClass([self class])) ;

    NSString *userName = userNameField.text ;
    if(![VeamUtil isEmpty:userName]){
        //NSLog(@"userName:%@",userName) ;
        [self sendUserNameAndPassword] ;
    }
}


- (void)sendUserNameAndPassword
{
    NSString *userName = userNameField.text ;
    NSString *password = passwordField.text ;
    
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_USERNAME value:userName] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD value:password] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_USER_PRIVILAGES value:@"0"] ;
    
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
    [self showMask:YES] ;
    [self performSelectorInBackground:@selector(doPost:) withObject:postData] ;
}

- (void)doPost:(ConsolePostData *)postData
{
    @autoreleasepool
    {
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
                        //NSLog(@"user privilages=%@",[results objectAtIndex:3]) ;
                        [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_MCN_ID value:[results objectAtIndex:4]] ;
                        [[AppDelegate sharedInstance] updateConsoleContents] ;
                        [ConsoleUtil postContentsUpdateNotification] ;
                        [self performSelectorOnMainThread:@selector(loginSuccess) withObject:nil waitUntilDone:NO] ;
                    } else {
                        [self performSelectorOnMainThread:@selector(loginFailed:) withObject:@"Failed to Login" waitUntilDone:NO] ;
                    }
                } if([code isEqual:@"ERROR_MESSAGE"]){
                    if(count >= 2){
                        [self performSelectorOnMainThread:@selector(loginFailed:) withObject:[results objectAtIndex:1] waitUntilDone:NO] ;
                    } else {
                        [self performSelectorOnMainThread:@selector(loginFailed:) withObject:@"Failed to Login" waitUntilDone:NO] ;
                    }
                }
            }
        } else {
            [self performSelectorOnMainThread:@selector(loginFailed:) withObject:@"Failed to Login" waitUntilDone:NO] ;
        }
    }
}

- (void)loginSuccess
{
    //NSLog(@"loginSuccess appId=%@",[VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_APP_ID]) ;
    [self showMask:NO] ;
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *appStatus = contents.appInfo.status ;
    if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_INITIALIZED]){
        ConsoleHomeViewController *homeViewController = [[ConsoleHomeViewController alloc] init] ;
        [homeViewController setMode:VEAM_CONSOLE_HOME_MODE_NOT_INSTALLED] ;
        [self.navigationController pushViewController:homeViewController animated:NO] ;
    } else {
        AlternativeImage *alternativeImage = [contents getAlternativeImageForFileName:@"c_veam_icon.png"] ;
        UIImage *iconImage = [VeamUtil getCachedImage:alternativeImage.url downloadIfNot:YES] ;
        
        ConsoleHomeViewController *homeViewController = [[ConsoleHomeViewController alloc] init] ;
        [homeViewController setMode:VEAM_CONSOLE_HOME_MODE_INSTALLING] ;
        [homeViewController setWithoutCountDown:YES] ;
        [homeViewController setTargetIconImage:iconImage] ;
        [self.navigationController pushViewController:homeViewController animated:NO] ;
    }
}

- (void)loginFailed:(NSString *)message
{
    //NSLog(@"loginFailed:%@",message) ;
    [self showMask:NO] ;
    [VeamUtil dispError:message] ;
}






@end
