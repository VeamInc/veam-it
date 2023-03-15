//
//  YoutubePlayViewController.m
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "YoutubePlayViewController.h"

#import "VeamUtil.h"
#import "WebViewController.h"
#import "ImageViewerViewController.h"


@interface YoutubePlayViewController ()

@end

@implementation YoutubePlayViewController

@synthesize youtube ;

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
    // Do any additional setup after loading the view from its nib.
    
    [self setViewName:[NSString stringWithFormat:@"YoutubePlay/%@/%@/",[youtube youtubeId],[youtube title]]] ;
    
    isBrowsing = NO ;

    CGFloat deviceWidth = [VeamUtil getScreenWidth] ;
    
    CGFloat margin = 10 ;
    
    BOOL hasDescription = NO ;
    NSString *description = [youtube description] ;
    if((description != nil) && ![description isEqualToString:@""]){
        hasDescription = YES ;
        //NSLog(@"description:%@",description) ;
    }

    
    BOOL isLongDevice = NO ;
    if([VeamUtil getScreenHeight] > 480){
        isLongDevice = YES ;
    }
    
    CGFloat offsetY ;
    if(hasDescription){
        offsetY = [VeamUtil getTopBarHeight] ;
    } else {
        offsetY = 76 ;
        if(isLongDevice){
            offsetY += 44 ;
        }
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTabBarHeight])] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:scrollView] ;
    
    
    CGFloat thumbnailHeight = [VeamUtil getScreenWidth] * 9 / 16 ;
    CGFloat backHeight = thumbnailHeight * 1.2 ;
    UIView *playerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY , deviceWidth, backHeight)] ;
    [playerBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:playerBackView] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    CGRect frame = indicator.frame ;
    frame.origin.x = (deviceWidth - frame.size.width) / 2 ;
    frame.origin.y = offsetY + (backHeight - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator startAnimating] ;
    [scrollView addSubview:indicator] ;
    
    offsetY += thumbnailHeight * 0.1 ;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, offsetY, deviceWidth, thumbnailHeight)] ;
    [webView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]] ;
    [webView setDelegate:self] ;
    [webView setAlpha:0.0] ;
    
    webView.allowsInlineMediaPlayback = YES ;
    webView.mediaPlaybackRequiresUserAction = NO ;
    
    [scrollView addSubview:webView] ;
    
    offsetY += thumbnailHeight * 1.1 + margin ;
    UIView *bottmBackView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY , deviceWidth, 80)] ;
    [bottmBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:bottmBackView] ;
    
    UIImage *iconImage = [VeamUtil imageNamed:@"add_off.png"] ;
    CGFloat iconSize = iconImage.size.width / 2 ;
    //iconSize = 0 ; // no add button

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(margin, offsetY+5, deviceWidth-20-iconSize-margin, 50)] ;
    [label setText:[youtube title]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
    [label setNumberOfLines:2];
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [scrollView addSubview:label] ;
    
    favoriteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(deviceWidth-margin-iconSize, offsetY+5, iconSize,iconSize)] ;
    if([VeamUtil isFavoriteYoutube:[youtube youtubeId]]){
        [favoriteImageView setImage:[VeamUtil imageNamed:@"add_on.png"]] ;
    } else {
        [favoriteImageView setImage:iconImage] ;
    }
    [VeamUtil registerTapAction:favoriteImageView target:self selector:@selector(onFavoriteButtonTap:)] ;
    [scrollView addSubview:favoriteImageView] ;
    
    

    label = [[UILabel alloc]initWithFrame:CGRectMake(margin, offsetY+55, deviceWidth-20, 20)] ;
    [label setText:[VeamUtil getDurationString:[youtube duration]]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [scrollView addSubview:label] ;
    
    offsetY += bottmBackView.frame.size.height ;
    UIView *descriptionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY , deviceWidth, 1)] ;
    [descriptionBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:descriptionBackView] ;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, [VeamUtil getScreenWidth]-margin*2, 1)] ;
    [separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [descriptionBackView addSubview:separatorView] ;

    frame = CGRectMake(margin, margin, deviceWidth-margin*2, 1) ;
    TTStyledTextLabel *descriptionlabel = [[TTStyledTextLabel alloc] initWithFrame:frame] ;

    NSString *linkPattern = @"(https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+)";
    NSString *linkReplacement = @"<a href=\"$1\" class=\"descLink:\">$1</a>";
    
    NSRegularExpression *linkRegexp = [NSRegularExpression
                                       regularExpressionWithPattern:linkPattern
                                       options:NSRegularExpressionCaseInsensitive
                                       error:nil
                                       ];
    
    NSString *linkedString = [linkRegexp
                              stringByReplacingMatchesInString:description
                              options:NSMatchingReportProgress
                              range:NSMakeRange(0, description.length)
                              withTemplate:linkReplacement
                              ];

    
    [descriptionlabel setText:[TTStyledText textFromXHTML:linkedString lineBreaks:YES URLs:NO]] ;
    [descriptionlabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [descriptionlabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [descriptionlabel setBackgroundColor:[UIColor clearColor]] ;
    [descriptionlabel sizeToFit] ;
    [descriptionBackView addSubview:descriptionlabel] ;
    
    //NSLog(@"descriptionlabel.frame.size.height=%f",descriptionlabel.frame.size.height) ;
    frame = descriptionBackView.frame ;
    frame.size.height = descriptionlabel.frame.size.height + margin * 2 ;
    [descriptionBackView setFrame:frame] ;

    CGFloat contentHeight = offsetY + frame.size.height + 30.0 ;
    if(contentHeight <= scrollView.frame.size.height){
        contentHeight = scrollView.frame.size.height + 1 ;
    }
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], contentHeight)] ;
    
    NSURL *apiUrl = [VeamUtil getApiUrl:@"youtube/play4"] ;
    NSString *urlString = [[apiUrl absoluteString] stringByAppendingFormat:@"&v=%@",[youtube youtubeVideoId]] ;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

    appearFlag = NO ;
    [self addTopBar:YES showSettingsButton:NO] ;
    
    ttNavigator = [TTNavigator navigator] ;
    ttNavigator.delegate = self ;
}

- (void)onFavoriteButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    // 押されたらとりあえず変更する
    UIImageView *imageView = (UIImageView *)[singleTapGesture view] ;
    NSString *youtubeId = [youtube youtubeId] ;
    if([VeamUtil isFavoriteYoutube:youtubeId]){
        [imageView setImage:[VeamUtil imageNamed:@"add_off.png"]] ;
        [VeamUtil deleteFavoriteYoutube:youtubeId] ;
    } else {
        [imageView setImage:[VeamUtil imageNamed:@"add_on.png"]] ;
        [VeamUtil addFavoriteYoutube:youtubeId] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"viewDidAppear") ;
    [super viewDidAppear:animated] ;
    if(appearFlag && !isBrowsing){
        [self.navigationController popViewControllerAnimated:NO] ;
    } else {
        appearFlag = YES ;
    }
    isBrowsing = NO ;
    //[VEAMUtil trackPageView:0 pageName:[self getPageName]] ;
}

//NSString static *const kYTPlayerAdUrlRegexPattern = @"^http(s)://pubads.g.doubleclick.net/pagead/conversion/";
//NSString static *const kYTPlayerAdUrlRegexPattern = @"pubads.g.doubleclick.net/pagead/conversion/";

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"shouldStartLoadWithRequest url=%@",request.URL.absoluteString) ;
    
    BOOL shouldStart = YES ;
    
    NSArray *exclusionUrls = [VeamUtil getYoutubeExclusionUrls] ;
    if(exclusionUrls != nil){
        //NSLog(@"exclusionUrls != nil") ;
        NSError *error = NULL ;
        NSInteger count = [exclusionUrls count] ;
        NSString *absoluteString = request.URL.absoluteString ;
        for(int index = 0 ; index < count ; index++){
            NSString *exclusionUrl = [exclusionUrls objectAtIndex:index] ;
            //NSLog(@"exclusionUrl=%@",exclusionUrl) ;
            NSRegularExpression *excludeRegex = [NSRegularExpression regularExpressionWithPattern:exclusionUrl options:NSRegularExpressionCaseInsensitive error:&error] ;
            NSTextCheckingResult *excludeMatch = [excludeRegex firstMatchInString:absoluteString options:0 range:NSMakeRange(0, [absoluteString length])] ;
            if(excludeMatch){
                //NSLog(@"Match") ;
                shouldStart = NO ;
                break ;
            }
        }
    }
    
    return shouldStart ;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"webViewDidStartLoad") ;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"didFailLoadWithError") ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //NSLog(@"webViewDidFinishLoad") ;
    [indicator setAlpha:0.0] ;
    [indicator stopAnimating] ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [webView setAlpha:1.0] ;
    [UIView commitAnimations];
}

/*
- (NSString *)getPageName
{
    return [NSString stringWithFormat:@"YouTubePlay/%@",youTubeId] ;
}

- (void)trackEvent:(NSString *)buttonName
{
    [VEAMUtil trackEvent:0 pageName:[self getPageName] buttonName:buttonName] ;
}
 */

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"viewDidDisappear") ;
    if(!isBrowsing){
        if (webView.loading) {
            [webView stopLoading];
        }
        [webView removeFromSuperview] ;
        [webView setDelegate:nil] ;
        webView = nil ;
        
        if(ttNavigator != nil){
            [ttNavigator setDelegate:nil] ;
            ttNavigator = nil ;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"YoutubePlayViewController::shouldAutorotateToInterfaceOrientation") ;
    //NSString* className = NSStringFromClass([self class]);
    //NSLog(@"class=%@",className) ;
    
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight) ;
}

- (BOOL)navigator: (TTBaseNavigator *)navigator shouldOpenURL:(NSURL *)url
{
    //NSLog(@"shouldOpenURL url=%@ scheme=%@",[url absoluteString],[url scheme]) ;
    
    isBrowsing = YES ;
    
    if([[url scheme] isEqualToString:@"printable"]){
        NSString *youtubeId = [url host] ;
        //NSLog(@"youtubeId=%@",youtubeId) ;
        Youtube *printable = [VeamUtil getYoutubeForId:youtubeId] ;
        if([[printable kind] isEqualToString:VEAM_YOUTUBE_KIND_IMAGE]){
            ImageViewerViewController *imageViewerViewController = [[ImageViewerViewController alloc] init] ;
            [imageViewerViewController setUrl:[printable linkUrl]] ;
            [imageViewerViewController setTitleName:[printable title]] ;
            [self.navigationController pushViewController:imageViewerViewController animated:YES];
        }
    } else {
        WebViewController *webViewController = [[WebViewController alloc] init] ;
        [webViewController setUrl:[url absoluteString]] ;
        [webViewController setTitleName:[youtube title]] ;
        [webViewController setShowBackButton:YES] ;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    /*
     NSDictionary *queryParameters = [url queryParameters] ;
     NSString *action = [queryParameters valueForKey:@"action"] ;
     NSString *userId = [queryParameters valueForKey:@"guid"] ;
     if((action != nil) && ([action compare:VEAM_ELGG_ACTION_SHOW_USER] == NSOrderedSame)){
     ElggProfileViewController *elggProfileViewController = [[ElggProfileViewController alloc] initWithNibName:@"ElggProfileViewController" bundle:nil] ;
     [elggProfileViewController setElggUserId:userId] ;
     if (elggProfileViewController) {
     [socialNavigationController pushViewController:elggProfileViewController animated:YES];
     }
     }
     */
    return NO ;
}




@end
