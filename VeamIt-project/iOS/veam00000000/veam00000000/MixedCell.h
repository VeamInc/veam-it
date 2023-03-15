//
//  MixedCell.h
//  veam00000000
//
//  Created by veam on 6/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixedCell : UITableViewCell
{
    IBOutlet UIImageView *thumbnailImageView ;
    IBOutlet UILabel *titleLabel ;
}

@property (nonatomic, retain) UIImageView *thumbnailImageView ;
@property (nonatomic, retain) UILabel *titleLabel ;

@end
