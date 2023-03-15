//
//  RecipeCell.h
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCell : UITableViewCell
{
    IBOutlet UIImageView *thumbnailImageView ;
    IBOutlet UILabel *titleLabel ;
}

@property (nonatomic, retain) UIImageView *thumbnailImageView ;
@property (nonatomic, retain) UILabel *titleLabel ;


@end
