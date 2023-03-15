//
//  YoutubeSubCategoryViewController.m
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "YoutubeSubCategoryViewController.h"
#import "VeamUtil.h"
#import "BasicCellViewController.h"
#import "YoutubeSubCategory.h"
#import "YoutubeViewController.h"

@interface YoutubeSubCategoryViewController ()

@end

@implementation YoutubeSubCategoryViewController

@synthesize categoryId ;


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

    [self setViewName:[NSString stringWithFormat:@"YoutubeSubCategoryList/%@/%@/",categoryId,self.titleName]] ;

    subCategoryListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [subCategoryListTableView setDelegate:self] ;
    [subCategoryListTableView setDataSource:self] ;
    [subCategoryListTableView setBackgroundColor:[UIColor clearColor]] ;
    [subCategoryListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [subCategoryListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:subCategoryListTableView] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
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
    indexOffset = 1 ;
    subCategories = [VeamUtil getYoutubeSubCategories:categoryId] ;
    lastIndex = indexOffset + [subCategories count] ;
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
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
    } else {
        NSInteger index = indexPath.row - 1 ;
        YoutubeSubCategory *subCategory = [subCategories objectAtIndex:index] ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = [subCategory name] ;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    NSInteger index = indexPath.row - 1 ;
    if(index >= 0){
        YoutubeSubCategory *subCategory = [subCategories objectAtIndex:index] ;
        if(subCategory != nil){
            //NSLog(@"sub category tapped : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
            if([VeamUtil isConnected]){
                YoutubeViewController *youtubeViewController = [[YoutubeViewController alloc] init] ;
                [youtubeViewController setShowBackButton:YES] ;
                [youtubeViewController setSubCategoryId:[subCategory youtubeSubCategoryId]] ;
                [youtubeViewController setTitleName:[subCategory name]] ;
                [self.navigationController pushViewController:youtubeViewController animated:YES] ;
            } else {
                [VeamUtil dispNotConnectedError] ;
            }
        }
    }
}

- (void)updateList
{
    [subCategoryListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}



@end
