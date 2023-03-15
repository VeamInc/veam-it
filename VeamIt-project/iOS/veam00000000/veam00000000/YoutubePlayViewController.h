//
//  YoutubePlayViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "Youtube.h"
#import "Three20/Three20.h"


@interface YoutubePlayViewController : VeamViewController<UIWebViewDelegate,TTNavigatorDelegate> {
    UIWebView *webView ;
    //Youtube *youtube ;
    BOOL appearFlag ;
    NSString *title;
    NSString *duration ;
    UIActivityIndicatorView *indicator ;
    TTNavigator *ttNavigator ;
    UIScrollView *scrollView ;
    BOOL isBrowsing ;
    UIImageView *favoriteImageView ;
}

@property (nonatomic, retain) Youtube *youtube ;

@end
