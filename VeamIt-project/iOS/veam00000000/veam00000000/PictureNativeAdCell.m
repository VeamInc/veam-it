//
//  PictureNativeAdCell.m
//  veam00000000
//
//  Created by veam on 12/20/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "PictureNativeAdCell.h"

@implementation PictureNativeAdCell

@synthesize isAssigned ;
@synthesize row ;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showIndicator:(CGFloat)cellHeight
{
    if(loadAdIndicator == nil){
        CGFloat indicatorSize = 30 ;
        CGRect frame = [self frame] ;
        loadAdIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
        [loadAdIndicator setFrame:CGRectMake((320-indicatorSize) / 2, (cellHeight-indicatorSize)/2, indicatorSize, indicatorSize)] ;
        [self addSubview:loadAdIndicator] ;
    }
    [loadAdIndicator startAnimating] ;
    [loadAdIndicator setAlpha:1.0] ;

}

- (void)hideIndicator
{
    if(loadAdIndicator != nil){
        [loadAdIndicator setAlpha:0.0] ;
        [loadAdIndicator stopAnimating] ;
    }
}

@end
