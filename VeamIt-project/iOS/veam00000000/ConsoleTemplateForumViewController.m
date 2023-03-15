//
//  ConsoleTemplateForumViewController.m
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTemplateForumViewController.h"
#import "ConsoleForumSettingsViewController.h"
#import "ConsoleForumViewController.h"

@interface ConsoleTemplateForumViewController ()

@end

@implementation ConsoleTemplateForumViewController

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
    
    
    CGFloat currentY = [self addMainScrollViewWithTitle:@"3.Forum" subTitle:@"Free Section"] ;
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
    currentY += [self addTextBar:@"Category Settings" y:currentY fullBottomLine:YES selector:@selector(didTapForumList)].frame.size.height ;
    
    return currentY ;
}

- (void)didTapBasicSettigns
{
    //NSLog(@"didTapBasicSettigns") ;
    ConsoleForumSettingsViewController *forumSettingsViewController = [[ConsoleForumSettingsViewController alloc] init] ;
    [self pushViewController:forumSettingsViewController] ;
}

- (void)didTapForumList
{
    //NSLog(@"didTapForumList") ;
    ConsoleForumViewController *forumViewController = [[ConsoleForumViewController alloc] init] ;
    [forumViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [forumViewController setHeaderTitle:NSLocalizedString(@"forum_theme",nil)] ;
    [forumViewController setNumberOfHeaderDots:2] ;
    [forumViewController setSelectedHeaderDot:1] ;
    [forumViewController setFooterImage:[UIImage imageNamed:@"tab_back.png"]] ;
    [forumViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    [self pushViewController:forumViewController] ;
}

@end
