//
//  SettingsViewController.h
//  veam31000000
//
//  Created by veam on 7/25/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import <StoreKit/StoreKit.h>


@interface SettingsViewController : VeamViewController<SKPaymentTransactionObserver>
{
    UIScrollView *scrollView ;
    UILabel *facebookLeftLabel ;
    UILabel *facebookRightLabel ;
    UIView *twitterView ;
    UIView *emailView ;
    UIView *bottomView ;
    UIActivityIndicatorView *indicator ;
    UIView *lockView ;
    
    NSTimer *refreshTimer ;
    UILabel *doneLabel ;
    
    CGFloat bottomViewY ;
    
    NSMutableDictionary *handledReceipts ;
}

@end
