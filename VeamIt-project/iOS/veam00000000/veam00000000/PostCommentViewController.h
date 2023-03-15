//
//  PostCommentViewController.h
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "Pictures.h"

/*
#ifndef DO_NOT_USE_ADMOB
#import <GoogleMobileAds/GADInterstitial.h>
#endif
*/

@interface PostCommentViewController : VeamViewController
{
    UITextView *commentTextView ;
    UIActivityIndicatorView *indicator ;
    BOOL isPosting ;
    NSURLConnection *conn ;
    NSMutableData *buffer ;
    UILabel *postLabel ;
    
/*
#ifndef DO_NOT_USE_ADMOB
    GADInterstitial *interstitial ;
#endif
*/
    
}

@property (nonatomic, retain) NSString *pictureId ;
@property (nonatomic, retain) Pictures *pictures ;

@end
