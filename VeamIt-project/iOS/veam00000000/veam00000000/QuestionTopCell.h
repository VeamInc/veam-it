//
//  QuestionTopCell.h
//  veam31000016
//
//  Created by veam on 4/24/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTopCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel ;
    IBOutlet UILabel *subTitleLabel ;
    IBOutlet UIImageView *thumbnailImageView ;
    IBOutlet UIImageView *askButtonImageView ;
    IBOutlet UILabel *askButtonLabel ;
}

@property (nonatomic, retain) UILabel *titleLabel ;
@property (nonatomic, retain) UILabel *subTitleLabel ;
@property (nonatomic, retain) UIImageView *thumbnailImageView ;
@property (nonatomic, retain) UIImageView *askButtonImageView ;
@property (nonatomic, retain) UILabel *askButtonLabel ;


@end
