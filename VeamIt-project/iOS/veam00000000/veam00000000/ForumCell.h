//
//  ForumCell.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@interface ForumCell : UITableViewCell
{
    IBOutlet UIImageView *userImageView ;
    IBOutlet UIImageView *pictureImageView ;
    IBOutlet UIActivityIndicatorView *pictureImageIndicator ;
    IBOutlet UIImageView *likeImageView ;
    IBOutlet UIImageView *likeButtonImageView ;
    IBOutlet UIImageView *commentButtonImageView ;
    IBOutlet UIImageView *commentImageView ;
    IBOutlet UIImageView *deleteButtonImageView ;
    IBOutlet UIImageView *favoriteButtonImageView ;
    IBOutlet UIImageView *reportImageView ;
    IBOutlet UILabel *userNameLabel ;
    IBOutlet UILabel *timeLabel ;
    IBOutlet UILabel *likeLabel ;
    IBOutlet UIView *lineView ;
    TTStyledTextLabel *commentLabel ;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *userImageView ;
@property (nonatomic, retain) UIImageView *pictureImageView ;
@property (nonatomic, retain) UIActivityIndicatorView *pictureImageIndicator ;
@property (nonatomic, retain) UIImageView *likeImageView ;
@property (nonatomic, retain) UIImageView *likeButtonImageView ;
@property (nonatomic, retain) UIImageView *commentButtonImageView ;
@property (nonatomic, retain) UIImageView *commentImageView ;
@property (nonatomic, retain) UIImageView *deleteButtonImageView ;
@property (nonatomic, retain) UIImageView *favoriteButtonImageView ;
@property (nonatomic, retain) UIImageView *reportImageView ;
@property (nonatomic, retain) UILabel *userNameLabel ;
@property (nonatomic, retain) UILabel *timeLabel ;
@property (nonatomic, retain) UILabel *likeLabel ;
@property (nonatomic, retain) UIView *lineView ;
@property (nonatomic, retain) TTStyledTextLabel *commentLabel ;

@end
