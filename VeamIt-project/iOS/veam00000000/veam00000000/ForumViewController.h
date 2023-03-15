//
//  ForumViewController.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "LoginPendingOperationDelegate.h"

/*
#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADBannerView.h>
#endif
*/


@interface ForumViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource,LoginPendingOperationDelegate>
{
    UITableView *forumListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    
    NSInteger pendingOperation ;
    
    UITableViewCell *bannerCell ;
    
/*
#ifndef DO_NOT_USE_ADMOB
    GADBannerView *bannerView ;
#endif
 */

}

- (void)updateList ;

- (void)doPendingOperation ;

@end
