//
//  ConsoleAppDesignViewController.m
//  veam00000000
//
//  Created by veam on 6/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleAppDesignViewController.h"
#import "ConsoleEditAppColorViewController.h"

#define CONSOLE_VIEW_COLOR                  1
#define CONSOLE_VIEW_BACKGROUND_IMAGE       2
#define CONSOLE_VIEW_SPLASH_IMAGE           3
#define CONSOLE_VIEW_ICON_IMAGE             4

@interface ConsoleAppDesignViewController ()

@end

@implementation ConsoleAppDesignViewController

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
    
    
    CGFloat currentY = [self addMainScrollViewWithTitle:@"App Design" subTitle:@""] ;
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
    currentY += [self addTextBar:@"Colors" y:currentY fullBottomLine:NO selector:@selector(didTapColors)].frame.size.height ;
    
    // 640:1136
    backgroundImageInputBarView = [self addImageInputBar:@"Background" y:currentY fullBottomLine:NO
                                      displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_BACKGROUND_IMAGE] ;
    currentY += backgroundImageInputBarView.frame.size.height ;
    
    splashImageInputBarView = [self addImageInputBar:@"Splash" y:currentY fullBottomLine:NO
                                            displayWidth:200 displayHeight:355 cropWidth:640 cropHeight:1136 resizableCropArea:NO tag:CONSOLE_VIEW_SPLASH_IMAGE] ;
    currentY += backgroundImageInputBarView.frame.size.height ;
    
    iconImageInputBarView = [self addImageInputBar:@"Icon" y:currentY fullBottomLine:YES
                                            displayWidth:200 displayHeight:200 cropWidth:1024 cropHeight:1024 resizableCropArea:NO tag:CONSOLE_VIEW_ICON_IMAGE] ;
    currentY += backgroundImageInputBarView.frame.size.height ;
    
    [self reloadValues] ;

    return currentY ;
}




- (void)didTapColors
{
    //NSLog(@"didTapColors") ;
    ConsoleEditAppColorViewController *appColorViewController = [[ConsoleEditAppColorViewController alloc] init] ;
    [self pushViewController:appColorViewController] ;

    /*
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = [UIColor whiteColor] ;
    controller.title = @"My dialog title";
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navVC animated:YES completion:nil];
     */
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color
{
    //NSLog(@"didSelectColor") ;
    // Do something with the color.
    self.view.backgroundColor = color;
    [controller dismissViewControllerAnimated:YES completion:nil] ;
}

- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_BACKGROUND_IMAGE:
            //NSLog(@"CONSOLE_VIEW_BACKGROUND_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setAppBackgroundImage:value] ;
            break;
        case CONSOLE_VIEW_SPLASH_IMAGE:
            //NSLog(@"CONSOLE_VIEW_SPLASH_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setAppSplashImage:value] ;
            break;
        case CONSOLE_VIEW_ICON_IMAGE:
            //NSLog(@"CONSOLE_VIEW_ICON_IMAGE") ;
            [[ConsoleUtil getConsoleContents] setAppIconImage:value] ;
            break;
        default:
            break;
    }
}

- (void)reloadValues
{
    // set title
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    [backgroundImageInputBarView setInputValue:contents.appInfo.backgroundImageUrl] ;
    [splashImageInputBarView setInputValue:contents.appInfo.splashImageUrl] ;
    [iconImageInputBarView setInputValue:contents.appInfo.iconImageUrl] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}



@end