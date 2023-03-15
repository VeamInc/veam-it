//
//  NotificationCellViewController.m
//  veam31000000
//
//  Created by veam on 7/24/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "NotificationCellViewController.h"

@interface NotificationCellViewController ()

@end

@implementation NotificationCellViewController

@synthesize cell ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //NSLog(@"NotificationCellViewController::initWithNibName %@",NSLocalizedString(@"release_to_refresh",nil)) ;
        NotificationCell *notificationCell = (NotificationCell *)self.view ;
        [notificationCell.updatingLabel setText:NSLocalizedString(@"updating",nil)] ;
        [notificationCell.instructionLabel setText:NSLocalizedString(@"release_to_refresh",nil)] ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
