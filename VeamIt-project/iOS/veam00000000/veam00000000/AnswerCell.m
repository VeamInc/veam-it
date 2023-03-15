//
//  AnswerCell.m
//  veam31000016
//
//  Created by veam on 4/24/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell

@synthesize titleLabel ;
@synthesize questionLabel ;
@synthesize dateLabel ;
@synthesize actionLabel ;
@synthesize actionImageView ;
@synthesize arrowImageView ;
@synthesize iconImageView ;
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
