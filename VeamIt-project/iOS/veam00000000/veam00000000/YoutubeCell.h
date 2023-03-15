//
//  YoutubeCell.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeCell : UITableViewCell
{
    IBOutlet UIImageView *thumbnailImageView ;
    IBOutlet UILabel *titleLabel ;
    IBOutlet UILabel *durationLabel ;
    IBOutlet UIView *separatorView ;
}

@property (nonatomic, retain) UIImageView *thumbnailImageView ;
@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *durationLabel ;
@property (nonatomic, retain) UIView *separatorView ;

@end