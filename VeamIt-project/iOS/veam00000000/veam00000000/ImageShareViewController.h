//
//  ImageShareViewController.h
//  CameraTest
//
//  Created by veam on 7/9/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"
#import <Accounts/Accounts.h>

/*
#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADInterstitial.h>
#endif
*/

@interface ImageShareViewController : VeamViewController<UITextViewDelegate>
{
    UIActivityIndicatorView *indicator ;
    UIActivityIndicatorView *twitterIndicator ;
    UITextView *commentTextView ;
    UILabel *commentPlaceHolderLabel ;
    NSURLConnection *conn ;
    NSMutableData *buffer ;
    UIImage *rotatedImage ;
    UIImageView *facebookImageView ;
    UILabel *facebookLabel ;
    UIImageView *twitterImageView ;
    UILabel *twitterLabel ;
    BOOL shouldPostToFacebook ;
    BOOL shouldPostToTwitter ;
    ACAccount *twitterAccount ;
    UILabel *postLabel ;
    BOOL placeHolderShown ;
    
    BOOL twitterReqesting ;
/*
#ifndef DO_NOT_USE_ADMOB
    GADInterstitial *interstitial ;
#endif
*/    
}

@property (nonatomic, assign) CGFloat degree ;
@property (nonatomic, retain) UIImage *targetImage ;
@property (nonatomic, retain) NSString *forumId ;

@end
