//
//  SellVideoCell.m
//  veam00000000
//
//  Created by veam on 7/17/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellVideoCell.h"

@implementation SellVideoCell

@synthesize thumbnailImageView ;
@synthesize titleLabel ;
@synthesize durationLabel ;
@synthesize separatorView ;
@synthesize statusImageView ;
@synthesize statusLabel ;
@synthesize priceLabel ;
@synthesize maskView ;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
