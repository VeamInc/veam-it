//
//  NotificationCell.m
//  veam31000000
//
//  Created by veam on 7/24/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

@synthesize indicator ;
@synthesize updatingLabel ;
@synthesize instructionLabel ;

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
