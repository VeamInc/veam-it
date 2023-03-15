//
//  ConsoleYoutubeUserConfirmViewController.m
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleYoutubeUserConfirmViewController.h"
#import "VeamUtil.h"
#import "ConsoleStarterColorPickerViewController.h"

@interface ConsoleYoutubeUserConfirmViewController ()

@end

@implementation ConsoleYoutubeUserConfirmViewController

@synthesize channelTitle ;

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
    
    UIColor *color = [VeamUtil getColorFromArgbString:@"FF6D6D6D"] ;
    channelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [channelTitleLabel setBackgroundColor:[UIColor clearColor]] ;
    [channelTitleLabel setText:channelTitle] ;
    [channelTitleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [channelTitleLabel setAdjustsFontSizeToFitWidth:YES] ;
    [channelTitleLabel setTextColor:color] ;
    [channelTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:50]] ;
    [self.view addSubview:channelTitleLabel] ;
    [channelTitleLabel setAlpha:0.0] ;
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"ConsoleYoutubeUserConfirmViewController::viewDidAppear") ;
    [super viewDidAppear:animated] ;
    
    [UIView beginAnimations:nil context:nil] ;
    [UIView setAnimationDuration:2.0f] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(initScreen)] ;
    [channelTitleLabel setAlpha:1.0f] ;
    [UIView commitAnimations] ;
}


- (void)initScreen
{
    [self showHeader:@"" backgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
}


- (void)launchColorView
{
    ConsoleStarterColorPickerViewController *viewController = [[ConsoleStarterColorPickerViewController alloc] init] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (void)didHeaderNextTap
{
    //NSLog(@"ConsoleYoutubeUserConfirmViewController::didHeaderNextTap") ;
    [self launchColorView] ;
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

@end
