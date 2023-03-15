//
//  ConsoleMixedViewController.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleMixedViewController.h"
#import "VeamUtil.h"
//#import "ConsoleEditMixedViewController.h"
#import "ConsoleEditRecipeViewController.h"

@interface ConsoleMixedViewController ()

@end

@implementation ConsoleMixedViewController

@synthesize mixedCategory ;
@synthesize mixedSubCategory ;

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

- (Mixed *)getMixedAt:(NSInteger)index
{
    Mixed *retValue = nil ;
    if(mixedSubCategory == nil){
        retValue = [[ConsoleUtil getConsoleContents] getMixedForCategory:mixedCategory.mixedCategoryId at:index order:NSOrderedAscending] ;
    } else {
        retValue = [[ConsoleUtil getConsoleContents] getMixedForSubCategory:mixedSubCategory.mixedSubCategoryId at:index] ;
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
        if(mixedSubCategory == nil){
            retValue = [[ConsoleUtil getConsoleContents] getNumberOfMixedsForCategory:mixedCategory.mixedCategoryId] ;
        } else {
            retValue = [[ConsoleUtil getConsoleContents] getNumberOfMixedsForSubCategory:mixedSubCategory.mixedSubCategoryId] ;
        }
    } else if(section == 2){
        // add category section
        retValue = 1 ;
    }
    
    //NSLog(@"%@::numberOfRowsInSection section=%d number=%d",NSStringFromClass([self class]),section,retValue) ;
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
        cell.textLabel.text = @"Content Settings" ;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0] ;
    } else if(indexPath.section == 1){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        if(cell.backgroundView == nil){
            cell.backgroundView = [[UIView alloc] init] ;
        }
        [cell.backgroundView setBackgroundColor:[VeamUtil getColorFromArgbString:@"4CE0E0E0"]] ;
        Mixed *mixed = [self getMixedAt:indexPath.row] ;
        cell.textLabel.text = mixed.title ;
        cell.textLabel.font = [UIFont systemFontOfSize:15.5] ;
    } else if(indexPath.section == 2){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
        cell.textLabel.text = @"+ Add New Content" ;
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
        Mixed *mixed = [self getMixedAt:indexPath.row] ;
        if(mixed != nil){
            NSString *kind = mixed.kind ;
            if([kind isEqualToString:@"1"]){ // recipe
                // Recipe
                Recipe *recipe = [[ConsoleUtil getConsoleContents] getRecipeForId:mixed.contentId] ;
                //NSLog(@"recipe %@",recipe.recipeId) ;
                ConsoleEditRecipeViewController *editRecipeViewController = [[ConsoleEditRecipeViewController alloc] init] ;
                [editRecipeViewController setMixedCategory:mixedCategory] ;
                [editRecipeViewController setMixedSubCategory:mixedSubCategory] ;
                [editRecipeViewController setMixed:mixed] ;
                [editRecipeViewController setRecipe:recipe] ;
                [self pushViewController:editRecipeViewController] ;
            } else {
                [VeamUtil dispMessage:@"Not Implemented Yet" title:@""] ;
            }
            /*
            ConsoleEditMixedViewController *editMixedViewController = [[ConsoleEditMixedViewController alloc] init] ;
            [editMixedViewController setMixed:mixed] ;
            [self pushViewController:editMixedViewController] ;
             */
        }
    } else if(indexPath.section == 2){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init] ;
        actionSheet.delegate = self ;
        actionSheet.title = @"Content" ;
        cancelIndex = 0 ;
        [actionSheet addButtonWithTitle:@"Recipe"] ; cancelIndex++ ;
        [actionSheet addButtonWithTitle:@"Mini-blog"] ; cancelIndex++ ;
        [actionSheet addButtonWithTitle:@"Picture"] ; cancelIndex++ ;
        [actionSheet addButtonWithTitle:@"Unlisted Youtube"] ; cancelIndex++ ;
        [actionSheet addButtonWithTitle:@"Video"] ; cancelIndex++ ;
        [actionSheet addButtonWithTitle:@"Audio"] ; cancelIndex++ ;
        [actionSheet addButtonWithTitle:@"Cancel"] ;
        actionSheet.cancelButtonIndex = cancelIndex ;
        [actionSheet showInView:self.view] ;

        /*
        //NSLog(@"Add Mixed c=%@",mixedCategory.mixedCategoryId) ;
        ConsoleEditMixedViewController *editMixedViewController = [[ConsoleEditMixedViewController alloc] init] ;
        [editMixedViewController setMixedCategory:mixedCategory] ;
        [editMixedViewController setMixedSubCategory:mixedSubCategory] ;
        [self pushViewController:editMixedViewController] ;
         */
    }
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < cancelIndex){
        switch (buttonIndex) {
            case 0:
            {
                // Recipe
                ConsoleEditRecipeViewController *editRecipeViewController = [[ConsoleEditRecipeViewController alloc] init] ;
                [editRecipeViewController setMixedCategory:mixedCategory] ;
                [editRecipeViewController setMixedSubCategory:mixedSubCategory] ;
                [self pushViewController:editRecipeViewController] ;
            }
                break;
            default:
                [VeamUtil dispMessage:@"Not Implemented Yet" title:@""] ;
                break;
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
        if(mixedSubCategory == nil){
            [[ConsoleUtil getConsoleContents] moveMixedForCategory:(NSString *)mixedCategory.mixedCategoryId from:fromIndexPath.row to:toIndexPath.row] ;
        } else {
            [[ConsoleUtil getConsoleContents] moveMixedForSubCategory:(NSString *)mixedSubCategory.mixedSubCategoryId from:fromIndexPath.row to:toIndexPath.row] ;
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
        if(mixedSubCategory == nil){
            [[ConsoleUtil getConsoleContents] removeMixedForCategory:(NSString *)mixedCategory.mixedCategoryId at:indexPath.row] ;
        } else {
            [[ConsoleUtil getConsoleContents] removeMixedForSubCategory:(NSString *)mixedSubCategory.mixedSubCategoryId at:indexPath.row] ;
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
