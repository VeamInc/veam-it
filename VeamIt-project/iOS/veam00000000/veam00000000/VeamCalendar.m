//
//  VeamCalendar.m
//  veam31000015
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamCalendar.h"

@implementation VeamCalendar

@synthesize calendarData ;
@synthesize year ;
@synthesize month ;
@synthesize numberOfRows ;
@synthesize delegate ;


/*
 NSEraCalendarUnit ――時代を示す値（紀元前・紀元後など）
 NSYearCalendarUnit ――年の値
 NSMonthCalendarUnit ――月の値
 NSDayCalendarUnit ――日の値
 NSHourCalendarUnit ――時の値
 NSMinuteCalendarUnit ――分の値
 NSSecondCalendarUnit ――秒の値
 NSWeekCalendarUnit ――週の値（１年の何週目か）
 NSWeekdayCalendarUnit ――曜日の値
 NSWeekdayOrdinalCalendarUnit ――週の値（今月の何週目か）
 NSQuarterCalendarUnit ――第何四半期か
 */

- (id)initWithCalendarData:(CalendarData *)targetCalendarData year:(NSInteger)targetYear month:(NSInteger)targetMonth delegate:(id <VeamCalendarDelegate>)veamCalendarDelegate
{
    self = [super init] ;
    if (self) {
        // Initialization code
        self.delegate = veamCalendarDelegate ;
        self.calendarData = targetCalendarData ;
        self.year = targetYear ;
        self.month = targetMonth ;
        calendarLabels = [[NSMutableArray alloc] init] ;
    }
    return self ;
}

- (void)loadCalendar
{
    //NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setYear:year] ;
    [components setMonth:month] ;
    [components setDay:1] ;
    NSDate *firstDate = [calendar dateFromComponents:components] ;
    
    NSDate *currentDate = [NSDate date] ;
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate] ;
    NSInteger currentYear = components.year ;
    NSInteger currentMonth = components.month ;
    NSInteger currentDay = components.day ;
    
    components = [calendar components:NSWeekdayCalendarUnit fromDate:firstDate] ;
    NSInteger offset = components.weekday ; // sun:1 mon:2 tue:3 ...
    //NSDate *startDate = [firstDate dateByAddingTimeInterval:-86400*(offset-1)] ;
    NSDate *startDate = [firstDate dateByAddingTimeInterval:-86400*(offset-1)+43200] ;
    //NSLog(@"%d/%d/1 : %d",year,month,components.weekday) ;
    
    [components setYear:year] ;
    [components setMonth:month+1] ;
    [components setDay:1] ;
    NSDate *nextMonthFirstDate = [calendar dateFromComponents:components] ;
    
    NSTimeInterval diff = [nextMonthFirstDate timeIntervalSinceDate:startDate] ;
    //NSLog(@"%f",diff / 86400) ;
    
    numberOfRows = ceil(diff / 86400 / 7) ;
    //NSLog(@"number of rows : %d",numberOfRows) ;
    
    NSDate *workDate = startDate ;
    for(int y = 0 ; y < numberOfRows ; y++){
        for(int x = 0 ; x < 7 ; x++){
            components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:workDate] ;
            NSInteger workYear = components.year ;
            NSInteger workMonth = components.month ;
            NSInteger workDay = components.day ;
            //NSLog(@"%d,%d %d/%d",x,y,workMonth,workDay) ;
            
            CalendarLabel *calendarLabel = [[CalendarLabel alloc] initWithCalendarData:calendarData year:workYear month:workMonth day:workDay] ;
            //NSLog(@"set label %d/%d/%d",workYear,workMonth,workDay) ;
            if((currentYear == workYear) && (currentMonth == workMonth) && (currentDay == workDay)){
                // today
                //NSLog(@"Today") ;
                [calendarLabel setState:VEAM_CALENDAR_STATE_TODAY] ;
            } else if((year != workYear) || (month != workMonth)){
                [calendarLabel setState:VEAM_CALENDAR_STATE_INACTIVE] ;
            } else {
                BOOL isPast = NO ;
                if(workYear < currentYear){
                    isPast = YES ;
                } else if(workYear == currentYear){
                    if(workMonth < currentMonth){
                        isPast = YES ;
                    } else if(workMonth == currentMonth){
                        if(workDay < currentDay){
                            isPast = YES ;
                        }
                    }
                }
                
                if(isPast){
                    //NSLog(@"past") ;
                    [calendarLabel setState:VEAM_CALENDAR_STATE_PAST] ;
                } else {
                    //NSLog(@"future") ;
                    [calendarLabel setState:VEAM_CALENDAR_STATE_FUTURE] ;
                }
            }
            
            [calendarLabel updateContents] ;
            
            [calendarLabels addObject:calendarLabel] ;
            
            workDate = [workDate dateByAddingTimeInterval:86400] ;
        }
    }
    
    if(delegate != nil){
        [delegate calendarDidLoad] ;
    }
}

- (CalendarLabel *)getCalendarLabel:(NSInteger)x y:(NSInteger)y
{
    NSInteger index = y * 7 + x ;
    CalendarLabel *retValue ;
    if(index < [calendarLabels count]){
        retValue = [calendarLabels objectAtIndex:index] ;
    }
    return retValue ;
}

@end
