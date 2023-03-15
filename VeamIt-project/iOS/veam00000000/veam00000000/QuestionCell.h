//
//  QuestionCell.h
//  veam31000016
//
//  Created by veam on 3/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel ;
    IBOutlet UILabel *questionLabel ;
    IBOutlet UILabel *dateLabel ;
    IBOutlet UILabel *likeNumLabel ;
    IBOutlet UIImageView *likeNumImageView ;
    IBOutlet UIImageView *likeImageView ;
    IBOutlet UIImageView *iconImageView ;
    IBOutlet UIView *separatorView ;
}

@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *questionLabel ;
@property (nonatomic, retain) UILabel *dateLabel ;
@property (nonatomic, retain) UILabel *likeNumLabel ;
@property (nonatomic, retain) UIImageView *likeNumImageView ;
@property (nonatomic, retain) UIImageView *likeImageView ;
@property (nonatomic, retain) UIImageView *iconImageView ;
@property (nonatomic, retain) UIView *separatorView ;

@end
