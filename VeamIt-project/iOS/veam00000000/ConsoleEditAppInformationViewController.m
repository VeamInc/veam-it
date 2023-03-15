//
//  ConsoleEditAppInformationViewController.m
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditAppInformationViewController.h"
#import "ConsoleEditAppRatingViewController.h"
#import "ConsoleUtil.h"
#import "VeamUtil.h"

#define CONSOLE_VIEW_APP_NAME           1
#define CONSOLE_VIEW_STORE_APP_NAME     2
#define CONSOLE_VIEW_DESCRIPTION        3
#define CONSOLE_VIEW_KEYWORD            4
#define CONSOLE_VIEW_CATEGORY           5
#define CONSOLE_VIEW_RATING             6
#define CONSOLE_VIEW_SCREEN_SHOT_1      7
#define CONSOLE_VIEW_SCREEN_SHOT_2      8
#define CONSOLE_VIEW_SCREEN_SHOT_3      9
#define CONSOLE_VIEW_SCREEN_SHOT_4      10
#define CONSOLE_VIEW_SCREEN_SHOT_5      11

@interface ConsoleEditAppInformationViewController ()

@end

@implementation ConsoleEditAppInformationViewController

@synthesize appInfo ;

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
        [self setHeaderRightText:@"Done"] ;
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
    
    contents = [ConsoleUtil getConsoleContents] ;
    NSString *appCategoryKey = @"app_categories" ;
    if([ConsoleUtil isLocaleJapanese]){
        appCategoryKey = @"app_categories_ja" ;
    }
    NSArray *appCategories = [[contents getValueForKey:appCategoryKey] componentsSeparatedByString:@"|"] ;

    CGFloat currentY = y ;
    /*
    currentY += [self addSectionHeader:@"App Information" y:currentY] ;
     */
    
    
    appNameInputBarView = [self addTextInputBar:NSLocalizedString(@"app_info_app_name", nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_APP_NAME] ;
    [appNameInputBarView setDelegate:self] ;
    currentY += appNameInputBarView.frame.size.height ;
    
    storeAppNameInputBarView = [self addTextInputBar:NSLocalizedString(@"app_info_store_app_name", nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_STORE_APP_NAME] ;
    [storeAppNameInputBarView setDelegate:self] ;
    currentY += storeAppNameInputBarView.frame.size.height ;
    
    descriptionInputBarView = [self addLongTextInputBar:NSLocalizedString(@"app_info_description", nil) y:currentY height:130 fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_DESCRIPTION] ;
    [descriptionInputBarView setDelegate:self] ;
    currentY += descriptionInputBarView.frame.size.height ;
    
    keywordInputBarView = [self addLongTextInputBar:NSLocalizedString(@"app_info_keywords", nil) y:currentY height:90 fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_KEYWORD] ;
    [keywordInputBarView setDelegate:self] ;
    currentY += keywordInputBarView.frame.size.height ;
    
    categoryInputBarView = [self addTextSelectBar:NSLocalizedString(@"app_info_category", nil) selections:appCategories selectionValues:appCategories y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_CATEGORY] ;
    [categoryInputBarView setDelegate:self] ;
    currentY += categoryInputBarView.frame.size.height ;
    
    currentY += [self addTextBar:NSLocalizedString(@"app_info_rating", nil) y:currentY fullBottomLine:NO selector:@selector(didTapRating)].frame.size.height ;

    /*
    screenShot1ImageInputBarView = [self addImageInputBar:@"Screen Shot 1" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_1] ;
    currentY += screenShot1ImageInputBarView.frame.size.height ;
    
    screenShot2ImageInputBarView = [self addImageInputBar:@"Screen Shot 2" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_2] ;
    currentY += screenShot2ImageInputBarView.frame.size.height ;
    
    screenShot3ImageInputBarView = [self addImageInputBar:@"Screen Shot 3" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_3] ;
    currentY += screenShot3ImageInputBarView.frame.size.height ;
    
    screenShot4ImageInputBarView = [self addImageInputBar:@"Screen Shot 4" y:currentY fullBottomLine:NO
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_4] ;
    currentY += screenShot4ImageInputBarView.frame.size.height ;
    
    screenShot5ImageInputBarView = [self addImageInputBar:@"Screen Shot 5" y:currentY fullBottomLine:YES
                                             displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SCREEN_SHOT_5] ;
    currentY += screenShot5ImageInputBarView.frame.size.height ;
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
    contents = [ConsoleUtil getConsoleContents] ;
    [appNameInputBarView setInputValue:contents.appInfo.name] ;
    [storeAppNameInputBarView setInputValue:contents.appInfo.storeAppName] ;
    [descriptionInputBarView setInputValue:contents.appInfo.description] ;
    [keywordInputBarView setInputValue:contents.appInfo.keyword] ;
    [categoryInputBarView setInputValue:contents.appInfo.category] ;
    [screenShot1ImageInputBarView setInputValue:contents.appInfo.screenShot1Url] ;
    [screenShot2ImageInputBarView setInputValue:contents.appInfo.screenShot2Url] ;
    [screenShot3ImageInputBarView setInputValue:contents.appInfo.screenShot3Url] ;
    [screenShot4ImageInputBarView setInputValue:contents.appInfo.screenShot4Url] ;
    [screenShot5ImageInputBarView setInputValue:contents.appInfo.screenShot5Url] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    //[self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)didChangeTextInputValue:(ConsoleTextInputBarView *)view value:(NSString *)value
{
    /*
    switch (view.tag) {
        case CONSOLE_VIEW_APP_NAME:
            [[ConsoleUtil getConsoleContents] setAppName:value] ;
            break;
        case CONSOLE_VIEW_STORE_APP_NAME:
            [[ConsoleUtil getConsoleContents] setAppStoreAppName:value] ;
            break;
        case CONSOLE_VIEW_KEYWORD:
            [[ConsoleUtil getConsoleContents] setAppKeyword:value] ;
            break;
        default:
            break;
    }
     */
}

- (void)didChangeTextSelectValue:(ConsoleTextSelectBarView *)view inputValue:(NSString *)inputValue selectionValue:(NSString *)selectionValue
{
    /*
    switch (view.tag) {
        case CONSOLE_VIEW_CATEGORY:
            [[ConsoleUtil getConsoleContents] setAppCategory:inputValue] ;
            break;
        default:
            break;
    }
     */
}

- (void)didChangeLongTextInputValue:(ConsoleLongTextInputBarView *)view value:(NSString *)value
{
    //NSLog(@"%@::didChangeLongTextInputValue",NSStringFromClass([self class])) ;
    if(view.tag == CONSOLE_VIEW_KEYWORD){
        NSString *keyword = [keywordInputBarView getInputValue] ;
        //NSLog(@"keyword=%@",keyword) ;
        if([keyword length] > 100){
            NSString *shortenKeyword = [keyword substringWithRange:NSMakeRange(0, 100)] ;
            [keywordInputBarView setInputValue:shortenKeyword] ;
            [VeamUtil dispError:@"You can only use up to 100 characters for keywords"] ;
        }
    }
    /*
    switch (view.tag) {
        case CONSOLE_VIEW_DESCRIPTION:
            [[ConsoleUtil getConsoleContents] setAppDescription:value] ;
            break;
        default:
            break;
    }
     */
}

- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_SCREEN_SHOT_1:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_1") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"1"] ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_2:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_2") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"2"] ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_3:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_3") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"3"] ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_4:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_4") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"4"] ;
            break;
        case CONSOLE_VIEW_SCREEN_SHOT_5:
            //NSLog(@"CONSOLE_VIEW_SCREEN_SHOT_5") ;
            [[ConsoleUtil getConsoleContents] setAppScreenShot:value name:@"5"] ;
            break;
        default:
            break;
    }
}

- (void)didTapRating
{
    //NSLog(@"didTapRating") ;
    ConsoleEditAppRatingViewController *appRatingViewController = [[ConsoleEditAppRatingViewController alloc] init] ;
    [self pushViewController:appRatingViewController] ;
}

- (BOOL)isValueChanged
{
    BOOL retValue = NO ;
    
    NSString *appName = [appNameInputBarView getInputValue] ;
    NSString *storeAppName = [storeAppNameInputBarView getInputValue] ;
    NSString *description = [descriptionInputBarView getInputValue] ;
    NSString *keyword = [keywordInputBarView getInputValue] ;
    NSString *category = [categoryInputBarView getInputValue] ;
    if(![appName isEqualToString:contents.appInfo.name] ||
       ![storeAppName isEqualToString:contents.appInfo.storeAppName] ||
       ![description isEqualToString:contents.appInfo.description] ||
       ![keyword isEqualToString:contents.appInfo.keyword] ||
       ![category isEqualToString:contents.appInfo.category]
      ){
        //NSLog(@"modified (%@:%@) (%@:%@)",appName,contents.appInfo.name,storeAppName,contents.appInfo.storeAppName) ;
        retValue = YES ;
    }
    
    return retValue ;
}

- (BOOL)isDescriptionChanged
{
    BOOL retValue = NO ;
    
    NSString *description = [descriptionInputBarView getInputValue] ;
    if(![description isEqualToString:contents.appInfo.description]){
        //NSLog(@"modified (%@:%@) (%@:%@)",appName,contents.appInfo.name,storeAppName,contents.appInfo.storeAppName) ;
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
    
    /*
    [descriptionInputBarView setInputValue:contents.appInfo.description] ;
    [keywordInputBarView setInputValue:contents.appInfo.keyword] ;
    [categoryInputBarView setInputValue:contents.appInfo.category] ;
    [screenShot1ImageInputBarView setInputValue:contents.appInfo.screenShot1Url] ;
    [screenShot2ImageInputBarView setInputValue:contents.appInfo.screenShot2Url] ;
    [screenShot3ImageInputBarView setInputValue:contents.appInfo.screenShot3Url] ;
    [screenShot4ImageInputBarView setInputValue:contents.appInfo.screenShot4Url] ;
    [screenShot5ImageInputBarView setInputValue:contents.appInfo.screenShot5Url] ;
     */
}

- (void)saveValues
{
    //NSLog(@"%@::saveValues",NSStringFromClass([self class])) ;
    if([self isDescriptionChanged]){
        [contents setValueForKey:@"app_description_set" value:@"1"] ;
    }
    [contents.appInfo setName:[appNameInputBarView getInputValue]] ;
    [contents.appInfo setStoreAppName:[storeAppNameInputBarView getInputValue]] ;
    [contents.appInfo setDescription:[descriptionInputBarView getInputValue]] ;
    [contents.appInfo setKeyword:[keywordInputBarView getInputValue]] ;
    [contents.appInfo setCategory:[categoryInputBarView getInputValue]] ;
    [contents saveAppInfo] ;
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

@end
