//
//  ConsoleStarterTutorialViewController.m
//  veam00000000
//
//  Created by veam on 2/16/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleStarterTutorialViewController.h"
#import "VeamUtil.h"
#import "ConsoleStarterColorPickerViewController.h"

@interface ConsoleStarterTutorialViewController ()

@end

@implementation ConsoleStarterTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"%@::viewDidLoad",NSStringFromClass([self class])) ;

    CGFloat currentY = 55 ;
    
    UIImage *topIconImage = [UIImage imageNamed:@"start_tutorial_icon.png"] ;
    CGFloat imageWidth = topIconImage.size.width / 2 ;
    CGFloat imageHeight = topIconImage.size.height / 2 ;
    UIImageView *topIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, currentY, imageWidth, imageHeight)] ;
    [topIconImageView setImage:topIconImage] ;
    [self.view addSubview:topIconImageView] ;
    
    currentY += imageHeight ;
    currentY += 10 ;
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], 24)] ;
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [descriptionLabel setText:@"Select color and photo"] ;
    [descriptionLabel setTextColor:[UIColor whiteColor]] ;
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]] ;
    [self.view addSubview:descriptionLabel] ;
    
    currentY += descriptionLabel.frame.size.height ;
    currentY += 10 ;
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], 12)] ;
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [descriptionLabel setText:@"will be used in the apps."] ;
    [descriptionLabel setTextColor:[UIColor whiteColor]] ;
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [self.view addSubview:descriptionLabel] ;

    currentY += descriptionLabel.frame.size.height ;
    currentY += 27 ;
    
    UIImage *ssImage = [UIImage imageNamed:@"start_tutorial_ss1.png"] ;
    imageWidth = ssImage.size.width / 2 ;
    imageHeight = ssImage.size.height / 2 ;
    UIImageView *ssImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, currentY, imageWidth, imageHeight)] ;
    [ssImageView setImage:ssImage] ;
    [self.view addSubview:ssImageView] ;

    
    [self showHeader:@"" backgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;

}

- (void)didHeaderNextTap
{
    //NSLog(@"%@::didHeaderNextTap",NSStringFromClass([self class])) ;

    ConsoleStarterColorPickerViewController *viewController = [[ConsoleStarterColorPickerViewController alloc] init] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
