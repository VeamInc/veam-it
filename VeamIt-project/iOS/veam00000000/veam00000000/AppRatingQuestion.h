//
//  AppRatingQuestion.h
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRatingQuestion : NSObject

@property (nonatomic, retain) NSString *appRatingQuestionId ;
@property (nonatomic, retain) NSString *question ;
@property (nonatomic, retain) NSString *questionJa ;
@property (nonatomic, retain) NSString *selections ;
@property (nonatomic, retain) NSString *selectionsJa ;
@property (nonatomic, retain) NSString *answer ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

- (NSString *)getQuestionString ;
- (NSString *)getSelectionString ;


@end
