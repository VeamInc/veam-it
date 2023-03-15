//
//  Question.m
//  veam31000016
//
//  Created by veam on 4/23/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "Question.h"
#import "VeamUtil.h"

@implementation Question

@synthesize questionId ;
@synthesize kind ;
@synthesize title ;
@synthesize text ;
@synthesize numberOfLikes ;
@synthesize answerKind ;
@synthesize answerId ;
@synthesize answeredAt ;
@synthesize createdAt ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setQuestionId:[attributeDict objectForKey:@"id"]] ;
    [self setKind:[attributeDict objectForKey:@"kind"]] ;
    [self setSocialUserId:[attributeDict objectForKey:@"u"]] ;
    [self setSocialUserName:[attributeDict objectForKey:@"n"]] ;
    [self setText:[attributeDict objectForKey:@"q"]] ;
    [self setNumberOfLikes:[attributeDict objectForKey:@"l"]] ;
    [self setAnswerKind:[attributeDict objectForKey:@"ak"]] ;
    [self setAnswerId:[attributeDict objectForKey:@"aid"]] ;
    [self setAnsweredAt:[attributeDict objectForKey:@"at"]] ;
    [self setCreatedAt:[attributeDict objectForKey:@"ct"]] ;
    
    //NSLog(@"question created at = %@",[attributeDict objectForKey:@"cr"]) ;
    //NSLog(@"question answer id = %@",[attributeDict objectForKey:@"aid"]) ;
    
    return self ;
}



- (id)initWithQuestionId:(NSString *)targetQuestionId
{
    self = [super init];
    if (self) {
        // Initialization code
        [self load:targetQuestionId] ;
    }
    return self;
}

- (void)save
{
    [VeamUtil setQuestionString:[self getQuestionString] questionId:questionId] ;
}

- (void)load:(NSString *)targetQuestionId
{
    NSString *questionString = [VeamUtil getQuestionStringForQuestionId:targetQuestionId] ;
    //NSLog(@"Question::load QuestionString:%@",QuestionString) ;
    if(![VeamUtil isEmpty:questionString]){
        self.questionId = targetQuestionId ;
        [self setQuestionString:questionString] ;
    }
}

#define QUESTION_STRING_DELIMITER @"_<;<_"

- (void)setQuestionString:(NSString *)questionString
{
    NSArray *elements = [questionString componentsSeparatedByString:QUESTION_STRING_DELIMITER] ;
    if([elements count] >= 8){
        kind = elements[0] ;
        title = elements[1] ;
        text = elements[2] ;
        numberOfLikes = elements[3] ;
        answerKind = elements[4] ;
        answerId = elements[5] ;
        answeredAt = elements[6] ;
        createdAt = elements[7] ;

    }
}

- (NSString *)getQuestionString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
            kind,QUESTION_STRING_DELIMITER,
            title,QUESTION_STRING_DELIMITER,
            text,QUESTION_STRING_DELIMITER,
            numberOfLikes,QUESTION_STRING_DELIMITER,
            answerKind,QUESTION_STRING_DELIMITER,
            answerId,QUESTION_STRING_DELIMITER,
            answeredAt,QUESTION_STRING_DELIMITER,
            createdAt] ;
}

@end
