//
//  MixedCell.m
//  veam00000000
//
//  Created by veam on 6/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "MixedCell.h"

@implementation MixedCell

@synthesize thumbnailImageView ;
@synthesize titleLabel ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
