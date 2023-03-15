//
//  SellPdfPurchaseViewController.h
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "VeamViewController.h"
#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
#import "SellPdf.h"
#import <UIKit/UIKit.h>

@interface SellPdfPurchaseViewController : VeamViewController<InAppPurchaseManagerDelegate>
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
@property (nonatomic,retain) SellPdf *sellPdf ;

@end
