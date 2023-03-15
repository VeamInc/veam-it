//
//  QuestionTopCell.m
//  veam31000016
//
//  Created by veam on 4/24/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "QuestionTopCell.h"

@implementation QuestionTopCell

@synthesize titleLabel ;
@synthesize subTitleLabel ;
@synthesize thumbnailImageView ;
@synthesize askButtonImageView ;
@synthesize askButtonLabel ;

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
