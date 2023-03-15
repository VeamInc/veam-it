//
//  PictureNativeAdCell.h
//  veam00000000
//
//  Created by veam on 12/20/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureNativeAdCell : UITableViewCell {
    UIActivityIndicatorView *loadAdIndicator ;
}

- (void)showIndicator:(CGFloat)cellHeight ;
- (void)hideIndicator ;


@property (nonatomic, assign) NSInteger row ;
@property (nonatomic, assign) BOOL isAssigned ;


@end
