//
//  Youtube.m
//  veam31000000
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Youtube.h"

@implementation Youtube

@synthesize mixed ;
@synthesize youtubeId ;
@synthesize kind ;
@synthesize duration ;
@synthesize title ;
@synthesize youtubeCategoryId ;
@synthesize youtubeSubCategoryId ;
@synthesize youtubeVideoId ;
@synthesize description ;
@synthesize isNew ;
@synthesize linkUrl ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setYoutubeId:[attributeDict objectForKey:@"id"]] ;
    [self setKind:[attributeDict objectForKey:@"k"]] ;
    [self setDuration:[attributeDict objectForKey:@"d"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setDescription:[attributeDict objectForKey:@"e"]] ;
    [self setYoutubeCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setYoutubeSubCategoryId:[attributeDict objectForKey:@"s"]] ;
    [self setYoutubeVideoId:[attributeDict objectForKey:@"v"]] ;
    [self setIsNew:[attributeDict objectForKey:@"n"]] ;
    [self setLinkUrl:[attributeDict objectForKey:@"l"]] ;
    
    mixed = [[Mixed alloc] init] ;
    [mixed setMixedId:[attributeDict objectForKey:@"mi"]] ;
    [mixed setTitle:[attributeDict objectForKey:@"t"]] ;
    [mixed setMixedCategoryId:[attributeDict objectForKey:@"mc"]] ;
    [mixed setMixedSubCategoryId:[attributeDict objectForKey:@"ms"]] ;
    [mixed setKind:[attributeDict objectForKey:@"mk"]] ;
    [mixed setThumbnailUrl:[attributeDict objectForKey:@"mt"]] ;
    [mixed setCreatedAt:[attributeDict objectForKey:@"cr"]] ;
    [mixed setContentId:self.youtubeId] ;
    [mixed setDisplayType:[attributeDict objectForKey:@"mdt"]] ;
    [mixed setDisplayName:[attributeDict objectForKey:@"mdn"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 2){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setYoutubeId:[results objectAtIndex:1]] ;
            //NSLog(@"set youtubeId:%@",self.youtubeId) ;
        }
    }
}


@end
