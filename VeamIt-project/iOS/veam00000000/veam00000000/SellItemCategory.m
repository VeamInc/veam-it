//
//  SellItemCategory.m
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellItemCategory.h"
#import "VeamUtil.h"

@implementation SellItemCategory

@synthesize sellItemCategoryId ;
@synthesize targetCategoryId ;
@synthesize kind ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setSellItemCategoryId:[attributeDict objectForKey:@"id"]] ;
    [self setTargetCategoryId:[attributeDict objectForKey:@"target"]] ;
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
            [self setSellItemCategoryId:[results objectAtIndex:1]] ;
            [self setKind:[results objectAtIndex:2]] ;
            [self setTargetCategoryId:[results objectAtIndex:3]] ;
            //NSLog(@"set videoCategoryId:%@",self.videoCategoryId) ;
        }
    }
}

- (NSString *)getTargetName
{
    NSString *targetName = @"" ;
    if([kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_VIDEO]){
        VideoCategory *category = [VeamUtil getVideoCategoryForId:targetCategoryId] ;
        targetName = [category name] ;
    } else if([kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_PDF]){
        PdfCategory *category = [VeamUtil getPdfCategoryForId:targetCategoryId] ;
        targetName = [category name] ;
    } else if([kind isEqualToString:VEAM_SELL_ITEM_CATEGORY_KIND_AUDIO]){
        AudioCategory *category = [VeamUtil getAudioCategoryForId:targetCategoryId] ;
        targetName = [category name] ;
    }
    return targetName ;
}


@end
