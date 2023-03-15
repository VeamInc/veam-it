//
//  WebListViewController.h
//  veam31000000
//
//  Created by veam on 2/26/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"

/*
#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADBannerView.h>
#endif
*/


@interface WebListViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *webListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    NSInteger numberOfWebs ;
    NSArray *webs ;
    
    UITableViewCell *bannerCell ;

/*
#ifndef DO_NOT_USE_ADMOB
    GADBannerView *bannerView ;
#endif
*/
    
}

- (void)updateList ;

@property (nonatomic, retain) NSString *category ;


@end
