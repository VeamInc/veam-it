//
//  ConsoleMixedForGridViewController.h
//  veam00000000
//
//  Created by veam on 1/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleMixedForGridViewController : ConsoleViewController<UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfMixeds ;
    NSInteger indexToBeDeleted ;
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;
    NSTimer *updateTimer ;
    BOOL needTimer ;
    Mixed *currentMixed ;
    BOOL isAppReleased ;
    NSArray *prices ;
}
@property(nonatomic,retain)MixedCategory *mixedCategory ;
@property(nonatomic,retain)MixedSubCategory *mixedSubCategory ;
@property(nonatomic,assign)BOOL showCustomizeFirst ;


@end
