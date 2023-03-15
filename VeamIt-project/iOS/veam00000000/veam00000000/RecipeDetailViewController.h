//
//  RecipeDetailViewController.h
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "Recipe.h"

@interface RecipeDetailViewController : VeamViewController
{
    UIScrollView *scrollView ;
    UIImageView *favoriteImageView ;
    UIView *adBaseView ;

    UIView *sharedBanner_ ;
}

@property (nonatomic, retain) Recipe *recipe ;
@property (nonatomic, retain) UIView *sharedBanner ;

@end
