//
//  VeamCalendar.h
//  veam31000015
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarLabel.h"
#import "CalendarData.h"

@protocol VeamCalendarDelegate ;

@interface VeamCalendar : NSObject
{
    NSInteger year ;
    NSInteger month ;
    NSMutableArray *calendarLabels ;
    
}

@property (nonatomic, retain) CalendarData *calendarData ;
@property (nonatomic, assign) NSInteger year ;
@property (nonatomic, assign) NSInteger month ;
@property (nonatomic, assign) NSInteger numberOfRows ;
@property (nonatomic, retain) id <VeamCalendarDelegate> delegate;

- (id)initWithCalendarData:(CalendarData *)targetCalendarData year:(NSInteger)targetYear month:(NSInteger)targetMonth delegate:(id <VeamCalendarDelegate>)veamCalendarDelegate ;
- (void)loadCalendar ;
- (CalendarLabel *)getCalendarLabel:(NSInteger)x y:(NSInteger)y ;

@end

@protocol VeamCalendarDelegate
- (void)calendarDidLoad ;
@end
