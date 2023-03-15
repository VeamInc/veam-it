//
//  RecipeViewController.m
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "RecipeViewController.h"
#import "VeamUtil.h"
#import "RecipeCellViewController.h"
#import "Recipe.h"
#import "RecipeDetailViewController.h"

@interface RecipeViewController ()

@end

@implementation RecipeViewController

@synthesize recipeCategoryId ;

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
    
    [self setViewName:[NSString stringWithFormat:@"RecipeList/%@/%@/",recipeCategoryId,self.titleName]] ;
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary];
    
    recipeListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [recipeListTableView setDelegate:self] ;
    [recipeListTableView setDataSource:self] ;
    [recipeListTableView setBackgroundColor:[UIColor clearColor]] ;
    [recipeListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [recipeListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:recipeListTableView] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
             case 2:
             imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
             break;
             */
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if(imageDownloader == nil){
        //NSLog(@"new imageDownloader") ;
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.imageIndex = imageIndex ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload] ;
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
             case 2:
             imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
             break;
             */
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        RecipeCell *cell = (RecipeCell *)[recipeListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView] ;
        
        // NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.thumbnailImageView.image = [VeamUtil getSquareImage:imageDownloader.pictureImage] ;
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    indexOffset = 1 ;
    recipes = [VeamUtil getRecipes:recipeCategoryId] ;
    lastIndex = indexOffset + [recipes count] ;
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
    } else {
        retValue = 88.0 ; // youtube cell height
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
        NSInteger index = indexPath.row - indexOffset ;
        Recipe *recipe = [recipes objectAtIndex:index] ;
        RecipeCell *recipeCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (recipeCell == nil) {
            RecipeCellViewController *controller = [[RecipeCellViewController alloc] initWithNibName:@"RecipeCell" bundle:nil] ;
            recipeCell = (RecipeCell *)controller.view ;
        }
        NSString *title = [recipe title] ;
        [recipeCell.titleLabel setText:title] ;
        
        NSString *thumbnailUrl = [recipe imageUrl] ;
        //NSLog(@"image url : %@",thumbnailUrl) ;
        if([VeamUtil isEmpty:thumbnailUrl]){
            [recipeCell.thumbnailImageView setImage:[VeamUtil imageNamed:@"no_recipe_s.png"]] ;
        } else {
            [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
        }
        cell = recipeCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    NSInteger index = indexPath.row - indexOffset ;
    if(index >= 0){
        Recipe *recipe = [recipes objectAtIndex:index] ;
        if(recipe != nil){
            //NSLog(@"recipe tapped : %@ %@",[recipe recipeId],[recipe title]) ;
            //[VeamUtil showRecipeDetailView:recipe title:self.titleName] ;

            RecipeDetailViewController *recipeDetailViewController = [[RecipeDetailViewController alloc] init] ;
            [recipeDetailViewController setRecipe:recipe] ;
            [recipeDetailViewController setTitleName:self.titleName] ;
            //[recipeDetailViewController setHidesBottomBarWhenPushed:YES] ;
            [self.navigationController pushViewController:recipeDetailViewController animated:YES] ;
        }
    }
}

- (void)updateList
{
    [recipeListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


@end
