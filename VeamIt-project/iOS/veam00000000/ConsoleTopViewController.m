//
//  ConsoleTopViewController.m
//  veam00000000
//
//  Created by veam on 5/28/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTopViewController.h"
#import "VeamUtil.h"
#import "ConsoleElementCell.h"
#import "ConsoleTemplateSubscriptionViewController.h"
#import "ConsoleTemplateYoutubeViewController.h"
#import "ConsoleTemplateMixedViewController.h"
#import "ConsoleTemplateWebViewController.h"
#import "ConsoleTemplateForumViewController.h"
#import "ConsoleElement.h"
#import "ConsoleAppDesignViewController.h"
#import "ConsoleAppSettingsViewController.h"
#import "ConsoleHomeViewController.h"

@interface ConsoleTopViewController ()

@end

@implementation ConsoleTopViewController

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
    
    consoleElements = [NSArray arrayWithObjects:
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_menu_icon.png" title:@"Menu&Icon" needLogin:YES selector:@selector(didTapIconMenuIcon)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_design.png" title:@"Design" needLogin:YES selector:@selector(didTapIconDesign)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_subscription.png" title:@"Subscription" needLogin:YES selector:@selector(didTapIconSubscription)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_youtube.png" title:@"YouTube" needLogin:YES selector:@selector(didTapIconYoutube)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_forum.png" title:@"Forum" needLogin:YES selector:@selector(didTapIconForum)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_patrol.png" title:@"Patrol" needLogin:YES selector:@selector(didTapIconPatrol)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_contents.png" title:@"Contents" needLogin:YES selector:@selector(didTapIconContents)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_link.png" title:@"Link" needLogin:YES selector:@selector(didTapIconLink)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_support.png" title:@"Support" needLogin:YES selector:@selector(didTapIconSupport)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_faq.png" title:@"FAQ" needLogin:NO selector:@selector(didTapIconFaq)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_mail.png" title:@"from Veam" needLogin:YES selector:@selector(didTapIconMail)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_settings.png" title:@"Settings" needLogin:NO selector:@selector(didTapIconSettings)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_notification.png" title:@"Notification" needLogin:YES selector:@selector(didTapIconNotification)],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       [[ConsoleElement alloc] initWithFileName:@"c_icon_none.png" title:@"" needLogin:YES selector:nil],
                       nil] ;
    
    CGFloat gridViewWidth = VEAM_CONSOLE_ELEMENT_WIDTH * 4 ;
    CGFloat margin = ([VeamUtil getScreenWidth] - gridViewWidth) / 2 ;
    
    gridView = [[AQGridView alloc] initWithFrame:CGRectMake(margin, 0, gridViewWidth, contentView.frame.size.height)] ;
    [gridView setBackgroundColor:[UIColor clearColor]] ;
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
	gridView.autoresizesSubviews = YES ;
	gridView.delegate = self ;
	gridView.dataSource = self ;
    gridView.separatorStyle = AQGridViewCellSeparatorStyleNone;
    gridView.showsVerticalScrollIndicator = NO ;
    gridView.resizesCellWidthToFit = NO;
    gridView.separatorColor = nil;
    UIEdgeInsets contentInset = gridView.contentInset ;
    if(self.headerStyle != VEAM_CONSOLE_HEADER_STYLE_NONE){
        contentInset.top = VEAM_CONSOLE_HEADER_HEIGHT ;
    } else {
        contentInset.top = 0 ;
    }
    if(self.showFooter){
        contentInset.bottom = VEAM_CONSOLE_FOOTER_HEIGHT ;
    }
    gridView.contentInset = contentInset ;
    [contentView addSubview:gridView] ;

    [gridView reloadData] ;

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

#pragma mark Grid View Data Source
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    //NSLog(@"numberOfItemsInGridView") ;
    NSUInteger retInt = [consoleElements count] ;
    return retInt ;
}

#define GRID_CELL_IDENTIFIER    @"GridCellIdentifier"
- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    //NSLog(@"cellForItemAtIndex index=%d",index) ;
    AQGridViewCell * cell = nil ;
    ConsoleElementCell * filledCell = [[ConsoleElementCell alloc] initWithFrame: CGRectMake(0.0, 0.0, VEAM_CONSOLE_ELEMENT_WIDTH, VEAM_CONSOLE_ELEMENT_HEIGHT) reuseIdentifier:GRID_CELL_IDENTIFIER] ;
    filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray ;
    
    ConsoleElement *consoleElement = [consoleElements objectAtIndex:index] ;
    [filledCell setBackgroundColor:[UIColor clearColor]] ;
    [filledCell setIconImage:[UIImage imageNamed:consoleElement.fileName]] ;
    [filledCell setTitle:consoleElement.title] ;
    if(consoleElement.needLogin && ![ConsoleUtil isConsoleLoggedin]){
        [filledCell setActivate:NO] ;
    }
    cell = filledCell;
    
    return ( cell );
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return ( CGSizeMake(VEAM_CONSOLE_ELEMENT_WIDTH, VEAM_CONSOLE_ELEMENT_HEIGHT) );
}

- (void)gridView:(AQGridView *)aGridView didSelectItemAtIndex:(NSUInteger)index
{
    //NSLog(@"selected item %d",index) ;
    
    [gridView deselectItemAtIndex:index animated:NO] ;
    
    ConsoleElement *consoleElement = [consoleElements objectAtIndex:index] ;
    if(!consoleElement.needLogin || [ConsoleUtil isConsoleLoggedin]){
        if(consoleElement.selector != nil){
            [self performSelector:consoleElement.selector] ;
        }
    }
}

- (void)didTapIconMenuIcon
{
    ConsoleHomeViewController *homeViewController = [[ConsoleHomeViewController alloc] init] ;
    [homeViewController setMode:VEAM_CONSOLE_HOME_MODE_INSTALLED] ;
    [self showViewController:homeViewController] ;
    //[VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}

- (void)didTapIconDesign
{
    ConsoleAppDesignViewController *designViewController = [[ConsoleAppDesignViewController alloc] init] ;
    [designViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_NONE] ;
    [designViewController setShowFooter:YES] ;
    [self showViewController:designViewController] ;
}


- (void)didTapIconSubscription
{
    ConsoleTemplateSubscriptionViewController *subscriptionViewController = [[ConsoleTemplateSubscriptionViewController alloc] init] ;
    [subscriptionViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_NONE] ;
    [subscriptionViewController setShowFooter:YES] ;
    [self showViewController:subscriptionViewController] ;
}


- (void)didTapIconYoutube
{
    ConsoleTemplateYoutubeViewController *youtubeViewController = [[ConsoleTemplateYoutubeViewController alloc] init] ;
    [youtubeViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_NONE] ;
    [youtubeViewController setShowFooter:YES] ;
    [self showViewController:youtubeViewController] ;
}


- (void)didTapIconForum
{
    ConsoleTemplateForumViewController *forumViewController = [[ConsoleTemplateForumViewController alloc] init] ;
    [forumViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_NONE] ;
    [forumViewController setShowFooter:YES] ;
    [self showViewController:forumViewController] ;
}


- (void)didTapIconPatrol
{
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}


- (void)didTapIconContents
{
    ConsoleTemplateMixedViewController *mixedViewController = [[ConsoleTemplateMixedViewController alloc] init] ;
    [mixedViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_NONE] ;
    [mixedViewController setShowFooter:YES] ;
    [self showViewController:mixedViewController] ;
}


- (void)didTapIconLink
{
    ConsoleTemplateWebViewController *webViewController = [[ConsoleTemplateWebViewController alloc] init] ;
    [webViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_NONE] ;
    [webViewController setShowFooter:YES] ;
    [self showViewController:webViewController] ;
}


- (void)didTapIconSupport
{
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}


- (void)didTapIconFaq
{
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}


- (void)didTapIconMail
{
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}


- (void)didTapIconSettings
{
    ConsoleAppSettingsViewController *appSettingsViewController = [[ConsoleAppSettingsViewController alloc] init] ;
    [appSettingsViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_NONE] ;
    [appSettingsViewController setShowFooter:YES] ;
    [self showViewController:appSettingsViewController] ;
}


- (void)didTapIconNotification
{
    [VeamUtil dispMessage:@"Not implemented yet" title:@""] ;
}






- (void)showViewController:(UIViewController *)viewController
{
        [UIView transitionWithView:self.navigationController.view duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.navigationController pushViewController:viewController animated:NO] ;
                        } completion:nil];
}

#pragma mark -
#pragma mark Grid View Delegate

- (void)reloadValues
{
    [gridView reloadData] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}


@end
