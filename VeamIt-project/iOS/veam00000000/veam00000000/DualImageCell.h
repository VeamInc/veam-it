//
//  DualImageCell.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DualImageCell : UITableViewCell
{
    IBOutlet UIView *leftBackView ;
    IBOutlet UILabel *leftLabel ;
    IBOutlet UIImageView *leftImageView ;
    IBOutlet UIImageView *rightImageView ;
}

@property (nonatomic, retain) UIView *leftBackView;
@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UIImageView *leftImageView;
@property (nonatomic, retain) UIImageView *rightImageView;

@end
