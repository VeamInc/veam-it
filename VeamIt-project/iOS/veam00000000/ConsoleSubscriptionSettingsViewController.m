//
//  ConsoleSubscriptionSettingsViewController.m
//  veam00000000
//
//  Created by veam on 6/17/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleSubscriptionSettingsViewController.h"
#import "ConsoleUtil.h"

#define CONSOLE_VIEW_TITLE          1
#define CONSOLE_VIEW_LAYOUT         2
#define CONSOLE_VIEW_KIND           3
#define CONSOLE_VIEW_RIGHT_IMAGE    4
#define CONSOLE_VIEW_PRICE          5

@interface ConsoleSubscriptionSettingsViewController ()

@end

@implementation ConsoleSubscriptionSettingsViewController

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
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE] ;
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
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *priceKey = @"subscription_prices" ;
    if([ConsoleUtil isLocaleJapanese]){
        priceKey = @"subscription_prices_ja" ;
    }
    NSArray *prices = [[contents getValueForKey:priceKey] componentsSeparatedByString:@"|"] ;

    CGFloat currentY = y ;
    
    currentY += [self addSectionHeader:@"Section Settings" y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:@"Title" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    priceInputBarView = [self addTextSelectBar:@"Price" selections:prices selectionValues:prices y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_PRICE] ;
    [priceInputBarView setDelegate:self] ;
    currentY += priceInputBarView.frame.size.height ;

    layoutInputBarView = [self addSwitchBar:@"Grid Layout" y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_LAYOUT] ;
     [layoutInputBarView setDelegate:self] ;
     currentY += layoutInputBarView.frame.size.height ;
    
    NSArray *kinds = [NSArray arrayWithObjects:@"Premium Videos + Archive Videos",@"Premium Q&A Videos",@"Premium Videos + Log Calendar", nil] ;
    NSArray *kindValues = [NSArray arrayWithObjects:VEAM_SUBSCRIPTION_KIND_VIDEOS,VEAM_SUBSCRIPTION_KIND_QA,VEAM_SUBSCRIPTION_KIND_CALENDAR, nil] ;
    kindInputBarView = [self addTextSelectBar:@"Kind" selections:kinds selectionValues:kindValues y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_KIND] ;
    [kindInputBarView setDelegate:self] ;
    currentY += kindInputBarView.frame.size.height ;

    rightImageInputBarView = [self addImageInputBar:@"Right image" y:currentY fullBottomLine:YES
                                       displayWidth:160 displayHeight:160 cropWidth:320 cropHeight:320 resizableCropArea:NO tag:CONSOLE_VIEW_RIGHT_IMAGE] ;
    currentY += rightImageInputBarView.frame.size.height ;
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    // set title
    //NSLog(@"%@::reloadValues",NSStringFromClass([self class])) ;
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    //NSLog(@"Kind %@",contents.templateSubscription.kind) ;
    [titleInputBarView setInputValue:contents.templateSubscription.title] ;
    [priceInputBarView setSelectionValue:contents.templateSubscription.price] ;
    [layoutInputBarView setInputValue:[contents.templateSubscription.layout isEqualToString:@"2"]] ;
    [kindInputBarView setSelectionValue:contents.templateSubscription.kind] ;
    [rightImageInputBarView setInputValue:contents.templateSubscription.rightImageUrl] ;
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
            [[ConsoleUtil getConsoleContents] setTemplateSubscriptionTitle:value] ;
            break;
        default:
            break;
    }
}

- (void)didChangeSwitchValue:(ConsoleSwitchBarView *)view value:(BOOL)value
{
    //NSLog(@"%@::didChangeSwitchValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_LAYOUT:
            if(value){
                [[ConsoleUtil getConsoleContents] setTemplateSubscriptionLayout:VEAM_SUBSCRIPTION_LAYOUT_GRID] ;
            } else {
                [[ConsoleUtil getConsoleContents] setTemplateSubscriptionLayout:VEAM_SUBSCRIPTION_LAYOUT_LIST] ;
            }
             break;
        default:
            break;
    }
}

- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_RIGHT_IMAGE:
            //NSLog(@"CONSOLE_VIEW_RIGHT_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setTemplateSubscriptionRightImage:value] ;
            break;
        default:
            break;
    }
}

- (void)didChangeTextSelectValue:(ConsoleTextSelectBarView *)view inputValue:(NSString *)inputValue selectionValue:(NSString *)selectionValue
{
    switch (view.tag) {
        case CONSOLE_VIEW_PRICE:
            [[ConsoleUtil getConsoleContents] setTemplateSubscriptionPrice:selectionValue] ;
            break;
        case CONSOLE_VIEW_KIND:
            [[ConsoleUtil getConsoleContents] setTemplateSubscriptionKind:selectionValue] ;
            break;
        default:
            break;
    }
}



@end
