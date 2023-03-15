//
//  Category.m
//  veam31000000
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "AudioCategory.h"

@implementation AudioCategory

@synthesize audioCategoryId ;
@synthesize name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setAudioCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;

    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setAudioCategoryId:[results objectAtIndex:1]] ;
            //NSLog(@"set audioCategoryId:%@",self.audioCategoryId) ;
        }
    }
}

@end
