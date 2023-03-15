//
//  SellSectionCategoryViewController.m
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellSectionCategoryViewController.h"
#import "VeamUtil.h"
#import "DualImageCellViewController.h"
#import "BasicCellViewController.h"
#import "SellSectionItemViewController.h"
#import "SellSectionCategory.h"

#define EMBEDED_DESCRIPTION_CELL_LINE_HEIGHT    17

@interface SellSectionCategoryViewController ()

@end

@implementation SellSectionCategoryViewController

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
    
    //NSLog(@"SellSectionCategoryViewController::viewDidLoad start") ;
    
    [self setViewName:@"SellSectionCategoryList/"] ;
    
    imageDownloadsInProgressForBulletin = [NSMutableDictionary dictionary];
    
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
    
    shouldShowDescription = NO ;
    if(![VeamUtil getSellSectionIsBought:@"0"]){
        //NSLog(@"Not bought") ;
        embededDescription = [VeamUtil getSellSectionDescription] ;
        if(![VeamUtil isEmpty:embededDescription]){
            //NSLog(@"Embeded description found") ;
            shouldShowDescription = YES ;
        }
    }
    
    if(shouldShowDescription){
        indexOffset++ ;
    }

    
    lastIndex = indexOffset + [VeamUtil getNumberOfSellSectionCategories] ;
    NSInteger retInt = lastIndex + 1 ;
    
    //NSLog(@"numberOfRowsInSection %d",retInt) ;
    
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == 1){
        retValue = 160.0 ; // dual image cell height
    } else if(shouldShowDescription && (indexPath.row == 2)){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 288, 1)] ;
        [self configEmbededDescriptionLabel:label] ;
        retValue = label.frame.size.height + 22 ; // height of description
    } else if(indexPath.row == lastIndex){
        //retValue = [VeamUtil getTabBarHeight] ;
        retValue = 49.0 ; // タブが表示されていないときに更新されると0になってしまうので固定
    }

    //NSLog(@"heightForRowAtIndexPath %d,%f",indexPath.row,retValue) ;
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (void)configEmbededDescriptionLabel:(UILabel *)label
{
    [label setLineBreakMode:NSLineBreakByWordWrapping] ;
    [label setNumberOfLines:0];
    [label setText:embededDescription] ;
    [VeamUtil setTextWithLineHeight:label text:embededDescription lineHeight:EMBEDED_DESCRIPTION_CELL_LINE_HEIGHT] ;
    
    [label setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [label setHighlightedTextColor:[VeamUtil getNewVideosTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]] ;
    [label sizeToFit] ;
    
    CGRect frame = label.frame ;
    frame.origin.y = 7 ;
    [label setFrame:frame] ;
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
        // image
        DualImageCell *dualImageCell = [tableView dequeueReusableCellWithIdentifier:@"Image"] ;
        if (dualImageCell == nil) {
            DualImageCellViewController *controller = [[DualImageCellViewController alloc] initWithNibName:@"DualImageCell" bundle:nil] ;
            dualImageCell = (DualImageCell *)controller.view ;
        }
        
        ////NSLog(@"current bulletin is nil") ;
        [dualImageCell.leftImageView setHidden:NO] ;
        [dualImageCell.leftLabel setHidden:YES] ;
        
        NSString *leftImageName = nil ;
        //leftImageName = [NSString stringWithFormat:@"t%@_top_left.png",VEAM_TEMPLATE_ID_SUBSCRIPTION] ;
        leftImageName = @"video_left.png" ;
        //NSLog(@"left image=%@",leftImageName) ;
        [dualImageCell.leftImageView setImage:[VeamUtil imageNamed:leftImageName]] ;
        
        NSString *rightImageName = nil ;
        rightImageName = [NSString stringWithFormat:@"t%@_top_right.png",VEAM_TEMPLATE_ID_SUBSCRIPTION] ;
        [dualImageCell.rightImageView setImage:[VeamUtil imageNamed:rightImageName]] ;
        
        [dualImageCell.leftBackView setAlpha:0.0] ;
        [dualImageCell setBackgroundColor:[UIColor clearColor]] ;
        [dualImageCell.contentView setBackgroundColor:[UIColor clearColor]] ;
        
        cell = dualImageCell ;
    } else if(shouldShowDescription && (indexPath.row == 2)){
        BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
        BasicCell *basicCell = (BasicCell *)controller.view ;
        
        [self configEmbededDescriptionLabel:basicCell.titleLabel] ;
        
        CGRect frame = basicCell.separatorView.frame ;
        frame.origin.y = basicCell.titleLabel.frame.size.height + 20 ;
        [basicCell.separatorView setFrame:frame] ;
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        [basicCell.arrowImage setAlpha:0.0] ;
        
        [basicCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        
        cell = basicCell ;
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        SellSectionCategory *category = [VeamUtil getSellSectionCategoryAt:index] ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        NSString *title = [category getTargetName] ;
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
        [[basicCell titleLabel] setHighlightedTextColor:[VeamUtil getBaseTextColor]] ;
        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
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
    
    NSInteger index = indexPath.row - indexOffset ;
    if(index >= 0){
        NSInteger index = indexPath.row - indexOffset ;
        
        SellSectionCategory *sellSectionCategory = [VeamUtil getSellSectionCategoryAt:index] ;
        if(sellSectionCategory != nil){
            SellSectionItemViewController *viewController = [[SellSectionItemViewController alloc] init] ;
            [viewController setCategoryId:[sellSectionCategory sellSectionCategoryId]] ;
            [viewController setSubCategoryId:@"0"] ;
            [viewController setTitleName:[sellSectionCategory name]] ;
            [self.navigationController pushViewController:viewController animated:YES] ;
        }
    }
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForBulletin ;
            break;
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
            imageDownloadsInProgress = imageDownloadsInProgressForBulletin ;
            break;
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        DualImageCell *cell = (DualImageCell *)[categoryListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.leftImageView.image = imageDownloader.pictureImage ;
        }
    } else {
        //NSLog(@"imageDownloader is nil") ;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"%@::viewDidAppear",NSStringFromClass([self class])) ;
    if([VeamUtil getSellSectionIsBought:@"0"]){
        //NSLog(@"bought") ;
        //NSLog(@"call update") ;
        [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
    }
}



@end
