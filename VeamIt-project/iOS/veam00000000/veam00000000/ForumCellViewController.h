//
//  ForumCellViewController.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumCell.h"

@interface ForumCellViewController : UIViewController
{
    IBOutlet ForumCell *cell ;
}

@property (nonatomic, retain) ForumCell *cell ;


@end
