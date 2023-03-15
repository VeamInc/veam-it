//
//  QuestionCell.m
//  veam31000016
//
//  Created by veam on 3/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

@synthesize titleLabel ;
@synthesize questionLabel ;
@synthesize dateLabel ;
@synthesize likeNumLabel ;
@synthesize likeImageView ;
@synthesize likeNumImageView ;
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
