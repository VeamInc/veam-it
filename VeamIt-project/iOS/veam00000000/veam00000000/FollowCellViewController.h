//
//  FollowCellViewController.h
//  veam31000000
//
//  Created by veam on 2/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowCell.h"

@interface FollowCellViewController : UIViewController
{
    IBOutlet FollowCell *cell ;
}

@property (nonatomic, retain) FollowCell *cell ;

@end
