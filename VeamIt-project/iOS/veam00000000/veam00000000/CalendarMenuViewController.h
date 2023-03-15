//
//  CalendarMenuViewController.h
//  veam31000015
//
//  Created by veam on 9/13/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"
#import "CalendarViewController.h"
//#import "BeginnersCalendarViewController.h"


@interface CalendarMenuViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *categoryListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    
    BOOL calendarBought ;
    BOOL beginnersCalendarBought ;
    
    CalendarViewController *calendarViewController ;
    //BeginnersCalendarViewController *beginnersCalendarViewController ;
}

- (void)updateList ;

@end
