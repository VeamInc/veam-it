//
//  RecipeDetailViewController.m
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "VeamUtil.h"
#import "Three20/Three20.h"
//#import "SimpleAdManager.h"



@interface RecipeDetailViewController ()

@end

@implementation RecipeDetailViewController

@synthesize recipe ;
@synthesize sharedBanner = sharedBanner_ ;


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
    
    //NSLog(@"RecipeDetailViewController::viewDidLoat") ;
    
    [self setViewName:[NSString stringWithFormat:@"Recipe/%@/%@/",[recipe recipeId],[recipe title]]] ;
    
    UILabel *label ;
    CGFloat margin = 10 ;

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [scrollView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [self.view addSubview:scrollView] ;

    CGFloat currentY = [VeamUtil getTopBarHeight] + margin ;
    CGFloat imageWidth = [VeamUtil getScreenWidth] - margin * 2 ;
    UIImage *image = [VeamUtil getCachedImage:[recipe imageUrl] downloadIfNot:YES] ;
    if(image == nil){
        image = [VeamUtil imageNamed:@"no_recipe_l.png"] ;
    }
    if(image != nil){
        CGFloat imageHeight = imageWidth / image.size.width * image.size.height ;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, currentY , imageWidth, imageHeight)] ;
        [imageView setImage:image] ;
        [scrollView addSubview:imageView] ;
        currentY += [imageView frame].size.height ;
    }
    
    UIImage *iconImage = [VeamUtil imageNamed:@"add_off.png"] ;
    CGFloat iconSize = iconImage.size.width / 2 ;
    
    currentY += 10 ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth-iconSize-margin, 1)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]] ;
    [label setTextColor:[VeamUtil getColorFromArgbString:@"FF2E2E30"]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setLineBreakMode:NSLineBreakByWordWrapping] ;
    [label setNumberOfLines:0];
    [label setText:[recipe title]] ;
    [label sizeToFit] ;
    [scrollView addSubview:label] ;
    
    favoriteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin+imageWidth-iconSize, currentY, iconSize,iconSize)] ;
    if([VeamUtil isFavoriteMixed:recipe.mixed.mixedId]){
        [favoriteImageView setImage:[VeamUtil imageNamed:@"add_on.png"]] ;
    } else {
        [favoriteImageView setImage:iconImage] ;
    }
    [VeamUtil registerTapAction:favoriteImageView target:self selector:@selector(onFavoriteButtonTap:)] ;
    [scrollView addSubview:favoriteImageView] ;

    currentY += [label frame].size.height ;

    currentY += 10 ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, 14)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]] ;
    [label setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:@"Ingredients"] ;
    [scrollView addSubview:label] ;
    currentY += [label frame].size.height ;
    
    currentY += 4 ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, 1)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [label setTextColor:[VeamUtil getColorFromArgbString:@"FF202020"]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setText:[recipe ingredients]] ;
    [label sizeToFit] ;
    [scrollView addSubview:label] ;
    currentY += [label frame].size.height ;
    
    currentY += 12 ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, 14)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]] ;
    [label setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:@"Directions"] ;
    [scrollView addSubview:label] ;
    currentY += [label frame].size.height ;
    
    currentY += 4 ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, 1)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [label setTextColor:[VeamUtil getColorFromArgbString:@"FF202020"]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setText:[recipe directions]] ;
    [label sizeToFit] ;
    [scrollView addSubview:label] ;
    currentY += [label frame].size.height ;
    
    currentY += 12 ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, 14)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]] ;
    [label setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:@"Nutrition Info"] ;
    [scrollView addSubview:label] ;
    currentY += [label frame].size.height ;


    currentY += 4 ;
    /*
     TTStyledTextLabel is not supported <table> tag
    TTStyledTextLabel *ttstyledLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, 1)] ;
    [ttstyledLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    ttstyledLabel.text = [TTStyledText textFromXHTML:@"<table><tr><td>test</td><td>10.0g</td></tr><tr><td>testtest</td><td>255.0ml</td></tr></table>" lineBreaks:NO URLs:NO];
    [ttstyledLabel setBackgroundColor:[UIColor clearColor]] ;
    [ttstyledLabel sizeToFit];
     */
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, currentY, imageWidth, 1)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [label setTextColor:[VeamUtil getColorFromArgbString:@"FF202020"]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setText:[recipe nutrition]] ;
    [label sizeToFit] ;
    [scrollView addSubview:label] ;
    currentY += [label frame].size.height ;
    
    //UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, 1, [VeamUtil getTabBarHeight]+margin)] ;
    UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, 1, 50+margin)] ;
    [spacer setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:spacer] ;
    currentY += [spacer frame].size.height ;

    CGFloat contentHeight = currentY ;
    if(contentHeight <= [scrollView frame].size.height){
        contentHeight = [scrollView frame].size.height + 1 ;
    }
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], contentHeight)] ;
    
    [self addTopBar:YES showSettingsButton:NO] ;

    /*
    adBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, [VeamUtil getScreenHeight]-VEAM_AD_HEIGHT-[VeamUtil getStatusBarHeight]+[VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], VEAM_AD_HEIGHT)] ;
    [adBaseView setBackgroundColor:[UIColor clearColor]] ;
    [adBaseView setHidden:YES] ;
    //NSLog(@"adBaseView hidden") ;
    [self.view addSubview:adBaseView] ;
     */
    
}

- (void)onFavoriteButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    // 押されたらとりあえず変更する
    UIImageView *imageView = (UIImageView *)[singleTapGesture view] ;
    NSString *mixedId = recipe.mixed.mixedId ;
    if([VeamUtil isFavoriteMixed:mixedId]){
        [imageView setImage:[VeamUtil imageNamed:@"add_off.png"]] ;
        [VeamUtil deleteFavoriteMixed:mixedId] ;
    } else {
        [imageView setImage:[VeamUtil imageNamed:@"add_on.png"]] ;
        [VeamUtil addFavoriteMixed:mixedId] ;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)onBackButtonTap
{
    //NSLog(@"RecipeDetailViewController::onBackButtonTap") ;
    [VeamUtil showTabBarController:-1] ;
}
*/



-(void)removeShareBanner
{
    if(self.sharedBanner){
        [self.sharedBanner removeFromSuperview] ;
        self.sharedBanner = nil;
    }
}

/*
-(void)iAdAvailable
{
    if([VeamUtil adDisabled]){
        //NSLog(@"RecipeDetailViewController::iAdAvailable adDisabled:YES") ;
        [self removeShareBanner] ;
        [adBaseView setHidden:YES] ;
        //NSLog(@"adBaseView hidden") ;
        [SimpleAdManager shutDown] ;
    } else {
        //NSLog(@"RecipeDetailViewController::iAdAvailable adDisabled:NO") ;
        UIView *adBanner = [[SimpleAdManager getInstance] returnBannerIfLoaded] ;
        if(adBanner){
            //[self removeShareBanner] ;
            [adBaseView setHidden:NO] ;
            //NSLog(@"adBaseView shown") ;
            [adBaseView addSubview:adBanner] ; //using default position at 0,0
            self.sharedBanner = adBanner;
            
            //NSLog(@"adBaseView subViews count : %d",[[adBaseView subviews] count]) ;
        }
    }
}

-(void)iAdUnavailable
{
    //NSLog(@"RecipeDetailViewController::iAdUnavailable") ;
    [adBaseView setHidden:YES] ;
    //NSLog(@"adBaseView hidden") ;
    [self removeShareBanner] ;
    if([VeamUtil adDisabled]){
        //NSLog(@"RecipeDetailViewController::iAdUnAvailable adDisabled:NO") ;
        [SimpleAdManager shutDown] ;
    }
}
*/
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated] ;
    
    /*
    // This sample shows using the notifications to allow for placing the ad
    // at a later time if one becomes available while this view is active
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iAdAvailable) name:iAD_AVAILABLE_EVENT object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iAdUnavailable) name:iAD_UNAVAILABLE_EVENT object:nil] ;
    [self iAdAvailable] ;
     */
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"RecipeDetailViewController::viewWillDisappear") ;
	[super viewWillDisappear:animated] ;
    
    /*
    [self removeShareBanner] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
     */
}

@end
