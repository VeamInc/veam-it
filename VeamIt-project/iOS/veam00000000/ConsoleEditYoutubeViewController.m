//
//  ConsoleEditYoutubeViewController.m
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditYoutubeViewController.h"

#define CONSOLE_VIEW_VIDEO_ID           1
#define CONSOLE_VIEW_TITLE              2
#define CONSOLE_VIEW_DURATION           3
#define CONSOLE_VIEW_DESCRIPTION        4

@interface ConsoleEditYoutubeViewController ()

@end

@implementation ConsoleEditYoutubeViewController

@synthesize youtubeCategory ;
@synthesize youtubeSubCategory ;
@synthesize youtube ;

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
    
    currentY += [self addSectionHeader:@"YouTube" y:currentY] ;
    
    videoIdInputBarView = [self addTextInputBar:@"Video ID" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_VIDEO_ID] ;
    [videoIdInputBarView setDelegate:self] ;
    currentY += videoIdInputBarView.frame.size.height ;
    
    titleInputBarView = [self addTextInputBar:@"Title" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    durationInputBarView = [self addTextInputBar:@"Duration" y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_DURATION] ;
    [durationInputBarView setDelegate:self] ;
    currentY += durationInputBarView.frame.size.height ;
    
    descriptionInputBarView = [self addLongTextInputBar:@"Description" y:currentY height:100 fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_DESCRIPTION] ;
    [descriptionInputBarView setDelegate:self] ;
    currentY += descriptionInputBarView.frame.size.height ;
    
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
    NSString *duration = @"" ;
    NSString *description = @"" ;
    if(youtube != nil){
        videoId = youtube.youtubeVideoId ;
        title = youtube.title ;
        duration = youtube.duration ;
        description = youtube.description ;
    }
    
    [videoIdInputBarView setInputValue:videoId] ;
    [titleInputBarView setInputValue:title] ;
    [durationInputBarView setInputValue:duration] ;
    [descriptionInputBarView setInputValue:description] ;
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

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
    if(youtube == nil){
        //NSLog(@"new youtube c=%@",youtubeCategory.youtubeCategoryId) ;
        youtube = [[Youtube alloc] init] ;
        youtube.youtubeCategoryId = youtubeCategory.youtubeCategoryId ;
        if(youtubeSubCategory == nil){
            youtube.youtubeSubCategoryId = @"0" ;
        } else {
            youtube.youtubeSubCategoryId = youtubeSubCategory.youtubeSubCategoryId ;
        }
        
        youtube.kind = @"1" ;
    }
    
    //NSLog(@"video id=%@",[videoIdInputBarView getInputValue]) ;
    [youtube setYoutubeVideoId:[videoIdInputBarView getInputValue]] ;
    
    //NSLog(@"name=%@",[titleInputBarView getInputValue]) ;
    [youtube setTitle:[titleInputBarView getInputValue]] ;

    //NSLog(@"duration=%@",[durationInputBarView getInputValue]) ;
    [youtube setDuration:[durationInputBarView getInputValue]] ;
    
    //NSLog(@"description=%@",[descriptionInputBarView getInputValue]) ;
    [youtube setDescription:[descriptionInputBarView getInputValue]] ;
    
    [[ConsoleUtil getConsoleContents] setYoutube:youtube] ;
    [self popViewController] ;
}


@end
