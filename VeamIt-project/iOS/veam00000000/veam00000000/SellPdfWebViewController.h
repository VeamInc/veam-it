//
//  SellPdfWebViewController.h
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"
#import "Pdf.h"

@interface SellPdfWebViewController : VeamViewController<UIWebViewDelegate>
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

    NSString *urlString ;
    UILabel *urlLabel ;
}

@property (nonatomic, retain) NSString *url ;
@property (nonatomic, retain) Pdf *pdf ;
@property (nonatomic, assign) BOOL shouldReload ;
@property (nonatomic, assign) BOOL showBackButton ;
@property (nonatomic, assign) BOOL showSettingsDoneButton ;

@end
