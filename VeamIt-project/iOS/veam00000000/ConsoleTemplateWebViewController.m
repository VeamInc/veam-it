//
//  ConsoleTemplateWebViewController.m
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTemplateWebViewController.h"
#import "ConsoleWebSettingsViewController.h"
#import "ConsoleWebViewController.h"

@interface ConsoleTemplateWebViewController ()

@end

@implementation ConsoleTemplateWebViewController

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
    
    
    CGFloat currentY = [self addMainScrollViewWithTitle:@"5.Link" subTitle:@"Free Section"] ;
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
    
    currentY += [self addSectionHeader:@"General" y:currentY] ;
    currentY += [self addTextBar:@"Basic Settings" y:currentY fullBottomLine:NO selector:@selector(didTapBasicSettigns)].frame.size.height ;
    currentY += [self addTextBar:@"Embedded Webpage List" y:currentY fullBottomLine:YES selector:@selector(didTapWebList)].frame.size.height ;
    
    return currentY ;
}

- (void)didTapBasicSettigns
{
    //NSLog(@"didTapBasicSettigns") ;
    ConsoleWebSettingsViewController *webSettingsViewController = [[ConsoleWebSettingsViewController alloc] init] ;
    [self pushViewController:webSettingsViewController] ;
}

- (void)didTapWebList
{
    //NSLog(@"didTapWebList") ;
    ConsoleWebViewController *webViewController = [[ConsoleWebViewController alloc] init] ;
    [webViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [webViewController setHeaderTitle:NSLocalizedString(@"links_url",nil)] ;
    [webViewController setNumberOfHeaderDots:2] ;
    [webViewController setSelectedHeaderDot:1] ;
    [webViewController setFooterImage:[UIImage imageNamed:@"tab_back.png"]] ;
    [webViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    [self pushViewController:webViewController] ;
}

@end
