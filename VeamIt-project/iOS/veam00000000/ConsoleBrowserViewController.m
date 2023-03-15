//
//  ConsoleBrowserViewController.m
//  veam00000000
//
//  Created by veam on 3/9/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleBrowserViewController.h"
#import "VeamUtil.h"

@interface ConsoleBrowserViewController ()

@end

@implementation ConsoleBrowserViewController

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
    
    
    
    //[self setViewName:[NSString stringWithFormat:@"WebView/%@/",url]] ;
    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [VeamUtil getTopBarHeight]+[VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTopBarHeight])] ;
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
    CGFloat buttonY = [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-image.size.height/2-10 ;
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
    //NSLog(@"%@::refreshInfo",NSStringFromClass([self class])) ;
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

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"%@::viewDidAppear",NSStringFromClass([self class])) ;
    [super viewDidAppear:animated] ;
    if(refreshTimer == nil){
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshInfo) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"%@::viewDidDisappear",NSStringFromClass([self class])) ;
    if(refreshTimer != nil){
        [refreshTimer invalidate] ;
        refreshTimer = nil ;
    }
}


@end
