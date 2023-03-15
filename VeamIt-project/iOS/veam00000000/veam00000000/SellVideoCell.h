//
//  SellVideoCell.h
//  veam00000000
//
//  Created by veam on 7/17/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellVideoCell : UITableViewCell
{
    IBOutlet UIImageView *thumbnailImageView ;
    IBOutlet UILabel *titleLabel ;
    IBOutlet UILabel *durationLabel ;
    IBOutlet UIView *separatorView ;
    
    IBOutlet UIImageView *statusImageView ;
    IBOutlet UILabel *statusLabel ;
    IBOutlet UILabel *priceLabel ;
    IBOutlet UIView *maskView ;

}

@property (nonatomic, retain) UIImageView *thumbnailImageView ;
@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *durationLabel ;
@property (nonatomic, retain) UIView *separatorView ;
@property (nonatomic, retain) UIImageView *statusImageView ;
@property (nonatomic, retain) UILabel *statusLabel ;
@property (nonatomic, retain) UILabel *priceLabel ;
@property (nonatomic, retain) UIView *maskView ;

@end
