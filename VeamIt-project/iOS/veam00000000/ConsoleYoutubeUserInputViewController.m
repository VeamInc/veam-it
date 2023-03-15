//
//  ConsoleYoutubeUserInputViewController.m
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleYoutubeUserInputViewController.h"
#import "VeamUtil.h"
#import "ConsolePostData.h"
#import "ConsoleUtil.h"
#import "ConsoleYoutubeUserConfirmViewController.h"

#define INPUT_VIEW_MINIMUM_BLINK_TIME   1.5f
#define INPUT_VIEW_BLINK_SPAN       0.25f

@interface ConsoleYoutubeUserInputViewController ()

@end

@implementation ConsoleYoutubeUserInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define USER_NAME_FIELD_HEIGHT 37
#define USER_NAME_FIELD_MARGIN 30

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
    
    inputView = [[UIView alloc] initWithFrame:CGRectMake(USER_NAME_FIELD_MARGIN, ([VeamUtil getScreenHeight]-USER_NAME_FIELD_HEIGHT)/2, [VeamUtil getScreenWidth]-USER_NAME_FIELD_MARGIN*2, USER_NAME_FIELD_HEIGHT)] ;

    UIColor *color = [VeamUtil getColorFromArgbString:@"FF6D6D6D"] ;

    NSString *placeholderText = @" YouTube User Name" ;
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0,0,inputView.frame.size.width,inputView.frame.size.height)] ;
    [userNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone] ;
    [userNameField setTextColor:color] ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [userNameField setTintColor:color] ;
    }
    [userNameField setReturnKeyType:UIReturnKeyDone] ;
    [userNameField setDelegate:self] ;
    if ([userNameField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}] ;
    } else {
        [userNameField setPlaceholder:placeholderText] ;
    }
    [userNameField setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]] ;
    [inputView addSubview:userNameField] ;
    
    UIView *underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, inputView.frame.size.height-1, inputView.frame.size.width, 1)] ;
    [underLineView setBackgroundColor:color] ;
    [inputView addSubview:underLineView] ;
    
    [self.view addSubview:inputView] ;
    
    
    [self showHeader:@"" backgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
}

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
    //NSLog(@"ConsoleYoutubeUserInputViewController::didHeaderNextTap") ;
    NSString *userName = userNameField.text ;
    if(![VeamUtil isEmpty:userName]){
        [self hideHeader] ;
        //NSLog(@"userName:%@",userName) ;
        shouldContinueBlinking = YES ;
        totalBlinkTime = 0 ;
        blinkTimer = [NSTimer scheduledTimerWithTimeInterval:INPUT_VIEW_BLINK_SPAN target:self selector:@selector(blinkInputView) userInfo:nil repeats:YES] ;
        [self sendYoutubeUserName] ;
        //[self blinkInputView] ;
    }
}

- (void)launchConfView
{
    ConsoleYoutubeUserConfirmViewController *viewController = [[ConsoleYoutubeUserConfirmViewController alloc] init] ;
    [viewController setChannelTitle:channelTitle] ;
    [self.navigationController pushViewController:viewController animated:NO] ;
}

- (void)blinkInputView
{
    if(shouldContinueBlinking){
        if([inputView alpha] == 1.0f){
            [inputView setAlpha:0.0f] ;
        } else {
            [inputView setAlpha:1.0f] ;
        }
    } else {
        [inputView setAlpha:1.0f] ;
    }
    
    totalBlinkTime += INPUT_VIEW_BLINK_SPAN ;
    if(totalBlinkTime > INPUT_VIEW_MINIMUM_BLINK_TIME){
        if(![VeamUtil isEmpty:channelTitle]){
            [blinkTimer invalidate] ;
            [[ConsoleUtil getConsoleContents].appInfo setName:channelTitle] ;
            [[ConsoleUtil getConsoleContents].appInfo setStoreAppName:channelTitle] ;
            [self performSelectorOnMainThread:@selector(launchConfView) withObject:nil waitUntilDone:NO] ;
        }
    }
}

- (void)sendYoutubeUserName
{
    NSString *userName = userNameField.text ;

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userName,@"n",
                            nil] ;
    
    ConsolePostData *postData = [[ConsolePostData alloc] init] ;
    [postData setApiName:@"account/setyoutubeusername"] ;
    [postData setParams:params] ;
    [self performSelectorInBackground:@selector(doPost:) withObject:postData] ;
}

- (void)doPost:(ConsolePostData *)postData
{
    @autoreleasepool
    {
        NSArray *results = [ConsoleUtil doPost:postData] ;
        //NSLog(@"ConsoleUtil doPost called") ;
        if(results != nil){
            //NSLog(@"results != nil") ;
            int count = [results count] ;
            if(count > 0){
                //NSLog(@"count > 0") ;
                NSString *code = [results objectAtIndex:0] ;
                if([code isEqual:@"OK"]){
                    //NSLog(@"OK") ;
                    if(count >= 2){
                        //NSLog(@"count >= 2") ;
                        channelTitle = [results objectAtIndex:1] ;
                        //NSLog(@"channelTitle=%@",channelTitle) ;
                    } else {
                        //NSLog(@"count < 2") ;
                        [self performSelectorOnMainThread:@selector(updateFailed:) withObject:@"Failed to update" waitUntilDone:NO] ;
                    }
                } else if([code isEqual:@"ERROR_MESSAGE"]){
                    if(count >= 2){
                        [self performSelectorOnMainThread:@selector(updateFailed:) withObject:[results objectAtIndex:1] waitUntilDone:NO] ;
                    } else {
                        [self performSelectorOnMainThread:@selector(updateFailed:) withObject:@"Failed to update" waitUntilDone:NO] ;
                    }
                } else {
                    for(int index = 0 ; index < count ; index++){
                        //NSLog(@"%d:%@",index,[results objectAtIndex:index]) ;
                    }
                    [self performSelectorOnMainThread:@selector(updateFailed:) withObject:@"Failed to update" waitUntilDone:NO] ;
                }
            }
        } else {
            [self performSelectorOnMainThread:@selector(updateFailed:) withObject:@"Failed to update" waitUntilDone:NO] ;
        }
    }
}

- (void)updateFailed:(NSString *)message
{
    //NSLog(@"updateFailed:%@",message) ;
    shouldContinueBlinking = NO ;
    [blinkTimer invalidate] ;
    blinkTimer = nil ;
    [headerView setAlpha:1.0] ;
    [inputView setAlpha:1.0f] ;
    
    [VeamUtil dispError:message] ;
}




/*
- (void)blinkInputView
{
    if(shouldContinueBlinking){
        [UIView beginAnimations:nil context:nil] ;
        [UIView setAnimationDuration:0.2f] ;
        [UIView setAnimationDelegate:self] ;
        [UIView setAnimationDidStopSelector:@selector(blinkInputView)] ;
        if([inputView alpha] == 1.0f){
            [inputView setAlpha:0.0f] ;
        } else {
            [inputView setAlpha:1.0f] ;
        }
        [UIView commitAnimations] ;
    }
}
 */


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

@end
