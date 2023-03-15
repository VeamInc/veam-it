//
//  FollowCell.m
//  veam31000000
//
//  Created by veam on 2/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

@synthesize thumbnailImageView ;
@synthesize userNameLabel ;
@synthesize separatorView ;

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
