//
//  ConsoleEditBankAccountViewController.m
//  veam00000000
//
//  Created by veam on 2/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleEditBankAccountViewController.h"

#define CONSOLE_VIEW_ROUTING_NUMBER             1
#define CONSOLE_VIEW_ACCOUNT_NUMBER             2
#define CONSOLE_VIEW_ACCOUNT_NAME               3
#define CONSOLE_VIEW_ACCOUNT_TYPE               4
#define CONSOLE_VIEW_STREET_ADDRESS             5
#define CONSOLE_VIEW_CITY                       6
#define CONSOLE_VIEW_STATE                      7
#define CONSOLE_VIEW_ZIP_CODE                   8

@interface ConsoleEditBankAccountViewController ()

@end

@implementation ConsoleEditBankAccountViewController

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
    
    CGFloat currentY = y ;
    /*
     currentY += [self addSectionHeader:@"App Information" y:currentY] ;
     */
    
    
    routingNumberInputBarView = [self addTextInputBar:@"Routing Number" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_ROUTING_NUMBER] ;
    [routingNumberInputBarView setDelegate:self] ;
    currentY += routingNumberInputBarView.frame.size.height ;
    
    accountNumberInputBarView = [self addTextInputBar:@"Account Number" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_ACCOUNT_NUMBER] ;
    [accountNumberInputBarView setDelegate:self] ;
    currentY += accountNumberInputBarView.frame.size.height ;
    
    accountNameInputBarView = [self addTextInputBar:@"Account Name" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_ACCOUNT_NAME] ;
    [accountNameInputBarView setDelegate:self] ;
    currentY += accountNameInputBarView.frame.size.height ;
    
    accountTypeInputBarView = [self addTextInputBar:@"Account Type" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_ACCOUNT_TYPE] ;
    [accountTypeInputBarView setDelegate:self] ;
    currentY += accountTypeInputBarView.frame.size.height ;
    
    streetAddressInputBarView = [self addLongTextInputBar:@"Street Address" y:currentY height:130 fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_STREET_ADDRESS] ;
    [streetAddressInputBarView setDelegate:self] ;
    currentY += streetAddressInputBarView.frame.size.height ;

    cityInputBarView = [self addTextInputBar:@"City" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_CITY] ;
    [cityInputBarView setDelegate:self] ;
    currentY += cityInputBarView.frame.size.height ;
    
    stateInputBarView = [self addTextInputBar:@"State" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_STATE] ;
    [stateInputBarView setDelegate:self] ;
    currentY += stateInputBarView.frame.size.height ;
    
    zipCodeInputBarView = [self addTextInputBar:@"Zip Code" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_ZIP_CODE] ;
    [zipCodeInputBarView setDelegate:self] ;
    currentY += zipCodeInputBarView.frame.size.height ;
    
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
    [routingNumberInputBarView setInputValue:contents.bankAccountInfo.routingNumber] ;
    [accountNumberInputBarView setInputValue:contents.bankAccountInfo.accountNumber] ;
    [accountNameInputBarView setInputValue:contents.bankAccountInfo.accountName] ;
    [accountTypeInputBarView setInputValue:contents.bankAccountInfo.accountType] ;
    [streetAddressInputBarView setInputValue:contents.bankAccountInfo.streetAddress] ;
    [cityInputBarView setInputValue:contents.bankAccountInfo.city] ;
    [stateInputBarView setInputValue:contents.bankAccountInfo.state] ;
    [zipCodeInputBarView setInputValue:contents.bankAccountInfo.zipCode] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
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


- (BOOL)isValueChanged
{
    BOOL retValue = NO ;
    
    NSString *routingNumber = [routingNumberInputBarView getInputValue] ;
    NSString *accountNumber = [accountNumberInputBarView getInputValue] ;
    NSString *accountName = [accountNameInputBarView getInputValue] ;
    NSString *accountType = [accountTypeInputBarView getInputValue] ;
    NSString *streetAddress = [streetAddressInputBarView getInputValue] ;
    NSString *city = [cityInputBarView getInputValue] ;
    NSString *state = [stateInputBarView getInputValue] ;
    NSString *zipCode = [zipCodeInputBarView getInputValue] ;
    
    if(![routingNumber isEqualToString:contents.bankAccountInfo.routingNumber] ||
       ![accountNumber isEqualToString:contents.bankAccountInfo.accountNumber] ||
       ![accountName isEqualToString:contents.bankAccountInfo.accountName] ||
       ![accountType isEqualToString:contents.bankAccountInfo.accountType] ||
       ![streetAddress isEqualToString:contents.bankAccountInfo.streetAddress] ||
       ![city isEqualToString:contents.bankAccountInfo.city] ||
       ![state isEqualToString:contents.bankAccountInfo.state] ||
       ![zipCode isEqualToString:contents.bankAccountInfo.zipCode]
       ){
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
    
}

- (void)saveValues
{
    //NSLog(@"%@::saveValues",NSStringFromClass([self class])) ;
    [contents.bankAccountInfo setRoutingNumber:[routingNumberInputBarView getInputValue]] ;
    [contents.bankAccountInfo setAccountNumber:[accountNumberInputBarView getInputValue]] ;
    [contents.bankAccountInfo setAccountName:[accountNameInputBarView getInputValue]] ;
    [contents.bankAccountInfo setAccountType:[accountTypeInputBarView getInputValue]] ;
    [contents.bankAccountInfo setStreetAddress:[streetAddressInputBarView getInputValue]] ;
    [contents.bankAccountInfo setCity:[cityInputBarView getInputValue]] ;
    [contents.bankAccountInfo setState:[stateInputBarView getInputValue]] ;
    [contents.bankAccountInfo setZipCode:[zipCodeInputBarView getInputValue]] ;

    [contents saveBankAccountInfo] ;
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
