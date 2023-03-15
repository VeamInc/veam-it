//
//  ReportManager.h
//  TestRequest
//
//  Created by veam on 2014/09/17.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unit : NSObject

@property (strong, nonatomic) NSString* beginDate;
@property (strong, nonatomic) NSString* endDate;
@property float units;

@end




@interface Users : NSObject

@property (strong, nonatomic) NSString* beginDate;
@property (strong, nonatomic) NSString* endDate;
@property float newUsers;
@property float returningUsers;

@end

@interface Sessions : NSObject

@property (strong, nonatomic) NSString* beginDate;
@property (strong, nonatomic) NSString* endDate;
@property float newSessions;
@property float repeatSessions;

@end


@interface ReportManager : NSObject{
    NSString* _appId;
}

+ (ReportManager*)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;

- (BOOL)setData:(NSData*)data;

@property (strong, nonatomic) Unit* appTotalUnits;
@property (strong, nonatomic) NSArray* appDailyUnits;
@property (strong, nonatomic) NSArray* appWeeklyUnits;
@property (strong, nonatomic) NSArray* appMonthlyUnits;

@property (strong, nonatomic) Unit* iapTotalUnits;
@property (strong, nonatomic) NSArray* iapDailyUnits;
@property (strong, nonatomic) NSArray* iapWeeklyUnits;
@property (strong, nonatomic) NSArray* iapMonthlyUnits;

@property (strong, nonatomic) NSArray* screenViewsDaily;
@property (strong, nonatomic) NSArray* screenViewsWeekly;
@property (strong, nonatomic) NSArray* screenViewsMonthly;

@property (strong, nonatomic) Users* usersTotal;
@property (strong, nonatomic) NSArray* usersDaily;
@property (strong, nonatomic) NSArray* usersWeekly;
@property (strong, nonatomic) NSArray* usersMonthly;

@property (strong, nonatomic) Sessions* repeatSessionsTotal;
@property (strong, nonatomic) NSArray* repeatSessionsDaily;
@property (strong, nonatomic) NSArray* repeatSessionsWeekly;
@property (strong, nonatomic) NSArray* repeatSessionsMonthly;

@property (strong, nonatomic) Unit* postsTotalUnits;
@property (strong, nonatomic) NSArray* postsDaily;
@property (strong, nonatomic) NSArray* postsWeekly;
@property (strong, nonatomic) NSArray* postsMonthly;

@property (strong, nonatomic) Unit* commentsTotalUnits;
@property (strong, nonatomic) NSArray* commentsDaily;
@property (strong, nonatomic) NSArray* commentsWeekly;
@property (strong, nonatomic) NSArray* commentsMonthly;

@property CGFloat percentOfPurchaseConversionRate;

+(NSString*)roundingNumber:(CGFloat)num;

@property (strong, nonatomic, setter=setAppId:) NSString* appId;
@property CGFloat customerPrice;
@property (strong, nonatomic) NSString* screenNamePrefix;

@end
