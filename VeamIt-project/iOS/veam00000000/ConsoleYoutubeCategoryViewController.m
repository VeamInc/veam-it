//
//  ConsoleYoutubeCategoryViewController.m
//  veam00000000
//
//  Created by veam on 6/3/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleYoutubeCategoryViewController.h"
#import "ConsoleEditYoutubeCategoryViewController.h"
#import "ConsoleYoutubeSubCategoryViewController.h"
#import "ConsoleYoutubeViewController.h"
#import "ConsoleYoutubeCategoryTableViewCell.h"
#import "VeamUtil.h"
#import "ConsoleTutorialViewController.h"

@interface ConsoleYoutubeCategoryViewController ()

@end

@implementation ConsoleYoutubeCategoryViewController

@synthesize showCustomizeFirst ;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.shouldShowFloatingMenu = YES ;
    }
    return self;
}

- (void)showFloatingMenu
{
    //NSLog(@"%@::showFloatingMenu",NSStringFromClass([self class])) ;
    NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"NO",@"SELECTED",nil] ;
    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"YES",@"SELECTED",nil] ;
    NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
    NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3,nil] ;
    [VeamUtil showFloatingMenu:elements delegate:self] ;
}

- (void)didTapFloatingMenu:(NSInteger)index
{
    //NSLog(@"%@::didTapFloatingMenu index=%d",NSStringFromClass([self class]),index) ;
    if(index == 0){
        [self handleSwipeRightGesture:nil] ;
    } else if(index == 2){
        [self handleSwipeLeftGesture:nil] ;
    }
}


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
    
    CGFloat currentY = [self addMainTableView] ;
    [tableView setDelegate:self] ;
    [tableView setDataSource:self] ;
    [tableView setContentInset:UIEdgeInsetsMake(44, 0, 100, 0)] ;
    
    if(showCustomizeFirst){
        [self handleSwipeLeftGesture:nil] ;
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger retValue = 0 ;
    if(section == 0){
        numberOfCategories = [[ConsoleUtil getConsoleContents] getNumberOfYoutubeCategories] ;
        retValue = numberOfCategories ; // no add cell
    }
    
    //NSLog(@"numberOfRowsInSection section=%d number=%d",section,retValue) ;
    return retValue ;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfCategories){
            retValue = [ConsoleYoutubeCategoryTableViewCell getCellHeight] ;
        } else {
            retValue = 44 ; // TODO addCell getCellHeight
        }
    }
    return retValue ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat retValue = 0 ;
    return retValue ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = nil ;
    return sectionHeaderView ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil ;
    
    if(indexPath.section == 0){
        if(indexPath.row < numberOfCategories){
            BOOL isLast = (indexPath.row == (numberOfCategories-1)) ;
            YoutubeCategory *category = [[ConsoleUtil getConsoleContents] getYoutubeCategoryAt:indexPath.row] ;
            ConsoleYoutubeCategoryTableViewCell *categoryCell = [[ConsoleYoutubeCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:category.name isLast:isLast] ;
            [VeamUtil registerTapAction:categoryCell.deleteTapView target:self selector:@selector(didDeleteButtonTap:)] ;
            categoryCell.deleteTapView.tag = indexPath.row ;
            [categoryCell setDisabled:[category.disabled isEqualToString:@"1"]] ;
            [categoryCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
            cell = categoryCell ;
        } else {
            // no add button for youtube category
            /*
            ConsoleAddTableViewCell *addCell = [[ConsoleAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:@"Add New Category" isLast:YES] ;
            cell = addCell ;
             */
        }
    }
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnknownCell"] ;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
        [cell.textLabel setText:@""] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }
    
    return cell;
}

- (void)didDeleteButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger index = singleTapGesture.view.tag ;
    YoutubeCategory *category = [[ConsoleUtil getConsoleContents] getYoutubeCategoryAt:index] ;
    [[ConsoleUtil getConsoleContents] disableYoutubeCategoryAt:index disabled:![category.disabled isEqualToString:@"1"]] ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath") ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.section == 0){
        if(indexPath.row < numberOfCategories){
            
            // no edit function
            
            
            /*
            YoutubeCategory *category = [[ConsoleUtil getConsoleContents] getYoutubeCategoryAt:indexPath.row] ;
            if(category != nil){
                if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
                    ConsoleEditYoutubeCategoryViewController *editYoutubeCategoryViewController = [[ConsoleEditYoutubeCategoryViewController alloc] init] ;
                    [editYoutubeCategoryViewController setYoutubeCategory:category] ;
                    [self pushViewController:editYoutubeCategoryViewController] ;
                } else {
                    int count = [[ConsoleUtil getConsoleContents] getNumberOfYoutubeSubCategories:category.youtubeCategoryId] ;
                    if(count == 0){
                        ConsoleYoutubeViewController *youtubeViewController = [[ConsoleYoutubeViewController alloc] init] ;
                        [youtubeViewController setYoutubeCategory:category] ;
                        [youtubeViewController setYoutubeSubCategory:nil] ;
                        [youtubeViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                        [youtubeViewController setShowFooter:YES] ;
                        [youtubeViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                        [self pushViewController:youtubeViewController] ;
                    } else {
                        ConsoleYoutubeSubCategoryViewController *youtubeSubCategoryViewController = [[ConsoleYoutubeSubCategoryViewController alloc] init] ;
                        [youtubeSubCategoryViewController setYoutubeCategory:category] ;
                        [youtubeSubCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                        [youtubeSubCategoryViewController setShowFooter:YES] ;
                        [youtubeSubCategoryViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
                        [self pushViewController:youtubeSubCategoryViewController] ;
                    }
                }
            }
             */
        } else {
            if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
                //NSLog(@"Add") ;
                ConsoleEditYoutubeCategoryViewController *editYoutubeCategoryViewController = [[ConsoleEditYoutubeCategoryViewController alloc] init] ;
                [self pushViewController:editYoutubeCategoryViewController] ;
            }
        }
    }
}

/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"accessoryButtonTappedForRowWithIndexPath") ;
    if(indexPath.section == 0){
        // nothing to do
    } else if(indexPath.section == 1){
        YoutubeCategory *category = [[ConsoleUtil getConsoleContents] getYoutubeCategoryAt:indexPath.row] ;
        if(category != nil){
            ConsoleYoutubeSubCategoryViewController *youtubeSubCategoryViewController = [[ConsoleYoutubeSubCategoryViewController alloc] init] ;
            [youtubeSubCategoryViewController setYoutubeCategory:category] ;
            [youtubeSubCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
            [youtubeSubCategoryViewController setShowFooter:YES] ;
            [youtubeSubCategoryViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
            [self pushViewController:youtubeSubCategoryViewController] ;
        }
    } else if(indexPath.section == 2){
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            //NSLog(@"Add") ;
            ConsoleEditYoutubeCategoryViewController *editYoutubeCategoryViewController = [[ConsoleEditYoutubeCategoryViewController alloc] init] ;
            [self pushViewController:editYoutubeCategoryViewController] ;
        }
    }
}
*/

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"canMoveRowAtIndexPath row=%d",indexPath.row) ;
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfCategories){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(fromIndexPath.row != toIndexPath.row){
        [[ConsoleUtil getConsoleContents] moveYoutubeCategoryFrom:fromIndexPath.row to:toIndexPath.row] ;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //NSLog(@"targetIndexPathForMoveFromRowAtIndexPath") ;
    NSIndexPath *retValue = sourceIndexPath ;
    if (proposedDestinationIndexPath.section == 0) {
        if(proposedDestinationIndexPath.row < numberOfCategories){
            retValue = proposedDestinationIndexPath ;
        } else {
            retValue = [NSIndexPath indexPathForRow:numberOfCategories-1 inSection:sourceIndexPath.section] ;
        }
    }
    return retValue ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfCategories){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
//        [[ConsoleUtil getConsoleContents] disableYoutubeCategoryAt:indexPath.row] ; TODO
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade] ;
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
}

- (void)reloadValues
{
    [tableView reloadData] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
    
    ConsoleTutorialViewController *viewController = [[ConsoleTutorialViewController alloc] init] ;
    
    [viewController setTutorialKind:VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE] ;
    [viewController setHideHeaderBottomLine:NO] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:NSLocalizedString(@"youtube_tutorial", nil)] ;
    [viewController setNumberOfHeaderDots:3] ;
    [viewController setSelectedHeaderDot:2] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [self pushViewController:viewController] ;
    
}


@end
