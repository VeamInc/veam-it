//
//  CalendarMenuViewController.m
//  veam31000015
//
//  Created by veam on 9/13/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "CalendarMenuViewController.h"
#import "VeamUtil.h"
#import "DualImageCellViewController.h"
#import "BasicCellViewController.h"
#import "CalendarViewController.h"
#import "CalendarData.h"
#import "SubscriptionPurchaseViewController.h"
#import "MixedViewController.h"

@interface CalendarMenuViewController ()

@end

@implementation CalendarMenuViewController

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
    
    [self setViewName:@"CalendarMenu"] ;
    
    categoryListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [categoryListTableView setDelegate:self] ;
    [categoryListTableView setDataSource:self] ;
    [categoryListTableView setBackgroundColor:[UIColor clearColor]] ;
    [categoryListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [categoryListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:categoryListTableView] ;
    
    [self addTopBar:NO showSettingsButton:YES] ;
    
    [self performSelectorInBackground:@selector(preloadCalendarData) withObject:nil] ;

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
    lastIndex = indexOffset + 2 ; // number of menus
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == 1){
        retValue = 160.0 ; // dual image cell height
    } else if(indexPath.row == lastIndex){
        //retValue = [VeamUtil getTabBarHeight] ;
        retValue = 49.0 ; // タブが表示されていないときに更新されると0になってしまうので固定
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
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
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else if(indexPath.row == 1){
        // image
        DualImageCell *dualImageCell = [tableView dequeueReusableCellWithIdentifier:@"Image"] ;
        if (dualImageCell == nil) {
            DualImageCellViewController *controller = [[DualImageCellViewController alloc] initWithNibName:@"DualImageCell" bundle:nil] ;
            dualImageCell = (DualImageCell *)controller.view ;
        }

        UIColor *topLeftColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_EXCLUSIVE_TOP_LEFT_COLOR default:@"FF777777"]] ;
        UIColor *topLeftTextColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_EXCLUSIVE_TOP_LEFT_TEXT_COLOR default:@"FF000000"]] ;
        

        [dualImageCell.leftImageView setHidden:YES] ;
        [dualImageCell.leftBackView setHidden:NO] ;
        [dualImageCell.leftLabel setHidden:YES] ;
        //[dualImageCell.leftBackView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFFF61BC"]] ;
        [dualImageCell.leftBackView setBackgroundColor:topLeftColor] ;
        
        
        CGRect leftFrame = dualImageCell.leftBackView.frame ;

        
        //NSCalendar *calendar = [NSCalendar currentCalendar] ;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:[NSDate date]] ;

        NSString *weekdayString = [VeamUtil getShorthandForWeekday:[components weekday]  format:VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL] ;
        NSString *dayString = [NSString stringWithFormat:@"%d",[components day]] ;
        NSString *monthString = [VeamUtil getNameForMonth:[components month]] ;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, leftFrame.size.width, 20)] ;
        [label setText:weekdayString] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setTextColor:topLeftTextColor] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]] ;
        [label setTextAlignment:NSTextAlignmentCenter] ;
        [dualImageCell addSubview:label] ;

        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, leftFrame.size.width, 60)] ;
        [label setText:dayString] ;
        
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setTextColor:topLeftTextColor] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:78]] ;
        [label setTextAlignment:NSTextAlignmentCenter] ;
        [dualImageCell addSubview:label] ;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, leftFrame.size.width, 20)] ;
        [label setText:monthString] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setTextColor:topLeftTextColor] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
        [label setTextAlignment:NSTextAlignmentCenter] ;
        [dualImageCell addSubview:label] ;
        
        //[VeamUtil adjustLabelSize:dualImageCell.leftLabel] ;
        
        [dualImageCell.rightImageView setImage:[VeamUtil imageNamed:@"t6_top_right.png"]] ;
        [dualImageCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;

        cell = dualImageCell ;
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        
        // FF41A2 purchased
        NSString *title ;
        UIColor *textColor = [VeamUtil getBaseTextColor] ;
        if(index == 0){
            title = [VeamUtil getConfigurationString:VEAM_CONFIG_CALENDAR_TITLE default:@"Calendar"] ;
            calendarBought = [self isCalendarBought] ;
            /*
            if(calendarBought){
                //textColor = [VeamUtil getColorFromArgbString:@"FFFF41A2"] ;
                textColor = [VeamUtil getNewVideosTextColor] ;
            }
             */
        } else if(index == 1){
            title = [VeamUtil getConfigurationString:VEAM_CONFIG_CALENDAR_MONTHLY_CONTENT_TITLE default:@"Monthly"] ;
            calendarBought = [self isCalendarBought] ;
            /*
            title = [VeamUtil getCalendarName:2] ;
            if((title == nil) || [title isEqualToString:@""]){
                title = @"Beginners Workout Calendar" ;
            }
            beginnersCalendarBought = [self isBeginnersCalendarBought] ;
            if(beginnersCalendarBought){
                //textColor = [VeamUtil getColorFromArgbString:@"FFFF41A2"] ;
                textColor = [VeamUtil getNewVideosTextColor] ;
            }
             */
        } else {
            title = @"" ;
        }
        [[basicCell titleLabel] setText:title] ;
        [[basicCell titleLabel] setTextColor:textColor] ;
        [basicCell.separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        
        [basicCell setBackgroundColor:[UIColor clearColor]] ;
        [basicCell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;

        cell = basicCell ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (BOOL)isCalendarBought
{
    return [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]] ;
}

/*
- (BOOL)isBeginnersCalendarBought
{
    BOOL retValue = NO ;
    NSString *receipt = [VeamUtil getBeginnersCalendarReceipt] ;
    if((receipt != nil) && ![receipt isEqualToString:@""]){
        retValue = YES ;
    }
    return retValue ;
}
*/

- (void)updateList
{
    [categoryListTableView reloadData] ;
    if(calendarViewController != nil){
        [calendarViewController updateCalendar] ;
    }

    /*
    if(beginnersCalendarViewController != nil){
        [beginnersCalendarViewController updateCalendar] ;
    }
    */
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath %d",indexPath.row) ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    NSInteger index = indexPath.row - indexOffset ;
    if(index == 0){
        if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
            // subscription
            calendarViewController = [[CalendarViewController alloc] init] ;
            [self.navigationController pushViewController:calendarViewController animated:YES] ;
        } else {
            SubscriptionPurchaseViewController *subscriptionPurchaseViewController = [[SubscriptionPurchaseViewController alloc] init] ;
            [subscriptionPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
            [self.navigationController pushViewController:subscriptionPurchaseViewController animated:YES] ;
        }
    } else if(index == 1){
        if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
            MixedViewController *mixedViewController = [[MixedViewController alloc] init] ;
            [mixedViewController setShowBackButton:YES] ;
            [mixedViewController setCategoryId:VEAM_MIXED_CATEGORY_ID_SUBSCRIPTION] ;
            [mixedViewController setSubCategoryId:@"0"] ;
            [mixedViewController setTitleName:[VeamUtil getConfigurationString:VEAM_CONFIG_CALENDAR_MONTHLY_CONTENT_TITLE default:@"Monthly"]] ;
            [self.navigationController pushViewController:mixedViewController animated:YES] ;
        } else {
            SubscriptionPurchaseViewController *subscriptionPurchaseViewController = [[SubscriptionPurchaseViewController alloc] init] ;
            [subscriptionPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
            [self.navigationController pushViewController:subscriptionPurchaseViewController animated:YES] ;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear");
    calendarViewController = nil ;
    //beginnersCalendarViewController = nil ;
    if([VeamUtil getShouldShowCalendar]){
        [VeamUtil setShouldShowCalendar:NO] ;
        calendarViewController = [[CalendarViewController alloc] init] ;
        [self.navigationController pushViewController:calendarViewController animated:YES] ;
    } else {
        BOOL shouldUpdate = NO ;
        //BOOL workBeginnersCalendarBought = [self isBeginnersCalendarBought] ;
        BOOL workCalendarBought = [self isCalendarBought] ;
        
        /*
        if(workBeginnersCalendarBought){
            if(!beginnersCalendarBought){
                beginnersCalendarBought = workBeginnersCalendarBought ;
                shouldUpdate = YES ;
            }
        } else {
            if(beginnersCalendarBought){
                beginnersCalendarBought = workBeginnersCalendarBought ;
                shouldUpdate = YES ;
            }
        }
         */
        
        if(workCalendarBought){
            if(!calendarBought){
                calendarBought = workCalendarBought ;
                shouldUpdate = YES ;
            }
        } else {
            if(calendarBought){
                calendarBought = workCalendarBought ;
                shouldUpdate = YES ;
            }
        }
        
        if(shouldUpdate){
            [categoryListTableView reloadData] ;
        }
    }
    
}


-(void)preloadCalendarData
{
    @autoreleasepool
    {
        //NSLog(@"preloadCalendarData start") ;
        
        NSDateComponents *components = [VeamUtil getCurrentDateComponents] ;
        if(![CalendarData cacheExists:components.year month:components.month]){
            //NSLog(@"cache not found") ;
            CalendarData *calendarData = [[CalendarData alloc] initWithServerData:components.year month:components.month] ;
        } else {
            //NSLog(@"cache exists") ;
        }
        
        //NSLog(@"preloadCalendarData end") ;
    }
}


@end
