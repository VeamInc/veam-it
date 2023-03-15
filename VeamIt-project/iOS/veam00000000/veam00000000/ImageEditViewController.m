//
//  ImageEditViewController.m
//  CameraTest
//
//  Created by veam on 7/9/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "ImageEditViewController.h"
#import "ImageShareViewController.h"
#import "VeamUtil.h"

@interface ImageEditViewController ()

@end

@implementation ImageEditViewController

@synthesize targetImage ;
@synthesize forumId ;

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
    [self setViewName:@"ImageEdit/"] ;


    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [maskView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF222222"]] ;
    [self.view addSubview:maskView] ;

    [self addTopBar:YES showSettingsButton:NO] ;
    
    currentDegree = 0 ; 

    CGFloat topBarHeight = [VeamUtil getTopBarHeight] ;
    //CGFloat buttonHeight = 30 ;
    CGFloat bottomBarHeight = 84 ;
    CGFloat screenHeight = [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight] ;

    CGFloat bottomY = screenHeight - bottomBarHeight ;
    


    
    /*
     UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, topBarHeight)] ;
     [topBarView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]] ;
     [self.view addSubview:topBarView] ;
    UIButton *returnButton = [UIButton buttonWithType:101] ;
    [returnButton setTitle:@"Camera" forState:UIControlStateNormal] ;
    [returnButton setFrame:CGRectMake(10, (topBarHeight-buttonHeight)/2, 100, buttonHeight)] ;
    [returnButton addTarget:self action:@selector(onReturnButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton] ;
     */
    
    CGFloat nextWidth = 50 ;
    UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(topBarTitleMaxRight-nextWidth, 0, nextWidth, [VeamUtil getTopBarHeight])] ;
    [nextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [nextLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
    [nextLabel setBackgroundColor:[UIColor clearColor]] ;
    [nextLabel setText:NSLocalizedString(@"next",nil)] ;
    [VeamUtil registerTapAction:nextLabel target:self selector:@selector(onNextButtonTap)] ;
    [topBarView addSubview:nextLabel] ;
    
    /*
    UIButton *nextButton = [UIButton buttonWithType:100] ;
    [nextButton setTitle:@"Next" forState:UIControlStateNormal] ;
    [nextButton setFrame:CGRectMake(240, (topBarHeight-buttonHeight)/2, 70, buttonHeight)] ;
    [nextButton addTarget:self action:@selector(onNextButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton] ;
     */
    
    CGFloat margin = 4 ;
    CGFloat imageViewSize = [VeamUtil getScreenWidth] - margin * 2 ;
    CGFloat topMargin = (screenHeight - topBarHeight - bottomBarHeight - imageViewSize) / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, [VeamUtil getViewTopOffset]+topBarHeight+topMargin, imageViewSize, imageViewSize)] ;
    [imageView setImage:targetImage] ;
    [self.view addSubview:imageView] ;
    
    UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0,[VeamUtil getViewTopOffset]+bottomY,[VeamUtil getScreenWidth],bottomBarHeight)] ;
    [bottomBarView setBackgroundColor:[UIColor blackColor]] ;
    [self.view addSubview:bottomBarView] ;
    
    UIImage *image = [VeamUtil imageNamed:@"rotate.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    UIImageView *rotateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth] - imageWidth)/2,[VeamUtil getViewTopOffset] + bottomY + (bottomBarHeight - imageHeight)/2, imageWidth, imageHeight)] ;
    [rotateImageView setImage:image] ;
    [VeamUtil registerTapAction:rotateImageView target:self selector:@selector(onRotateButtonTap)] ;
    [self.view addSubview:rotateImageView] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReturnButtonTap
{
    //NSLog(@"return button tapped") ;
}

- (void)onNextButtonTap
{
    //NSLog(@"next button tapped") ;
    ImageShareViewController *imageShareViewController = [[ImageShareViewController alloc] initWithNibName:@"ImageShareViewController" bundle:nil] ;
    [imageShareViewController setTargetImage:targetImage] ;
    [imageShareViewController setDegree:currentDegree] ;
    [imageShareViewController setTitleName:NSLocalizedString(@"share",nil)] ;
    [imageShareViewController setForumId:forumId] ;
    [self.navigationController pushViewController:imageShareViewController animated:YES] ;
}

- (void)onRotateButtonTap
{
    //NSLog(@"rotate button tapped") ;
    currentDegree -= 90 ;
    if(currentDegree < 0){
        currentDegree += 360 ;
    }
    CGFloat angle = currentDegree * M_PI / 180.0;
    [imageView setTransform:CGAffineTransformMakeRotation(angle)] ;
}

@end
