//
//  ConsoleSellVideoViewController.h
//  veam00000000
//
//  Created by veam on 10/29/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleSellVideoViewController : ConsoleViewController<UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfSellVideos ;
    NSInteger indexToBeDeleted ;
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;
    NSTimer *updateTimer ;
    BOOL needTimer ;
    SellVideo *currentSellVideo ;
    BOOL isAppReleased ;
    NSArray *prices ;
    BOOL isSellSection ;
}
@property(nonatomic,retain)VideoCategory *videoCategory ;
@property(nonatomic,retain)VideoSubCategory *videoSubCategory ;
@property(nonatomic,assign)BOOL showCustomizeFirst ;


@end
