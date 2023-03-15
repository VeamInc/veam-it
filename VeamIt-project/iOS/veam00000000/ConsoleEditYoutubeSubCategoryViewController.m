//
//  ConsoleEditYoutubeSubCategoryViewController.m
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditYoutubeSubCategoryViewController.h"

#define CONSOLE_VIEW_TITLE          1
#define CONSOLE_VIEW_TYPE           2

@interface ConsoleEditYoutubeSubCategoryViewController ()

@end

@implementation ConsoleEditYoutubeSubCategoryViewController

@synthesize youtubeCategory ;
@synthesize youtubeSubCategory ;

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
    
    currentY += [self addSectionHeader:@"Sub Category" y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:@"Title" y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    /*
    currentY += [self addTextInputBar:@"Type" y:currentY fullBottomLine:YES selector:@selector(didTapBasicSettigns) tag:CONSOLE_VIEW_TYPE].frame.size.height ;
     */
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    // set title
    NSString *title = @"" ;
    if(youtubeSubCategory != nil){
        title = youtubeSubCategory.name ;
    }
    [titleInputBarView setInputValue:title] ;
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

- (void)didTapRightText
{
    //NSLog(@"ConsoleEditYoutubeViewcontroller::didTapRightText") ;
    if(youtubeSubCategory == nil){
        //NSLog(@"new sub category c=%@",youtubeCategory.youtubeCategoryId) ;
        youtubeSubCategory = [[YoutubeSubCategory alloc] init] ;
        youtubeSubCategory.youtubeCategoryId = youtubeCategory.youtubeCategoryId ;
    }
    //NSLog(@"name=%@",[titleInputBarView getInputValue]) ;
    [youtubeSubCategory setName:[titleInputBarView getInputValue]] ;
    [[ConsoleUtil getConsoleContents] setYoutubeSubCategory:youtubeSubCategory] ;
    [self popViewController] ;
}


@end
