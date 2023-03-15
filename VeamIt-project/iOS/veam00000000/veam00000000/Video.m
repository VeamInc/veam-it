//
//  Video.m
//  veam31000000
//
//  Created by veam on 2/27/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "Video.h"

@implementation Video

@synthesize mixed ;
@synthesize videoId ;
@synthesize duration ;
@synthesize title ;
@synthesize kind ;
@synthesize videoCategoryId ;
@synthesize videoSubCategoryId ;
@synthesize imageUrl ;
@synthesize imageSize ;
@synthesize dataUrl ;
@synthesize dataSize ;
@synthesize key ;
@synthesize description ;
@synthesize linkUrl ;
@synthesize createdAt ;
@synthesize status ;
@synthesize statusText ;


- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setVideoId:[attributeDict objectForKey:@"id"]] ;
    [self setDuration:[attributeDict objectForKey:@"d"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setKind:[attributeDict objectForKey:@"k"]] ;
    [self setVideoCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setVideoSubCategoryId:[attributeDict objectForKey:@"s"]] ;
    [self setImageUrl:[attributeDict objectForKey:@"i"]] ;
    [self setImageSize:[attributeDict objectForKey:@"is"]] ;
    [self setDataUrl:[attributeDict objectForKey:@"v"]] ;
    [self setDataSize:[attributeDict objectForKey:@"vs"]] ;
    [self setKey:[attributeDict objectForKey:@"vk"]] ;
    [self setLinkUrl:[attributeDict objectForKey:@"l"]] ;
    [self setSourceUrl:[attributeDict objectForKey:@"su"]] ;
    [self setCreatedAt:[attributeDict objectForKey:@"cr"]] ;
    [self setStatus:[attributeDict objectForKey:@"st"]] ;
    [self setStatusText:[attributeDict objectForKey:@"stt"]] ;
    
    mixed = [[Mixed alloc] init] ;
    [mixed setMixedId:[attributeDict objectForKey:@"mi"]] ;
    [mixed setTitle:[attributeDict objectForKey:@"t"]] ;
    [mixed setMixedCategoryId:[attributeDict objectForKey:@"mc"]] ;
    [mixed setMixedSubCategoryId:[attributeDict objectForKey:@"ms"]] ;
    [mixed setKind:[attributeDict objectForKey:@"mk"]] ;
    [mixed setThumbnailUrl:[attributeDict objectForKey:@"mt"]] ;
    [mixed setCreatedAt:[attributeDict objectForKey:@"cr"]] ;
    [mixed setContentId:self.videoId] ;
    [mixed setDisplayType:[attributeDict objectForKey:@"mdt"]] ;
    [mixed setDisplayName:[attributeDict objectForKey:@"mdn"]] ;

    //NSLog(@"video created at = %@",[attributeDict objectForKey:@"cr"]) ;
    //NSLog(@"video mixed id = %@",[attributeDict objectForKey:@"mi"]) ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 3){
        //NSLog(@"count >= 3") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setVideoId:[results objectAtIndex:1]] ;
            //NSLog(@"set videoId:%@",self.videoId) ;
            [self.mixed setMixedId:[results objectAtIndex:2]] ;
            //NSLog(@"set mixedId:%@",self.mixed.mixedId) ;
            if([results count] >= 6){
                [self setStatus:[results objectAtIndex:3]] ;
                //NSLog(@"set status:%@",self.status) ;
                [self setStatusText:[results objectAtIndex:4]] ;
                //NSLog(@"set statusText:%@",self.statusText) ;
                [self setImageUrl:[results objectAtIndex:5]] ;
                //NSLog(@"set imageUrl:%@",self.imageUrl) ;
            }
        }
    }
}


@end
