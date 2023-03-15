//
//  SubCategory.m
//  veam31000000
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VideoSubCategory.h"

@implementation VideoSubCategory

@synthesize videoSubCategoryId ;
@synthesize videoCategoryId ;
@synthesize name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setVideoSubCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    [self setVideoCategoryId:[attributeDict objectForKey:@"c"]] ;

    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setVideoSubCategoryId:[results objectAtIndex:1]] ;
            //NSLog(@"set videoSubCategoryId:%@",self.videoSubCategoryId) ;
        }
    }
}


@end
