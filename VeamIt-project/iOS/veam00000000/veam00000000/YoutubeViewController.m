//
//  YoutubeViewController.m
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "YoutubeViewController.h"
#import "VeamUtil.h"
#import "Youtube.h"
#import "YoutubeCellViewController.h"
#import "ImageDownloader.h"
#import "YoutubePlayViewController.h"
#import "WebViewController.h"
#import "ImageViewerViewController.h"

@interface YoutubeViewController ()

@end

@implementation YoutubeViewController

@synthesize categoryId ;
@synthesize subCategoryId ;
@synthesize categoryKind ;
@synthesize showBackButton ;

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
    
    //NSLog(@"YoutubeViewController::viewDidLoad %@ %@",categoryId,subCategoryId) ;

    [self setViewName:[NSString stringWithFormat:@"YoutubeList/%@/%@/",subCategoryId,self.titleName]] ;
    
//#ifdef DO_NOT_USE_ADMOB
#define ADMOB_BANNER_HEIGHT 1.0
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], 1)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
/*
#else
#define ADMOB_BANNER_HEIGHT 100.0
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
    bannerView.adUnitID = VEAM_ADMOB_UNIT_ID_PLAYLIST;
    bannerView.rootViewController = self;
    bannerView.delegate = self;
    [bannerView loadRequest:[VeamUtil getAdRequest]];
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 99, 300, 1)] ;
    [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
    [bannerCell addSubview:lineView] ;
    [bannerCell addSubview:bannerView] ;
#endif
*/
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary];

    youtubeListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [youtubeListTableView setDelegate:self] ;
    [youtubeListTableView setDataSource:self] ;
    [youtubeListTableView setBackgroundColor:[UIColor clearColor]] ;
    [youtubeListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [youtubeListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:youtubeListTableView] ;
    
    [self addTopBar:showBackButton showSettingsButton:YES] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload url=%@",url) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
        case 2:
            imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
            break;
             */
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
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
        case 2:
            imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
            break;
             */
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        YoutubeCell *cell = (YoutubeCell *)[youtubeListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.thumbnailImageView.image = imageDownloader.pictureImage ;
            /*
        } else if(imageIndex == 2){
            cell.pictureImageView.image = imageDownloader.pictureImage ;
             */
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    indexOffset = 2 ;
    if([subCategoryId isEqualToString:@"0"]){
        youtubes = [VeamUtil getYoutubesForCategory:categoryId] ;
    } else {
        youtubes = [VeamUtil getYoutubesForSubCategory:subCategoryId] ;
    }
    lastIndex = indexOffset + [youtubes count] ;
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
        retValue = [VeamUtil getTabBarHeight] ;
    } else {
        retValue = 88.0 ; // youtube cell height
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
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        Youtube *youtube = [youtubes objectAtIndex:index] ;
        YoutubeCell *youtubeCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (youtubeCell == nil) {
            YoutubeCellViewController *controller = [[YoutubeCellViewController alloc] initWithNibName:@"YoutubeCell" bundle:nil] ;
            youtubeCell = (YoutubeCell *)controller.view ;
        }
        NSString *title = [youtube title] ;
        [[youtubeCell titleLabel] setLineBreakMode:NSLineBreakByWordWrapping] ;
        [[youtubeCell titleLabel] setNumberOfLines:0];
        [[youtubeCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[youtubeCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
        CGRect frame = [[youtubeCell titleLabel] frame] ;
        CGFloat orgWidth = frame.size.width ;
        
        [[youtubeCell titleLabel] setText:@"Title"] ;
        [[youtubeCell titleLabel] sizeToFit] ;
        frame = [[youtubeCell titleLabel] frame] ;
        CGFloat lineHeight = frame.size.height ;
        //NSLog(@"line height=%f",lineHeight) ;
        frame.size.width = orgWidth ;
        [[youtubeCell titleLabel] setFrame:frame] ;

        [[youtubeCell titleLabel] setText:title] ;
        [[youtubeCell titleLabel] sizeToFit] ;
        
        frame = [[youtubeCell titleLabel] frame] ;
        if(frame.size.height > lineHeight){
            frame.size.height = lineHeight*2 ;
            [[youtubeCell titleLabel] setFrame:frame] ;
            [[youtubeCell titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail] ;
            [[youtubeCell titleLabel] setNumberOfLines:2];
        } else {
            frame.origin.y += 12 ;
            [[youtubeCell titleLabel] setFrame:frame] ;
        }
        CGRect durationFrame = [[youtubeCell durationLabel] frame] ;
        durationFrame.origin.y = frame.origin.y + frame.size.height ;
        [[youtubeCell durationLabel] setFrame:durationFrame] ;

        //NSLog(@"height=%f %@",[[youtubeCell titleLabel] frame].size.height,[youtube title]) ;
        NSString *durationString = [youtube duration] ;
        //NSLog(@"duration:%@",durationString) ;
        if((durationString != nil) && ![durationString isEqualToString:@""] && ![durationString isEqualToString:@"0"]){
            [[youtubeCell durationLabel] setText:[VeamUtil getDurationString:[youtube duration]]] ;
        } else {
            [[youtubeCell durationLabel] setAlpha:0.0] ;
        }
        [[youtubeCell durationLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[youtubeCell durationLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;

        NSString *thumbnailUrl = [VeamUtil getYoutubeImageUrl:[youtube youtubeVideoId]] ;
        [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
        
        [youtubeCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        cell = youtubeCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    //NSLog(@"didSelectRowAtIndexPath : %d - %d",indexPath.row,indexOffset) ;
    if((indexOffset <= indexPath.row) && (indexPath.row < lastIndex)){
        NSInteger index = indexPath.row - indexOffset ;
        if(index >= 0){
            Youtube *youtube = [youtubes objectAtIndex:index] ;
            if(youtube != nil){
                //NSLog(@"youtube tapped : %@ %@",[youtube contentVideoId],[youtube title]) ;
                
                if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_NORMAL]){
                    YoutubePlayViewController *youtubePlayViewController = [[YoutubePlayViewController alloc] init] ;
                    [youtubePlayViewController setYoutube:youtube] ;
                    [youtubePlayViewController setTitleName:@"image:youtube.png"] ;
                    [self.navigationController pushViewController:youtubePlayViewController animated:YES] ;
                } else if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_WEB]){
                    // show youtube channel
                    WebViewController *webViewController = [[WebViewController alloc] init] ;
                    [webViewController setUrl:[youtube linkUrl]] ;
                    [webViewController setTitleName:[youtube title]] ;
                    [webViewController setShowBackButton:YES] ;
                    [self.navigationController pushViewController:webViewController animated:YES];  
                } else if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_IMAGE]){
                    ImageViewerViewController *imageViewerViewController = [[ImageViewerViewController alloc] init] ;
                    [imageViewerViewController setUrl:[youtube linkUrl]] ;
                    [imageViewerViewController setTitleName:[youtube title]] ;
                    [self.navigationController pushViewController:imageViewerViewController animated:YES];
                } else if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_POPUP]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[youtube description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
                    [alert show] ;
                }
            }
        }
    }
}

- (void)updateList
{
    [youtubeListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


@end
