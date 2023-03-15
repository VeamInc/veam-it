//
//  MessageCell.m
//  veam31000017
//
//  Created by veam on 3/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppCreatorMessageCell.h"

@implementation AppCreatorMessageCell

@synthesize titleLabel ;
@synthesize messageLabel ;
@synthesize dateLabel ;

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
