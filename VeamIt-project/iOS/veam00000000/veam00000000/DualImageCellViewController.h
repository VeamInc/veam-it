//
//  DualImageCellViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DualImageCell.h"

@interface DualImageCellViewController : UIViewController
{
    IBOutlet DualImageCell *cell ;
}

@property (nonatomic, retain) DualImageCell *cell ;

@end
