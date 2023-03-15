//
//  ConsoleEditWebViewController.m
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleEditWebViewController.h"
#import "VeamUtil.h"

#define CONSOLE_VIEW_TITLE          1
#define CONSOLE_VIEW_URL            2

@interface ConsoleEditWebViewController ()

@end

@implementation ConsoleEditWebViewController

@synthesize web ;

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
    
    currentY += [self addSectionHeader:NSLocalizedString(@"link_caption",nil) y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:NSLocalizedString(@"link_title",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    urlInputBarView = [self addTextInputBar:@"URL" y:currentY fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [urlInputBarView setDelegate:self] ;
    currentY += urlInputBarView.frame.size.height ;

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
    NSString *url = @"" ;
    if(web != nil){
        title = web.title ;
        url = web.url ;
    }
    [titleInputBarView setInputValue:title] ;
    [urlInputBarView setInputValue:url] ;
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




- (BOOL)isValueChanged
{
    BOOL retValue = NO ;
    if(web == nil){
        //NSLog(@"new") ;
        retValue = YES ;
    } else {
        NSString *title = [titleInputBarView getInputValue] ;
        NSString *url = [urlInputBarView getInputValue] ;
        if(
           ![title isEqualToString:web.title] ||
           ![url isEqualToString:web.url]
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
            [super didTapClose] ;
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
    NSString *url = [urlInputBarView getInputValue] ;
    if([VeamUtil isEmpty:title]){
        [VeamUtil dispError:@"Please input title"] ;
        return NO ;
    }
    if([VeamUtil isEmpty:url]){
        [VeamUtil dispError:@"Please input url"] ;
        return NO ;
    }
    
    if(web == nil){
        web = [[Web alloc] init] ;
    }
    //NSLog(@"name=%@ url=%@",title,url) ;
    [web setTitle:title] ;
    [web setUrl:url] ;
    [[ConsoleUtil getConsoleContents] setWeb:web] ;

    return YES ;
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Save
            //NSLog(@"save") ;
            if([self saveValues]){
                [super didTapClose] ;
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




@end
