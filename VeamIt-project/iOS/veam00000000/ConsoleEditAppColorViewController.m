//
//  ConsoleEditAppColorViewController.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditAppColorViewController.h"
#import "VeamUtil.h"

#define CONSOLE_VIEW_TOP_BAR                1
#define CONSOLE_VIEW_TOP_BAR_TITLE          2
#define CONSOLE_VIEW_TAB_TEXT               3
#define CONSOLE_VIEW_HILIGHTED_TEXT         4
#define CONSOLE_VIEW_TABLE_SELECTION        5


@interface ConsoleEditAppColorViewController ()

@end

@implementation ConsoleEditAppColorViewController

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
        colorNames = [NSArray arrayWithObjects:
                      @"EMPTY",
                      VEAM_CONFIG_TOP_BAR_COLOR,
                      VEAM_CONFIG_TOP_BAR_TITLE_COLOR,
                      VEAM_CONFIG_TAB_TEXT_COLOR,
                      VEAM_CONFIG_NEW_VIDEOS_TEXT_COLOR,
                      VEAM_CONFIG_TABLE_SELECTION_COLOR,
                      nil] ;

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
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSArray *appCategories = [[contents getValueForKey:@"app_categories"] componentsSeparatedByString:@"|"] ;
    
    CGFloat currentY = y ;
    
    currentY += [self addSectionHeader:@"Colors" y:currentY] ;

    
    topBarColorPickBarView = [self addColorPickBar:@"Top Bar" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TOP_BAR] ;
    [topBarColorPickBarView setDelegate:self] ;
    currentY += topBarColorPickBarView.frame.size.height ;
    
    topBarTitleColorPickBarView = [self addColorPickBar:@"Top Bar Title" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TOP_BAR_TITLE] ;
    [topBarTitleColorPickBarView setDelegate:self] ;
    currentY += topBarTitleColorPickBarView.frame.size.height ;
    
    tabTextColorPickBarView = [self addColorPickBar:@"Tab Text" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TAB_TEXT] ;
    [tabTextColorPickBarView setDelegate:self] ;
    currentY += tabTextColorPickBarView.frame.size.height ;
    
    hilightedTextColorPickBarView = [self addColorPickBar:@"Hilighted Text" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_HILIGHTED_TEXT] ;
    [hilightedTextColorPickBarView setDelegate:self] ;
    currentY += hilightedTextColorPickBarView.frame.size.height ;
    
    tableSelectionColorPickBarView = [self addColorPickBar:@"List Selection" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TABLE_SELECTION] ;
    [tableSelectionColorPickBarView setDelegate:self] ;
    currentY += tableSelectionColorPickBarView.frame.size.height ;
    
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
    [topBarColorPickBarView setInputValue:[contents getValueForKey:[colorNames objectAtIndex:CONSOLE_VIEW_TOP_BAR]]] ;
    [topBarTitleColorPickBarView setInputValue:[contents getValueForKey:[colorNames objectAtIndex:CONSOLE_VIEW_TOP_BAR_TITLE]]] ;
    [tabTextColorPickBarView setInputValue:[contents getValueForKey:[colorNames objectAtIndex:CONSOLE_VIEW_TAB_TEXT]]] ;
    [hilightedTextColorPickBarView setInputValue:[contents getValueForKey:[colorNames objectAtIndex:CONSOLE_VIEW_HILIGHTED_TEXT]]] ;
    [tableSelectionColorPickBarView setInputValue:[contents getValueForKey:[colorNames objectAtIndex:CONSOLE_VIEW_TABLE_SELECTION]]] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)didChangeColorPickValue:(ConsoleColorPickBarView *)view value:(NSString *)value
{
    NSString *colorName = [colorNames objectAtIndex:view.tag] ;
    if(![VeamUtil isEmpty:colorName]){
        [[ConsoleUtil getConsoleContents] setAppColor:value name:colorName] ;
    }
}

@end
