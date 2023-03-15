//
//  ConsoleVideoNotificationTableViewCell.h
//  veam00000000
//
//  Created by veam on 9/15/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleVideoNotificationTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel ;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier video:(Video *)video isLast:(BOOL)isLast ;
+ (CGFloat)getCellHeight ;

@end
