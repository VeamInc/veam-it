//
//  ConsoleYoutubeSettingsViewController.m
//  veam00000000
//
//  Created by veam on 5/30/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleYoutubeSettingsViewController.h"
#import "ConsoleUtil.h"

#define CONSOLE_VIEW_TITLE          1
#define CONSOLE_VIEW_EMBED_FLAG     2
#define CONSOLE_VIEW_EMBED_URL      3
#define CONSOLE_VIEW_LEFT_IMAGE     4
#define CONSOLE_VIEW_RIGHT_IMAGE    5


@interface ConsoleYoutubeSettingsViewController ()

@end

@implementation ConsoleYoutubeSettingsViewController

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
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE] ;
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
    
    currentY += [self addSectionHeader:@"Section Settings" y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:@"Title" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;

    /*
    embedFlagInputBarView = [self addSwitchBar:@"Embed" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_EMBED_FLAG] ;
    [embedFlagInputBarView setDelegate:self] ;
    currentY += embedFlagInputBarView.frame.size.height ;
    
    embedUrlInputBarView = [self addTextInputBar:@"Embed URL" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_EMBED_URL] ;
    [embedUrlInputBarView setDelegate:self] ;
    currentY += embedUrlInputBarView.frame.size.height ;
     */

    /*
    leftImageInputBarView = [self addImageInputBar:@"Left image" y:currentY fullBottomLine:NO
                                      displayWidth:160 displayHeight:160 cropWidth:320 cropHeight:320 resizableCropArea:NO tag:CONSOLE_VIEW_LEFT_IMAGE] ;
     */
    leftImageInputBarView = [self addImageInputBar:@"Left image" y:currentY fullBottomLine:NO
                                      displayWidth:160 displayHeight:160 cropWidth:320 cropHeight:320 resizableCropArea:NO tag:CONSOLE_VIEW_LEFT_IMAGE] ;
    currentY += leftImageInputBarView.frame.size.height ;
    
    rightImageInputBarView = [self addImageInputBar:@"Right image" y:currentY fullBottomLine:YES
                                       displayWidth:160 displayHeight:160 cropWidth:320 cropHeight:320 resizableCropArea:NO tag:CONSOLE_VIEW_RIGHT_IMAGE] ;
    currentY += rightImageInputBarView.frame.size.height ;
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    // set title
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    [titleInputBarView setInputValue:contents.templateYoutube.title] ;
    /*
    [embedFlagInputBarView setInputValue:[contents.templateYoutube.embedFlag isEqualToString:@"1"]] ;
    [embedUrlInputBarView setInputValue:contents.templateYoutube.embedUrl] ;
     */
    [leftImageInputBarView setInputValue:contents.templateYoutube.leftImageUrl] ;
    [rightImageInputBarView setInputValue:contents.templateYoutube.rightImageUrl] ;
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
            [[ConsoleUtil getConsoleContents] setTemplateYoutubeTitle:value] ;
            break;
            /*
        case CONSOLE_VIEW_EMBED_URL:
            [[ConsoleUtil getConsoleContents] setTemplateYoutubeEmbedUrl:value] ;
            break;
             */
            
        default:
            break;
    }
}

- (void)didChangeSwitchValue:(ConsoleSwitchBarView *)view value:(BOOL)value
{
    //NSLog(@"%@::didChangeSwitchValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
            /*
        case CONSOLE_VIEW_EMBED_FLAG:
            //NSLog(@"EMBED_FLAG") ;
            [[ConsoleUtil getConsoleContents] setTemplateYoutubeEmbedFlag:value] ;
            break;
             */
        default:
            break;
    }
}

- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_LEFT_IMAGE:
            //NSLog(@"CONSOLE_VIEW_LEFT_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setTemplateYoutubeLeftImage:value] ;
            break;
        case CONSOLE_VIEW_RIGHT_IMAGE:
            //NSLog(@"CONSOLE_VIEW_RIGHT_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setTemplateYoutubeRightImage:value] ;
            break;
        default:
            break;
    }
}


@end
