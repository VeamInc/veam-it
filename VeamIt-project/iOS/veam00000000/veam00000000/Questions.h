//
//  Questions.h
//  veam31000016
//
//  Created by veam on 4/23/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "Video.h"

#define VEAM_QUESTION_KIND_DATE         1
#define VEAM_QUESTION_KIND_RATING       2
#define VEAM_QUESTION_KIND_ANSWER_DATE  3

@interface Questions : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary* dictionary ;
    NSMutableArray* questionsDate ;
    NSMutableArray* questionsRating ;
    NSMutableArray* questionsAnswerDate ;
    NSMutableArray *likeQuestions ;
    NSMutableDictionary *videosForId ;
    NSMutableDictionary *youtubeVideosForId ;
    BOOL isParsing ;
    BOOL questionsDateLoaded ;
    BOOL questionsRatingLoaded ;
    BOOL questionsAnswerDateLoaded ;
    
    
}

- (id)init ;
- (id)initWithAnswers:(NSMutableArray *)answers ;
- (void)parseWithData:(NSData *)data ;
- (NSInteger)getNumberOfQuestions:(NSInteger)kind ;
- (Question *)getQuestionAt:(NSInteger)index kind:(NSInteger)kind ;
- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;
- (void)deleteQuestion:(Question *)question kind:(NSInteger)kind ;
- (BOOL)noMoreQuestions:(NSInteger)kind ;
- (BOOL)isLike:(NSString *)questionId ;
- (void)setIsLike:(BOOL)isLike questionId:(NSString *)questionId ;
- (Video *)getVideoForid:(NSString *)videoId ;
- (void)save ;
- (void)load ;


@end
