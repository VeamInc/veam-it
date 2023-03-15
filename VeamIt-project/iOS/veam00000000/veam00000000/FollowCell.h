//
//  FollowCell.h
//  veam31000000
//
//  Created by veam on 2/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

@interface FollowCell : UITableViewCell
{
    AGMedallionView *thumbnailImageView ;
    IBOutlet UILabel *userNameLabel ;
    IBOutlet UIView *separatorView ;
}

@property (nonatomic, retain) AGMedallionView *thumbnailImageView ;
@property (nonatomic, retain) UILabel *userNameLabel ;
@property (nonatomic, retain) UIView *separatorView ;


@end
