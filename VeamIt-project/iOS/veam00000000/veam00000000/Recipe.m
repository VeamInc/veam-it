//
//  Recipe.m
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

@synthesize mixed ;
@synthesize recipeId ;
@synthesize recipeCategoryId ;
@synthesize title ;
@synthesize imageUrl ;
@synthesize directions ;
@synthesize ingredients ;
@synthesize nutrition ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setRecipeId:[attributeDict objectForKey:@"id"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setImageUrl:[attributeDict objectForKey:@"u"]] ;
    [self setRecipeCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setNutrition:[attributeDict objectForKey:@"n"]] ;
    [self setIngredients:[attributeDict objectForKey:@"i"]] ;
    [self setDirections:[attributeDict objectForKey:@"d"]] ;
    
    mixed = [[Mixed alloc] init] ;
    [mixed setMixedId:[attributeDict objectForKey:@"mi"]] ;
    [mixed setTitle:[attributeDict objectForKey:@"t"]] ;
    [mixed setMixedCategoryId:[attributeDict objectForKey:@"mc"]] ;
    [mixed setMixedSubCategoryId:[attributeDict objectForKey:@"ms"]] ;
    [mixed setKind:[attributeDict objectForKey:@"mk"]] ;
    [mixed setThumbnailUrl:[attributeDict objectForKey:@"mt"]] ;
    [mixed setContentId:self.recipeId] ;
    [mixed setDisplayType:[attributeDict objectForKey:@"mdt"]] ;
    [mixed setDisplayName:[attributeDict objectForKey:@"mdn"]] ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 3){
        //NSLog(@"count >= 3") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self.mixed setMixedId:[results objectAtIndex:1]] ;
            //NSLog(@"set mixedId:%@",self.mixed.mixedId) ;
            [self setRecipeId:[results objectAtIndex:2]] ;
            //NSLog(@"set recipeId:%@",self.recipeId) ;
            [mixed setContentId:self.recipeId] ;
        }
    }
}



@end
