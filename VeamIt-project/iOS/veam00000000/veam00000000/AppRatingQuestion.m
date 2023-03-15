//
//  AppRatingQuestion.m
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppRatingQuestion.h"
#import "ConsoleUtil.h"

@implementation AppRatingQuestion

@synthesize appRatingQuestionId ;
@synthesize question ;
@synthesize questionJa ;
@synthesize selections ;
@synthesize selectionsJa ;
@synthesize answer ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setAppRatingQuestionId:[attributeDict objectForKey:@"id"]] ;
    [self setQuestion:[attributeDict objectForKey:@"q"]] ;
    [self setQuestionJa:[attributeDict objectForKey:@"qj"]] ;
    [self setSelections:[attributeDict objectForKey:@"s"]] ;
    [self setSelectionsJa:[attributeDict objectForKey:@"sj"]] ;
    [self setAnswer:[attributeDict objectForKey:@"a"]] ;
    
    return self ;
}

- (NSString *)getQuestionString
{
    NSString *retValue = question ;
    if([ConsoleUtil isLocaleJapanese]){
        retValue = questionJa ;
    }
    return retValue ;
}

- (NSString *)getSelectionString
{
    NSString *retValue = selections ;
    if([ConsoleUtil isLocaleJapanese]){
        retValue = selectionsJa ;
    }
    return retValue ;
}


- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 1){
        //NSLog(@"count >= 1") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
        }
    }
}

@end
