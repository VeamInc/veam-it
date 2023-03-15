//
//  BasicCell.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel ;
    IBOutlet UIView *separatorView ;
    IBOutlet UIImageView *arrowImage ;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *separatorView ;
@property (nonatomic, retain) UIImageView *arrowImage ;

@end
