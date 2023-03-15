//
//  ConsoleEditShootVideoForMixedViewController.m
//  veam00000000
//
//  Created by veam on 7/12/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "ConsoleEditShootVideoForMixedViewController.h"

#import "ConsoleDropboxViewController.h"
#import "VeamUtil.h"


#define CONSOLE_VIEW_VIDEO_ID           1
#define CONSOLE_VIEW_TITLE              2
//#define CONSOLE_VIEW_DURATION           3
//#define CONSOLE_VIEW_PERIODICAL_FLAG    4
#define CONSOLE_VIEW_THUMBNAIL_IMAGE    5
#define CONSOLE_VIEW_SOURCE_URL         6

@interface ConsoleEditShootVideoForMixedViewController ()

@end

@implementation ConsoleEditShootVideoForMixedViewController

@synthesize videoCategory ;
@synthesize videoSubCategory ;
@synthesize video ;
@synthesize mixed ;
@synthesize shootVideoUrl ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //[self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE|VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT] ;
        [self setHeaderRightText:NSLocalizedString(@"confirm",nil)] ;
        //[self setHeaderTitle:@"YouTube Basic Settings"] ;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat currentY = [self addMainScrollView] ;
    currentY = [self addContents:currentY] ;
    [self setScrollHeight:currentY] ;
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

/*
- (UIImage *)makeThumbnail
{
    // サムネイル作成
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:shootVideoUrl options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CGImageRef image = [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:nil error:nil];
    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);

    return thumbnail ;
}
 */

- (CGFloat)addContents:(CGFloat)y
{
    CGFloat currentY = y ;
    
    currentY += [self addSectionHeader:NSLocalizedString(@"upload_video_to_veam_cloud",nil) y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:NSLocalizedString(@"title",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;

    currentY += 10 ;
    
    movieView = [[MovieView alloc]initWithFrame:CGRectMake(90, currentY, 140, 163)];
    [scrollView addSubview:movieView];
    //[self.view addSubview:movieView];
    movieView.repeat = YES ;
    movieView.clipsToBounds = YES ;
    [movieView setBackgroundColor:[VeamUtil getColorFromArgbString:@"22FFFFFF"]] ;
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, 140, 23)] ;
    [maskView setBackgroundColor:UIColor.whiteColor] ;
    [movieView addSubview:maskView] ;
    currentY += 140 ;
    

/*
    sourceUrlInputBarView = [self addDropboxInputBar:NSLocalizedString(@"video_data_url",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_SOURCE_URL extensions:DROPBOX_VIDEO_EXTENSIONS] ;
    [sourceUrlInputBarView setDelegate:self] ;
    currentY += sourceUrlInputBarView.frame.size.height ;
*/

    /*
    imageUrlInputBarView = [self addDropboxInputBar:NSLocalizedString(@"image_data_url",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_THUMBNAIL_IMAGE extensions:DROPBOX_IMAGE_EXTENSIONS] ;
    [imageUrlInputBarView setDelegate:self] ;
    currentY += imageUrlInputBarView.frame.size.height ;
     */
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    NSString *videoId = @"" ;
    NSString *title = @"" ;
    NSString *sourceUrl = @"" ;
    //NSString *duration = @"" ;
    NSString *imageUrl = @"" ;
    //BOOL periodical = NO ;
    //NSString *description = @"" ;
    if(video != nil){
        videoId = video.videoId ;
        title = video.title ;
        sourceUrl = video.sourceUrl ;
        //duration = video.duration ;
        //description = video.description ;
        //periodical = [video.kind isEqualToString:VEAM_VIDEO_KIND_PERIODICAL] ;
        imageUrl = video.imageUrl ;
    }
    
    //NSLog(@"image url %@",imageUrl) ;
    
    [titleInputBarView setInputValue:title] ;
    [sourceUrlInputBarView setInputValue:sourceUrl] ;
    //[periodicalFlagInputBarView setInputValue:periodical] ;
    [imageUrlInputBarView setInputValue:imageUrl] ;
    
    //[durationInputBarView setInputValue:duration] ;
    //[descriptionInputBarView setInputValue:description] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)didChangeTextInputValue:(ConsoleTextInputBarView *)view value:(NSString *)value
{
    switch (view.tag) {
        case CONSOLE_VIEW_TITLE:
            break;
            
        default:
            break;
    }
}

- (void)didChangeLongTextInputValue:(ConsoleLongTextInputBarView *)view value:(NSString *)value
{
    //NSLog(@"%@::didChangeLongTextInputValue %@",NSStringFromClass([self class]),value) ;
}


- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_THUMBNAIL_IMAGE:
            //NSLog(@"CONSOLE_VIEW_THUMBNAIL_IMAGE") ;
            thumbnailImage = value ;
            break;
        default:
            break;
    }
}

- (void)showDropboxViewController:(ConsoleDropboxInputBarView *)view
{
    ConsoleDropboxViewController *dropboxViewController = [[ConsoleDropboxViewController alloc] init] ;
    [dropboxViewController setDelegate:view] ;
    [dropboxViewController setReturnViewController:self] ;
    [dropboxViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [dropboxViewController setShowFooter:NO] ;
    [dropboxViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
    [dropboxViewController setDropboxPath:@"/"] ;
    [dropboxViewController setHeaderTitle:@"Dropbox"] ;
    [dropboxViewController setExtensions:view.extensions] ;
    [self pushViewController:dropboxViewController] ;
}









- (BOOL)isValueChanged
{
    BOOL retValue = NO ;
    if(video == nil){
        //NSLog(@"new") ;
        retValue = YES ;
    } else {
        NSString *title = [titleInputBarView getInputValue] ;
        NSString *sourceUrl = [sourceUrlInputBarView getInputValue] ;
        NSString *imageUrl = [imageUrlInputBarView getInputValue] ;
        if(
           ![title isEqualToString:video.title] ||
           ![sourceUrl isEqualToString:video.sourceUrl] ||
           ![imageUrl isEqualToString:video.imageUrl]
           ){
            //NSLog(@"modified") ;
            retValue = YES ;
        }
    }
    
    return retValue ;
}

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
    if([self isValueChanged]){
        [self saveValues] ;
    } else {
        //NSLog(@"not modified") ;
        [super didTapClose] ;
    }
}

- (void)didTapClose
{
    //NSLog(@"%@::didTapClose",NSStringFromClass([self class])) ;
    
    if([self isValueChanged]){
        [self.view endEditing:YES] ;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init] ;
        actionSheet.delegate = self ;
        actionSheet.title = nil ;
        [actionSheet addButtonWithTitle:@"Save"] ;
        [actionSheet addButtonWithTitle:@"Discard"] ;
        [actionSheet addButtonWithTitle:@"Cancel"] ;
        actionSheet.cancelButtonIndex = 2 ;
        actionSheet.destructiveButtonIndex = 0 ;
        [actionSheet showInView:self.view] ;
    } else {
        //NSLog(@"not modified") ;
        [super didTapClose] ;
    }
}

- (BOOL)saveValues
{
    //NSLog(@"%@::saveValues",NSStringFromClass([self class])) ;
    NSString *title = [titleInputBarView getInputValue] ;
    /*
    NSString *sourceUrl = [sourceUrlInputBarView getInputValue] ;
    NSString *imageUrl = [imageUrlInputBarView getInputValue] ;
     */
    
    if([VeamUtil isEmpty:title]){
        [VeamUtil dispError:@"Please input title"] ;
        return NO ;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat  = @"yyyyMMddHHmmss" ;
    NSString *fileName = [NSString stringWithFormat:@"s%@.mov",[dateFormatter stringFromDate:[NSDate date]]] ;
    
    NSString *shootPath = shootVideoUrl.path ;
    if(![VeamUtil isEmpty:shootPath]){
        NSString *cachePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
        //NSLog(@"move %@ -> %@",shootPath,cachePath) ;
        [VeamUtil moveFile:shootPath toPath:cachePath] ;
        if([VeamUtil fileExistsAtCachesDirectory:fileName]){
            //NSLog(@"moved") ;
            
            //Create a session w/ background settings
            NSString *backgroundId = [NSString stringWithFormat:@"bg_%@",fileName] ;
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:backgroundId] ;
            NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil] ;
            
            NSURL *uploadUrl = [ConsoleUtil getUploadApiUrl:@"file/upload"] ;
            NSString *urlString = [NSString stringWithFormat:@"%@&k=1&f=%@",uploadUrl.absoluteString,fileName] ;
            uploadUrl = [NSURL URLWithString:urlString] ;
            //NSLog(@"upload url %@",uploadUrl.absoluteString) ;
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:uploadUrl] ;
            [request setHTTPMethod:@"PUT"] ;
            NSURLSessionUploadTask *uploadTask = [upLoadSession uploadTaskWithRequest:request fromFile:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",cachePath]]] ;
            [uploadTask resume] ;
        } else {
            [VeamUtil dispError:@"Failed to copy video"] ;
            return NO ;
        }
    } else {
        [VeamUtil dispError:@"Video not found"] ;
        return NO ;
    }
    
    
    /*
    if([VeamUtil isEmpty:sourceUrl]){
        [VeamUtil dispError:@"Please input video data url"] ;
        return NO ;
    }
    
    if([VeamUtil isEmpty:imageUrl]){
        [VeamUtil dispError:@"Please select image data url"] ;
        return NO ;
    }
    */
    
    if(video == nil){
        //NSLog(@"new video c=%@",videoCategory.videoCategoryId) ;
        video = [[Video alloc] init] ;
        if(videoCategory == nil){
            video.videoCategoryId = @"0" ;
        } else {
            video.videoCategoryId = videoCategory.videoCategoryId ;
        }
        
        if(videoSubCategory == nil){
            video.videoSubCategoryId = @"0" ;
        } else {
            video.videoSubCategoryId = videoSubCategory.videoSubCategoryId ;
        }
        
        if(mixed == nil){
            [video setKind:VEAM_VIDEO_KIND_PERIODICAL] ;
        } else {
            [video setKind:VEAM_VIDEO_KIND_NORMAL] ;
        }
    }
    
    //NSLog(@"name=%@",title) ;
    [video setTitle:title] ;
    
    //NSLog(@"source=%@",url) ;
    [video setSourceUrl:fileName] ;
    
    [video setImageUrl:@"NOIMAGE"] ;
    
    if(mixed != nil){
        [video setMixed:mixed] ;
    }
    
    [self performSelectorInBackground:@selector(doUpdate) withObject:nil] ;
    
    return YES ;
}

- (void)doUpdate
{
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
    [[ConsoleUtil getConsoleContents] setVideo:video thumbnailImage:nil] ;
    [ConsoleUtil updateConsoleContents] ;
    [self performSelectorOnMainThread:@selector(hideProgress) withObject:nil waitUntilDone:NO] ;
    [self performSelectorOnMainThread:@selector(didTapCloseAtSuper) withObject:nil waitUntilDone:NO] ;
}

- (void)didTapCloseAtSuper
{
    [super didTapClose] ;
}

- (void)showProgress
{
    //NSLog(@"%@::showProgress",NSStringFromClass([self class])) ;
    [self showMask:YES] ;
}

- (void)hideProgress
{
    //NSLog(@"%@::hideProgress",NSStringFromClass([self class])) ;
    [self showMask:NO] ;
}



-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Save
            //NSLog(@"save") ;
            [self saveValues] ;
            break ;
        case 1:
            // Discard
            [super didTapClose] ;
            break;
        case 2:
            // Cancel
            //NSLog(@"cancel") ;
            break;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"viewDidAppear") ;
    [super viewDidAppear:animated] ;
    if(!videoStarted){
        videoStarted = YES ;
        [movieView playMovie:shootVideoUrl] ;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    
    [movieView clear] ;
    
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    //NSLog(@"didBecomeInvalidWithError") ;
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    //NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession") ;
}


@end
