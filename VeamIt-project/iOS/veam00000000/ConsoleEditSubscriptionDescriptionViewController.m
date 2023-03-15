//
//  ConsoleEditSubscriptionDescriptionViewController.m
//  veam00000000
//
//  Created by veam on 9/16/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditSubscriptionDescriptionViewController.h"
#import "ConsoleCustomizeViewController.h"
#import "Veamutil.h"

#define CONSOLE_VIEW_DESCRIPTION        1

#define CONSOLE_SUBSCRIPTION_DESCRIPTION_KEY    @"subscription_0_description"


@interface ConsoleEditSubscriptionDescriptionViewController ()

@end

@implementation ConsoleEditSubscriptionDescriptionViewController

@synthesize showCustomizeFirst ;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE|VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT] ;
        [self setHeaderRightText:NSLocalizedString(@"confirm",nil)] ;
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
    
    [descriptionInputBarView setFirstResponder] ;
    
    if(showCustomizeFirst){
        [self handleSwipeLeftGesture:nil] ;
    }
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
    
    contents = [ConsoleUtil getConsoleContents] ;
    CGFloat currentY = y ;
    
    descriptionInputBarView = [self addLongTextInputBar:NSLocalizedString(@"edit_text",nil) y:currentY height:130 fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_DESCRIPTION] ;
    [descriptionInputBarView setDelegate:self] ;
    [descriptionInputBarView hideBottomLine] ;
    currentY += descriptionInputBarView.frame.size.height ;
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)reloadValues
{
    // set title
    contents = [ConsoleUtil getConsoleContents] ;
    NSString *description = [contents getValueForKey:CONSOLE_SUBSCRIPTION_DESCRIPTION_KEY] ;
    //NSLog(@"description:%@",description) ;
    [descriptionInputBarView setInputValue:description] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (BOOL)isValueChanged
{
    BOOL retValue = NO ;
    
    NSString *description = [descriptionInputBarView getInputValue] ;
    if(
       ![description isEqualToString:[contents getValueForKey:CONSOLE_SUBSCRIPTION_DESCRIPTION_KEY]]
       ){
        //NSLog(@"modified") ;
        retValue = YES ;
    }
    
    return retValue ;
}

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
    if([self isValueChanged]){
        [self saveValues] ;
        [super didTapClose] ;
    } else {
        //NSLog(@"not modified") ;
        [super didTapClose] ;
    }
}

- (void)didTapClose
{
    //NSLog(@"%@::didTapClose",NSStringFromClass([self class])) ;
    
    if([self isValueChanged]){
        [self.view endEditing:YES] ;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init] ;
        actionSheet.delegate = self;
        actionSheet.title = nil ;
        [actionSheet addButtonWithTitle:@"Save"] ;
        [actionSheet addButtonWithTitle:@"Discard"] ;
        [actionSheet addButtonWithTitle:@"Cancel"] ;
        actionSheet.cancelButtonIndex = 2 ;
        actionSheet.destructiveButtonIndex = 0 ;
        [actionSheet showInView:self.view] ;
    } else {
        //NSLog(@"not modified") ;
        [super didTapClose] ;
    }
}

- (void)saveValues
{
    //NSLog(@"%@::saveValues",NSStringFromClass([self class])) ;
    [contents setAppData:[descriptionInputBarView getInputValue] name:CONSOLE_SUBSCRIPTION_DESCRIPTION_KEY] ;
    [contents setValueForKey:@"subscription_description_set" value:@"1"] ;
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Save
            //NSLog(@"save") ;
            [self saveValues] ;
            [super didTapClose] ;
            break ;
        case 1:
            // Discard
            [super didTapClose] ;
            break;
        case 2:
            // Cancel
            //NSLog(@"cancel") ;
            break;
    }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
    
    ConsoleCustomizeViewController *viewController = [[ConsoleCustomizeViewController alloc] init] ;
    
    [viewController setCustomizeKind:VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION] ;
    [viewController setHideHeaderBottomLine:YES] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:@"Premium - Customize"] ;
    [viewController setNumberOfHeaderDots:3] ;
    [viewController setSelectedHeaderDot:2] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [self pushViewController:viewController] ;
    
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeRightGesture",NSStringFromClass([self class])) ;
    [self didTapClose] ;
}

- (void) keyboardWillShow:(NSNotification *)note
{
    //NSLog(@"%@::keyboardWillShow",NSStringFromClass([self class])) ;
    [super keyboardWillShow:note] ;
    
    NSDictionary *userInfo = [note userInfo] ;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size ;
    //NSLog(@"%@::keyboardWillShow w:%f h:%f",NSStringFromClass([self class]),kbSize.width, kbSize.height) ;
    
    CGRect frame = descriptionInputBarView.frame ;
    frame.size.height = [VeamUtil getScreenHeight] - kbSize.height - frame.origin.y - [VeamUtil getViewTopOffset] ;
    [descriptionInputBarView setFrame:frame] ;
    [descriptionInputBarView adjustSubViews] ;
    
}

- (void) keyboardWillHide:(NSNotification *)note
{
    [super keyboardWillHide:note] ;
}



@end
