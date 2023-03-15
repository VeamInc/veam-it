//
//  ConsoleVideoCategoryViewController.m
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleVideoCategoryViewController.h"
#import "ConsoleEditVideoCategoryViewController.h"
#import "ConsoleVideoSubCategoryViewController.h"
#import "ConsoleVideoViewController.h"
#import "VeamUtil.h"
#import "ConsoleVideoCategoryTableViewCell.h"

@interface ConsoleVideoCategoryViewController ()

@end

@implementation ConsoleVideoCategoryViewController

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
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 0 ;
    if(section == 0){
        numberOfVideoCategories = [[ConsoleUtil getConsoleContents] getNumberOfVideoCategories] ;
        retValue = numberOfVideoCategories + 1 ; // + add cell
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideoCategories){
            retValue = [ConsoleVideoCategoryTableViewCell getCellHeight] ;
        } else {
            retValue = 44 ; // TODO addCell getCellHeight
        }
    }
    return retValue ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil ;
    
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideoCategories){
            BOOL isLast = (indexPath.row == (numberOfVideoCategories-1)) ;
            VideoCategory *videoCategory = [[ConsoleUtil getConsoleContents] getVideoCategoryAt:indexPath.row] ;
            ConsoleVideoCategoryTableViewCell *videoCategoryCell = [[ConsoleVideoCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:videoCategory.name isLast:isLast] ;
            [VeamUtil registerTapAction:videoCategoryCell.deleteImageView target:self selector:@selector(didDeleteButtonTap:)] ;
            videoCategoryCell.deleteImageView.tag = indexPath.row ;
            cell = videoCategoryCell ;
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
                cell.textLabel.text = @"+ Add New Category" ;
            } else {
                cell.textLabel.text = @"" ;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15.5] ;
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
    //NSLog(@"delete %d",index) ;
    indexToBeDeleted = index ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Delete Category?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] ;
    //[alert setTag:ALERT_VIEW_TAG_REMOVE] ;
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    switch (buttonIndex) {
        case 0:
            // cancel
            break;
        case 1:
            // OK
            [[ConsoleUtil getConsoleContents] removeVideoCategoryAt:indexToBeDeleted] ;
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath") ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideoCategories){
            VideoCategory *category = [[ConsoleUtil getConsoleContents] getVideoCategoryAt:indexPath.row] ;
            if(category != nil){
                if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
                    ConsoleEditVideoCategoryViewController *editVideoCategoryViewController = [[ConsoleEditVideoCategoryViewController alloc] init] ;
                    [editVideoCategoryViewController setVideoCategory:category] ;
                    [self pushViewController:editVideoCategoryViewController] ;
                } else {
                    int count = [[ConsoleUtil getConsoleContents] getNumberOfVideoSubCategories:category.videoCategoryId] ;
                    if(count == 0){
                        ConsoleVideoViewController *videoViewController = [[ConsoleVideoViewController alloc] init] ;
                        [videoViewController setHeaderTitle:NSLocalizedString(@"exclusive_upload",nil)] ;
                        [videoViewController setNumberOfHeaderDots:3] ;
                        [videoViewController setSelectedHeaderDot:1] ;
                        [videoViewController setVideoCategory:category] ;
                        [videoViewController setVideoSubCategory:nil] ;
                        [videoViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                        [videoViewController setFooterImage:[UIImage imageNamed:@"tab_back.png"]] ;
                        [videoViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                        [self pushViewController:videoViewController] ;
                    } else {
                        ConsoleVideoSubCategoryViewController *videoSubCategoryViewController = [[ConsoleVideoSubCategoryViewController alloc] init] ;
                        [videoSubCategoryViewController setVideoCategory:category] ;
                        [videoSubCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                        [videoSubCategoryViewController setShowFooter:YES] ;
                        [videoSubCategoryViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
                        [self pushViewController:videoSubCategoryViewController] ;
                    }
                }
            }
        } else {
            if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
                //NSLog(@"Add") ;
                ConsoleEditVideoCategoryViewController *editVideoCategoryViewController = [[ConsoleEditVideoCategoryViewController alloc] init] ;
                [self pushViewController:editVideoCategoryViewController] ;
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
        VideoCategory *category = [[ConsoleUtil getConsoleContents] getVideoCategoryAt:indexPath.row] ;
        if(category != nil){
            ConsoleVideoSubCategoryViewController *videoSubCategoryViewController = [[ConsoleVideoSubCategoryViewController alloc] init] ;
            [videoSubCategoryViewController setVideoCategory:category] ;
            [videoSubCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
            [videoSubCategoryViewController setShowFooter:YES] ;
            [videoSubCategoryViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
            [self pushViewController:videoSubCategoryViewController] ;
        }
    } else if(indexPath.section == 2){
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            //NSLog(@"Add") ;
            ConsoleEditVideoCategoryViewController *editVideoCategoryViewController = [[ConsoleEditVideoCategoryViewController alloc] init] ;
            [self pushViewController:editVideoCategoryViewController] ;
        }
    }
}
 */

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"canMoveRowAtIndexPath row=%d",indexPath.row) ;
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideoCategories){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //NSLog(@"moveRowAtIndexPath") ;
    if(fromIndexPath.row != toIndexPath.row){
        [[ConsoleUtil getConsoleContents] moveVideoCategoryFrom:fromIndexPath.row to:toIndexPath.row] ;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //NSLog(@"targetIndexPathForMoveFromRowAtIndexPath") ;
    NSIndexPath *retValue = sourceIndexPath ;
    if (proposedDestinationIndexPath.section == 0) {
        if(proposedDestinationIndexPath.row < numberOfVideoCategories){
            retValue = proposedDestinationIndexPath ;
        } else {
            retValue = [NSIndexPath indexPathForRow:numberOfVideoCategories-1 inSection:sourceIndexPath.section] ;
        }
    }
    return retValue ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideoCategories){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[ConsoleUtil getConsoleContents] removeVideoCategoryAt:indexPath.row] ;
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
