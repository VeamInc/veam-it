//
//  VideoViewController.m
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamUtil.h"
#import "VideoViewController.h"
#import "Video.h"
#import "VideoCellViewController.h"
#import "ImageDownloader.h"
//#import "YoutubePlayViewController.h"
#import "WebViewController.h"
#import "ImageViewerViewController.h"
#import "DRMMovieViewController.h"
#import "Video.h"
#import "SubscriptionPurchaseViewController.h"

#define VIDEO_STATUS_DOWNLOADING    1
#define VIDEO_STATUS_WAITING        2
#define VIDEO_STATUS_DOWNLOADED     3
#define VIDEO_STATUS_NOT_DOWNLOADED 4


#define LIST_MODE_NORMAL            1
#define LIST_MODE_DELETE            2

#define ALERT_VIEW_TAG_DOWNLOAD     1
#define ALERT_VIEW_TAG_REMOVE       2


@interface VideoViewController ()

@end

@implementation VideoViewController

@synthesize categoryId ;
@synthesize subCategoryId ;

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
    
    //NSLog(@"VideoViewController::viewDidLoad %@ %@",categoryId,subCategoryId) ;
    
    progressWidth = 135 ;
    
    listMode = LIST_MODE_NORMAL ;

    [self setViewName:[NSString stringWithFormat:@"VideoList/%@/%@/",subCategoryId,self.titleName]] ;

    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary];
    videoDownloadsInProgress = [NSMutableDictionary dictionary];

    videoListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [videoListTableView setDelegate:self] ;
    [videoListTableView setDataSource:self] ;
    [videoListTableView setBackgroundColor:[UIColor clearColor]] ;
    [videoListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [videoListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:videoListTableView] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
    
    /*
    topDeleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-64, ([VeamUtil getTopBarHeight]-30)/2, 30, 30)] ;
    [topDeleteImageView setImage:[UIImage imageNamed:@"top_delete.png"]] ;
    [VeamUtil registerTapAction:topDeleteImageView target:self selector:@selector(onTopDeleteButtonTap)] ;
    [topBarView addSubview:topDeleteImageView] ;
     */
    
    doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(topBarTitleMaxRight-VEAM_SETTINGS_DONE_WIDTH, 0, VEAM_SETTINGS_DONE_WIDTH, [VeamUtil getTopBarHeight])] ;
    [doneLabel setText:NSLocalizedString(@"done",nil)] ;
    [doneLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
    [doneLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [doneLabel setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:doneLabel target:self selector:@selector(onDeleteDoneButtonTap)] ;
    [doneLabel setAlpha:0.0] ;
    [topBarView addSubview:doneLabel] ;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload %@",url) ;
    if(![VeamUtil isEmpty:url]){
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
        VideoCell *cell = (VideoCell *)[videoListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
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
    indexOffset = 1 ;
    if([subCategoryId isEqualToString:@"0"]){
        //NSLog(@"video category id : %@",categoryId) ;
        videos = [VeamUtil getVideosForCategory:categoryId] ;
    } else {
        videos = [VeamUtil getVideosForSubCategory:subCategoryId] ;
    }
    lastIndex = indexOffset + [videos count] ;
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == lastIndex){
        retValue = [VeamUtil getTabBarHeight] ;
    } else {
        retValue = 88.0 ; // video cell height
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (NSInteger)getVideoIndex:(NSIndexPath *)indexPath
{
    return indexPath.row - indexOffset ;
}

- (Video *)getVideoAt:(NSIndexPath *)indexPath
{
    NSInteger index = [self getVideoIndex:indexPath] ;
    Video *video = [videos objectAtIndex:index] ;
    return video ;
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
    } else {
        //NSInteger index = indexPath.row - indexOffset ;
        Video *video = [self getVideoAt:indexPath] ;
        VideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (videoCell == nil) {
            VideoCellViewController *controller = [[VideoCellViewController alloc] initWithNibName:@"VideoCell" bundle:nil] ;
            videoCell = (VideoCell *)controller.view ;
        }
        NSString *title = [video title] ;
        [[videoCell titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[videoCell titleLabel] setNumberOfLines:0];
        CGRect frame = [[videoCell titleLabel] frame] ;
        CGFloat orgWidth = frame.size.width ;
        
        [[videoCell titleLabel] setText:@"Title"] ;
        [[videoCell titleLabel] sizeToFit] ;
        frame = [[videoCell titleLabel] frame] ;
        CGFloat lineHeight = frame.size.height ;
        //NSLog(@"line height=%f",lineHeight) ;
        frame.size.width = orgWidth ;
        [[videoCell titleLabel] setFrame:frame] ;

        [[videoCell titleLabel] setText:title] ;
        [[videoCell titleLabel] sizeToFit] ;
        
        frame = [[videoCell titleLabel] frame] ;
        if(frame.size.height > lineHeight){
            frame.size.height = lineHeight*2 ;
            [[videoCell titleLabel] setFrame:frame] ;
            [[videoCell titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
            [[videoCell titleLabel] setNumberOfLines:2];
        } else {
            frame.origin.y += 12 ;
            [[videoCell titleLabel] setFrame:frame] ;

            frame = [[videoCell durationLabel] frame] ;
            frame.origin.y -= 12 ;
            [[videoCell durationLabel] setFrame:frame] ;
            
            frame = [[videoCell statusLabel] frame] ;
            frame.origin.y -= 12 ;
            [[videoCell statusLabel] setFrame:frame] ;
            /*
             frame = [[videoCell deleteLabel] frame] ;
             frame.origin.y -= 12 ;
             [[videoCell deleteLabel] setFrame:frame] ;
             */
            frame = [[videoCell progressView] frame] ;
            frame.origin.y -= 12 ;
            [[videoCell progressView] setFrame:frame] ;
        }
        

        //NSLog(@"height=%f %@",[[videoCell titleLabel] frame].size.height,[video title]) ;
        NSString *durationString = [video duration] ;
        //NSLog(@"duration:%@",durationString) ;
        if((durationString != nil) && ![durationString isEqualToString:@""] && ![durationString isEqualToString:@"0"]){
            [[videoCell durationLabel] setText:[VeamUtil getDurationString:[video duration]]] ;
        } else {
            [[videoCell durationLabel] setAlpha:0.0] ;
        }
        NSString *thumbnailUrl = [video imageUrl] ;
        UIImage *image = [VeamUtil getCachedImage:thumbnailUrl downloadIfNot:NO] ;
        if(image == nil){
            [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
        } else {
            [[videoCell thumbnailImageView] setImage:image] ;
        }
        cell = videoCell ;
        [videoCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        [videoCell setBackgroundColor:[UIColor clearColor]] ;
        [videoCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        
        [[videoCell progressView] setAlpha:0.0] ;
        if([VeamUtil videoExists:video]){
            [[videoCell titleLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell titleLabel] setHighlightedTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell durationLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell durationLabel] setHighlightedTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell statusLabel] setAlpha:0.0] ;
            [[videoCell deleteLabel] setAlpha:1.0] ;
            videoCell.deleteLabel.tag = [self getVideoIndex:indexPath] ;
            [VeamUtil registerTapAction:videoCell.deleteLabel target:self selector:@selector(didTapDeleteVideo:)] ;
            [[videoCell deleteLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[videoCell thumbnailImageView] setAlpha:1.0] ;
            [[videoCell arrowImageView] setAlpha:1.0] ;
            [[videoCell deleteImageView] setAlpha:0.0] ;
            /*
            if(listMode == LIST_MODE_NORMAL){
                [[videoCell arrowImageView] setAlpha:1.0] ;
                [[videoCell deleteImageView] setAlpha:0.0] ;
            } else {
                [[videoCell arrowImageView] setAlpha:0.0] ;
                [[videoCell deleteImageView] setAlpha:1.0] ;
            }
             */
        } else {
            [[videoCell titleLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF959595"]] ;
            [[videoCell titleLabel] setHighlightedTextColor:[VeamUtil getColorFromArgbString:@"FF959595"]] ;
            [[videoCell durationLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF959595"]] ;
            [[videoCell durationLabel] setHighlightedTextColor:[VeamUtil getColorFromArgbString:@"FF959595"]] ;
            [[videoCell statusLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF959595"]] ;
            [[videoCell statusLabel] setHighlightedTextColor:[VeamUtil getColorFromArgbString:@"FF959595"]] ;
            [[videoCell deleteLabel] setAlpha:0.0] ;
            [[videoCell thumbnailImageView] setAlpha:0.6] ;
            [[videoCell arrowImageView] setAlpha:0.0] ;
            [[videoCell deleteImageView] setAlpha:0.0] ;
        }
        
        if([self isDownloading:video]){
            [[videoCell statusLabel] setText:@"Downloading..."] ;
            float progress = [self getDownloadProgress:video] ;
            CGRect frame = [[videoCell progressView] frame] ;
            frame.size.width = progressWidth * progress ;
            [[videoCell progressView] setFrame:frame] ;
            [[videoCell progressView] setAlpha:1.0] ;
        } else {
            [[videoCell statusLabel] setText:@""] ;
        }
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)playVideo:(Video *)video
{
    
    [VeamUtil playVideo:video title:NSLocalizedString(@"exclusive_video",nil)] ;
    
    /*
    [VeamUtil setMovieKey:[video key]] ;
    DRMMovieViewController* movieViewController = [[DRMMovieViewController alloc] init];
    [movieViewController setVideoTitleName:[video title]] ;
    movieViewController.strPathName = getHttpUrl([video videoId]) ;
    [movieViewController setContentId:[video videoId]] ;
    [movieViewController setTitleName:@"Exclusive Video"] ;
    [self.navigationController pushViewController:movieViewController animated:YES] ;
     */

}

- (BOOL)isDownloading:(Video *)video
{
    BOOL retValue = NO ;
    VideoDownloader *videoDownloader = [videoDownloadsInProgress objectForKey:[video videoId]] ;
    if(videoDownloader != nil){
        retValue = YES ;
    }
    return retValue ;
}

- (float)getDownloadProgress:(Video *)video
{
    float retValue = 0.0 ;
    VideoDownloader *videoDownloader = [videoDownloadsInProgress objectForKey:[video videoId]] ;
    if(videoDownloader != nil){
        retValue = [videoDownloader getProgress] ;
    }
    return retValue ;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.row == lastIndex){
        return ;
    }
    
    NSInteger index = indexPath.row - indexOffset ;
    if(index >= 0){
        Video *video = [videos objectAtIndex:index] ;
        if(video != nil){
            if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
                //NSLog(@"video tapped : %@ %@",[video videoId],[video title]) ;
                if([VeamUtil videoExists:video]){
                    if(listMode == LIST_MODE_NORMAL){
                        // play video
                        [self playVideo:video] ;
                    } else if(listMode == LIST_MODE_DELETE) {
                        //NSLog(@"remove video file") ;
                        currentVideo = video ;
                        currentIndexPath = indexPath ;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Remove this video?" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
                        [alert setTag:ALERT_VIEW_TAG_REMOVE] ;
                        [alert show];
                    }
                } else {
                    if(listMode == LIST_MODE_NORMAL){
                        if(![self isDownloading:video]){
                            // confirm download
                            currentVideo = video ;
                            currentIndexPath = indexPath ;
                            //NSLog(@"video url = %@",[currentVideo dataUrl]) ;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"download_this_video",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
                            [alert setTag:ALERT_VIEW_TAG_DOWNLOAD] ;
                            [alert show];
                        } else {
                            //NSLog(@"downloading") ;
                        }
                    }
                }
            } else {
                SubscriptionPurchaseViewController *subscriptionPurchaseViewController = [[SubscriptionPurchaseViewController alloc] init] ;
                [subscriptionPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
                [subscriptionPurchaseViewController setTitle:@"About Subscription"] ;
                [self.navigationController pushViewController:subscriptionPurchaseViewController animated:YES] ;
            }
        
            /*
            if([[video kind] isEqualToString:VEAM_YOUTUBE_KIND_NORMAL]){
                YoutubePlayViewController *youtubePlayViewController = [[YoutubePlayViewController alloc] init] ;
                [youtubePlayViewController setYoutubeVideo:youtubeVideo] ;
                [youtubePlayViewController setTitleName:@"image:youtube.png"] ;
                [self.navigationController pushViewController:youtubePlayViewController animated:YES] ;
            } else if([[youtubeVideo kind] isEqualToString:VEAM_YOUTUBE_KIND_WEB]){
                // show youtube channel
                WebViewController *webViewController = [[WebViewController alloc] init] ;
                [webViewController setUrl:[youtubeVideo linkUrl]] ;
                [webViewController setTitleName:[youtubeVideo title]] ;
                [webViewController setShowBackButton:YES] ;
                [self.navigationController pushViewController:webViewController animated:YES];  
            } else if([[youtubeVideo kind] isEqualToString:VEAM_YOUTUBE_KIND_IMAGE]){
                ImageViewerViewController *imageViewerViewController = [[ImageViewerViewController alloc] init] ;
                [imageViewerViewController setUrl:[youtubeVideo linkUrl]] ;
                [imageViewerViewController setTitleName:[youtubeVideo title]] ;
                [self.navigationController pushViewController:imageViewerViewController animated:YES];
            } else if([[youtubeVideo kind] isEqualToString:VEAM_YOUTUBE_KIND_POPUP]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[youtubeVideo description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
                [alert show] ;
            }
             */
        }
    }
}


- (void)didTapDeleteVideo:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender ;
    NSInteger index = tap.view.tag ;
    
    Video *video = [videos objectAtIndex:index] ;
    if(video != nil){
        if([VeamUtil videoExists:video]){
            //NSLog(@"remove video file") ;
            currentVideo = video ;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"confirmation",nil) message:@"eliminate file from internal storage?\n( no charge for re-downloading )" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
            [alert setTag:ALERT_VIEW_TAG_REMOVE] ;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if([alertView tag] == ALERT_VIEW_TAG_DOWNLOAD){
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
            {
                // OK
                // start downloading
                //NSLog(@"video url = %@",[currentVideo dataUrl]) ;
                Video *downloadableVideo = [[Video alloc] init] ;
                [downloadableVideo setVideoId:[currentVideo videoId]] ;
                [downloadableVideo setDataUrl:[currentVideo dataUrl]] ;
                [downloadableVideo setDataSize:[currentVideo dataSize]] ;

                previewDownloader = [[PreviewDownloader alloc]
                                     initWithDownloadableVideo:downloadableVideo
                                     dialogTitle:NSLocalizedString(@"PreviewDownloadTitie", nil)
                                     dialogDescription:NSLocalizedString(@"PreviewDownloadDescription",nil)
                                     dialogCancelText:NSLocalizedString(@"cancel",nil)
                                     ] ;
                
                previewDownloader.delegate = self ;
                /*
                [self setVideoStatus:VIDEO_STATUS_DOWNLOADING indexPath:currentIndexPath] ;
                VideoDownloader *videoDownloader = [[VideoDownloader alloc] initWithVideo:currentVideo indexPath:currentIndexPath delegate:self] ;
                [videoDownloadsInProgress setObject:videoDownloader forKey:[currentVideo videoId]] ;
                 */
            }
                break;
        }
    } else if([alertView tag] == ALERT_VIEW_TAG_REMOVE){
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
                // OK
                [VeamUtil removeVideoFile:[currentVideo videoId]] ;
                [videoListTableView reloadData] ;
                break;
        }
    }
}


-(void)setVideoStatus:(NSInteger)status indexPath:(NSIndexPath *)indexPath
{
    VideoCell *videoCell = (VideoCell *)[videoListTableView cellForRowAtIndexPath:indexPath] ;
    if(videoCell != nil){
        switch (status) {
            case VIDEO_STATUS_DOWNLOADING:
                //NSLog(@"show downloading status") ;
                [[videoCell statusLabel] setText:@"Downloading..."] ;
                [[videoCell statusLabel] setAlpha:1.0] ;
                [[videoCell progressView] setAlpha:1.0] ;
                CGRect frame = [[videoCell progressView] frame] ;
                frame.size.width = 1 ;
                [[videoCell progressView] setFrame:frame] ;
                break;
            case VIDEO_STATUS_WAITING:
                [[videoCell statusLabel] setText:@"Waiting..."] ;
                [[videoCell statusLabel] setAlpha:1.0] ;
                [[videoCell progressView] setAlpha:0.0] ;
                break;
            case VIDEO_STATUS_DOWNLOADED:
                [[videoCell statusLabel] setText:@""] ;
                [[videoCell statusLabel] setAlpha:0.0] ;
                [[videoCell titleLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
                [[videoCell durationLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
                [[videoCell thumbnailImageView] setAlpha:1.0] ;
                [[videoCell arrowImageView] setAlpha:1.0] ;
                [[videoCell progressView] setAlpha:0.0] ;
                break;
            case VIDEO_STATUS_NOT_DOWNLOADED:
                [[videoCell statusLabel] setText:@""] ;
                [[videoCell statusLabel] setAlpha:0.0] ;
                [[videoCell progressView] setAlpha:0.0] ;
                break;
                
            default:
                break;
        }
    }
}



-(void) previewDownloadCompleted:(Video *)downloadableVideo
{
    //NSLog(@"download completed. play movie") ;
    //[self trackEvent:[NSString stringWithFormat:@"PreviewDownloadComplete-%@",contentId]] ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
    [videoListTableView reloadData] ;
}

-(void) previewDownloadCancelled:(Video *)downloadableVideo
{
    //NSLog(@"download cancelled.") ;
    //[self trackEvent:[NSString stringWithFormat:@"PreviewDownloadCancel-%@",contentId]] ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
}





-(void) videoDownloadCompleted:(Video *)video indexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"download completed. play movie") ;
    [self setVideoStatus:VIDEO_STATUS_DOWNLOADED indexPath:indexPath] ;
    VideoDownloader *videoDownloader = [videoDownloadsInProgress objectForKey:[video videoId]] ;
    if(videoDownloader != nil){
        videoDownloader.delegate = nil ;
    }
    [videoDownloadsInProgress removeObjectForKey:[video videoId]] ;
    //[self playVideo:video] ;
}

-(void) videoDownloadCancelled:(Video *)video indexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"download cancelled.") ;
    [self setVideoStatus:VIDEO_STATUS_NOT_DOWNLOADED indexPath:indexPath] ;
    VideoDownloader *videoDownloader = [videoDownloadsInProgress objectForKey:[video videoId]] ;
    if(videoDownloader != nil){
        videoDownloader.delegate = nil ;
    }
    [videoDownloadsInProgress removeObjectForKey:[video videoId]] ;
}

-(void) videoDownloadProgress:(Video *)video progress:(float)progress indexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"progress %d",(int)(progress * 100)) ;
    VideoCell *videoCell = (VideoCell *)[videoListTableView cellForRowAtIndexPath:indexPath] ;
    if(videoCell != nil){
        CGRect frame = [[videoCell progressView] frame] ;
        frame.size.width = progressWidth * progress ;
        [[videoCell progressView] setFrame:frame] ;
        [[videoCell progressView] setAlpha:1.0] ;
    }
}

-(void)onTopDeleteButtonTap
{
    // disabled
    /*
    listMode = LIST_MODE_DELETE ;
    [topBarLabel setText:@"Delete videos from device"] ;
    [doneLabel setAlpha:1.0] ;
    [topDeleteImageView setAlpha:0.0] ;
    [settingsImageView setAlpha:0.0] ;
    [videoListTableView reloadData] ;
     */
}

-(void)onDeleteDoneButtonTap
{
    // disabled
    /*
    listMode = LIST_MODE_NORMAL ;
    [topBarLabel setText:self.titleName] ;
    [doneLabel setAlpha:0.0] ;
    [topDeleteImageView setAlpha:1.0] ;
    [settingsImageView setAlpha:1.0] ;
    [videoListTableView reloadData] ;
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    /*
    NSString *linkUrl = [VeamUtil getLinkUrl] ;
    if(![VeamUtil isEmpty:linkUrl]){
        WebViewController *webViewController = [[WebViewController alloc] init] ;
        [webViewController setUrl:linkUrl] ;
        [webViewController setTitleName:@"Web"] ;
        [webViewController setShowBackButton:YES] ;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    */
}


- (void)updateList
{
    [videoListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


@end
