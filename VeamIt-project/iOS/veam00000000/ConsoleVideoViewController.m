//
//  ConsoleVideoViewController.m
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleVideoViewController.h"
#import "VeamUtil.h"
#import "ConsoleEditVideoViewController.h"
#import "ConsoleVideoTableViewCell.h"
#import "ImageDownloader.h"
#import "ConsoleVideoNotificationTableViewCell.h"
#import "ConsoleCustomizeViewController.h"
#import "AppDelegate.h"

@interface ConsoleVideoViewController ()

@end

@implementation ConsoleVideoViewController

@synthesize videoCategory ;
@synthesize videoSubCategory ;
@synthesize showCustomizeFirst ;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.shouldShowFloatingMenu = YES ;
    }
    return self;
}

- (void)showFloatingMenu
{
    //NSLog(@"%@::showFloatingMenu",NSStringFromClass([self class])) ;
    
    NSInteger numberOfWaitingVideos = [[ConsoleUtil getConsoleContents] getNumberOfWaitingVideoForCategory:videoCategory.videoCategoryId] ;
    NSString *badgeString = @"" ;
    if(numberOfWaitingVideos > 0){
        badgeString = [NSString stringWithFormat:@"%d",numberOfWaitingVideos] ;
    }
    
    NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"NO",@"SELECTED",nil] ;
    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"YES",@"SELECTED",badgeString,@"BADGE",nil] ;
    NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
    NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3, nil] ;
    [VeamUtil showFloatingMenu:elements delegate:self] ;
    
}

- (void)didTapFloatingMenu:(NSInteger)index
{
    //NSLog(@"%@::didTapFloatingMenu index=%d",NSStringFromClass([self class]),index) ;
    if(index == 0){
        [self handleSwipeRightGesture:nil] ;
    } else if(index == 2){
        [self handleSwipeLeftGesture:nil] ;
    }
}


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
    // Do any additional setup after loading the view.
    
    needTimer = YES ;
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary] ;
    
    CGFloat currentY = [self addMainTableView] ;
    [tableView setDelegate:self] ;
    [tableView setDataSource:self] ;
    [tableView setContentInset:UIEdgeInsetsMake(44, 0, 100, 0)] ;
    
    if(showCustomizeFirst){
        [self handleSwipeLeftGesture:nil] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (Video *)getVideoAt:(NSInteger)index
{
    Video *retValue = nil ;
    if(videoSubCategory == nil){
        retValue = [[ConsoleUtil getConsoleContents] getVideoForCategory:videoCategory.videoCategoryId at:index] ;
    } else {
        retValue = [[ConsoleUtil getConsoleContents] getVideoForSubCategory:videoSubCategory.videoSubCategoryId at:index] ;
    }
    return retValue ;
}

- (void)removeVideoAt:(NSInteger)index
{
    if(videoSubCategory == nil){
        [[ConsoleUtil getConsoleContents] removeVideoForCategory:(NSString *)videoCategory.videoCategoryId at:index] ;
    } else {
        [[ConsoleUtil getConsoleContents] removeVideoForSubCategory:(NSString *)videoSubCategory.videoSubCategoryId at:index] ;
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 0 ;
    if(section == 0){
        if(videoSubCategory == nil){
            numberOfVideos = [[ConsoleUtil getConsoleContents] getNumberOfVideosForCategory:videoCategory.videoCategoryId] ;
        } else {
            numberOfVideos = [[ConsoleUtil getConsoleContents] getNumberOfVideosForSubCategory:videoSubCategory.videoSubCategoryId] ;
        }
        retValue = numberOfVideos + 1 ; // + add cell
    }
    
    //NSLog(@"numberOfRowsInSection section=%d number=%d",section,retValue) ;
    return retValue ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat retValue = 0 ;
    return retValue ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = nil ;
    return sectionHeaderView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideos){
            retValue = [ConsoleVideoTableViewCell getCellHeight] ;
        } else {
            retValue = 44 ; // TODO addCell getCellHeight
        }
    }
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@::cellForRowAtIndexPath section=%d row=%d",NSStringFromClass([self class]),indexPath.section,indexPath.row) ;

    UITableViewCell *cell = nil ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideos){
            BOOL isLast = (indexPath.row == (numberOfVideos-1)) ;
            Video *video = [self getVideoAt:indexPath.row] ;
            ConsoleVideoTableViewCell *videoCell = [[ConsoleVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" video:video isLast:isLast] ;
            [VeamUtil registerTapAction:videoCell.deleteImageView target:self selector:@selector(didDeleteButtonTap:)] ;
            videoCell.deleteImageView.tag = indexPath.row ;
            
            NSString *thumbnailUrl = [video imageUrl] ;
            if(![VeamUtil isEmpty:thumbnailUrl]){
                UIImage *image = [VeamUtil getCachedImage:thumbnailUrl downloadIfNot:NO] ;
                if(image == nil){
                    [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
                } else {
                    [[videoCell thumbnailImageView] setImage:image] ;
                }
            }

            
            cell = videoCell ;
        } else {
            if([[ConsoleUtil getConsoleContents].appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_SETTING]){
                // Hel light 24p
                ConsoleVideoNotificationTableViewCell *videoNotificationCell = [[ConsoleVideoNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
                [videoNotificationCell.titleLabel setText:@"Need at least 3 videos for registration to appstore. Make new videos & upload here."] ;
                cell = videoNotificationCell ;
            } else {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
                cell.textLabel.text = @"" ;
                cell.textLabel.font = [UIFont systemFontOfSize:15.5] ;
            }
            [cell setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        }
    }
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnknownCell"] ;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
        [cell.textLabel setText:@""] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }
    
    return cell;
}

- (void)didDeleteButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger index = singleTapGesture.view.tag ;
    //NSLog(@"delete %d",index) ;
    indexToBeDeleted = index ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Delete Video?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] ;
    //[alert setTag:ALERT_VIEW_TAG_REMOVE] ;
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    switch (buttonIndex) {
        case 0:
            // cancel
            break;
        case 1:
            // OK
            [self removeVideoAt:indexToBeDeleted] ;
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath") ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideos){
            Video *video = [self getVideoAt:indexPath.row] ;
            if(video != nil){
                ConsoleEditVideoViewController *editVideoViewController = [[ConsoleEditVideoViewController alloc] init] ;
                [editVideoViewController setVideo:video] ;
                [editVideoViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
                [self pushViewController:editVideoViewController] ;
            }
        } else {
            /*
            //NSLog(@"Add Video c=%@",videoCategory.videoCategoryId) ;
            ConsoleEditVideoViewController *editVideoViewController = [[ConsoleEditVideoViewController alloc] init] ;
            [editVideoViewController setVideoCategory:videoCategory] ;
            [editVideoViewController setVideoSubCategory:videoSubCategory] ;
            [self pushViewController:editVideoViewController] ;
             */
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"canMoveRowAtIndexPath row=%d",indexPath.row) ;
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideos){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    if(fromIndexPath.row != toIndexPath.row){
        if(videoSubCategory == nil){
            [[ConsoleUtil getConsoleContents] moveVideoForCategory:(NSString *)videoCategory.videoCategoryId from:fromIndexPath.row to:toIndexPath.row] ;
        } else {
            [[ConsoleUtil getConsoleContents] moveVideoForSubCategory:(NSString *)videoSubCategory.videoSubCategoryId from:fromIndexPath.row to:toIndexPath.row] ;
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *retValue = sourceIndexPath ;
    if (proposedDestinationIndexPath.section == 0) {
        if(proposedDestinationIndexPath.row < numberOfVideos){
            retValue = proposedDestinationIndexPath ;
        } else {
            retValue = [NSIndexPath indexPathForRow:numberOfVideos-1 inSection:sourceIndexPath.section] ;
        }
    }
    return retValue ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideos){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(videoSubCategory == nil){
            [[ConsoleUtil getConsoleContents] removeVideoForCategory:(NSString *)videoCategory.videoCategoryId at:indexPath.row] ;
        } else {
            [[ConsoleUtil getConsoleContents] removeVideoForSubCategory:(NSString *)videoSubCategory.videoSubCategoryId at:indexPath.row] ;
        }
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade] ;
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
}

- (void)reloadValues
{
    [tableView reloadData] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
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
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        ConsoleVideoTableViewCell *cell = (ConsoleVideoTableViewCell *)[tableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView] ;
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.thumbnailImageView.image = imageDownloader.pictureImage ;
        }
    } else {
        //NSLog(@"imageDownloader is nil") ;
    }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
    
    ConsoleCustomizeViewController *viewController = [[ConsoleCustomizeViewController alloc] init] ;
    
    [viewController setCustomizeKind:VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION] ;
    [viewController setHideHeaderBottomLine:YES] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:@"Premium - Customize"] ;
    [viewController setNumberOfHeaderDots:3] ;
    [viewController setSelectedHeaderDot:2] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [self pushViewController:viewController] ;

}

- (void)unsetUpdateTimer
{
    if(updateTimer != nil){
        //NSLog(@"updateTimer invalidate") ;
        [updateTimer invalidate] ;
        updateTimer = nil ;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@::viewWillAppear",NSStringFromClass([self class])) ;
    [super viewWillAppear:animated] ;

    [[ConsoleUtil getConsoleContents] updatePreparingVideoStatus:videoCategory.videoCategoryId] ;

    [self unsetUpdateTimer] ;
    if(needTimer){
        //NSLog(@"updateTimer scheduledTimerWithTimeInterval") ;
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(handleUpdateTimer:) userInfo:nil repeats:YES] ;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"%@::viewWillDisappear",NSStringFromClass([self class])) ;
    [super viewWillDisappear:animated] ;
    [self unsetUpdateTimer] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"%@::viewDidDisappear",NSStringFromClass([self class])) ;
    [super viewDidDisappear:animated] ;
    [self unsetUpdateTimer] ;
}

-(void)handleUpdateTimer:(NSTimer*)timer
{
    //NSLog(@"%@::handleUpdateTimer",NSStringFromClass([self class])) ;
    if([[AppDelegate sharedInstance] isShowingPreview]){
        [self unsetUpdateTimer] ;
    } else {
        [[ConsoleUtil getConsoleContents] updatePreparingVideoStatus:videoCategory.videoCategoryId] ;
    }
}

- (void)didTapBack
{
    needTimer = NO ;
    [self unsetUpdateTimer] ;
    [super didTapBack] ;
}

-(void)dealloc
{
    //NSLog(@"%@::dealloc",NSStringFromClass([self class])) ;
}


@end
