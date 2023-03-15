//
//  SellSectionItem.m
//  veam00000000
//
//  Created by veam on 11/25/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellSectionItem.h"
#import "VeamUtil.h"

@implementation SellSectionItem

@synthesize sellSectionItemId ;
@synthesize sellSectionCategoryId ;
@synthesize sellSectionSubCategoryId ;
@synthesize title ;
@synthesize kind ;
@synthesize contentId ;
@synthesize createdAt ;
@synthesize status ;
@synthesize statusText ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setSellSectionItemId:[attributeDict objectForKey:@"id"]] ;
    [self setSellSectionCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setSellSectionSubCategoryId:[attributeDict objectForKey:@"s"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setKind:[attributeDict objectForKey:@"k"]] ;
    [self setContentId:[attributeDict objectForKey:@"ci"]] ;
    [self setStatus:[attributeDict objectForKey:@"st"]] ;
    [self setStatusText:[attributeDict objectForKey:@"stt"]] ;
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
            [self setSellSectionItemId:[results objectAtIndex:1]] ;
            [self setContentId:[results objectAtIndex:2]] ;
            //NSLog(@"set mixedId:%@ contentId:%@",self.mixedId,self.contentId) ;
            if([results count] >= 6){
                [self setStatus:[results objectAtIndex:3]] ;
                //NSLog(@"set status:%@",self.status) ;
                [self setStatusText:[results objectAtIndex:4]] ;
                //NSLog(@"set statusText:%@",self.statusText) ;
            }
        }
    }
}

- (NSString *)getKindString
{
    NSString *retValue = @"" ;
    if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_VIDEO]){
        retValue = @"Video" ;
    } else if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_PDF]){
        retValue = @"PDF" ;
    } else if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_AUDIO]){
        retValue = @"Audio" ;
    }
    return retValue ;
    
}

- (NSString *) getDurationString
{
    NSString *retValue = @"" ;
    if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_VIDEO]){
        Video *video = [VeamUtil getVideoForId:contentId] ;
        if(video){
            retValue = video.duration ;
        }
    } else if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_AUDIO]){
        Audio *audio = [VeamUtil getAudioForId:contentId] ;
        if(audio){
            retValue = audio.duration ;
        }
    }
    return retValue ;
}

- (NSString *)getImageUrl
{
    NSString *retValue = @"" ;
    if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_VIDEO]){
        Video *video = [VeamUtil getVideoForId:contentId] ;
        if(video){
            retValue = video.imageUrl ;
        }
    } else if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_PDF]){
        Pdf *pdf = [VeamUtil getPdfForId:contentId] ;
        if(pdf){
            retValue = pdf.imageUrl ;
        }
    } else if([kind isEqualToString:VEAM_SELL_SECTION_ITEM_KIND_AUDIO]){
        Audio *audio = [VeamUtil getAudioForId:contentId] ;
        if(audio){
            retValue = audio.rectangleImageUrl ;
        }
    }
    return retValue ;
}


@end
