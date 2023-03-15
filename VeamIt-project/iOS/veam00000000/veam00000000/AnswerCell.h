//
//  AnswerCell.h
//  veam31000016
//
//  Created by veam on 4/24/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel ;
    IBOutlet UILabel *questionLabel ;
    IBOutlet UILabel *dateLabel ;
    IBOutlet UILabel *deleteLabel ;
    IBOutlet UILabel *actionLabel ;
    IBOutlet UIImageView *actionImageView ;
    IBOutlet UIImageView *arrowImageView ;
    IBOutlet UIImageView *iconImageView ;
    IBOutlet UIView *separatorView ;
}

@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *questionLabel ;
@property (nonatomic, retain) UILabel *dateLabel ;
@property (nonatomic, retain) UILabel *deleteLabel ;
@property (nonatomic, retain) UILabel *actionLabel ;
@property (nonatomic, retain) UIImageView *actionImageView ;
@property (nonatomic, retain) UIImageView *arrowImageView ;
@property (nonatomic, retain) UIImageView *iconImageView ;
@property (nonatomic, retain) UIView *separatorView ;

@end
