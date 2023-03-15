//
//  AppCreatorMessageCell.h
//  veam31000017
//
//  Created by veam on 3/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCreatorMessageLabel.h"

@interface AppCreatorMessageCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel ;
    IBOutlet AppCreatorMessageLabel *messageLabel ;
    IBOutlet UILabel *dateLabel ;
}

@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) AppCreatorMessageLabel *messageLabel ;
@property (nonatomic, retain) UILabel *dateLabel ;

@end
