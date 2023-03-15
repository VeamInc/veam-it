//
//  CalendarListViewController.m
//  veam31000015
//
//  Created by veam on 7/25/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "CalendarListViewController.h"
#import "VeamUtil.h"
#import "BasicCellViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CalendarListViewController ()

@end

@implementation CalendarListViewController

@synthesize year ;
@synthesize calendarViewController ;

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
    
    [self setViewName:[NSString stringWithFormat:@"CalendarList/%04d/",year]] ;

    calendarListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [calendarListTableView setDelegate:self] ;
    [calendarListTableView setDataSource:self] ;
    [calendarListTableView setBackgroundColor:[UIColor clearColor]] ;
    [calendarListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [calendarListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:calendarListTableView] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
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
    indexOffset = 1 ;
    
    startMonth = 1 ;
    endMonth = 12 ;
    
    NSInteger calendarStartYear = [VeamUtil getSubscriptionStartYear:[VeamUtil getSubscriptionIndex]] ;
    NSDateComponents *components = [VeamUtil getCurrentDateComponents] ;
    NSInteger currentYear = components.year ;
    NSInteger currentMonth = components.month ;
    
    if(calendarStartYear == 0){
        startMonth = currentMonth ;
        endMonth = currentMonth ;
        numberOfMonthsThisYear = 1 ;
        numberOfYearsToBeShown = 0 ;
    } else {
        if(calendarStartYear == year){
            startMonth = [VeamUtil getSubscriptionStartMonth:[VeamUtil getSubscriptionIndex]] ;
        }
        if(year == currentYear){
            endMonth = currentMonth ;
        } else {
            endMonth = 12 ;
        }
        numberOfMonthsThisYear = endMonth - startMonth + 1 ;
        numberOfYearsToBeShown = year - calendarStartYear ;
    }
    
    lastIndex = indexOffset + numberOfMonthsThisYear + numberOfYearsToBeShown ;
    NSInteger retInt = lastIndex + 1 ;
     
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == lastIndex){
        retValue = [VeamUtil getTabBarHeight] ;
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if((indexPath.row == 0) || (indexPath.row == lastIndex)){
        // spacer
        cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
        }
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else {
        NSInteger index = indexPath.row - 1 ;
        NSString *title ;
        if(index < numberOfMonthsThisYear){
            // month of this year
            title = [VeamUtil getNameForMonth:endMonth-index] ;
        } else {
            // another year
            NSInteger offset = index - numberOfMonthsThisYear ;
            NSInteger targetYear = year - offset - 1 ;
            title = [NSString stringWithFormat:@"%d",targetYear] ;
        }
        
        BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (basicCell == nil) {
            BasicCellViewController *controller = [[BasicCellViewController alloc] initWithNibName:@"BasicCell" bundle:nil] ;
            basicCell = (BasicCell *)controller.view ;
        }
        [[basicCell titleLabel] setText:title] ;
        cell = basicCell ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    NSInteger index = indexPath.row - 1 ;
    if(index >= 0){
        if(index < numberOfMonthsThisYear){
            // month of this year
            NSInteger targetMonth = endMonth - index ;
            //NSLog(@"tap %d/%d",year,targetMonth) ;
            [VeamUtil setCalendarYear:year month:targetMonth] ;
            /*
            CATransition* transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
             */
            if(calendarViewController == nil){
                [self.navigationController popToRootViewControllerAnimated:YES] ;
            } else {
                [self.navigationController popToViewController:calendarViewController animated:YES] ;
            }
        } else if(index < (numberOfMonthsThisYear + numberOfYearsToBeShown)) {
            // another year
            NSInteger offset = index - numberOfMonthsThisYear ;
            NSInteger targetYear = year - offset - 1 ;
            //NSLog(@"tap %d",targetYear) ;
            CalendarListViewController *calendarListViewController = [[CalendarListViewController alloc] init] ;
            [calendarListViewController setYear:targetYear] ;
            [calendarListViewController setTitleName:[NSString stringWithFormat:@"%d",targetYear]] ;
            [calendarListViewController setCalendarViewController:calendarViewController] ;
            [self.navigationController pushViewController:calendarListViewController animated:YES] ;
        }
    }
}


@end
