//
//  ConsoleSellAudioPostHandler.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellAudio.h"
#import "Audio.h"

@interface ConsoleSellAudioPostHandler : NSObject<HandlePostResultDelegate>

@property (nonatomic,retain) SellAudio *sellAudio ;
@property (nonatomic,retain) Audio *audio ;

@end
