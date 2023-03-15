//
//  VideoCellViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCell.h"

@interface VideoCellViewController : UIViewController
{
    IBOutlet VideoCell *cell ;
}

@property (nonatomic, retain) VideoCell *cell ;


@end
