//
//  ConsoleViewController.m
//  VeamConsole
//
//  Created by veam on 5/27/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "VeamUtil.h"
#import "ConsoleElementView.h"
#import "ConsoleTextBarView.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleDropboxInputBarView.h"
#import "ConsoleLongTextInputBarView.h"
#import "ConsoleSwitchBarView.h"
#import "ConsoleImageInputBarView.h"
#import "NEOColorPickerViewController.h"
#import "AppDelegate.h"

@interface ConsoleViewController ()

@end

@implementation ConsoleViewController

@synthesize shouldShowFloatingMenu ;
@synthesize headerStyle ;
@synthesize headerTitle ;
@synthesize headerRightText ;
@synthesize launchFromPreview ;
@synthesize showFooter ;
@synthesize hideHeaderBottomLine ;
@synthesize contentMode ;
@synthesize transitionType ;
@synthesize footerImage ;

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

    //NSLog(@"ConsoleViewController %@::viewDidLoad",NSStringFromClass([self class])) ;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];

    
    if(transitionType == 0){
        transitionType = VEAM_CONSOLE_TRANSITION_TYPE_HORIZONTAL ;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter] ;
    [notificationCenter addObserver:self selector:@selector(contentsDidUpdate:) name:CONSOLE_CONTENTS_UPDATED_NOTIFICATION_ID object:nil] ;
    [notificationCenter addObserver:self selector:@selector(requestDidPost:) name:CONSOLE_REQUEST_POSTED_NOTIFICATION_ID object:nil] ;
    
    if(self.navigationController != nil){
        [self.navigationController setNavigationBarHidden:YES] ;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]] ;
    
    CGFloat deviceWidth = [VeamUtil getScreenWidth] ;
    CGFloat deviceHeight = [VeamUtil getScreenHeight] ;
    UIImage *backgroundImage = [UIImage imageNamed:@"c_background.png"] ;
    CGFloat imageWidth = backgroundImage.size.width / 2 ;
    CGFloat imageHeight = backgroundImage.size.height / 2 ;
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((deviceWidth-imageWidth)/2, (deviceHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [backgroundImageView setImage:backgroundImage] ;
    [self.view addSubview:backgroundImageView] ;
    
    
    [self addContentView] ;
    
    if(headerStyle != VEAM_CONSOLE_HEADER_STYLE_NONE){
        [self addHeader] ;
    }
    
    if(footerImage == nil){
        //NSLog(@"%@::footerImage nil",NSStringFromClass([self class])) ;
        if(showFooter){
            [self addFooter] ;
        }
    } else {
        //NSLog(@"%@::footerImage set",NSStringFromClass([self class])) ;
        CGFloat footerImageWidth = [VeamUtil getScreenWidth] ;
        footerImageHeight = footerImage.size.height * imageWidth / footerImage.size.width ;
        //NSLog(@"footerImageHeight=%f",footerImageHeight) ;
        CGRect footerFrame ;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            footerFrame = CGRectMake(0, [VeamUtil getScreenHeight]-footerImageHeight, footerImageWidth, footerImageHeight) ;
        } else {
            footerFrame = CGRectMake(0, [VeamUtil getScreenHeight]-footerImageHeight-[VeamUtil getStatusBarHeight], footerImageWidth, footerImageHeight) ;
        }

        UIImageView *footerImageView = [[UIImageView alloc] initWithFrame:footerFrame] ;
        [footerImageView setImage:footerImage] ;
        [VeamUtil registerTapAction:footerImageView target:self selector:@selector(didFooterImageTap:)] ;
        [self.view addSubview:footerImageView] ;
    }
    
    
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)] ;
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft ;
    [self.view addGestureRecognizer:swipeLeftGesture] ;
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)] ;
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight ;
    [self.view addGestureRecognizer:swipeRightGesture] ;
    
    if(shouldShowFloatingMenu){
        [self showFloatingMenu] ;
    } else {
        //NSLog(@"call hideFloatingMenu") ;
        [VeamUtil hideFloatingMenu] ;
    }

}
- (void)didFooterImageTap:(UITapGestureRecognizer *)sender
{
    //NSLog(@"%@::didFooterImageTap",NSStringFromClass([self class])) ;
    
    CGPoint point = [sender locationInView:sender.view] ;
    //NSLog(@"x=%f y=%f",point.x,point.y) ;
    [[AppDelegate sharedInstance] didConsoleTabBarTap:point.x] ;
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeRightGesture",NSStringFromClass([self class])) ;
    [self didTapBack] ;
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

- (void)addContentView
{
    CGFloat contentY = [VeamUtil getViewTopOffset] ;
    
    /*
    if(showHeader){
        contentY += VEAM_CONSOLE_HEADER_HEIGHT ;
    }
    */
    
    CGFloat contentHeighgt ;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        contentHeighgt = [VeamUtil getScreenHeight] - contentY ;
    } else {
        contentHeighgt = [VeamUtil getScreenHeight] - contentY - [VeamUtil getStatusBarHeight] ;
    }
    
    /*
    if(showFooter){
        contentHeighgt -= VEAM_CONSOLE_FOOTER_HEIGHT ;
    }
    */

    /*
    if([self hasTabBar]){
        //NSLog(@"has tab") ;
    } else {
        //NSLog(@"no tab") ;
    }
    */
     
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentY, contentHeighgt, contentHeighgt)] ;
    [contentView setBackgroundColor:[UIColor clearColor]] ;
    [self.view addSubview:contentView] ;

}

- (void)addHeader
{

    UIColor *backgroundColor = [VeamUtil getColorFromArgbString:@"E5FFFFFF"] ;

    CGFloat viewTopOffset = [VeamUtil getViewTopOffset] ;
    if (viewTopOffset > 0){
        //NSLog(@"status bar back set") ;
        statusBarBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], viewTopOffset)] ;
        [statusBarBackView setBackgroundColor:backgroundColor] ;
        [self.view addSubview:statusBarBackView] ;
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], VEAM_CONSOLE_HEADER_HEIGHT)] ;
    [headerView setBackgroundColor:backgroundColor] ;
    
    CGFloat currentLeftX = 0 ;
    CGFloat currentRightX = headerView.frame.size.width ;
    if(headerStyle & VEAM_CONSOLE_HEADER_STYLE_BACK){
        UIImage *backImage = [UIImage imageNamed:@"c_top_back.png"] ;
        CGFloat imageWidth = backImage.size.width / 2 ;
        CGFloat imageHeight = backImage.size.height / 2 ;
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentLeftX, (VEAM_CONSOLE_HEADER_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
        [backImageView setImage:backImage] ;
        [VeamUtil registerTapAction:backImageView target:self selector:@selector(didTapBack)] ;
        [headerView addSubview:backImageView] ;
        currentLeftX += imageWidth ;
        
        UIImage *veamImage = [UIImage imageNamed:@"c_top_veam.png"] ;
        imageWidth = veamImage.size.width / 2 ;
        imageHeight = veamImage.size.height / 2 ;
        currentRightX -= imageWidth ;
        UIImageView *veamImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentRightX, (VEAM_CONSOLE_HEADER_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
        [veamImageView setImage:veamImage] ;
        [VeamUtil registerTapAction:veamImageView target:self selector:@selector(didTapVeam)] ;
        [headerView addSubview:veamImageView] ;

        
    }
    
    if(headerStyle & VEAM_CONSOLE_HEADER_STYLE_CLOSE){
        UIImage *closeImage = [UIImage imageNamed:@"c_top_close.png"] ;
        CGFloat imageWidth = closeImage.size.width / 2 ;
        CGFloat imageHeight = closeImage.size.height / 2 ;
        UIImageView *closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentLeftX, (VEAM_CONSOLE_HEADER_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
        [closeImageView setImage:closeImage] ;
        [VeamUtil registerTapAction:closeImageView target:self selector:@selector(didTapClose)] ;
        [headerView addSubview:closeImageView] ;
        currentLeftX += imageWidth ;
    }
    
    if(headerStyle & VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT){
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], VEAM_CONSOLE_HEADER_HEIGHT)] ;
        [rightLabel setBackgroundColor:[UIColor clearColor]] ;
        [rightLabel setTextColor:[UIColor redColor]] ;
        [rightLabel setText:headerRightText] ;
        [rightLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]] ;
        [rightLabel setNumberOfLines:1] ;
        [rightLabel sizeToFit] ;
        CGRect frame = rightLabel.frame ;
        currentRightX -= 8 ; // margin
        currentRightX -= frame.size.width ;
        frame.origin.x = currentRightX ;
        frame.size.height = VEAM_CONSOLE_HEADER_HEIGHT ;
        [rightLabel setFrame:frame] ;
        [VeamUtil registerTapAction:rightLabel target:self selector:@selector(didTapRightText)] ;
        [headerView addSubview:rightLabel] ;
    }
    
    CGFloat fromRight = headerView.frame.size.width - currentRightX ;
    CGFloat margin = 0 ;
    if(currentLeftX < fromRight){
        margin = fromRight ;
    } else {
        margin = currentLeftX ;
    }
    headerTitleLabel = nil ;
    if(self.numberOfHeaderDots <= 1){
        headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, headerView.frame.size.width-margin*2, headerView.frame.size.height)] ;
    } else {
        headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, headerView.frame.size.width-margin*2, 35)] ;
    }
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]] ;
    [headerTitleLabel setTextColor:[UIColor redColor]] ;
    [headerTitleLabel setText:headerTitle] ;
    [headerTitleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [headerTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]] ;
    [headerView addSubview:headerTitleLabel] ;
    
    if(self.numberOfHeaderDots > 1){
        UIImage *dotOffImage = [UIImage imageNamed:@"c_top_dot_off.png"] ;
        UIImage *dotOnImage = [UIImage imageNamed:@"c_top_dot_on.png"] ;
        CGFloat imageSize = dotOffImage.size.width / 2 ;
        CGFloat imageGap = 3 ;
        CGFloat currentX = (headerView.frame.size.width / 2) - ((self.numberOfHeaderDots - 1) * (imageSize + imageGap) / 2);
        for(int index = 0 ; index < self.numberOfHeaderDots ; index++){
            //NSLog(@"dot x=%f",currentX) ;
            UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, 30, imageSize, imageSize)] ;
            if(index == self.selectedHeaderDot){
                [dotImageView setImage:dotOnImage] ;
            } else {
                [dotImageView setImage:dotOffImage] ;
            }
            [headerView addSubview:dotImageView] ;
            currentX += imageSize + imageGap ;
        }
    }
    
    
    if(!hideHeaderBottomLine){
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, VEAM_CONSOLE_HEADER_HEIGHT-1, [VeamUtil getScreenWidth], 0.5)] ;
        [bottomLine setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
        [headerView addSubview:bottomLine] ;
    }
    
    [self.view addSubview:headerView] ;
}

- (void)addFooter
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake
                  (0,
                   [VeamUtil getScreenHeight]-VEAM_CONSOLE_FOOTER_HEIGHT-[VeamUtil getStatusBarHeight]+[VeamUtil getViewTopOffset],
                   [VeamUtil getScreenWidth],
                   VEAM_CONSOLE_FOOTER_HEIGHT)] ;
    [footerView setBackgroundColor:[VeamUtil getColorFromArgbString:@"E5FFFFFF"]] ;
    [self.view addSubview:footerView] ;
    
    [self loadCurrentFooter] ;
}

- (void)loadCurrentFooter
{
    if(footerView != nil){
        [[footerView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)] ;
        NSInteger numberOfElements = 4 ;
        CGFloat margin = ([VeamUtil getScreenWidth] - VEAM_CONSOLE_ELEMENT_WIDTH * numberOfElements) / 2 ;
        CGFloat currentX = margin ;
        CGFloat currentY = (VEAM_CONSOLE_FOOTER_HEIGHT - VEAM_CONSOLE_ELEMENT_HEIGHT) / 2 ;
        
        // Preview
        ConsoleElementView *elementView = [[ConsoleElementView alloc] initWithX:currentX y:currentY iconImage:[UIImage imageNamed:@"c_icon_preview.png" ] title:@"Preview"] ;
        [elementView setBackgroundColor:[UIColor clearColor]] ;
        [VeamUtil registerTapAction:elementView target:self selector:@selector(didTapPreview)] ;
        [footerView addSubview:elementView] ;
        currentX += VEAM_CONSOLE_ELEMENT_WIDTH ;
        
        // Dashboard
        elementView = [[ConsoleElementView alloc] initWithX:currentX y:currentY iconImage:[UIImage imageNamed:@"c_icon_dashboard.png" ] title:@"Dashboard"] ;
        [elementView setBackgroundColor:[UIColor clearColor]] ;
        [VeamUtil registerTapAction:elementView target:self selector:@selector(didTapDashboard)] ;
        [footerView addSubview:elementView] ;
        currentX += VEAM_CONSOLE_ELEMENT_WIDTH ;
        
        // Stats
        elementView = [[ConsoleElementView alloc] initWithX:currentX y:currentY iconImage:[UIImage imageNamed:@"c_icon_stats.png" ] title:@"Stats"] ;
        [elementView setBackgroundColor:[UIColor clearColor]] ;
        [VeamUtil registerTapAction:elementView target:self selector:@selector(didTapStats)] ;
        [footerView addSubview:elementView] ;
        currentX += VEAM_CONSOLE_ELEMENT_WIDTH ;
        
        // Status
        elementView = [[ConsoleElementView alloc] initWithX:currentX y:currentY iconImage:[UIImage imageNamed:@"c_icon_status.png" ] title:@"Status"] ;
        [elementView setBackgroundColor:[UIColor clearColor]] ;
        [VeamUtil registerTapAction:elementView target:self selector:@selector(didTapStatus)] ;
        [footerView addSubview:elementView] ;
        currentX += VEAM_CONSOLE_ELEMENT_WIDTH ;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], 1)] ;
        [lineView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77000000"]] ;
        [footerView addSubview:lineView] ;
    }
}

- (void)showMask:(BOOL)show
{
    //NSLog(@"%@::showMask",NSStringFromClass([self class])) ;
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

- (void)didTapPreview
{
    //NSLog(@"%@::didTapPreview",NSStringFromClass([self class])) ;
    if([ConsoleUtil isConsoleLoggedin]){
        [self showMask:YES] ;
        [self performSelectorInBackground:@selector(preparePreview) withObject:nil] ;
    } else {
        [VeamUtil dispMessage:@"Please Login" title:@""] ;
    }
}

- (void)preparePreview
{
    [ConsoleUtil preparePreview] ;
    [self performSelectorOnMainThread:@selector(showPreview) withObject:nil waitUntilDone:NO] ;
}

- (void)showPreview
{
    [self showMask:NO] ;
    [ConsoleUtil showPreview] ;
}


- (void)didTapClose
{
    //NSLog(@"%@::didTapClose",NSStringFromClass([self class])) ;
    [self didTapBack] ;
}

- (void)didTapBack
{
    //NSLog(@"%@::didTapBack",NSStringFromClass([self class])) ;
    if(launchFromPreview){
        [VeamUtil backToPreview] ;
    } else {
        [self popViewController] ;
    }
}

- (void)didTapVeam
{
    //NSLog(@"%@::didTapVeam",NSStringFromClass([self class])) ;
    [VeamUtil showSideMenu:NO] ;
}

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
}


- (void)didTapDashboard
{
    if(self.navigationController != nil){
        
        [UIView transitionWithView:self.navigationController.view duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.navigationController popToRootViewControllerAnimated:NO] ;
                        } completion:nil];

    }
}

- (void)didTapStats
{
    //NSLog(@"didTapStats") ;
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}

- (void)didTapStatus
{
    //NSLog(@"didTapStatus") ;
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}

- (BOOL)hasTabBar
{
    return (self.tabBarController != nil) ;
}

- (void)pushViewController:(ConsoleViewController *)viewController
{
    //NSLog(@"%@::pushViewController transitionType=%d",NSStringFromClass([self class]),transitionType) ;
    switch(viewController.transitionType){
        case VEAM_CONSOLE_TRANSITION_TYPE_HORIZONTAL:
        default:
            [self.navigationController pushViewController:viewController animated:YES] ;
            break ;
        case VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL:
        {
            CATransition *animation = [CATransition animation] ;
            [animation setType:kCATransitionMoveIn] ;
            [animation setSubtype:kCATransitionFromTop] ;
            [animation setDuration:0.5] ;
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]] ;
            [[self.navigationController.view layer] addAnimation:animation forKey: @"transitionViewAnimation"] ;
            [self.navigationController pushViewController:viewController animated:NO] ;
        }
            break ;
    }
}

- (void)popViewController
{
    switch(transitionType){
        case VEAM_CONSOLE_TRANSITION_TYPE_HORIZONTAL:
        default:
            [self.navigationController popViewControllerAnimated:YES] ;
            break ;
        case VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL:
        {
            CATransition *animation = [CATransition animation] ;
            [animation setType:kCATransitionReveal] ;
            [animation setSubtype:kCATransitionFromBottom] ;
            [animation setDuration:0.5] ;
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]] ;
            [[self.navigationController.view layer] addAnimation:animation forKey: @"transitionViewAnimation"] ;
            [self.navigationController popViewControllerAnimated:NO] ;
        }
            break ;
    }
}




- (CGFloat)addSectionHeader:(NSString *)title y:(CGFloat)y
{
    CGFloat currentY = y ;
    
    currentY += 10 ;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VEAM_CONSOLE_BAR_LEFT_MARGIN, currentY, scrollView.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN, 28)] ;
    [titleLabel setText:title] ;
    [titleLabel setFont:[UIFont systemFontOfSize:14]] ;
    [scrollView addSubview:titleLabel] ;
    currentY += titleLabel.frame.size.height ;
    
    currentY += 2 ;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, scrollView.frame.size.width,1)] ;
    [bottomLine setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFCCCCCC"]] ;
    [scrollView addSubview:bottomLine] ;
    currentY += 1 ;
    
    return currentY - y ;
    
}

- (ConsoleBarView *)addTextBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector
{
    ConsoleTextBarView *barView = [[ConsoleTextBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], 44)] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    if(selector != nil){
        [VeamUtil registerTapAction:barView target:self selector:selector] ;
    }
    [scrollView addSubview:barView] ;
    
    return barView ;
}

- (ConsoleTextInputBarView *)addTextInputBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag
{
    ConsoleTextInputBarView *barView = [[ConsoleTextInputBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], 44)] ;
    [barView setTag:tag] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    if(selector != nil){
        [VeamUtil registerTapAction:barView target:self selector:selector] ;
    }
    [scrollView addSubview:barView] ;
    
    return barView ;
}

- (ConsoleDropboxInputBarView *)addDropboxInputBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag extensions:(NSString *)extensions
{
    ConsoleDropboxInputBarView *barView = [[ConsoleDropboxInputBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], 44)] ;
    [barView setTag:tag] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    [barView setExtensions:extensions] ;
    if(selector != nil){
        [VeamUtil registerTapAction:barView target:self selector:selector] ;
    }
    [scrollView addSubview:barView] ;
    
    return barView ;
}

- (ConsoleColorPickBarView *)addColorPickBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag
{
    ConsoleColorPickBarView *barView = [[ConsoleColorPickBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], 44)] ;
    [barView setTag:tag] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    if(selector != nil){
        [VeamUtil registerTapAction:barView target:self selector:selector] ;
    }
    [scrollView addSubview:barView] ;
    
    return barView ;
}

- (ConsoleTextSelectBarView *)addTextSelectBar:(NSString *)title selections:(NSArray *)selections selectionValues:(NSArray *)selectionValues y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag
{
    ConsoleTextSelectBarView *barView = [[ConsoleTextSelectBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], 44)] ;
    [barView setTag:tag] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    [barView setSelections:selections] ;
    [barView setSelectionValues:selectionValues] ;
    if(selector != nil){
        [VeamUtil registerTapAction:barView target:self selector:selector] ;
    }
    [scrollView addSubview:barView] ;
    
    return barView ;
}

- (ConsoleLongTextInputBarView *)addLongTextInputBar:(NSString *)title y:(CGFloat)y height:(CGFloat)height fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag
{
    ConsoleLongTextInputBarView *barView = [[ConsoleLongTextInputBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], height)] ;
    [barView setTag:tag] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    if(selector != nil){
        [VeamUtil registerTapAction:barView target:self selector:selector] ;
    }
    [scrollView addSubview:barView] ;
    
    return barView ;
}

- (ConsoleImageInputBarView *)addImageInputBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine
                                  displayWidth:(CGFloat)displayWidth  displayHeight:(CGFloat)displayHeight
                                     cropWidth:(CGFloat)cropWidth  cropHeight:(CGFloat)cropHeight resizableCropArea:(BOOL)resizableCropArea
                                  tag:(NSInteger)tag
{
    ConsoleImageInputBarView *barView = [[ConsoleImageInputBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], 44)] ;
    [barView setTag:tag] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    [barView setDelegate:self] ;
    [barView setDisplayWidth:displayWidth] ;
    [barView setDisplayHeight:displayHeight] ;
    [barView setCropWidth:cropWidth] ;
    [barView setCropHeight:cropHeight] ;
    [barView setResizableCropArea:resizableCropArea] ;
    [scrollView addSubview:barView] ;
    
    return barView ;
}

- (ConsoleSwitchBarView *)addSwitchBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag
{
    ConsoleSwitchBarView *barView = [[ConsoleSwitchBarView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], 44)] ;
    [barView setTag:tag] ;
    [barView setTitle:title] ;
    [barView setFullBottomLine:fullBottomLine] ;
    [scrollView addSubview:barView] ;
    
    return barView ;
}


- (CGFloat)addMainTableView
{
    CGFloat currentY = 0 ;
    if(tableView == nil){
        tableView = [[HPReorderTableView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)] ;
        [tableView setShowsVerticalScrollIndicator:NO] ;
        [tableView setBackgroundColor:[UIColor clearColor]] ;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
        UIEdgeInsets insets = tableView.contentInset ;
        //insets.top -= [VeamUtil getViewTopOffset] ;
        if(headerStyle != VEAM_CONSOLE_HEADER_STYLE_NONE){
            //NSLog(@"insets.top=%f",insets.top) ;
            insets.top += VEAM_CONSOLE_HEADER_HEIGHT ;
            /*
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], VEAM_CONSOLE_HEADER_HEIGHT)] ;
            [tableHeaderView setBackgroundColor:[UIColor clearColor]] ;
            [tableView setTableHeaderView:tableHeaderView] ;
             */
        }
        if(footerImageHeight > 0){
            insets.bottom += footerImageHeight ;
        } else {
            if(showFooter){
                insets.bottom += VEAM_CONSOLE_FOOTER_HEIGHT ;
            }
        }
        [tableView setContentInset:insets] ;
        if(contentMode == VEAM_CONSOLE_SETTING_MODE){
            /*
            [tableView setEditing:YES] ;
            [tableView setAllowsSelectionDuringEditing:YES] ;
             */
        }
        [contentView addSubview:tableView] ;
    }
    
    if(headerStyle != VEAM_CONSOLE_HEADER_STYLE_NONE){
        currentY += VEAM_CONSOLE_HEADER_HEIGHT ;
    }
    return currentY ;
}

- (CGFloat)addNormalTableView
{
    //NSLog(@"addNormalTableView contentView.frame.size.width=%f",contentView.frame.size.width) ;
    CGFloat currentY = 0 ;
    if(normalTableView == nil){
        normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], contentView.frame.size.height)] ;
        [normalTableView setShowsVerticalScrollIndicator:NO] ;
        [normalTableView setBackgroundColor:[UIColor clearColor]] ;
        [normalTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
        UIEdgeInsets insets = normalTableView.contentInset ;
        if(headerStyle != VEAM_CONSOLE_HEADER_STYLE_NONE){
            //NSLog(@"insets.top=%f",insets.top) ;
            insets.top += VEAM_CONSOLE_HEADER_HEIGHT ;
        }
        if(footerImageHeight > 0){
            insets.bottom += footerImageHeight ;
        } else {
            if(showFooter){
                insets.bottom += VEAM_CONSOLE_FOOTER_HEIGHT ;
            }
        }
        [normalTableView setContentInset:insets] ;
        if(contentMode == VEAM_CONSOLE_SETTING_MODE){
        }
        [contentView addSubview:normalTableView] ;
    }
    
    if(headerStyle != VEAM_CONSOLE_HEADER_STYLE_NONE){
        currentY += VEAM_CONSOLE_HEADER_HEIGHT ;
    }
    return currentY ;
}





- (CGFloat)addMainScrollView
{
    CGFloat currentY = 0 ;
    if(scrollView == nil){
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)] ;
        [scrollView setShowsVerticalScrollIndicator:NO] ;
        [scrollView setBackgroundColor:[UIColor clearColor]] ;
        [contentView addSubview:scrollView] ;
    }
    
    if(headerStyle != VEAM_CONSOLE_HEADER_STYLE_NONE){
        currentY += VEAM_CONSOLE_HEADER_HEIGHT ;
    }
    return currentY ;
}


- (CGFloat)addMainScrollViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    [self addMainScrollView] ;
    
    CGFloat currentY = 65 ;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VEAM_CONSOLE_BAR_LEFT_MARGIN, currentY, scrollView.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN, 41)] ;
    [titleLabel setText:title] ;
    [titleLabel setFont:[UIFont systemFontOfSize:36]] ;
    [scrollView addSubview:titleLabel] ;
    currentY += titleLabel.frame.size.height ;
    
    currentY += 5 ;
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VEAM_CONSOLE_BAR_LEFT_MARGIN, currentY, scrollView.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN, 20)] ;
    [subTitleLabel setText:subTitle] ;
    [subTitleLabel setFont:[UIFont systemFontOfSize:15]] ;
    [scrollView addSubview:subTitleLabel] ;
    currentY += subTitleLabel.frame.size.height ;
    
    currentY += 37 ;
    
    return currentY ;
}

- (void)setScrollHeight:(CGFloat)y
{
    CGFloat currentY = y ;
    CGFloat contentHeight = currentY + VEAM_CONSOLE_FOOTER_HEIGHT ;
    if(contentHeight <= scrollView.frame.size.height){
        //NSLog(@"adjust content height") ;
        contentHeight = scrollView.frame.size.height + 1 ;
    }
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, contentHeight)] ;
}

- (void)updateContents
{
    // update view if any
}

-(void)contentsDidUpdate:(NSNotification*)notification
{
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    // NSString *value = [[notificationCenter userInfo] objectForKey:@"KEY"] ;
    
    [self performSelectorOnMainThread:@selector(updateContents) withObject:nil waitUntilDone:NO] ;
}

-(void)requestDidPost:(NSNotification *)notification
{
    //NSLog(@"%@::requestDidPost",NSStringFromClass([self class])) ;
    // NSString *value = [[notification userInfo] objectForKey:@"KEY"] ;
}


- (void)didChangeTextInputValue:(ConsoleTextInputBarView *)view value:(NSString *)value
{
    
}

- (void)didChangeSwitchValue:(ConsoleSwitchBarView *)view value:(BOOL)value
{
    
}

- (void)didChangeLongTextInputValue:(ConsoleLongTextInputBarView *)view value:(NSString *)value
{
    //NSLog(@"%@::didChangeLongTextInputValue %@",NSStringFromClass([self class]),value) ;
}


/*
- (void)didTapImageUploadButton
{
    gkImagePicker = [[GKImagePicker alloc] init] ;
    gkImagePicker.cropSize = CGSizeMake(160, 320) ;
    gkImagePicker.delegate = self ;
    gkImagePicker.resizeableCropArea = NO ;
    [self presentModalViewController:gkImagePicker.imagePickerController animated:YES] ;
}
 */

- (void)showImagePicker:(GKImagePicker *)gkImagePicker
{
    [self presentModalViewController:gkImagePicker.imagePickerController animated:YES] ;
}

- (void)showColorPicker:(NEOColorPickerViewController *)colorPickerViewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:colorPickerViewController] ;
    [self presentViewController:navigationController animated:YES completion:nil] ;
}

- (void)dismissImagePicker
{
    [self dismissModalViewControllerAnimated:YES] ;
}


- (void) keyboardWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo] ;
    //CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size ;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size ;
    //NSLog(@"%@::keyboardWillShow w:%f h:%f",NSStringFromClass([self class]),kbSize.width, kbSize.height) ;
    
    if(scrollView != nil){
        if(adjustedKeyboardHeight == 0){
            adjustedKeyboardHeight = kbSize.height ;
            CGRect frame = scrollView.frame ;
            frame.size.height -= adjustedKeyboardHeight ;
            [scrollView setFrame:frame] ;
        }
    }
}

- (void) keyboardWillHide:(NSNotification *)note
{
    // move the view back to the origin
    //NSLog(@"%@::keyboardWillHide adjustedKeyboardHeight:%f",NSStringFromClass([self class]),adjustedKeyboardHeight) ;
    
    if(scrollView != nil){
        if(adjustedKeyboardHeight > 0){
            CGRect frame = scrollView.frame ;
            frame.size.height += adjustedKeyboardHeight ;
            [scrollView setFrame:frame] ;
            adjustedKeyboardHeight = 0 ;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    if(shouldShowFloatingMenu){
        [self showFloatingMenu] ;
    } else {
        //NSLog(@"%@::call hideFloatingMenu",NSStringFromClass([self class])) ;
        [VeamUtil hideFloatingMenu] ;
    }
}

- (void)showFloatingMenu
{
    //NSLog(@"%@::showFloatingMenu should be overwritten",NSStringFromClass([self class])) ;
}

- (void)didTapFloatingMenu:(NSInteger)index
{
    //NSLog(@"%@::didTapFloatingMenu index=%d",NSStringFromClass([self class]),index) ;
}

- (void)sendMailWithSubjedct:(NSString *)subject body:(NSString *)body
{
    //NSLog(@"didHelperTap") ;
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *appId = contents.appInfo.appId ;
    NSString *storeAppName = contents.appInfo.storeAppName ;
    NSString *toString = [contents getValueForKey:@"email_to"] ;
    NSArray *to = [toString componentsSeparatedByString:@","] ;
    
    NSString *newBody = [NSString stringWithFormat:@"%@\nApp Name : %@\nApp ID : %@\n\n",body,storeAppName,appId] ;
    
    [self sendMailWithSubjedct:subject to:to cc:nil bcc:nil body:newBody] ;
}

- (void)sendMailWithSubjedct:(NSString *)subject to:(NSArray *)to cc:(NSArray *)cc bcc:(NSArray *)bcc body:(NSString *)body
{
    //NSLog(@"didHelperTap") ;
    if([MFMailComposeViewController canSendMail]){
        //NSLog(@"can send") ;
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init] ;
		
		[controller setSubject:subject] ;
        if(to != nil){
            [controller setToRecipients:to] ;
        }
        if(cc != nil){
            [controller setCcRecipients:cc] ;
        }
        if(bcc != nil){
            [controller setBccRecipients:bcc] ;
        }
		[controller setMessageBody:body isHTML:NO] ;
		controller.mailComposeDelegate = self;
		
        [self presentViewController:controller animated:YES completion:nil] ;
    } else {
        [VeamUtil dispError:@"This device is not configured to send email.\nPlease set an E-mail account and try again."] ;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	if(error != nil){
		//NSLog(@"%@",error.localizedDescription) ;
        [VeamUtil dispError:error.localizedDescription] ;
	} else {
		switch( result )
		{
			case MFMailComposeResultSent:
                [VeamUtil dispMessage:NSLocalizedString(@"message_sent",nil) title:@""] ;
                break;
			case MFMailComposeResultSaved:
                //NSLog(@"saved") ;
                break;
			case MFMailComposeResultCancelled:
                //NSLog(@"cancelled") ;
                break ;
			case MFMailComposeResultFailed:
                //NSLog(@"failed") ;
                [VeamUtil dispError:NSLocalizedString(@"failed_to_send_message",nil)] ;
                break ;
			default:
                //NSLog(@"unknown") ;
                break;
		}
	}
	
    [controller dismissViewControllerAnimated:YES completion:nil] ;
	
	return;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"shouldAutorotateToInterfaceOrientation") ;
    //NSString* className = NSStringFromClass([self class]);
    //NSLog(@"class=%@",className) ;
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}


- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"VeamNavigationController::supportedInterfaceOrientations") ;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    //NSLog(@"VeamNavigationController::shouldAutorotate") ;
    return YES;
}





@end
