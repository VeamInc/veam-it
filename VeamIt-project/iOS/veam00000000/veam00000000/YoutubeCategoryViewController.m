//
//  YoutubeCategoryViewController.m
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "YoutubeCategoryViewController.h"
#import "VeamUtil.h"
#import "DualImageCellViewController.h"
#import "BasicCellViewController.h"
#import "YoutubeCategory.h"
#import "YoutubeSubCategoryViewController.h"
#import "YoutubeViewController.h"
#import "WebViewController.h"

@interface YoutubeCategoryViewController ()

@end

@implementation YoutubeCategoryViewController

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
    
    //NSLog(@"YoutubeCategoryViewController::viewDidLoad start") ;
    
    [self setViewName:@"YoutubeCategoryList/"] ;
    
//#ifdef DO_NOT_USE_ADMOB
#define ADMOB_BANNER_HEIGHT 1.0
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
/*
#else
#define ADMOB_BANNER_HEIGHT 50.0
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView.adUnitID = VEAM_ADMOB_UNIT_ID_PLAYLISTCATEGORY;
    bannerView.rootViewController = self;
    bannerView.delegate = self;
    [bannerView loadRequest:[VeamUtil getAdRequest]];
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, 300, 1)] ;
    [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
    [bannerCell addSubview:lineView] ;
    [bannerCell addSubview:bannerView] ;
#endif
*/
    
    imageDownloadsInProgressForBulletin = [NSMutableDictionary dictionary];
    
    categoryListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [categoryListTableView setDelegate:self] ;
    [categoryListTableView setDataSource:self] ;
    [categoryListTableView setBackgroundColor:[UIColor clearColor]] ;
    [categoryListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [categoryListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:categoryListTableView] ;
    
    [self addTopBar:NO showSettingsButton:YES] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    isAllYoutubeCategoryEmbed = [VeamUtil isAllYoutubeCategoryEmbed] ;
    if(isAllYoutubeCategoryEmbed){
        //NSLog(@"all embed") ;
        indexOffset = 2 ;
    } else {
        //NSLog(@"not all embed") ;
        indexOffset = 4 ;
    }
    /*
    NSInteger numberOfNewVideos = [VeamUtil getNumberOfNewYoutubeVideos] ;
    //NSLog(@"number of new videos = %d",numberOfNewVideos) ;
    if(numberOfNewVideos > 0){
        hasNewVideo = YES ;
        indexOffset++ ;
    } else {
        hasNewVideo = NO ;
    }
     */
    lastIndex = indexOffset + [VeamUtil getNumberOfYoutubeCategories] ;
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == 1){
        retValue = 160.0 ; // dual image cell height
    } else if(indexPath.row == 2){
        retValue = ADMOB_BANNER_HEIGHT ; // admob
    } else if(indexPath.row == lastIndex){
        //retValue = [VeamUtil getTabBarHeight] ;
        retValue = 49.0 ; // タブが表示されていないときに更新されると0になってしまうので固定
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if((indexPath.row == 0) || (indexPath.row == lastIndex)){
        // spacer
        cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else if(indexPath.row == 1){
        // image
        DualImageCell *dualImageCell = [tableView dequeueReusableCellWithIdentifier:@"Image"] ;
        if (dualImageCell == nil) {
            DualImageCellViewController *controller = [[DualImageCellViewController alloc] initWithNibName:@"DualImageCell" bundle:nil] ;
            dualImageCell = (DualImageCell *)controller.view ;
        }
        
        //NSLog(@"current bulletin is nil") ;
        [dualImageCell.leftImageView setHidden:NO] ;
        [dualImageCell.leftLabel setHidden:YES] ;
        
        NSString *leftImageName = nil ;
        leftImageName = [NSString stringWithFormat:@"t%@_top_left.png",VEAM_TEMPLATE_ID_YOUTUBE_LIST] ;
        [dualImageCell.leftImageView setImage:[VeamUtil imageNamed:leftImageName]] ;
        
        NSString *rightImageName = nil ;
        rightImageName = [NSString stringWithFormat:@"t%@_top_right.png",VEAM_TEMPLATE_ID_YOUTUBE_LIST] ;
        [dualImageCell.rightImageView setImage:[VeamUtil imageNamed:rightImageName]] ;
        
        [dualImageCell.leftBackView setAlpha:0.0] ;
        [dualImageCell setBackgroundColor:[UIColor clearColor]] ;
        [dualImageCell.contentView setBackgroundColor:[UIColor clearColor]] ;

        cell = dualImageCell ;
    } else if(!isAllYoutubeCategoryEmbed && (indexPath.row == 2)){
        cell = bannerCell ;
    } else if(!isAllYoutubeCategoryEmbed && (indexPath.row == 3)){
        // My Favorites
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = NSLocalizedString(@"my_favorites",nil) ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getNewVideosTextColor]] ;
        
        UILabel *label = [basicCell titleLabel] ;
        CGSize expectedLabelSize = [title sizeWithFont:label.font
                                     constrainedToSize:CGSizeMake([VeamUtil getScreenWidth], 50)
                                         lineBreakMode:label.lineBreakMode] ;
        //NSLog(@"label width = %f",expectedLabelSize.width) ;
        
        UIImage *image = [VeamUtil imageNamed:@"list_clip.png"] ;
        CGRect labelFrame = label.frame ;
        CGFloat imageWidth = image.size.width / 2 ;
        CGFloat imageHeight = image.size.height / 2 ;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(expectedLabelSize.width+4, (labelFrame.size.height-imageHeight)/2, imageWidth, imageHeight)] ;
        [imageView setImage:image] ;
        [label addSubview:imageView] ;
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        
        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;

        cell = basicCell ;
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        YoutubeCategory *category = [VeamUtil getYoutubeCategoryAt:index] ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = [category name] ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        cell = basicCell ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)updateList
{
    [categoryListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


/*
- (void)updateBulletin
{
    Bulletin *bulletin = [VeamUtil getCurrentBulletin:0] ;
    if(bulletin != nil){
        DualImageCell *dualImageCell = (DualImageCell *)[categoryListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] ;
        if (dualImageCell != nil) {
            [dualImageCell.leftImageView setImage:[UIImage imageNamed:@"videos_left_image.png"]] ;
            if([[bulletin kind] isEqualToString:VEAM_BULLETIN_KIND_TEXT]){
                [dualImageCell.leftImageView setHidden:YES] ;
                [dualImageCell.leftLabel setHidden:NO] ;
                [dualImageCell.leftLabel setText:[bulletin message]] ;
            }
        }
    }
}
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(!isAllYoutubeCategoryEmbed && (indexPath.row == 3)){
        if([VeamUtil isConnected]){
            YoutubeViewController *youtubeViewController = [[YoutubeViewController alloc] init] ;
            [youtubeViewController setShowBackButton:YES] ;
            [youtubeViewController setCategoryId:VEAM_YOUTUBE_CATEGORY_ID_FAVORITES] ;
            [youtubeViewController setSubCategoryId:@"0"] ;
            [youtubeViewController setTitleName:NSLocalizedString(@"my_favorites",nil)] ;
            [self.navigationController pushViewController:youtubeViewController animated:YES] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        if(index >= 0){
            NSInteger index = indexPath.row - indexOffset ;
            YoutubeCategory *category = [VeamUtil getYoutubeCategoryAt:index] ;
            if(category != nil){
                if([category.embed isEqual:@"1"]){
                    WebViewController *webViewController = [[WebViewController alloc] init] ;
                    [webViewController setUrl:category.embedUrl] ;
                    [webViewController setTitleName:category.name] ;
                    [webViewController setShowBackButton:YES] ;
                    [self.navigationController pushViewController:webViewController animated:YES] ;
                } else {
                    NSArray *subCategories = [VeamUtil getYoutubeSubCategories:[category youtubeCategoryId]] ;
                    //NSLog(@"subCategories count = %d",[subCategories count]) ;
                    if([subCategories count] > 0){
                        //NSLog(@"category tapped : %@ %@",[category categoryId],[category name]) ;
                        YoutubeSubCategoryViewController *youtubeSubCategoryViewController = [[YoutubeSubCategoryViewController alloc] init] ;
                        [youtubeSubCategoryViewController setCategoryId:[category youtubeCategoryId]] ;
                        [youtubeSubCategoryViewController setTitleName:[category name]] ;
                        [self.navigationController pushViewController:youtubeSubCategoryViewController animated:YES] ;
                    } else {
                        if([VeamUtil isConnected]){
                            YoutubeViewController *youtubeViewController = [[YoutubeViewController alloc] init] ;
                            [youtubeViewController setShowBackButton:YES] ;
                            [youtubeViewController setCategoryId:[category youtubeCategoryId]] ;
                            [youtubeViewController setSubCategoryId:@"0"] ;
                            [youtubeViewController setTitleName:[category name]] ;
                            [self.navigationController pushViewController:youtubeViewController animated:YES] ;
                        } else {
                            [VeamUtil dispNotConnectedError] ;
                        }
                    }
                }
            }
        }
    }
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForBulletin ;
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

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForBulletin ;
            break;
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        DualImageCell *cell = (DualImageCell *)[categoryListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.leftImageView.image = imageDownloader.pictureImage ;
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    //[VeamUtil kickKiip:VEAM_KIIP_YOUTUBE_CATEGORY] ;
}


/*
#ifndef DO_NOT_USE_ADMOB
/// Called when an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    //NSLog(@"adViewDidReceiveAd");
}

/// Called when an ad request failed.
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    //NSLog(@"adViewDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Called just before presenting the user a full screen view, such as
/// a browser, in response to clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    //NSLog(@"adViewWillPresentScreen");
}

/// Called just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    //NSLog(@"adViewWillDismissScreen");
}

/// Called just after dismissing a full screen view.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    //NSLog(@"adViewDidDismissScreen");
}

/// Called just before the application will background or terminate
/// because the user clicked on an ad that will launch another
/// application (such as the App Store).
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    //NSLog(@"adViewDidLeaveApplication");
}
#endif
*/

@end
