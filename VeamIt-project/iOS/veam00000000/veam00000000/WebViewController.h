//
//  WebViewController.h
//  veam31000000
//
//  Created by veam on 7/25/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"

@interface WebViewController : VeamViewController<UIWebViewDelegate>
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
}

@property (nonatomic, retain) NSString *url ;
@property (nonatomic, assign) BOOL shouldReload ;
@property (nonatomic, assign) BOOL showBackButton ;
@property (nonatomic, assign) BOOL showSettingsDoneButton ;

@end
