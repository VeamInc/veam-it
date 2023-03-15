//
//  Questions.m
//  veam31000016
//
//  Created by veam on 4/23/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "Questions.h"
#import "Video.h"
#import "VeamUtil.h"

@implementation Questions

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Follows::parserDidStartDocument") ;
}

- (void)setup
{
    questionsDate = [[NSMutableArray alloc] init] ;
    questionsRating = [[NSMutableArray alloc] init] ;
    questionsAnswerDate = [[NSMutableArray alloc] init] ;
    dictionary = [NSMutableDictionary dictionary] ;
    likeQuestions = [NSMutableArray array] ;
    videosForId = [NSMutableDictionary dictionary] ;
    youtubeVideosForId = [NSMutableDictionary dictionary] ;
}

- (id)init
{
    self = [super init] ;
    if(self != nil){
        [self setup] ;
    }
    return self ;
}

- (id)initWithAnswers:(NSMutableArray *)answers
{
    self = [super init] ;
    if(self != nil){
        [self setup] ;
        questionsAnswerDate = answers ;
        questionsAnswerDateLoaded = YES ;
    }
    return self ;
}

- (void)parseWithData:(NSData *)data
{
    isParsing = YES ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data] ;
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

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    //NSLog(@"elementName=%@",elementName) ;
    if([elementName isEqualToString:@"question"]){
        // <question id="3" kind="2" u="22" n="veam03" q="Test3" l="2" ak="0" aid="0" at="0" ct="1398154755" />
        Question *question = [[Question alloc] initWithAttributes:attributeDict] ;
        [self addQuestion:question] ;
        
    } else if([elementName isEqualToString:@"page"]){
        // <page kind="1" no="1" is_last_page="0" />
        BOOL lastPageLoaded ;
        NSString *isLastPage = [attributeDict objectForKey:@"is_last_page"];
        if([isLastPage intValue] == 1){
            lastPageLoaded = YES ;
        } else {
            lastPageLoaded = NO ;
        }
        
        NSString *kindString = [attributeDict objectForKey:@"kind"] ;
        NSInteger kind = [kindString integerValue] ;
        switch (kind) {
            case VEAM_QUESTION_KIND_DATE:
                questionsDateLoaded = lastPageLoaded ;
                break;
            case VEAM_QUESTION_KIND_RATING:
                questionsRatingLoaded = lastPageLoaded ;
                break;
            case VEAM_QUESTION_KIND_ANSWER_DATE:
                questionsAnswerDateLoaded = lastPageLoaded ;
                break;
                
            default:
                break;
        }
    } else if([elementName isEqualToString:@"question_like"]){
        NSString *value = [attributeDict objectForKey:@"value"];
        likeQuestions =  [[NSMutableArray alloc] initWithArray:[value componentsSeparatedByString:@","]] ;
    } else if([elementName isEqualToString:@"video"]){
        Video *video = [[Video alloc] init] ;
        NSString *categoryId = [attributeDict objectForKey:@"c"] ;
        NSString *subCategoryId = [attributeDict objectForKey:@"s"] ;
        [video setVideoId:[attributeDict objectForKey:@"id"]] ;
        [video setDuration:[attributeDict objectForKey:@"d"]] ;
        [video setTitle:[attributeDict objectForKey:@"t"]] ;
        [video setVideoCategoryId:categoryId] ;
        [video setVideoSubCategoryId:subCategoryId] ;
        [video setImageUrl:[attributeDict objectForKey:@"i"]] ;
        [video setImageSize:[attributeDict objectForKey:@"is"]] ;
        [video setDataUrl:[attributeDict objectForKey:@"v"]] ;
        [video setDataSize:[attributeDict objectForKey:@"vs"]] ;
        [video setKey:[attributeDict objectForKey:@"vk"]] ;
        [video setLinkUrl:[attributeDict objectForKey:@"l"]] ;
        
        [videosForId setObject:video forKey:[video videoId]] ;

        //NSLog(@"add video : %@ %@",[video videoId],[video title]) ;
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
    //NSLog(@"Follows::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"Follows::parserDidEndDocument") ;
    [parser setDelegate:nil] ;
    isParsing = NO ;
}

- (BOOL)isLike:(NSString *)questionId
{
    BOOL retValue = NO ;
    int count = [likeQuestions count] ;
    for(int index = 0 ; index < count ; index++){
        NSString *workId = [likeQuestions objectAtIndex:index] ;
        if([questionId isEqualToString:workId]){
            retValue = YES ;
            break ;
        }
    }
    return retValue ;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // エレメントの文字データを string で取得
}

- (NSMutableArray *)getQuestionsForKind:(NSInteger)kind
{
    NSMutableArray *questions = nil ;
    switch (kind) {
        case VEAM_QUESTION_KIND_DATE:
            questions = questionsDate ;
            break;
        case VEAM_QUESTION_KIND_RATING:
            questions = questionsRating ;
            break;
        case VEAM_QUESTION_KIND_ANSWER_DATE:
            questions = questionsAnswerDate ;
            break;
            
        default:
            break;
    }
    return questions ;
    
}

- (Video *)getVideoForid:(NSString *)videoId
{
    Video *retValue = nil ;
    retValue = [videosForId objectForKey:videoId] ;
    return retValue ;
}

- (Question *)getQuestionForId:(NSString *)questionId kind:(NSInteger)kind
{
    NSMutableArray *questions = [self getQuestionsForKind:kind] ;
    NSInteger count = [questions count] ;
    Question *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        Question *question = [questions objectAtIndex:index] ;
        if([[question questionId] isEqualToString:questionId]){
            retValue = question ;
            break ;
        }
    }
    return retValue ;
}

- (void)addQuestion:(Question *)question
{
    NSInteger kind = [[question kind] integerValue] ;
    Question *workQuestion = [self getQuestionForId:[question questionId] kind:kind] ;
    if(workQuestion == nil){
        NSMutableArray *questions = [self getQuestionsForKind:kind] ;
        [questions addObject:question] ;
    }
}

- (NSInteger)getQuestionIndexForId:(NSString *)questionId kind:(NSInteger)kind
{
    NSMutableArray *questions = [self getQuestionsForKind:kind] ;
    NSInteger count = [questions count] ;
    NSInteger retValue = -1 ;
    for(int index = 0 ; index < count ; index++){
        Question *question = [questions objectAtIndex:index] ;
        if([[question questionId] isEqualToString:questionId]){
            retValue = index ;
            break ;
        }
    }
    return retValue ;
}

- (NSString *)getValueForKey:(NSString *)key
{
    //NSLog(@"key=%@",key) ;
    NSString *value = [dictionary objectForKey:key] ;
    return value ;
}

- (void)setValueForKey:(NSString *)key value:(NSString *)value
{
    //NSLog(@"setValueForKey %@ %@",key,value) ;
    [dictionary setObject:value forKey:key] ;
}

- (NSInteger)getNumberOfQuestions:(NSInteger)kind
{
    return [[self getQuestionsForKind:kind] count] ;
}

- (Question *)getQuestionAt:(NSInteger)index kind:(NSInteger)kind
{
    Question *retValue = nil ;
    NSMutableArray *questions = [self getQuestionsForKind:kind] ;
    if(index < [questions count]){
        retValue = [questions objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)deleteQuestion:(Question *)question kind:(NSInteger)kind
{
    if(question != nil){
        
        [[self getQuestionsForKind:kind] removeObject:question] ;
    }
}

- (BOOL)noMoreQuestions:(NSInteger)kind
{
    BOOL retValue = NO ;
    
    switch (kind) {
        case VEAM_QUESTION_KIND_DATE:
            retValue = questionsDateLoaded ;
            break;
        case VEAM_QUESTION_KIND_RATING:
            retValue = questionsRatingLoaded ;
            break;
        case VEAM_QUESTION_KIND_ANSWER_DATE:
            retValue = questionsAnswerDateLoaded ;
            break;
            
        default:
            break;
    }

    return retValue ;
}

- (void)addNumberOfLike:(Question *)question count:(NSInteger)count
{
    if(question != nil){
        NSInteger numberOfLikes = [[question numberOfLikes] integerValue] ;
        numberOfLikes += count ;
        [question setNumberOfLikes:[NSString stringWithFormat:@"%d",numberOfLikes]] ;
    }
}

- (void)addNumberOfLikeForAllKind:(NSString *)questionId count:(NSInteger)count
{
    [self addNumberOfLike:[self getQuestionForId:questionId kind:VEAM_QUESTION_KIND_DATE] count:count] ;
    [self addNumberOfLike:[self getQuestionForId:questionId kind:VEAM_QUESTION_KIND_RATING] count:count] ;
    [self addNumberOfLike:[self getQuestionForId:questionId kind:VEAM_QUESTION_KIND_ANSWER_DATE] count:count] ;
}

- (void)setIsLike:(BOOL)isLike questionId:(NSString *)questionId
{
    if(isLike){
        [likeQuestions addObject:questionId] ;
        [self addNumberOfLikeForAllKind:questionId count:1] ;
    } else {
        [likeQuestions removeObject:questionId] ;
        [self addNumberOfLikeForAllKind:questionId count:-1] ;
    }
}


- (void)save
{
    NSMutableArray *questionIds = [NSMutableArray array] ;
    int count = [questionsAnswerDate count] ;
    //NSLog(@"Answers::save %d",count) ;
    for(int index = 0 ; index < count ; index++){
        Question *question = [questionsAnswerDate objectAtIndex:index] ;
        [question save] ;
        [questionIds addObject:[question questionId]] ;
    }
    [VeamUtil setQuestionIds:questionIds] ;
}

- (void)load
{
    //NSLog(@"Answers::load") ;
    NSArray *questionIds = [VeamUtil getQuestionIds] ;
    int count = [questionIds count] ;
    [self setup] ;
    for(int index = 0 ; index < count ; index++){
        NSString *questionId = [questionIds objectAtIndex:index] ;
        //NSLog(@"answerId:%@",answerId) ;
        Question *question = [[Question alloc] initWithQuestionId:questionId] ;
        [self addQuestion:question] ;
    }
    questionsDateLoaded = YES ;
    questionsRatingLoaded = YES ;
    questionsAnswerDateLoaded = YES ;
}



@end
