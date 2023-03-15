//
//  SellSectionPurchaseViewController.h
//  veam00000000
//
//  Created by veam on 11/25/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "InAppPurchaseManager.h"
#import <UIKit/UIKit.h>

@interface SellSectionPurchaseViewController : VeamViewController<InAppPurchaseManagerDelegate>
{
    UIScrollView *scrollView ;
    NSMutableArray *workoutListViews ;
    BOOL isBought ;
    UIActivityIndicatorView *indicator ;
    UIView *purchaseView ;
    
    UIView *thankyouView ;
    
    CGFloat margin ;
    
}

@property (nonatomic,retain) InAppPurchaseManager *inAppPurchaseManager;

@end
