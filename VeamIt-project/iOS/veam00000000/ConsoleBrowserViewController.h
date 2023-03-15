//
//  ConsoleBrowserViewController.h
//  veam00000000
//
//  Created by veam on 3/9/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleBrowserViewController : ConsoleViewController
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
