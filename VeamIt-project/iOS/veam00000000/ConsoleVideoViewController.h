//
//  ConsoleVideoViewController.h
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleVideoViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfVideos ;
    NSInteger indexToBeDeleted ;
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;
    NSTimer *updateTimer ;
    BOOL needTimer ;
}
@property(nonatomic,retain)VideoCategory *videoCategory ;
@property(nonatomic,retain)VideoSubCategory *videoSubCategory ;
@property(nonatomic,assign)BOOL showCustomizeFirst ;

@end
