//
//  SettingsViewController.m
//  veam31000000
//
//  Created by veam on 7/25/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "SettingsViewController.h"
#import "VeamUtil.h"
#import "WebViewController.h"
#import "About2ViewController.h"
#import "AppDelegate.h"

#define ALERT_VIEW_TAG_RESTORE          1
#define ALERT_VIEW_TAG_FACEBOOK_LOGOUT  2

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define VEAM_SETTINGS_ROW_HEIGHT    44
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setViewName:@"Settings/"] ;
    
    CGFloat screenWidth = [VeamUtil getScreenWidth] ;

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [self.view addSubview:scrollView] ;
    
    CGFloat labelHeight = 25 ;
    CGFloat currentY = 60 ;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 200, labelHeight)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"account_login",nil)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [scrollView addSubview:label] ;
    currentY += labelHeight ;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [scrollView addSubview:lineView] ;
    currentY += 1 ;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [VeamUtil registerTapAction:backView target:self selector:@selector(onFacebookTap)] ;
    [scrollView addSubview:backView] ;
    
    facebookLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [facebookLeftLabel setBackgroundColor:[UIColor clearColor]] ;
    [facebookLeftLabel setText:@"Facebook"] ;
    [facebookLeftLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [facebookLeftLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [scrollView addSubview:facebookLeftLabel] ;
    
    facebookRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-228, currentY, 200, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [facebookRightLabel setBackgroundColor:[UIColor clearColor]] ;
    [facebookRightLabel setText:NSLocalizedString(@"login",nil)] ;
    [facebookRightLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [facebookRightLabel setTextAlignment:NSTextAlignmentRight] ;
    [facebookRightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [scrollView addSubview:facebookRightLabel] ;

    UIImage *image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, currentY+(VEAM_SETTINGS_ROW_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [scrollView addSubview:imageView] ;
    currentY += VEAM_SETTINGS_ROW_HEIGHT ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [scrollView addSubview:lineView] ;
    currentY += 1 ;
    
    twitterView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [twitterView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [VeamUtil registerTapAction:twitterView target:self selector:@selector(onTwitterTap)] ;
    [scrollView addSubview:twitterView] ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, VEAM_SETTINGS_ROW_HEIGHT, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [twitterView addSubview:lineView] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:@"Twitter"] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [twitterView addSubview:label] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-228, 0, 200, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"login",nil)] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setTextAlignment:NSTextAlignmentRight] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [twitterView addSubview:label] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, (VEAM_SETTINGS_ROW_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [twitterView addSubview:imageView] ;


    currentY += VEAM_SETTINGS_ROW_HEIGHT ;
    currentY += 1 ;
    
    
    
    
    
    
    
    
    
    emailView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [emailView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [VeamUtil registerTapAction:emailView target:self selector:@selector(onEmailTap)] ;
    [scrollView addSubview:emailView] ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, VEAM_SETTINGS_ROW_HEIGHT, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [emailView addSubview:lineView] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:@"Email"] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [emailView addSubview:label] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-228, 0, 200, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"login",nil)] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setTextAlignment:NSTextAlignmentRight] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    [emailView addSubview:label] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, (VEAM_SETTINGS_ROW_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [emailView addSubview:imageView] ;
    
    
    currentY += VEAM_SETTINGS_ROW_HEIGHT ;
    currentY += 1 ;
    

    
    
    
    
    
    
    


    
    currentY += 10 ;
    
    bottomViewY = currentY ;
    
    currentY = 0 ; // reset for bottomView
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, screenWidth, 1)] ; // height will be set later
    [scrollView addSubview:bottomView] ;

    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 200, labelHeight)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"storage_settings",nil)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [bottomView addSubview:label] ;
    currentY += labelHeight ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [bottomView addSubview:lineView] ;
    currentY += 1 ;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [VeamUtil registerTapAction:backView target:self selector:@selector(onRestoreTap)] ;
    [bottomView addSubview:backView] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"restore",nil)] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [bottomView addSubview:label] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, currentY+(VEAM_SETTINGS_ROW_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [bottomView addSubview:imageView] ;
    currentY += VEAM_SETTINGS_ROW_HEIGHT ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [bottomView addSubview:lineView] ;
    currentY += 1 ;

    
    
    currentY += 10 ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 200, labelHeight)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"help",nil)] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [bottomView addSubview:label] ;
    currentY += labelHeight ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [bottomView addSubview:lineView] ;
    currentY += 1 ;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [VeamUtil registerTapAction:backView target:self selector:@selector(onUserGuideTap)] ;
    [bottomView addSubview:backView] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"user_guide",nil)] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [bottomView addSubview:label] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, currentY+(VEAM_SETTINGS_ROW_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [bottomView addSubview:imageView] ;
    currentY += VEAM_SETTINGS_ROW_HEIGHT ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [bottomView addSubview:lineView] ;
    currentY += 1 ;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [VeamUtil registerTapAction:backView target:self selector:@selector(onTermsOfServiceTap)] ;
    [bottomView addSubview:backView] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"terms_of_service",nil)] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [bottomView addSubview:label] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, currentY+(VEAM_SETTINGS_ROW_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [bottomView addSubview:imageView] ;
    currentY += VEAM_SETTINGS_ROW_HEIGHT ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [bottomView addSubview:lineView] ;
    currentY += 1 ;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [backView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [VeamUtil registerTapAction:backView target:self selector:@selector(onAboutThisAppTap)] ;
    [bottomView addSubview:backView] ;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, screenWidth, VEAM_SETTINGS_ROW_HEIGHT)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setText:NSLocalizedString(@"about_this_app",nil)] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [bottomView addSubview:label] ;
    
    image = [VeamUtil imageNamed:@"setting_arrow.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, currentY+(VEAM_SETTINGS_ROW_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
    [imageView setImage:image] ;
    [bottomView addSubview:imageView] ;
    currentY += VEAM_SETTINGS_ROW_HEIGHT ;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, screenWidth, 0.5)] ;
    [lineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [bottomView addSubview:lineView] ;
    currentY += 1 ;
    
    CGRect frame = bottomView.frame ;
    frame.size.height = currentY ;
    [bottomView setFrame:frame] ;
    
    [scrollView setContentSize:CGSizeMake(screenWidth, scrollView.frame.size.height+1)] ;
    
    lockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [lockView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77000000"]] ;
    [lockView setAlpha:0.0] ;
    [self.view addSubview:lockView] ;
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator setAlpha:0.0] ;
    [self.view addSubview:indicator] ;
    
    [self addTopBar:NO showSettingsButton:NO] ;
    
    doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(topBarTitleMaxRight-VEAM_SETTINGS_DONE_WIDTH, 0, VEAM_SETTINGS_DONE_WIDTH, [VeamUtil getTopBarHeight])] ;
    [doneLabel setText:NSLocalizedString(@"done",nil)] ;
    [doneLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
    [doneLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [doneLabel setBackgroundColor:[UIColor clearColor]] ;
    [VeamUtil registerTapAction:doneLabel target:self selector:@selector(onDoneButtonTap)] ;
    [topBarView addSubview:doneLabel] ;
    
    [self refreshInfo] ;
}

- (void)onDoneButtonTap
{
    [VeamUtil showTabBarController:-1] ;
}

- (void)onFacebookTap
{
    //NSLog(@"onFacebookTap") ;
    if(![VeamUtil isLoggedIn]){
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:nil] ;
        //[VeamUtil login] ;
        [VeamUtil openFacebookSession] ;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"warning",nil)
                                                        message:NSLocalizedString(@"logout_warning",nil)
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles: NSLocalizedString(@"cancel",nil),NSLocalizedString(@"logout",nil),nil];
        [alert setTag:ALERT_VIEW_TAG_FACEBOOK_LOGOUT] ;
        [alert show];
    }
}

- (void)onTwitterTap
{
    //NSLog(@"onTwitterTap") ;
    if(![VeamUtil isLoggedIn]){
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:nil] ;
        //[VeamUtil login] ;
        [VeamUtil openTwitterSession] ;
    }
}

- (void)onEmailTap
{
    NSLog(@"onEmailTap") ;
    if(![VeamUtil isLoggedIn]){
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:nil] ;
        //[VeamUtil login] ;
        [VeamUtil openEmailSession] ;
    }
}

- (void)onRestoreTap
{
    //NSLog(@"onRestoreTap") ;
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    
    [lockView setAlpha:1.0] ;
    [self startIndicator] ;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"restore_title",nil)
                                                        message: NSLocalizedString(@"restore_description",nil)
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles: NSLocalizedString(@"cancel",nil),NSLocalizedString(@"restore",nil),nil];
    [alertView setTag:ALERT_VIEW_TAG_RESTORE] ;
    [alertView show] ;
}

- (void)onUserGuideTap
{
    //NSLog(@"onUserGuideTap") ;
    WebViewController *webViewController = [[WebViewController alloc] init] ;
    [webViewController setUrl:[NSString stringWithFormat:@"https://veam.co/top/userguideforapp/?a=%@",[VeamUtil getAppId]]] ;
    [webViewController setTitleName:NSLocalizedString(@"user_guide",nil)] ;
    [webViewController setShowBackButton:YES] ;
    [webViewController setShowSettingsDoneButton:YES] ;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)onTermsOfServiceTap
{
    NSString *urlString = [NSString stringWithFormat:@"https://veam.co/top/termsofserviceforapp/?a=%@&os=i",[VeamUtil getAppId]] ;

    //NSLog(@"onTermsOfServiceTap url=%@",urlString) ;

    WebViewController *webViewController = [[WebViewController alloc] init] ;
    [webViewController setUrl:urlString] ;
    [webViewController setTitleName:NSLocalizedString(@"terms_of_service",nil)] ;
    [webViewController setShowBackButton:YES] ;
    [webViewController setShowSettingsDoneButton:YES] ;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)onAboutThisAppTap
{
    //NSLog(@"onAboutThisAppTap") ;
    About2ViewController *aboutViewController = [[About2ViewController alloc] init] ;
    [aboutViewController setTitleName:NSLocalizedString(@"about_this_app",nil)] ;
    [self.navigationController pushViewController:aboutViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRestore
{
    [lockView setAlpha:1.0] ;
    [doneLabel setAlpha:0.0] ;
    [VeamUtil setIsPurchasing:YES] ;
}

- (void)endRestore
{
    [lockView setAlpha:0.0] ;
    [doneLabel setAlpha:1.0] ;
    [VeamUtil setIsPurchasing:NO] ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clickedButtonAtIndex buttonIndex=%d",buttonIndex) ;
    if(alertView.tag == ALERT_VIEW_TAG_RESTORE){
        if(buttonIndex == 1){ // Restore
            [self startRestore] ;
            handledReceipts = [NSMutableDictionary dictionary] ;
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        } else if(buttonIndex == 0){ // cancel
            [lockView setAlpha:0.0] ;
            [self stopIndicator] ;
        }
    } else if(alertView.tag == ALERT_VIEW_TAG_FACEBOOK_LOGOUT){
        if(buttonIndex == 1){ // OK
            [VeamUtil logoutFromSocial] ;
            [VeamUtil setFacebookUserName:@""] ;
            [facebookRightLabel setText:NSLocalizedString(@"login",nil)] ;
        }
        [self stopIndicator] ;
    }
    alertView.delegate = nil ;
}

-(void)startIndicator
{
    [indicator startAnimating] ;
    [indicator setAlpha:1.0] ;
}

-(void)stopIndicator
{
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
}


#pragma mark - SKProductsRequest delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //NSLog(@"didReceiveResponse") ;
    for (SKProduct *p in response.products) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:p.priceLocale];
        
        /*
        NSString *price = [formatter stringFromNumber:p.price];
       //NSLog(@"price=%@ productid=%@",price,p.productIdentifier) ;
         */
    }
}













- (void)verifyTransaction:(SKPaymentTransaction *)transaction
{
    if([transaction.payment.productIdentifier isEqualToString:[VeamUtil getSubscriptionProductId:[VeamUtil getSubscriptionIndex]]]){
        if(![VeamUtil receiptIsExpired:transaction.transactionReceipt]){
            NSString *base64Receipt = [VeamUtil base64Encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length] ;
            //NSLog(@"receipt=%@",base64Receipt) ;
            BOOL verifyFailed = [VeamUtil verifySubscriptionReceipt:base64Receipt clearIfExpired:NO forced:NO] ;
        }
    } else {
        NSString *jsonObjectString = [VeamUtil base64Encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length] ;
        if([VeamUtil isSellVideoProduct:transaction.payment.productIdentifier]){
            //NSLog(@"sell video") ;
            BOOL verifyStatus = [VeamUtil verifySellVideoReceipt:jsonObjectString clearIfExpired:YES forced:YES] ;
        } else if([VeamUtil isSellPdfProduct:transaction.payment.productIdentifier]){
            BOOL verifyStatus = [VeamUtil verifySellPdfReceipt:jsonObjectString clearIfExpired:YES forced:YES] ;
        } else if([VeamUtil isSellAudioProduct:transaction.payment.productIdentifier]){
            BOOL verifyStatus = [VeamUtil verifySellAudioReceipt:jsonObjectString clearIfExpired:YES forced:YES] ;
        } else if([VeamUtil isSellSectionProduct:transaction.payment.productIdentifier]){
            BOOL verifyStatus = [VeamUtil verifySellSectionReceipt:jsonObjectString clearIfExpired:YES forced:YES] ;
        }
    }
    
    if(transaction.transactionReceipt != nil){
        [handledReceipts setObject:@"1" forKey:transaction.transactionReceipt] ;
    }
}

- (void)handleRestoreTransaction:(SKPaymentTransaction *)transaction
{
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchasing:
            //NSLog(@"SKPaymentTransactionStatePurchasing");
            break;
        case SKPaymentTransactionStatePurchased:
            //NSLog(@"SKPaymentTransactionStatePurchased productId=%@",transaction.payment.productIdentifier);
            [self verifyTransaction:transaction] ;
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        case SKPaymentTransactionStateFailed:
            //NSLog(@"SKPaymentTransactionStateFailed");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        case SKPaymentTransactionStateRestored:
        {
            //NSLog(@"SKPaymentTransactionStateRestored productId=%@",transaction.payment.productIdentifier);
            [self verifyTransaction:transaction] ;
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction] ;
        }
            break;
        default:
            //NSLog(@"unknown transactionState: %d", transaction.transactionState);
            break;
    }
}







#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    //NSLog(@"updatedTransactions") ;
    
    for (SKPaymentTransaction *transaction in transactions) {
        [self handleRestoreTransaction:transaction] ;
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //NSLog(@"paymentQueueRestoreCompletedTransactionsFinished") ;
    /*
    for(SKPaymentTransaction *transaction in queue.transactions){
       //NSLog(@"product id = %@",transaction.payment.productIdentifier) ;
    }
    */

    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionReceipt != nil){
            NSString *flag = [handledReceipts objectForKey:transaction.transactionReceipt] ;
            if([VeamUtil isEmpty:flag] || ![flag isEqualToString:@"1"]){
                //NSLog(@"product id = %@",transaction.payment.productIdentifier) ;
                //NSLog(@"unhandled transaction pid=%@ state=%d",transaction.payment.productIdentifier,(long)transaction.transactionState,SKPaymentTransactionStatePurchased) ;
                [self handleRestoreTransaction:transaction] ;
            }
        }
    }

    //[VeamUtil updateCalendarView] ;
    [self endRestore] ;
    [self stopIndicator] ;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self] ;
    [VeamUtil postContentsUpdateNotification] ;
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
   //NSLog(@"failed to restore") ;
   //NSLog(@"description=%@",[error localizedDescription]) ;
    // リストアの失敗
    [self endRestore] ;
    [self stopIndicator] ;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"Settings::viewDidAppear") ;
    [super viewDidAppear:animated] ;
    if(refreshTimer == nil){
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshInfo) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"Settings::viewDidDisappear") ;
    if(refreshTimer != nil){
        [refreshTimer invalidate] ;
        refreshTimer = nil ;
    }
}


-(void)refreshInfo
{
    //NSLog(@"refreshInfo") ;
    // login 更新
    if([VeamUtil isLoggedIn]){
        if([VeamUtil getSocialUserKind] == SOCIAL_USER_KIND_FACEBOOK){
            [facebookLeftLabel setText:@"Facebook"] ;
        } else if([VeamUtil getSocialUserKind] == SOCIAL_USER_KIND_TWITTER){
            [facebookLeftLabel setText:@"Twitter"] ;
        } else if([VeamUtil getSocialUserKind] == SOCIAL_USER_KIND_EMAIL){
            [facebookLeftLabel setText:@"Email"] ;
        }
        [facebookRightLabel setText:[VeamUtil getSocialUserName]] ;
        [twitterView setAlpha:0.0] ;
        [emailView setAlpha:0.0] ;
    
        CGRect frame = bottomView.frame ;
        frame.origin.y = bottomViewY - VEAM_SETTINGS_ROW_HEIGHT ;
        [bottomView setFrame:frame] ;
    } else {
        [facebookLeftLabel setText:@"Facebook"] ;
        [facebookRightLabel setText:NSLocalizedString(@"login",nil)] ;
        [twitterView setAlpha:1.0] ;
        [emailView setAlpha:1.0] ;

        CGRect frame = bottomView.frame ;
        frame.origin.y = bottomViewY ;
        [bottomView setFrame:frame] ;
    }
}


@end
