//
//  ConsoleTabBarController.m
//  veam00000000
//
//  Created by veam on 5/29/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleTabBarController.h"
#import "VeamUtil.h"

@interface ConsoleTabBarController ()

@end

@implementation ConsoleTabBarController

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

    //[self.view setBackgroundColor:[UIColor greenColor]] ;
    //[self.tabBar setBackgroundColor:[VeamUtil getColorFromArgbString:@"33FF0000"]] ;
    
    CGRect tabFrame = self.tabBar.frame ;
    CGFloat offset = VEAM_CONSOLE_FOOTER_HEIGHT - tabFrame.size.height ;
    tabFrame.origin.y -= offset;
    tabFrame.size.height = VEAM_CONSOLE_FOOTER_HEIGHT ;
    self.tabBar.frame = tabFrame ;
    self.view.bounds = self.tabBar.bounds ;
    
    /*
    for(UIView *view in self.view.subviews) {
        [view setBackgroundColor:[UIColor redColor]] ;
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, self.view.frame.size.height+49, view.frame.size.width, view.frame.size.height)];
        } else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.view.frame.size.height)];
        }
    }
     */
    
    
    
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

@end
