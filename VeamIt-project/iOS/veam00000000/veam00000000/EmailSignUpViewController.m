//
//  EmailSignUpViewController.m
//  veam00000000
//
//  Created by veam on 12/26/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "EmailSignUpViewController.h"
#import "VeamUtil.h"
#import "AppDelegate.h"

#define CONSOLE_TEXT_FIELD_EMAIL            1
#define CONSOLE_TEXT_FIELD_PASSWORD         2
#define CONSOLE_TEXT_FIELD_FIRST_NAME       3
#define CONSOLE_TEXT_FIELD_LAST_NAME        4
#define CONSOLE_TEXT_FIELD_POFILE_PICTURE   5


@interface EmailSignUpViewController ()

@end

@implementation EmailSignUpViewController

@synthesize displayWidth ;
@synthesize displayHeight ;
@synthesize cropWidth ;
@synthesize cropHeight ;

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
    
    self.displayWidth = 300 ;
    self.displayHeight = 300 ;
    self.cropWidth = 160 ;
    self.cropHeight = 160 ;
    
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
    
    CGFloat currentY = 45 ;
    
    UIImage *topImage = [UIImage imageNamed:@"login_text_signup_red.png"] ;
    imageWidth = topImage.size.width / 2 ;
    imageHeight = topImage.size.height / 2 ;
    CGRect frame = CGRectMake((contentWidth-imageWidth)/2, currentY, imageWidth, imageHeight) ;
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:frame] ;
    [topImageView setImage:topImage] ;
    [contentView addSubview:topImageView] ;
    
    currentY += imageHeight ;
    
    CGFloat descriptionHeight = 40 ;
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, contentWidth, descriptionHeight)] ;
    [description setText:NSLocalizedString(@"sign_up_with_an_email_address",nil)] ;
    [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
    [description setTextAlignment:NSTextAlignmentCenter] ;
    [description setTextColor:[VeamUtil getColorFromArgbString:@"FF818181"]] ;
    [contentView addSubview:description] ;
    
    currentY += descriptionHeight ;
    
    
    firstNameField = [[UITextField alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2,currentY,loginButtonWidth/2,fieldHeight)] ;
    [firstNameField setTag:CONSOLE_TEXT_FIELD_FIRST_NAME] ;
    [firstNameField setKeyboardType:UIKeyboardTypeAlphabet] ;
    [firstNameField setReturnKeyType:UIReturnKeyDone] ;
    [firstNameField setDelegate:self] ;
    [firstNameField setEnabled:YES] ;
    [firstNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [firstNameField setBackgroundColor:[UIColor clearColor]] ;
    [firstNameField setTextAlignment:NSTextAlignmentLeft] ;
    [firstNameField setPlaceholder:NSLocalizedString(@"first_name",nil)] ;
    [firstNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter] ;
    [firstNameField setTextColor:[VeamUtil getColorFromArgbString:@"FF818181"]] ;
    [firstNameField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [firstNameField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, fieldHeight)]] ; // padding view
    [firstNameField setLeftViewMode:UITextFieldViewModeAlways] ;
    firstNameField.layer.borderColor = [VeamUtil getColorFromArgbString:@"FF535353"].CGColor ;
    firstNameField.layer.borderWidth = 0.5 ;
    [contentView addSubview:firstNameField] ;
    
    lastNameField = [[UITextField alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2+loginButtonWidth/2,currentY,loginButtonWidth/2,fieldHeight)] ;
    [lastNameField setTag:CONSOLE_TEXT_FIELD_LAST_NAME] ;
    [lastNameField setKeyboardType:UIKeyboardTypeAlphabet] ;
    [lastNameField setReturnKeyType:UIReturnKeyDone] ;
    [lastNameField setDelegate:self] ;
    [lastNameField setEnabled:YES] ;
    [lastNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [lastNameField setBackgroundColor:[UIColor clearColor]] ;
    [lastNameField setTextAlignment:NSTextAlignmentLeft] ;
    [lastNameField setPlaceholder:NSLocalizedString(@"last_name",nil)] ;
    [lastNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter] ;
    [lastNameField setTextColor:[VeamUtil getColorFromArgbString:@"FF818181"]] ;
    [lastNameField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [lastNameField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, fieldHeight)]] ; // padding view
    [lastNameField setLeftViewMode:UITextFieldViewModeAlways] ;
    lastNameField.layer.borderColor = [VeamUtil getColorFromArgbString:@"FF535353"].CGColor ;
    lastNameField.layer.borderWidth = 0.5 ;
    [contentView addSubview:lastNameField] ;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2+loginButtonWidth/2,currentY+1,1,fieldHeight-2)] ;
    [whiteView setBackgroundColor:[UIColor whiteColor]] ;
    [contentView addSubview:whiteView] ;
    

    currentY += fieldHeight ;
    currentY += 8 ;
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2,currentY,loginButtonWidth,fieldHeight)] ;
    [emailField setTag:CONSOLE_TEXT_FIELD_EMAIL] ;
    [emailField setKeyboardType:UIKeyboardTypeEmailAddress] ;
    [emailField setReturnKeyType:UIReturnKeyDone] ;
    [emailField setDelegate:self] ;
    [emailField setEnabled:YES] ;
    [emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [emailField setBackgroundColor:[UIColor clearColor]] ;
    [emailField setTextAlignment:NSTextAlignmentLeft] ;
    [emailField setPlaceholder:NSLocalizedString(@"email",nil)] ;
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
    [passwordField setPlaceholder:NSLocalizedString(@"password",nil)] ;
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
    
    profilePictureField = [[UIView alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2,currentY,loginButtonWidth,fieldHeight)] ;
    [profilePictureField setTag:CONSOLE_TEXT_FIELD_POFILE_PICTURE] ;
    [profilePictureField setBackgroundColor:[UIColor clearColor]] ;
    profilePictureField.layer.borderColor = [VeamUtil getColorFromArgbString:@"FF535353"].CGColor ;
    profilePictureField.layer.borderWidth = 0.5 ;
    [VeamUtil registerTapAction:profilePictureField target:self selector:@selector(didProfilePictureTap)] ;
    [contentView addSubview:profilePictureField] ;
    
    profilePictureLabel = [[UILabel alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2+5,currentY,loginButtonWidth,fieldHeight)] ;
    [profilePictureLabel setTag:CONSOLE_TEXT_FIELD_POFILE_PICTURE] ;
    [profilePictureLabel setBackgroundColor:[UIColor clearColor]] ;
    [profilePictureLabel setTextAlignment:NSTextAlignmentLeft] ;
    [profilePictureLabel setText:NSLocalizedString(@"profile_picture",nil)] ;
    [profilePictureLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFCCCCCC"]] ;
    [profilePictureLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [contentView addSubview:profilePictureLabel] ;
    
    
    currentY += fieldHeight ;
    currentY += 8 ;
    
    createButtonView = [[UILabel alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2, currentY, loginButtonWidth, loginButtonHeight)] ;
    [createButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFF0F0F0"]] ;
    [createButtonView setText:NSLocalizedString(@"create_account",nil)] ;
    [createButtonView setTextAlignment:NSTextAlignmentCenter] ;
    [createButtonView setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]] ;
    [createButtonView setTextColor:[VeamUtil getColorFromArgbString:@"FFCACACA"]] ;
    [contentView addSubview:createButtonView] ;
    [VeamUtil registerTapAction:createButtonView target:self selector:@selector(didCreateButtonTap)] ;
    
    /*
    loginImageGray = [UIImage imageNamed:@"login_text_signup_gray.png"] ;
    loginImageWhite = [UIImage imageNamed:@"login_text_login_white.png"] ;
    imageWidth = loginImageGray.size.width / 2 ;
    imageHeight = loginImageGray.size.height / 2 ;
    loginImageView = [[UIImageView alloc] initWithFrame:CGRectMake((loginButtonWidth-imageWidth)/2, (loginButtonHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [loginImageView setImage:loginImageGray] ;
    [loginButtonView addSubview:loginImageView] ;
    [VeamUtil registerTapAction:loginButtonView target:self selector:@selector(didLoginButtonTap)] ;
     */
    
    currentY += loginButtonHeight ;
    currentY += 33 ;
    
    
    /*
     NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
     NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Forgot password?" attributes:underlineAttribute] ;
     UILabel *forgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, contentWidth, 10)] ;
     [forgetLabel setAttributedText:attributedString] ;
     [forgetLabel setTextColor:[UIColor blackColor]] ;
     [forgetLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9]] ;
     [forgetLabel setTextAlignment:NSTextAlignmentCenter] ;
     [contentView addSubview:forgetLabel] ;
     */
    
}

- (void)updateLoginButton
{
    if(isEmailEntered && isPasswordEntered && isFirstNameEntered && isLastNameEntered && isProfilePictureEntered){
        //[loginImageView setImage:loginImageWhite] ;
        [createButtonView setBackgroundColor:[UIColor redColor]] ;
        [createButtonView setTextColor:[UIColor whiteColor]] ;
    } else {
        //[loginImageView setImage:loginImageGray] ;
        [createButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFF0F0F0"]] ;
        [createButtonView setTextColor:[VeamUtil getColorFromArgbString:@"FFCACACA"]] ;
    }
}

- (void)didCreateButtonTap
{
    //NSLog(@"didLoginButtonTap") ;
    NSString *firstName = firstNameField.text ;
    NSString *lastName = lastNameField.text ;
    NSString *email = emailField.text ;
    NSString *password = passwordField.text ;
    
    if(![VeamUtil isEmpty:password] && [password length] < 8){
        [VeamUtil dispError:NSLocalizedString(@"your_password_must_be_at_least_8_characters_long",nil)] ;
        return ;
    }
    
    if(![VeamUtil isEmpty:email] &&
       ![VeamUtil isEmpty:password] &&
       ![VeamUtil isEmpty:firstName] &&
       ![VeamUtil isEmpty:lastName] &&
       isProfilePictureEntered
       ){
        [self sendUserNameAndPassword] ;
    }
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
        NSString *firstName = firstNameField.text ;
        NSString *lastName = lastNameField.text ;
        NSString *email = emailField.text ;
        NSString *password = passwordField.text ;
        NSURL *url = [VeamUtil getApiUrl:@"email/create"] ;
        NSString *uid = [VeamUtil getUid] ;
        
        NSURLResponse *response = nil ;
        NSError *error = nil;
        
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%@_%@_%@",uid,email,firstName,lastName]] ;

        
        NSString *encodedFirstName = [VeamUtil urlEncode:firstName] ;
        NSString *encodedLastName = [VeamUtil urlEncode:lastName] ;
        NSString *encodedEmail = [VeamUtil urlEncode:email] ;
        NSString *encodedPassword = [VeamUtil urlEncode:password] ;

        /*
        NSString *params ;
        params = [NSString stringWithFormat:@"u=%@&e=%@&p=%@&fn=%@&ln=%@&o=i&l=%@&s=%@",uid,encodedEmail,encodedPassword,encodedFirstName,encodedLastName,[VeamUtil getLanguageId],signature] ;
        
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
                                  initWithTitle : @"Network Error"
                                  message : error_str
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil
                                  ];
            [alert show];
            return ;
        }
        */
        
        
        
        
        
        
        
        
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url] ;
        [request setHTTPMethod: @"POST"] ;
        NSString *boundary = @"0x0hHai1CanHazB0undar135" ;
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] ;
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
        NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.95);
        
        NSMutableData *body = [NSMutableData data];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:[uid dataUsingEncoding:NSUTF8StringEncoding] forKey:@"u"];
        [params setObject:[email dataUsingEncoding:NSUTF8StringEncoding] forKey:@"e"];
        [params setObject:[password  dataUsingEncoding:NSUTF8StringEncoding] forKey:@"p"];
        [params setObject:[firstName  dataUsingEncoding:NSUTF8StringEncoding] forKey:@"fn"];
        [params setObject:[lastName  dataUsingEncoding:NSUTF8StringEncoding] forKey:@"ln"];
        [params setObject:[@"i" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"o"];
        [params setObject:[[VeamUtil getLanguageId] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"l"];
        [params setObject:[signature  dataUsingEncoding:NSUTF8StringEncoding] forKey:@"s"];
        
        for (id key in params) {
            NSData *value = [params objectForKey:key];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]] ;
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:value];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
            
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0<[error_str length]) {
            UIAlertView *alert = [
                                  [UIAlertView alloc]
                                  initWithTitle : @"Network Error"
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
                    shouldBackScreen = YES ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                } else {
                    messageTitle = @"Error" ;
                    messageBody = @"Failed to create" ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                }
            } else if([code isEqual:@"ERROR_MESSAGE"]){
                if(count >= 3){
                    messageTitle = [results objectAtIndex:1] ;
                    messageBody = [results objectAtIndex:2] ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                } else {
                    messageTitle = @"Error" ;
                    messageBody = @"Failed to create" ;
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO] ;
                }
            } else {
                for(int index = 0 ; index < count ; index++){
                    //NSLog(@"%@",[results objectAtIndex:index]) ;
                }
                messageTitle = @"Error" ;
                messageBody = @"Failed to create" ;
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

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if(shouldBackScreen){
        [self didBackButtonTap] ;
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
        } else if(textField.tag == CONSOLE_TEXT_FIELD_PASSWORD){
            isPasswordEntered = NO ;
        } else if(textField.tag == CONSOLE_TEXT_FIELD_FIRST_NAME){
            isFirstNameEntered = NO ;
        } else if(textField.tag == CONSOLE_TEXT_FIELD_LAST_NAME){
            isLastNameEntered = NO ;
        }
    } else {
        if(textField.tag == CONSOLE_TEXT_FIELD_EMAIL){
            isEmailEntered = YES ;
        } else if(textField.tag == CONSOLE_TEXT_FIELD_PASSWORD){
            isPasswordEntered = YES ;
        } else if(textField.tag == CONSOLE_TEXT_FIELD_FIRST_NAME){
            isFirstNameEntered = YES ;
        } else if(textField.tag == CONSOLE_TEXT_FIELD_LAST_NAME){
            isLastNameEntered = YES ;
        }
    }
    [self performSelectorOnMainThread:@selector(updateLoginButton) withObject:nil waitUntilDone:NO] ;
    return YES ;
}


- (void)didBackButtonTap
{
    //NSLog(@"didBackButtonTap") ;
    if(self.navigationController != nil){
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    //[VeamUtil showTabBarController:-1] ;
}






- (void)didProfilePictureTap
{
    //NSLog(@"didProfilePictureTap") ;
    [self showImageInputView] ;
}


- (void)showImageInputView
{
    gkImagePicker = [[GKImagePicker alloc] init] ;
    gkImagePicker.cropSize = CGSizeMake(displayWidth,displayHeight) ;
    gkImagePicker.delegate = self ;
    gkImagePicker.resizeableCropArea = YES ;
    gkImagePicker.allowResize = NO ;
    
    [self presentModalViewController:gkImagePicker.imagePickerController animated:YES] ;
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    if(image == nil){
        NSLog(@"image is nil") ;
    }
    
    //NSLog(@"pickedImage w=%f h=%f -> w=%f h=%f",image.size.width,image.size.height,cropWidth,cropHeight) ;
    
    CGFloat resizeWidth = cropWidth ;
    CGFloat resizeHeight = cropHeight ;
    
    profileImage = [VeamUtil resizeImage:image width:resizeWidth height:resizeHeight backgroundColor:[UIColor whiteColor]] ;
    [profilePictureLabel setText:NSLocalizedString(@"selected",nil)] ;
    [profilePictureLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF818181"]] ;
    isProfilePictureEntered = YES ;
    [self updateLoginButton] ;
    [self dismissModalViewControllerAnimated:YES] ;
    
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker
{
    //NSLog(@"GKImagePicker canceled") ;
    [self dismissModalViewControllerAnimated:YES] ;
}



@end
