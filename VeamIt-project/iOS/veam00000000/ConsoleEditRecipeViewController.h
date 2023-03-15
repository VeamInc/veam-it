//
//  ConsoleEditRecipeViewController.h
//  veam00000000
//
//  Created by veam on 6/14/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "MixedCategory.h"
#import "MixedSubCategory.h"
#import "Mixed.h"
#import "Recipe.h"

@interface ConsoleEditRecipeViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleLongTextInputBarViewDelegate>
{
    ConsoleImageInputBarView *recipeImageInputBarView ;
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleLongTextInputBarView *ingredientsInputBarView ;
    ConsoleLongTextInputBarView *directionsInputBarView ;
    ConsoleLongTextInputBarView *nutritionInputBarView ;
    
    UIImage *recipeImage ;
}

@property(nonatomic,retain)MixedCategory *mixedCategory ;
@property(nonatomic,retain)MixedSubCategory *mixedSubCategory ;
@property(nonatomic,retain)Mixed *mixed ;
@property(nonatomic,retain)Recipe *recipe ;

- (id)init ;

@end
