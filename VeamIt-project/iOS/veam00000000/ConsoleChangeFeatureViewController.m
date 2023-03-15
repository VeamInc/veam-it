//
//  ConsoleChangeFeatureViewController.m
//  veam00000000
//
//  Created by veam on 10/28/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleChangeFeatureViewController.h"
#import "VeamUtil.h"
#import "ConsoleMixedForGridTableViewCell.h"
#import "ConsoleMixedNotificationTableViewCell.h"
#import "ImageDownloader.h"
#import "ConsoleTutorialViewController.h"
#import "AppDelegate.h"
#import "ConsoleEditVideoForMixedViewController.h"
#import "ConsoleEditAudioViewController.h"
#import "ConsoleEditSubscriptionDescriptionViewController.h"

#define ACTION_SHEET_SELECT_FEATURE         3

@interface ConsoleChangeFeatureViewController ()

@end

@implementation ConsoleChangeFeatureViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.shouldShowFloatingMenu = NO ;
    }
    return self;
}

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
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    features = [NSMutableArray arrayWithObjects:
                VEAM_SUBSCRIPTION_KIND_MIXED_GRID,
                VEAM_SUBSCRIPTION_KIND_SELL_VIDEOS,
                VEAM_SUBSCRIPTION_KIND_SELL_SECTION,
                /* VEAM_SUBSCRIPTION_KIND_MIXED_GRID, */
                nil] ;
    
    featurePrices = [NSMutableArray arrayWithObjects:
                     @"$",
                     @"$",
                     @"$",
                     /* @"0", */
                nil] ;
    
    CGFloat currentY = [self addNormalTableView] ;
    [normalTableView setDelegate:self] ;
    [normalTableView setDataSource:self] ;
    [normalTableView setContentInset:UIEdgeInsetsMake(44, 0, 100, 0)] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // this will not be called because of HPReorderTableView
    //NSLog(@"numberOfSectionsInTableView") ;
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 1 ;
    return retValue ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat retValue = 0 ;
    if(section == 1){
        retValue = 44.0 ;
    }
    return retValue ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = nil ;
    return sectionHeaderView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44 ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@::cellForRowAtIndexPath section=%d row=%d",NSStringFromClass([self class]),indexPath.section,indexPath.row) ;
    
    UITableViewCell *cell = nil ;
    NSInteger index = indexPath.row ;
    if(index == 0){
        UITableViewCell *featureCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"feature"] ;
        [featureCell.textLabel setTextColor:[UIColor blackColor]] ;
        [featureCell.textLabel setText:NSLocalizedString(@"payment_type",nil)] ;
        [featureCell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
        [featureCell.detailTextLabel setTextColor:[UIColor redColor]] ;
        [featureCell.detailTextLabel setText:[VeamUtil getPaymentTypeString:[ConsoleUtil getConsoleContents].templateSubscription.kind price:[ConsoleUtil getConsoleContents].templateSubscription.price]] ;
        [featureCell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]] ;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [VeamUtil getScreenWidth], 0.5)] ;
        separatorView.backgroundColor = [UIColor blackColor] ;
        [featureCell.contentView addSubview:separatorView] ;
        
        cell = featureCell ;
    }
    [cell setBackgroundColor:[UIColor clearColor]] ;
    [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnknownCell"] ;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
        [cell.textLabel setText:@""] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath row=%d",indexPath.row) ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.row == 0){
        // edit feature
        //NSLog(@"edit feature") ;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"payment",nil)
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:nil] ;
        
        for(int featureIndex = 0 ; featureIndex < [features count] ; featureIndex++){
            NSString *featureString = [VeamUtil getPaymentTypeString:[features objectAtIndex:featureIndex] price:[featurePrices objectAtIndex:featureIndex]] ;
            [actionSheet addButtonWithTitle:featureString] ;
        }
        [actionSheet addButtonWithTitle:@"Cancel"] ;
        [actionSheet setCancelButtonIndex:[features count]] ;
        [actionSheet setTag:ACTION_SHEET_SELECT_FEATURE] ;
        
        // アクションシートの表示
        [actionSheet showInView:self.view] ;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSInteger tag = actionSheet.tag ;
    if(tag == ACTION_SHEET_SELECT_FEATURE){
        if(buttonIndex < [features count]){
            NSString *subscriptionKindString = [features objectAtIndex:buttonIndex] ;
            NSString *subscriptionPriceString = [featurePrices objectAtIndex:buttonIndex] ;
            //NSString *featureString = [VeamUtil getPaymentTypeString:subscriptionKindString price:subscriptionPriceString] ;
            //NSLog(@"feature = %@",featureString) ;
            [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
            if([subscriptionPriceString isEqualToString:@"0"]){
                [ConsoleUtil getConsoleContents].templateSubscription.price = @"0" ;
            } else {
                if([[ConsoleUtil getConsoleContents].templateSubscription.price isEqualToString:@"0"]){
                    [ConsoleUtil getConsoleContents].templateSubscription.price = [ConsoleUtil getPrices][0] ;
                }
            }
            [[ConsoleUtil getConsoleContents] setTemplateSubscriptionKind:subscriptionKindString] ;
        }
    }
}

- (void)reloadValues
{
    [normalTableView reloadData] ;
}


- (void)showProgress
{
    //NSLog(@"%@::showProgress",NSStringFromClass([self class])) ;
    if(!progressView){
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
        [progressView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77000000"]] ;
        progressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
        progressIndicator.center = progressView.center ;
        [progressView addSubview:progressIndicator] ;
        [self.view addSubview:progressView] ;
    }
    
    [progressIndicator startAnimating] ;
    [progressView setAlpha:1.0] ;
}

- (void)hideProgress
{
    //NSLog(@"%@::hideProgress",NSStringFromClass([self class])) ;
    [progressView setAlpha:0.0] ;
    [progressIndicator stopAnimating] ;
}

- (void)contentsDidUpdate:(NSNotification *)notification
{
    [super contentsDidUpdate:notification] ;
    
    NSString *value = [[notification userInfo] objectForKey:@"ACTION"] ;
    if(![VeamUtil isEmpty:value] && [value isEqualToString:@"CONTENT_POST_DONE"]){
        NSString *apiName = [[notification userInfo] objectForKey:@"API_NAME"] ;
        if(
           [apiName isEqualToString:@"subscription/setdata"]
           ){
            //NSLog(@"update finished") ;
            [self performSelectorOnMainThread:@selector(hideProgress) withObject:nil waitUntilDone:NO] ;
            //[VeamUtil dispMessage:@"Check App preview!!" title:@"Updated"] ;
            [ConsoleUtil restartHome] ;
        }
    }
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
}


@end
