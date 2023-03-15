//
//  SellSectionCategory.m
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellSectionCategory.h"
#import "VeamUtil.h"

@implementation SellSectionCategory

@synthesize sellSectionCategoryId ;
@synthesize name ;
@synthesize kind ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setSellSectionCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setName:[attributeDict objectForKey:@"name"]] ;
    [self setKind:[attributeDict objectForKey:@"kind"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 5){
        //NSLog(@"count >= 2") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setSellSectionCategoryId:[results objectAtIndex:1]] ;
            [self setKind:[results objectAtIndex:2]] ;
            [self setName:[results objectAtIndex:3]] ;
            //NSLog(@"set videoCategoryId:%@",self.videoCategoryId) ;
        }
    }
}

- (NSString *)getTargetName
{
    NSString *targetName = @"" ;
    targetName = name ;
    /*
    if([kind isEqualToString:VEAM_SELL_SECTION_CATEGORY_KIND_VIDEO]){
        VideoCategory *category = [VeamUtil getVideoCategoryForId:targetCategoryId] ;
        targetName = [category name] ;
    } else if([kind isEqualToString:VEAM_SELL_SECTION_CATEGORY_KIND_PDF]){
        PdfCategory *category = [VeamUtil getPdfCategoryForId:targetCategoryId] ;
        targetName = [category name] ;
    } else if([kind isEqualToString:VEAM_SELL_SECTION_CATEGORY_KIND_AUDIO]){
        AudioCategory *category = [VeamUtil getAudioCategoryForId:targetCategoryId] ;
        targetName = [category name] ;
    }
     */
    return targetName ;
}


@end
