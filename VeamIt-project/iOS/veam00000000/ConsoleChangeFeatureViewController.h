//
//  ConsoleChangeFeatureViewController.h
//  veam00000000
//
//  Created by veam on 10/28/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleChangeFeatureViewController : ConsoleViewController<UITableViewDataSource,UITableViewDelegate,HPReorderTableViewDelegate>
{
    NSInteger numberOfMixeds ;
    NSInteger indexToBeDeleted ;
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;
    NSTimer *updateTimer ;
    BOOL needTimer ;
    Mixed *currentMixed ;
    BOOL isAppReleased ;
    NSMutableArray *features ;
    NSMutableArray *featurePrices ;
    
    UIView *progressView ;
    UIActivityIndicatorView *progressIndicator ;

}
@property(nonatomic,retain)MixedCategory *mixedCategory ;
@property(nonatomic,retain)MixedSubCategory *mixedSubCategory ;
@property(nonatomic,assign)BOOL showCustomizeFirst ;


@end
