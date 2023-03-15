//
//  TemplateSubscription.m
//  veam00000000
//
//  Created by veam on 6/17/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "TemplateSubscription.h"
#import "VeamUtil.h"

@implementation TemplateSubscription

@synthesize templateSubscriptionId ;
@synthesize title ;
@synthesize layout ;
@synthesize price ;
@synthesize kind ;
@synthesize rightImageUrl ;
@synthesize uploadSpan ;
@synthesize isFree ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setTemplateSubscriptionId:[attributeDict objectForKey:@"id"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setLayout:[attributeDict objectForKey:@"l"]] ;
    [self setKind:[attributeDict objectForKey:@"k"]] ;
    [self setPrice:[attributeDict objectForKey:@"p"]] ;
    [self setRightImageUrl:[attributeDict objectForKey:@"r"]] ;
    NSString *workUploadSpan = [attributeDict objectForKey:@"u"] ;
    if([VeamUtil isEmpty:workUploadSpan]){
        [self setUploadSpan:@"7"] ;
    } else {
        [self setUploadSpan:workUploadSpan] ;
    }

    NSString *workIsFree = [attributeDict objectForKey:@"f"] ;
    if([VeamUtil isEmpty:workIsFree]){
        [self setIsFree:@"0"] ;
    } else {
        [self setIsFree:workIsFree] ;
    }

    return self ;
}


- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setRightImageUrl:[results objectAtIndex:1]] ;
            //NSLog(@"set rightImageUrl:%@",self.rightImageUrl) ;
        }
    }
}


@end
