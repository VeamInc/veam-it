//
//  MixedCategoryViewController.m
//  veam00000000
//
//  Created by veam on 6/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "MixedCategoryViewController.h"
#import "VeamUtil.h"
#import "DualImageCellViewController.h"
#import "BasicCellViewController.h"
#import "MixedCategory.h"
#import "MixedSubCategoryViewController.h"
#import "MixedViewController.h"
#import "WebViewController.h"

@interface MixedCategoryViewController ()

@end

@implementation MixedCategoryViewController

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
    
    //NSLog(@"%@::viewDidLoad",NSStringFromClass([self class])) ;
    
    [self setViewName:@"MixedCategoryList"] ;
    
    //imageDownloadsInProgressForBulletin = [NSMutableDictionary dictionary];
    
    categoryListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [categoryListTableView setDelegate:self] ;
    [categoryListTableView setDataSource:self] ;
    [categoryListTableView setBackgroundColor:[UIColor clearColor]] ;
    [categoryListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [categoryListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:categoryListTableView] ;
    
    [self addTopBar:NO showSettingsButton:YES] ;
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
    lastIndex = indexOffset + [VeamUtil getNumberOfMixedCategories] ;
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == lastIndex){
        //retValue = [VeamUtil getTabBarHeight] ;
        retValue = 49.0 ; // タブが表示されていないときに更新されると0になってしまうので固定
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if((indexPath.row == 0) || (indexPath.row == lastIndex)){
        // spacer
        cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else if(indexPath.row == 1){
        // My Favorites
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
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
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        
        cell = basicCell ;
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        MixedCategory *category = [VeamUtil getMixedCategoryAt:index] ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = [category name] ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
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

- (void)updateList
{
    [categoryListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.row == 1){
        if([VeamUtil isConnected]){
            MixedViewController *mixedViewController = [[MixedViewController alloc] init] ;
            [mixedViewController setShowBackButton:YES] ;
            [mixedViewController setCategoryId:VEAM_MIXED_CATEGORY_ID_FAVORITES] ;
            [mixedViewController setSubCategoryId:@"0"] ;
            [mixedViewController setTitleName:NSLocalizedString(@"my_favorites",nil)] ;
            [self.navigationController pushViewController:mixedViewController animated:YES] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        if(index >= 0){
            NSInteger index = indexPath.row - indexOffset ;
            MixedCategory *category = [VeamUtil getMixedCategoryAt:index] ;
            if(category != nil){
                NSArray *subCategories = [VeamUtil getMixedSubCategories:[category mixedCategoryId]] ;
                //NSLog(@"subCategories count = %d",[subCategories count]) ;
                if([subCategories count] > 0){
                    //NSLog(@"category tapped : %@ %@",[category categoryId],[category name]) ;
                    MixedSubCategoryViewController *mixedSubCategoryViewController = [[MixedSubCategoryViewController alloc] init] ;
                    [mixedSubCategoryViewController setCategoryId:[category mixedCategoryId]] ;
                    [mixedSubCategoryViewController setTitleName:[category name]] ;
                    [self.navigationController pushViewController:mixedSubCategoryViewController animated:YES] ;
                } else {
                    if([VeamUtil isConnected]){
                        MixedViewController *mixedViewController = [[MixedViewController alloc] init] ;
                        [mixedViewController setShowBackButton:YES] ;
                        [mixedViewController setCategoryId:[category mixedCategoryId]] ;
                        [mixedViewController setSubCategoryId:@"0"] ;
                        [mixedViewController setTitleName:[category name]] ;
                        [self.navigationController pushViewController:mixedViewController animated:YES] ;
                    } else {
                        [VeamUtil dispNotConnectedError] ;
                    }
                }
            }
        }
    }
}

@end
