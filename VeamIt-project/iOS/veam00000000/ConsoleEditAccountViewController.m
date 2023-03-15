//
//  ConsoleEditAccountViewController.m
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditAccountViewController.h"
#import "ConsolePostData.h"
#import "VeamUtil.h"
#import "AppDelegate.h"

#define CONSOLE_VIEW_EMAIL              1
#define CONSOLE_VIEW_PASSWORD           2

@interface ConsoleEditAccountViewController ()

@end

@implementation ConsoleEditAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //[self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE|VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT] ;
        [self setHeaderRightText:@"Login"] ;
        //[self setHeaderTitle:@"YouTube Basic Settings"] ;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat currentY = [self addMainScrollView] ;
    currentY = [self addContents:currentY] ;
    [self setScrollHeight:currentY] ;
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

- (CGFloat)addContents:(CGFloat)y
{
    CGFloat currentY = y ;
    
    currentY += [self addSectionHeader:@"Account" y:currentY] ;
    
    emailInputBarView = [self addTextInputBar:@"Email" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_EMAIL] ;
    [emailInputBarView setDelegate:self] ;
    currentY += emailInputBarView.frame.size.height ;
    
    passwordInputBarView = [self addTextInputBar:@"Password" y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_PASSWORD] ;
    [passwordInputBarView setDelegate:self] ;
    currentY += passwordInputBarView.frame.size.height ;
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    NSString *email = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
    NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;
    
    [emailInputBarView setInputValue:email] ;
    [passwordInputBarView setInputValue:password] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)didChangeTextInputValue:(ConsoleTextInputBarView *)view value:(NSString *)value
{
}

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_USERNAME value:[emailInputBarView getInputValue]] ;
    [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD value:[passwordInputBarView getInputValue]] ;
    [self loginConsole] ;
}

- (void)loginConsole
{
    NSString *consoleDeviceToken = [VeamUtil getUserDefaultString:@"CONSOLE_DEVICE_TOKEN"] ;
    if([VeamUtil isEmpty:consoleDeviceToken]){
        consoleDeviceToken = @"" ;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME],@"u",
                            [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD],@"p",
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
                    if(count >= 3){
                        [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_APP_ID value:[results objectAtIndex:1]] ;
                        [VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_APP_SECRET value:[results objectAtIndex:2]] ;
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
    [self popViewController] ;
}

- (void)loginFailed:(NSString *)message
{
    //NSLog(@"loginFailed:%@",message) ;
    [self showMask:NO] ;
    [VeamUtil dispError:message] ;
}



@end
