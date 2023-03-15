//
//  ConsoleTermsViewController.h
//  veam00000000
//
//  Created by veam on 12/21/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleTermsViewController : ConsoleViewController
{
    UIWebView *webView ;
    UIActivityIndicatorView *indicator ;
    
    UIImageView *forwardImageView ;
    UIImageView *backwardImageView ;
    
    NSTimer *refreshTimer ;
    
    BOOL isShowingNavigationButton ;
    BOOL isForwardButtonOn ;
    BOOL isBackwardButtonOn ;
    BOOL firstAppear ;
    
    UIView *progressView ;
    UIActivityIndicatorView *progressIndicator ;

    UILabel *buttonLabel ;
}

@property (nonatomic, retain) NSString *url ;
@property (nonatomic, assign) BOOL shouldReload ;
@property (nonatomic, assign) BOOL showBackButton ;
@property (nonatomic, assign) BOOL showSettingsDoneButton ;

@end
