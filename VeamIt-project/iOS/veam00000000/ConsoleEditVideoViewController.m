//
//  ConsoleEditVideoViewController.m
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditVideoViewController.h"
#import "ConsoleDropboxViewController.h"
#import "VeamUtil.h"

#define CONSOLE_VIEW_VIDEO_ID           1
#define CONSOLE_VIEW_TITLE              2
//#define CONSOLE_VIEW_DURATION           3
//#define CONSOLE_VIEW_PERIODICAL_FLAG    4
#define CONSOLE_VIEW_THUMBNAIL_IMAGE    5
#define CONSOLE_VIEW_SOURCE_URL         6

@interface ConsoleEditVideoViewController ()

@end

@implementation ConsoleEditVideoViewController

@synthesize videoCategory ;
@synthesize videoSubCategory ;
@synthesize video ;
@synthesize mixed ;

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

- (CGFloat)addContents:(CGFloat)y
{
    CGFloat currentY = y ;
    
    currentY += [self addSectionHeader:@"Upload Video to Veam Cloud" y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:@"Title" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    sourceUrlInputBarView = [self addDropboxInputBar:@"Dropbox URL" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_SOURCE_URL extensions:DROPBOX_VIDEO_EXTENSIONS] ;
    [sourceUrlInputBarView setDelegate:self] ;
    currentY += sourceUrlInputBarView.frame.size.height ;
    
    /*
    periodicalFlagInputBarView = [self addSwitchBar:@"Periodical" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_PERIODICAL_FLAG] ;
    [periodicalFlagInputBarView setDelegate:self] ;
    currentY += periodicalFlagInputBarView.frame.size.height ;
     */
    
    /*
    durationInputBarView = [self addTextInputBar:@"Duration" y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_DURATION] ;
    [durationInputBarView setDelegate:self] ;
    currentY += durationInputBarView.frame.size.height ;
     */
    
    if(mixed == nil){
        thumbnailImageInputBarView = [self addImageInputBar:@"Thumbnail" y:currentY fullBottomLine:YES
                                        displayWidth:240 displayHeight:180 cropWidth:240 cropHeight:180 resizableCropArea:NO tag:CONSOLE_VIEW_THUMBNAIL_IMAGE] ;
    } else {
        thumbnailImageInputBarView = [self addImageInputBar:@"Thumbnail" y:currentY fullBottomLine:YES
                                               displayWidth:240 displayHeight:240 cropWidth:320 cropHeight:320 resizableCropArea:NO tag:CONSOLE_VIEW_THUMBNAIL_IMAGE] ;
    }
    currentY += thumbnailImageInputBarView.frame.size.height ;
    

    /*
    descriptionInputBarView = [self addLongTextInputBar:@"Description" y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_DESCRIPTION] ;
    [descriptionInputBarView setDelegate:self] ;
    currentY += descriptionInputBarView.frame.size.height ;
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
    [thumbnailImageInputBarView setInputValue:imageUrl] ;

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
        NSString *url = [sourceUrlInputBarView getInputValue] ;
        NSString *thumbnailUrl = [thumbnailImageInputBarView getInputValue] ;
        if(
           (thumbnailImage != nil) ||
           ![title isEqualToString:video.title] ||
           ![url isEqualToString:video.sourceUrl]
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
    NSString *url = [sourceUrlInputBarView getInputValue] ;
    NSString *thumbnailUrl = [thumbnailImageInputBarView getInputValue] ;
    if([VeamUtil isEmpty:title]){
        [VeamUtil dispError:@"Please input title"] ;
        return NO ;
    }
    if([VeamUtil isEmpty:url]){
        [VeamUtil dispError:@"Please input dropbox url"] ;
        return NO ;
    }
    
    if([VeamUtil isEmpty:thumbnailUrl] && (thumbnailImage == nil)){
        [VeamUtil dispError:@"Please select thumbnail"] ;
        return NO ;
    }
    
    
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
    [video setSourceUrl:url] ;
    
    if(mixed != nil){
        [video setMixed:mixed] ;
    }

    [self performSelectorInBackground:@selector(doUpdate) withObject:nil] ;

    return YES ;
}

- (void)doUpdate
{
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
    [[ConsoleUtil getConsoleContents] setVideo:video thumbnailImage:thumbnailImage] ;
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




@end
