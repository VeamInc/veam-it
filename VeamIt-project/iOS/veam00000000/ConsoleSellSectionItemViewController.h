//
//  ConsoleSellSectionItemViewController.h
//  veam00000000
//
//  Created by veam on 11/26/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "SellSectionItem.h"

@interface ConsoleSellSectionItemViewController : ConsoleViewController<UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfSellSectionItems ;
    NSInteger indexToBeDeleted ;
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;
    NSTimer *updateTimer ;
    BOOL needTimer ;
    SellSectionItem *currentSellSectionItem ;
    BOOL isAppReleased ;
    NSArray *prices ;
    BOOL isSellSection ;
}
@property(nonatomic,retain)SellSectionCategory *sellSectionCategory ;
@property(nonatomic,assign)BOOL showCustomizeFirst ;


@end
