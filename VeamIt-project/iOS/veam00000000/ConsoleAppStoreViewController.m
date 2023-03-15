//
//  ConsoleAppStoreViewController.m
//  ColorPickerTest
//
//  Created by veam on 8/20/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleAppStoreViewController.h"

#import "ConsoleEditAppInformationViewController.h"
#import "AppStoreSummaryTableViewCell.h"
#import "AppStoreDescriptionTableViewCell.h"
#import "AppStoreInformationTableViewCell.h"
#import "AppStoreScreenShotTableViewCell.h"
#import "VeamUtil.h"
#import "ImageDownloader.h"

#define APP_STORE_EDIT_BUTTON_HEIGHT    44

#define CONSOLE_VIEW_SCREEN_SHOT_1      7
#define CONSOLE_VIEW_SCREEN_SHOT_2      8
#define CONSOLE_VIEW_SCREEN_SHOT_3      9
#define CONSOLE_VIEW_SCREEN_SHOT_4      10
#define CONSOLE_VIEW_SCREEN_SHOT_5      11


@interface ConsoleAppStoreViewController ()

@end

@implementation ConsoleAppStoreViewController

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
    
    imageDownloadsInProgressForIcon = [NSMutableDictionary dictionary] ;
    screenShotUploading = [NSMutableArray arrayWithObjects:@"NO",@"NO",@"NO",@"NO",@"NO",nil] ;

    CGFloat currentY = 0 ; 
    screenShot1ImageInputBarView = [self addImageInputBar:@"Screen Shot 1" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_1] ;
    [screenShot1ImageInputBarView setAlpha:0.0] ;
    
    screenShot2ImageInputBarView = [self addImageInputBar:@"Screen Shot 2" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_2] ;
    [screenShot2ImageInputBarView setAlpha:0.0] ;
    
    screenShot3ImageInputBarView = [self addImageInputBar:@"Screen Shot 3" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_3] ;
    [screenShot3ImageInputBarView setAlpha:0.0] ;
    
    screenShot4ImageInputBarView = [self addImageInputBar:@"Screen Shot 4" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_4] ;
    [screenShot4ImageInputBarView setAlpha:0.0] ;
    
    screenShot5ImageInputBarView = [self addImageInputBar:@"Screen Shot 5" y:currentY fullBottomLine:YES
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_5] ;
    [screenShot5ImageInputBarView setAlpha:0.0] ;

    
    
    
    appTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VEAM_CONSOLE_HEADER_HEIGHT, [VeamUtil getScreenWidth], contentView.frame.size.height-VEAM_CONSOLE_HEADER_HEIGHT-APP_STORE_EDIT_BUTTON_HEIGHT)] ;
    appTableView.delegate = self ;
    appTableView.dataSource = self ;
    [appTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [contentView addSubview:appTableView] ;
    
    UIView *editButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height-APP_STORE_EDIT_BUTTON_HEIGHT, [VeamUtil getScreenWidth], APP_STORE_EDIT_BUTTON_HEIGHT)] ;
    [editButtonView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFF8F8F8"]] ;
    [VeamUtil registerTapAction:editButtonView target:self selector:@selector(didEditButtonTap)] ;
    [contentView addSubview:editButtonView] ;

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], 0.5)] ;
    [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
    [editButtonView addSubview:separatorView] ;
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], APP_STORE_EDIT_BUTTON_HEIGHT)] ;
    [buttonLabel setBackgroundColor:[UIColor clearColor]] ;
    [buttonLabel setText:NSLocalizedString(@"edit_your_app_information", nil)] ;
    [buttonLabel setTextColor:[UIColor blackColor]] ;
    [buttonLabel setTextAlignment:NSTextAlignmentCenter] ;
    [buttonLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.5]] ;
    [editButtonView addSubview:buttonLabel] ;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth] - 33, 7, 30, 30)] ;
    [iconImageView setImage:[UIImage imageNamed:@"c_edit_app.png"]] ;
    [editButtonView addSubview:iconImageView] ;
    
    
    contents = [ConsoleUtil getConsoleContents] ;
    
    
}

- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    
    AppStoreScreenShotTableViewCell *cell = (AppStoreScreenShotTableViewCell *)[appTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] ;

    NSInteger index = 0 ;
    switch (view.tag) {
        case CONSOLE_VIEW_SCREEN_SHOT_1:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_1") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"1"] ;
            index = 0 ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_2:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_2") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"2"] ;
            index = 1 ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_3:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_3") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"3"] ;
            index = 2 ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_4:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_4") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"4"] ;
            index = 3 ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_5:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_5") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"5"] ;
            index = 4 ;
            break;
        default:
            break;
    }
    
    UIActivityIndicatorView *indicator = [cell.uploadIndicators objectAtIndex:index] ;
    [indicator startAnimating] ;
    [indicator setHidden:NO] ;
    [screenShotUploading setObject:@"YES" atIndexedSubscript:index] ;

}


- (void)didEditButtonTap
{
    //NSLog(@"didEditButtonTap") ;
    ConsoleEditAppInformationViewController *appInformationViewController = [[ConsoleEditAppInformationViewController alloc] init] ;
    [appInformationViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
    [self pushViewController:appInformationViewController] ;
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




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 0 ;
    
    switch (section) {
        case 0:
            retValue = 1 ;
            break;
        case 1:
            retValue = 8 ;
            break;
            
        default:
            break;
    }
    
    return retValue ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat retValue = 0 ;
    
    if(section == 1){
        retValue = 50 ;
    }
    
    return retValue ;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *retValue = nil ;
    
    if(section == 1){
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], 50)] ;
        [sectionHeaderView setBackgroundColor:[UIColor whiteColor]] ;
        
        NSArray *titles = [NSArray arrayWithObjects:
                           NSLocalizedString(@"app_store_details", nil),
                           NSLocalizedString(@"app_store_reviews", nil),
                           NSLocalizedString(@"app_store_related", nil),
                           nil] ;
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titles] ;
        segment.frame = CGRectMake(15, 10, 290, 30) ;
        segment.segmentedControlStyle = UISegmentedControlStyleBar ;
        segment.selectedSegmentIndex = 0 ;
        segment.backgroundColor = [UIColor whiteColor] ;
        segment.tintColor = [UIColor grayColor] ;
        [sectionHeaderView addSubview:segment] ;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, [VeamUtil getScreenWidth], 0.5)] ;
        [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFB5B5B5"]] ;
        [sectionHeaderView addSubview:separatorView] ;
        
        retValue = sectionHeaderView ;
    }
    
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIColor *backgroundColor = [VeamUtil getColorFromArgbString:@"FFF7F7F7"] ;
    
    UITableViewCell *retValue = nil ;
    if(indexPath.section == 0){
        AppStoreSummaryTableViewCell *cell = [[AppStoreSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:contents.appInfo.storeAppName] ;
        NSString *iconImageUrl = contents.appInfo.iconImageUrl ;
        //NSLog(@"iconImageUrl = %@",iconImageUrl) ;
        UIImage *iconImage = [VeamUtil getCachedImage:iconImageUrl downloadIfNot:NO] ;
        if(iconImage != nil){
            [cell.iconImageView setImage:iconImage] ;
        } else {
            [cell.iconImageView setImage:[VeamUtil imageNamed:@"c_veam_icon.png"]] ;
            [self startImageDownload:iconImageUrl forIndexPath:indexPath imageIndex:1] ;
        }
        /*
        [storeAppNameInputBarView setInputValue:contents.appInfo.storeAppName] ;
        [descriptionInputBarView setInputValue:contents.appInfo.description] ;
        [keywordInputBarView setInputValue:contents.appInfo.keyword] ;
        [categoryInputBarView setInputValue:contents.appInfo.category] ;
        [screenShot1ImageInputBarView setInputValue:contents.appInfo.screenShot1Url] ;
        [screenShot2ImageInputBarView setInputValue:contents.appInfo.screenShot2Url] ;
        [screenShot3ImageInputBarView setInputValue:contents.appInfo.screenShot3Url] ;
        [screenShot4ImageInputBarView setInputValue:contents.appInfo.screenShot4Url] ;
        [screenShot5ImageInputBarView setInputValue:contents.appInfo.screenShot5Url] ;
         */

        retValue = cell ;
    } else {
        if(indexPath.row == 0){
            //NSLog(@"cell for screen shot") ;
            NSString *cellIdentifier = @"ScreenShotCell" ;
            AppStoreScreenShotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier] ;
            
            if (!cell) {
                //NSLog(@"create new") ;
                cell = [[AppStoreScreenShotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
            }
            
            NSMutableArray *imageViews = cell.screenShotImageViews ;
            NSMutableArray *urls = [NSMutableArray array] ;
            [urls addObject:contents.appInfo.screenShot1Url] ;
            [urls addObject:contents.appInfo.screenShot2Url] ;
            [urls addObject:contents.appInfo.screenShot3Url] ;
            [urls addObject:contents.appInfo.screenShot4Url] ;
            [urls addObject:contents.appInfo.screenShot5Url] ;
            
            int count = [imageViews count] ;
            if([urls count] < count){
                count = [urls count] ;
            }
            for(int index = 0 ; index < count ; index++){
                if([[screenShotUploading objectAtIndex:index] isEqualToString:@"YES"]){
                    UIActivityIndicatorView *uploadIndicator = [cell.uploadIndicators objectAtIndex:index] ;
                    [uploadIndicator startAnimating] ;
                    [uploadIndicator setHidden:NO] ;
                }

                NSString *imageUrl = [urls objectAtIndex:index] ;
                //NSLog(@"ss%d:%@",index,imageUrl) ;
                UIImageView *imageView = [imageViews objectAtIndex:index] ;
                if(![VeamUtil isEmpty:imageUrl]){
                    UIImage *image = [VeamUtil getCachedImage:imageUrl downloadIfNot:NO] ;
                    if(image != nil){
                        [imageView setImage:image] ;
                    } else {
                        [imageView setImage:[VeamUtil imageNamed:@"c_screen_shot.png"]] ;
                        [self startImageDownload:imageUrl forIndexPath:indexPath imageIndex:index] ;
                        UIActivityIndicatorView *indicator = [cell.loadIndicators objectAtIndex:index] ;
                        [indicator startAnimating] ;
                        [indicator setHidden:NO] ;
                    }
                } else {
                    [imageView setImage:[VeamUtil imageNamed:@"c_screen_shot.png"]] ;
                }
            }
            /*
            [VeamUtil registerTapAction:[cell.uploadImageViews objectAtIndex:0] target:self selector:@selector(didUploadScreenshot1Tap)] ;
            [VeamUtil registerTapAction:[cell.uploadImageViews objectAtIndex:1] target:self selector:@selector(didUploadScreenshot2Tap)] ;
            [VeamUtil registerTapAction:[cell.uploadImageViews objectAtIndex:2] target:self selector:@selector(didUploadScreenshot3Tap)] ;
            [VeamUtil registerTapAction:[cell.uploadImageViews objectAtIndex:3] target:self selector:@selector(didUploadScreenshot4Tap)] ;
            [VeamUtil registerTapAction:[cell.uploadImageViews objectAtIndex:4] target:self selector:@selector(didUploadScreenshot5Tap)] ;
             */
            
            [cell.contentView setBackgroundColor:backgroundColor] ;
            retValue = cell ;

        } else if(indexPath.row == 1){
            AppStoreDescriptionTableViewCell *cell = [[AppStoreDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" description:contents.appInfo.description] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            retValue = cell ;
        } else if(indexPath.row == 2){
            AppStoreInformationTableViewCell *cell = [[AppStoreInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" category:contents.appInfo.category] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            retValue = cell ;
        } else if(indexPath.row == 3){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            [cell.textLabel setText:NSLocalizedString(@"app_store_in_app_purchases", nil)] ;
            [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, 43, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
            [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
            [cell.contentView addSubview:separatorView] ;
            [cell setBackgroundColor:[UIColor clearColor]] ;
            retValue = cell ;
        } else if(indexPath.row == 4){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            [cell.textLabel setText:NSLocalizedString(@"app_store_version_history", nil)] ;
            [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, 43, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
            [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
            [cell.contentView addSubview:separatorView] ;
            [cell setBackgroundColor:[UIColor clearColor]] ;
            retValue = cell ;
        } else if(indexPath.row == 5){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            [cell.textLabel setText:NSLocalizedString(@"app_store_developer_web_site", nil)] ;
            [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, 43, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
            [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
            [cell.contentView addSubview:separatorView] ;
            [cell setBackgroundColor:[UIColor clearColor]] ;
            retValue = cell ;
        } else if(indexPath.row == 6){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            [cell.textLabel setText:NSLocalizedString(@"app_store_privacy_policy", nil)] ;
            [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, 43, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
            [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
            [cell.contentView addSubview:separatorView] ;
            [cell setBackgroundColor:[UIColor clearColor]] ;
            retValue = cell ;
        } else if(indexPath.row == 7){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            [cell.textLabel setText:NSLocalizedString(@"app_store_developer_app", nil)] ;
            [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, 43, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
            [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
            [cell.contentView addSubview:separatorView] ;
            [cell setBackgroundColor:[UIColor clearColor]] ;
            retValue = cell ;
            /*
        } else if(indexPath.row == 8){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            [cell.textLabel setText:@"Copyright"] ;
            [cell.contentView setBackgroundColor:backgroundColor] ;
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, 43, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
            [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
            retValue = cell ;
             */
        }
    }

    [retValue setSelectionStyle:UITableViewCellSelectionStyleNone] ;

    return retValue ;
}

- (void)didUploadScreenshot1Tap
{
    if([[screenShotUploading objectAtIndex:0] isEqualToString:@"NO"]){
        [screenShot1ImageInputBarView showInputView] ;
    }
}

- (void)didUploadScreenshot2Tap
{
    if([[screenShotUploading objectAtIndex:1] isEqualToString:@"NO"]){
        [screenShot2ImageInputBarView showInputView] ;
    }
}

- (void)didUploadScreenshot3Tap
{
    if([[screenShotUploading objectAtIndex:2] isEqualToString:@"NO"]){
        [screenShot3ImageInputBarView showInputView] ;
    }
}

- (void)didUploadScreenshot4Tap
{
    if([[screenShotUploading objectAtIndex:3] isEqualToString:@"NO"]){
        [screenShot4ImageInputBarView showInputView] ;
    }
}

- (void)didUploadScreenshot5Tap
{
    if([[screenShotUploading objectAtIndex:4] isEqualToString:@"NO"]){
        [screenShot5ImageInputBarView showInputView] ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    if(indexPath.section == 0){
        retValue = 120 ;
    } else {
        if(indexPath.row == 0){
            retValue = [AppStoreScreenShotTableViewCell getCellHeight] ;
        } else if(indexPath.row == 1){
            retValue = [AppStoreDescriptionTableViewCell getCellHeight:NSLocalizedString(@"app_store_description", nil) showFull:NO] ;
        } else if(indexPath.row == 2){
            retValue = APP_STORE_INFORMATION_CELL_HEIGHT ;
        } else if(indexPath.row == 3){
            retValue = 44 ;
        } else if(indexPath.row == 4){
            retValue = 44 ;
        } else if(indexPath.row == 6){
            retValue = 44 ;
        } else if(indexPath.row == 7){
            retValue = 44 ;
        } else if(indexPath.row == 8){
            retValue = 44 ;
        }
    }
    
    return retValue ;
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"viewDidAppear") ;
    [super viewDidAppear:animated] ;
    
    if(appTableView != nil){
        [appTableView reloadData] ;
    }
    
}

- (NSString *)getImageKey:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    return [NSString stringWithFormat:@"%d_%d_%d",indexPath.section,indexPath.row,imageIndex] ;
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    NSMutableDictionary *imageDownloadsInProgress = imageDownloadsInProgressForIcon ;
    NSString *key = [self getImageKey:indexPath imageIndex:imageIndex] ;
    //NSLog(@"key:%@",key) ;
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:key] ;
    if(imageDownloader == nil){
        //NSLog(@"new imageDownloader") ;
        imageDownloader = [[ImageDownloader alloc] init] ;
        imageDownloader.indexPathInTableView = indexPath ;
        imageDownloader.imageIndex = imageIndex ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloadsInProgress setObject:imageDownloader forKey:key] ;
        [imageDownloader startDownload] ;
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d-%d %d",indexPath.section,[indexPath row],imageIndex) ;
    NSString *key = [self getImageKey:indexPath imageIndex:imageIndex] ;
    //NSLog(@"key:%@",key) ;
    
    NSMutableDictionary *imageDownloadsInProgress = imageDownloadsInProgressForIcon ;
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:key] ;
    
    [imageDownloadsInProgress removeObjectForKey:key] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        if(indexPath.section == 0){
            AppStoreSummaryTableViewCell *cell = (AppStoreSummaryTableViewCell *)[appTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView] ;
            cell.iconImageView.image = imageDownloader.pictureImage ;
        } else {
            //NSLog(@"section 1") ;
            if(indexPath.row == 0){
                //NSLog(@"row 0") ;
                //NSLog(@"imagedownloader section %d row %d",imageDownloader.indexPathInTableView.section,imageDownloader.indexPathInTableView.row) ;
                AppStoreScreenShotTableViewCell *cell = (AppStoreScreenShotTableViewCell *)[appTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView] ;
                //NSLog(@"count:%d",[cell.screenShotImageViews count]) ;
                if(imageIndex < [cell.screenShotImageViews count]){
                    //NSLog(@"within count") ;
                    UIImageView *imageView = [cell.screenShotImageViews objectAtIndex:imageIndex] ;
                    [imageView setImage:imageDownloader.pictureImage] ;
                    
                    UIActivityIndicatorView *indicator = [cell.loadIndicators objectAtIndex:imageIndex] ;
                    [indicator setHidden:YES] ;
                    [indicator stopAnimating] ;
                }
            }
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

- (void)updateContents
{
    //NSLog(@"ConsoleAppStoreViewController:updateContents") ;
    [appTableView reloadData] ;
}


-(void)requestDidPost:(NSNotification *)notification
{
    //NSLog(@"ConsoleAppStoreViewController::requestDidPost") ;
    NSString *apiName = [[notification userInfo] objectForKey:@"API_NAME"] ;
    if([apiName isEqualToString:@"app/setscreenshot"]){
        NSDictionary *params = [[notification userInfo] objectForKey:@"PARAMS"] ;
        NSString *screenShotNo = [params objectForKey:@"n"] ;
        //NSLog(@"screen shot %@ sent",screenShotNo) ;
        NSInteger index = [screenShotNo integerValue] ;
        index-- ;
        
        AppStoreScreenShotTableViewCell *cell = (AppStoreScreenShotTableViewCell *)[appTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] ;
        //NSLog(@"count:%d",[cell.screenShotImageViews count]) ;
        if(index < [cell.uploadIndicators count]){
            //NSLog(@"within count") ;
            UIActivityIndicatorView *indicator = [cell.uploadIndicators objectAtIndex:index] ;
            [indicator setHidden:YES] ;
            [indicator stopAnimating] ;
            [screenShotUploading setObject:@"NO" atIndexedSubscript:index] ;
        }
    }
}




@end

