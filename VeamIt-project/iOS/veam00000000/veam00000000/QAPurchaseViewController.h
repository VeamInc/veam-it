//
//  QAPurchaseViewController.h
//  veam31000016
//
//  Created by veam on 2/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
#import "VeamViewController.h"

@interface QAPurchaseViewController : VeamViewController<InAppPurchaseManagerDelegate>
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
