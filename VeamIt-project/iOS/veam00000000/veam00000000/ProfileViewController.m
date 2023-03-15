//
//  ProfileViewController.m
//  veam31000000
//
//  Created by veam on 2/7/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ProfileViewController.h"
#import "AGMedallionView.h"
#import "VeamUtil.h"
#import "ProfileData.h"
#import "PictureViewController.h"
#import "FollowViewController.h"
#import "PostDescriptionViewController.h"

#define VEAM_PENDING_OPERATION_FOLLOW               1
#define VEAM_PENDING_OPERATION_EDIT_DESCRIPTION     2

//#define VEAM_USER_DESCRIPTION_HINT   @"(Tap to edit your message)"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize socialUserId ;
@synthesize socialUserName ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
    socialUserId = @"0" ;
    socialUserName = @"Not Logged In" ;
     */
    
    imageDownloadsInProgress = [NSMutableDictionary dictionary] ;
    
    [self setViewName:[NSString stringWithFormat:@"Profile/%@/",socialUserId]] ;

    CGFloat margin = 13 ;
    CGFloat currentY = [VeamUtil getTopBarHeight] ;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTabBarHeight])] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:scrollView] ;

    currentY += 22 ;
    
    CGFloat userNameHeight = 25 ;
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin*2, userNameHeight)] ;
    [userNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22]] ;
    [userNameLabel setText:socialUserName] ;
    [userNameLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [userNameLabel setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:userNameLabel] ;
    currentY += userNameHeight ;
    
    currentY += 3 ;
    
    userImageView = [[AGMedallionView alloc] initWithFrame:CGRectMake(224, currentY, 80, 80)] ;
    userImageView.image = [VeamUtil imageNamed:@"pro_no_image.png"] ;
    [scrollView addSubview:userImageView];
    
    currentY += 4 ;
    
    UIImage *image = [VeamUtil imageNamed:@"pro_description.png"] ;
    CGFloat imageWidth = image.size.width/2 ;
    CGFloat imageHeight = image.size.height/2 ;
    UIImageView *userDescriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, imageHeight)] ;
    [userDescriptionImageView setImage:image] ;
    [scrollView addSubview:userDescriptionImageView] ;
    
    descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(margin+5, currentY+2, 190, imageHeight-6)] ;
    if([self isMyProfile]){
        [descriptionTextView setText:NSLocalizedString(@"tap_to_edit_your_message",nil)] ;
    } else {
        [descriptionTextView setText:@""] ;
    }
    [descriptionTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [descriptionTextView setTextColor:[VeamUtil getBaseTextColor]] ;
    [descriptionTextView setBackgroundColor:[UIColor clearColor]] ;
    [descriptionTextView setEditable:NO] ;
    if([self isMyProfile]){
        [VeamUtil registerTapAction:descriptionTextView target:self selector:@selector(descriptionTapped)] ;
    }
    [scrollView addSubview:descriptionTextView] ;

    currentY += imageHeight ;
    
    currentY += 13 ;

    if([self isMyProfile]){
        image = [VeamUtil imageNamed:@"pro_settings_nolabel.png"] ;
    } else {
        image = [VeamUtil imageNamed:@"pro_base.png"] ;
    }
    imageWidth = image.size.width/2 ;
    imageHeight = image.size.height/2 ;
    actionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, imageHeight)] ;
    [actionImageView setImage:image] ;
    [VeamUtil registerTapAction:actionImageView target:self selector:@selector(actionButtonTap)] ;
    [scrollView addSubview:actionImageView] ;
    
    actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin+34, currentY, [VeamUtil getScreenWidth]-margin*2-50, imageHeight)] ;
    [actionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]] ;
    if([self isMyProfile]){
        [actionLabel setText:NSLocalizedString(@"go_to_settings",nil)] ; // Go to Settings 
    } else {
        [actionLabel setText:@""] ;
    }
    [actionLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ; // FF454545 for follow
    [actionLabel setBackgroundColor:[UIColor clearColor]] ;
    [actionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [scrollView addSubview:actionLabel] ;
    
    currentY += imageHeight ;
    
    currentY += 20 ;

    CGFloat forumTextHeight = 13 ;
    UILabel *forumLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin*2, forumTextHeight)] ;
    [forumLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
    [forumLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [forumLabel setText:@"Forum"] ;
    [forumLabel setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:forumLabel] ;
    currentY += forumTextHeight ;
    
    currentY += 7 ;
    
    listHeight = 45 ;
    iconMargin = 5 ;
    
    UIView *listBackView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], listHeight*3)] ;
    [listBackView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]] ;
    [listBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:listBackView] ;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [scrollView addSubview:lineView] ;
    
    UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin*2, listHeight)] ;
    [postLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]] ;
    [postLabel setText:NSLocalizedString(@"posts",nil)] ;
    [postLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [postLabel setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:postLabel target:self selector:@selector(postsBarTapped)] ;
    [scrollView addSubview:postLabel] ;

    image = [VeamUtil imageNamed:@"pro_post_icon.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    postImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-48-imageWidth, currentY+(listHeight-imageHeight)/2, imageWidth,imageHeight)] ;
    [postImageView setImage:image] ;
    [scrollView addSubview:postImageView] ;
    
    postNumLabel = [[UILabel alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-48, currentY, 14, listHeight)] ;
    [postNumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [postNumLabel setText:@"-"] ;
    [postNumLabel setTextAlignment:NSTextAlignmentRight] ;
    [postNumLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [postNumLabel setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:postNumLabel] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-22, currentY+(listHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [arrowImageView setImage:image] ;
    [scrollView addSubview:arrowImageView] ;
    
    currentY += listHeight ;

    ///// Followers
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [scrollView addSubview:lineView] ;
    
    UILabel *followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin*2, listHeight)] ;
    [followersLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]] ;
    [followersLabel setText:NSLocalizedString(@"followers",nil)] ;
    [followersLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [followersLabel setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:followersLabel target:self selector:@selector(followersBarTapped)] ;
    [scrollView addSubview:followersLabel] ;
    
    image = [VeamUtil imageNamed:@"pro_person_icon.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    followersImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-48-imageWidth, currentY+(listHeight-imageHeight)/2, imageWidth,imageHeight)] ;
    [followersImageView setImage:image] ;
    [scrollView addSubview:followersImageView] ;
    
    followersNumLabel = [[UILabel alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-48, currentY, 14, listHeight)] ;
    [followersNumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [followersNumLabel setText:@"-"] ;
    [followersNumLabel setTextAlignment:NSTextAlignmentRight] ;
    [followersNumLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [followersNumLabel setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:followersNumLabel] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-22, currentY+(listHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [arrowImageView setImage:image] ;
    [scrollView addSubview:arrowImageView] ;
    
    currentY += listHeight ;

    ///// Following
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [scrollView addSubview:lineView] ;
    
    UILabel *followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, [VeamUtil getScreenWidth]-margin*2, listHeight)] ;
    [followingLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]] ;
    [followingLabel setText:NSLocalizedString(@"following",nil)] ;
    [followingLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [followingLabel setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:followingLabel target:self selector:@selector(followingsBarTapped)] ;
    [scrollView addSubview:followingLabel] ;
    
    image = [VeamUtil imageNamed:@"pro_person_icon.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    followingImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-48-imageWidth, currentY+(listHeight-imageHeight)/2, imageWidth,imageHeight)] ;
    [followingImageView setImage:image] ;
    [scrollView addSubview:followingImageView] ;
    
    followingNumLabel = [[UILabel alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-48, currentY, 14, listHeight)] ;
    [followingNumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [followingNumLabel setText:@"-"] ;
    [followingNumLabel setTextAlignment:NSTextAlignmentRight] ;
    [followingNumLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [followingNumLabel setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:followingNumLabel] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-22, currentY+(listHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [arrowImageView setImage:image] ;
    [scrollView addSubview:arrowImageView] ;
    
    currentY += listHeight ;

    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [scrollView addSubview:lineView] ;
    currentY += 1 ;
    
    CGFloat contentHeight = currentY ;
    if(contentHeight <= scrollView.frame.size.height){
        contentHeight = scrollView.frame.size.height+1 ;
    }
    
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], contentHeight)] ;
    
    [self addTopBar:YES showSettingsButton:NO] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    CGRect frame = indicator.frame ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [self.view addSubview:indicator] ;

    [self adjustInfoLayout] ;
    
    [self performSelectorInBackground:@selector(reloadData) withObject:nil] ;

}

- (void)postsBarTapped
{
    if(![VeamUtil isEmpty:socialUserId] && ![socialUserId isEqualToString:@"0"]){
        PictureViewController *pictureViewController = [[PictureViewController alloc] init] ;
        [pictureViewController setForumId:VEAM_SPECIAL_FORUM_ID_USER_POST] ;
        [pictureViewController setTargetSocialUserId:[socialUserId integerValue]] ;
        [pictureViewController setTitleName:[profileData name]] ;
        [self.navigationController pushViewController:pictureViewController animated:YES] ;
    }
}

- (void)followersBarTapped
{
    if(![VeamUtil isEmpty:socialUserId] && ![socialUserId isEqualToString:@"0"]){
        FollowViewController *followViewController = [[FollowViewController alloc] init] ;
        [followViewController setSocialUserId:socialUserId] ;
        [followViewController setFollowKind:VEAM_FOLLOW_KIND_FOLLOWERS] ;
        [followViewController setTitleName:NSLocalizedString(@"followers",nil)] ;
        [followViewController setTopBarIcon:userIconImage] ;
        [followViewController setTopBarIconKind:VEAM_TOP_BAR_ICON_CIRCLE] ;
        [self.navigationController pushViewController:followViewController animated:YES] ;
    }
}

- (void)followingsBarTapped
{
    if(![VeamUtil isEmpty:socialUserId] && ![socialUserId isEqualToString:@"0"]){
        FollowViewController *followViewController = [[FollowViewController alloc] init] ;
        [followViewController setSocialUserId:socialUserId] ;
        [followViewController setFollowKind:VEAM_FOLLOW_KIND_FOLLOWINGS] ;
        [followViewController setTitleName:NSLocalizedString(@"following",nil)] ;
        [followViewController setTopBarIcon:userIconImage] ;
        [followViewController setTopBarIconKind:VEAM_TOP_BAR_ICON_CIRCLE] ;
        [self.navigationController pushViewController:followViewController animated:YES] ;
    }
}


- (BOOL)isMyProfile
{
    BOOL retValue = NO ;
    if([socialUserId isEqualToString:@"0"]){
        retValue = YES ;
    } else if([socialUserId integerValue] == [VeamUtil getSocialUserId]){
        retValue = YES ;
    }
    return retValue ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startIndicator
{
    [indicator startAnimating] ;
    [indicator setHidden:NO] ;
}

- (void)stopIndicator
{
    [indicator setHidden:YES] ;
    [indicator stopAnimating] ;
}

- (void)reloadData
{
    @autoreleasepool
    {
        //NSLog(@"update youtube data start") ;
        isUpdating = YES ;
        [self performSelectorOnMainThread:@selector(startIndicator) withObject:nil waitUntilDone:NO] ;
        if(![VeamUtil isEmpty:socialUserId] && ![socialUserId isEqualToString:@"0"]){
            NSInteger mySocialUserId = 0 ;
            if([VeamUtil isLoggedIn]){
                mySocialUserId = [VeamUtil getSocialUserId] ;
            }
            NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@",socialUserId]] ;
            NSString *urlString = [NSString stringWithFormat:@"%@&tid=%@&mid=%d&s=%@",[VeamUtil getApiUrl:@"socialuser/profile"],socialUserId,mySocialUserId,signature] ;
            NSURL *url = [NSURL URLWithString:urlString] ;
            //NSLog(@"profiledata url : %@",[url absoluteString]) ;
            NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
            NSURLResponse *response = nil ;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            // error
            NSString *error_str = [error localizedDescription];
            if (0 == [error_str length]) {
                ProfileData *workProfileData = [[ProfileData alloc] init] ;
                [workProfileData parseWithData:data] ;
                if([[workProfileData getValueForKey:@"check"] isEqualToString:@"OK"]){
                    profileData = workProfileData ;
                    isFollowing = [profileData isFollowing] ;
                } else {
                    //NSLog(@"get profile failed") ;
                }
            } else {
                NSLog(@"error=%@",error_str) ;
            }
        }
        [self performSelectorOnMainThread:@selector(stopIndicator) withObject:nil waitUntilDone:NO] ;
        isUpdating = NO ;
        //NSLog(@"update youtube data end") ;
    }
    if(profileData != nil){
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO] ;
    }
}

- (void)updateView
{
    //NSLog(@"updateView") ;
    if(profileData != nil){
        [userNameLabel setText:[profileData name]] ;
        
        NSString *description = [profileData description] ;
        if([VeamUtil isEmpty:description] && [self isMyProfile]){
            description = NSLocalizedString(@"tap_to_edit_your_message",nil) ;
        }
        [descriptionTextView setText:description] ;
        
        // set user image
        NSString *imageUrl = [profileData imageUrl] ;
        if(![VeamUtil isEmpty:imageUrl]){
            [self startImageDownload:imageUrl forIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] imageIndex:0] ;
        }
        
        if([self isMyProfile]){
            [actionImageView setImage:[VeamUtil imageNamed:@"pro_settings_nolabel.png"]] ;
            [actionLabel setText:NSLocalizedString(@"go_to_settings",nil)] ;
        } else {
            if(isFollowing){
                [actionImageView setImage:[VeamUtil imageNamed:@"pro_unfollow.png"]] ;
                [actionLabel setText:NSLocalizedString(@"i_am_following",nil)] ;
            } else {
                [actionImageView setImage:[VeamUtil imageNamed:@"pro_follow.png"]] ;
                [actionLabel setText:NSLocalizedString(@"do_follow",nil)] ;
            }
        }
        
        [postNumLabel setText:[NSString stringWithFormat:@"%d",[profileData numberOfPosts]]] ;
        [followersNumLabel setText:[NSString stringWithFormat:@"%d",[profileData numberOfFollowers]]] ;
        [followingNumLabel setText:[NSString stringWithFormat:@"%d",[profileData numberOfFollowings]]] ;
        
        [self adjustInfoLayout] ;
    }
}

- (void)actionButtonTap
{
    if([self isMyProfile]){
        [VeamUtil showSettingsView] ;
    } else {
        [self operateFollowButton] ;
    }
}

- (void)descriptionTapped
{
    [self operateEditButton] ;
}

- (void)operateEditButton
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_EDIT_DESCRIPTION ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        if([VeamUtil isConnected]){
            [self performSelectorOnMainThread:@selector(showPostDescriptionView) withObject:nil waitUntilDone:NO] ;
            
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    }
}

- (void)showPostDescriptionView
{
    PostDescriptionViewController *postDescriptionViewController = [[PostDescriptionViewController alloc] initWithNibName:@"PostDescriptionViewController" bundle:nil] ;
    [postDescriptionViewController setTitleName:NSLocalizedString(@"edit",nil)] ;
    NSString *currentDescription = descriptionTextView.text ;
    if([currentDescription isEqualToString:NSLocalizedString(@"tap_to_edit_your_message",nil)]){
        [postDescriptionViewController setDefaultDescription:@""] ;
    } else {
        [postDescriptionViewController setDefaultDescription:currentDescription] ;
    }
    [self.navigationController pushViewController:postDescriptionViewController animated:YES] ;
}




- (void)operateFollowButton
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_FOLLOW ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        if([VeamUtil isConnected]){
            //NSLog(@"call followThisUser") ;
            [self startIndicator] ;
            [self performSelectorInBackground:@selector(followThisUser) withObject:nil] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    }
}

- (void)followThisUser
{
    @autoreleasepool
    {
        isFollowSending = YES ;
        //NSLog(@"followThisUser") ;
        NSInteger followValue = 1 ;
        if(isFollowing){
            followValue = 0 ;
        }
        
        NSInteger mySocialUserId = [VeamUtil getSocialUserId] ;
        
        NSURL *url = [VeamUtil getApiUrl:@"socialuser/follow"] ;
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%d",socialUserId,mySocialUserId]] ;
        NSString *urlString = [NSString stringWithFormat:@"%@&tid=%@&mid=%d&f=%d&s=%@",[url absoluteString],socialUserId,mySocialUserId,followValue,signature] ;
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"follow url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSArray *results = [resultString componentsSeparatedByString:@"\n"];
            //NSLog(@"count=%d",[results count]) ;
            if([results count] >= 1){
                if([[results objectAtIndex:0] isEqualToString:@"OK"]){
                    //NSLog(@"result OK") ;
                    if(followValue == 1){
                        //[VeamUtil kickKiip:VEAM_KIIP_USER_FOLLOW] ;
                    }
                }
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        //NSLog(@"followThisUser end") ;
        [self performSelectorInBackground:@selector(reloadData) withObject:nil] ;
        isFollowSending = NO ;
    }
}


- (void)doPendingOperation
{
    if(pendingOperation == VEAM_PENDING_OPERATION_FOLLOW){
        pendingOperation = 0 ;
        [self operateFollowButton] ;
    } else if(pendingOperation == VEAM_PENDING_OPERATION_EDIT_DESCRIPTION){
        pendingOperation = 0 ;
        [self operateEditButton] ;
    }
}



- (void)adjustInfoLayout
{
    
    CGRect frame = postNumLabel.frame ;
    CGFloat rightX = frame.origin.x + frame.size.width ;
    
    [postNumLabel sizeToFit] ;
    frame = postNumLabel.frame ;
    CGFloat textX = rightX - frame.size.width ;
    frame.origin.x = textX ;
    frame.size.height = listHeight ;
    [postNumLabel setFrame:frame] ;
    
    frame = postImageView.frame ;
    frame.origin.x = textX - frame.size.width - iconMargin ;
    [postImageView setFrame:frame] ;
    

    [followersNumLabel sizeToFit] ;
    frame = followersNumLabel.frame ;
    textX = rightX - frame.size.width ;
    frame.origin.x = textX ;
    frame.size.height = listHeight ;
    [followersNumLabel setFrame:frame] ;
    
    frame = followersImageView.frame ;
    frame.origin.x = textX - frame.size.width - iconMargin ;
    [followersImageView setFrame:frame] ;

    
    [followingNumLabel sizeToFit] ;
    frame = followingNumLabel.frame ;
    textX = rightX - frame.size.width ;
    frame.origin.x = textX ;
    frame.size.height = listHeight ;
    [followingNumLabel setFrame:frame] ;
    
    frame = followingImageView.frame ;
    frame.origin.x = textX - frame.size.width - iconMargin ;
    [followingImageView setFrame:frame] ;
    
}


- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath] ;
    if(imageDownloader == nil){
        //NSLog(@"new imageDownloader") ;
        imageDownloader = [[ImageDownloader alloc] init] ;
        imageDownloader.indexPathInTableView = indexPath ;
        imageDownloader.imageIndex = imageIndex ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath] ;
        [imageDownloader startDownload] ;
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        userImageView.image = imageDownloader.pictureImage ;
        userIconImage = imageDownloader.pictureImage ;
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated] ;
    
    if([VeamUtil isEmpty:socialUserId] || [socialUserId isEqualToString:@"0"]){
        if([VeamUtil isLoggedIn]){
            socialUserId = [NSString stringWithFormat:@"%d",[VeamUtil getSocialUserId]] ;
            socialUserName = [VeamUtil getSocialUserName] ;
            [VeamUtil setDescriptionPosted:NO] ;
            [self reloadData] ;
        }
    }

    if([VeamUtil getDescriptionPosted]){
        [VeamUtil setDescriptionPosted:NO] ;
        [self reloadData] ;
    }
}


@end
