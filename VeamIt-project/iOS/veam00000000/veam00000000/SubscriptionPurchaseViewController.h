//
//  SubscriptionPurchaseViewController.h
//  veam31000000
//
//  Created by veam on 2/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
#import "VeamViewController.h"

@interface SubscriptionPurchaseViewController : VeamViewController<InAppPurchaseManagerDelegate>
{
    UIScrollView *scrollView ;
    NSMutableArray *workoutListViews ;
    BOOL isBought ;
    UIActivityIndicatorView *indicator ;
    UIView *purchaseView ;
    
    UIView *thankyouView ;
    
    CGFloat margin ;
    
    UILabel *descriptionLabel ;
    UILabel *noteLabel ;
    UILabel *linkTitleLabel ;
    UILabel *linkLabel ;
    UILabel *link ;
    UILabel *buttonLabel ;

}

@property (nonatomic,retain) InAppPurchaseManager *inAppPurchaseManager;

@end
