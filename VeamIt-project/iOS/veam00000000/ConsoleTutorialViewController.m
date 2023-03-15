//
//  ConsoleTutorialViewController.m
//  veam00000000
//
//  Created by veam on 2/17/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleTutorialViewController.h"
#import "VeamUtil.h"

@interface ConsoleTutorialViewController ()

@end

@implementation ConsoleTutorialViewController

@synthesize tutorialKind ;

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
    
    //NSLog(@"%@::viewDidLoad customzeKind=%d",NSStringFromClass([self class]),tutorialKind) ;
    
    UIColor *titleColor = nil ;
    
    switch (tutorialKind) {
        case VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE:
            elements = [NSMutableArray arrayWithObjects:
                        [[ConsoleTutorialElement alloc]
                        initWithTutorialElementId:@"1"
                         title:NSLocalizedString(@"exclusive_tutorial_title_1", nil)
                         description:NSLocalizedString(@"exclusive_tutorial_description_1", nil)
                        imageFileName:@"exclusive_tutorial_ss1.png"
                        kind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE],
                                
                        [[ConsoleTutorialElement alloc]
                        initWithTutorialElementId:@"2"
                         title:NSLocalizedString(@"exclusive_tutorial_title_2", nil)
                         description:NSLocalizedString(@"exclusive_tutorial_description_2", nil)
                        imageFileName:@"exclusive_tutorial_ss2.png"
                        kind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE],
                                
                        [[ConsoleTutorialElement alloc]
                        initWithTutorialElementId:@"3"
                        title:NSLocalizedString(@"exclusive_tutorial_title_3", nil)
                        description:NSLocalizedString(@"exclusive_tutorial_description_3", nil)
                        imageFileName:@"exclusive_tutorial_ss3.png"
                        kind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE],
                                
                        nil] ;
            break;
        case VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED:
            elements = [NSMutableArray arrayWithObjects:
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"1"
                         title:NSLocalizedString(@"exclusive_released_tutorial_title_1", nil)
                         description:NSLocalizedString(@"exclusive_released_tutorial_description_1", nil)
                         imageFileName:@"exclusive_ar_tutorial_ss1.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED],
                        
                        nil] ;
            break;
        case VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE:
            elements = [NSMutableArray arrayWithObjects:
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"1"
                         title:NSLocalizedString(@"youtube_tutorial_title_1", nil)
                         description:NSLocalizedString(@"youtube_tutorial_description_1", nil)
                         imageFileName:@"youtube_tutorial_ss1.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE],
                        
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"2"
                         title:NSLocalizedString(@"youtube_tutorial_title_2", nil)
                         description:NSLocalizedString(@"youtube_tutorial_description_2", nil)
                         imageFileName:@"youtube_tutorial_ss2.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE],
                        
                        nil] ;
            break;
        case VEAM_CONSOLE_TUTORIAL_KIND_FORUM:
            elements = [NSMutableArray arrayWithObjects:
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"1"
                         title:NSLocalizedString(@"forum_tutorial_title_1", nil)
                         description:NSLocalizedString(@"forum_tutorial_description_1", nil)
                         imageFileName:@"forum_tutorial_ss1.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_FORUM],
                        
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"2"
                         title:NSLocalizedString(@"forum_tutorial_title_2", nil)
                         description:NSLocalizedString(@"forum_tutorial_description_2", nil)
                         imageFileName:@"forum_tutorial_ss2.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_FORUM],
                        
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"3"
                         title:NSLocalizedString(@"forum_tutorial_title_3", nil)
                         description:NSLocalizedString(@"forum_tutorial_description_3", nil)
                         imageFileName:@"forum_tutorial_ss3.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_FORUM],
                        
                        nil] ;
            break;
        case VEAM_CONSOLE_TUTORIAL_KIND_FORUM_RELEASED:
            elements = [NSMutableArray arrayWithObjects:
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"1"
                         title:NSLocalizedString(@"forum_released_tutorial_title_1", nil)
                         description:NSLocalizedString(@"forum_released_tutorial_description_1", nil)
                         imageFileName:@"forum_tutorial_ss1.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_FORUM],
                        
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"2"
                         title:NSLocalizedString(@"forum_released_tutorial_title_2", nil)
                         description:NSLocalizedString(@"forum_released_tutorial_description_2", nil)
                         imageFileName:@"forum_tutorial_ss2.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_FORUM],
                        
                        nil] ;
            break;
        case VEAM_CONSOLE_TUTORIAL_KIND_LINK:
            elements = [NSMutableArray arrayWithObjects:
                        [[ConsoleTutorialElement alloc]
                         initWithTutorialElementId:@"1"
                         title:NSLocalizedString(@"links_tutorial_title_1", nil)
                         description:NSLocalizedString(@"links_tutorial_description_1", nil)
                         imageFileName:@"link_tutorial_ss1.png"
                         kind:VEAM_CONSOLE_TUTORIAL_KIND_LINK],
                        nil] ;
            break;
            
        default:
            break;
    }
    
    [headerTitleLabel setTextColor:[UIColor redColor]] ;
    
    [self addMainScrollView] ;
    
    currentIndex = 0 ;
    
    CGFloat currentY = 60 ;

    UIImage *iconImage = [UIImage imageNamed:@"tutorial_icon.png"] ;
    CGFloat imageWidth = iconImage.size.width / 2 ;
    CGFloat imageHeight = iconImage.size.height / 2 ;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, currentY, imageWidth, imageHeight)] ;
    [iconImageView setImage:iconImage] ;
    [scrollView addSubview:iconImageView] ;
    
    currentY += imageHeight ;
    currentY += 10 ;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], 28)] ;
    [titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF2E2E2E"]] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [titleLabel setAdjustsFontSizeToFitWidth:YES] ;
    [titleLabel setMinimumScaleFactor:0.2f] ;
    [scrollView addSubview:titleLabel] ;

    currentY += titleLabel.frame.size.height ;
    currentY += 6 ;
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, [VeamUtil getScreenWidth]-20, 45)] ;
    [descriptionLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF2E2E2E"]] ;
    [descriptionLabel setBackgroundColor:[UIColor clearColor]] ;
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]] ;
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [descriptionLabel setNumberOfLines:3] ;
    [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [scrollView addSubview:descriptionLabel] ;
    
    currentY += descriptionLabel.frame.size.height ;
    currentY += 10 ;
    
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
            UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, currentY, imageSize, imageSize)] ;
            [dotImageViews addObject:dotImageView] ;
            [scrollView addSubview:dotImageView] ;
            currentX += imageSize + imageGap ;
        }
        
    }
    currentY += 14 ;

    
    
    NSString *startImageFileName = [self getImageFileName:0] ;
    UIImage *startImage = [UIImage imageNamed:startImageFileName] ;
    imageWidth = startImage.size.width / 2 ;
    imageHeight = startImage.size.height / 2 ;
    mainFrame = CGRectMake(([VeamUtil getScreenWidth] - imageWidth)/2, currentY, imageWidth, imageHeight) ;
    mainImageView = [[UIImageView alloc] initWithFrame:mainFrame] ;
    [scrollView addSubview:mainImageView] ;
    
    animationImageView = [[UIImageView alloc] initWithFrame:mainFrame] ;
    [scrollView addSubview:animationImageView] ;
    [animationImageView setAlpha:0.0] ;
    
    
    prevImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 290, 50, 50)] ;
    [prevImageView setImage:[UIImage imageNamed:@"c_prev.png"]] ;
    [VeamUtil registerTapAction:prevImageView target:self selector:@selector(didPrevButtonTap)] ;
    [scrollView addSubview:prevImageView] ;
    [prevImageView setAlpha:0.0] ;
    
    nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 290, 50, 50)] ;
    [nextImageView setImage:[UIImage imageNamed:@"c_next.png"]] ;
    [VeamUtil registerTapAction:nextImageView target:self selector:@selector(didNextButtonTap)] ;
    [scrollView addSubview:nextImageView] ;
    [nextImageView setAlpha:0.0] ;
    
    
    
    
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], 510)] ;
    
    
    
    [self setMainImage] ;
    
}

- (void)setMainImage
{
    ConsoleTutorialElement *element = [elements objectAtIndex:currentIndex] ;
    [titleLabel setText:element.title] ;
    [descriptionLabel setText:element.description] ;
    
    NSString *imageFileName = element.imageFileName ;
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
    
    NSString *imageFileName = [self getImageFileName:currentIndex] ;
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

- (NSString *)getImageFileName:(NSInteger)index
{
    ConsoleTutorialElement *element = [elements objectAtIndex:index] ;
    return element.imageFileName ;
}

@end
