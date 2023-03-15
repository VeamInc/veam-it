//
//  ForumViewController.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "ForumViewController.h"
#import "VeamUtil.h"
#import "BasicCellViewController.h"
#import "PictureViewController.h"

#define VEAM_PENDING_OPERATION_MYPOST   1

@interface ForumViewController ()

@end

@implementation ForumViewController

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
    [self setViewName:@"ForumList/"] ;
    
//#ifdef DO_NOT_USE_ADMOB
#define ADMOB_BANNER_HEIGHT 1.0
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
/*
#else
#define ADMOB_BANNER_HEIGHT 50.0
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner] ;
    bannerView.adUnitID = VEAM_ADMOB_UNIT_ID_FORUMCATEGORY ;
    bannerView.rootViewController = self ;
    bannerView.delegate = self ;
    [bannerView loadRequest:[VeamUtil getAdRequest]] ;
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, 300, 1)] ;
    [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
    [bannerCell addSubview:lineView] ;
    [bannerCell addSubview:bannerView] ;
#endif
*/
    forumListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [forumListTableView setDelegate:self] ;
    [forumListTableView setDataSource:self] ;
    [forumListTableView setBackgroundColor:[UIColor clearColor]] ;
    [forumListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [forumListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:forumListTableView] ;
    
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
    indexOffset = 5 ;
    lastIndex = indexOffset + [VeamUtil getNumberOfForums] ;
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == 1){
        retValue = ADMOB_BANNER_HEIGHT ;
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else if(indexPath.row == 1){
        cell = bannerCell ;
    } else if(indexPath.row == 2){
        // my posts
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = NSLocalizedString(@"my_posts",nil) ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getNewVideosTextColor]] ;
        
        UILabel *label = [basicCell titleLabel] ;
        CGSize expectedLabelSize = [title sizeWithFont:label.font
                                     constrainedToSize:CGSizeMake([VeamUtil getScreenWidth], 50)
                                         lineBreakMode:label.lineBreakMode] ;
        //NSLog(@"label width = %f",expectedLabelSize.width) ;
        
        UIImage *image = [VeamUtil imageNamed:@"list_my_post.png"] ;
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
    } else if(indexPath.row == 3){
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
    } else if(indexPath.row == 4){
        // Followings
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = NSLocalizedString(@"following",nil) ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getNewVideosTextColor]] ;
        
        UILabel *label = [basicCell titleLabel] ;
        CGSize expectedLabelSize = [title sizeWithFont:label.font
                                     constrainedToSize:CGSizeMake([VeamUtil getScreenWidth], 50)
                                         lineBreakMode:label.lineBreakMode] ;
        //NSLog(@"label width = %f",expectedLabelSize.width) ;
        
        UIImage *image = [VeamUtil imageNamed:@"list_following.png"] ;
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
        NSInteger index = indexPath.row - 5 ;
        Forum *forum = [VeamUtil getForumAt:index] ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = [forum forumName] ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
        
        if([[forum kind] isEqualToString:VEAM_FORUM_KIND_HOT]){
        //if([[forum forumId] isEqualToString:@"0"]){
            // hot topics
            title = NSLocalizedString(@"forum_name_hot_topics",nil) ;
            UILabel *label = [basicCell titleLabel] ;
            [label setText:title] ;
            CGSize expectedLabelSize = [title sizeWithFont:label.font
                                              constrainedToSize:CGSizeMake([VeamUtil getScreenWidth], 50)
                                                  lineBreakMode:label.lineBreakMode] ;
            //NSLog(@"label width = %f",expectedLabelSize.width) ;
            
            UIImage *image = [VeamUtil imageNamed:@"flame.png"] ;
            CGRect labelFrame = label.frame ;
            CGFloat imageWidth = image.size.width / 2 ;
            CGFloat imageHeight = image.size.height / 2 ;
            CGFloat newImageHeight = labelFrame.size.height * 0.8 ;
            CGFloat newImageWidth = newImageHeight / imageHeight * imageWidth ;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(expectedLabelSize.width+4, (labelFrame.size.height-newImageHeight)/2, newImageWidth, newImageHeight)] ;
            [imageView setImage:image] ;
            [label addSubview:imageView] ;
        }
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;

        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        
        cell = basicCell ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    if(indexPath.row == 2){
        // My Post
        [self operateMyPost] ;
    } else  if(indexPath.row == 3){
        if([VeamUtil isConnected]){
            PictureViewController *pictureViewController = [[PictureViewController alloc] init] ;
            [pictureViewController setForumId:VEAM_SPECIAL_FORUM_ID_FAVORITES] ;
            [pictureViewController setTitleName:NSLocalizedString(@"my_favorites",nil)] ;
            [self.navigationController pushViewController:pictureViewController animated:YES] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    } else  if(indexPath.row == 4){
        if([VeamUtil isConnected]){
            PictureViewController *pictureViewController = [[PictureViewController alloc] init] ;
            [pictureViewController setForumId:VEAM_SPECIAL_FORUM_ID_FOLLOWINGS] ;
            [pictureViewController setTitleName:NSLocalizedString(@"following",nil)] ;
            [self.navigationController pushViewController:pictureViewController animated:YES] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    } else {
        NSInteger index = indexPath.row - 5 ;
        Forum *forum = [VeamUtil getForumAt:index] ;
        if(forum != nil){
            //NSLog(@"forum tapped : %@ %@",[forum forumId],[forum forumName]) ;
            if([VeamUtil isConnected]){
                PictureViewController *pictureViewController = [[PictureViewController alloc] init] ;
                [pictureViewController setForumId:[forum forumId]] ;
                [pictureViewController setForumKind:[forum kind]] ;
                [pictureViewController setTitleName:[VeamUtil getTranslatedString:[forum forumName]]] ;
                [self.navigationController pushViewController:pictureViewController animated:YES] ;
            } else {
                [VeamUtil dispNotConnectedError] ;
            }
        }
    }
    
}

- (void)updateList
{
    [forumListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}

- (void)operateMyPost
{
    if([VeamUtil isLoggedIn]){
        if([VeamUtil isConnected]){
            PictureViewController *pictureViewController = [[PictureViewController alloc] init] ;
            [pictureViewController setForumId:VEAM_SPECIAL_FORUM_ID_MY_POST] ;
            [pictureViewController setTitleName:NSLocalizedString(@"my_posts",nil)] ;
            [self.navigationController pushViewController:pictureViewController animated:YES] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    } else {
        pendingOperation = VEAM_PENDING_OPERATION_MYPOST ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    }
}

- (void)doPendingOperation
{
    if(pendingOperation == VEAM_PENDING_OPERATION_MYPOST){
        pendingOperation = 0 ;
        [self performSelectorOnMainThread:@selector(operateMyPost) withObject:nil waitUntilDone:NO] ;
        //[self operateMyPost] ;
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    //[VeamUtil kickKiip:VEAM_KIIP_FORUM_CATEGORY] ;
}


@end
