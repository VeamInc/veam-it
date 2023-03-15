//
//  WebViewController.m
//  veam31000000
//
//  Created by veam on 7/25/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "WebViewController.h"
#import "VeamUtil.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize url ;
@synthesize showBackButton ;
@synthesize showSettingsDoneButton ;
@synthesize shouldReload ;

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
    [super viewDidLoad] ;
    // Do any additional setup after loading the view from its nib.
    
    isShowingNavigationButton = NO ;
    isForwardButtonOn = NO ;
    isBackwardButtonOn = NO ;
    
    [self setViewName:[NSString stringWithFormat:@"WebView/%@/",url]] ;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [VeamUtil getTopBarHeight]+[VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTopBarHeight]-[VeamUtil getTabBarHeight])] ;
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
    //NSLog(@"load url=%@",url) ;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    firstAppear = YES ;
    
    if(showBackButton){
        [self addTopBar:YES showSettingsButton:NO] ;
    } else {
        [self addTopBar:NO showSettingsButton:NO] ;
    }
    
    if(showSettingsDoneButton){
        UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(topBarTitleMaxRight-VEAM_SETTINGS_DONE_WIDTH, 0, VEAM_SETTINGS_DONE_WIDTH, [VeamUtil getTopBarHeight])] ;
        [doneLabel setText:NSLocalizedString(@"done",nil)] ;
        [doneLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
        [doneLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
        [doneLabel setBackgroundColor:[UIColor clearColor]] ;
        [VeamUtil registerTapAction:doneLabel target:self selector:@selector(onDoneButtonTap)] ;
        [topBarView addSubview:doneLabel] ;
    }
    
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
}

- (void)onForwardButtonTap
{
    if([webView canGoForward]){
        [webView goForward] ;
    }
}

- (void)onBackwardButtonTap
{
    if([webView canGoBack]){
        [webView goBack] ;
    }
}

- (void)onDoneButtonTap
{
    [VeamUtil showTabBarController:-1] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    /*
    if((error.code == -1022) && ![url isEqualToString:[VeamUtil getSecureUrl:url]]){
        url = [VeamUtil getSecureUrl:url] ;
        //NSLog(@"reload url=%@",url) ;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    } else {
     */
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
    /*
    }
     */
}

-(void)dealloc
{
    //NSLog(@"WebViewController::dealloc") ;
    if (webView.loading) {
        [webView stopLoading];
    }
    webView.delegate = nil ;
}

- (void)showNavigationButton
{
    isShowingNavigationButton = YES ;
    [forwardImageView setAlpha:1.0] ;
    [backwardImageView setAlpha:1.0] ;
}

- (void)changeBackwardImage
{
    if([webView canGoBack]){
        isBackwardButtonOn = YES ;
        [backwardImageView setImage:[VeamUtil imageNamed:@"br_backward_on.png"]] ;
    } else {
        isBackwardButtonOn = NO ;
        [backwardImageView setImage:[VeamUtil imageNamed:@"br_backward_off.png"]] ;
    }
}

- (void)changeForwardImage
{
    if([webView canGoForward]){
        isForwardButtonOn = YES ;
        [forwardImageView setImage:[VeamUtil imageNamed:@"br_forward_on.png"]] ;
    } else {
        isForwardButtonOn = NO ;
        [forwardImageView setImage:[VeamUtil imageNamed:@"br_forward_off.png"]] ;
    }
}

- (void)refreshInfo
{
    if([webView canGoBack]){
        //NSLog(@"canGoBack") ;
        if(!isShowingNavigationButton){
            [self performSelectorOnMainThread:@selector(showNavigationButton) withObject:nil waitUntilDone:NO] ;
        }
        if(!isBackwardButtonOn){
            [self performSelectorOnMainThread:@selector(changeBackwardImage) withObject:nil waitUntilDone:NO] ;
        }
    } else {
        //NSLog(@"can NOT GoBack") ;
        if(isBackwardButtonOn){
            [self performSelectorOnMainThread:@selector(changeBackwardImage) withObject:nil waitUntilDone:NO] ;
        }
    }

    if([webView canGoForward]){
        //NSLog(@"canGoForward") ;
        if(!isShowingNavigationButton){
            [self performSelectorOnMainThread:@selector(showNavigationButton) withObject:nil waitUntilDone:NO] ;
        }
        if(!isForwardButtonOn){
            [self performSelectorOnMainThread:@selector(changeForwardImage) withObject:nil waitUntilDone:NO] ;
        }
    } else {
        //NSLog(@"can NOT GoForward") ;
        if(isForwardButtonOn){
            [self performSelectorOnMainThread:@selector(changeForwardImage) withObject:nil waitUntilDone:NO] ;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"WebView::viewDidAppear") ;
    [super viewDidAppear:animated] ;
    if(refreshTimer == nil){
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshInfo) userInfo:nil repeats:YES];
    }

    if(firstAppear){
        firstAppear = NO ;
    } else {
        if(shouldReload){
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"WebView::viewDidDisappear") ;
    if(refreshTimer != nil){
        [refreshTimer invalidate] ;
        refreshTimer = nil ;
    }
}


@end
