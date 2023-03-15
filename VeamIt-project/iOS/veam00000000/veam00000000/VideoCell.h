//
//  VideoCell.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell
{
    IBOutlet UIImageView *arrowImageView ;
    IBOutlet UIImageView *deleteImageView ;
    IBOutlet UIImageView *thumbnailImageView ;
    IBOutlet UILabel *titleLabel ;
    IBOutlet UILabel *durationLabel ;
    IBOutlet UILabel *statusLabel ;
    IBOutlet UILabel *deleteLabel ;
    IBOutlet UIView *progressView ;
    IBOutlet UIView *separatorView ;
}

@property (nonatomic, retain) UIImageView *arrowImageView ;
@property (nonatomic, retain) UIImageView *deleteImageView ;
@property (nonatomic, retain) UIImageView *thumbnailImageView ;
@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *durationLabel ;
@property (nonatomic, retain) UILabel *statusLabel ;
@property (nonatomic, retain) UILabel *deleteLabel ;
@property (nonatomic, retain) UIView *progressView ;
@property (nonatomic, retain) UIView *separatorView ;

@end
