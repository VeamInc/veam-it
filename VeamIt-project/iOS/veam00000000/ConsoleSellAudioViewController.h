//
//  ConsoleSellAudioViewController.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "SellAudio.h"
#import "AudioCategory.h"
#import "AudioSubCategory.h"

@interface ConsoleSellAudioViewController : ConsoleViewController<UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfSellAudios ;
    NSInteger indexToBeDeleted ;
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;
    NSTimer *updateTimer ;
    BOOL needTimer ;
    SellAudio *currentSellAudio ;
    BOOL isAppReleased ;
    NSArray *prices ;
    BOOL isSellSection ;
}

@property(nonatomic,retain)AudioCategory *audioCategory ;
@property(nonatomic,retain)AudioSubCategory *audioSubCategory ;
@property(nonatomic,assign)BOOL showCustomizeFirst ;


@end
