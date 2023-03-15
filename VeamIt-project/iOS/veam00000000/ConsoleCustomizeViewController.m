//
//  ConsoleCustomizeViewController.m
//  veam00000000
//
//  Created by veam on 9/8/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleCustomizeViewController.h"
#import "VeamUtil.h"
#import "ConsoleStarterColorPickerViewController.h"

#define CONSOLE_VIEW_BACKGROUND_IMAGE   1
#define CONSOLE_VIEW_ICON_IMAGE         2
#define CONSOLE_VIEW_YOUTUBE_IMAGE      3


@interface ConsoleCustomizeViewController ()

@end

@implementation ConsoleCustomizeViewController

@synthesize customizeKind ;

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
    
    //NSLog(@"%@::viewDidLoad customzeKind=%d",NSStringFromClass([self class]),customizeKind) ;

    UIColor *titleColor = nil ;
    
    switch (customizeKind) {
        case VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN:
            titleColor = [UIColor blackColor] ;
            elements = [[ConsoleUtil getConsoleContents] getCustomizeElementsForKind:VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN] ;
            imageFileNameFormat = @"c_custom_design_%d.png" ;
            break;
            /*
        case VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE:
            titleColor = [UIColor blackColor] ;
            elements = [[ConsoleUtil getConsoleContents] getCustomizeElementsForKind:VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE] ;
            imageFileNameFormat = @"c_custom_feature_%d.png" ;
            break;
        case VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION:
            titleColor = [UIColor redColor] ;
            elements = [[ConsoleUtil getConsoleContents] getCustomizeElementsForKind:VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION] ;
            imageFileNameFormat = @"c_custom_subscription_%d.png" ;
            break;
             */
        default:
            imageFileNameFormat = @"c_custom_design_%d.png" ;
            break;
    }
    
    [headerTitleLabel setTextColor:titleColor] ;
    
    [self addMainScrollView] ;
    
    currentIndex = 0 ;
    NSString *startImageFileName = [NSString stringWithFormat:imageFileNameFormat,1] ;
    UIImage *startImage = [UIImage imageNamed:startImageFileName] ;
    CGFloat imageWidth = startImage.size.width / 2 ;
    CGFloat imageHeight = startImage.size.height / 2 ;
    mainFrame = CGRectMake(([VeamUtil getScreenWidth] - imageWidth)/2, 70, imageWidth, imageHeight) ;
    mainImageView = [[UIImageView alloc] initWithFrame:mainFrame] ;
    [scrollView addSubview:mainImageView] ;
    
    animationImageView = [[UIImageView alloc] initWithFrame:mainFrame] ;
    [scrollView addSubview:animationImageView] ;
    [animationImageView setAlpha:0.0] ;
    
    CGFloat submitImageWidth = 60 ;
    CGFloat submitImageHeight = 60 ;
    UIImageView *submitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(232, 48, submitImageWidth, submitImageHeight)] ;
    [submitImageView setImage:[UIImage imageNamed:@"c_update.png"]] ;
    [VeamUtil registerTapAction:submitImageView target:self selector:@selector(didSubmitButtonTap)] ;
    [scrollView addSubview:submitImageView] ;
    
    prevImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 230, 50, 50)] ;
    [prevImageView setImage:[UIImage imageNamed:@"c_prev.png"]] ;
    [VeamUtil registerTapAction:prevImageView target:self selector:@selector(didPrevButtonTap)] ;
    [scrollView addSubview:prevImageView] ;
    [prevImageView setAlpha:0.0] ;
    
    nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 230, 50, 50)] ;
    [nextImageView setImage:[UIImage imageNamed:@"c_next.png"]] ;
    [VeamUtil registerTapAction:nextImageView target:self selector:@selector(didNextButtonTap)] ;
    [scrollView addSubview:nextImageView] ;
    [nextImageView setAlpha:0.0] ;
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 460, [VeamUtil getScreenWidth], 14)] ;
    [titleLabel setTextColor:[UIColor redColor]] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [scrollView addSubview:titleLabel] ;
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 478, [VeamUtil getScreenWidth], 12)] ;
    [descriptionLabel setTextColor:[UIColor blackColor]] ;
    [descriptionLabel setBackgroundColor:[UIColor clearColor]] ;
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]] ;
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [scrollView addSubview:descriptionLabel] ;
    
    numberOfElements = [elements count] ;
    dotImageViews = [NSMutableArray array] ;
    if(numberOfElements > 1){
        dotOffImage = [UIImage imageNamed:@"c_top_dot_off.png"] ;
        dotOnImage = [UIImage imageNamed:@"c_top_dot_on.png"] ;
        CGFloat imageSize = dotOffImage.size.width / 2 ;
        CGFloat imageGap = 3 ;
        CGFloat currentX = ([VeamUtil getScreenWidth] / 2) - ((numberOfElements - 1) * (imageSize + imageGap) / 2) ;
        for(int index = 0 ; index < numberOfElements ; index++){
            //NSLog(@"dot x=%f",currentX) ;
            UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, 504, imageSize, imageSize)] ;
            [dotImageViews addObject:dotImageView] ;
            [scrollView addSubview:dotImageView] ;
            currentX += imageSize + imageGap ;
        }
    }
    
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], 510)] ;

    [self setMainImage] ;
    
    
    backgroundImageInputBarView = [self addImageInputBar:@"Background" y:0 fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_BACKGROUND_IMAGE] ;
    [backgroundImageInputBarView setAlpha:0.0] ;

    iconImageInputBarView = [self addImageInputBar:@"Icon" y:0 fullBottomLine:NO
                                            displayWidth:300 displayHeight:300 cropWidth:1024 cropHeight:1024 resizableCropArea:NO tag:CONSOLE_VIEW_ICON_IMAGE] ;
    [iconImageInputBarView setAlpha:0.0] ;
    
    youtubeImageInputBarView = [self addImageInputBar:@"Youtube" y:0 fullBottomLine:NO
                                      displayWidth:300 displayHeight:300 cropWidth:1024 cropHeight:1024 resizableCropArea:NO tag:CONSOLE_VIEW_YOUTUBE_IMAGE] ;
    [youtubeImageInputBarView setAlpha:0.0] ;


}

- (void)setMainImage
{
    ConsoleCustomizeElement *element = [elements objectAtIndex:currentIndex] ;
    [titleLabel setText:element.title] ;
    [descriptionLabel setText:element.description] ;

    NSString *imageFileName = [NSString stringWithFormat:imageFileNameFormat,currentIndex+1] ;
    UIImage *image = [UIImage imageNamed:imageFileName] ;
    [mainImageView setImage:image] ;
    [mainImageView setFrame:mainFrame] ;
    [animationImageView setAlpha:0.0] ;
    CGFloat prevAlpha = 0 ;
    CGFloat nextAlpha = 0 ;
    if(currentIndex == 0){
        prevAlpha = 0.0 ;
    } else {
        prevAlpha = 1.0 ;
    }
    
    if(currentIndex < ([elements count]-1)){
        nextAlpha = 1.0 ;
    } else {
        nextAlpha = 0.0 ;
    }
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.2] ;
    [UIView setAnimationDelegate:self] ;
    [prevImageView setAlpha:prevAlpha] ;
    [nextImageView setAlpha:nextAlpha] ;
    [UIView commitAnimations] ;
    

    if(numberOfElements > 1){
        for(int index = 0 ; index < numberOfElements ; index++){
            UIImageView *imageView = [dotImageViews objectAtIndex:index] ;
            if(index == currentIndex){
                [imageView setImage:dotOnImage] ;
            } else {
                [imageView setImage:dotOffImage] ;
            }
        }
    }
}

- (void)doAnimationWithDirection:(NSInteger)direction
{
    
    CGRect animationFrame = mainFrame ;
    CGRect outFrame = mainFrame ;
    animationFrame.origin.x += direction * [VeamUtil getScreenWidth] ;
    outFrame.origin.x -= direction * [VeamUtil getScreenWidth] ;
    
    NSString *imageFileName = [NSString stringWithFormat:imageFileNameFormat,currentIndex+1] ;
    UIImage *image = [UIImage imageNamed:imageFileName] ;
    [animationImageView setFrame:animationFrame] ;
    [animationImageView setImage:image] ;
    [animationImageView setAlpha:1.0] ;
    
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(setMainImage)] ;
    [animationImageView setFrame:mainFrame] ;
    [mainImageView setFrame:outFrame] ;
    [UIView commitAnimations] ;

    
    
}

- (void)didPrevButtonTap
{
    //NSLog(@"%@::didPrevButtonTap",NSStringFromClass([self class])) ;
    if(currentIndex > 0){
        currentIndex-- ;
        [self doAnimationWithDirection:-1] ;
    }
}

- (void)didNextButtonTap
{
    //NSLog(@"%@::didNextButtonTap",NSStringFromClass([self class])) ;
    if(currentIndex < ([elements count]-1)){
        currentIndex++ ;
        [self doAnimationWithDirection:1] ;
    }
}

- (void)didSubmitButtonTap
{
    //NSLog(@"%@::didSubmitButtonTap",NSStringFromClass([self class])) ;
    
    ConsoleCustomizeElement *element = [elements objectAtIndex:currentIndex] ;
    NSString *elementId = element.customizeElementId ;
    if([elementId isEqual:@"1"]){
        //NSLog(@"Splash & Background") ;
        [backgroundImageInputBarView showInputView] ;
    } else if([elementId isEqual:@"2"]){
        //NSLog(@"Color") ;
        ConsoleStarterColorPickerViewController *viewController = [[ConsoleStarterColorPickerViewController alloc] init] ;
        [viewController setShowBackButton:YES] ;
        [viewController setNextButtonText:NSLocalizedString(@"done",nil)] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    } else if([elementId isEqual:@"3"]){
        //NSLog(@"Icon") ;
        [iconImageInputBarView showInputView] ;
    } else if([elementId isEqual:@"4"]){
        //NSLog(@"Youtube image") ;
        [youtubeImageInputBarView showInputView] ;
    }
}


- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
    switch (view.tag) {
        case CONSOLE_VIEW_BACKGROUND_IMAGE:
            //NSLog(@"CONSOLE_VIEW_BACKGROUND_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setAppCustomBackgroundImage:value] ;
            //NSLog(@"DONE") ;
            break;
        case CONSOLE_VIEW_ICON_IMAGE:
            //NSLog(@"CONSOLE_VIEW_ICON_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setAppCustomIconImage:value] ;
            [ConsoleUtil setNewIcon:value] ;
            //NSLog(@"DONE") ;
            break;
        case CONSOLE_VIEW_YOUTUBE_IMAGE:
            //NSLog(@"CONSOLE_VIEW_YOUTUBE_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setTemplateYoutubeRightImage:value] ;
            //NSLog(@"DONE") ;
            break;
        default:
            break;
    }
    
    /*
    UIActivityIndicatorView *indicator = [cell.uploadIndicators objectAtIndex:index] ;
    [indicator startAnimating] ;
    [indicator setHidden:NO] ;
    [screenShotUploading setObject:@"YES" atIndexedSubscript:index] ;
    */
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

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeRightGesture",NSStringFromClass([self class])) ;
    [self didTapBack] ;
}

- (void)showProgress
{
    //NSLog(@"%@::showProgress",NSStringFromClass([self class])) ;
    if(!progressView){
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
        [progressView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77000000"]] ;
        progressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
        progressIndicator.center = progressView.center ;
        [progressView addSubview:progressIndicator] ;
        [self.view addSubview:progressView] ;
    }
    
    [progressIndicator startAnimating] ;
    [progressView setAlpha:1.0] ;
}

- (void)hideProgress
{
    //NSLog(@"%@::hideProgress",NSStringFromClass([self class])) ;
    [progressView setAlpha:0.0] ;
    [progressIndicator stopAnimating] ;
}

- (void)contentsDidUpdate:(NSNotification *)notification
{
    [super contentsDidUpdate:notification] ;

    NSString *value = [[notification userInfo] objectForKey:@"ACTION"] ;
    if(![VeamUtil isEmpty:value] && [value isEqualToString:@"CONTENT_POST_DONE"]){
        NSString *apiName = [[notification userInfo] objectForKey:@"API_NAME"] ;
        if(
           [apiName isEqualToString:@"app/setcustombackgroundimage"] ||
           [apiName isEqualToString:@"app/setcustomiconimage"] ||
           [apiName isEqualToString:@"youtube/setrightimage"]
           ){
            //NSLog(@"update finished") ;
            [self performSelectorOnMainThread:@selector(hideProgress) withObject:nil waitUntilDone:NO] ;
            //[VeamUtil dispMessage:@"Check App preview!!" title:@"Updated"] ;
            [ConsoleUtil restartHome] ;
        }
    }
  
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
}


@end
