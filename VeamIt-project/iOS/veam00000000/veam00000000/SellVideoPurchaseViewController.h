//
//  SellVideoPurchaseViewController.h
//  veam31000015
//
//  Created by veam on 5/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "InAppPurchaseManager.h"
#import "SellVideo.h"
#import <UIKit/UIKit.h>

@interface SellVideoPurchaseViewController : VeamViewController<InAppPurchaseManagerDelegate>
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
@property (nonatomic,retain) SellVideo *sellVideo ;

@end
