//
//  CalendarData.m
//  veam00000000
//
//  Created by veam on 7/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "CalendarData.h"
#import "VeamUtil.h"

@implementation CalendarData

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Pictures::parserDidStartDocument") ;
}

- (void)setup
{
    calendarDays = [[NSMutableArray alloc] init] ;
    monthlyContents = [[NSMutableArray alloc] init] ;
    mixeds = [[NSMutableArray alloc] init] ;
    
    mixedsForMixedId = [NSMutableDictionary dictionary] ;
    youtubesForYoutubeId = [NSMutableDictionary dictionary] ;
    videosForVideoId = [NSMutableDictionary dictionary] ;
    audiosForAudioId = [NSMutableDictionary dictionary] ;
    recipesForRecipeId = [NSMutableDictionary dictionary] ;
 
    dictionary = [NSMutableDictionary dictionary] ;
}

- (id)init
{
    self = [super init] ;
    if(self != nil){
        [self setup] ;
    }
    return self ;
}


- (id)initWithYear:(NSInteger)targetYear month:(NSInteger)targetMonth
{
    // load content
    year = targetYear ;
    month = targetMonth ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    NSString *fileName = [CalendarData getCacheFileName:year month:month] ;
    NSString *contentsStorePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    if ([fileManager fileExistsAtPath:contentsStorePath]) {
        //NSLog(@"config url : %@",contentsStorePath) ;
        NSURL *contentsFileUrl = [NSURL fileURLWithPath:contentsStorePath] ;
        self = [self initWithUrl:contentsFileUrl] ;
    } else {
        self = [self init] ;
    }
    return self ;
}

- (id)initWithUrl:(NSURL *)url ;
{
    self = [super init] ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url] ;
    [self startParsing:parser] ;
    
    return self ;
}

- (id)initWithData:(NSData *)data
{
    self = [super init] ;
    
    xmlData = data ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data] ;
    [self startParsing:parser] ;
    
    return self ;
}



- (id)initWithServerData:(NSInteger)targetYear month:(NSInteger)targetMonth
{
    year = targetYear ;
    month = targetMonth ;
    
    //NSString *urlString  = [NSString stringWithFormat:@"%@&c=%@",[VeamUtil getApiUrl:@"calendar/list"],[self getCalendarContentId:year month:month]] ;

    NSString *urlString  = [NSString stringWithFormat:@"%@&k=1&y=%d&m=%d&c=%@",[VeamUtil getApiUrl:@"calendar/list"],year,month,[self getStoredContentId]] ;
	//NSLog(@"urlString String url = %@",urlString) ;
    NSURL *url = [NSURL URLWithString:urlString] ;
    //NSLog(@"update url : %@",[url absoluteString]) ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
    NSURLResponse *response = nil ;
    NSError *error = nil ;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] ;
    
    // error
    NSString *error_str = [error localizedDescription] ;
    if (0 == [error_str length]) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        if(![string isEqualToString:@"NO_UPDATE"]){
            return [self initWithData:data] ; // analyze sync
        }
    }
    
    return [self init] ;
}


- (void)startParsing:(NSXMLParser *)parser
{
    [self setup] ;
    
    isParsing = YES ;
    
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError) {
        NSLog(@"error: %@", parseError);
    }
}



- (void)parseWithData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data] ;
    [self startParsing:parser] ;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    //NSLog(@"elementName=%@",elementName) ;
    if([elementName isEqualToString:@"list"]){
        contentId = [attributeDict objectForKey:@"id"] ;
        //NSLog(@"list id=%@",contentId) ;
    } else if([elementName isEqualToString:@"calendar_day"]){
        CalendarDay *calendarDay = [[CalendarDay alloc] initWithAttributes:attributeDict] ;
        [calendarDays addObject:calendarDay] ;
        //NSLog(@"add picture : %@ %@",[picture pictureId],[picture pictureUrl]) ;
        
    } else if([elementName isEqualToString:@"video"]){
        Video *video = [[Video alloc] initWithAttributes:attributeDict] ;
        [self addMixed:video.mixed] ;
        [videosForVideoId setObject:video forKey:[video videoId]] ;
        //NSLog(@"add video : %@ createdAt=%@ %@",video.title,video.createdAt,video.dataUrl) ;
        
    } else if([elementName isEqualToString:@"youtube"]){
        Youtube *youtube = [[Youtube alloc] initWithAttributes:attributeDict] ;
        [self addMixed:youtube.mixed] ;
        [youtubesForYoutubeId setObject:youtube forKey:[youtube youtubeId]] ;
        //NSLog(@"add youtube video : %@ %@",[youtube youtubeId],[youtube title]) ;
        
    } else if([elementName isEqualToString:@"audio"]){
        Audio *audio = [[Audio alloc] initWithAttributes:attributeDict] ;
        [self addMixed:audio.mixed] ;
        [audiosForAudioId setObject:audio forKey:[audio audioId]] ;
        //NSLog(@"add audio : %@ createdAt=%@ %@",audio.title,audio.createdAt,audio.dataUrl) ;
        
    } else if([elementName isEqualToString:@"recipe"]){
        Recipe *recipe = [[Recipe alloc] initWithAttributes:attributeDict] ;
        [self addMixed:recipe.mixed] ;
        [recipesForRecipeId setObject:recipe forKey:[recipe recipeId]] ;
        //NSLog(@"add recipe : %@ %@",[recipe recipeCategoryId],[recipe title]) ;

    } else {
        NSString *value = [attributeDict objectForKey:@"value"];
        if(value != nil){
            //NSLog(@"elementName=%@ value=%@",elementName,value) ;
            [dictionary setObject:value forKey:elementName] ;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Pictures::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"CalendarData::parserDidEndDocument") ;
    [parser setDelegate:nil] ;
    
    if([self isValid]){
        BOOL shouldStoreContentId = YES ;
        
        NSArray *monthlyContentIds = [[self getValueForKey:@"monthly_contents"] componentsSeparatedByString:@"_"] ;
        NSInteger count = [monthlyContentIds count] ;
        for(int index = 0 ; index < count ; index++){
            NSString *mixedId = [monthlyContentIds objectAtIndex:index] ;
            Mixed *mixed = [mixedsForMixedId valueForKey:mixedId] ;
            if(mixed != nil){
                [monthlyContents addObject:[mixedsForMixedId valueForKey:mixedId]] ;
                //NSLog(@"add monthly content mixed=%@",mixedId) ;
            }
        }
        
        if(xmlData != nil){
            NSFileManager *fileManager = [NSFileManager defaultManager] ;
            NSString *workFileName = [NSString stringWithFormat:@"%@.work",[CalendarData getCacheFileName:year month:month]] ;
            NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:workFileName] ;
            [fileManager createFileAtPath:workFilePath contents:[NSData data] attributes:nil] ;
            NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:workFilePath] ;
            [file writeData:xmlData] ;
            [file closeFile] ;
            BOOL moved = [VeamUtil moveFile:workFilePath toPath:[VeamUtil getFilePathAtCachesDirectory:[CalendarData getCacheFileName:year month:month]]] ;
            if(!moved){
                shouldStoreContentId = NO ;
            }
        }
        
        if(shouldStoreContentId){
            [self storeContentId] ;
        }
    }
    
    isParsing = NO ;
}

- (NSString *)getContentIdKey
{
    return [NSString stringWithFormat:@"CALENDAR_CONTENT_ID_%d_%d",year,month] ;
}

- (void)storeContentId
{
    //NSLog(@"storeContentId") ;
    if(![VeamUtil isEmpty:contentId]){
        [VeamUtil setUserDefaultString:[self getContentIdKey] value:contentId] ;
    }
}

- (NSString *)getStoredContentId
{
    return [VeamUtil getUserDefaultString:[self getContentIdKey]] ;
}


- (BOOL)isValid
{
    BOOL retValue = NO ;
    NSString *checkValue = [self getValueForKey:@"check"] ;
    if(![VeamUtil isEmpty:checkValue] && [checkValue isEqualToString:@"OK"]){
        retValue = YES ;
    }
    return retValue ;
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // エレメントの文字データを string で取得
}

- (CalendarDay *)getCalendarDayForYear:(NSInteger)targetYear month:(NSInteger)targetMonth day:(NSInteger)targetDay
{
    NSInteger count = [calendarDays count] ;
    CalendarDay *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        CalendarDay *calendarDay = [calendarDays objectAtIndex:index] ;
        if(([[calendarDay year] integerValue] == targetYear) &&
           ([[calendarDay month] integerValue] == targetMonth) &&
           ([[calendarDay day] integerValue] == targetDay)){
            retValue = calendarDay ;
            break ;
        }
    }
    return retValue ;
}

- (Mixed *)getMixedForId:(NSString *)mixedId
{
    Mixed *retValue = nil ;
    NSInteger count = [mixeds count] ;
    for(int index = 0 ; index < count ; index++){
        Mixed *mixed = [mixeds objectAtIndex:index] ;
        if([mixed.mixedId isEqualToString:mixedId]){
            retValue = mixed ;
            break ;
        }
    }
    return retValue ;
}

- (Youtube *)getYoutubeForId:(NSString *)youtubeId
{
    return [youtubesForYoutubeId objectForKey:youtubeId ] ;
}

- (Audio *)getAudioForId:(NSString *)audioId
{
    return [audiosForAudioId objectForKey:audioId ] ;
}

- (Video *)getVideoForId:(NSString *)videoId
{
    return [videosForVideoId objectForKey:videoId ] ;
}

- (Recipe *)getRecipeForId:(NSString *)recipeId
{
    return [recipesForRecipeId objectForKey:recipeId ] ;
}


- (NSString *)getValueForKey:(NSString *)key
{
    //NSLog(@"key=%@",key) ;
    NSString *value = [dictionary objectForKey:key] ;
    return value ;
}

- (NSArray *)getMonthlyContents
{
    return monthlyContents ;
}

- (void)setValueForKey:(NSString *)key value:(NSString *)value
{
    //NSLog(@"setValueForKey %@ %@",key,value) ;
    [dictionary setObject:value forKey:key] ;
}

+ (NSString *)getCacheFileName:(NSInteger)targetYear month:(NSInteger)targetMonth
{
    return [NSString stringWithFormat:@"cal%04d%02d.xml",targetYear,targetMonth] ;
}

+ (BOOL)cacheExists:(NSInteger)targetYear month:(NSInteger)targetMonth
{
    BOOL retValue = NO ;
    NSString *fileName = [CalendarData getCacheFileName:targetYear month:targetMonth] ;
    NSString *contentsStorePath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    if ([fileManager fileExistsAtPath:contentsStorePath]) {
        //NSLog(@"config url : %@",contentsStorePath) ;
        retValue = YES ;
    }
    
    return retValue ;
}

- (void)addMixed:(Mixed *)mixed
{
    
    if((mixed != nil) && ![VeamUtil isEmpty:mixed.mixedId]){
        [mixeds addObject:mixed] ;
        [mixedsForMixedId setObject:mixed forKey:[mixed mixedId]] ;
        
        //NSLog(@"add mixed : %@ %@",[mixed mixedId],[mixed title]) ;
    }
}

@end

