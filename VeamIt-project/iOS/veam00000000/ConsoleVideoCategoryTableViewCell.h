//
//  ConsoleVideoCategoryTableViewCell.h
//  veam00000000
//
//  Created by veam on 9/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleVideoCategoryTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UIImageView *moveImageView ;
@property (nonatomic, retain) UIImageView *deleteImageView ;
@property (nonatomic, retain) UIView *separatorView ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title isLast:(BOOL)isLast ;
+ (CGFloat)getCellHeight ;

@end
