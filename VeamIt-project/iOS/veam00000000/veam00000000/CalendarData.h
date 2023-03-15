//
//  CalendarData.h
//  veam00000000
//
//  Created by veam on 7/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDay.h"
#import "Mixed.h"
#import "Youtube.h"
#import "Video.h"
#import "Audio.h"
#import "Recipe.h"

@interface CalendarData : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary *dictionary ;
    
    NSMutableArray *calendarDays ;
    NSMutableArray *monthlyContents ;
    
    //// mixed
    NSMutableArray *mixeds ;
    NSMutableDictionary *mixedsForMixedId ;
    
    //// youtube
    NSMutableDictionary *youtubesForYoutubeId ;
    
    //// video
    NSMutableDictionary *videosForVideoId ;
    
    //// audio
    NSMutableDictionary *audiosForAudioId ;
    
    //// recipe
    NSMutableDictionary *recipesForRecipeId ;
    
    
    BOOL isParsing ;
    NSData *xmlData ;
    NSInteger year ;
    NSInteger month ;
    NSString *contentId ;

}

- (id)init ;
- (id)initWithYear:(NSInteger)targetYear month:(NSInteger)targetMonth ;
- (id)initWithServerData:(NSInteger)targetYear month:(NSInteger)targetMonth ;
- (void)parseWithData:(NSData *)data ;
- (CalendarDay *)getCalendarDayForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day ;
- (NSString *)getValueForKey:(NSString *)key ;
- (NSArray *)getMonthlyContents ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;
- (Mixed *)getMixedForId:(NSString *)mixedId ;
- (Youtube *)getYoutubeForId:(NSString *)youtubeId ;
- (Audio *)getAudioForId:(NSString *)audioId ;
- (Video *)getVideoForId:(NSString *)videoId ;
- (Recipe *)getRecipeForId:(NSString *)recipeId ;
+ (BOOL)cacheExists:(NSInteger)targetYear month:(NSInteger)targetMonth ;
- (BOOL)isValid ;

@end
