//
//  Question.h
//  veam31000016
//
//  Created by veam on 4/23/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, retain) NSString *questionId ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *socialUserId ;
@property (nonatomic, retain) NSString *socialUserName ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *text ;
@property (nonatomic, retain) NSString *numberOfLikes ;
@property (nonatomic, retain) NSString *answerKind ;
@property (nonatomic, retain) NSString *answerId ;
@property (nonatomic, retain) NSString *answeredAt ;
@property (nonatomic, retain) NSString *createdAt ;


- (void)save ;
- (void)load:(NSString *)targetQuestionId ;
- (id)initWithAttributes:(NSDictionary *)attributeDict ;
- (id)initWithQuestionId:(NSString *)targetQuestionId ;

@end
