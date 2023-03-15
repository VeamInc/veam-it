//
//  ConsoleMixedForGridViewController.m
//  veam00000000
//
//  Created by veam on 1/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleMixedForGridViewController.h"
#import "VeamUtil.h"
#import "ConsoleMixedForGridTableViewCell.h"
#import "ConsoleMixedNotificationTableViewCell.h"
#import "ImageDownloader.h"
#import "ConsoleTutorialViewController.h"
#import "AppDelegate.h"
#import "ConsoleEditVideoForMixedViewController.h"
#import "ConsoleEditShootVideoForMixedViewController.h"
#import "ConsoleEditAudioViewController.h"
#import "ConsoleEditSubscriptionDescriptionViewController.h"
#import "ConsoleShootVideoViewController.h"
#import "VeamUtil.h"

#define ACTION_SHEET_SELECT_CONTENT_KIND    1
#define ACTION_SHEET_SELECT_PRICE           2

@interface ConsoleMixedForGridViewController ()

@end

@implementation ConsoleMixedForGridViewController

@synthesize mixedCategory ;
@synthesize mixedSubCategory ;
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
    
    NSInteger numberOfWaitingMixeds = [[ConsoleUtil getConsoleContents] getNumberOfWaitingMixedForCategory:@"0"] ;
    NSString *badgeString = @"" ;
    if(numberOfWaitingMixeds > 0){
        badgeString = [NSString stringWithFormat:@"%d",numberOfWaitingMixeds] ;
    }
    
    NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"NO",@"SELECTED",nil] ;
    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"YES",@"SELECTED",badgeString,@"BADGE",nil] ;
    NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Tutorial",@"TITLE", @"NO",@"SELECTED",nil] ;
    NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2,dictionary3, nil] ;
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

    /*
    prices = [NSArray arrayWithObjects:
              @"$0.99",
              @"$1.99",
              @"$2.99",
              @"$3.99",
              @"$4.99",
              @"$5.99",
              @"$6.99",
              @"$7.99",
              @"$8.99",
              @"$9.99",
              nil] ;
     */
    
    [[AppDelegate sharedInstance] setShotMovieUrl:nil] ;
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *priceKey = @"subscription_prices" ;
    if([ConsoleUtil isLocaleJapanese]){
        priceKey = @"subscription_prices_ja" ;
    }
    prices = [[contents getValueForKey:priceKey] componentsSeparatedByString:@"|"] ;

    
    needTimer = YES ;
    
    isAppReleased = NO ;
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary] ;
    
    CGFloat currentY = [self addNormalTableView] ;
    [normalTableView setDelegate:self] ;
    [normalTableView setDataSource:self] ;
    [normalTableView setContentInset:UIEdgeInsetsMake(44, 0, 100, 0)] ;
    
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

- (Mixed *)getMixedAt:(NSInteger)index
{
    Mixed *retValue = nil ;
    //retValue = [[ConsoleUtil getConsoleContents] getMixedForCategory:@"0" at:index order:NSOrderedDescending] ;
    retValue = [[ConsoleUtil getConsoleContents] getMixedForCategory:@"0" at:index order:NSOrderedAscending] ;
    return retValue ;
}

- (void)removeMixedAt:(NSInteger)index
{
    [[ConsoleUtil getConsoleContents] removeMixedForCategory:@"0" at:index] ;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // this will not be called because of HPReorderTableView
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
        numberOfMixeds = [[ConsoleUtil getConsoleContents] getNumberOfMixedsForCategory:@"0"] ;
        if([self isAppReleased]){
            retValue = [self numberOfAllMixeds] ; //
        } else {
            retValue = [self numberOfAllMixeds] + 3 ; // + comment cell
        }
    }
    
    //NSLog(@"numberOfRowsInSection section=%d number=%d",section,retValue) ;
    return retValue ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat retValue = 0 ;
    if(section == 1){
        retValue = 44.0 ;
    }
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
    if(indexPath.row < [self numberOfAllMixeds]){
        retValue = [ConsoleMixedForGridTableViewCell getCellHeight] ;
    } else {
        retValue = 44 ; // TODO addCell getCellHeight
    }

    return retValue ;
}

- (NSInteger)numberOfAllMixeds
{
    NSInteger retValue = numberOfMixeds ;
    if(isAppReleased){
        retValue++ ;
    }
    return retValue ;
}

- (NSInteger)getMixedIndexFor:(NSInteger)row
{
    NSInteger retValue = -1 ;
    if(isAppReleased){
        if(row == 0){
            retValue = -1 ;
        } else {
            retValue = row - 1 ;
        }
    } else {
        retValue = row ;
    }
    return retValue ;
}

- (Mixed *)getMixedFor:(NSIndexPath *)indexPath
{
    Mixed *retValue = nil ;
    if(isAppReleased){
        if(indexPath.row == 0){
            double uploadTime = [[ConsoleUtil getConsoleContents] getNextUploadTime] ;
            NSString *deadlineString = [VeamUtil getMessageDateString:[NSString stringWithFormat:@"%f",uploadTime]] ;
            retValue = [[Mixed alloc] init] ;
            [retValue setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO] ;
            [retValue setTitle:@"Title"] ;
            [retValue setStatus:@"1"] ;
            [retValue setStatusText:@"Deadline"] ;
            [retValue setDeadlineString:deadlineString] ;
        } else {
            NSInteger index = indexPath.row - 1 ;
            retValue = [self getMixedAt:index] ;
        }
    } else {
        retValue = [self getMixedAt:indexPath.row] ;
    }
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@::cellForRowAtIndexPath section=%d row=%d",NSStringFromClass([self class]),indexPath.section,indexPath.row) ;
    
    UITableViewCell *cell = nil ;
    if(indexPath.row < [self numberOfAllMixeds]){
        BOOL isLast = (indexPath.row == ([self numberOfAllMixeds]-1)) ;
        Mixed *mixed = [self getMixedFor:indexPath] ;
        ConsoleMixedForGridTableViewCell *mixedCell = [[ConsoleMixedForGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" mixed:mixed isLast:isLast] ;
        if(0 <= [self getMixedIndexFor:indexPath.row]){
            [VeamUtil registerTapAction:mixedCell.deleteTapView target:self selector:@selector(didDeleteButtonTap:)] ;
        }
        mixedCell.deleteImageView.tag = indexPath.row ;
        
        NSString *thumbnailUrl = [mixed thumbnailUrl] ;
        //NSLog(@"mixed thumbnailUrl=%@",mixed.thumbnailUrl) ;
        if(![VeamUtil isEmpty:thumbnailUrl]){
            UIImage *image = [VeamUtil getCachedImage:thumbnailUrl downloadIfNot:NO] ;
            if(image == nil){
                [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
            } else {
                [[mixedCell thumbnailImageView] setImage:image] ;
            }
        }
        mixedCell.deleteTapView.tag = indexPath.row ;
        
        [mixedCell setSelectionStyle:UITableViewCellEditingStyleNone] ;
        cell = mixedCell ;
    } else {
        NSInteger index = indexPath.row - [self numberOfAllMixeds] ;
        if(index == 0){
            // Hel light 24p
            UITableViewCell *titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"a"];
            titleCell.textLabel.text = @" ";
            titleCell.detailTextLabel.text = NSLocalizedString(@"subscription_information",nil);
            [titleCell.detailTextLabel setTextColor:[UIColor blackColor]] ;
            [titleCell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
            
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [VeamUtil getScreenWidth], 0.5)] ;
            separatorView.backgroundColor = [UIColor blackColor] ;
            [titleCell.contentView addSubview:separatorView] ;

            cell = titleCell ;
        } else if(index == 1){
            
            UITableViewCell *descriptionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"description"] ;
            [descriptionCell.textLabel setTextColor:[UIColor redColor]] ;
            [descriptionCell.textLabel setText:NSLocalizedString(@"description_before_purchasing",nil)] ;
            [descriptionCell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
            [descriptionCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator] ;

            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 44, [VeamUtil getScreenWidth], 0.5)] ;
            separatorView.backgroundColor = [UIColor blackColor] ;
            [descriptionCell.contentView addSubview:separatorView] ;

            cell = descriptionCell ;
        } else if(index == 2){
            UITableViewCell *priceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"price"] ;
            [priceCell.textLabel setTextColor:[UIColor blackColor]] ;
            [priceCell.textLabel setText:NSLocalizedString(@"set_the_price_monthly",nil)] ;
            [priceCell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
            [priceCell.detailTextLabel setTextColor:[UIColor redColor]] ;
            [priceCell.detailTextLabel setText:[ConsoleUtil getConsoleContents].templateSubscription.price] ;
            [priceCell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;

            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [VeamUtil getScreenWidth], 0.5)] ;
            separatorView.backgroundColor = [UIColor blackColor] ;
            [priceCell.contentView addSubview:separatorView] ;

            cell = priceCell ;
        }
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
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
    indexToBeDeleted = [self getMixedIndexFor:index] ;
    if(indexToBeDeleted >= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] ;
        //[alert setTag:ALERT_VIEW_TAG_REMOVE] ;
        [alert show];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    switch (buttonIndex) {
        case 0:
            // cancel
            break;
        case 1:
            // OK
            [self removeMixedAt:indexToBeDeleted] ;
            break;
    }
}

- (BOOL)isAppReleased
{
    return [[ConsoleUtil getConsoleContents] isAppReleased] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath") ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.section == 0){
        //NSLog(@"row=%d",indexPath.row) ;
        if(indexPath.row < [self numberOfAllMixeds]){
            if([self isAppReleased]){
                if(indexPath.row == 0){
                    // リリース後は Deadline  のところだけ押せる
                    currentMixed = [self getMixedFor:indexPath] ;
                    
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:NSLocalizedString(@"upload",nil)
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:nil] ;
                    
                    [actionSheet addButtonWithTitle:@"Audio"] ;
                    [actionSheet addButtonWithTitle:@"Video"] ;
                    [actionSheet addButtonWithTitle:NSLocalizedString(@"shoot_a_video", nil)] ;
                    [actionSheet addButtonWithTitle:@"Cancel"] ;
                    [actionSheet setCancelButtonIndex:3] ;
                    [actionSheet setTag:ACTION_SHEET_SELECT_CONTENT_KIND] ;
                    
                    // アクションシートの表示
                    [actionSheet showInView:self.view] ;
                }
            } else {
                currentMixed = [self getMixedFor:indexPath] ;

                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:NSLocalizedString(@"upload",nil)
                                              delegate:self
                                              cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:nil] ;
                
                [actionSheet addButtonWithTitle:@"Audio"] ;
                [actionSheet addButtonWithTitle:@"Video"] ;
                [actionSheet addButtonWithTitle:NSLocalizedString(@"shoot_a_video", nil)] ;
                [actionSheet addButtonWithTitle:@"Cancel"] ;
                [actionSheet setCancelButtonIndex:3] ;
                [actionSheet setTag:ACTION_SHEET_SELECT_CONTENT_KIND] ;
                
                // アクションシートの表示
                [actionSheet showInView:self.view] ;
            }
        } else {
            if(![self isAppReleased]){
                NSInteger index = indexPath.row - [self numberOfAllMixeds] ;
                if(index == 1){
                    // edit description
                    //NSLog(@"edit description") ;
                    ConsoleEditSubscriptionDescriptionViewController *viewController = [[ConsoleEditSubscriptionDescriptionViewController alloc] init] ;
                    [self pushViewController:viewController] ;

                } else if(index == 2){
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
    if(tag == ACTION_SHEET_SELECT_CONTENT_KIND){
        BOOL isFixed = YES ;
        if([currentMixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO] ||
           [currentMixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO] ){
            isFixed = NO ;
        }
        
        switch (buttonIndex) {
            case 0:
            {
                // Audio
                //NSLog(@"Audio") ;
                ConsoleEditAudioViewController *editAudioViewController = [[ConsoleEditAudioViewController alloc] init] ;
                //[editAudioViewController setAudio:video] ;
                if(isFixed){
                    [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO] ;
                } else {
                    [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO] ;
                }
                [editAudioViewController setMixed:currentMixed] ;
                [editAudioViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
                [self pushViewController:editAudioViewController] ;
            }
                break;
            case 1:
            {
                // Audio
                //NSLog(@"Video") ;
                ConsoleEditVideoForMixedViewController *editVideoViewController = [[ConsoleEditVideoForMixedViewController alloc] init] ;
                //[editVideoViewController setVideo:video] ;
                if(isFixed){
                    [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ;
                } else {
                    [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO] ;
                }
                [editVideoViewController setMixed:currentMixed] ;
                [editVideoViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
                [self pushViewController:editVideoViewController] ;
            }
                break;
            case 2:
            {
                //NSLog(@"Shoot a Video") ;
                
                [[AppDelegate sharedInstance] showVideoCameraView] ;

                /*
                ConsoleShootVideoViewController *shootVideoViewController = [[ConsoleShootVideoViewController alloc] init] ;
                [self pushViewController:shootVideoViewController] ;
                */
                
                /*
                ConsoleEditVideoForMixedViewController *editVideoViewController = [[ConsoleEditVideoForMixedViewController alloc] init] ;
                if(isFixed){
                    [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ;
                } else {
                    [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO] ;
                }
                [editVideoViewController setMixed:currentMixed] ;
                [editVideoViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
                [self pushViewController:editVideoViewController] ;
                 */
            }
                break;
                
            default:
                break;
        }
    } else if(tag == ACTION_SHEET_SELECT_PRICE){
        if(buttonIndex < [prices count]){
            NSString *priceString = [prices objectAtIndex:buttonIndex] ;
            //NSLog(@"price = %@",priceString) ;
            [[ConsoleUtil getConsoleContents] setTemplateSubscriptionPrice:priceString] ;
        }
    }
}

/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO ; //
    
    //NSLog(@"canMoveRowAtIndexPath row=%d",indexPath.row) ;
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < [self numberOfAllMixeds]){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    if(fromIndexPath.row != toIndexPath.row){
        [[ConsoleUtil getConsoleContents] moveMixedForCategory:@"0" from:fromIndexPath.row to:toIndexPath.row] ;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *retValue = sourceIndexPath ;
    if (proposedDestinationIndexPath.section == 0) {
        if(proposedDestinationIndexPath.row < [self numberOfAllMixeds]){
            retValue = proposedDestinationIndexPath ;
        } else {
            retValue = [NSIndexPath indexPathForRow:[self numberOfAllMixeds]-1 inSection:sourceIndexPath.section] ;
        }
    }
    return retValue ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL retValue = NO ;
    if(indexPath.section == 0){
        if(indexPath.row < [self numberOfAllMixeds]){
            retValue = YES ;
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[ConsoleUtil getConsoleContents] removeMixedForCategory:@"0" at:indexPath.row] ;
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade] ;
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
}
*/
- (void)reloadValues
{
    [normalTableView reloadData] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload %@",url) ;
    if(![VeamUtil isEmpty:url]){
        NSMutableDictionary *imageDownloadsInProgress ;
        switch (imageIndex) {
            case 1:
                imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
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
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        //ConsoleMixedForGridTableViewCell *cell = (ConsoleMixedForGridTableViewCell *)[tableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView] ;
        ConsoleMixedForGridTableViewCell *cell = (ConsoleMixedForGridTableViewCell *)[normalTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView] ;
        
        
        //NSLog(@"%d width %f",indexPath.row,imageDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.thumbnailImageView.image = imageDownloader.pictureImage ;
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
    
    ConsoleTutorialViewController *viewController = [[ConsoleTutorialViewController alloc] init] ;
    
    if([[ConsoleUtil getConsoleContents].appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_RELEASED]){
        [viewController setTutorialKind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED] ;
    } else {
        [viewController setTutorialKind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE] ;
    }
    [viewController setHideHeaderBottomLine:NO] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:NSLocalizedString(@"exclusive_tutorial", nil)] ;
    [viewController setNumberOfHeaderDots:3] ;
    [viewController setSelectedHeaderDot:2] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [self pushViewController:viewController] ;
    
}

- (void)unsetUpdateTimer
{
    if(updateTimer != nil){
        //NSLog(@"updateTimer invalidate") ;
        [updateTimer invalidate] ;
        updateTimer = nil ;
        
    }
}

- (void)launchEditShootVideo
{
    //NSLog(@"%@::launchEditShootVideo",NSStringFromClass([self class])) ;
    ConsoleEditShootVideoForMixedViewController *editVideoViewController = [[ConsoleEditShootVideoForMixedViewController alloc] init] ;
    //[editVideoViewController setVideo:video] ;
    BOOL isFixed = YES ;
    if([currentMixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO] ||
       [currentMixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO] ){
        isFixed = NO ;
    }
    if(isFixed){
        [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ;
    } else {
        [currentMixed setKind:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO] ;
    }
    [editVideoViewController setMixed:currentMixed] ;
    [editVideoViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
    NSURL *shotMovieUrl = [[AppDelegate sharedInstance] shotMovieUrl] ;
    [[AppDelegate sharedInstance] setShotMovieUrl:nil] ;
    [editVideoViewController setShootVideoUrl:shotMovieUrl] ;
    [self pushViewController:editVideoViewController] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@::viewWillAppear",NSStringFromClass([self class])) ;
    [super viewWillAppear:animated] ;
    
    NSURL *shotMovieUrl = [[AppDelegate sharedInstance] shotMovieUrl] ;
    if(shotMovieUrl != nil){
        [self performSelectorOnMainThread:@selector(launchEditShootVideo) withObject:nil waitUntilDone:NO] ;
    } else {
        [[ConsoleUtil getConsoleContents] updatePreparingMixedStatus:@"0"] ;
        
        [self unsetUpdateTimer] ;
        if(needTimer){
            //NSLog(@"updateTimer scheduledTimerWithTimeInterval") ;
            updateTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(handleUpdateTimer:) userInfo:nil repeats:YES] ;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"%@::viewWillDisappear",NSStringFromClass([self class])) ;
    [super viewWillDisappear:animated] ;
    [self unsetUpdateTimer] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"%@::viewDidDisappear",NSStringFromClass([self class])) ;
    [super viewDidDisappear:animated] ;
    [self unsetUpdateTimer] ;
}

-(void)handleUpdateTimer:(NSTimer*)timer
{
    //NSLog(@"%@::handleUpdateTimer",NSStringFromClass([self class])) ;
    if([[AppDelegate sharedInstance] isShowingPreview]){
        [self unsetUpdateTimer] ;
    } else {
        [[ConsoleUtil getConsoleContents] updatePreparingMixedStatus:@"0"] ;
    }
}

- (void)didTapBack
{
    needTimer = NO ;
    [self unsetUpdateTimer] ;
    [super didTapBack] ;
}

-(void)dealloc
{
    //NSLog(@"%@::dealloc",NSStringFromClass([self class])) ;
}


@end
