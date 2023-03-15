//
//  ImageShareViewController.m
//  CameraTest
//
//  Created by veam on 7/9/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "ImageShareViewController.h"
#import "VeamUtil.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>


//#define PLACE_HOLDER_STRING @"Add a caption"

@interface ImageShareViewController ()

@end

@implementation ImageShareViewController

@synthesize targetImage ;
@synthesize degree ;
@synthesize forumId ;

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
    
    [self setViewName:@"ImageShare/"] ;
    
/*
#ifndef DO_NOT_USE_ADMOB
    interstitial = [[GADInterstitial alloc] initWithAdUnitID:VEAM_ADMOB_UNIT_ID_POSTPICTURE] ;
    interstitial.delegate = self ;
    [interstitial loadRequest:[VeamUtil getAdRequest]] ;
#endif
*/
    
    shouldPostToFacebook = NO ;
    shouldPostToTwitter = NO ;
    twitterAccount = nil ;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.784 green:0.784 blue:0.784 alpha:1.0]] ;
    
    CGFloat topBarHeight = [VeamUtil getTopBarHeight] ;
    CGFloat currentY = [VeamUtil getViewTopOffset] ;

    [self addTopBar:YES showSettingsButton:NO] ;
    currentY += topBarHeight ;
    
    CGFloat postWidth = 50 ;
    CGRect postFrame = CGRectMake(topBarTitleMaxRight-postWidth, 0, postWidth, [VeamUtil getTopBarHeight]) ;
    postLabel = [[UILabel alloc] initWithFrame:postFrame] ;
    [postLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [postLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
    [postLabel setBackgroundColor:[UIColor clearColor]] ;
    [postLabel setText:NSLocalizedString(@"post",nil)] ;
    [VeamUtil registerTapAction:postLabel target:self selector:@selector(onPostButtonTap)] ;
    [topBarView addSubview:postLabel] ;

    CGFloat margin = 12 ;
    CGFloat textViewHeight = 90 ;
    CGFloat imageSize = 84 ;
    CGFloat backViewHeight = margin*2+textViewHeight ;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], backViewHeight)] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [self.view addSubview:backView] ;
    
    currentY += backViewHeight ;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY,[VeamUtil getScreenWidth], 1)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [self.view addSubview:lineView] ;
    
    UIImageView *targetImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-imageSize-margin , [VeamUtil getViewTopOffset]+topBarHeight+margin, imageSize, imageSize)] ;
    [targetImageView setImage:targetImage] ;
    CGFloat angle = degree * M_PI / 180.0;
    [targetImageView setTransform:CGAffineTransformMakeRotation(angle)] ;
    [self.view addSubview:targetImageView] ;
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(margin-4, [VeamUtil getViewTopOffset]+topBarHeight+margin, 215, textViewHeight)] ;
    [commentTextView setBackgroundColor:[UIColor clearColor]] ;
    [commentTextView becomeFirstResponder] ;
    [commentTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
    [commentTextView setDelegate:self] ;
    //[commentTextView setText:NSLocalizedString(@"add_a_caption",nil)] ;
    [commentTextView setText:@""] ;
    //[commentTextView setTextColor:[VeamUtil changeColor:[VeamUtil getBaseTextColor] alpha:0.5]] ;
    [commentTextView setTextColor:[VeamUtil getBaseTextColor]] ;
    placeHolderShown = YES ;
    [self.view addSubview:commentTextView] ;
    
    commentPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin+1, [VeamUtil getViewTopOffset]+topBarHeight+margin, 215, 36)] ;
    [commentPlaceHolderLabel setBackgroundColor:[UIColor clearColor]] ;
    [commentPlaceHolderLabel setText:NSLocalizedString(@"add_a_caption",nil)] ;
    [commentPlaceHolderLabel setTextColor:[VeamUtil changeColor:[VeamUtil getBaseTextColor] alpha:0.5]] ;
    [commentPlaceHolderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
    [self.view addSubview:commentPlaceHolderLabel] ;
    
    
    currentY += 12 ;
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin, 20)] ;
    [shareLabel setBackgroundColor:[UIColor clearColor]] ;
    [shareLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
    [shareLabel setText:NSLocalizedString(@"share",nil)] ;
    [shareLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [self.view addSubview:shareLabel] ;
    
    currentY += 20 ;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY,[VeamUtil getScreenWidth], 1)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [self.view addSubview:lineView] ;

    currentY += 1 ;
    UIImage *image = [VeamUtil imageNamed:@"share_facebook_off.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], imageHeight)] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [self.view addSubview:backView] ;
    
    facebookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, currentY,imageWidth , imageHeight)] ;
    [facebookImageView setImage:image] ;
    [VeamUtil registerTapAction:facebookImageView target:self selector:@selector(onFacebookTap)] ;
    [self.view addSubview:facebookImageView] ;
    
    /*
    CGRect imageFrame = facebookImageView.frame ;
    imageFrame.origin.x += 7 ;
    facebookLabel = [[UILabel alloc] initWithFrame:imageFrame] ;
    [facebookLabel setBackgroundColor:[UIColor clearColor]] ;
    [facebookLabel setTextColor:[VeamUtil changeColor:[VeamUtil getBaseTextColor] alpha:0.5]] ;
    [facebookLabel setText:@"Facebook"] ;
    [facebookLabel setTextAlignment:NSTextAlignmentCenter] ;
    [facebookLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
    [self.view addSubview:facebookLabel] ;
     */
    
    image = [VeamUtil imageNamed:@"share_twitter_off.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    twitterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(161, currentY,imageWidth , imageHeight)] ;
    [twitterImageView setImage:image] ;
    [VeamUtil registerTapAction:twitterImageView target:self selector:@selector(onTwitterTap)] ;
    [self.view addSubview:twitterImageView] ;
    CGRect twitterFrame = twitterImageView.frame ;

    lineView = [[UIView alloc] initWithFrame:CGRectMake(160, currentY,1, imageHeight)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [self.view addSubview:lineView] ;

    currentY += imageHeight ;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY,[VeamUtil getScreenWidth], 1)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [self.view addSubview:lineView] ;

    twitterIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    CGRect frame = twitterIndicator.frame ;
    frame.origin.x = twitterFrame.origin.x + (twitterFrame.size.width - frame.size.width) / 2 ;
    frame.origin.y = twitterFrame.origin.y + (twitterFrame.size.height - frame.size.height) / 2 ;
    [twitterIndicator setFrame:frame] ;
    [twitterIndicator setAlpha:0.0] ;
    [self.view addSubview:twitterIndicator] ;

    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
    frame = indicator.frame ;
    frame.origin.x = postFrame.origin.x + (postFrame.size.width - frame.size.width) / 2 ;
    frame.origin.y = postFrame.origin.y + (postFrame.size.height - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator setAlpha:0.0] ;
    [topBarView addSubview:indicator] ;
    
}

- (void)onFacebookTap
{
    if(shouldPostToFacebook){
        shouldPostToFacebook = NO ;
        [facebookImageView setImage:[VeamUtil imageNamed:@"share_facebook_off.png"]] ;
    } else {
        shouldPostToFacebook = YES ;
        [facebookImageView setImage:[VeamUtil imageNamed:@"share_facebook_on.png"]] ;
        if(![[FBSession activeSession] isOpen]){
            [VeamUtil openFacebookSession] ;
        }
    }
}

- (void)startTwitterRequest
{
    twitterReqesting = YES ;
    [twitterIndicator startAnimating] ;
    [twitterIndicator setAlpha:1.0] ;
}

- (void)endTwitterRequest
{
    twitterReqesting = NO ;
    [twitterIndicator setAlpha:0.0] ;
    [twitterIndicator stopAnimating] ;
}

- (void)setTwitterImageOn
{
    [twitterImageView setImage:[VeamUtil imageNamed:@"share_twitter_on.png"]] ;
}

- (void)onTwitterTap
{
    if(!twitterReqesting){
        if(shouldPostToTwitter){
            shouldPostToTwitter = NO ;
            [twitterImageView setImage:[VeamUtil imageNamed:@"share_twitter_off.png"]] ;
        } else {
            if(twitterAccount == nil){
                [self performSelectorOnMainThread:@selector(startTwitterRequest) withObject:nil waitUntilDone:NO] ;
                ACAccountStore *store = [[ACAccountStore alloc] init];
                ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                [store requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:
                    ^(BOOL granted, NSError *error)
                    {
                        //NSLog(@"requestAccessToAccountsWithType CompletionHandler") ;
                        if (granted) {
                            NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
                            if ([twitterAccounts count] > 0) {
                                twitterAccount = [twitterAccounts objectAtIndex:0];
                                shouldPostToTwitter = YES ;
                                [self performSelectorOnMainThread:@selector(setTwitterImageOn) withObject:nil waitUntilDone:NO] ;
                            } else {
                                NSLog(@"No Twitter Account") ;
                            }
                        } else {
                            NSLog(@"Not Granted") ;
                        }
                        [self performSelectorOnMainThread:@selector(endTwitterRequest) withObject:nil waitUntilDone:NO] ;
                    }
                 ];
            } else {
                shouldPostToTwitter = YES ;
                [twitterImageView setImage:[VeamUtil imageNamed:@"share_twitter_on.png"]] ;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReturnButtonTap
{
    //NSLog(@"return button tapped") ;
}


- (UIImage*)rotateImage:(UIImage *)image {
	CGSize imgSize = [image size];
	UIGraphicsBeginImageContext(imgSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
    if(degree == 90){
        CGContextRotateCTM(context, M_PI/2);
        CGContextTranslateCTM(context, 0, -imgSize.height);
    } else if(degree == 180){
        CGContextRotateCTM(context, M_PI) ;
        CGContextTranslateCTM(context, -imgSize.width, -imgSize.height);
    } else if(degree == 270){
        CGContextRotateCTM(context, M_PI*3/2);
        CGContextTranslateCTM(context, -imgSize.width, 0);
    } else {
        CGContextRotateCTM(context, 0);
    }

	[image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (void)onPostButtonTap
{
    //NSLog(@"post button tapped") ;
    NSString *commentText = [commentTextView text] ;
    if([VeamUtil isEmpty:commentText]){
        [VeamUtil dispError:NSLocalizedString(@"please_add_a_caption",nil)] ;
        return ;
    }
    
    // rotate image
    rotatedImage = [self rotateImage:targetImage] ;
    /*
    if(degree == 90){
        rotatedImage = [UIImage imageWithCGImage:targetImage.CGImage scale:targetImage.scale orientation:UIImageOrientationRight] ;
    } else if(degree == 180){
        rotatedImage = [UIImage imageWithCGImage:targetImage.CGImage scale:targetImage.scale orientation:UIImageOrientationDown] ;
    } else if(degree == 270){
        rotatedImage = [UIImage imageWithCGImage:targetImage.CGImage scale:targetImage.scale orientation:UIImageOrientationLeft] ;
    } else {
        rotatedImage = targetImage ;
    }
     */
    
    //UIImageWriteToSavedPhotosAlbum( rotatedImage, nil, nil, nil ) ;

    [postLabel setAlpha:0.0] ;
    [indicator startAnimating] ;
    [indicator setAlpha:1.0] ;
    
    [self sendPostRequest] ;
}

- (void)sendPostRequest
{
    NSURL *url = [VeamUtil getApiUrl:@"forum/postpicture"] ;
    //NSLog(@"url=%@",url.absoluteString);
    
    NSString *comment = [commentTextView text] ;
    //NSString *urlEncodedComment = [VeamUtil urlEncode:comment] ;
    //NSLog(@"urlEncodedMessage = %@",urlEncodedMessage);
    
    NSString *uid = [VeamUtil getUid] ;
    NSInteger socialUserId = [VeamUtil getSocialUserId] ;
    NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%d_%@",uid,(int)socialUserId,comment]] ;
    /*
    NSString *params ;
    params = [NSString stringWithFormat:@"u=%@&sid=%d&c=%@&s=%@",uid,socialUserId,urlEncodedComment,signature] ;
    NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
     */
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url] ;
    [request setHTTPMethod: @"POST"] ;
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSString *boundary = @"0x0hHai1CanHazB0undar135" ;
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] ;
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    //[request setHTTPBody: myRequestData];
    
    NSData *imageData = UIImageJPEGRepresentation(rotatedImage, 0.95);
    
    NSMutableData *body = [NSMutableData data];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[uid dataUsingEncoding:NSUTF8StringEncoding] forKey:@"u"];
    [params setObject:[[NSString stringWithFormat:@"%d",(int)socialUserId] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"sid"];
    [params setObject:[forumId dataUsingEncoding:NSUTF8StringEncoding] forKey:@"f"];
    [params setObject:[comment dataUsingEncoding:NSUTF8StringEncoding] forKey:@"c"];
    [params setObject:[signature dataUsingEncoding:NSUTF8StringEncoding] forKey:@"s"];
    
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
    //NSLog(@"Connection failed: %@", [error localizedDescription]);
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    [VeamUtil dispError:@"Request failed"] ;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"Succeed!! Received %d bytes of data", [buffer length]);
    NSString *contents = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    //NSLog(@"received %@",contents) ;
    NSArray *results = [contents componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    if([results count] >= 7){
        if([[results objectAtIndex:0] compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
            // OK
            // 0
            //
            // 86199
            // veam03
            // 1
            // 2 Pictures

            /*
            NSString *commentId = [results objectAtIndex:1] ;
            NSString *pictureId = [results objectAtIndex:2] ;
            NSString *userId = [results objectAtIndex:3] ;
            NSString *userName = [results objectAtIndex:4] ;
            NSString *comment = [results objectAtIndex:5] ;
             */
            NSString *rewardString = [results objectAtIndex:6] ;
            
            NSInteger count = [results count] ;
            for(int index = 0 ; index < count ; index++){
                //NSLog(@"%d = %@",index,[results objectAtIndex:index]) ;
            }
            
            [VeamUtil setRewardString:rewardString] ;
        }
    }
    
    //NSLog(@"%@", contents);
    buffer = nil ;

    if(shouldPostToFacebook){
        [self postToFacebook] ;
    }
    if(shouldPostToTwitter){
        [self postToTwitter] ;
    }
   
    [VeamUtil setPicturePosted:YES] ;
    
    //NSLog(@"swich to tab bar") ;
    
//#ifdef DO_NOT_USE_ADMOB
    [VeamUtil showTabBarController:-1] ;
/*
#else
    if(interstitial.isReady){
        [interstitial presentFromRootViewController:self] ;
    } else {
        [VeamUtil showTabBarController:-1] ;
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
    [VeamUtil showTabBarController:-1] ;
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store).
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    //NSLog(@"interstitialWillLeaveApplication");
    [VeamUtil showTabBarController:-1] ;
}
#endif
*/





- (void)postToFacebook
{
    //NSLog(@"postToFaceBook") ;
    
    NSString *comment = [commentTextView text] ;
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init] ;
    
    // First request uploads the photo.
    FBRequest *request = [FBRequest requestForUploadPhoto:rotatedImage] ;
    [request.parameters addEntriesFromDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:comment, @"message", nil]];
    [connection addRequest:request completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error)
        {
            if(!error){
                NSLog(@"facebook : completed successfully") ;
            } else {
                NSString *message = [error localizedDescription] ;
                NSLog(@"facebook : completed with error : %@",message) ;
            }
        }
        batchEntryName:@"photopost"
    ];
    
    [connection start] ;
    //NSLog(@"postToFaceBook end") ;
}

- (void)postToTwitter
{
    //NSLog(@"postToTwitter") ;
    NSString *comment = [commentTextView text] ;

    // "https://api.twitter.com/1.1/statuses/update_with_media.json"
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"] parameters:nil requestMethod:TWRequestMethodPOST];
    
    //add text
    [postRequest addMultiPartData:[comment dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
    //add image
    [postRequest addMultiPartData:UIImagePNGRepresentation(rotatedImage) withName:@"media" type:@"multipart/form-data"];
    
    // Set the account used to post the tweet.
    [postRequest setAccount:twitterAccount] ;
    
    // Perform the request created above and create a handler block to handle the response.
    [postRequest performRequestWithHandler:
        ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
        {
            //NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
            if(!error){
                NSLog(@"twitter : completed successfully") ;
            } else {
                NSString *message = [error localizedDescription];
                NSLog(@"twitter : completed with error : %@",message) ;
            }
        }
     ] ;
}



- (void)setCursorToTop
{
    UITextPosition *newPos = [commentTextView positionFromPosition:commentTextView.beginningOfDocument offset:0];
    commentTextView.selectedTextRange = [commentTextView textRangeFromPosition:newPos toPosition:newPos];
    [commentTextView setNeedsLayout];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *comment = [commentTextView text] ;
    //NSLog(@"textViewDidChange %@",comment);
    if([comment isEqualToString:@""]){
        //[commentTextView setText:NSLocalizedString(@"add_a_caption",nil)] ;
        //[commentTextView setTextColor:[VeamUtil changeColor:[VeamUtil getBaseTextColor] alpha:0.5]] ;
        [commentPlaceHolderLabel setAlpha:1.0] ;
        [self setCursorToTop] ;
        placeHolderShown = YES ;
    } else {
        if(placeHolderShown){
            [commentPlaceHolderLabel setAlpha:0.0] ;
            placeHolderShown = NO ;
            /*
                comment = [comment substringToIndex:1] ;
                [commentTextView setText:comment] ;
                [commentTextView setTextColor:[VeamUtil getBaseTextColor]] ;
             */
        }
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSString *comment = [commentTextView text] ;
    //NSLog(@"textViewDidChangeSelection %@",comment);
    if([comment isEqualToString:NSLocalizedString(@"add_a_caption",nil)]){
        if(commentTextView.selectedRange.location > 0){
            [self setCursorToTop] ;
        }
    }
}
/*
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    //NSLog(@"textViewShouldEndEditing %@",[commentTextView text]);
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //NSLog(@"textViewDidEndEditing -%@-",[commentTextView text]);
    if([[commentTextView text] isEqualToString:@""]){
        [commentTextView setText:NSLocalizedString(@"add_a_caption",nil)] ;
        [commentTextView setTextColor:[VeamUtil getColorFromArgbString:@"FF929292"]] ;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // NSLog(@"textViewShouldBeginEditing %@",[comment text]);
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //NSLog(@"textViewDidBeginEditing %@",[commentTextView text]);
    if([[commentTextView text] isEqualToString:NSLocalizedString(@"add_a_caption",nil)]){
        [commentTextView setText:@""] ;
        [commentTextView setTextColor:[UIColor blackColor]] ;
    }
}
*/



@end
