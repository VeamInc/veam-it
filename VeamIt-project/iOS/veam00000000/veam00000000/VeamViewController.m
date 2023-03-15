//
//  VeamViewController.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "VeamUtil.h"
#import "GAI.h"
#import "GAIFields.h"
#import "AGMedallionView.h"
#import "ProfileViewController.h"


@interface VeamViewController ()

@end

@implementation VeamViewController

@synthesize titleName ;
@synthesize topBarIcon ;
@synthesize topBarIconKind ;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"shouldAutorotateToInterfaceOrientation") ;
    //NSString* className = NSStringFromClass([self class]);
    //NSLog(@"class=%@",className) ;
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ;
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //NSLog(@"VeamViewController %@::viewDidLoad",NSStringFromClass([self class])) ;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter] ;
    
    // 通知センターに通知要求を登録する
    // この例だと、通知センターに"Tuchi"という名前の通知がされた時に、
    // hogeメソッドを呼び出すという通知要求の登録を行っている。
    [notificationCenter addObserver:self selector:@selector(contentsDidUpdate:) name:[VeamUtil getContentsUpdateNotificationId] object:nil] ;
    
    if(self.navigationController != nil){
        [self.navigationController setNavigationBarHidden:YES] ;
    }
    
    [self.view setBackgroundColor:[UIColor blackColor]] ;
    
    // set background image
    UIImage *image = [VeamUtil imageNamed:@"background.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset] + ([VeamUtil getScreenHeight] - imageHeight)/2 - [VeamUtil getStatusBarHeight], imageWidth, imageHeight)] ;
    [backgroundImageView setImage:image] ;
    [self.view addSubview:backgroundImageView] ;
    
    if([VeamUtil isVeamConsole]){
        UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)] ;
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft ;
        [self.view addGestureRecognizer:swipeLeftGesture] ;
        /*
        UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)] ;
        swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight ;
        [self.view addGestureRecognizer:swipeRightGesture] ;
         */
    }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
    [VeamUtil didTapFloatingMenu:1] ;
}
/*
- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeRightGesture",NSStringFromClass([self class])) ;
}
*/
- (void)setViewName:(NSString *)viewName
{
    self.screenName = [VeamUtil makeScreenName:viewName] ;
}

- (void)addTopBar:(BOOL)showBackButton showSettingsButton:(BOOL)showSettingsButton
{
    
    topBarTitleMinLeft = 0 ;
    topBarTitleMaxRight = [VeamUtil getScreenWidth] ;

    CGFloat topBarHeight = [VeamUtil getTopBarHeight] ;
    CGFloat viewTopOffset = [VeamUtil getViewTopOffset] ;
    if (viewTopOffset > 0){
        //NSLog(@"status bar back set") ;
        statusBarBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], viewTopOffset)] ;
        //[statusBarBackView setBackgroundColor:[UIColor blackColor]] ;
        [statusBarBackView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFCCCCCC"]] ;
        [self.view addSubview:statusBarBackView] ;
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }

    
    topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopOffset, [VeamUtil getScreenWidth], topBarHeight)] ;
    [topBarView setBackgroundColor:[VeamUtil getTopBarColor]] ;
    [self.view addSubview:topBarView] ;
    
    if([VeamUtil isVeamConsole] && !preventVeamIcon){
        UIImage *veamImage = [VeamUtil imageNamed:@"veam_icon.png"] ;
        CGFloat imageWidth = veamImage.size.width / 2 ;
        CGFloat imageHeight = veamImage.size.height / 2 ;
        topBarVeamImageView = [[UIImageView alloc] initWithFrame:CGRectMake(topBarTitleMaxRight-imageWidth, (topBarHeight-imageHeight)/2, imageWidth, imageHeight)] ;
        [topBarVeamImageView setImage:veamImage] ;
        [VeamUtil registerTapAction:topBarVeamImageView target:self selector:@selector(onVeamButtonTap)] ;
        [topBarView addSubview:topBarVeamImageView] ;
        
        topBarTitleMaxRight = topBarVeamImageView.frame.origin.x + 2 ;
    }

    
    if(([titleName length] > 6) && [[titleName substringToIndex:6] isEqualToString:@"image:"]){
        NSString *imageName = [titleName substringFromIndex:6] ;
        //NSLog(@"image name = %@",imageName) ;
        UIImage *image = [VeamUtil imageNamed:imageName] ;
        if(image != nil){
            CGFloat imageWidth = image.size.width / 2 ;
            CGFloat imageHeight = image.size.height / 2 ;
            topBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth] - imageWidth)/2, (topBarHeight - imageHeight)/2, imageWidth, imageHeight)] ;
            [topBarImageView setImage:image] ;
            [topBarView addSubview:topBarImageView] ;
        }
    } else {
        topBarLabel = [[UILabel alloc] initWithFrame:topBarView.frame] ;
        [topBarLabel setBackgroundColor:[UIColor clearColor]] ;
        [topBarLabel setTextColor:[VeamUtil getTopBarTitleColor]] ;
        [topBarLabel setFont:[UIFont fontWithName:[VeamUtil getTopBarTitleFont] size:[VeamUtil getTopBarTitleFontSize]]] ;
        //NSLog(@"Top bar title font : %@ %f",[VeamUtil getTopBarTitleFont],[VeamUtil getTopBarTitleFontSize]) ;
        [topBarLabel setText:titleName] ;
        [topBarLabel setTextAlignment:NSTextAlignmentCenter] ;
        [self.view addSubview:topBarLabel] ;
        
        CGSize textSize = [titleName sizeWithFont:topBarLabel.font constrainedToSize:CGSizeMake(240, 480) lineBreakMode:topBarLabel.lineBreakMode] ;
        topBarTitleLeftPosition = ([VeamUtil getScreenWidth] - textSize.width) / 2 ;
        if(topBarIcon != nil){
            CGFloat imageWidth = topBarIcon.size.width / 2 ;
            CGFloat imageHeight = topBarIcon.size.height / 2 ;
            
            if(topBarIconKind == VEAM_TOP_BAR_ICON_CIRCLE){
                imageWidth = 25 ;
                imageHeight = 25 ;
                AGMedallionView *topBarIconImageView = [[AGMedallionView alloc] initWithFrame:CGRectMake(topBarTitleLeftPosition-imageWidth-5, (topBarHeight-imageHeight)/2, imageWidth, imageHeight)] ;
                [topBarIconImageView setImage:topBarIcon] ;
                [topBarView addSubview:topBarIconImageView] ;
            } else {
                UIImageView *topBarIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(topBarTitleLeftPosition-imageWidth-5, (topBarHeight-imageHeight)/2, imageWidth, imageHeight)] ;
                [topBarIconImageView setImage:topBarIcon] ;
                [topBarView addSubview:topBarIconImageView] ;
            }
        }
    }
    
    if(showBackButton){
        topBarBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, topBarHeight)] ;
        [topBarBackImageView setImage:[VeamUtil imageNamed:@"top_bar_back.png"]] ;
        [VeamUtil registerTapAction:topBarBackImageView target:self selector:@selector(onBackButtonTap)] ;
        [topBarView addSubview:topBarBackImageView] ;
        topBarTitleMinLeft = topBarBackImageView.frame.origin.x + topBarBackImageView.frame.size.width ;
    }
    
    if(showSettingsButton){
        settingsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(topBarTitleMaxRight-35, (topBarHeight-40)/2, 30, 40)] ;
        [settingsImageView setImage:[VeamUtil imageNamed:@"settings_button.png"]] ;
        [VeamUtil registerTapAction:settingsImageView target:self selector:@selector(onSettingsButtonTap)] ;
        [topBarView addSubview:settingsImageView] ;
        
        topBarTitleMaxRight = settingsImageView.frame.origin.x ;
    }
    
    [self restrictTopBarLabelWidth] ;

}

- (void)restrictTopBarLabelWidth
{
    CGFloat left = topBarTitleMinLeft ;
    CGFloat right = [VeamUtil getScreenWidth] - topBarTitleMaxRight ;
    CGFloat max = right ;
    if(left > right){
        max = left ;
    }
    
    CGFloat width = [VeamUtil getScreenWidth] - (max * 2) ;
    
    CGRect frame ;
    frame = [topBarLabel frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - width) / 2 ;
    frame.size.width = width ;
    [topBarLabel setFrame:frame] ;
    [topBarLabel setLineBreakMode:NSLineBreakByTruncatingTail] ;
    [topBarLabel setNumberOfLines:1] ;
}


- (void)onBackButtonTap
{
    if(self.navigationController != nil){
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}

- (void)onVeamButtonTap
{
    //NSLog(@"veam button tapped") ;
    [VeamUtil showSideMenu:YES] ;
}

- (void)onSettingsButtonTap
{
    if(self.navigationController != nil){
        NSString *socialUserId ;
        NSString *socialUserName ;
        if([VeamUtil isLoggedIn]){
            socialUserId = [NSString stringWithFormat:@"%d",[VeamUtil getSocialUserId]] ;
            socialUserName = [VeamUtil getSocialUserName] ;
        } else {
            socialUserId = @"0" ;
            socialUserName = NSLocalizedString(@"not_logged_in",nil) ;
        }
        ProfileViewController *profileViewController = [[ProfileViewController alloc] init] ;
        [profileViewController setSocialUserId:socialUserId] ;
        [profileViewController setSocialUserName:socialUserName] ;
        [profileViewController setTitleName:NSLocalizedString(@"profile",nil)] ;
        [self.navigationController pushViewController:profileViewController animated:YES] ;
    }

    /*
    if(self.navigationController != nil){
        [VeamUtil showSettingsView] ;
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"VeamViewController::viewDidAppear");
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker] ;  // Get the tracker object.
    [tracker set:[GAIFields customDimensionForIndex:1] value:[VeamUtil getTrackingId]] ;
    
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"VeamViewController::viewWillAppear");
    [super viewWillAppear:animated] ;
    [VeamUtil showFloatingMenuWithClassName:NSStringFromClass([self class]) instance:self] ;
}

- (void)updateContents
{
    UIImage *image = [VeamUtil imageNamed:@"background.png"] ;
    if(image != nil){
        [backgroundImageView setImage:image] ;
    }
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    //NSLog(@"VeamViewController::contentsDidUpdate") ;
    // NSString *value = [[notificationCenter userInfo] objectForKey:@"KEY"] ;

    [self performSelectorOnMainThread:@selector(updateContents) withObject:nil waitUntilDone:NO] ;
}

-(void)dealloc
{
    //NSLog(@"VeamViewController %@::dealloc",NSStringFromClass([self class])) ;
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}


@end
