//
//  ForumCell.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "ForumCell.h"

@implementation ForumCell

@synthesize titleLabel;
@synthesize userImageView ;
@synthesize pictureImageView ;
@synthesize pictureImageIndicator ;
@synthesize likeImageView ;
@synthesize likeButtonImageView ;
@synthesize commentButtonImageView ;
@synthesize commentImageView ;
@synthesize deleteButtonImageView ;
@synthesize favoriteButtonImageView ;
@synthesize reportImageView ;
@synthesize userNameLabel ;
@synthesize timeLabel ;
@synthesize likeLabel ;
@synthesize commentLabel ;
@synthesize lineView ;

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
