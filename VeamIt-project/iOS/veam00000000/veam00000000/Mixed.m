//
//  Mixed.m
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "Mixed.h"

@implementation Mixed

@synthesize mixedId ;
@synthesize kind ;
@synthesize mixedCategoryId ;
@synthesize mixedSubCategoryId ;
@synthesize title ;
@synthesize contentId ;
@synthesize thumbnailUrl ;
@synthesize createdAt ;
@synthesize displayType ;
@synthesize displayName ;
@synthesize status ;
@synthesize statusText ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setMixedId:[attributeDict objectForKey:@"id"]] ;
    [self setKind:[attributeDict objectForKey:@"k"]] ;
    [self setMixedCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setMixedSubCategoryId:[attributeDict objectForKey:@"s"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setContentId:[attributeDict objectForKey:@"ci"]] ;
    [self setDisplayType:[attributeDict objectForKey:@"dt"]] ;
    [self setStatus:[attributeDict objectForKey:@"st"]] ;
    [self setStatusText:[attributeDict objectForKey:@"stt"]] ;
    [self setThumbnailUrl:[attributeDict objectForKey:@"th"]] ;
    [self setCreatedAt:[attributeDict objectForKey:@"ct"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 3){
        //NSLog(@"count >= 3") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setMixedId:[results objectAtIndex:1]] ;
            [self setContentId:[results objectAtIndex:2]] ;
            //NSLog(@"set mixedId:%@ contentId:%@",self.mixedId,self.contentId) ;
            if([results count] >= 6){
                [self setStatus:[results objectAtIndex:3]] ;
                //NSLog(@"set status:%@",self.status) ;
                [self setStatusText:[results objectAtIndex:4]] ;
                //NSLog(@"set statusText:%@",self.statusText) ;
                [self setThumbnailUrl:[results objectAtIndex:5]] ;
                //NSLog(@"set imageUrl:%@",self.imageUrl) ;
            }
        }
    }
}


@end
