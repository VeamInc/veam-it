//
//  ConsoleTemplateSubscriptionViewController.m
//  veam00000000
//
//  Created by veam on 6/17/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTemplateSubscriptionViewController.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleLongTextInputBarView.h"
#import "ConsoleSubscriptionSettingsViewController.h"
#import "ConsoleVideoCategoryViewController.h"
#import "ConsoleEditSubscriptionDescriptionViewController.h"

@interface ConsoleTemplateSubscriptionViewController ()

@end

@implementation ConsoleTemplateSubscriptionViewController

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
    
    
    CGFloat currentY = [self addMainScrollViewWithTitle:@"1.Subscription" subTitle:@""] ;
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
    currentY += [self addTextBar:@"Basic Settings" y:currentY fullBottomLine:NO selector:@selector(didTapBasicSettigns)].frame.size.height ;
    currentY += [self addTextBar:@"Category Settings" y:currentY fullBottomLine:YES selector:@selector(didTapCategorySettigns)].frame.size.height ;
    
    currentY += 16 ;
    
    currentY += [self addSectionHeader:@"Contents" y:currentY] ;
    currentY += [self addTextBar:NSLocalizedString(@"upload",nil) y:currentY fullBottomLine:YES selector:@selector(didTapUpload)].frame.size.height ;
    currentY += [self addTextBar:@"Description" y:currentY fullBottomLine:YES selector:@selector(didTapDescription)].frame.size.height ;
    
    return currentY ;
}




- (void)didTapBasicSettigns
{
    //NSLog(@"didTapBasicSettigns") ;
    ConsoleSubscriptionSettingsViewController *subscriptionSettingsViewController = [[ConsoleSubscriptionSettingsViewController alloc] init] ;
    [self pushViewController:subscriptionSettingsViewController] ;
}

- (void)didTapCategorySettigns
{
    //NSLog(@"didTapCategorySettigns") ;
    ConsoleVideoCategoryViewController *videoCategoryViewController = [[ConsoleVideoCategoryViewController alloc] init] ;
    [videoCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [videoCategoryViewController setShowFooter:YES] ;
    [videoCategoryViewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    [self pushViewController:videoCategoryViewController] ;
}

- (void)didTapUpload
{
    //NSLog(@"didTapUpload") ;
    ConsoleVideoCategoryViewController *videoCategoryViewController = [[ConsoleVideoCategoryViewController alloc] init] ;
    [videoCategoryViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [videoCategoryViewController setShowFooter:YES] ;
    [videoCategoryViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
    [self pushViewController:videoCategoryViewController] ;
}

- (void)didTapDescription
{
    //NSLog(@"didTapDescription") ;
    ConsoleEditSubscriptionDescriptionViewController *viewController = [[ConsoleEditSubscriptionDescriptionViewController alloc] init] ;
    [viewController setShowFooter:NO] ;
    [viewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
    [self pushViewController:viewController] ;
}



@end
