//
//  NotificationCellViewController.h
//  veam31000000
//
//  Created by veam on 7/24/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationCell.h"

@interface NotificationCellViewController : UIViewController
{
    IBOutlet NotificationCell *cell ;
}

@property (nonatomic, retain) NotificationCell *cell ;

@end
