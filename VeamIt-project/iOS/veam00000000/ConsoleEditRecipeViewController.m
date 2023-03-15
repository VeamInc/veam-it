//
//  ConsoleEditRecipeViewController.m
//  veam00000000
//
//  Created by veam on 6/14/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditRecipeViewController.h"

#define CONSOLE_VIEW_TITLE              1
#define CONSOLE_VIEW_INGREDIENTS        2
#define CONSOLE_VIEW_DIRECTIONS         3
#define CONSOLE_VIEW_NUTRITION          4
#define CONSOLE_VIEW_RECIPE_IMAGE       5

@interface ConsoleEditRecipeViewController ()

@end

@implementation ConsoleEditRecipeViewController

@synthesize mixedCategory ;
@synthesize mixedSubCategory ;
@synthesize mixed ;
@synthesize recipe ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //[self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE|VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT] ;
        [self setHeaderRightText:NSLocalizedString(@"confirm",nil)] ;
        //[self setHeaderTitle:@"YouTube Basic Settings"] ;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat currentY = [self addMainScrollView] ;
    currentY = [self addContents:currentY] ;
    [self setScrollHeight:currentY] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (CGFloat)addContents:(CGFloat)y
{
    CGFloat currentY = y ;
    
    currentY += [self addSectionHeader:@"Recipe" y:currentY] ;
    
    recipeImageInputBarView = [self addImageInputBar:@"Image" y:currentY fullBottomLine:NO
                                            displayWidth:250 displayHeight:250 cropWidth:600 cropHeight:0 resizableCropArea:YES tag:CONSOLE_VIEW_RECIPE_IMAGE] ;
    currentY += recipeImageInputBarView.frame.size.height ;

    titleInputBarView = [self addTextInputBar:@"Title" y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    ingredientsInputBarView = [self addLongTextInputBar:@"Ingredients" y:currentY height:100 fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_INGREDIENTS] ;
    [ingredientsInputBarView setDelegate:self] ;
    currentY += ingredientsInputBarView.frame.size.height ;
    
    directionsInputBarView = [self addLongTextInputBar:@"Directions" y:currentY height:100 fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_DIRECTIONS] ;
    [directionsInputBarView setDelegate:self] ;
    currentY += directionsInputBarView.frame.size.height ;
    
    nutritionInputBarView = [self addLongTextInputBar:@"Nutrition" y:currentY height:100 fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_NUTRITION] ;
    [nutritionInputBarView setDelegate:self] ;
    currentY += nutritionInputBarView.frame.size.height ;
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    NSString *title = @"" ;
    NSString *ingredients = @"" ;
    NSString *directions = @"" ;
    NSString *nutrition = @"" ;
    NSString *recipeImageUrl = @"" ;
    if(recipe != nil){
        recipeImageUrl = recipe.imageUrl ;
        title = recipe.title ;
        ingredients = recipe.ingredients ;
        directions = recipe.directions ;
        nutrition = recipe.nutrition ;
    }
    
    [recipeImageInputBarView setInputValue:recipeImageUrl] ;
    [titleInputBarView setInputValue:title] ;
    [ingredientsInputBarView setInputValue:ingredients] ;
    [directionsInputBarView setInputValue:directions] ;
    [nutritionInputBarView setInputValue:nutrition] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)didChangeTextInputValue:(ConsoleTextInputBarView *)view value:(NSString *)value
{
    switch (view.tag) {
        case CONSOLE_VIEW_TITLE:
            break;
            
        default:
            break;
    }
}

- (void)didChangeLongTextInputValue:(ConsoleLongTextInputBarView *)view value:(NSString *)value
{
    //NSLog(@"%@::didChangeLongTextInputValue %@",NSStringFromClass([self class]),value) ;
}

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
    if(mixed == nil){
        //NSLog(@"new mixed c=%@",mixedCategory.mixedCategoryId) ;
        mixed = [[Mixed alloc] init] ;
        mixed.mixedCategoryId = mixedCategory.mixedCategoryId ;
        if(mixedSubCategory == nil){
            mixed.mixedSubCategoryId = @"0" ;
        } else {
            mixed.mixedSubCategoryId = mixedSubCategory.mixedSubCategoryId ;
        }
        
        mixed.kind = VEAM_CONSOLE_MIXED_KIND_RECIPE ;
    }
    
    if(recipe == nil){
        //NSLog(@"new recipe") ;
        recipe = [[Recipe alloc] init] ;
        recipe.recipeCategoryId = @"0" ;
    }
    
    [recipe setMixed:mixed] ;
    
    //NSLog(@"name=%@",[titleInputBarView getInputValue]) ;
    [mixed setTitle:[titleInputBarView getInputValue]] ;
    [recipe setTitle:[titleInputBarView getInputValue]] ;
    
    //NSLog(@"ingredients=%@",[ingredientsInputBarView getInputValue]) ;
    [recipe setIngredients:[ingredientsInputBarView getInputValue]] ;
    
    //NSLog(@"directions=%@",[directionsInputBarView getInputValue]) ;
    [recipe setDirections:[directionsInputBarView getInputValue]] ;
    
    //NSLog(@"nutrition=%@",[nutritionInputBarView getInputValue]) ;
    [recipe setNutrition:[nutritionInputBarView getInputValue]] ;
    
    [[ConsoleUtil getConsoleContents] setRecipe:recipe recipeImage:recipeImage] ;
    [self popViewController] ;
}

- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_RECIPE_IMAGE:
            //NSLog(@"CONSOLE_VIEW_RECIPE_IMAGE") ;
            recipeImage = value ;
            break;
        default:
            break;
    }
}


@end
