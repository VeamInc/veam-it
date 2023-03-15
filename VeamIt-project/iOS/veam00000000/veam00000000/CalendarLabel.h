//
//  CalendarLabel.h
//  veam31000015
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CalendarData.h"
#import "CalendarDay.h"
#import "CalendarWorkout.h"
#import "WeekdayText.h"

#define VEAM_CALENDAR_STATE_INACTIVE    1
#define VEAM_CALENDAR_STATE_PAST        2
#define VEAM_CALENDAR_STATE_DONE        3
#define VEAM_CALENDAR_STATE_TODAY       4
#define VEAM_CALENDAR_STATE_FUTURE      5

@interface CalendarLabel : UILabel
{
    NSInteger currentState ;
    BOOL isSelected ;
    NSMutableArray *workouts ;
    NSMutableArray *dotImageViews ;
    WeekdayText *weekdayText ;
}


@property (nonatomic, retain) CalendarData *calendarData ;
@property (nonatomic, retain) CalendarDay *calendarDay ;
@property (nonatomic, assign) NSInteger year ;
@property (nonatomic, assign) NSInteger month ;
@property (nonatomic, assign) NSInteger day ;

- (id)initWithCalendarData:(CalendarData *)targetCalendarData year:(NSInteger)targetYear month:(NSInteger)targetMonth day:(NSInteger)targetDay ;

- (void)setState:(NSInteger)state ;
- (NSInteger)getState ;
- (void)setBorderColor:(UIColor *)color width:(CGFloat)width ;
- (void)setSelected:(BOOL)selected ;
- (NSInteger)getNumberOfWorkouts ;
- (CalendarWorkout *)getWorkoutAt:(NSInteger)index ;
- (void)updateContents ;
- (BOOL)getWorkoutDone:(NSInteger)index ;
- (void)setWorkoutDone:(NSInteger)index done:(BOOL)done ;
- (WeekdayText *)getWeekdayText ;

@end

