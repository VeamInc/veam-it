//
//  PostCommentViewController.m
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "PostCommentViewController.h"
#import "VeamUtil.h"

@interface PostCommentViewController ()

@end

@implementation PostCommentViewController

@synthesize pictureId ;
@synthesize pictures ;

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
    
    [self setViewName:[NSString stringWithFormat:@"PostPictureComment/%@/",pictureId]] ;
    
/*
#ifndef DO_NOT_USE_ADMOB
    interstitial = [[GADInterstitial alloc] initWithAdUnitID:VEAM_ADMOB_UNIT_ID_POSTPICTURE] ;
    interstitial.delegate = self ;
    [interstitial loadRequest:[VeamUtil getAdRequest]] ;
#endif
*/
    
    
    isPosting = NO ;
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,[VeamUtil getViewTopOffset] + [VeamUtil getTopBarHeight] + 10, [VeamUtil getScreenWidth] - 20, 150)] ;
    [commentTextView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [commentTextView setTextColor:[VeamUtil getBaseTextColor]] ;
    [commentTextView becomeFirstResponder] ;
    [self.view addSubview:commentTextView] ;
    
    [self addTopBar:YES showSettingsButton:NO] ;

    //CGRect buttonFrame = CGRectMake(260,7,50,30) ;
    
    CGFloat postWidth = 50 ;
    CGRect postFrame = CGRectMake(topBarTitleMaxRight-postWidth, 0, postWidth, [VeamUtil getTopBarHeight]) ;
    postLabel = [[UILabel alloc] initWithFrame:postFrame] ;
    [postLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [postLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
    [postLabel setBackgroundColor:[UIColor clearColor]] ;
    [postLabel setText:NSLocalizedString(@"post",nil)] ;
    [VeamUtil registerTapAction:postLabel target:self selector:@selector(onPostButtonTap)] ;
    [topBarView addSubview:postLabel] ;
    
    /*
    UIButton *postButton = [UIButton buttonWithType:100] ;
    [postButton setTitle:@"Post" forState:UIControlStateNormal] ;
    [postButton setFrame:buttonFrame] ;
    [postButton addTarget:self action:@selector(onPostButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton] ;
     */
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
    CGRect frame = indicator.frame ;
    frame.origin.x = postFrame.origin.x + (postFrame.size.width - frame.size.width) / 2 ;
    frame.origin.y = postFrame.origin.y + (postFrame.size.height - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator setAlpha:0.0] ;
    [topBarView addSubview:indicator] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onPostButtonTap
{
    //NSLog(@"post");

    if(isPosting){
        return ;
    }
    
    NSString *comment = [commentTextView text] ;
    if((comment == nil) || [comment isEqualToString:@""]){
        return ;
    }

    
    isPosting = YES ;
    [indicator startAnimating] ;
    [indicator setAlpha:1.0] ;
    [postLabel setAlpha:0.0] ;
    
    [self postComment] ;
}

- (void)postComment
{
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    //NSLog(@"postComment %@ %@",[name text],[comment text]) ;
    [self sendPostRequest] ;
}

- (void)sendPostRequest
{
    NSURL *url = [VeamUtil getApiUrl:@"forum/postpicturecomment"] ;
    
    
    NSString *comment = [commentTextView text] ;
    NSString *urlEncodedComment = [VeamUtil urlEncode:comment] ;
    //NSLog(@"urlEncodedMessage = %@",urlEncodedMessage);
    
    NSString *uid = [VeamUtil getUid] ;
    NSInteger socialUserId = [VeamUtil getSocialUserId] ;
    NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%d_%@_%@",uid,socialUserId,pictureId,comment]] ;
    
    NSString *params ;
    params = [NSString stringWithFormat:@"u=%@&sid=%d&p=%@&c=%@&s=%@",uid,socialUserId,pictureId,urlEncodedComment,signature] ;
    NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    
    conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(conn){
        buffer = [NSMutableData data] ;
    } else {
        // error handling
    }
}


- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)res
{
    NSHTTPURLResponse *hres = (NSHTTPURLResponse *)res;
    /*
     NSLog(@"Received Response. Status Code: %d", [hres statusCode]);
     NSLog(@"Expected ContentLength: %qi", [hres expectedContentLength]);
     NSLog(@"MIMEType: %@", [hres MIMEType]);
     NSLog(@"Suggested File Name: %@", [hres suggestedFilename]);
     NSLog(@"Text Encoding Name: %@", [hres textEncodingName]);
     NSLog(@"URL: %@", [hres URL]);
     NSLog(@"Received Response. Status Code: %d", [hres statusCode]);
     */
    NSDictionary *dict = [hres allHeaderFields];
    NSArray *keys = [dict allKeys];
    for (int i = 0; i < [keys count]; i++) {
        /*
         NSLog(@"    %@: %@",
         [keys objectAtIndex:i],
         [dict objectForKey:[keys objectAtIndex:i]]);
         */
    }
    [buffer setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receivedData
{
    [buffer appendData:receivedData];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    conn = nil ;
    buffer = nil ;
    NSLog(@"Connection failed: %@", [error localizedDescription]);
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    [postLabel setAlpha:1.0] ;
    [VeamUtil dispError:@"Request failed"] ;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"Succeed!! Received %d bytes of data", [buffer length]);
    NSString *contents = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    //NSLog(@"received %@",contents) ;
    NSArray *results = [contents componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    NSString *commentId = nil ;
    if([results count] >= 2){
        if([[results objectAtIndex:0] compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
            commentId = [results objectAtIndex:1] ;
            //commentId = [results objectAtIndex:2] ;
            NSString *userId = [results objectAtIndex:3] ;
            NSString *userName = [results objectAtIndex:4] ;
            NSString *text = [results objectAtIndex:5] ;
            
            /*
            NSInteger count = [results count] ;
            for(int index = 0 ; index < count ; index++){
                NSLog(@"%d = %@",index,[results objectAtIndex:index]) ;
            }
             */
            
            Comment *comment = [[Comment alloc] init] ;
            [comment setCommentId:commentId] ;
            [comment setPictureId:pictureId] ;
            [comment setOwnerUserId:userId] ;
            [comment setOwnerName:userName] ;
            [comment setComment:text] ;
            
            [pictures addComment:comment] ;
        }
    }
    
    //NSLog(@"%@", contents);
    buffer = nil ;
    
//#ifdef DO_NOT_USE_ADMOB
    [self.navigationController popViewControllerAnimated:YES] ;
/*
#else
    if(interstitial.isReady){
        [interstitial presentFromRootViewController:self] ;
    } else {
        [self.navigationController popViewControllerAnimated:YES] ;
    }
#endif
*/
}


/*
#ifndef DO_NOT_USE_ADMOB
/// Called when an interstitial ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    //NSLog(@"interstitialDidReceiveAd");
}

/// Called when an interstitial ad request failed.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    //NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Called just before presenting an interstitial.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    //NSLog(@"interstitialWillPresentScreen");
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    //NSLog(@"interstitialWillDismissScreen");
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    //NSLog(@"interstitialDidDismissScreen");
    [self.navigationController popViewControllerAnimated:YES] ;
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store).
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    //NSLog(@"interstitialWillLeaveApplication");
    [self.navigationController popViewControllerAnimated:YES] ;
}
#endif
*/

@end
