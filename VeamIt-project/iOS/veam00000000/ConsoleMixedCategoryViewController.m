//
//  ConsoleMixedCategoryViewController.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleMixedCategoryViewController.h"
#import "ConsoleEditMixedCategoryViewController.h"
#import "ConsoleMixedSubCategoryViewController.h"
#import "ConsoleMixedViewController.h"
#import "VeamUtil.h"

@interface ConsoleMixedCategoryViewController ()

@end

@implementation ConsoleMixedCategoryViewController

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
        retValue = [[ConsoleUtil getConsoleContents] getNumberOfMixedCategories] ;
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
            cell.textLabel.text = @"Category Settings" ;
        } else {
            cell.textLabel.text = @"Category List" ;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14.0] ;
    } else if(indexPath.section == 1){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton] ;
            [cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton] ;
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator] ;
        }
        if(cell.backgroundView == nil){
            cell.backgroundView = [[UIView alloc] init] ;
        }
        [cell.backgroundView setBackgroundColor:[VeamUtil getColorFromArgbString:@"4CE0E0E0"]] ;
        MixedCategory *mixedCategory = [[ConsoleUtil getConsoleContents] getMixedCategoryAt:indexPath.row] ;
        cell.textLabel.text = mixedCategory.name ;
        cell.textLabel.font = [UIFont systemFontOfSize:15.5] ;
    } else if(indexPath.section == 2){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            cell.textLabel.text = @"+ Add New Category" ;
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
        MixedCategory *category = [[ConsoleUtil getConsoleContents] getMixedCategoryAt:indexPath.row] ;
        if(category != nil){
            if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
                ConsoleEditMixedCategoryViewController *editMixedCategoryViewController = [[ConsoleEditMixedCategoryViewController alloc] init] ;
                [editMixedCategoryViewController setMixedCategory:category] ;
                [self pushViewController:editMixedCategoryViewController] ;
            } else {
                int count = [[ConsoleUtil getConsoleContents] getNumberOfMixedSubCategories:category.mixedCategoryId] ;
                if(count == 0){
                    ConsoleMixedViewController *mixedViewController = [[ConsoleMixedViewController alloc] init] ;
                    [mixedViewController setMixedCategory:category] ;
                    [mixedViewController setMixedSubCategory:nil] ;
                    [mixedViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [mixedViewController setShowFooter:YES] ;
                    [mixedViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
                    [self pushViewController:mixedViewController] ;
                } else {
                    ConsoleMixedSubCategoryViewController *mixedSubCategoryViewController = [[ConsoleMixedSubCategoryViewController alloc] init] ;
                    [mixedSubCategoryViewController setMixedCategory:category] ;
                    [mixedSubCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [mixedSubCategoryViewController setShowFooter:YES] ;
                    [mixedSubCategoryViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
                    [self pushViewController:mixedSubCategoryViewController] ;
                }
            }
        }
    } else if(indexPath.section == 2){
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            //NSLog(@"Add") ;
            ConsoleEditMixedCategoryViewController *editMixedCategoryViewController = [[ConsoleEditMixedCategoryViewController alloc] init] ;
            [self pushViewController:editMixedCategoryViewController] ;
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"accessoryButtonTappedForRowWithIndexPath") ;
    if(indexPath.section == 0){
        // nothing to do
    } else if(indexPath.section == 1){
        MixedCategory *category = [[ConsoleUtil getConsoleContents] getMixedCategoryAt:indexPath.row] ;
        if(category != nil){
            ConsoleMixedSubCategoryViewController *mixedSubCategoryViewController = [[ConsoleMixedSubCategoryViewController alloc] init] ;
            [mixedSubCategoryViewController setMixedCategory:category] ;
            [mixedSubCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
            [mixedSubCategoryViewController setShowFooter:YES] ;
            [mixedSubCategoryViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
            [self pushViewController:mixedSubCategoryViewController] ;
        }
    } else if(indexPath.section == 2){
        if(self.contentMode == VEAM_CONSOLE_SETTING_MODE){
            //NSLog(@"Add") ;
            ConsoleEditMixedCategoryViewController *editMixedCategoryViewController = [[ConsoleEditMixedCategoryViewController alloc] init] ;
            [self pushViewController:editMixedCategoryViewController] ;
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
        [[ConsoleUtil getConsoleContents] moveMixedCategoryFrom:fromIndexPath.row to:toIndexPath.row] ;
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
        [[ConsoleUtil getConsoleContents] removeMixedCategoryAt:indexPath.row] ;
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
