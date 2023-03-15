//
//  ConsoleEditSellSectionCategoryViewController.m
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleEditSellSectionCategoryViewController.h"
#import "VeamUtil.h"

#define CONSOLE_VIEW_TITLE          1
//#define CONSOLE_VIEW_KIND           2

@interface ConsoleEditSellSectionCategoryViewController ()

@end

@implementation ConsoleEditSellSectionCategoryViewController

@synthesize sellSectionCategory ;

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
    
    currentY += [self addSectionHeader:NSLocalizedString(@"category_caption",nil) y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:NSLocalizedString(@"category_title",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    /*
    NSArray *kindSelections = [NSArray arrayWithObjects:@"Video",@"PDF",@"Audio", nil] ;
    NSArray *kindValues = [NSArray arrayWithObjects:@"1",@"2",@"3", nil] ;
    
    kindSelectBarView = [self addTextSelectBar:NSLocalizedString(@"category_kind",nil) selections:kindSelections selectionValues:kindValues y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_KIND] ;
    [kindSelectBarView setDelegate:self] ;
    currentY += kindSelectBarView.frame.size.height ;
     
     */
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    // set title
    NSString *title = @"" ;
    //NSString *kind = @"" ;
    if(sellSectionCategory != nil){
        title = [[ConsoleUtil getConsoleContents] getCategoryTitleForSellSectionCategory:sellSectionCategory] ;
        //kind = sellSectionCategory.kind ;
    }
    [titleInputBarView setInputValue:title] ;
    //[kindSelectBarView setSelectionValue:kind] ;
}

- (void)contentsDidUpdate:(NSNotification*)notification
{
    [super contentsDidUpdate:notification] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    // CONTENT_POST_DONE",@"ACTION",postData.apiName,@"API_NAME",results,@"RESULTS",nil] ;
    //NSLog(@"ACTION=%@",[notification.userInfo objectForKey:@"ACTION"]) ;
    //NSLog(@"API_NAME=%@",[notification.userInfo objectForKey:@"API_NAME"]) ;
    //NSLog(@"RESULTS=%@",[notification.userInfo objectForKey:@"RESULTS"]) ;
    
    if(notification.userInfo != nil){
        NSString *actionName = [notification.userInfo objectForKey:@"ACTION"] ;
        if([actionName isEqualToString:@"CONTENT_POST_DONE"]){
            NSString *apiName = [notification.userInfo objectForKey:@"API_NAME"] ;
            if([apiName isEqualToString:@"sellsection/setcategory"]){
                NSArray *results = [notification.userInfo objectForKey:@"RESULTS"] ;
                if([results count] >= 4){
                    NSString *code = [results objectAtIndex:0] ;
                    if([code isEqualToString:@"OK"]){
                        NSString *sellSectionCategoryId = [results objectAtIndex:1] ;
                        NSString *kind = [results objectAtIndex:2] ;
                        NSString *name = [results objectAtIndex:4] ;
                        //[ConsoleUtil postContentsUpdateNotification] ;
                        [self performSelectorOnMainThread:@selector(doClose) withObject:nil waitUntilDone:NO] ;
                    }
                }
            }
        }
    }
    
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)doClose
{
    [super didTapClose] ;
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




- (BOOL)isValueChanged
{
    BOOL retValue = NO ;
    if(sellSectionCategory == nil){
        //NSLog(@"new") ;
        retValue = YES ;
    } else {
        NSString *title = [titleInputBarView getInputValue] ;
        //NSString *kind = [kindSelectBarView getInputValue] ;
        if(
           ![title isEqualToString:[[ConsoleUtil getConsoleContents] getCategoryTitleForSellSectionCategory:sellSectionCategory]]
           ){
            //NSLog(@"modified") ;
            //NSLog(@"%@:%@ %@:%@",title,web.title,url,web.url) ;
            retValue = YES ;
        }
    }
    
    return retValue ;
}

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
    if([self isValueChanged]){
        if([self saveValues]){
            //[super didTapClose] ; // 応答が来てからクローズする
        }
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
        actionSheet.delegate = self ;
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

- (BOOL)saveValues
{
    //NSLog(@"%@::saveValues",NSStringFromClass([self class])) ;
    NSString *title = [titleInputBarView getInputValue] ;
    //NSString *kind = [kindSelectBarView getSelectionValue] ;
    if([VeamUtil isEmpty:title]){
        [VeamUtil dispError:@"Please input title"] ;
        return NO ;
    }
    /*
    if([VeamUtil isEmpty:kind]){
        [VeamUtil dispError:@"Please input kind"] ;
        return NO ;
    }
    */
    
    if(sellSectionCategory == nil){
        sellSectionCategory = [[SellSectionCategory alloc] init] ;
    }
    //NSLog(@"name=%@ url=%@",title,url) ;
    [sellSectionCategory setKind:@"0"] ;
    [[ConsoleUtil getConsoleContents] setSellSectionCategory:sellSectionCategory title:title] ;
    [self showProgress] ;
    
    return YES ;
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Save
            //NSLog(@"save") ;
            if([self saveValues]){
                //[super didTapClose] ; // 応答が来てからクローズする
            }
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


- (void)showProgress
{
    //NSLog(@"%@::showProgress",NSStringFromClass([self class])) ;
    if(!progressView){
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
        [progressView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77000000"]] ;
        progressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
        progressIndicator.center = progressView.center ;
        [progressView addSubview:progressIndicator] ;
        [self.view addSubview:progressView] ;
    }
    
    [progressIndicator startAnimating] ;
    [progressView setAlpha:1.0] ;
}

- (void)hideProgress
{
    //NSLog(@"%@::hideProgress",NSStringFromClass([self class])) ;
    [progressView setAlpha:0.0] ;
    [progressIndicator stopAnimating] ;
}

- (void)didChangeTextSelectValue:(ConsoleTextSelectBarView *)view inputValue:(NSString *)inputValue selectionValue:(NSString *)selectionValue
{
}

@end
