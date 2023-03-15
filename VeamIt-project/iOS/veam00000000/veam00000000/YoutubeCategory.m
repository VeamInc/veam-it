//
//  YoutubeCategory.m
//  veam31000000
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "YoutubeCategory.h"

@implementation YoutubeCategory

@synthesize youtubeCategoryId ;
@synthesize name ;
@synthesize kind ;
@synthesize embed ;
@synthesize embedUrl ;
@synthesize disabled ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setYoutubeCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    [self setKind:[attributeDict objectForKey:@"kind"]] ;
    [self setEmbed:[attributeDict objectForKey:@"e"]] ;
    [self setEmbedUrl:[attributeDict objectForKey:@"u"]] ;
    [self setDisabled:[attributeDict objectForKey:@"d"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setYoutubeCategoryId:[results objectAtIndex:1]] ;
            //NSLog(@"set youtubeCategoryId:%@",self.youtubeCategoryId) ;
        }
    }
}

@end
