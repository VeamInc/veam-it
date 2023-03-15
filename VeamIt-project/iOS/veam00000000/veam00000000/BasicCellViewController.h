//
//  BasicCellViewController.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicCell.h"

@interface BasicCellViewController : UIViewController
{
    IBOutlet BasicCell *cell ;
}

@property (nonatomic, retain) BasicCell *cell ;

@end
