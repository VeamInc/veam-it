//
//  SellAudioPurchaseViewController.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "VeamViewController.h"
#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
#import "SellAudio.h"
#import <UIKit/UIKit.h>

@interface SellAudioPurchaseViewController : VeamViewController<InAppPurchaseManagerDelegate>
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
@property (nonatomic,retain) SellAudio *sellAudio ;

@end
