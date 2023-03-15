//
//  ConsoleTemplateYoutubeViewController.m
//  veam00000000
//
//  Created by veam on 5/30/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTemplateYoutubeViewController.h"
#import "VeamUtil.h"
#import "ConsoleBarView.h"
#import "ConsoleYoutubeSettingsViewController.h"
#import "ConsoleYoutubeCategoryViewController.h"

@interface ConsoleTemplateYoutubeViewController ()

@end

@implementation ConsoleTemplateYoutubeViewController

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
    
    
    CGFloat currentY = [self addMainScrollViewWithTitle:@"2.YouTube" subTitle:@"Free Section"] ;
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
    currentY += [self addTextBar:@"Category Settings" y:currentY fullBottomLine:YES selector:@selector(didTapCategorySettigns)].frame.size.height ;
    
    currentY += 16 ;
    
    currentY += [self addSectionHeader:@"Contents" y:currentY] ;
    currentY += [self addTextBar:NSLocalizedString(@"upload",nil) y:currentY fullBottomLine:YES selector:@selector(didTapUpload)].frame.size.height ;
    
    return currentY ;
}




- (void)didTapBasicSettigns
{
    //NSLog(@"didTapBasicSettigns") ;
    ConsoleYoutubeSettingsViewController *youtubeSettingsViewController = [[ConsoleYoutubeSettingsViewController alloc] init] ;
    [self pushViewController:youtubeSettingsViewController] ;
}

- (void)didTapCategorySettigns
{
    //NSLog(@"didTapCategorySettigns") ;
    ConsoleYoutubeCategoryViewController *youtubeCategoryViewController = [[ConsoleYoutubeCategoryViewController alloc] init] ;
    [youtubeCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [youtubeCategoryViewController setFooterImage:[UIImage imageNamed:@"tab_back.png"]] ;
    [youtubeCategoryViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    [youtubeCategoryViewController setHeaderTitle:@"YouTube - Playlists"] ;
    [youtubeCategoryViewController setNumberOfHeaderDots:2] ;
    [youtubeCategoryViewController setSelectedHeaderDot:1] ;
    [self pushViewController:youtubeCategoryViewController] ;
}

- (void)didTapUpload
{
    //NSLog(@"didTapUpload") ;
    ConsoleYoutubeCategoryViewController *youtubeCategoryViewController = [[ConsoleYoutubeCategoryViewController alloc] init] ;
    [youtubeCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [youtubeCategoryViewController setFooterImage:[UIImage imageNamed:@"tab_back.png"]] ;
    [youtubeCategoryViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
    [self pushViewController:youtubeCategoryViewController] ;
}



@end
