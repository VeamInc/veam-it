//
//  VideoCategoryViewController.m
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VideoCategoryViewController.h"
#import "VeamUtil.h"
#import "DualImageCellViewController.h"
#import "BasicCellViewController.h"
#import "VideoCategory.h"
#import "VideoSubCategoryViewController.h"
#import "VideoViewController.h"
#import "WebViewController.h"
#import "SubscriptionPurchaseViewController.h"

#define EMBEDED_DESCRIPTION_CELL_LINE_HEIGHT    17

@interface VideoCategoryViewController ()

@end

@implementation VideoCategoryViewController



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
    
    [self setViewName:@"VideoCategoryList/"] ;
    
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
    indexOffset = 2 ;
    /*
    NSInteger numberOfNewVideos = [VeamUtil getNumberOfNewVideoVideos] ;
    //NSLog(@"number of new videos = %d",numberOfNewVideos) ;
    if(numberOfNewVideos > 0){
        hasNewVideo = YES ;
        indexOffset++ ;
    } else {
        hasNewVideo = NO ;
    }
     */
    shouldShowDescription = NO ;
    if(![VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
        //NSLog(@"Not bought") ;
        embededDescription = [VeamUtil getConfigurationString:[NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_EMBEDED_DESCRIPTION_FORMAT,[VeamUtil getSubscriptionIndex]] default:@""] ;
        if(![VeamUtil isEmpty:embededDescription]){
            //NSLog(@"Embeded description found") ;
            shouldShowDescription = YES ;
        }
    }
    
    if(shouldShowDescription){
        indexOffset++ ;
    }
    lastIndex = indexOffset + [VeamUtil getNumberOfVideoCategories] ;
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
    } else if(shouldShowDescription && (indexPath.row == 2)){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 288, 1)] ;
        [self configEmbededDescriptionLabel:label] ;
        retValue = label.frame.size.height + 22 ; // height of description
    } else if(indexPath.row == lastIndex){
        //retValue = [VeamUtil getTabBarHeight] ;
        retValue = 49.0 ; // タブが表示されていないときに更新されると0になってしまうので固定
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (void)configEmbededDescriptionLabel:(UILabel *)label
{
    [label setLineBreakMode:NSLineBreakByWordWrapping] ;
    [label setNumberOfLines:0];
    [label setText:embededDescription] ;
    [VeamUtil setTextWithLineHeight:label text:embededDescription lineHeight:EMBEDED_DESCRIPTION_CELL_LINE_HEIGHT] ;

    [label setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [label setHighlightedTextColor:[VeamUtil getNewVideosTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]] ;
    [label sizeToFit] ;
    
    CGRect frame = label.frame ;
    frame.origin.y = 7 ;
    [label setFrame:frame] ;
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
            dualImageCell = (DualImageCell *)controller.view ;        }
        
        [dualImageCell.leftImageView setHidden:YES] ;
        [dualImageCell.leftBackView setHidden:NO] ;
        [dualImageCell.leftLabel setHidden:YES] ;
        [dualImageCell.leftBackView setBackgroundColor:[VeamUtil getNewVideosTextColor]] ;
        
        CGRect leftFrame = dualImageCell.leftBackView.frame ;
        
        //NSCalendar *calendar = [NSCalendar currentCalendar] ;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:[NSDate date]] ;
        
        NSString *weekdayString = [VeamUtil getShorthandForWeekday:[components weekday]  format:VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL] ;
        NSString *dayString = [NSString stringWithFormat:@"%d",[components day]] ;
        NSString *monthString = [VeamUtil getNameForMonth:[components month]] ;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, leftFrame.size.width, 20)] ;
        [label setText:weekdayString] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setTextColor:[UIColor whiteColor]] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]] ;
        [label setTextAlignment:NSTextAlignmentCenter] ;
        [dualImageCell addSubview:label] ;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, leftFrame.size.width, 60)] ;
        [label setText:dayString] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setTextColor:[UIColor whiteColor]] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:78]] ;
        [label setTextAlignment:NSTextAlignmentCenter] ;
        [dualImageCell addSubview:label] ;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, leftFrame.size.width, 20)] ;
        [label setText:monthString] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setTextColor:[UIColor whiteColor]] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
        [label setTextAlignment:NSTextAlignmentCenter] ;
        [dualImageCell addSubview:label] ;
        
        //[VeamUtil adjustLabelSize:dualImageCell.leftLabel] ;
        
        NSString *rightImageName = nil ;
        rightImageName = [NSString stringWithFormat:@"t%@_top_right.png",VEAM_TEMPLATE_ID_SUBSCRIPTION] ;
        [dualImageCell.rightImageView setImage:[VeamUtil imageNamed:rightImageName]] ;
        
        [dualImageCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        
        cell = dualImageCell ;
        
    } else if(shouldShowDescription && (indexPath.row == 2)){
        BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
        BasicCell *basicCell = (BasicCell *)controller.view ;

        [self configEmbededDescriptionLabel:basicCell.titleLabel] ;
        
        CGRect frame = basicCell.separatorView.frame ;
        frame.origin.y = basicCell.titleLabel.frame.size.height + 20 ;
        [basicCell.separatorView setFrame:frame] ;
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        [basicCell.arrowImage setAlpha:0.0] ;
        
        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        [basicCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;

        cell = basicCell ;
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        VideoCategory *category = [VeamUtil getVideoCategoryAt:index] ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = [category name] ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
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
    
    /*
    if(indexPath.row == 2){
        // new video tapped
        if([VeamUtil isConnected]){
            // show SimplePickup channel
            WebViewController *webViewController = [[WebViewController alloc] init] ;
            [webViewController setUrl:@"http://www.youtube.com/user/SimplePickup"] ;
            [webViewController setTitleName:@"New Videos"] ;
            [webViewController setShowBackButton:YES] ;
            [self.navigationController pushViewController:webViewController animated:YES];

        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    } else if(indexPath.row == 3){
        if([VeamUtil isConnected]){
            VideoViewController *videoViewController = [[VideoViewController alloc] init] ;
            [videoViewController setCategoryId:@"FAVORITES"] ;
            [videoViewController setSubCategoryId:@"0"] ;
            [videoViewController setTitleName:NSLocalizedString(@"my_favorites",nil)] ;
            [self.navigationController pushViewController:videoViewController animated:YES] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    } else {
     */
        NSInteger index = indexPath.row - indexOffset ;
        if(index >= 0){
            NSInteger index = indexPath.row - indexOffset ;
            VideoCategory *category = [VeamUtil getVideoCategoryAt:index] ;
            if(category != nil){
                
                NSArray *subCategories = [VeamUtil getVideoSubCategories:[category videoCategoryId]] ;
                //NSLog(@"subCategories count = %d",[subCategories count]) ;
                if([subCategories count] > 0){
                    //NSLog(@"category tapped : %@ %@",[category categoryId],[category name]) ;
                    VideoSubCategoryViewController *videoSubCategoryViewController = [[VideoSubCategoryViewController alloc] init] ;
                    [videoSubCategoryViewController setCategoryId:[category videoCategoryId]] ;
                    [videoSubCategoryViewController setTitleName:[category name]] ;
                    [self.navigationController pushViewController:videoSubCategoryViewController animated:YES] ;
                } else {
                    VideoViewController *videoViewController = [[VideoViewController alloc] init] ;
                    [videoViewController setCategoryId:[category videoCategoryId]] ;
                    [videoViewController setSubCategoryId:@"0"] ;
                    [videoViewController setTitleName:[category name]] ;
                    [self.navigationController pushViewController:videoViewController animated:YES] ;
                }
            }
        }
    /*
    }
     */
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
    //NSLog(@"%@::viewDidAppear",NSStringFromClass([self class])) ;
    if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
        if(!isBought){
            isBought = YES ;
            [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
        }
    }
}




@end
