//
//  EmailLoginViewController.m
//  veam00000000
//
//  Created by veam on 12/22/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "VeamUtil.h"
#import "AppDelegate.h"

#define CONSOLE_TEXT_FIELD_EMAIL    1
#define CONSOLE_TEXT_FIELD_PASSWORD 2

@interface EmailLoginViewController ()

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"%@::viewDidLoad",NSStringFromClass([self class])) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
    
    
    isEmailEntered = NO ;
    isPasswordEntered = NO ;
    
    contentWidth = 285 ;
    contentHeight = 405 ;
    CGFloat loginButtonWidth = 239 ;
    CGFloat loginButtonHeight = 44 ;
    CGFloat fieldHeight = 40 ;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"email_background.png"] ;
    CGFloat imageWidth = backgroundImage.size.width / 2 ;
    CGFloat imageHeight = backgroundImage.size.height / 2 ;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([VeamUtil getScreenHeight] - imageHeight) / 2,imageWidth,imageHeight)] ;
    [backgroundImageView setImage:backgroundImage] ;
    [self.view addSubview:backgroundImageView] ;
    
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-contentWidth)/2, ([VeamUtil getScreenHeight]-contentHeight)/2, contentWidth, contentHeight)] ;
    [contentView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFFDFDFD"]] ;
    contentView.layer.cornerRadius = 6 ;
    contentView.layer.masksToBounds = YES ;
    [self.view addSubview:contentView] ;
    
    UIImage *backImage = [UIImage imageNamed:@"email_back.png"] ;
    imageWidth = backImage.size.width / 2 ;
    imageHeight = backImage.size.height / 2 ;
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)] ;
    [backImageView setImage:backImage] ;
    [contentView addSubview:backImageView] ;
    [VeamUtil registerTapAction:backImageView target:self selector:@selector(didBackButtonTap)] ;
    
    CGFloat currentY = 104 ;
    
    UIImage *topImage = [UIImage imageNamed:@"login_text_welcome.png"] ;
    imageWidth = topImage.size.width / 2 ;
    imageHeight = topImage.size.height / 2 ;
    CGRect frame = CGRectMake((contentWidth-imageWidth)/2, currentY, imageWidth, imageHeight) ;
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:frame] ;
    [topImageView setImage:topImage] ;
    [contentView addSubview:topImageView] ;
    
    currentY += imageHeight ;
    currentY += 17 ;
    
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2,currentY,loginButtonWidth,fieldHeight)] ;
    [emailField setTag:CONSOLE_TEXT_FIELD_EMAIL] ;
    [emailField setKeyboardType:UIKeyboardTypeEmailAddress] ;
    [emailField setReturnKeyType:UIReturnKeyDone] ;
    [emailField setDelegate:self] ;
    [emailField setEnabled:YES] ;
    [emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [emailField setBackgroundColor:[UIColor clearColor]] ;
    [emailField setTextAlignment:NSTextAlignmentLeft] ;
    [emailField setPlaceholder:@"Email"] ;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter] ;
    [emailField setTextColor:[VeamUtil getColorFromArgbString:@"FF818181"]] ;
    [emailField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [emailField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, fieldHeight)]] ; // padding view
    [emailField setLeftViewMode:UITextFieldViewModeAlways] ;
    emailField.layer.borderColor = [VeamUtil getColorFromArgbString:@"FF535353"].CGColor ;
    emailField.layer.borderWidth = 0.5 ;
    [contentView addSubview:emailField] ;
    
    currentY += fieldHeight ;
    currentY += 8 ;
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2,currentY,loginButtonWidth,fieldHeight)] ;
    [passwordField setTag:CONSOLE_TEXT_FIELD_PASSWORD] ;
    [passwordField setSecureTextEntry:YES] ;
    [passwordField setReturnKeyType:UIReturnKeyDone] ;
    [passwordField setDelegate:self] ;
    [passwordField setEnabled:YES] ;
    [passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [passwordField setBackgroundColor:[UIColor clearColor]] ;
    [passwordField setTextAlignment:NSTextAlignmentLeft] ;
    [passwordField setPlaceholder:@"Password"] ;
    [passwordField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter] ;
    [passwordField setTextColor:[VeamUtil getColorFromArgbString:@"FF818181"]] ;
    [passwordField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    //[passwordField setFont:[UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:18]] ;
    [passwordField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, fieldHeight)]] ; // padding view
    [passwordField setLeftViewMode:UITextFieldViewModeAlways] ;
    passwordField.layer.borderColor = [VeamUtil getColorFromArgbString:@"FF535353"].CGColor ;
    passwordField.layer.borderWidth = 0.5 ;
    [contentView addSubview:passwordField] ;
    
    
    currentY += fieldHeight ;
    currentY += 8 ;
    
    loginButtonView = [[UIView alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2, currentY, loginButtonWidth, loginButtonHeight)] ;
    [loginButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFF0F0F0"]] ;
    [contentView addSubview:loginButtonView] ;
    
    loginImageGray = [UIImage imageNamed:@"login_text_login_gray.png"] ;
    loginImageWhite = [UIImage imageNamed:@"login_text_login_white.png"] ;
    imageWidth = loginImageGray.size.width / 2 ;
    imageHeight = loginImageGray.size.height / 2 ;
    loginImageView = [[UIImageView alloc] initWithFrame:CGRectMake((loginButtonWidth-imageWidth)/2, (loginButtonHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [loginImageView setImage:loginImageGray] ;
    [loginButtonView addSubview:loginImageView] ;
    [VeamUtil registerTapAction:loginButtonView target:self selector:@selector(didLoginButtonTap)] ;
    
    currentY += loginButtonHeight ;
    currentY += 33 ;
    
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"forgot_password",nil) attributes:underlineAttribute] ;
    UILabel *forgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, contentWidth, 10)] ;
    [forgetLabel setAttributedText:attributedString] ;
    [forgetLabel setTextColor:[UIColor blackColor]] ;
    [forgetLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9]] ;
    [forgetLabel setTextAlignment:NSTextAlignmentCenter] ;
    [contentView addSubview:forgetLabel] ;
    [VeamUtil registerTapAction:forgetLabel target:self selector:@selector(didForgotButtonTap)] ;
    
}

- (void)updateLoginButton
{
    if(isEmailEntered && isPasswordEntered){
        [loginImageView setImage:loginImageWhite] ;
        [loginButtonView setBackgroundColor:[UIColor redColor]] ;
    } else {
        [loginImageView setImage:loginImageGray] ;
        [loginButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFF0F0F0"]] ;
    }
}

- (void)didLoginButtonTap
{
    //NSLog(@"didLoginButtonTap") ;
    NSString *email = emailField.text ;
    NSString *password = passwordField.text ;
    if(![VeamUtil isEmpty:email] && ![VeamUtil isEmpty:password]){
        //NSLog(@"email:%@",email) ;
        [self sendUserNameAndPassword] ;
    }
}

- (void)didForgotButtonTap
{
    //NSLog(@"didForgotButtonTap") ;
    NSString *email = emailField.text ;
    if([VeamUtil isEmpty:email]){
        //NSLog(@"email:%@",email) ;
        [VeamUtil dispError:NSLocalizedString(@"please_enter_your_mail_address",nil)] ;
    } else {
        resetAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"confirmation",nil) message:NSLocalizedString(@"reset_the_password",nil)
                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil];
        [resetAlertView show];
    }
}


-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if(alertView == resetAlertView){
        if(buttonIndex == 1){
            //NSLog(@"sentResetPassword") ;
            [self sendResetPassword] ;
        }
    }
}



- (void)sendResetPassword
{
    [self showMask:YES] ;
    [self performSelectorInBackground:@selector(doSendResetPassword) withObject:nil] ;
}

- (void)doSendResetPassword
{
    @autoreleasepool
    {
        
        NSString *email = emailField.text ;
        NSURL *url = [VeamUtil getApiUrl:@"email/resetpassword"] ;
        
        NSURLResponse *response = nil ;
        NSError *error = nil;
        
        NSString *encodedEmail = [VeamUtil urlEncode:email] ;
        NSString *uid = [VeamUtil getUid] ;
        
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%@",uid,email]] ;
        NSString *params ;
        params = [NSString stringWithFormat:@"u=%@&e=%@&o=i&l=%@&s=%@",uid,encodedEmail,[VeamUtil getLanguageId],signature] ;
        
        //NSLog(@"params=%@",params) ;
        NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
        [request setHTTPMethod: @"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setHTTPBody: myRequestData];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0<[error_str length]) {
            UIAlertView *alert = [
                                  [UIAlertView alloc]
                                  initWithTitle : @"Login Error"
                                  message : error_str
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil
                                  ];
            [alert show];
            return ;
        }
        
        
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        //NSLog(@"results=%@",resultString) ;
        
        NSArray *results = [resultString componentsSeparatedByString:@"\n"];
        //NSLog(@"count=%d",[results count]) ;
        int count = [results count] ;
        if(count > 0){
            NSString *code = [results objectAtIndex:0] ;
            if([code compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
                if(count >= 3){
                    messageTitle = [results objectAtIndex:1] ;
                    messageBody = [results objectAtIndex:2] ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                } else {
                    messageTitle = @"Error" ;
                    messageBody = @"Failed to reset" ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                }
            } else if([code isEqual:@"ERROR_MESSAGE"]){
                if(count >= 2){
                    messageTitle = @"Error" ;
                    messageBody = [results objectAtIndex:1] ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                } else {
                    messageTitle = @"Error" ;
                    messageBody = @"Failed to reset" ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                }
            } else {
                for(int index = 0 ; index < count ; index++){
                    //NSLog(@"%@",[results objectAtIndex:index]) ;
                }
                messageTitle = @"Error" ;
                messageBody = @"Failed to reset" ;
                [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
            }
        }
    }
}


- (void)showMessage
{
    [self showMask:NO] ;
    UIAlertView *alert = [
                          [UIAlertView alloc]
                          initWithTitle : messageTitle
                          message : messageBody
                          delegate : self
                          cancelButtonTitle : @"OK"
                          otherButtonTitles : nil
                          ];
    [alert show];
}







- (void)sendUserNameAndPassword
{
    /*
    NSString *userName = emailField.text ;
    NSString *password = passwordField.text ;
    
    //[VeamUtil setUserDefaultString:USERDEFAULT_KEY_EMAIL_USER_NAME value:userName] ;
    //[VeamUtil setUserDefaultString:USERDEFAULT_KEY_EMAIL_PASSWORD value:password] ;
    //[VeamUtil setUserDefaultString:VEAM_CONSOLE_KEY_USER_PRIVILAGES value:@"0"] ;
    
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
    */
    
    [self showMask:YES] ;
    [self performSelectorInBackground:@selector(doPost) withObject:nil] ;
}

- (void)doPost
{
    @autoreleasepool
    {
        
        NSString *email = emailField.text ;
        NSString *password = passwordField.text ;
        NSURL *url = [VeamUtil getApiUrl:@"email/login"] ;
        
        NSURLResponse *response = nil ;
        NSError *error = nil;
        
        NSString *encodedEmail = [VeamUtil urlEncode:email] ;
        NSString *encodedPassword = [VeamUtil urlEncode:password] ;
        NSString *uid = [VeamUtil getUid] ;
        
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%@",uid,email]] ;
        NSString *params ;
        params = [NSString stringWithFormat:@"u=%@&e=%@&p=%@&o=i&l=%@&s=%@",uid,encodedEmail,encodedPassword,[VeamUtil getLanguageId],signature] ;
        
        //NSLog(@"params=%@",params) ;
        NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
        [request setHTTPMethod: @"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setHTTPBody: myRequestData];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0<[error_str length]) {
            UIAlertView *alert = [
                                  [UIAlertView alloc]
                                  initWithTitle : @"Login Error"
                                  message : error_str
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil
                                  ];
            [alert show];
            return ;
        }
        
        
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        //NSLog(@"results=%@",resultString) ;
        
        NSInteger socialUserId = 0 ;
        NSString *socialUserIdString = nil ;
        NSArray *results = [resultString componentsSeparatedByString:@"\n"];
        //NSLog(@"count=%d",[results count]) ;
        int count = [results count] ;
        if(count > 0){
            NSString *code = [results objectAtIndex:0] ;
            if([code compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
                if(count >= 4){
                    emailUserId = [results objectAtIndex:1] ;
                    userName = [results objectAtIndex:2] ;
                    secret = [results objectAtIndex:3] ;
                    [self performSelectorOnMainThread:@selector(loginSuccess) withObject:nil waitUntilDone:NO] ;
                } else {
                    [self performSelectorOnMainThread:@selector(loginFailed:) withObject:@"Failed to Login" waitUntilDone:NO] ;
                }
            } else if([code isEqual:@"ERROR_MESSAGE"]){
                if(count >= 2){
                    [self performSelectorOnMainThread:@selector(loginFailed:) withObject:[results objectAtIndex:1] waitUntilDone:NO] ;
                } else {
                    [self performSelectorOnMainThread:@selector(loginFailed:) withObject:@"Failed to Login" waitUntilDone:NO] ;
                }
            } else {
                for(int index = 0 ; index < count ; index++){
                    //NSLog(@"%@",[results objectAtIndex:index]) ;
                }
                [self performSelectorOnMainThread:@selector(loginFailed:) withObject:@"Failed to Login" waitUntilDone:NO] ;
            }
        }
    }
}

- (void)loginSuccess
{
    //NSLog(@"loginSuccess appId=%@ mcnId=%@",[VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_APP_ID],[VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_MCN_ID]) ;
    //- (void)emailSessionOpen:(NSString *)emailUserId name:(NSString *)name secret:(NSString *)secret
    [[AppDelegate sharedInstance] emailSessionOpen:emailUserId name:userName secret:secret] ;
    [self showMask:NO] ;
    [[AppDelegate sharedInstance] backFromEmailLogin] ;
    //[VeamUtil showTabBarController:-1] ;
}

- (void)loginFailed:(NSString *)message
{
    //NSLog(@"loginFailed:%@",message) ;
    [self showMask:NO] ;
    [VeamUtil dispError:message] ;
}

- (void)showMask:(BOOL)show
{
    if(show){
        if(maskView == nil){
            maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
            [maskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"55000000"]] ;
            [self.view addSubview:maskView] ;
            maskIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
            CGRect frame = maskIndicator.frame ;
            frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
            frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
            [maskIndicator setFrame:frame] ;
            [maskView addSubview:maskIndicator] ;
        }
        [maskIndicator startAnimating] ;
        [maskView setAlpha:1.0] ;
    } else {
        [maskView setAlpha:0.0] ;
        [maskIndicator stopAnimating] ;
    }
}




- (void)didForgetButtonTap
{
    //NSLog(@"didSignupButtonTap") ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードを隠す
    [textField resignFirstResponder] ;
    return YES ;
}

- (void) keyboardWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo] ;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size ;
    
    //NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width) ;
    
    // move the view up by 30 pts
    
    CGRect frame = contentView.frame ;
    frame.origin.y = ([VeamUtil getScreenHeight]-kbSize.height-frame.size.height) / 2 ;
    [UIView animateWithDuration:0.3 animations:^{
        [contentView setFrame:frame] ;
    }];
}

- (void) keyboardWillHide:(NSNotification *)note
{
    
    // move the view back to the origin
    CGRect frame = contentView.frame ;
    frame.origin.y = ([VeamUtil getScreenHeight]-frame.size.height) / 2 ;
    [UIView animateWithDuration:0.3 animations:^{
        [contentView setFrame:frame] ;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%@::shouldChangeCharactersInRange string=%@ range le=%d lo=%d",NSStringFromClass([self class]),string,range.length,range.location) ;
    if((range.location == 0) && [VeamUtil isEmpty:string]){
        if(textField.tag == CONSOLE_TEXT_FIELD_EMAIL){
            isEmailEntered = NO ;
        } else {
            isPasswordEntered = NO ;
        }
    } else {
        if(textField.tag == CONSOLE_TEXT_FIELD_EMAIL){
            isEmailEntered = YES ;
        } else {
            isPasswordEntered = YES ;
        }
    }
    [self performSelectorOnMainThread:@selector(updateLoginButton) withObject:nil waitUntilDone:NO] ;
    return YES ;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didBackButtonTap
{
    //NSLog(@"didBackButtonTap") ;
    if(self.navigationController != nil){
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    //[VeamUtil showTabBarController:-1] ;
}


@end
