//
//  About2ViewController.m
//  veam00000000
//
//  Created by veam on 2/19/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "About2ViewController.h"
#import "VeamUtil.h"
#import "WebViewController.h"

@interface About2ViewController ()

@end

@implementation About2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setViewName:@"About/"] ;
    
    UIView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [self.view addSubview:backView] ;
    
    UIImage *mcnLogoImage = [VeamUtil imageNamed:@"mcn_logo.png"] ;
    CGFloat mcnLogoImageWidth = mcnLogoImage.size.width / 2 ;
    CGFloat mcnLogoImageHeight = mcnLogoImage.size.height / 2 ;
    
    CGFloat imageBackSize = 175 ;
    CGFloat imageSize = 160 ;
    CGFloat imageBottom = 12 ;
    CGFloat titleSize = 18 ;
    CGFloat titleBottom = 20 ;
    CGFloat logoSize = mcnLogoImageHeight ;
    CGFloat logoBottom = 15 ;
    CGFloat copyrightSize = 11 ;
    
    CGFloat contentSize = imageBackSize + imageBottom + titleSize + 2 + titleBottom + logoSize + logoBottom + copyrightSize + 2 ;
    CGFloat currentY = 20 + ([VeamUtil getScreenHeight] - contentSize) / 2 ;
    
    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageBackSize)/2, currentY, imageBackSize, imageBackSize)] ;
    [imageBackView setBackgroundColor:[VeamUtil getColorFromArgbString:@"1A000000"]] ;
    [self.view addSubview:imageBackView] ;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageBackSize-imageSize)/2, (imageBackSize-imageSize)/2, imageSize, imageSize)] ;
    [imageView setImage:[VeamUtil imageNamed:@"c_veam_icon.png"]] ;
    [imageBackView addSubview:imageView] ;
    
    currentY += imageBackSize + imageBottom ;

    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, [VeamUtil getScreenWidth]-20, titleSize+2)] ;
    [appNameLabel setText:[VeamUtil getAppName]] ;
    [appNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:titleSize]] ;
    [appNameLabel setAdjustsFontSizeToFitWidth:YES] ;
    [appNameLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF4C4C4C"]] ;
    [appNameLabel setTextAlignment:NSTextAlignmentCenter] ;
    [self.view addSubview:appNameLabel] ;

    currentY += titleSize + titleBottom ;

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-mcnLogoImageWidth)/2, currentY, mcnLogoImageWidth, mcnLogoImageHeight)] ;
    [imageView setImage:mcnLogoImage] ;
    [self.view addSubview:imageView] ;
    
    currentY += logoSize + logoBottom ;

    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, [VeamUtil getScreenWidth]-20, copyrightSize+2)] ;
    [copyrightLabel setText:[NSString stringWithFormat:@"©2017 %@, Veam™.",[VeamUtil getAppName]]] ;
    [copyrightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:copyrightSize]] ;
    [copyrightLabel  setAdjustsFontSizeToFitWidth:YES] ;
    [copyrightLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF4C4C4C"]] ;
    [copyrightLabel setTextAlignment:NSTextAlignmentCenter] ;
    [self.view addSubview:copyrightLabel] ;

    
    
    /*
    
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
     */
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, [VeamUtil getTopBarHeight], [VeamUtil getScreenWidth] , [VeamUtil getScreenHeight])] ;
    [button setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:button target:self selector:@selector(onVeamLinkTap)] ;
    [self.view addSubview:button] ;

    
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
    NSString *urlString = [NSString stringWithFormat:@"https://help.veam.co/contact/app.php/inquiry?m=%@&a=%@",[VeamUtil getMcnId],[VeamUtil getAppId]] ;
    //NSLog(@"onVeamLinkTap url=%@",urlString) ;
    WebViewController *webViewController = [[WebViewController alloc] init] ;
    [webViewController setUrl:urlString] ;
    [webViewController setTitleName:@"Veam"] ;
    [webViewController setShowBackButton:YES] ;
    [webViewController setShowSettingsDoneButton:YES] ;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
