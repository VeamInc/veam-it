//
//  Reportmanager.m
//  TestRequest
//
//  Created by veam on 2014/09/17.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "ReportManager.h"

@implementation Unit

@end

@implementation Users

@end

@implementation Sessions

@end

@implementation ReportManager

// シングルトンパターンとする
static ReportManager* _sharedManager = nil;


+ (ReportManager*)sharedManager {
    @synchronized(self) {
        if (_sharedManager == nil) {
            (void) [[self alloc] init]; // ここでは代入していない
        }
    }
    return _sharedManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_sharedManager == nil) {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;  // 最初の割り当てで代入し、返す
        }
    }
    return nil; // 以降の割り当てではnilを返すようにする
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}


- (id)init
{
    if(self = [super init]){
        /* initialization code */
        self.appId = DEFAULT_APP_ID;
        self.customerPrice = DEFAULT_IAP_CUSTOMER_PRICE;
    }
    return self;
}

-(void)dealloc
{
    self.appTotalUnits = nil;
    self.appDailyUnits = nil;
    self.appWeeklyUnits = nil;
    self.appMonthlyUnits = nil;
    self.iapTotalUnits = nil;
    self.iapDailyUnits = nil;
    self.iapWeeklyUnits = nil;
    self.iapMonthlyUnits = nil;
}

// JSONを解析して各種オブジェクトをセット
- (BOOL)setData:(NSData*)data
{
    if(data == nil){
        DLog(@"error");
        return NO;
    }
    
    DLog(@"%@", [data description]);
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments error:nil];

    if (![jsonObject respondsToSelector:@selector(objectAtIndex:)]) {
        DLog(@"error");
        return NO;
    }
    
    BOOL isInAppExecuted = NO; // InAppPurchase は最初の一個だけを採用する
    
    for(NSDictionary* appInfo in jsonObject){
        NSString* veamId = [appInfo objectForKey:@"VeamId"];
        NSString* title = [appInfo objectForKey:@"Title"];
        NSString* platform = [appInfo objectForKey:@"Platform"];
        NSString* productType = [appInfo objectForKey:@"ProductType"];

        DLog(@"VeamId     =%@", veamId);
        DLog(@"Title      =%@", title);
        DLog(@"Platform   =%@", platform);
        DLog(@"ProductType=%@", productType);
        
        if([productType isEqualToString:@"App"]){
            // アプリダウンロード状況
            [self setDataAppUnit:appInfo];

        }
        else if([productType isEqualToString:@"In-App"]){
            
            if(isInAppExecuted == YES){
                continue;
            }
            isInAppExecuted = YES;
            
            [self setDataIapUnit:appInfo];
        }
        else if([productType isEqualToString:@"SV"]){
            // ScreenViews
            [self setDataScreenViews:appInfo];
        }
        else if([productType isEqualToString:@"USR"]){
            // Returning Users

            [self setDataUsers:appInfo];
        }
        else if([productType isEqualToString:@"RS"]){
            // Repeat Session
            [self setDataSessions:appInfo];
        }
        else if([productType isEqualToString:@"Posts"]){
            // Veam 投稿状況
            [self setDataPosts:appInfo];
        }
        else if([productType isEqualToString:@"Comments"]){
            // Veam Comment状況
            [self setDataComments:appInfo];
        }
    }
    
    // 成功
    return YES;
}



//
// iTunes Connect
// アプリダウンロード状況
//
-(void)setDataAppUnit:(NSDictionary*)appInfo
{
    
    // App Download (Total)
    {
        NSDictionary* appTotalDictionary = [appInfo objectForKey:@"Total"];
        NSString* beginDate = [appTotalDictionary objectForKey:@"beginDate"];
        NSString* units    = [appTotalDictionary objectForKey:@"count"];
        
        Unit* appTotalUnits = [[Unit alloc] init];
        appTotalUnits.beginDate = beginDate;
        if([units isKindOfClass:[NSString class]]){
            appTotalUnits.units = [units floatValue];
        }
        self.appTotalUnits = appTotalUnits;
    }
    
    // App Download (Daily)
    NSArray* appDailyArray = [appInfo objectForKey:@"Daily"];
    NSMutableArray* appDailyUnits = [NSMutableArray array];
    for(NSDictionary* a in appDailyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [appDailyUnits addObject:u];
    }
    self.appDailyUnits = appDailyUnits;
    
    // App Download (Weekly)
    NSArray* appWeeklyArray = [appInfo objectForKey:@"Weekly"];
    NSMutableArray* appWeeklyUnits = [NSMutableArray array];
    for(NSDictionary* a in appWeeklyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [appWeeklyUnits addObject:u];
    }
    self.appWeeklyUnits = appWeeklyUnits;
    
    // App Download (Monthly)
    NSArray* appMonthlyArray = [appInfo objectForKey:@"Monthly"];
    NSMutableArray* appMonthlyUnits = [NSMutableArray array];
    for(NSDictionary* a in appMonthlyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [appMonthlyUnits addObject:u];
    }
    self.appMonthlyUnits = appMonthlyUnits;
}

//
// iTunes Connect
// アプリ内課金状況
//
-(void)setDataIapUnit:(NSDictionary*)appInfo
{
    // In-App Purchase (Total)
    {
        NSDictionary* iapTotalDictionary = [appInfo objectForKey:@"Total"];
        NSString* beginDate = [iapTotalDictionary objectForKey:@"beginDate"];
        NSString* units     = [iapTotalDictionary objectForKey:@"count"];
        
        Unit* iapTotalUnits = [[Unit alloc] init];
        iapTotalUnits.beginDate = beginDate;
        if([units isKindOfClass:[NSString class]]){
            iapTotalUnits.units = [units floatValue];
        }
        self.iapTotalUnits = iapTotalUnits;
    }
    
    //  In-App Purchase (Daily)
    NSArray* iapDailyArray = [appInfo objectForKey:@"Daily"];
    NSMutableArray* iapDailyUnits = [NSMutableArray array];
    for(NSDictionary* a in iapDailyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [iapDailyUnits addObject:u];
    }
    self.iapDailyUnits = iapDailyUnits;
    
    //  In-App Purchase (Weekly)
    NSArray* iapWeeklyArray = [appInfo objectForKey:@"Weekly"];
    NSMutableArray* iapWeeklyUnits = [NSMutableArray array];
    for(NSDictionary* a in iapWeeklyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [iapWeeklyUnits addObject:u];
    }
    self.iapWeeklyUnits = iapWeeklyUnits;
    
    //  In-App Purchase (Monthly)
    NSArray* iapMonthlyArray = [appInfo objectForKey:@"Monthly"];
    NSMutableArray* iapMonthlyUnits = [NSMutableArray array];
    for(NSDictionary* a in iapMonthlyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [iapMonthlyUnits addObject:u];
    }
    self.iapMonthlyUnits = iapMonthlyUnits;
}


//
// Google Analytics
// ScreenViews
//
-(void)setDataScreenViews:(NSDictionary*)appInfo
{
    // ScreenViews (Daily)
    NSArray* screenViewsDailyArray = [appInfo objectForKey:@"Daily"];
    if (![screenViewsDailyArray respondsToSelector:@selector(objectAtIndex:)]) {
        self.screenViewsDaily = nil;
    }
    else{
        self.screenViewsDaily = screenViewsDailyArray;
    }
    // ScreenViews (Weekly)
    NSArray* screenViewsWeeklyArray = [appInfo objectForKey:@"Weekly"];
    if (![screenViewsWeeklyArray respondsToSelector:@selector(objectAtIndex:)]) {
        self.screenViewsWeekly = nil;
    }
    else{
        self.screenViewsWeekly = screenViewsWeeklyArray;
    }
    // ScreenViews (Monthly)
    NSArray* screenViewsMonthlyArray = [appInfo objectForKey:@"Monthly"];
    if (![screenViewsMonthlyArray respondsToSelector:@selector(objectAtIndex:)]) {
        self.screenViewsMonthly = nil;
    }
    else{
        self.screenViewsMonthly = screenViewsMonthlyArray;
    }
}


//
// Google Analytics
// Users
//
-(void)setDataUsers:(NSDictionary*)appInfo
{
    // users (Total)
    {
        NSDictionary* usersTotalWork = [appInfo objectForKey:@"Total"];
        NSString* newUsers    = [usersTotalWork objectForKey:@"newUsers"];
        NSString* returningUsers = [usersTotalWork objectForKey:@"returningUsers"];
        Users* usersTotal = [[Users alloc]init];
        if([newUsers isKindOfClass:[NSString class]]){
            usersTotal.newUsers = [newUsers floatValue];
        }
        if([returningUsers isKindOfClass:[NSString class]]){
            usersTotal.returningUsers = [returningUsers floatValue];
        }
        self.usersTotal = usersTotal;
    }
    
    // users (Daily)
    NSArray* usersDailyArray = [appInfo objectForKey:@"Daily"];
    NSMutableArray* usersDaily = [NSMutableArray array];
    for(NSDictionary* a in usersDailyArray){
        NSString* beginDate      = [a objectForKey:@"beginDate"];
        NSString* endDate        = [a objectForKey:@"endDate"];
        NSString* newUsers       = [a objectForKey:@"newUsers"];
        NSString* returningUsers = [a objectForKey:@"returningUsers"];
        Users* u = [[Users alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([newUsers isKindOfClass:[NSString class]]){
            u.newUsers = [newUsers floatValue];
        }
        if([returningUsers isKindOfClass:[NSString class]]){
            u.returningUsers = [returningUsers floatValue];
        }
        [usersDaily addObject:u];
    }
    self.usersDaily = usersDaily;
    
    // users (Weekly)
    NSArray* usersWeeklyArray = [appInfo objectForKey:@"Weekly"];
    NSMutableArray* usersWeekly = [NSMutableArray array];
    for(NSDictionary* a in usersWeeklyArray){
        NSString* beginDate      = [a objectForKey:@"beginDate"];
        NSString* endDate        = [a objectForKey:@"endDate"];
        NSString* newUsers       = [a objectForKey:@"newUsers"];
        NSString* returningUsers = [a objectForKey:@"returningUsers"];
        Users* u = [[Users alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([newUsers isKindOfClass:[NSString class]]){
            u.newUsers = [newUsers floatValue];
        }
        if([returningUsers isKindOfClass:[NSString class]]){
            u.returningUsers = [returningUsers floatValue];
        }
        [usersWeekly addObject:u];
    }
    self.usersWeekly = usersWeekly;
    
    // users (Monthly)
    NSArray* usersMonthlyArray = [appInfo objectForKey:@"Monthly"];
    NSMutableArray* usersMonthly = [NSMutableArray array];
    for(NSDictionary* a in usersMonthlyArray){
        NSString* beginDate      = [a objectForKey:@"beginDate"];
        NSString* endDate        = [a objectForKey:@"endDate"];
        NSString* newUsers       = [a objectForKey:@"newUsers"];
        NSString* returningUsers = [a objectForKey:@"returningUsers"];
        Users* u = [[Users alloc]init];
        u.beginDate = beginDate;
        u.endDate = endDate;
        if([newUsers isKindOfClass:[NSString class]]){
            u.newUsers = [newUsers floatValue];
        }
        if([returningUsers isKindOfClass:[NSString class]]){
            u.returningUsers = [returningUsers floatValue];
        }
        [usersMonthly addObject:u];
    }
    self.usersMonthly = usersMonthly;
}

//
// Google Analytics
// Sessions
//
-(void)setDataSessions:(NSDictionary*)appInfo
{
    // RepeatSessions (Total)
    {
        NSDictionary* repeatSessionsTotalWork = [appInfo objectForKey:@"Total"];
        NSString* newSessions    = [repeatSessionsTotalWork objectForKey:@"newSessions"];
        NSString* repeatSessions = [repeatSessionsTotalWork objectForKey:@"repeatSessions"];
        Sessions* repeatSessionsTotal = [[Sessions alloc]init];
        if([newSessions isKindOfClass:[NSString class]]){
            repeatSessionsTotal.newSessions = [newSessions floatValue];
        }
        if([repeatSessions isKindOfClass:[NSString class]]){
            repeatSessionsTotal.repeatSessions = [repeatSessions floatValue];
        }
        self.repeatSessionsTotal = repeatSessionsTotal;
    }
    
    // RepeatSessions (Daily)
    NSArray* repeatSessionsDailyArray = [appInfo objectForKey:@"Daily"];
    NSMutableArray* repeatSessionsDaily = [NSMutableArray array];
    for(NSDictionary* a in repeatSessionsDailyArray){
        NSString* beginDate      = [a objectForKey:@"beginDate"];
        NSString* endDate        = [a objectForKey:@"endDate"];
        NSString* newSessions    = [a objectForKey:@"newSessions"];
        NSString* repeatSessions = [a objectForKey:@"repeatSessions"];
        Sessions* u = [[Sessions alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([newSessions isKindOfClass:[NSString class]]){
            u.newSessions = [newSessions floatValue];
        }
        if([repeatSessions isKindOfClass:[NSString class]]){
            u.repeatSessions = [repeatSessions floatValue];
        }
        [repeatSessionsDaily addObject:u];
    }
    self.repeatSessionsDaily = repeatSessionsDaily;
    
    // RepeatSessions (Weekly)
    NSArray* repeatSessionsWeeklyArray = [appInfo objectForKey:@"Weekly"];
    NSMutableArray* repeatSessionsWeekly = [NSMutableArray array];
    for(NSDictionary* a in repeatSessionsWeeklyArray){
        NSString* beginDate      = [a objectForKey:@"beginDate"];
        NSString* endDate        = [a objectForKey:@"endDate"];
        NSString* newSessions    = [a objectForKey:@"newSessions"];
        NSString* repeatSessions = [a objectForKey:@"repeatSessions"];
        Sessions* u = [[Sessions alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([newSessions isKindOfClass:[NSString class]]){
            u.newSessions = [newSessions floatValue];
        }
        if([repeatSessions isKindOfClass:[NSString class]]){
            u.repeatSessions = [repeatSessions floatValue];
        }
        [repeatSessionsWeekly addObject:u];
    }
    self.repeatSessionsWeekly = repeatSessionsWeekly;
    
    // RepeatSessions (Monthly)
    NSArray* repeatSessionsMonthlyArray = [appInfo objectForKey:@"Monthly"];
    NSMutableArray* repeatSessionsMonthly = [NSMutableArray array];
    for(NSDictionary* a in repeatSessionsMonthlyArray){
        NSString* beginDate      = [a objectForKey:@"beginDate"];
        NSString* endDate        = [a objectForKey:@"endDate"];
        NSString* newSessions    = [a objectForKey:@"newSessions"];
        NSString* repeatSessions = [a objectForKey:@"repeatSessions"];
        Sessions* u = [[Sessions alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([newSessions isKindOfClass:[NSString class]]){
            u.newSessions = [newSessions floatValue];
        }
        if([repeatSessions isKindOfClass:[NSString class]]){
            u.repeatSessions = [repeatSessions floatValue];
        }
        [repeatSessionsMonthly addObject:u];
    }
    self.repeatSessionsMonthly = repeatSessionsMonthly;
}

//
// veam server
// posts
//
-(void)setDataPosts:(NSDictionary*)appInfo
{
    
    // Posts (Total)
    {
        NSDictionary* postsTotalDictionary = [appInfo objectForKey:@"Total"];
        NSString* beginDate = [postsTotalDictionary objectForKey:@"beginDate"];
        NSString* units    = [postsTotalDictionary objectForKey:@"count"];
        
        Unit* postsTotalUnits = [[Unit alloc] init];
        postsTotalUnits.beginDate = beginDate;
        if([units isKindOfClass:[NSString class]]){
            postsTotalUnits.units = [units floatValue];
        }
        self.postsTotalUnits = postsTotalUnits;
    }
    
    // Posts (Daily)
    NSArray* postsDailylyArray = [appInfo objectForKey:@"Daily"];
    NSMutableArray* postsDaily = [NSMutableArray array];
    for(NSDictionary* a in postsDailylyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [postsDaily addObject:u];
    }
    self.postsDaily = postsDaily;
    
    // Posts (Weekly)
    NSArray* postsWeeklyArray = [appInfo objectForKey:@"Weekly"];
    NSMutableArray* postsWeekly = [NSMutableArray array];
    for(NSDictionary* a in postsWeeklyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [postsWeekly addObject:u];
    }
    self.postsWeekly = postsWeekly;
    
    // Posts (Monthly)
    NSArray* postsMonthlyArray = [appInfo objectForKey:@"Monthly"];
    NSMutableArray* postsMonthly = [NSMutableArray array];
    for(NSDictionary* a in postsMonthlyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [postsMonthly addObject:u];
    }
    self.postsMonthly = postsMonthly;
}


//
// veam server
// comments
//
-(void)setDataComments:(NSDictionary*)appInfo
{
    // Comments (Total)
    {
        NSDictionary* commentsTotalDictionary = [appInfo objectForKey:@"Total"];
        NSString* beginDate = [commentsTotalDictionary objectForKey:@"beginDate"];
        NSString* units    = [commentsTotalDictionary objectForKey:@"count"];
        
        Unit* commentsTotalUnits = [[Unit alloc] init];
        commentsTotalUnits.beginDate = beginDate;
        if([units isKindOfClass:[NSString class]]){
            commentsTotalUnits.units = [units floatValue];
        }
        self.commentsTotalUnits = commentsTotalUnits;
    }
    
    // Comments (Daily)
    NSArray* commentsDailyArray = [appInfo objectForKey:@"Daily"];
    NSMutableArray* commentsDaily = [NSMutableArray array];
    for(NSDictionary* a in commentsDailyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [commentsDaily addObject:u];
    }
    self.commentsDaily = commentsDaily;
    
    // Comments (Weekly)
    NSArray* commentsWeeklyArray = [appInfo objectForKey:@"Weekly"];
    NSMutableArray* commentsWeekly = [NSMutableArray array];
    for(NSDictionary* a in commentsWeeklyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [commentsWeekly addObject:u];
    }
    self.commentsWeekly = commentsWeekly;
    
    // Comments (Monthly)
    NSArray* commentsMonthlyArray = [appInfo objectForKey:@"Monthly"];
    NSMutableArray* commentsMonthly = [NSMutableArray array];
    for(NSDictionary* a in commentsMonthlyArray){
        NSString* beginDate = [a objectForKey:@"beginDate"];
        NSString* endDate   = [a objectForKey:@"endDate"];
        NSString* units     = [a objectForKey:@"count"];
        Unit* u = [[Unit alloc]init];
        u.beginDate = beginDate;
        u.endDate  = endDate;
        if([units isKindOfClass:[NSString class]]){
            u.units = [units floatValue];
        }
        [commentsMonthly addObject:u];
    }
    self.commentsMonthly = commentsMonthly;
}


+(NSString*)roundingNumber:(CGFloat)num
{
    NSString* ret;
    
    if(num>=1000000000){
        ret = [NSString stringWithFormat:@"%.0fM", num/1000000];
        
    }
    else if(num>=1000000){
        ret = [NSString stringWithFormat:@"%.1fM", num/1000000];
        
    }
    else if(num>=100000){
        ret = [NSString stringWithFormat:@"%.0fK", num/1000];
    }
    else if(num>=1000){
        ret = [NSString stringWithFormat:@"%.1fK", num/1000];
    }
    else{
        ret = [NSString stringWithFormat:@"%.0f", num];
    }
    DLog(@"%.1f %@", num, ret);
    
    return ret;
}

-(void)setAppId:(NSString *)appId
{
    _appId = appId;
    self.screenNamePrefix = [NSString stringWithFormat:@"/%@/", self.appId];
}

@end
