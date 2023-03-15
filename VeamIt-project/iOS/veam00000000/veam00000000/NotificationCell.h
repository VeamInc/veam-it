//
//  NotificationCell.h
//  veam31000000
//
//  Created by veam on 7/24/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
{
    IBOutlet UIActivityIndicatorView *indicator ;
    IBOutlet UILabel *updatingLabel ;
    IBOutlet UILabel *instructionLabel ;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicator ;
@property (nonatomic, retain) UILabel *updatingLabel ;
@property (nonatomic, retain) UILabel *instructionLabel ;

@end
