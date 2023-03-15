//
//  TemplateYoutube.m
//  veam00000000
//
//  Created by veam on 6/3/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "TemplateYoutube.h"

@implementation TemplateYoutube

@synthesize templateYoutubeId ;
@synthesize title ;
@synthesize leftImageUrl ;
@synthesize rightImageUrl ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setTemplateYoutubeId:[attributeDict objectForKey:@"id"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setEmbedFlag:[attributeDict objectForKey:@"e"]] ;
    [self setEmbedUrl:[attributeDict objectForKey:@"u"]] ;
    [self setLeftImageUrl:[attributeDict objectForKey:@"l"]] ;
    [self setRightImageUrl:[attributeDict objectForKey:@"r"]] ;
    
    return self ;
}


- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 4){
        //NSLog(@"count >= 4") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setLeftImageUrl:[results objectAtIndex:2]] ;
            [self setRightImageUrl:[results objectAtIndex:3]] ;
            //NSLog(@"set leftImageUrl:%@",self.leftImageUrl) ;
            //NSLog(@"set rightImageUrl:%@",self.rightImageUrl) ;
        }
    }
}


@end
