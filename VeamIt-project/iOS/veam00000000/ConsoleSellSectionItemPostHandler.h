//
//  ConsoleSellSectionItemPostHandler.h
//  veam00000000
//
//  Created by veam on 11/26/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellSectionItem.h"
#import "Video.h"
#import "Pdf.h"
#import "Audio.h"

@interface ConsoleSellSectionItemPostHandler : NSObject

@property (nonatomic,retain) SellSectionItem *sellSectionItem ;
@property (nonatomic,retain) Video *video ;
@property (nonatomic,retain) Pdf *pdf ;
@property (nonatomic,retain) Audio *audio ;

@end
