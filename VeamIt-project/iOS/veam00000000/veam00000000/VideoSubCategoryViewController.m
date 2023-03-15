//
//  VideoSubCategoryViewController.m
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VideoSubCategoryViewController.h"
#import "VeamUtil.h"
#import "BasicCellViewController.h"
#import "VideoSubCategory.h"
#import "VideoViewController.h"

@interface VideoSubCategoryViewController ()

@end

@implementation VideoSubCategoryViewController

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

    [self setViewName:[NSString stringWithFormat:@"VideoSubCategoryList/%@/%@/",categoryId,self.titleName]] ;

    videoSubCategoryListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [videoSubCategoryListTableView setDelegate:self] ;
    [videoSubCategoryListTableView setDataSource:self] ;
    [videoSubCategoryListTableView setBackgroundColor:[UIColor clearColor]] ;
    [videoSubCategoryListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [videoSubCategoryListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:videoSubCategoryListTableView] ;
    
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
    //NSLog(@"category id %@",categoryId ) ;
    videoSubCategories = [VeamUtil getVideoSubCategories:categoryId] ;
    lastIndex = indexOffset + [videoSubCategories count] ;
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
        VideoSubCategory *videoSubCategory = [videoSubCategories objectAtIndex:index] ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = [videoSubCategory name] ;
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
    
    if((indexOffset <= indexPath.row) && (indexPath.row < lastIndex)){
        NSInteger index = indexPath.row - indexOffset ;
        if(index >= 0){
            VideoSubCategory *videoSubCategory = [videoSubCategories objectAtIndex:index] ;
            if(videoSubCategory != nil){
                //NSLog(@"sub category tapped : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
                VideoViewController *videoViewController = [[VideoViewController alloc] init] ;
                [videoViewController setSubCategoryId:[videoSubCategory videoSubCategoryId]] ;
                [videoViewController setTitleName:[videoSubCategory name]] ;
                [self.navigationController pushViewController:videoViewController animated:YES] ;
            }
        }
    }
}

- (void)updateList
{
    [videoSubCategoryListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


@end
