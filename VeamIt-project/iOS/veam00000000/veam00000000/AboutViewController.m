//
//  AboutViewController.m
//  veam31000000
//
//  Created by veam on 7/26/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "AboutViewController.h"
#import "VeamUtil.h"
#import "WebViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self setViewName:@"About/"] ;
    
    UIView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [self.view addSubview:backView] ;
    
    UIImage *image = [VeamUtil imageNamed:@"about.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    CGFloat spaceHeight = [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight] - [VeamUtil getTopBarHeight]  ;
    CGFloat imageY = [VeamUtil getTopBarHeight] + (spaceHeight - imageHeight) / 2 ;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageY, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [self.view addSubview:imageView] ;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 295, 130, 33)] ;
    [button setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:button target:self selector:@selector(onVeamLinkTap)] ;
    [imageView addSubview:button] ;
    [imageView setUserInteractionEnabled:YES] ;
    
    [self addTopBar:YES showSettingsButton:NO] ;
    //UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-VEAM_SETTINGS_DONE_WIDTH, 0, VEAM_SETTINGS_DONE_WIDTH, [VeamUtil getTopBarHeight])] ;
    UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(topBarTitleMaxRight-VEAM_SETTINGS_DONE_WIDTH, 0, VEAM_SETTINGS_DONE_WIDTH, [VeamUtil getTopBarHeight])] ;
    [doneLabel setText:NSLocalizedString(@"done",nil)] ; // FF62BD
    [doneLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
    [doneLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [doneLabel setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:doneLabel target:self selector:@selector(onDoneButtonTap)] ;
    [topBarView addSubview:doneLabel] ;
}

- (void)onDoneButtonTap
{
    [VeamUtil showTabBarController:-1] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onVeamLinkTap
{
    //NSLog(@"onVeamLinkTap") ;
    WebViewController *webViewController = [[WebViewController alloc] init] ;
    [webViewController setUrl:@"https://veam.co/"] ;
    [webViewController setTitleName:@"Veam"] ;
    [webViewController setShowBackButton:YES] ;
    [webViewController setShowSettingsDoneButton:YES] ;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
