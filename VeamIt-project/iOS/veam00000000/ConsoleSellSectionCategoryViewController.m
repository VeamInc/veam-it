//
//  ConsoleSellSectionCategoryViewController.m
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleSellSectionCategoryViewController.h"
#import "VeamUtil.h"
#import "ConsoleWebTableViewCell.h"
#import "ConsoleAddTableViewCell.h"
#import "ConsoleTutorialViewController.h"
#import "ConsoleEditSellSectionCategoryViewController.h"
#import "ConsoleEditSectionDescriptionViewController.h"
#import "ConsoleEditSectionPaymentDescriptionViewController.h"

#define ACTION_SHEET_SELECT_PRICE           2

@interface ConsoleSellSectionCategoryViewController ()

@end

@implementation ConsoleSellSectionCategoryViewController

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
    NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,nil] ;
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
    
    isAppReleased = NO ;
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *priceKey = @"subscription_prices" ;
    if([ConsoleUtil isLocaleJapanese]){
        priceKey = @"subscription_prices_ja" ;
    }
    prices = [[contents getValueForKey:priceKey] componentsSeparatedByString:@"|"] ;
   
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
    //NSLog(@"numberOfSectionsInTableView") ;
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 0 ;
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *appStatus = contents.appInfo.status ;
    //NSLog(@"appStatus=%@",appStatus) ;
    if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_RELEASED]){
        isAppReleased = YES ;
    }

    if(section == 0){
        numberOfSellSectionCategories = [[ConsoleUtil getConsoleContents] getNumberOfSellSectionCategories] ;
        retValue = numberOfSellSectionCategories + 1 ; // + add cell
        if(!isAppReleased){
            retValue += 4 ; // + comment cell
        }
    }
    
    //NSLog(@"numberOfRowsInSection section=%d number=%d",section,retValue) ;
    return retValue ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfSellSectionCategories){
            retValue = [ConsoleWebTableViewCell getCellHeight] ;
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
        if(indexPath.row < numberOfSellSectionCategories){
            BOOL isLast = (indexPath.row == (numberOfSellSectionCategories-1)) ;
            SellSectionCategory *sellSectionCategory = [[ConsoleUtil getConsoleContents] getSellSectionCategoryAt:indexPath.row] ;
            NSString *title = [[ConsoleUtil getConsoleContents] getCategoryTitleForSellSectionCategory:sellSectionCategory] ;
            ConsoleWebTableViewCell *webCell = [[ConsoleWebTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:title isLast:isLast] ;
            [VeamUtil registerTapAction:webCell.deleteTapView target:self selector:@selector(didDeleteButtonTap:)] ;
            webCell.deleteTapView.tag = indexPath.row ;
            cell = webCell ;
        } else {
            NSInteger index = indexPath.row - numberOfSellSectionCategories ;
            if(index == 0){
                ConsoleAddTableViewCell *addCell = [[ConsoleAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:NSLocalizedString(@"add_new_category",nil) isLast:YES] ;
                cell = addCell ;
            } else if(index == 1){
                // Hel light 24p
                UITableViewCell *titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"a"];
                titleCell.textLabel.text = @" ";
                titleCell.detailTextLabel.text = NSLocalizedString(@"section_information",nil);
                [titleCell.detailTextLabel setTextColor:[UIColor blackColor]] ;
                [titleCell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
                
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [VeamUtil getScreenWidth], 0.5)] ;
                separatorView.backgroundColor = [UIColor blackColor] ;
                [titleCell.contentView addSubview:separatorView] ;
                
                cell = titleCell ;
            } else if(index == 2){
                
                UITableViewCell *descriptionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"description"] ;
                [descriptionCell.textLabel setTextColor:[UIColor redColor]] ;
                [descriptionCell.textLabel setText:NSLocalizedString(@"description_of_this_section",nil)] ;
                [descriptionCell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
                [descriptionCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator] ;
                
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 44, [VeamUtil getScreenWidth], 0.5)] ;
                separatorView.backgroundColor = [UIColor blackColor] ;
                [descriptionCell.contentView addSubview:separatorView] ;
                
                cell = descriptionCell ;
            } else if(index == 3){
                
                UITableViewCell *descriptionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paymentdescription"] ;
                [descriptionCell.textLabel setTextColor:[UIColor redColor]] ;
                [descriptionCell.textLabel setText:NSLocalizedString(@"description_before_purchasing",nil)] ;
                [descriptionCell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
                [descriptionCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator] ;
                
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 44, [VeamUtil getScreenWidth], 0.5)] ;
                separatorView.backgroundColor = [UIColor blackColor] ;
                [descriptionCell.contentView addSubview:separatorView] ;
                
                cell = descriptionCell ;
            } else if(index == 4){
                //NSLog(@"price=%@",[ConsoleUtil getConsoleContents].templateSubscription.price) ;
                UITableViewCell *priceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"price"] ;
                [priceCell.textLabel setTextColor:[UIColor blackColor]] ;
                [priceCell.textLabel setText:NSLocalizedString(@"set_the_price",nil)] ;
                [priceCell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
                /*
                [priceCell.detailTextLabel setTextColor:[UIColor redColor]] ;
                [priceCell.detailTextLabel setText:[ConsoleUtil getConsoleContents].templateSubscription.price] ;
                [priceCell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
                 */
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, priceCell.frame.size.height)] ;
                [priceLabel setTextColor:[UIColor redColor]] ;
                [priceLabel setText:[ConsoleUtil getConsoleContents].templateSubscription.price] ;
                [priceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
                [priceLabel setTextAlignment:NSTextAlignmentRight] ;
                [priceCell addSubview:priceLabel] ;
                
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [VeamUtil getScreenWidth], 0.5)] ;
                separatorView.backgroundColor = [UIColor blackColor] ;
                [priceCell.contentView addSubview:separatorView] ;
                
                cell = priceCell ;
            }
            [cell setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
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
            [[ConsoleUtil getConsoleContents] removeSellSectionCategoryAt:indexToBeDeleted] ;
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.section == 0){
        if(indexPath.row < numberOfSellSectionCategories){
            SellSectionCategory *sellSectionCategory = [[ConsoleUtil getConsoleContents] getSellSectionCategoryAt:indexPath.row] ;
            if(sellSectionCategory != nil){
                ConsoleEditSellSectionCategoryViewController *editSellSectionCategoryViewController = [[ConsoleEditSellSectionCategoryViewController alloc] init] ;
                [editSellSectionCategoryViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
                [editSellSectionCategoryViewController setSellSectionCategory:sellSectionCategory] ;
                [self pushViewController:editSellSectionCategoryViewController] ;
            }
        } else if(indexPath.row == numberOfSellSectionCategories) {
            //NSLog(@"Add") ;
            ConsoleEditSellSectionCategoryViewController *editSellSectionCategoryViewController = [[ConsoleEditSellSectionCategoryViewController alloc] init] ;
            [editSellSectionCategoryViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
            [self pushViewController:editSellSectionCategoryViewController] ;
        } else {
            if(!isAppReleased){
                NSInteger index = indexPath.row - numberOfSellSectionCategories ;
                if(index == 2){
                    // edit section description
                    //NSLog(@"edit section description") ;
                    ConsoleEditSectionDescriptionViewController *viewController = [[ConsoleEditSectionDescriptionViewController alloc] init] ;
                    [self pushViewController:viewController] ;
                    
                } else if(index == 3){
                    // edit section payment description
                    //NSLog(@"edit section payment description") ;
                    ConsoleEditSectionPaymentDescriptionViewController *viewController = [[ConsoleEditSectionPaymentDescriptionViewController alloc] init] ;
                    [self pushViewController:viewController] ;
                    
                } else if(index == 4){
                    // edit price
                    //NSLog(@"edit price") ;
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:NSLocalizedString(@"price",nil)
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:nil] ;
                    
                    for(int priceIndex = 0 ; priceIndex < [prices count] ; priceIndex++){
                        NSString *priceString = [prices objectAtIndex:priceIndex] ;
                        [actionSheet addButtonWithTitle:priceString] ;
                    }
                    [actionSheet addButtonWithTitle:@"Cancel"] ;
                    [actionSheet setCancelButtonIndex:[prices count]] ;
                    [actionSheet setTag:ACTION_SHEET_SELECT_PRICE] ;
                    
                    // アクションシートの表示
                    [actionSheet showInView:self.view] ;
                }
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSInteger tag = actionSheet.tag ;
    if(tag == ACTION_SHEET_SELECT_PRICE){
        if(buttonIndex < [prices count]){
            NSString *priceString = [prices objectAtIndex:buttonIndex] ;
            //NSLog(@"price = %@",priceString) ;
            [[ConsoleUtil getConsoleContents] setTemplateSubscriptionPrice:priceString] ;
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"canMoveRowAtIndexPath row=%d",indexPath.row) ;
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfSellSectionCategories){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //NSLog(@"moveRowAtIndexPath") ;
    if(fromIndexPath.row != toIndexPath.row){
        [[ConsoleUtil getConsoleContents] moveSellSectionCategoryFrom:fromIndexPath.row to:toIndexPath.row] ;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //NSLog(@"targetIndexPathForMoveFromRowAtIndexPath") ;
    NSIndexPath *retValue = sourceIndexPath ;
    if (proposedDestinationIndexPath.section == 0) {
        if(proposedDestinationIndexPath.row < numberOfSellSectionCategories){
            retValue = proposedDestinationIndexPath ;
        } else {
            retValue = [NSIndexPath indexPathForRow:numberOfSellSectionCategories-1 inSection:sourceIndexPath.section] ;
        }
    }
    return retValue ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfSellSectionCategories){
            retValue = YES ;
        }
    }
    return retValue ;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[ConsoleUtil getConsoleContents] removeSellSectionCategoryAt:indexPath.row] ;
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade] ;
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
}

- (void)tableView:(UITableView *)tableView didEndReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didEndReorderingRowAtIndexPath row=%d",indexPath.row) ;
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

/*
 - (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
 {
 //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
 
 ConsoleTutorialViewController *viewController = [[ConsoleTutorialViewController alloc] init] ;
 
 [viewController setTutorialKind:VEAM_CONSOLE_TUTORIAL_KIND_LINK] ;
 [viewController setHideHeaderBottomLine:NO] ;
 [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
 [viewController setHeaderTitle:NSLocalizedString(@"links_tutorial", nil)] ;
 [viewController setNumberOfHeaderDots:3] ;
 [viewController setSelectedHeaderDot:2] ;
 [viewController setShowFooter:NO] ;
 [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
 
 [self pushViewController:viewController] ;
 
 }
 */

@end