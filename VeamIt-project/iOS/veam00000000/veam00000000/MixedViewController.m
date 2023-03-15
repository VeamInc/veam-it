//
//  MixedViewController.m
//  veam00000000
//
//  Created by veam on 6/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "MixedViewController.h"
#import "VeamUtil.h"
#import "Mixed.h"
#import "MixedCellViewController.h"
#import "ImageDownloader.h"
#import "WebViewController.h"
#import "ImageViewerViewController.h"
#import "RecipeDetailViewController.h"
#import "VideoCellViewController.h"

#define ALERT_VIEW_TAG_VIDEO_DOWNLOAD     1
#define ALERT_VIEW_TAG_VIDEO_REMOVE       2


@interface MixedViewController ()

@end

@implementation MixedViewController

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
    
    //NSLog(@"MixedViewController::viewDidLoad %@ %@",categoryId,subCategoryId) ;
    
    [self setViewName:[NSString stringWithFormat:@"MixedList/%@/%@/",subCategoryId,self.titleName]] ;
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary];
    
    mixedListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [mixedListTableView setDelegate:self] ;
    [mixedListTableView setDataSource:self] ;
    [mixedListTableView setBackgroundColor:[UIColor clearColor]] ;
    [mixedListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [mixedListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:mixedListTableView] ;
    
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
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        MixedCell *cell = (MixedCell *)[mixedListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            // cell.thumbnailImageView.image = imageDownloader.pictureImage ;
            cell.thumbnailImageView.image = [VeamUtil getSquareImage:imageDownloader.pictureImage] ;
        }
    } else {
        //NSLog(@"imageDownloader is nil") ;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%@::numberOfRowsInSection c=%@ s=%@",NSStringFromClass([self class]),categoryId,subCategoryId) ;
    
    indexOffset = 1 ;
    if([subCategoryId isEqualToString:@"0"]){
        if([categoryId isEqualToString:VEAM_MIXED_CATEGORY_ID_SUBSCRIPTION]){
            //NSLog(@"Subscription") ;
            mixeds = [VeamUtil getMixedsForSubscription:NO] ;
        } else {
            mixeds = [VeamUtil getMixedsForCategory:categoryId] ;
        }
    } else {
        mixeds = [VeamUtil getMixedsForSubCategory:subCategoryId] ;
    }
    lastIndex = indexOffset + [mixeds count] ;
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
        retValue = 88.0 ; // mixed cell height
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (UITableViewCell *)getCell:(Mixed *)mixed indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil ;
    NSInteger index = indexPath.row - indexOffset ;
    
    if([mixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_RECIPE]){
        MixedCellViewController *controller = [[MixedCellViewController alloc] initWithNibName:@"MixedCell" bundle:nil] ;
        MixedCell *mixedCell = (MixedCell *)controller.view ;
        NSString *title = [mixed title] ;
        [[mixedCell titleLabel] setLineBreakMode:NSLineBreakByWordWrapping] ;
        [[mixedCell titleLabel] setNumberOfLines:0];
        //CGRect frame = [[mixedCell titleLabel] frame] ;
        //CGFloat orgWidth = frame.size.width ;
        //[[mixedCell titleLabel] setText:@"Title"] ;
        [[mixedCell titleLabel] setText:title] ;
        [[mixedCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[mixedCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
        //NSLog(@"height=%f %@",[[mixedCell titleLabel] frame].size.height,[mixed title]) ;
        NSString *thumbnailUrl =  mixed.thumbnailUrl ;
        if([VeamUtil isEmpty:thumbnailUrl]){
            [mixedCell.thumbnailImageView setImage:[VeamUtil imageNamed:@"no_recipe_s.png"]] ;
        } else {
            [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
        }
        cell = mixedCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    } else if([mixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ||
              [mixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO] ){
        
        NSString *thumbnailUrl = [mixed thumbnailUrl] ;
        NSString *title = @"" ;
        NSString *durationString = @"0" ;

        Video *video = [VeamUtil getVideoForId:mixed.contentId] ;
        title = [video title] ;
        durationString = [video duration] ;
        
        VideoCellViewController *controller = [[VideoCellViewController alloc] initWithNibName:@"VideoCell" bundle:nil] ;
        VideoCell *videoCell = (VideoCell *)controller.view ;
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
            
            frame = [[videoCell progressView] frame] ;
            frame.origin.y -= 12 ;
            [[videoCell progressView] setFrame:frame] ;
        }
        //NSLog(@"height=%f %@",[[videoCell titleLabel] frame].size.height,[video title]) ;
        //NSLog(@"duration:%@",durationString) ;
        if((durationString != nil) && ![durationString isEqualToString:@""] && ![durationString isEqualToString:@"0"]){
            [[videoCell durationLabel] setText:[VeamUtil getDurationString:durationString]] ;
        } else {
            [[videoCell durationLabel] setAlpha:0.0] ;
        }
        UIImage *image = [VeamUtil getCachedImage:thumbnailUrl downloadIfNot:NO] ;
        if(image == nil){
            [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
        } else {
            [[videoCell thumbnailImageView] setImage:image] ;
        }
        cell = videoCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        
        [[videoCell progressView] setAlpha:0.0] ;
        if([VeamUtil videoExists:video]){
            [[videoCell titleLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell titleLabel] setHighlightedTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell durationLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell durationLabel] setHighlightedTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
            [[videoCell statusLabel] setAlpha:0.0] ;
            [[videoCell deleteLabel] setAlpha:1.0] ;
            videoCell.deleteLabel.tag = index ;
            [VeamUtil registerTapAction:videoCell.deleteLabel target:self selector:@selector(didTapDeleteVideo:)] ;
            [[videoCell deleteLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[videoCell thumbnailImageView] setAlpha:1.0] ;
            [[videoCell arrowImageView] setAlpha:1.0] ;
            [[videoCell deleteImageView] setAlpha:0.0] ;
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

        [[videoCell statusLabel] setText:@""] ;
        
        cell = videoCell ;
    } else if([mixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO] ||
              [mixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO] ){
        
        NSString *thumbnailUrl = [mixed thumbnailUrl] ;
        NSString *title = @"" ;
        NSString *durationString = @"0" ;
        
        Audio *audio = [VeamUtil getAudioForId:mixed.contentId] ;
        title = [audio title] ;
        durationString = [audio duration] ;
        
        VideoCellViewController *controller = [[VideoCellViewController alloc] initWithNibName:@"VideoCell" bundle:nil] ;
        VideoCell *videoCell = (VideoCell *)controller.view ;
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
            
            frame = [[videoCell progressView] frame] ;
            frame.origin.y -= 12 ;
            [[videoCell progressView] setFrame:frame] ;
        }
        //NSLog(@"height=%f %@",[[videoCell titleLabel] frame].size.height,[video title]) ;
        //NSLog(@"duration:%@",durationString) ;
        if((durationString != nil) && ![durationString isEqualToString:@""] && ![durationString isEqualToString:@"0"]){
            [[videoCell durationLabel] setText:[VeamUtil getDurationString:durationString]] ;
        } else {
            [[videoCell durationLabel] setAlpha:0.0] ;
        }
        UIImage *image = [VeamUtil getCachedImage:thumbnailUrl downloadIfNot:NO] ;
        if(image == nil){
            [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
        } else {
            [[videoCell thumbnailImageView] setImage:image] ;
        }
        cell = videoCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        
        [[videoCell progressView] setAlpha:0.0] ;
        
        [[videoCell titleLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
        [[videoCell durationLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
        [[videoCell statusLabel] setAlpha:0.0] ;
        [[videoCell deleteLabel] setAlpha:0.0] ;
        /*
        videoCell.deleteLabel.tag = index ;
        [VeamUtil registerTapAction:videoCell.deleteLabel target:self selector:@selector(didTapDeleteVideo:)] ;
        [[videoCell deleteLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
         */
        [[videoCell thumbnailImageView] setAlpha:1.0] ;
        [[videoCell arrowImageView] setAlpha:1.0] ;
        [[videoCell deleteImageView] setAlpha:0.0] ;
        
        [[videoCell statusLabel] setText:@""] ;
        
        cell = videoCell ;
    }
    
    return cell ;

}

- (void)didTapDeleteVideo:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender ;
    NSInteger index = tap.view.tag ;
    
    Mixed *mixed = [mixeds objectAtIndex:index] ;
    Video *video = [VeamUtil getVideoForId:mixed.contentId] ;

    if(video != nil){
        if([VeamUtil videoExists:video]){
            //NSLog(@"remove video file") ;
            currentVideo = video ;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"confirmation",nil) message:@"eliminate file from internal storage?\n( no charge for re-downloading )" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
            [alert setTag:ALERT_VIEW_TAG_VIDEO_REMOVE] ;
            [alert show];
        }
    }
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
        NSInteger index = indexPath.row - indexOffset ;
        Mixed *mixed = [mixeds objectAtIndex:index] ;
        cell = [self getCell:mixed indexPath:indexPath] ;
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
    NSInteger index = indexPath.row - indexOffset ;
    if(index >= 0){
        Mixed *mixed = [mixeds objectAtIndex:index] ;
        if(mixed != nil){
            //NSLog(@"mixed tapped : %@ %@",[mixed contentVideoId],[mixed title]) ;
            
            if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_RECIPE]){
                Recipe *recipe = [VeamUtil getRecipeForId:mixed.contentId] ;
                if(recipe != nil){
                    //NSLog(@"recipe tapped : %@ %@",[recipe recipeId],[recipe title]) ;
                    //[VeamUtil showRecipeDetailView:recipe title:self.titleName] ;
                    
                    RecipeDetailViewController *recipeDetailViewController = [[RecipeDetailViewController alloc] init] ;
                    [recipeDetailViewController setRecipe:recipe] ;
                    [recipeDetailViewController setTitleName:self.titleName] ;
                    //[recipeDetailViewController setHidesBottomBarWhenPushed:YES] ;
                    [self.navigationController pushViewController:recipeDetailViewController animated:YES] ;
                }
            } else if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ||
                      [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO]){
                //NSLog(@"video") ;
                Video *video = [VeamUtil getVideoForId:mixed.contentId] ;
                if(video != nil){
                    if([VeamUtil videoExists:video]){
                        //NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[video createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
                        [VeamUtil playVideo:video title:self.titleName] ;
                    } else {
                        // confirm download
                        currentVideo = video ;
                        //NSLog(@"video url = %@",[currentVideo dataUrl]) ;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"download_this_video",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
                        [alert setTag:ALERT_VIEW_TAG_VIDEO_DOWNLOAD] ;
                        [alert show];
                    }
                }
            } else if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO] ||
                      [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO]){
                //NSLog(@"audio") ;
                Audio *audio = [VeamUtil getAudioForId:mixed.contentId] ;
                if(audio != nil){
                    //NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[audio createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
                    [VeamUtil playAudio:audio title:self.titleName] ;
                }
            }

        }
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if([alertView tag] == ALERT_VIEW_TAG_VIDEO_DOWNLOAD){
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
            }
                break;
        }
    } else if([alertView tag] == ALERT_VIEW_TAG_VIDEO_REMOVE){
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
                // OK
                [VeamUtil removeVideoFile:[currentVideo videoId]] ;
                [self updateList] ;
                break;
        }
    }
}

-(void) previewDownloadCompleted:(Video *)downloadableVideo
{
    [VeamUtil playVideo:currentVideo title:self.titleName] ;
}

-(void) previewDownloadCancelled:(Video *)downloadableVideo
{
    
}


- (void)updateList
{
    [mixedListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


@end
