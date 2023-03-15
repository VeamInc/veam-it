//
//  ConsoleYoutubeSubCategoryViewController.m
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleYoutubeSubCategoryViewController.h"
#import "VeamUtil.h"
#import "ConsoleEditYoutubeSubCategoryViewController.h"
#import "ConsoleYoutubeViewController.h"

@interface ConsoleYoutubeSubCategoryViewController ()

@end

@implementation ConsoleYoutubeSubCategoryViewController

@synthesize youtubeCategory ;

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
    return 3 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 0 ;
    if(section == 0){
        // title seciton
        retValue = 1 ;
    } else if(section == 1){
        retValue = [[ConsoleUtil getConsoleContents] getNumberOfYoutubeSubCategories:youtubeCategory.youtubeCategoryId] ;
    } else if(section == 2){
        // add category section
        retValue = 1 ;
    }
    
    //NSLog(@"numberOfRowsInSection section=%d number=%d",section,retValue) ;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            cell.textLabel.text = @"Sub Category Settings" ;
        } else {
            cell.textLabel.text = @"Sub Category List" ;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14.0] ;
    } else if(indexPath.section == 1){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        if(cell.backgroundView == nil){
            cell.backgroundView = [[UIView alloc] init] ;
        }
        [cell.backgroundView setBackgroundColor:[VeamUtil getColorFromArgbString:@"4CE0E0E0"]] ;
        YoutubeSubCategory *youtubeSubCategory = [[ConsoleUtil getConsoleContents] getYoutubeSubCategoryAt:indexPath.row youtubeCategoryId:youtubeCategory.youtubeCategoryId] ;
        cell.textLabel.text = youtubeSubCategory.name ;
        cell.textLabel.font = [UIFont systemFontOfSize:15.5] ;
    } else if(indexPath.section == 2){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            cell.textLabel.text = @"+ Add New Sub Category" ;
        } else {
            cell.textLabel.text = @"" ;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15.5] ;
    }
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnknownCell"] ;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
        [cell.textLabel setText:@""] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath") ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.section == 0){
        // nothing to do
    } else if(indexPath.section == 1){
        YoutubeSubCategory *subCategory = [[ConsoleUtil getConsoleContents] getYoutubeSubCategoryAt:indexPath.row youtubeCategoryId:youtubeCategory.youtubeCategoryId] ;
        if(subCategory != nil){
            if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
                ConsoleEditYoutubeSubCategoryViewController *editYoutubeSubCategoryViewController = [[ConsoleEditYoutubeSubCategoryViewController alloc] init] ;
                [editYoutubeSubCategoryViewController setYoutubeSubCategory:subCategory] ;
                [self pushViewController:editYoutubeSubCategoryViewController] ;
            } else {
                ConsoleYoutubeViewController *youtubeViewController = [[ConsoleYoutubeViewController alloc] init] ;
                [youtubeViewController setYoutubeCategory:youtubeCategory] ;
                [youtubeViewController setYoutubeSubCategory:subCategory] ;
                [youtubeViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                [youtubeViewController setShowFooter:YES] ;
                [youtubeViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                [self pushViewController:youtubeViewController] ;
            }
        }
    } else if(indexPath.section == 2){
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            //NSLog(@"Add Sub Category c=%@",youtubeCategory.youtubeCategoryId) ;
            ConsoleEditYoutubeSubCategoryViewController *editYoutubeSubCategoryViewController = [[ConsoleEditYoutubeSubCategoryViewController alloc] init] ;
            [editYoutubeSubCategoryViewController setYoutubeCategory:youtubeCategory] ;
            [self pushViewController:editYoutubeSubCategoryViewController] ;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"canMoveRowAtIndexPath row=%d",indexPath.row) ;
    BOOL retValue = NO ;
    if(indexPath.section == 1){
        retValue = YES ;
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(fromIndexPath.row != toIndexPath.row){
        [[ConsoleUtil getConsoleContents] moveYoutubeSubCategoryFrom:fromIndexPath.row to:toIndexPath.row youtubeCategoryId:youtubeCategory.youtubeCategoryId] ;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *retValue = sourceIndexPath ;
    if (proposedDestinationIndexPath.section == 1) {
        retValue = proposedDestinationIndexPath ;
    }
    return retValue ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL retValue = NO ;
    if(indexPath.section == 1){
        retValue = YES ;
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[ConsoleUtil getConsoleContents] removeYoutubeSubCategoryAt:indexPath.row youtubeCategoryId:youtubeCategory.youtubeCategoryId] ;
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

@end
