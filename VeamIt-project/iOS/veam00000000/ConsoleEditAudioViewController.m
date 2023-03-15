//
//  ConsoleEditAudioViewController.m
//  veam00000000
//
//  Created by veam on 1/8/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleEditAudioViewController.h"
#import "ConsoleDropboxViewController.h"
#import "VeamUtil.h"

#define CONSOLE_VIEW_AUDIO_ID           1
#define CONSOLE_VIEW_TITLE              2
//#define CONSOLE_VIEW_DURATION           3
//#define CONSOLE_VIEW_PERIODICAL_FLAG    4
#define CONSOLE_VIEW_THUMBNAIL_IMAGE    5
#define CONSOLE_VIEW_SOURCE_URL         6
#define CONSOLE_VIEW_PDF_URL            7

@interface ConsoleEditAudioViewController ()

@end

@implementation ConsoleEditAudioViewController

@synthesize audioCategory ;
@synthesize audioSubCategory ;
@synthesize audio ;
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
    
    currentY += [self addSectionHeader:NSLocalizedString(@"upload_audio_to_veam_cloud",nil) y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:NSLocalizedString(@"title",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    sourceUrlInputBarView = [self addDropboxInputBar:NSLocalizedString(@"audio_data_url",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_SOURCE_URL extensions:DROPBOX_AUDIO_EXTENSIONS] ;
    [sourceUrlInputBarView setDelegate:self] ;
    currentY += sourceUrlInputBarView.frame.size.height ;
    
    imageUrlInputBarView = [self addDropboxInputBar:NSLocalizedString(@"image_data_url",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_THUMBNAIL_IMAGE extensions:DROPBOX_IMAGE_EXTENSIONS] ;
    [imageUrlInputBarView setDelegate:self] ;
    currentY += imageUrlInputBarView.frame.size.height ;
    
    linkUrlInputBarView = [self addDropboxInputBar:NSLocalizedString(@"pdf_data_url",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_PDF_URL extensions:@""] ;
    [linkUrlInputBarView setDelegate:self] ;
    currentY += linkUrlInputBarView.frame.size.height ;
    
    
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
    NSString *audioId = @"" ;
    NSString *title = @"" ;
    NSString *sourceUrl = @"" ;
    NSString *imageUrl = @"" ;
    NSString *linkUrl = @"" ;
    
    if(audio != nil){
        audioId = audio.audioId ;
        title = audio.title ;
        sourceUrl = audio.dataUrl ;
        imageUrl = audio.imageUrl ;
        linkUrl = audio.linkUrl ;
    }
    
    //NSLog(@"image url %@",imageUrl) ;
    
    [titleInputBarView setInputValue:title] ;
    [sourceUrlInputBarView setInputValue:sourceUrl] ;
    [imageUrlInputBarView setInputValue:imageUrl] ;
    [linkUrlInputBarView setInputValue:linkUrl] ;
    
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
    if(audio == nil){
        //NSLog(@"new") ;
        retValue = YES ;
    } else {
        NSString *title = [titleInputBarView getInputValue] ;
        NSString *sourceUrl = [sourceUrlInputBarView getInputValue] ;
        NSString *imageUrl = [imageUrlInputBarView getInputValue] ;
        NSString *linkUrl = [linkUrlInputBarView getInputValue] ;
        if(
           ![title isEqualToString:audio.title] ||
           ![sourceUrl isEqualToString:audio.dataUrl] ||
           ![imageUrl isEqualToString:audio.imageUrl] ||
           ![linkUrl isEqualToString:audio.linkUrl]
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
    NSString *audioUrl = [sourceUrlInputBarView getInputValue] ;
    NSString *linkUrl = [linkUrlInputBarView getInputValue] ;
    NSString *imageUrl = [imageUrlInputBarView getInputValue] ;
    
    if([VeamUtil isEmpty:title]){
        [VeamUtil dispError:@"Please input title"] ;
        return NO ;
    }

    if([VeamUtil isEmpty:audioUrl]){
        [VeamUtil dispError:@"Please input audio data url"] ;
        return NO ;
    }

    if([VeamUtil isEmpty:imageUrl]){
        [VeamUtil dispError:@"Please select image data url"] ;
        return NO ;
    }

    /* empty value allowed
     if([VeamUtil isEmpty:linkUrl]){
        [VeamUtil dispError:@"Please input pdf url"] ;
        return NO ;
     }
     */
    
    if(audio == nil){
        //NSLog(@"new audio c=%@",audioCategory.audioCategoryId) ;
        audio = [[Audio alloc] init] ;
        if(audioCategory == nil){
            audio.audioCategoryId = @"0" ;
        } else {
            audio.audioCategoryId = audioCategory.audioCategoryId ;
        }
        
        if(audioSubCategory == nil){
            audio.audioSubCategoryId = @"0" ;
        } else {
            audio.audioSubCategoryId = audioSubCategory.audioSubCategoryId ;
        }
        
        [audio setKind:VEAM_AUDIO_KIND_MESSAGE] ;
    }
    
    //NSLog(@"name=%@",title) ;
    [audio setTitle:title] ;
    
    //NSLog(@"source=%@",url) ;
    [audio setDataUrl:audioUrl] ;
    
    [audio setImageUrl:imageUrl] ;
    
    [audio setLinkUrl:linkUrl] ;
    
    if(mixed != nil){
        [audio setMixed:mixed] ;
    }

    [self performSelectorInBackground:@selector(doUpdate) withObject:nil] ;
    
    return YES ;
}

- (void)doUpdate
{
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
    [[ConsoleUtil getConsoleContents] setAudio:audio thumbnailImage:thumbnailImage] ;
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
