//
//  RecipeCategoryViewController.m
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "RecipeCategoryViewController.h"
#import "VeamUtil.h"
#import "RecipeCategory.h"
#import "BasicCellViewController.h"
#import "RecipeViewController.h"

@interface RecipeCategoryViewController ()

@end

@implementation RecipeCategoryViewController

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
    
    [self setViewName:@"RecipeCategoryList/"] ;
    
    recipeCategoryListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [recipeCategoryListTableView setDelegate:self] ;
    [recipeCategoryListTableView setDataSource:self] ;
    [recipeCategoryListTableView setBackgroundColor:[UIColor clearColor]] ;
    [recipeCategoryListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [recipeCategoryListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:recipeCategoryListTableView] ;
    
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
    recipeCategories = [VeamUtil getRecipeCategories] ;
    lastIndex = indexOffset + [recipeCategories count] ;
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
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else {
        NSInteger index = indexPath.row - 2 ;
        BasicCell *basicCell = nil ;
        if(index >= 0){
            RecipeCategory *recipeCategory = [recipeCategories objectAtIndex:index] ;
            basicCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"] ;
            if (basicCell == nil) {
                BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
                basicCell = (BasicCell *)controller.view ;
            }
            NSString *title = [recipeCategory name] ;
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
    
    NSInteger index = indexPath.row - 2 ;
    if(index >= 0){
        RecipeCategory *recipeCategory = [recipeCategories objectAtIndex:index] ;
        if(recipeCategory != nil){
            //NSLog(@"recipe category tapped : %@ %@",[recipeCategory recipeCategoryId],[recipeCategory name]) ;
            RecipeViewController *recipeViewController = [[RecipeViewController alloc] init] ;
            [recipeViewController setRecipeCategoryId:[recipeCategory recipeCategoryId]] ;
            [recipeViewController setTitleName:[recipeCategory name]] ;
            [self.navigationController pushViewController:recipeViewController animated:YES] ;
        }
    } else if(index == -1){
        // My Favorites
        RecipeViewController *recipeViewController = [[RecipeViewController alloc] init] ;
        [recipeViewController setRecipeCategoryId:@"FAVORITES"] ;
        [recipeViewController setTitleName:NSLocalizedString(@"my_favorites",nil)] ;
        [self.navigationController pushViewController:recipeViewController animated:YES] ;
    }
}

- (void)updateList
{
    [recipeCategoryListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


@end
