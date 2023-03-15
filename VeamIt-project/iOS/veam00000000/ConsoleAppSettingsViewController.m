//
//  ConsoleAppSettingsViewController.m
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleAppSettingsViewController.h"
#import "ConsoleAppStoreViewController.h"
#import "ConsoleEditAppInformationViewController.h"
#import "ConsoleEditAccountViewController.h"
#import "VeamUtil.h"

@interface ConsoleAppSettingsViewController ()

@end

@implementation ConsoleAppSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CGFloat currentY = [self addMainScrollViewWithTitle:@"Basic Settings" subTitle:@""] ;
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
    
    currentY += [self addSectionHeader:@"General" y:currentY] ;
    currentY += [self addTextBar:@"Account" y:currentY fullBottomLine:NO selector:@selector(didTapAccount)].frame.size.height ;
    currentY += [self addTextBar:@"Terms of Use" y:currentY fullBottomLine:YES selector:@selector(didTapTerms)].frame.size.height ;
    
    currentY += 16 ;
    
    currentY += [self addSectionHeader:@"App Settings" y:currentY] ;
    currentY += [self addTextBar:@"App Information" y:currentY fullBottomLine:NO selector:@selector(didTapAppInformation)].frame.size.height ;
    currentY += [self addTextBar:@"Bank Account" y:currentY fullBottomLine:YES selector:@selector(didTapBankAccount)].frame.size.height ;
    
    currentY += 16 ;

    currentY += [self addSectionHeader:@"Preview Settings" y:currentY] ;
    currentY += [self addTextBar:@"Clear Data" y:currentY fullBottomLine:YES selector:@selector(didTapPreviewClearData)].frame.size.height ;
    
    currentY += 16 ;
    
    [self reloadValues] ;
    
    return currentY ;
}




- (void)didTapAppInformation
{
    //NSLog(@"didTapAppInformation") ;
    if([ConsoleUtil isConsoleLoggedin]){
        //ConsoleEditAppInformationViewController *appInformationViewController = [[ConsoleEditAppInformationViewController alloc] init] ;
        //[self pushViewController:appInformationViewController] ;
        ConsoleAppStoreViewController *appStoreViewController = [[ConsoleAppStoreViewController alloc] init] ;
        
        [appStoreViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
        [appStoreViewController setHeaderTitle:NSLocalizedString(@"required_app_information",nil)] ;
        [appStoreViewController setNumberOfHeaderDots:0] ;
        [appStoreViewController setSelectedHeaderDot:0] ;
        [appStoreViewController setShowFooter:NO] ;
        [appStoreViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
        
        [self pushViewController:appStoreViewController] ;
    } else {
        [VeamUtil dispMessage:@"Please Login" title:@""] ;
    }
}

- (void)didTapBankAccount
{
    //NSLog(@"didTapBankAccount") ;
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}

- (void)didTapPreviewClearData
{
    //NSLog(@"didTapPreviewClearData") ;
    [ConsoleUtil clearPreviewData] ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear Preview Data" message:@"Completed"
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)didTapAccount
{
    //NSLog(@"didTapAccount") ;
    ConsoleEditAccountViewController *appAccountViewController = [[ConsoleEditAccountViewController alloc] init] ;
    [self pushViewController:appAccountViewController] ;
}

- (void)didTapPassword
{
    //NSLog(@"didTapPassword") ;
}

- (void)didTapTerms
{
    //NSLog(@"didTapTerms") ;
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}

- (void)reloadValues
{
    // set title
    //ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;

    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}


@end
