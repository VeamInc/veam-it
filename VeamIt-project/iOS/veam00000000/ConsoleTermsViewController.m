//
//  ConsoleTermsViewController.m
//  veam00000000
//
//  Created by veam on 12/21/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTermsViewController.h"
#import "VeamUtil.h"

#define TERMS_ACCEPT_BUTTON_HEIGHT    44

@interface ConsoleTermsViewController ()

@end

@implementation ConsoleTermsViewController

@synthesize url ;
@synthesize shouldReload ;
@synthesize showBackButton ;
@synthesize showSettingsDoneButton ;

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
    
    //NSLog(@"ConsoleTermsViewController::viewDidLoad url=%@",url) ;
    
    //[self setViewName:[NSString stringWithFormat:@"WebView/%@/",url]] ;
    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [VeamUtil getTopBarHeight]+[VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTopBarHeight]-TERMS_ACCEPT_BUTTON_HEIGHT)] ;
    [webView setScalesPageToFit:YES] ;
    [webView setBackgroundColor:[UIColor clearColor]] ;
    
    [self.view addSubview:webView] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    CGRect frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator startAnimating] ;
    [self.view addSubview:indicator] ;
    
    webView.delegate = self ;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    firstAppear = YES ;
    
    UIImage *image = [VeamUtil imageNamed:@"br_forward_off.png"] ;
    CGFloat buttonY = [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTabBarHeight]-image.size.height/2-10 ;
    forwardImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth] / 2, buttonY, image.size.width/2, image.size.height/2)] ;
    [VeamUtil registerTapAction:forwardImageView target:self selector:@selector(onForwardButtonTap)] ;
    [forwardImageView setImage:image] ;
    [forwardImageView setAlpha:0.0] ;
    [self.view addSubview:forwardImageView] ;
    
    frame = forwardImageView.frame ;
    image = [VeamUtil imageNamed:@"br_backward_off.png"] ;
    backwardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x-image.size.width/2, frame.origin.y, image.size.width/2, image.size.height/2)] ;
    [VeamUtil registerTapAction:backwardImageView target:self selector:@selector(onBackwardButtonTap)] ;
    [backwardImageView setImage:image] ;
    [backwardImageView setAlpha:0.0] ;
    [self.view addSubview:backwardImageView] ;

    
    
    UIView *editButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height-TERMS_ACCEPT_BUTTON_HEIGHT, [VeamUtil getScreenWidth], TERMS_ACCEPT_BUTTON_HEIGHT)] ;
    [editButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFF8F8F8"]] ;
    [VeamUtil registerTapAction:editButtonView target:self selector:@selector(didAcceptButtonTap)] ;
    [contentView addSubview:editButtonView] ;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], 0.5)] ;
    [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
    [editButtonView addSubview:separatorView] ;
    
    buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], TERMS_ACCEPT_BUTTON_HEIGHT)] ;
    [buttonLabel setBackgroundColor:[UIColor clearColor]] ;
    [buttonLabel setText:NSLocalizedString(@"accept", nil)] ;
    [buttonLabel setTextColor:[UIColor blackColor]] ;
    [buttonLabel setTextAlignment:NSTextAlignmentCenter] ;
    [buttonLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]] ;
    [editButtonView addSubview:buttonLabel] ;
    
    [self updateButtonLabel] ;

}

- (void)updateButtonLabel
{
    NSString *acceptedAt = [ConsoleUtil getConsoleContents].appInfo.termsAcceptedAt ;
    if([self isAccepted]){
        [buttonLabel setText:NSLocalizedString(@"accepted", nil)] ;
        [buttonLabel setTextColor:[UIColor redColor]] ;
        [buttonLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]] ;
    }
}

- (BOOL)isAccepted
{
    NSString *acceptedAt = [ConsoleUtil getConsoleContents].appInfo.termsAcceptedAt ;
    return ![VeamUtil isEmpty:acceptedAt] ;
    
}

- (void)didAcceptButtonTap
{
    //NSLog(@"didAcceptButtonTap") ;
    if(![self isAccepted]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"accept_these_terms", nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:NSLocalizedString(@"accept", nil), nil] ;
        [alert show];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    switch (buttonIndex) {
        case 0:
            // cancel
            break;
        case 1:
            // Accept
            //NSLog(@"Accept") ;
            [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
            [[ConsoleUtil getConsoleContents] setAppTermsAccepted] ;
            break;
    }
}

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
        if([apiName isEqualToString:@"app/acceptterms"]){
            //NSLog(@"acceptterms finished") ;
            [self performSelectorOnMainThread:@selector(hideProgress) withObject:nil waitUntilDone:NO] ;
            NSArray *results = [[notification userInfo] objectForKey:@"RESULTS"] ;
            if(results){
                NSInteger count = [results count] ;
                if(count >= 2){
                    NSString *retValue = [results objectAtIndex:0] ;
                    if([retValue isEqualToString:@"OK"]){
                        [ConsoleUtil getConsoleContents].appInfo.termsAcceptedAt = [results objectAtIndex:1] ;
                        [self performSelectorOnMainThread:@selector(updateButtonLabel) withObject:nil waitUntilDone:NO] ;
                    }
                }
            }
        }
    }
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
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


#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"shouldStartLoadWithRequest url=%@",request.URL.absoluteString) ;
    return YES ;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"webViewDidStartLoad") ;
    // starting the load, show the activity indicator in the status bar
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [indicator startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //NSLog(@"webViewDidFinishLoad") ;
    // finished loading, hide the activity indicator in the status bar
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [indicator stopAnimating] ;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"didFailLoadWithError") ;
    //NSLog(@"code=%d",error.code) ;
    if(error.code != -999){
        // load error, hide the activity indicator in the status bar
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [indicator stopAnimating] ;
        
        // report the error inside the webview
        NSString* errorString = [NSString stringWithFormat:
                                 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                                 error.localizedDescription] ;
        [webView loadHTMLString:errorString baseURL:nil] ;
    }
}

-(void)dealloc
{
    //NSLog(@"WebViewController::dealloc") ;
    if (webView.loading) {
        [webView stopLoading];
    }
    webView.delegate = nil ;
}


@end
