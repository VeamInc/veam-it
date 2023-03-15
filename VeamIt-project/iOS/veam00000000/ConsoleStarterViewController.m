//
//  ConsoleStarterViewController.m
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterViewController.h"
#import "VeamUtil.h"

@interface ConsoleStarterViewController ()

@end

@implementation ConsoleStarterViewController

@synthesize launchFromPreview ;
@synthesize showBackButton ;
@synthesize nextButtonText ;

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
    [self.view setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
}

#define STARTER_HEADER_HEIGHT   44
- (void)showHeader:(NSString *)title backgroundColor:(UIColor *)backgroundColor
{
    if(headerView == nil){
        CGFloat titleMarginLeft = 0 ;
        CGFloat imageWidth = 0 ;
        CGFloat imageHeight = 0 ;
        CGRect frame ;
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], STARTER_HEADER_HEIGHT)] ;
        [headerView setBackgroundColor:backgroundColor] ;
        
        if(showBackButton){
            UIImage *headerBackImage = [UIImage imageNamed:@"c_starter_back.png"] ;
            imageWidth = headerBackImage.size.width / 2 ;
            imageHeight = headerBackImage.size.height / 2 ;
            headerBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (STARTER_HEADER_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
            [headerBackImageView setImage:headerBackImage] ;
            [VeamUtil registerTapAction:headerBackImageView target:self selector:@selector(didHeaderBackTap)] ;
            [headerView addSubview:headerBackImageView] ;
            
            headerBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth, 0, 200, STARTER_HEADER_HEIGHT)] ;
            [headerBackLabel setText:@"Back"] ;
            [headerBackLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]] ;
            [headerBackLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
            [headerBackLabel setBackgroundColor:[UIColor clearColor]] ;
            [VeamUtil registerTapAction:headerBackLabel target:self selector:@selector(didHeaderBackTap)] ;
            [headerBackLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
            [headerBackLabel setNumberOfLines:1] ;
            [headerBackLabel sizeToFit] ;
            frame = headerBackLabel.frame ;
            frame.size.height = STARTER_HEADER_HEIGHT ;
            [headerBackLabel setFrame:frame] ;
            [headerView addSubview:headerBackLabel] ;
            
            titleMarginLeft = frame.origin.x + frame.size.width ;
        }

        NSString *buttonTitle = @"Next" ;
        if(nextButtonText){
            buttonTitle = nextButtonText ;
        }
        headerNextLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth, 0, 200, STARTER_HEADER_HEIGHT)] ;
        [headerNextLabel setText:buttonTitle] ;
        [headerNextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
        [headerNextLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFFF5FEE"]] ;
        [headerNextLabel setBackgroundColor:[UIColor clearColor]] ;
        [VeamUtil registerTapAction:headerNextLabel target:self selector:@selector(didHeaderNextTap)] ;
        [headerNextLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
        [headerNextLabel setNumberOfLines:1] ;
        [headerNextLabel sizeToFit] ;
        frame = headerNextLabel.frame ;
        frame.size.height = STARTER_HEADER_HEIGHT ;
        frame.origin.x = [VeamUtil getScreenWidth] - 15 - frame.size.width ;
        [headerNextLabel setFrame:frame] ;
        [headerView addSubview:headerNextLabel] ;
    
        CGRect nextFrame = headerNextLabel.frame ;
        nextIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
        CGRect indicatorFrame = nextIndicator.frame ;
        indicatorFrame.origin.x = nextFrame.origin.x + (nextFrame.size.width - indicatorFrame.size.width) / 2 ;
        indicatorFrame.origin.y = nextFrame.origin.y + (nextFrame.size.height - indicatorFrame.size.height) / 2 ;
        [nextIndicator setFrame:indicatorFrame] ;
        [nextIndicator setAlpha:0.0] ;
        [headerView addSubview:nextIndicator] ;
        
        
        CGFloat titleMarginRight = [VeamUtil getScreenWidth] - frame.origin.x ;
        CGFloat titleMargin = titleMarginLeft ;
        if(titleMarginLeft < titleMarginRight){
            titleMargin = titleMarginRight ;
        }

        UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleMargin, 0, [VeamUtil getScreenWidth]-titleMargin*2, STARTER_HEADER_HEIGHT)] ;
        [headerTitleLabel setText:title] ;
        [headerTitleLabel setTextAlignment:NSTextAlignmentCenter] ;
        [headerTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]] ;
        [headerTitleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
        [headerTitleLabel setBackgroundColor:[UIColor clearColor]] ;
        [headerView addSubview:headerTitleLabel] ;
        
        [self.view addSubview:headerView] ;
    }
    [headerView setAlpha:1.0] ;
}

- (void)didHeaderBackTap
{
    //NSLog(@"ConsoleStarterViewController::didHeaderBackTap") ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)didHeaderNextTap
{
    //NSLog(@"ConsoleStarterViewController::didHeaderNextTap") ;
}

- (void)hideHeader
{
    [headerView setAlpha:0.0] ;
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

- (void)showMask:(BOOL)show
{
    if(show){
        if(maskView == nil){
            maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
            [maskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"55000000"]] ;
            [self.view addSubview:maskView] ;
            maskIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
            CGRect frame = maskIndicator.frame ;
            frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
            frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
            [maskIndicator setFrame:frame] ;
            [maskView addSubview:maskIndicator] ;
        }
        [maskIndicator startAnimating] ;
        [maskView setAlpha:1.0] ;
    } else {
        [maskView setAlpha:0.0] ;
        [maskIndicator stopAnimating] ;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"shouldAutorotateToInterfaceOrientation") ;
    //NSString* className = NSStringFromClass([self class]);
    //NSLog(@"class=%@",className) ;
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}



@end
