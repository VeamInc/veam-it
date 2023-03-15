//
//  FollowViewController.m
//  veam31000000
//
//  Created by veam on 2/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "FollowViewController.h"
#import "VeamUtil.h"
#import "NotificationCellViewController.h"
#import "Follow.h"
#import "FollowCellViewController.h"
#import "ProfileViewController.h"

@interface FollowViewController ()

@end

@implementation FollowViewController

@synthesize socialUserId ;
@synthesize followKind ;
@synthesize pictureId ;

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

    [self setViewName:[NSString stringWithFormat:@"FollowList/"]] ;
    
    isUpdating = NO ;
    
    follows = [[Follows alloc] init] ;
    imageDownloadsInProgressForUser = [NSMutableDictionary dictionary] ;
    followListTableView = nil ;
    currentPageNo = 1 ;
    
    followListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [followListTableView setDelegate:self] ;
    [followListTableView setDataSource:self] ;
    [followListTableView setBackgroundColor:[UIColor clearColor]] ;
    [followListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [followListTableView setAlpha:0.0] ;
    [followListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:followListTableView] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    CGRect frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator startAnimating] ;
    [self.view addSubview:indicator] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
    [self restrictTopBarLabelWidth] ;
    
    [self performSelectorInBackground:@selector(updateFollows) withObject:nil] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateFollows
{
    @autoreleasepool
    {
        //NSLog(@"update follows start") ;
        isUpdating = YES ;
        NSURL *url = [VeamUtil getApiUrl:@"socialuser/followlist"] ;

        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%d_%@",followKind,socialUserId]] ;

        NSString *urlString = [NSString stringWithFormat:@"%@&k=%d&p=%d&sid=%@&s=%@&pid=%@",[url absoluteString],followKind,currentPageNo,socialUserId,signature,pictureId] ;
        
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"follows update url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        //NSLog(@"response=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]) ;
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            if(currentPageNo == 1){
                Follows *workFollows = [[Follows alloc] init] ;
                [workFollows parseWithData:data] ;
                follows = workFollows ;
            } else {
                [follows parseWithData:data] ; // add
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        isUpdating = NO ;
        //NSLog(@"update follows end") ;
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
}


- (void)reloadData
{
    //NSLog(@"reloadData") ;
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    [followListTableView reloadData] ;
    CGRect frame = [followListTableView frame] ;
    frame.origin.y = [VeamUtil getViewTopOffset] ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3] ;
    [followListTableView setAlpha:1.0] ;
    [followListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
}

- (void)hideIndicator
{
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForUser ;
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
    } else if(indexPath.row == (numberOfFollows+1)){
        if([follows noMoreFollows]){
            height = 50 ;
        } else {
            height = 100 ;
        }
    } else {
        height = 45 ;
    }
    return height ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numberOfFollows = [follows getNumberOfFollows] ;
    NSInteger retInt = numberOfFollows ;
    retInt += 2 ; // spacer
    //NSLog(@"number of rows : %d",retInt) ;
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
    } else if(indexPath.row == (numberOfFollows+1)){
        // spacer
        if([follows noMoreFollows] || (numberOfFollows == 0)){
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
                [self performSelectorInBackground:@selector(updateFollows) withObject:nil] ;
            }
        }
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else {
        NSInteger index = indexPath.row - 1 ;
        Follow *follow = [follows getFollowAt:index] ;
        FollowCell *followCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (followCell == nil) {
            FollowCellViewController *controller = [[FollowCellViewController alloc] initWithNibName:@"FollowCell" bundle:nil] ;
            followCell = (FollowCell *)controller.view ;
        }
        [[followCell userNameLabel] setText:[follow name]] ;
        [[followCell userNameLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        
        [[followCell separatorView] setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        
        followCell.thumbnailImageView = [[AGMedallionView alloc] initWithFrame:CGRectMake(13, 6, 32, 32)] ;
        [followCell.contentView addSubview:followCell.thumbnailImageView] ;
        
        UIImage *ownerIconImage = [VeamUtil getCachedImage:[follow imageUrl] downloadIfNot:NO] ;
        if(ownerIconImage == nil){
            [self startImageDownload:[follow imageUrl] forIndexPath:indexPath imageIndex:1] ;
        } else {
            [followCell.thumbnailImageView setImage:ownerIconImage] ;
        }
        
        
        [followCell setBackgroundColor:[UIColor clearColor]] ;
        [followCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        
        cell = followCell ;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;

    NSInteger index = indexPath.row - 1 ;
    if(index >= 0){
        Follow *follow = [follows getFollowAt:index] ;
        if(follow != nil){
            ProfileViewController *profileViewController = [[ProfileViewController alloc] init] ;
            [profileViewController setSocialUserId:[follow socialUserId]] ;
            [profileViewController setSocialUserName:[follow name]] ;
            [profileViewController setTitleName:NSLocalizedString(@"profile",nil)] ;
            [self.navigationController pushViewController:profileViewController animated:YES] ;
        }
    }
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
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        FollowCell *cell = (FollowCell *)[followListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.thumbnailImageView.image = imageDownloader.pictureImage ;
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"FollowViewController::viewDidAppear") ;
    [super viewDidAppear:animated] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"viewDidDisappear") ;
}


- (void)startUpdating
{
    NotificationCell *notificationCell = (NotificationCell *)[followListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    CGRect frame = [followListTableView frame] ;
    frame.origin.y = [VeamUtil getTopBarHeight] + [VeamUtil getViewTopOffset] ;
    [notificationCell.indicator startAnimating] ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [notificationCell.indicator setAlpha:1.0] ;
    [notificationCell.updatingLabel setAlpha:1.0] ;
    [followListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
    currentPageNo = 1 ;
    [self performSelectorInBackground:@selector(updateFollows) withObject:nil] ;
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
    
    NotificationCell *notificationCell = (NotificationCell *)[followListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    if((offsetY < -50) && !isUpdating){
        [notificationCell.instructionLabel setAlpha:1.0] ;
    } else {
        [notificationCell.instructionLabel setAlpha:0.0] ;
    }
}

@end
