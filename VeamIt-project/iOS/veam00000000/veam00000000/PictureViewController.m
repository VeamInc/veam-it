//
//  PictureViewController.m
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "PictureViewController.h"
#import "VeamUtil.h"
#import "BasicCellViewController.h"
#import "ForumCellViewController.h"
#import "PostCommentViewController.h"
#import "Picture.h"
#import "Comment.h"
#import "NotificationCellViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "FollowViewController.h"
#import "PictureNativeAdCell.h"
/*
#if INCLUDE_KIIP == 1
#import <KiipSDK/KiipSDK.h>
#endif
 */


#define VEAM_PENDING_OPERATION_CAMERA   1
#define VEAM_PENDING_OPERATION_LIKE     2
#define VEAM_PENDING_OPERATION_COMMENT  3

#define VEAM_DEFAULT_COMMENT_COUNT      3
#define VEAM_VIEW_COMMENT_SCHEMA        @"viewallcomments"
#define VEAM_CLOSE_COMMENT_SCHEMA       @"closeallcomments"
#define VEAM_VIEW_PROFILE_SCHEMA        @"viewprofile"




@interface PictureViewController ()

@end

@implementation PictureViewController

@synthesize forumId ;
@synthesize forumKind ;
@synthesize targetSocialUserId ;

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
    [super viewDidLoad] ;
    // Do any additional setup after loading the view from its nib.
    
    [self setViewName:[NSString stringWithFormat:@"Forum/%@/%@/",forumId,self.titleName]] ;

//#ifdef DO_NOT_USE_ADMOB
#define ADMOB_BANNER_HEIGHT 1.0
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
    /*
#else
#define ADMOB_BANNER_HEIGHT 270.0
    UIView *bannerBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 250)] ;
    [bannerBaseView setBackgroundColor:[UIColor clearColor]] ;
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
    bannerView.adUnitID = VEAM_ADMOB_UNIT_ID_FORUM ;
    bannerView.rootViewController = self ;
    bannerView.delegate = self ;
    [bannerView loadRequest:[VeamUtil getAdRequest]];
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
    [bannerCell addSubview:bannerBaseView] ;
    [bannerBaseView addSubview:bannerView] ;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 269, 300, 1)] ;
    [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
    [bannerCell addSubview:lineView] ;
#endif
     */
    
    numberOfPicturesBetweenAds = [VeamUtil getNumberOfPicturesBetweenAds] ;
    nativeAdHeight = [VeamUtil getPictureNativeAdHeight] ;
    nativeAdCellHeight = nativeAdHeight + 20 ;
    
    //NSLog(@"numberOfPicturesBetweenAds=%d , nativeAdHeight=%f",numberOfPicturesBetweenAds,nativeAdHeight) ;
    
    
    reportImage = [VeamUtil imageNamed:@"report.png"] ;
    
    isPostViewShown = NO ;
    isUpdating = NO ;
    
    pictures = [[Pictures alloc] init] ;
    [pictures setNumberOfPicturesBetweenAds:numberOfPicturesBetweenAds] ;
    imageDownloadsInProgressForUser = [NSMutableDictionary dictionary];
    imageDownloadsInProgressForPicture = [NSMutableDictionary dictionary];
    pictureListTableView = nil ;
    currentPageNo = 1 ;
    

    pictureNativeViewCells = [NSMutableDictionary dictionary] ;
    pictureNativeAdLoadRows = [NSMutableArray array] ;
    
    pictureListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    //[pictureListTableView registerClass:[PictureNativeAdCell class] forCellReuseIdentifier:@"NATIVE_AD"] ;
    [pictureListTableView setDelegate:self] ;
    [pictureListTableView setDataSource:self] ;
    [pictureListTableView setBackgroundColor:[UIColor clearColor]] ;
    [pictureListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [pictureListTableView setAlpha:0.0] ;
    [pictureListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:pictureListTableView] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    CGRect frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator startAnimating] ;
    [self.view addSubview:indicator] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
    
    if(![forumId isEqualToString:@"0"] &&
       ![forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_MY_POST] &&
       ![forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_USER_POST] &&
       ![forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_FAVORITES] &&
       ![forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_FOLLOWINGS] &&
       ![forumKind isEqualToString:VEAM_FORUM_KIND_HOT]
      ){
        UIImage *image = [VeamUtil imageNamed:@"camera_button.png"] ;
        CGFloat imageWidth = image.size.width / 2 ;
        CGFloat imageHeight = image.size.height / 2 ;
        cameraButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(topBarTitleMaxRight - 5 - imageWidth, ([VeamUtil getTopBarHeight] - imageHeight)/2 + 3, imageWidth, imageHeight)] ;
        [cameraButtonImageView setImage:image] ;
        [VeamUtil registerTapAction:cameraButtonImageView target:self selector:@selector(onCameraButtonTap)] ;
        [topBarView addSubview:cameraButtonImageView] ;
        topBarTitleMaxRight = cameraButtonImageView.frame.origin.x ;
        [self restrictTopBarLabelWidth] ;
        if([forumKind isEqualToString:VEAM_FORUM_KIND_RESTRICTED]){
            [cameraButtonImageView setHidden:YES] ;
        }
    }
    
    
    [self performSelectorInBackground:@selector(updatePictures) withObject:nil] ;
    
    ttNavigator = [TTNavigator navigator] ;
    //ttNavigator.delegate = self ;
    
    showAllCommentsFlags = [[NSMutableDictionary alloc] init] ;
    
}

- (void)onCameraButtonTap
{
    //NSLog(@"camera tapped") ;
    [self operateCameraButton] ;
}

- (void)operateCameraButton
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_CAMERA ;
        pendingTag = 0 ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        [VeamUtil showCameraView:forumId] ;
    }
}
    
-(void)updatePictures
{
    @autoreleasepool
    {
        //NSLog(@"update pictures start") ;
        isUpdating = YES ;
        NSURL *url = [VeamUtil getApiUrl:@"forum/picturelist"] ;

        NSString *urlString = nil ;
        if([forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_FAVORITES]){
            NSString *favoriteString = [VeamUtil getFavoritesForKind:VEAM_FAVORITE_KIND_PICTURE] ;
            if([VeamUtil isEmpty:favoriteString]){
                [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO] ;
                return ;
            } else {
                NSString *favoriteIds = [NSString stringWithFormat:@"f:%@",favoriteString] ;
                urlString = [NSString stringWithFormat:@"%@&f=%@&p=%d&s=%d",[url absoluteString],favoriteIds,currentPageNo,[VeamUtil getSocialUserId]] ;
            }
        } else if([forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_USER_POST]){
            //urlString = [NSString stringWithFormat:@"%@&f=%@&p=%d&s=%d",[url absoluteString],VEAM_SPECIAL_FORUM_ID_MY_POST,currentPageNo,targetSocialUserId] ;
            urlString = [NSString stringWithFormat:@"%@&f=%@:%d&p=%d&s=%d",[url absoluteString],VEAM_SPECIAL_FORUM_ID_USER_POST,targetSocialUserId,currentPageNo,[VeamUtil getSocialUserId]] ;
        } else {
            NSInteger socialUserId = [VeamUtil getSocialUserId] ;
            if(([forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_MY_POST] ||
                [forumId isEqualToString:VEAM_SPECIAL_FORUM_ID_FOLLOWINGS])
                && (socialUserId == 0)){
                [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO] ;
                return ;
            }
            urlString = [NSString stringWithFormat:@"%@&f=%@&p=%d&s=%d",[url absoluteString],forumId,currentPageNo,socialUserId] ;
        }

        
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"update url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            if(currentPageNo == 1){
                Pictures *workPictures = [[Pictures alloc] init] ;
                [workPictures setNumberOfPicturesBetweenAds:numberOfPicturesBetweenAds] ;
                [workPictures parseWithData:data] ;
                pictures = workPictures ;
            } else {
                [pictures parseWithData:data] ; // add
            }
            NSString *forumUserPermission = [pictures getValueForKey:@"forum_user_permission"] ;
            if((forumUserPermission != nil) && [forumUserPermission isEqualToString:@"1"]){
                [self performSelectorOnMainThread:@selector(showUploadButton) withObject:nil waitUntilDone:NO] ;
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        isUpdating = NO ;
        //NSLog(@"update pictures end") ;
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
}

- (void)showUploadButton
{
    if(cameraButtonImageView != nil){
        [cameraButtonImageView setHidden:NO] ;
    }
}

- (void)reloadData
{
    //NSLog(@"reloadData") ;
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    [pictureListTableView reloadData] ;
    CGRect frame = [pictureListTableView frame] ;
    frame.origin.y = [VeamUtil getViewTopOffset] ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3] ;
    [pictureListTableView setAlpha:1.0] ;
    [pictureListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
}

- (void)hideIndicator
{
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
}


/*
- (void)reloadData
{
    //NSLog(@"reloadData") ;
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.1] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(doReloadData)] ;
    [pictureListTableView setAlpha:0.0] ;
    [UIView commitAnimations] ;
}

- (void)doReloadData
{
    [pictureListTableView reloadData] ;
    CGRect frame = [pictureListTableView frame] ;
    frame.origin.y = 0 ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3] ;
    [pictureListTableView setAlpha:1.0] ;
    [pictureListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForUser ;
            break;
        case 2:
            imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
            break;
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if(imageDownloader == nil){
        //NSLog(@"new imageDownloader") ;
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.imageIndex = imageIndex ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload] ;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0 ;
    if(indexPath.row == 0){
        height = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == 1){
        height = ADMOB_BANNER_HEIGHT ;
    } else if(indexPath.row == (numberOfPictures+2)){
        if([pictures noMorePictures]){
            height = 50 ;
        } else {
            height = 100 ;
        }
    } else {
        NSInteger index = indexPath.row - 2 ;
        Picture *picture = [pictures getPictureAt:index] ;
        if([[picture pictureId] isEqualToString:@"AD"]){
            height = nativeAdCellHeight ;
        } else {
            TTStyledTextLabel *label = [self getCommentLabel:indexPath.row-2] ;
            height = 400 + label.frame.size.height ;
        }
    }
    return height ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (void)clearPictureNativeAdCache
{
    NSInteger maxCache = 5 ;
    NSArray *keys = [pictureNativeViewCells allKeys] ;
    int stackCount = [pictureNativeAdLoadRows count] ;
    int keysCount = [keys count] ;
    //NSLog(@"pictureNativeViewCells count=%d",keysCount) ;
    if(keysCount > maxCache){
        int removeCount = keysCount - maxCache ;
        for(int index = 0 ; index < keysCount ; index++){
            NSString *rowString = [keys objectAtIndex:index] ;
            BOOL shouldBeRemain = NO ;
            int checkCount = maxCache ;
            if(checkCount > stackCount){
                checkCount = stackCount ;
            }
            for(int stackIndex = 0 ; stackIndex < checkCount ; stackIndex++){
                if([rowString isEqualToString:[pictureNativeAdLoadRows objectAtIndex:stackIndex]]){
                    shouldBeRemain = YES ;
                    break ;
                }
            }
            if(!shouldBeRemain){
                //NSLog(@"clear pictureNativeAd for %@",rowString) ;
                [pictureNativeViewCells removeObjectForKey:rowString] ;
                removeCount-- ;
                if(removeCount == 0){
                    break ;
                }
            }
        }
    }
}

- (PictureNativeAdCell *)getPictureNativeAdCell:(NSInteger)row
{
    NSString *rowString = [NSString stringWithFormat:@"%d",row] ;
    PictureNativeAdCell *pictureNativeAdCell = [pictureNativeViewCells objectForKey:rowString] ;
    if(pictureNativeAdCell == nil){
        //NSLog(@"new nativeCell for %d",row) ;
        pictureNativeAdCell = [[PictureNativeAdCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], nativeAdCellHeight)] ;
        
        //NSLog(@"set native ad %@",VEAM_ADMOB_UNIT_ID_FORUM_NATIVE) ;
        UIView *bannerBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, nativeAdHeight)] ;
        [bannerBaseView setBackgroundColor:[UIColor clearColor]] ;
        [pictureNativeAdCell showIndicator:nativeAdCellHeight] ;
        
        nativeExpressAdView = [[GADNativeExpressAdView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(300, nativeAdHeight))];
        nativeExpressAdView.adUnitID = VEAM_ADMOB_UNIT_ID_FORUM_NATIVE ;
        //nativeExpressAdView.adUnitID = @"ca-app-pub-3940256099942544/2562852117" ; // TEST UNIT ID
        nativeExpressAdView.rootViewController = self ;
        nativeExpressAdView.delegate = self ;
        [nativeExpressAdView setTag:row] ;
        [nativeExpressAdView loadRequest:[VeamUtil getAdRequest]];
        [pictureNativeAdCell setFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], nativeAdCellHeight)] ;
        [pictureNativeAdCell setBackgroundColor:[UIColor clearColor]] ;
        [pictureNativeAdCell addSubview:bannerBaseView] ;
        [bannerBaseView addSubview:nativeExpressAdView] ;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, nativeAdCellHeight-1, 300, 1)] ;
        [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
        [pictureNativeAdCell setIsAssigned:YES] ;
        pictureNativeAdCell.row = row ;
        [pictureNativeAdCell addSubview:lineView] ;
        
        [pictureNativeViewCells setObject:pictureNativeAdCell forKey:rowString] ;
    } else {
        //NSLog(@"reuse NATIVE_AD") ;
    }
    
    [pictureNativeAdLoadRows removeObject:rowString] ;
    [pictureNativeAdLoadRows insertObject:rowString atIndex:0] ;
    [self clearPictureNativeAdCache] ;
    
    return pictureNativeAdCell ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numberOfPictures = [pictures getNumberOfPictures] ;
    NSInteger retInt = numberOfPictures ;
    retInt += 3 ; // spacer
    //NSLog(@"number of rows : %d",retInt) ;
    if(numberOfPicturesBetweenAds > 0){
        if(numberOfPicturesBetweenAds < numberOfPictures){
            // load first ad
            PictureNativeAdCell *pictureNativeAdCell = [self getPictureNativeAdCell:numberOfPicturesBetweenAds+2] ;
        }
    }
    return retInt ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"cellForRowAtIndexPath row=%d",indexPath.row) ;
    
    UITableViewCell *cell ;
    
    if(indexPath.row == 0){
        // notification
        
        NotificationCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:@"Notification"] ;
        if (notificationCell == nil) {
            NotificationCellViewController *controller = [[NotificationCellViewController alloc] initWithNibName:@"NotificationCell" bundle:nil] ;
            notificationCell = (NotificationCell *)controller.view ;
        }
        
        if(isUpdating){
            [notificationCell.indicator startAnimating] ;
            [notificationCell.indicator setAlpha:1.0] ;
            [notificationCell.updatingLabel setAlpha:1.0] ;
            [notificationCell.instructionLabel setAlpha:0.0] ;
        } else {
            [notificationCell.indicator stopAnimating] ;
            [notificationCell.indicator setAlpha:0.0] ;
            [notificationCell.updatingLabel setAlpha:0.0] ;
            if([tableView contentOffset].y < -50){
                [notificationCell.instructionLabel setAlpha:1.0] ;
            } else {
                [notificationCell.instructionLabel setAlpha:0.0] ;
            }
        }

        cell = notificationCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else if(indexPath.row == 1){
        cell = bannerCell ;
    } else if(indexPath.row == (numberOfPictures+2)){
        // spacer
        if([pictures noMorePictures] || (numberOfPictures == 0)){
            cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
            }
        } else {
            //NSLog(@"last cell %d : update",indexPath.row) ;
            NotificationCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:@"Notification"] ;
            if (notificationCell == nil) {
                NotificationCellViewController *controller = [[NotificationCellViewController alloc] initWithNibName:@"NotificationCell" bundle:nil] ;
                notificationCell = (NotificationCell *)controller.view ;
            }
            [notificationCell.indicator startAnimating] ;
            [notificationCell.indicator setAlpha:1.0] ;
            [notificationCell.updatingLabel setAlpha:1.0] ;
            [notificationCell.instructionLabel setAlpha:0.0] ;
            cell = notificationCell ;
            if(!isUpdating){
                currentPageNo++ ;
                [self performSelectorInBackground:@selector(updatePictures) withObject:nil] ;
            }
        }
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else {
        NSInteger index = indexPath.row - 2 ;
        Picture *picture = [pictures getPictureAt:index] ;
        if([[picture pictureId] isEqualToString:@"AD"]){
            // native
            PictureNativeAdCell *nativeCell = [self getPictureNativeAdCell:indexPath.row] ;
            
            if(numberOfPicturesBetweenAds > 0){
                if((indexPath.row + numberOfPicturesBetweenAds + 1) < numberOfPictures + 2){
                    // load next ad
                    PictureNativeAdCell *pictureNativeAdCell = [self getPictureNativeAdCell:indexPath.row + numberOfPicturesBetweenAds + 1] ;
                }
            }

            /*
            if(nativeCell.row != indexPath.row){
                NSLog(@"new nativeCell") ;
                nativeCell = [[PictureNativeAdCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NATIVE_AD"] ;
            }
            
            if(!nativeCell.isAssigned){
                NSLog(@"set native ad %@",VEAM_ADMOB_UNIT_ID_FORUM_NATIVE) ;
                UIView *bannerBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 270)] ;
                [bannerBaseView setBackgroundColor:[UIColor clearColor]] ;
                
                CGFloat indicatorSize = 30 ;
                UIActivityIndicatorView *loadAdIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
                [loadAdIndicator setFrame:CGRectMake((320-indicatorSize) / 2, (nativeAdCellHeight-indicatorSize)/2, indicatorSize, indicatorSize)] ;
                [loadAdIndicator startAnimating] ;
                [nativeCell addSubview:loadAdIndicator] ;
                

                nativeExpressAdView = [[GADNativeExpressAdView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(300, 270))];
                //nativeExpressAdView.adUnitID = VEAM_ADMOB_UNIT_ID_FORUM_NATIVE ;
                nativeExpressAdView.adUnitID = @"ca-app-pub-3940256099942544/2562852117" ; // TEST UNIT ID 
                nativeExpressAdView.rootViewController = self ;
                nativeExpressAdView.delegate = self ;
                [nativeExpressAdView loadRequest:[VeamUtil getAdRequest]];
                //nativeCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], nativeAdCellHeight)] ;
                //nativeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NATIVE_AD"] ;
                [nativeCell setFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], nativeAdCellHeight)] ;
                [nativeCell setBackgroundColor:[UIColor clearColor]] ;
                [nativeCell addSubview:bannerBaseView] ;
                [bannerBaseView addSubview:nativeExpressAdView] ;
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, nativeAdCellHeight-1, 300, 1)] ;
                [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
                [nativeCell setIsAssigned:YES] ;
                nativeCell.row = indexPath.row ;
                [nativeCell addSubview:lineView] ;
            } else {
                NSLog(@"reuse NATIVE_AD") ;
            }
             */
            cell = nativeCell ;
        } else {
            ForumCell *forumCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
            //ForumCell *forumCell = nil ;
            if (forumCell == nil) {
                ForumCellViewController *controller = [[ForumCellViewController alloc] initWithNibName:@"ForumCell" bundle:nil] ;
                forumCell = (ForumCell *)controller.view ;
            }
            [[forumCell userNameLabel] setText:[picture ownerName]] ;
            [[forumCell userNameLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [VeamUtil registerTapAction:forumCell.userNameLabel target:self selector:@selector(onUserImageTap:)] ;
            [forumCell.userNameLabel setTag:index] ;
            
            
            [[forumCell likeLabel] setText:[NSString stringWithFormat:@"%d",[picture numberOfLikes]]] ;
            [[forumCell likeLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[forumCell likeLabel] sizeToFit] ;
            CGRect frame = [[forumCell likeLabel] frame] ;
            frame.origin.x = forumCell.frame.size.width - 10 - frame.size.width ;
            [[forumCell likeLabel] setFrame:frame] ;
            
            CGRect likeFrame = [[forumCell likeImageView] frame] ;
            likeFrame.origin.x = frame.origin.x - likeFrame.size.width - 5 ;
            [[forumCell likeImageView] setFrame:likeFrame] ;
            
            UIImage *ownerIconImage = [VeamUtil getCachedImage:[picture ownerIconUrl] downloadIfNot:NO] ;
            if(ownerIconImage == nil){
                [self startImageDownload:[picture ownerIconUrl] forIndexPath:indexPath imageIndex:1] ;
            } else {
                [forumCell.userImageView setImage:ownerIconImage] ;
            }
            
            [VeamUtil registerTapAction:forumCell.userImageView target:self selector:@selector(onUserImageTap:)] ;
            [forumCell.userImageView setTag:index] ;
            
            
            UIImage *pictureImage = [VeamUtil getCachedImage:[picture pictureUrl] downloadIfNot:NO] ;
            if(pictureImage == nil){
                [self startImageDownload:[picture pictureUrl] forIndexPath:indexPath imageIndex:2] ;
                [forumCell.pictureImageIndicator setActivityIndicatorViewStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
                [forumCell.pictureImageIndicator startAnimating] ;
                [forumCell.pictureImageIndicator setHidden:NO] ;
            } else {
                [forumCell.pictureImageView setImage:pictureImage] ;
            }
            
            if(forumCell.commentLabel != nil){
                [forumCell.commentLabel removeFromSuperview] ;
                forumCell.commentLabel = nil ;
            }
            
            TTStyledTextLabel *commentLabel = [self getCommentLabel:index] ;
            forumCell.commentLabel = commentLabel ;
            [forumCell.contentView addSubview:commentLabel] ;
            [VeamUtil registerTapAction:forumCell.commentButtonImageView target:self selector:@selector(onCommentButtonTap:)] ;
            forumCell.commentButtonImageView.tag = index ;
            
            CGRect lineFrame = forumCell.lineView.frame ;
            lineFrame.origin.y = commentLabel.frame.origin.y + commentLabel.frame.size.height + 32 ;
            [forumCell.lineView setFrame:lineFrame] ;
            [forumCell.lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
            
            int commentCount = [self getCommentCount:index] ;
            CGRect reportFrame = forumCell.reportImageView.frame ;
            if(commentCount <= 3){
                reportFrame.origin.y = lineFrame.origin.y - 32 ;
            } else {
                reportFrame.origin.y = lineFrame.origin.y - 48 ;
            }
            [forumCell.reportImageView setFrame:reportFrame] ;
            [forumCell.contentView bringSubviewToFront:forumCell.reportImageView] ;
            
            NSInteger socialUserId = [VeamUtil getSocialUserId] ;
            if([[picture ownerUserId] integerValue] == socialUserId){
                [forumCell.deleteButtonImageView setHidden:NO] ;
                [forumCell.deleteButtonImageView setTag:index] ;
                [VeamUtil registerTapAction:forumCell.deleteButtonImageView target:self selector:@selector(onDeleteButtonTap:)] ;
            } else {
                [forumCell.deleteButtonImageView setHidden:YES] ;
                [forumCell.deleteButtonImageView setTag:-1] ;
            }
            
            if([picture isLike]){
                [forumCell.likeButtonImageView setImage:[VeamUtil imageNamed:@"forum_like_button_on.png"]] ;
            }
            
            [VeamUtil registerTapAction:forumCell.likeButtonImageView target:self selector:@selector(onLikeButtonTap:)] ;
            [forumCell.likeButtonImageView setTag:index] ;
            
            
            [VeamUtil registerTapAction:forumCell.likeImageView target:self selector:@selector(onShowLikerTap:)] ;
            [forumCell.likeImageView setTag:index] ;
            [VeamUtil registerTapAction:forumCell.likeLabel target:self selector:@selector(onShowLikerTap:)] ;
            [forumCell.likeLabel setTag:index] ;

            
            
            
            if([VeamUtil isFavoritePicture:[picture pictureId]]){
                [forumCell.favoriteButtonImageView setImage:[VeamUtil imageNamed:@"add_on.png"]] ;
            }
            
            [VeamUtil registerTapAction:forumCell.favoriteButtonImageView target:self selector:@selector(onFavoritePictureButtonTap:)] ;
            [forumCell.favoriteButtonImageView setTag:index] ;
            
            [VeamUtil registerTapAction:forumCell.reportImageView target:self selector:@selector(onReportButtonTap:)] ;
            [forumCell.reportImageView setTag:index] ;
            
            [forumCell.timeLabel setText:[VeamUtil getTimeDescription:[picture createdAt]]] ;
            [forumCell.timeLabel setTextColor:[VeamUtil getBaseTextColor]] ;
            
            [forumCell.likeImageView setImage:[VeamUtil imageNamed:@"like.png"]] ;
            [forumCell.reportImageView setImage:[VeamUtil imageNamed:@"report.png"]] ;
            [forumCell.commentImageView setImage:[VeamUtil imageNamed:@"forum_comment.png"]] ;

            
            
            
            
            [forumCell setBackgroundColor:[UIColor clearColor]] ;
            [forumCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;

            cell = forumCell ;
        }
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)onFavoritePictureButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onLikeButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    UIImageView *imageView = (UIImageView *)[singleTapGesture view] ;
    Picture *picture = [pictures getPictureAt:tag] ;
    NSString *pictureId = [picture pictureId] ;
    if([VeamUtil isFavoritePicture:pictureId]){
        [imageView setImage:[VeamUtil imageNamed:@"add_off.png"]] ;
        [VeamUtil deleteFavoritePicture:pictureId] ;
    } else {
        [imageView setImage:[VeamUtil imageNamed:@"add_on.png"]] ;
        [VeamUtil addFavoritePicture:pictureId] ;
        //[VeamUtil kickKiip:VEAM_KIIP_PICTURE_FAVORITE] ;
    }
}

- (void)onUserImageTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onLikeButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    Picture *picture = [pictures getPictureAt:tag] ;

    [self showProfileView:[picture ownerUserId] socialUserName:[picture ownerName]] ;
}

- (void)showProfileView:(NSString *)socialUserId socialUserName:(NSString *)socialUserName
{
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init] ;
    [profileViewController setSocialUserId:socialUserId] ;
    [profileViewController setSocialUserName:socialUserName] ;
    [profileViewController setTitleName:NSLocalizedString(@"profile",nil)] ;
    [self.navigationController pushViewController:profileViewController animated:YES] ;
}



- (NSInteger)getCommentCount:(NSInteger)index
{
    Picture *picture = [pictures getPictureAt:index] ;
    NSArray *comments = [picture comments] ;
    NSInteger count = [comments count] ;
    return count ;
}

- (void)onReportButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onReportButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    currentPicture = [pictures getPictureAt:tag] ;
    
    reportAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"report_inappropriate_photo",nil)
                                                 message:NSLocalizedString(@"why_are_you_reporting_this_photo",nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"cancel",nil)
                                       otherButtonTitles:NSLocalizedString(@"report",nil), nil] ;
    [reportAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput] ;
    [reportAlertView show];
    
}



- (void)onCommentButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"tag=%d",tag) ;
    [self operateCommentButton:tag] ;
}

- (void)doPendingCommentButton
{
    [self operateCommentButton:pendingTag] ;
}

- (void)operateCommentButton:(NSInteger)tag
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_COMMENT ;
        pendingTag = tag ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        Picture *picture = [pictures getPictureAt:tag] ;
        PostCommentViewController *postCommentViewController = [[PostCommentViewController alloc] initWithNibName:@"PostCommentViewController" bundle:nil] ;
        [postCommentViewController setPictureId:[picture pictureId]] ;
        [postCommentViewController setTitleName:NSLocalizedString(@"comment",nil)] ;
        [postCommentViewController setPictures:pictures] ;
        [self.navigationController pushViewController:postCommentViewController animated:YES] ;
        isPostViewShown = YES ;
    }
}

- (void)onDeleteButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onDeleteButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    currentPicture = [pictures getPictureAt:tag] ;
    
    // 'Are you sure you want to remove?'
    deleteAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"confirmation",nil) message:NSLocalizedString(@"are_you_sure_you_want_to_remove",nil)
                              delegate:self cancelButtonTitle:NSLocalizedString(@"no",nil) otherButtonTitles:NSLocalizedString(@"yes",nil), nil];
    [deleteAlertView show];
}

- (void)onLikeButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onLikeButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    
    if(isLikeSending){
        return ;
    }
    
    
    // 押されたらとりあえず変更する
    UIImageView *imageView = (UIImageView *)[singleTapGesture view] ;
    Picture *picture = [pictures getPictureAt:tag] ;
    if([picture isLike]){
        [imageView setImage:[VeamUtil imageNamed:@"forum_like_button_off.png"]] ;
    } else {
        [imageView setImage:[VeamUtil imageNamed:@"forum_like_button_on.png"]] ;
    }
    
    [self operateLikeButton:tag] ;
}

- (void)operateLikeButton:(NSInteger)tag
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_LIKE ;
        pendingTag = tag ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        currentPicture = [pictures getPictureAt:tag] ;
        if([VeamUtil isConnected]){
            //NSLog(@"call likeCurrentPicture") ;
            [self performSelectorInBackground:@selector(likeCurrentPicture) withObject:nil] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    }
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == deleteAlertView){
        switch (buttonIndex) {
            case 0:
                // No tapped
                break;
            case 1:
                // Yes tapped
                if([VeamUtil isConnected]){
                    [self performSelectorInBackground:@selector(deleteCurrentPicture) withObject:nil] ;
                } else {
                    [VeamUtil dispNotConnectedError] ;
                }
                break;
        }
    } else if(alertView == reportAlertView){
        if(buttonIndex == 1){
            currentReportMessage = [[alertView textFieldAtIndex:0] text] ;
            if(currentReportMessage == nil){
                currentReportMessage = @"" ;
            }
            //NSLog(@"send report : %@",currentReportMessage) ;
            if([VeamUtil isConnected]){
                [self performSelectorInBackground:@selector(reportCurrentPicture) withObject:nil] ;
            } else {
                [VeamUtil dispNotConnectedError] ;
            }
        }
    }
}

- (void)reportCurrentPicture
{
    @autoreleasepool
    {
        BOOL reportSuccess = NO ;
        //NSLog(@"reportCurrentPicture") ;
        NSString *pictureId = [currentPicture pictureId] ;
        NSString *message = currentReportMessage ;
        NSString *urlEncodedMessage = [VeamUtil urlEncode:message] ;
        
        NSInteger socialUserid = [VeamUtil getSocialUserId] ;
        
        NSURL *url = [VeamUtil getApiUrl:@"forum/reportpicture"] ;
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%d",pictureId,socialUserid]] ;
        NSString *urlString = [NSString stringWithFormat:@"%@&p=%@&m=%@&sid=%d&s=%@",[url absoluteString],pictureId,urlEncodedMessage,socialUserid,signature] ;
        
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"report url : %@",[url absoluteString]) ;
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
                    // OK
                    //NSLog(@"reportCurrentPicture success") ;
                    reportSuccess = YES ;
                }
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        
        if(reportSuccess){
            [self performSelectorOnMainThread:@selector(showReportSuccess) withObject:nil waitUntilDone:NO] ;
        } else {
            [self performSelectorOnMainThread:@selector(showReportFailed) withObject:nil waitUntilDone:NO] ;
        }
        //NSLog(@"reportCurrentPicture end") ;
    }
}

- (void)showReportSuccess
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"message_sent",nil) message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
    [alert show];
}

- (void)showReportFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"failed_to_send_message",nil) message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
    [alert show];
}


- (void)deleteCurrentPicture
{
    @autoreleasepool
    {
        //NSLog(@"deleteCurrentPicture") ;
        NSString *pictureId = [currentPicture pictureId] ;
        NSInteger socialUserid = [VeamUtil getSocialUserId] ;
        if([[currentPicture ownerUserId] integerValue] == socialUserid){
            NSURL *url = [VeamUtil getApiUrl:@"forum/deletepicture"] ;
            NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%d",pictureId,socialUserid]] ;
            NSString *urlString = [NSString stringWithFormat:@"%@&p=%@&sid=%d&s=%@",[url absoluteString],pictureId,socialUserid,signature] ;
            url = [NSURL URLWithString:urlString] ;
            //NSLog(@"delete url : %@",[url absoluteString]) ;
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
                        [pictures deletePicture:currentPicture] ;
                    }
                }
            } else {
                NSLog(@"error=%@",error_str) ;
            }
        }
        //NSLog(@"deleteCurrentPicture end") ;
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
}

- (void)likeCurrentPicture
{
    @autoreleasepool
    {
        isLikeSending = YES ;
        //NSLog(@"likeCurrentPicture") ;
        Picture *picture = currentPicture ;
        BOOL isLike = [picture isLike] ;
        NSInteger likeValue = 1 ;
        if(isLike){
            likeValue = 0 ;
        }
        
        NSString *pictureId = [picture pictureId] ;
        NSInteger socialUserid = [VeamUtil getSocialUserId] ;

        NSURL *url = [VeamUtil getApiUrl:@"forum/likepicture"] ;
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%@_%d",pictureId,socialUserid]] ;
        NSString *urlString = [NSString stringWithFormat:@"%@&p=%@&sid=%d&l=%d&s=%@",[url absoluteString],pictureId,socialUserid,likeValue,signature] ;
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"like url : %@",[url absoluteString]) ;
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
                    [picture setIsLike:!isLike] ;
                    NSInteger numberOfLikes = [picture numberOfLikes] ;
                    if(isLike){
                        numberOfLikes-- ;
                    } else {
                        numberOfLikes++ ;
                        //[VeamUtil kickKiip:VEAM_KIIP_PICTURE_LIKE] ;
                    }
                    [picture setNumberOfLikes:numberOfLikes] ;
                }
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        //NSLog(@"likeCurrentPicture end") ;
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
        isLikeSending = NO ;
    }
}

- (TTStyledTextLabel *)getCommentLabel:(NSInteger)index
{
    Picture *picture = [pictures getPictureAt:index] ;
    NSArray *comments = [picture comments] ;
    NSInteger count = [comments count] ;
    NSString *htmlString = @"" ;
    
    NSInteger limit = VEAM_DEFAULT_COMMENT_COUNT ;
    NSString *showFlag = [showAllCommentsFlags objectForKey:[picture pictureId]] ;
    if((showFlag != nil) && ([showFlag isEqualToString:@"YES"])){
        limit = 999999 ;
    }
    
    for(int commentIndex = 0 ; (commentIndex < count) && (commentIndex < limit) ; commentIndex++){
        Comment *comment = [comments objectAtIndex:commentIndex] ;
        //htmlString = [htmlString stringByAppendingFormat:@"<span class=\"commentUserName\">%@</span> ",[comment ownerName]] ;
        htmlString = [htmlString stringByAppendingFormat:@"<a href=\"%@://%d-%d/\" class=\"commentUserName:\">%@</a> ",VEAM_VIEW_PROFILE_SCHEMA,index,commentIndex,[comment ownerName]] ;
        htmlString = [htmlString stringByAppendingFormat:@"<span class=\"commentText:\">%@</span><br />",[comment comment]] ;
    }
    
    if(limit < count){
        //htmlString = [htmlString stringByAppendingFormat:@"<br /><span class=\"viewAllComments\">view all %d comments</span><br />",count] ;
        NSString *viewString = [NSString stringWithFormat:NSLocalizedString(@"view_all_comments",nil),count] ;
        htmlString = [htmlString stringByAppendingFormat:@"<br /><a href=\"%@://%@/\" class=\"viewAllComments:\">%@</a><br />",VEAM_VIEW_COMMENT_SCHEMA,[picture pictureId],viewString] ;
    } else if(count > 3){
        htmlString = [htmlString stringByAppendingFormat:@"<br /><a href=\"%@://%@/\" class=\"viewAllComments:\">%@</a><br />",VEAM_CLOSE_COMMENT_SCHEMA,[picture pictureId],NSLocalizedString(@"close_all_comments",nil)] ;
    }
    
    CGRect frame = CGRectMake(36, 367, 274, 1) ;
    TTStyledTextLabel *label = [[TTStyledTextLabel alloc] initWithFrame:frame] ;
    label.text = [TTStyledText textFromXHTML:htmlString lineBreaks:NO URLs:YES];
    label.font = [UIFont systemFontOfSize:14] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label sizeToFit];
    //[label setUserInteractionEnabled:YES] ;
    return label ;
    
}

- (BOOL)navigator: (TTBaseNavigator *)navigator shouldOpenURL:(NSURL *)url
{
    //NSLog(@"url=%@ scheme=%@ host=%@",[url absoluteString],[url scheme],[url host]) ;
    
    NSString *pictureId = [url host] ;
    NSString *schema = [url scheme] ;
    if([schema isEqualToString:VEAM_VIEW_COMMENT_SCHEMA]){
        [showAllCommentsFlags setObject:@"YES" forKey:pictureId] ;
    } else if([schema isEqualToString:VEAM_CLOSE_COMMENT_SCHEMA]){
        [showAllCommentsFlags setObject:@"NO" forKey:pictureId] ;
    } else if([schema isEqualToString:VEAM_VIEW_PROFILE_SCHEMA]){
        NSString *indexString = [url host] ;
        NSArray *indice = [indexString componentsSeparatedByString:@"-"] ;
        if([indice count] >= 2){
            NSInteger pictureIndex = [[indice objectAtIndex:0] integerValue] ;
            NSInteger commentIndex = [[indice objectAtIndex:1] integerValue] ;
            Picture *picture = [pictures getPictureAt:pictureIndex] ;
            NSArray *comments = [picture comments] ;
            if([comments count] >commentIndex){
                Comment *comment = [comments objectAtIndex:commentIndex] ;
                [self showProfileView:[comment ownerUserId] socialUserName:[comment ownerName]] ;
            }
        }
    }
    
    [pictureListTableView reloadData] ;
    
    /*
    CGPoint contentOffset = [pictureListTableView contentOffset] ;
    contentOffset.y -= 100 ;
    [pictureListTableView setContentOffset:contentOffset] ;
     */
    return NO ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForUser ;
            break;
        case 2:
            imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
            break;
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        ForumCell *cell = (ForumCell *)[pictureListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.userImageView.image = imageDownloader.pictureImage ;
        } else if(imageIndex == 2){
            cell.pictureImageView.image = imageDownloader.pictureImage ;
            [cell.pictureImageIndicator stopAnimating] ;
            [cell.pictureImageIndicator setHidden:YES] ;
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    if(isPostViewShown){
        isPostViewShown = NO ;
        [self reloadData] ;
        //[VeamUtil kickKiip:VEAM_KIIP_PICTURE_COMMENT] ;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"PictureViewController::viewDidAppear") ;
    [super viewDidAppear:animated] ;
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade] ;
    
    ttNavigator.delegate = self ;

    if([VeamUtil getPicturePosted]){
        [VeamUtil setPicturePosted:NO] ;
        [self startUpdating] ;
        NSString *rewardString = [VeamUtil getRewardString] ;
        if(![VeamUtil isEmpty:rewardString]){
            [VeamUtil setRewardString:@""] ;
            /*
#if INCLUDE_KIIP==1
            //NSLog(@"rewarded : %@",rewardString) ;
            [[Kiip sharedInstance] saveMoment:rewardString withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
                if (error) {
                    //NSLog(@"something's wrong");
                    // handle with an Alert dialog.
                }
                if (poptart) {
                    [poptart show];
                }
                if (!poptart) {
                    // handle logic when there is no reward to give.
                }
            }];
#endif
             */
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"viewDidDisappear") ;
    ttNavigator.delegate = nil ;
}


- (void)startUpdating
{
    NotificationCell *notificationCell = (NotificationCell *)[pictureListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    CGRect frame = [pictureListTableView frame] ;
    frame.origin.y = [VeamUtil getTopBarHeight] + [VeamUtil getViewTopOffset] ;
    [notificationCell.indicator startAnimating] ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [notificationCell.indicator setAlpha:1.0] ;
    [notificationCell.updatingLabel setAlpha:1.0] ;
    [pictureListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
    currentPageNo = 1 ;
    [self performSelectorInBackground:@selector(updatePictures) withObject:nil] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = [scrollView contentOffset].y ;
    //NSLog(@"scrollViewDidEndDragging offset = %f",offsetY) ;
    
    if((offsetY < -50) && !isUpdating){
        //NSLog(@"update") ;
        [self startUpdating] ;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = [scrollView contentOffset].y ;
    //NSLog(@"scrollViewDidScroll offset = %f",offsetY) ;
    
    NotificationCell *notificationCell = (NotificationCell *)[pictureListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    if((offsetY < -50) && !isUpdating){
        [notificationCell.instructionLabel setAlpha:1.0] ;
    } else {
        [notificationCell.instructionLabel setAlpha:0.0] ;
    }
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging") ;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //NSLog(@"scrollViewWillEndDragging") ;
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewShouldScrollToTop") ;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScrollToTop") ;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDecelerating") ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating") ;
}
 */

- (void)doPendingOperation
{
    if(pendingOperation == VEAM_PENDING_OPERATION_CAMERA){
        pendingOperation = 0 ;
        [self performSelectorOnMainThread:@selector(operateCameraButton) withObject:nil waitUntilDone:NO] ;
        //[self operateCameraButton] ;
    } else if(pendingOperation == VEAM_PENDING_OPERATION_LIKE){
        pendingOperation = 0 ;
        [self operateLikeButton:pendingTag] ;
    } else if(pendingOperation == VEAM_PENDING_OPERATION_COMMENT){
        pendingOperation = 0 ;
        [self performSelectorOnMainThread:@selector(doPendingCommentButton) withObject:nil waitUntilDone:NO] ;
        //[self operateCommentButton:pendingTag] ;
    }
}

- (void)onShowLikerTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onShowLikerTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    
    Picture *picture = [pictures getPictureAt:tag] ;
    if(picture != nil){
        if(picture.numberOfLikes > 0){
            FollowViewController *followViewController = [[FollowViewController alloc] init] ;
            [followViewController setSocialUserId:[NSString stringWithFormat:@"%d",[VeamUtil getSocialUserId]]] ;
            [followViewController setFollowKind:VEAM_FOLLOW_KIND_PICTURE_LIKER] ;
            [followViewController setPictureId:picture.pictureId] ;
            [followViewController setTitleName:@"Who likes"] ;
            [self.navigationController pushViewController:followViewController animated:YES] ;
        }
    }
}




/*
/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}
*/

- (void)nativeExpressAdViewDidReceiveAd:(nonnull GADNativeExpressAdView *)nativeExpressAdView {
    //NSLog(@"nativeExpressAdViewDidReceiveAd %d",nativeExpressAdView.tag);
    NSInteger row = nativeExpressAdView.tag ;
    NSString *rowString = [NSString stringWithFormat:@"%d",row] ;
    PictureNativeAdCell *pictureNativeAdCell = [pictureNativeViewCells objectForKey:rowString] ;
    if(pictureNativeAdCell != nil){
        //NSLog(@"hide indicator");
        [pictureNativeAdCell hideIndicator] ;
    }
}

- (void)nativeExpressAdView:(nonnull GADNativeExpressAdView *)nativeExpressAdView didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    //NSLog(@"didFailToReceiveAdWithError %d %@",nativeExpressAdView.tag,error.localizedDescription);
}

- (void)nativeExpressAdViewWillPresentScreen:(nonnull GADNativeExpressAdView *)nativeExpressAdView {
    //NSLog(@"nativeExpressAdViewWillPresentScreen %d",nativeExpressAdView.tag);
}

- (void)nativeExpressAdViewWillDismissScreen:(nonnull GADNativeExpressAdView *)nativeExpressAdView {
    //NSLog(@"nativeExpressAdViewWillDismissScreen %d",nativeExpressAdView.tag);
}

- (void)nativeExpressAdViewDidDismissScreen:(nonnull GADNativeExpressAdView *)nativeExpressAdView {
    //NSLog(@"nativeExpressAdViewDidDismissScreen %d",nativeExpressAdView.tag);
}

- (void)nativeExpressAdViewWillLeaveApplication:(nonnull GADNativeExpressAdView *)nativeExpressAdView {
    //NSLog(@"nativeExpressAdViewWillLeaveApplication %d",nativeExpressAdView.tag);
}
@end
