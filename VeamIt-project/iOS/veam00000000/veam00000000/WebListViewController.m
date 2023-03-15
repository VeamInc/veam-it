//
//  WebListViewController.m
//  veam31000000
//
//  Created by veam on 2/26/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "WebListViewController.h"
#import "Web.h"
#import "VeamUtil.h"
#import "BasicCellViewController.h"
#import "WebViewController.h"


@interface WebListViewController ()

@end

@implementation WebListViewController

@synthesize category ;

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
    
    [self setViewName:@"WebList/"] ;
    

//#ifdef DO_NOT_USE_ADMOB
#define ADMOB_BANNER_HEIGHT 1.0
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
/*
#else
#define ADMOB_BANNER_HEIGHT 50.0
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner] ;
    bannerView.adUnitID = VEAM_ADMOB_UNIT_ID_LINKSCATEGORY ;
    bannerView.rootViewController = self ;
    bannerView.delegate = self ;
    [bannerView loadRequest:[VeamUtil getAdRequest]] ;
    bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
    [bannerCell setBackgroundColor:[UIColor clearColor]] ;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, 300, 1)] ;
    [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
    [bannerCell addSubview:lineView] ;
    [bannerCell addSubview:bannerView] ;
#endif
*/
    
    numberOfWebs = [VeamUtil getnumberOfWebs:category] ;
    webs = [VeamUtil getWebs:category] ;
    
    webListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [webListTableView setDelegate:self] ;
    [webListTableView setDataSource:self] ;
    [webListTableView setBackgroundColor:[UIColor clearColor]] ;
    [webListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [webListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:webListTableView] ;
    
    [self addTopBar:NO showSettingsButton:YES] ;
    
    if(numberOfWebs == 1){
        Web *web = [webs objectAtIndex:0] ;
        [self showWebViewController:web animated:NO] ;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    indexOffset = 2 ;
    webs = [VeamUtil getWebs:category] ;
    //webs = [VeamUtil getRecipeCategories] ;
    lastIndex = indexOffset + [webs count] ;
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == 1){
        retValue = ADMOB_BANNER_HEIGHT ;
    } else if(indexPath.row == lastIndex){
        retValue = [VeamUtil getTabBarHeight] ;
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if((indexPath.row == 0) || (indexPath.row == lastIndex)){
        // spacer
        cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else if(indexPath.row == 1){
        cell = bannerCell ;
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        BasicCell *basicCell = nil ;
        if(index >= 0){
            Web *web = [webs objectAtIndex:index] ;
            basicCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"] ;
            if (basicCell == nil) {
                BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
                basicCell = (BasicCell *)controller.view ;
            }
            NSString *title = [web title] ;
            [[basicCell titleLabel] setText:title] ;
            [[basicCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
            [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
        } else {
            basicCell = [tableView dequeueReusableCellWithIdentifier:@"BasicFavoritesCell"] ;
            if (basicCell == nil) {
                BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
                basicCell = (BasicCell *)controller.view ;
            }
            NSString *title = NSLocalizedString(@"my_favorites",nil) ;
            [[basicCell titleLabel] setText:title] ;
            [[basicCell titleLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getNewVideosTextColor]] ;
            
            
            UILabel *label = [basicCell titleLabel] ;
            CGSize expectedLabelSize = [title sizeWithFont:label.font
                                         constrainedToSize:CGSizeMake([VeamUtil getScreenWidth], 50)
                                             lineBreakMode:label.lineBreakMode] ;
            //NSLog(@"label width = %f",expectedLabelSize.width) ;
            
            UIImage *image = [VeamUtil imageNamed:@"list_clip.png"] ;
            CGRect labelFrame = label.frame ;
            CGFloat imageWidth = image.size.width / 2 ;
            CGFloat imageHeight = image.size.height / 2 ;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(expectedLabelSize.width+4, (labelFrame.size.height-imageHeight)/2, imageWidth, imageHeight)] ;
            [imageView setImage:image] ;
            [label addSubview:imageView] ;
        }
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        cell = basicCell ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)showWebViewController:(Web *)web animated:(BOOL)animated
{
    if(web != nil){
        //NSLog(@"recipe category tapped : %@ %@",[recipeCategory recipeCategoryId],[recipeCategory name]) ;
        
        WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        [webViewController setTitleName:[web title]] ;
        [webViewController setTitle:[web title]] ;
        [webViewController setUrl:[web url]] ;
        if(numberOfWebs == 1){
            [webViewController setShouldReload:YES] ;
        }
        if(animated){
            [webViewController setShowBackButton:YES] ;
        } else {
            [webViewController setShowBackButton:NO] ;
        }
        [self.navigationController pushViewController:webViewController animated:animated] ;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    //NSLog(@"didSelectRowAtIndexPath %d < %d",indexPath.row,lastIndex) ;
    if((indexOffset <= indexPath.row) && (indexPath.row < lastIndex)){
        NSInteger index = indexPath.row - indexOffset ;
        if(index >= 0){
            Web *web = [webs objectAtIndex:index] ;
            [self showWebViewController:web animated:YES] ;
        } else {
            //
        }
    }
}

- (void)updateList
{
    [webListTableView reloadData] ;
    if(numberOfWebs == 1){
        if([VeamUtil getnumberOfWebs:category] > 1){
            numberOfWebs = [VeamUtil getnumberOfWebs:category] ;
            NSInteger numberOfViewControllers = [self.navigationController.viewControllers count] ;
            //NSLog(@"numberOfViewControllers=%d",numberOfViewControllers) ;
            if(numberOfViewControllers > 1){
                [self.navigationController popToRootViewControllerAnimated:YES] ;
            }
        }
    }
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    //[VeamUtil kickKiip:VEAM_KIIP_LINK_LIST] ;
}

@end
