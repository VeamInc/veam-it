//
//  ConsoleSellPdfTableViewCell.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellPdf.h"

@interface ConsoleSellPdfTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *priceLabel ;
@property (nonatomic, retain) UILabel *statusLabel ;
@property (nonatomic, retain) UILabel *deadlineLabel ;
@property (nonatomic, retain) UIImageView *thumbnailImageView ;
@property (nonatomic, retain) UIImageView *moveImageView ;
@property (nonatomic, retain) UIImageView *rightImageView ;
@property (nonatomic, retain) UIImageView *deleteImageView ;
@property (nonatomic, retain) UIView *separatorView ;
@property (nonatomic, retain) UIView *deleteTapView ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier sellPdf:(SellPdf *)sellPdf isLast:(BOOL)isLast ;
+ (CGFloat)getCellHeight ;


@end
