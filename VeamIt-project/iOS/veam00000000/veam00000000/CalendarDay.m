//
//  CalendarDay.m
//  veam00000000
//
//  Created by veam on 7/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "CalendarDay.h"
#import "HandlePostResultDelegate.h"

@implementation CalendarDay

@synthesize calendarDayId ;
@synthesize year ;
@synthesize month ;
@synthesize day ;
@synthesize title ;
@synthesize message ;
@synthesize mixedIds ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setCalendarDayId:[attributeDict objectForKey:@"id"]] ;
    [self setYear:[attributeDict objectForKey:@"y"]] ;
    [self setMonth:[attributeDict objectForKey:@"m"]] ;
    [self setDay:[attributeDict objectForKey:@"d"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setMessage:[attributeDict objectForKey:@"mes"]] ;
    [self setMixedIds:[attributeDict objectForKey:@"mids"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
}



@end
