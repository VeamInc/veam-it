//
//  CalendarLabel.m
//  veam31000015
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "CalendarLabel.h"
#import "VeamUtil.h"

@implementation CalendarLabel

@synthesize calendarData ;
@synthesize calendarDay ;
@synthesize year ;
@synthesize month ;
@synthesize day ;

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        workouts = [[NSMutableArray alloc] init] ;
        CalendarWorkout *workout = [[CalendarWorkout alloc] init] ;
        YoutubeVideo *dummyYoutubeVideo = [[YoutubeVideo alloc] init] ;
        [dummyYoutubeVideo setTitle:@"Veam's recommendation"] ;
        [workout setYoutubeVideo:dummyYoutubeVideo] ;
        [workout setDone:NO] ;
        [workouts addObject:workout] ;
    }
    return self;
}
 */

- (void)updateContents
{
    NSArray *mixedIds = [calendarDay.mixedIds componentsSeparatedByString:@"_"] ;
    NSString *weekdayDescription = calendarDay.message ;
    if([VeamUtil isEmpty:weekdayDescription]){
        weekdayDescription = @" " ;
    }
    weekdayText = [[WeekdayText alloc] init] ;
    [weekdayText setTitle:calendarDay.title] ;
    [weekdayText setDescription:weekdayDescription] ;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setYear:year] ;
    [components setMonth:month] ;
    [components setDay:day] ;
    NSDate *thisDate = [calendar dateFromComponents:components] ;
    components = [calendar components:NSWeekdayCalendarUnit fromDate:thisDate] ;
    NSInteger offset = components.weekday ; // sun:1 mon:2 tue:3 ...
    //NSLog(@"offset=%d",offset) ;
    NSString *weekdayString = [NSString stringWithFormat:@"%d",offset] ;
    /*
    [weekdayText setWeekday:[NSString stringWithFormat:@"%d",offset]] ;
     */
    [weekdayText setWeekday:weekdayString] ;
 
    
    
    
    
    
    
    NSInteger mixedCount = [mixedIds count] ;
    workouts = [[NSMutableArray alloc] init] ;
    for(int index = 0 ; index < mixedCount ; index++){
        NSString *mixedId = [mixedIds objectAtIndex:index] ;
        CalendarWorkout *workout = [[CalendarWorkout alloc] init] ;
        Mixed *mixed = [calendarData getMixedForId:mixedId] ;
        [workout setMixed:mixed] ;
        [workout setDone:NO] ;
        [workouts addObject:workout] ;
    }
    
    NSInteger count = [dotImageViews count] ;
    if(count > 0){
        for(int index = 0 ; index < count ; index++){
            UIImageView *imageView = [dotImageViews objectAtIndex:index] ;
            [imageView removeFromSuperview] ;
        }
        [dotImageViews removeAllObjects] ;
    }
    BOOL atLeastOneDone = NO ;
    NSInteger numberOfWorkouts = [workouts count] ;
    if(numberOfWorkouts > 0){
        dotImageViews = [[NSMutableArray alloc] init] ;
        CGFloat dotX = (VEAM_CALENDAR_LABEL_WIDTH / 2) - (VEAM_CALENDAR_DOT_WIDTH / 2) * numberOfWorkouts ;
        for(int index = 0 ; index < numberOfWorkouts ; index++){
            BOOL workoutDone = [VeamUtil getWorkoutDone:year month:month day:day index:index] ;
            if(workoutDone){
                atLeastOneDone = YES ;
            }
            CalendarWorkout *workout = [self getWorkoutAt:index] ;
            [workout setDone:workoutDone] ;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(dotX, VEAM_CALENDAR_LABEL_WIDTH*3/4, VEAM_CALENDAR_DOT_WIDTH, VEAM_CALENDAR_DOT_WIDTH)] ;
            UIImage *image ;
            switch (currentState) {
                case VEAM_CALENDAR_STATE_TODAY:
                    if(workoutDone){
                        image = [UIImage imageNamed:@"calendar_dot4.png"] ;
                    } else {
                        image = [UIImage imageNamed:@"calendar_dot3.png"] ;
                    }
                    break;
                case VEAM_CALENDAR_STATE_PAST:
                case VEAM_CALENDAR_STATE_DONE:
                case VEAM_CALENDAR_STATE_FUTURE:
                    if(workoutDone){
                        image = [UIImage imageNamed:@"calendar_dot2.png"] ;
                    } else {
                        image = [UIImage imageNamed:@"calendar_dot1.png"] ;
                    }
                    break;
                    
                default:
                    break;
            }
            [imageView setImage:image] ;
            [self addSubview:imageView] ;
            [dotImageViews addObject:imageView] ;
            
            dotX += VEAM_CALENDAR_DOT_WIDTH ;
        }
    }
    
    if((currentState == VEAM_CALENDAR_STATE_PAST) && atLeastOneDone){
        currentState = VEAM_CALENDAR_STATE_DONE ;
        [self updateAppearance] ;
    } else if((currentState == VEAM_CALENDAR_STATE_DONE) && !atLeastOneDone){
        currentState = VEAM_CALENDAR_STATE_PAST ;
        [self updateAppearance] ;
    }
}

- (BOOL)getWorkoutDone:(NSInteger)index
{
    CalendarWorkout *workout = [self getWorkoutAt:index] ;
    return [workout done] ;
}

- (void)setWorkoutDone:(NSInteger)index done:(BOOL)done
{
    CalendarWorkout *workout = [self getWorkoutAt:index] ;
    [workout setDone:done] ;
    [VeamUtil setWorkoutDone:year month:month day:day index:index done:done] ;
}


- (id)initWithCalendarData:(CalendarData *)targetCalendarData year:(NSInteger)targetYear month:(NSInteger)targetMonth day:(NSInteger)targetDay
{
    self = [super init];
    if (self) {
        // Initialization code
        
        
        [self setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
        [self setText:[NSString stringWithFormat:@"%d",targetDay]] ;
        [self setTextAlignment:NSTextAlignmentCenter] ;
        [self setCalendarData:targetCalendarData] ;
        [self setCalendarDay:[calendarData getCalendarDayForYear:targetYear month:targetMonth day:targetDay]] ;
        [self setYear:targetYear] ;
        [self setMonth:targetMonth] ;
        [self setDay:targetDay] ;

        /*
        workouts = [[NSMutableArray alloc] init] ;
        CalendarWorkout *workout = [[CalendarWorkout alloc] init] ;
        YoutubeVideo *dummyYoutubeVideo = [[YoutubeVideo alloc] init] ;
        [dummyYoutubeVideo setTitle:@"Veam's recommendation"] ;
        [workout setYoutubeVideo:dummyYoutubeVideo] ;
        [workout setDone:NO] ;
        [workouts addObject:workout] ;
         */
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width
{
    [[self layer] setBorderColor:[color CGColor]] ;
    [[self layer] setBorderWidth:width] ;
}

- (void)setState:(NSInteger)state
{
    currentState = state ;
    [self updateAppearance] ;
}

- (void)updateAppearance
{
    CGFloat lineWidth = 1 ;
    if(isSelected){
        lineWidth = 2 ;
    }
    switch (currentState) {
        case VEAM_CALENDAR_STATE_INACTIVE:
            [self setBorderColor:[UIColor clearColor] width:0] ;
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFD5D5D5"]] ;
            [self setTextColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
            break ;
        case  VEAM_CALENDAR_STATE_PAST:
            [self setBorderColor:[VeamUtil getColorFromArgbString:@"FF989595"] width:lineWidth] ;
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
            [self setTextColor:[VeamUtil getColorFromArgbString:@"FF9B999A"]] ;
            break ;
        case  VEAM_CALENDAR_STATE_DONE:
            [self setBorderColor:[VeamUtil getCalendarLineColor] width:lineWidth] ;
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
            [self setTextColor:[VeamUtil getCalendarTextColor]] ;
            break ;
        case  VEAM_CALENDAR_STATE_TODAY:
            [self setBorderColor:[VeamUtil getCalendarLineColor] width:lineWidth] ;
            [self setBackgroundColor:[VeamUtil getCalendarTodayColor]] ;
            [self setTextColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
            break ;
        case  VEAM_CALENDAR_STATE_FUTURE:
            [self setBorderColor:[VeamUtil getColorFromArgbString:@"FF999695"] width:lineWidth] ;
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
            [self setTextColor:[VeamUtil getColorFromArgbString:@"FF9A9A9A"]] ;
            break ;
        default:
            break;
    }
}

- (NSInteger)getState
{
    return currentState ;
}

- (void)setSelected:(BOOL)selected
{
    if(selected){
        isSelected = YES ;
    } else {
        isSelected = NO ;
    }
    [self updateAppearance] ;
}

- (NSInteger)getNumberOfWorkouts
{
    return [workouts count] ;
}

- (CalendarWorkout *)getWorkoutAt:(NSInteger)index
{
    CalendarWorkout *retValue = nil ;
    if(index < [workouts count]){
        retValue = [workouts objectAtIndex:index] ;
    }
    return retValue ;
}

- (WeekdayText *)getWeekdayText
{
    return weekdayText ;
}


@end
