//
//  EmailTopViewController.m
//  veam00000000
//
//  Created by veam on 12/22/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "EmailTopViewController.h"
#import "VeamUtil.h"
#import "EmailLoginViewController.h"
#import "EmailSignUpViewController.h"
#import "AppDelegate.h"

@interface EmailTopViewController ()

@end

@implementation EmailTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //NSLog(@"%@::viewDidLoad",NSStringFromClass([self class])) ;
    
    numberOfImages = 1 ;
    currentImageIndex = 0 ;
    contentWidth = 285 ;
    //contentHeight = 365 ;
    contentHeight = 405 ;
    //CGFloat bottomHeight = 115 ;
    CGFloat bottomHeight = 155 ;
    CGFloat dotGap = 6 ;
    CGFloat loginButtonWidth = 239 ;
    CGFloat loginButtonHeight = 44 ;
    CGFloat signupButtonWidth = 239 ;
    CGFloat signupButtonHeight = 33 ;
    
    dotImageViews = [NSMutableArray array] ;
    topImages = [NSMutableArray array] ;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"email_background.png"] ;
    CGFloat imageWidth = backgroundImage.size.width / 2 ;
    CGFloat imageHeight = backgroundImage.size.height / 2 ;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([VeamUtil getScreenHeight] - imageHeight) / 2,imageWidth,imageHeight)] ;
    [backgroundImageView setImage:backgroundImage] ;
    [self.view addSubview:backgroundImageView] ;
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-contentWidth)/2, ([VeamUtil getScreenHeight]-contentHeight)/2, contentWidth, contentHeight)] ;
    [contentView setBackgroundColor:[UIColor blackColor]] ;
    contentView.layer.cornerRadius = 6 ;
    contentView.layer.masksToBounds = YES ;
    
    [self.view addSubview:contentView] ;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight-bottomHeight, contentWidth, bottomHeight)] ;
    [bottomView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF191919"]] ;
    [contentView addSubview:bottomView] ;
    
    UIImage *backImage = [UIImage imageNamed:@"email_back.png"] ;
    imageWidth = backImage.size.width / 2 ;
    imageHeight = backImage.size.height / 2 ;
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)] ;
    [backImageView setImage:backImage] ;
    [contentView addSubview:backImageView] ;
    [VeamUtil registerTapAction:backImageView target:self selector:@selector(didBackButtonTap)] ;

    

    /*
    for(int index = 0 ; index < numberOfImages ; index++){
        UIImage *topImage = [UIImage imageNamed:[NSString stringWithFormat:@"login_top%d.png",index+1]] ;
        [topImages addObject:topImage] ;
    }
     */
    UIImage *topImage = [VeamUtil imageNamed:@"c_veam_icon.png"] ;
    [topImages addObject:topImage] ;
    
    //UIImage *topImage = [UIImage imageNamed:@"login_top1.png"] ;
    imageWidth = contentWidth / 2 ;
    imageHeight = contentWidth / 2 ;
    initialTopImageFrame = CGRectMake((contentWidth-imageWidth)/2, (contentHeight-bottomHeight-imageHeight)/2, imageWidth, imageHeight) ;
    topImageView = [[UIImageView alloc] initWithFrame:initialTopImageFrame] ;
    [topImageView setImage:topImage] ;
    
    CGFloat imageBackSize = imageWidth + 15 ;
    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake((contentWidth-imageBackSize)/2, (contentHeight-bottomHeight-imageBackSize)/2, imageBackSize, imageBackSize)] ;
    [imageBackView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF1A1A1A"]] ;
    [contentView addSubview:imageBackView] ;

    [contentView addSubview:topImageView] ;
    
    topAnimationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth, (contentHeight-bottomHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [contentView addSubview:topAnimationImageView] ;
    
    /*
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)] ;
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft ;
    [self.view addGestureRecognizer:swipeLeftGesture] ;
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)] ;
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight ;
    [self.view addGestureRecognizer:swipeRightGesture] ;
     */
    
    
    
    /*
    dotOnImage = [UIImage imageNamed:@"login_top_dot_on.png"] ;
    dotOffImage = [UIImage imageNamed:@"login_top_dot_off.png"] ;
    imageWidth = dotOnImage.size.width / 2 ;
    imageHeight = dotOnImage.size.height / 2 ;
    CGFloat initialX = contentWidth / 2 - imageWidth / 2 ;
    initialX -= (numberOfImages - 1) * dotGap ;
    CGFloat dotY = contentHeight - bottomHeight - 21 ;
    for(int index = 0 ; index < numberOfImages ; index++){
        CGFloat dotX = initialX + (imageWidth+dotGap) * index ;
        UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(dotX, dotY, imageWidth, imageHeight)] ;
        [contentView addSubview:dotImageView] ;
        [dotImageViews addObject:dotImageView] ;
    }
    [self updateDotImage] ;
     */
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, contentWidth, 19)] ;
    [descriptionLabel setTextColor:[UIColor whiteColor]] ;
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [descriptionLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12]] ;
    [descriptionLabel setText:[VeamUtil getAppName]] ;
    [bottomView addSubview:descriptionLabel] ;
    /*
    UIImage *descriptionImage = [UIImage imageNamed:@"login_text_veamit.png"] ;
    imageWidth = descriptionImage.size.width / 2 ;
    imageHeight = descriptionImage.size.height / 2 ;
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake((contentWidth-imageWidth)/2, 18, imageWidth, imageHeight)] ;
    [descriptionImageView setImage:descriptionImage] ;
    [bottomView addSubview:descriptionImageView] ;
     */
    
    UIView *loginButtonView = [[UIView alloc] initWithFrame:CGRectMake((contentWidth-loginButtonWidth)/2, 37, loginButtonWidth, loginButtonHeight)] ;
    [loginButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFF1F1F1"]] ;
    [bottomView addSubview:loginButtonView] ;
    
    UIImage *loginImage = [UIImage imageNamed:@"login_text_login.png"] ;
    imageWidth = loginImage.size.width / 2 ;
    imageHeight = loginImage.size.height / 2 ;
    UIImageView *loginImageView = [[UIImageView alloc] initWithFrame:CGRectMake((loginButtonWidth-imageWidth)/2, (loginButtonHeight-imageHeight)/2, imageWidth, imageHeight)] ;
    [loginImageView setImage:loginImage] ;
    [loginButtonView addSubview:loginImageView] ;
    [VeamUtil registerTapAction:loginButtonView target:self selector:@selector(didLoginButtonTap)] ;
    
    
     CGFloat signupY = loginButtonView.frame.origin.y + loginButtonView.frame.size.height + 5 ;
     UIView *signupButtonView = [[UIView alloc] initWithFrame:CGRectMake((contentWidth-signupButtonWidth)/2, signupY, signupButtonWidth, signupButtonHeight)] ;
     [signupButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FF808080"]] ;
     [bottomView addSubview:signupButtonView] ;
     
     UIImage *signupImage = [UIImage imageNamed:@"login_text_signup.png"] ;
     imageWidth = signupImage.size.width / 2 ;
     imageHeight = signupImage.size.height / 2 ;
     UIImageView *signupImageView = [[UIImageView alloc] initWithFrame:CGRectMake((signupButtonWidth-imageWidth)/2, (signupButtonHeight-imageHeight)/2, imageWidth, imageHeight)] ;
     [signupImageView setImage:signupImage] ;
     [signupButtonView addSubview:signupImageView] ;
     [VeamUtil registerTapAction:signupButtonView target:self selector:@selector(didSignupButtonTap)] ;
    
    
}

- (void)switchTopImageTo:(NSInteger)nextIndex
{
    UIImage *topImage = [topImages objectAtIndex:nextIndex] ;
    [topAnimationImageView setImage:topImage] ;
    
    CGRect frame = topImageView.frame ;
    CGRect animationFrame = topAnimationImageView.frame ;
    if(currentImageIndex < nextIndex){
        frame.origin.x = -frame.size.width ;
        animationFrame.origin.x = contentWidth ;
    } else {
        frame.origin.x = contentWidth ;
        animationFrame.origin.x = -contentWidth ;
    }
    
    [topAnimationImageView setFrame:animationFrame] ;
    [topAnimationImageView setAlpha:1.0] ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(updateDotImage)] ;
    [topImageView setFrame:frame] ;
    [topAnimationImageView setFrame:initialTopImageFrame] ;
    [UIView commitAnimations] ;
    
    currentImageIndex = nextIndex ;
}

- (void)updateDotImage
{
    UIImage *topImage = [topImages objectAtIndex:currentImageIndex] ;
    [topImageView setImage:topImage] ;
    [topImageView setFrame:initialTopImageFrame] ;
    [topAnimationImageView setAlpha:0.0] ;
    for(int index = 0 ; index < numberOfImages ; index++){
        UIImageView *dotImageView = [dotImageViews objectAtIndex:index] ;
        if(currentImageIndex == index){
            [dotImageView setImage:dotOnImage] ;
        } else {
            [dotImageView setImage:dotOffImage] ;
        }
    }
}



- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
    if(currentImageIndex < numberOfImages - 1){
        [self switchTopImageTo:currentImageIndex+1] ;
    }
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeRightGesture",NSStringFromClass([self class])) ;
    if(currentImageIndex > 0){
        [self switchTopImageTo:currentImageIndex-1] ;
    }
}

- (void)didBackButtonTap
{
    //NSLog(@"didBackButtonTap") ;
    [[AppDelegate sharedInstance] backFromEmailLogin] ;
    //[VeamUtil showTabBarController:-1] ;
}


- (void)didLoginButtonTap
{
    //NSLog(@"didLoginButtonTap") ;
    EmailLoginViewController *viewController = [[EmailLoginViewController alloc] init] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (void)didSignupButtonTap
{
    //NSLog(@"didSignupButtonTap") ;
    EmailSignUpViewController *viewController = [[EmailSignUpViewController alloc] init] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
