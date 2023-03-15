//
//  RecipeCellViewController.h
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeCell.h"

@interface RecipeCellViewController : UIViewController
{
    IBOutlet RecipeCell *cell ;
}

@property (nonatomic, retain) RecipeCell *cell ;

@end
