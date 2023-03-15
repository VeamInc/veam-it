//
//  ProfileViewController.h
//  veam31000000
//
//  Created by veam on 2/7/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"
#import "ProfileData.h"
#import "AGMedallionView.h"
#import "ImageDownloader.h"
#import "AppDelegate.h"

@interface ProfileViewController : VeamViewController<ImageDownloaderDelegate,LoginPendingOperationDelegate>
{
    UIScrollView *scrollView ;
    BOOL isUpdating ;
    BOOL isFollowSending ;
    ProfileData *profileData ;
    BOOL isFollowing ;
    
    UILabel *userNameLabel ;
    AGMedallionView *userImageView ;
    UITextView *descriptionTextView ;
    UIImageView *actionImageView ;
    UILabel *actionLabel ;
    UIImageView *postImageView ;
    UILabel *postNumLabel ;
    UIImageView *followersImageView ;
    UILabel *followersNumLabel ;
    UIImageView *followingImageView ;
    UILabel *followingNumLabel ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    CGFloat listHeight ;
    CGFloat iconMargin ;
    UIActivityIndicatorView *indicator ;
    NSInteger pendingOperation ;
    
    UIImage *userIconImage ;
}

@property (nonatomic, retain) NSString *socialUserId ;
@property (nonatomic, retain) NSString *socialUserName ;

@end
