//
//  CalendarListViewController.h
//  veam31000015
//
//  Created by veam on 7/25/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "CalendarViewController.h"

@interface CalendarListViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *calendarListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    
    NSInteger numberOfMonthsThisYear ;
    NSInteger startMonth ;
    NSInteger endMonth ;
    NSInteger numberOfYearsToBeShown ;
}

@property (nonatomic, assign) NSInteger year ;
@property (nonatomic, retain) CalendarViewController *calendarViewController ;

@end
