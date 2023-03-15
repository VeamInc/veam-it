//
//  ConsoleYoutubeViewController.m
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleYoutubeViewController.h"
#import "VeamUtil.h"
#import "ConsoleEditYoutubeViewController.h"

@interface ConsoleYoutubeViewController ()

@end

@implementation ConsoleYoutubeViewController

@synthesize youtubeCategory ;
@synthesize youtubeSubCategory ;

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

- (Youtube *)getYoutubeAt:(NSInteger)index
{
    Youtube *retValue = nil ;
    if(youtubeSubCategory == nil){
        retValue = [[ConsoleUtil getConsoleContents] getYoutubeForCategory:youtubeCategory.youtubeCategoryId at:index] ;
    } else {
        retValue = [[ConsoleUtil getConsoleContents] getYoutubeForSubCategory:youtubeSubCategory.youtubeSubCategoryId at:index] ;
    }
    return retValue ;
}


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
        if(youtubeSubCategory == nil){
            retValue = [[ConsoleUtil getConsoleContents] getNumberOfYoutubesForCategory:youtubeCategory.youtubeCategoryId] ;
        } else {
            retValue = [[ConsoleUtil getConsoleContents] getNumberOfYoutubesForSubCategory:youtubeSubCategory.youtubeSubCategoryId] ;
        }
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
        cell.textLabel.text = @"YouTube Video Settings" ;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0] ;
    } else if(indexPath.section == 1){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        if(cell.backgroundView == nil){
            cell.backgroundView = [[UIView alloc] init] ;
        }
        [cell.backgroundView setBackgroundColor:[VeamUtil getColorFromArgbString:@"4CE0E0E0"]] ;
        Youtube *youtube = [self getYoutubeAt:indexPath.row] ;
        cell.textLabel.text = youtube.title ;
        cell.textLabel.font = [UIFont systemFontOfSize:15.5] ;
    } else if(indexPath.section == 2){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        cell.textLabel.text = @"+ Add New YouTube Video" ;
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
        Youtube *youtube = [self getYoutubeAt:indexPath.row] ;
        if(youtube != nil){
            ConsoleEditYoutubeViewController *editYoutubeViewController = [[ConsoleEditYoutubeViewController alloc] init] ;
            [editYoutubeViewController setYoutube:youtube] ;
            [self pushViewController:editYoutubeViewController] ;
        }
    } else if(indexPath.section == 2){
        //NSLog(@"Add Youtube c=%@",youtubeCategory.youtubeCategoryId) ;
        ConsoleEditYoutubeViewController *editYoutubeViewController = [[ConsoleEditYoutubeViewController alloc] init] ;
        [editYoutubeViewController setYoutubeCategory:youtubeCategory] ;
        [editYoutubeViewController setYoutubeSubCategory:youtubeSubCategory] ;
        [self pushViewController:editYoutubeViewController] ;
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
        if(youtubeSubCategory == nil){
            [[ConsoleUtil getConsoleContents] moveYoutubeForCategory:(NSString *)youtubeCategory.youtubeCategoryId from:fromIndexPath.row to:toIndexPath.row] ;
        } else {
            [[ConsoleUtil getConsoleContents] moveYoutubeForSubCategory:(NSString *)youtubeSubCategory.youtubeSubCategoryId from:fromIndexPath.row to:toIndexPath.row] ;
        }
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
        if(youtubeSubCategory == nil){
            [[ConsoleUtil getConsoleContents] removeYoutubeForCategory:(NSString *)youtubeCategory.youtubeCategoryId at:indexPath.row] ;
        } else {
            [[ConsoleUtil getConsoleContents] removeYoutubeForSubCategory:(NSString *)youtubeSubCategory.youtubeSubCategoryId at:indexPath.row] ;
        }
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
