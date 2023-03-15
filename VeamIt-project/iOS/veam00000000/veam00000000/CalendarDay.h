//
//  CalendarDay.h
//  veam00000000
//
//  Created by veam on 7/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface CalendarDay : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *calendarDayId ;
@property (nonatomic, retain) NSString *year ;
@property (nonatomic, retain) NSString *month ;
@property (nonatomic, retain) NSString *day ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *message ;
@property (nonatomic, retain) NSString *mixedIds ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
