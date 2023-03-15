//
//  ConsoleEditAppRatingViewController.m
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditAppRatingViewController.h"

@interface ConsoleEditAppRatingViewController ()

@end

@implementation ConsoleEditAppRatingViewController

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
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE] ;
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
    
    currentY += [self addSectionHeader:NSLocalizedString(@"app_info_rating_caption", nil) y:currentY] ;
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSMutableArray *appRatingQuestions = contents.appRatingQuestions ;
    
    int count = [appRatingQuestions count] ;
    textSelectBarViews = [NSMutableArray array] ;
    for(int index = 0 ; index < count ; index++){
        AppRatingQuestion *appRatingQuestion = [appRatingQuestions objectAtIndex:index] ;
        NSArray *selections = [[appRatingQuestion getSelectionString] componentsSeparatedByString:@"|"] ;
        ConsoleTextSelectBarView *textSelectBarView = [self addTextSelectBar:[appRatingQuestion getQuestionString] selections:selections selectionValues:selections y:currentY fullBottomLine:NO selector:nil tag:index] ;
        [textSelectBarView setDelegate:self] ;
        currentY += textSelectBarView.frame.size.height ;
        [textSelectBarViews addObject:textSelectBarView];
    }
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)reloadValues
{
    // set title
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSMutableArray *appRatingQuestions = contents.appRatingQuestions ;
    int count = [appRatingQuestions count] ;
    for(int index = 0 ; index < count ; index++){
        AppRatingQuestion *appRatingQuestion = [appRatingQuestions objectAtIndex:index] ;
        ConsoleTextSelectBarView *textSelectBarView = [textSelectBarViews objectAtIndex:index] ;
        [textSelectBarView setInputValue:appRatingQuestion.answer] ;
    }

}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)didChangeTextSelectValue:(ConsoleTextSelectBarView *)view inputValue:(NSString *)inputValue selectionValue:(NSString *)selectionValue
{
    //NSLog(@"%@::didChangeTextSelectValue",NSStringFromClass([self class])) ;
    NSInteger index = view.tag ;
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSMutableArray *appRatingQuestions = contents.appRatingQuestions ;
    int count = [appRatingQuestions count] ;
    if(index < count){
        AppRatingQuestion *appRatingQuestion = [appRatingQuestions objectAtIndex:index] ;
        appRatingQuestion.answer = inputValue ;
        [[ConsoleUtil getConsoleContents] setAppRatingQuestion:appRatingQuestion] ;
    }
}

@end
