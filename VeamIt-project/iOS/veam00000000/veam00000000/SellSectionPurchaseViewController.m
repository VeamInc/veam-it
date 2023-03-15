//
//  SellSectionPurchaseViewController.m
//  veam00000000
//
//  Created by veam on 11/25/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellSectionPurchaseViewController.h"
#import "VeamUtil.h"

@interface SellSectionPurchaseViewController ()

@end

@implementation SellSectionPurchaseViewController

@synthesize inAppPurchaseManager ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    inAppPurchaseManager = nil ;
    
    UILabel *label ;
    //isBought = [sellVideo isBought] ;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    //[scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77FFFFFF"]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:scrollView] ;
    
    
    NSString *description = [VeamUtil getSellSectionPaymentDescription] ;
    
    margin = 10 ;
    CGFloat currentY = [VeamUtil getTopBarHeight] ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin,currentY+margin , [VeamUtil getScreenWidth]-margin*2, 1)] ;
    [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]] ;
    [label setTextColor:[VeamUtil getColorFromArgbString:@"FF2E2E30"]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setLineBreakMode:NSLineBreakByWordWrapping] ;
    [label setNumberOfLines:0];
    [label setText:description] ;
    [label sizeToFit] ;
    [scrollView addSubview:label] ;
    
    currentY += label.frame.size.height + margin ;
    
    if(!isBought){
        label = [[UILabel alloc] initWithFrame:CGRectMake(margin,currentY , [VeamUtil getScreenWidth]-margin*2, 40)] ;
        [label setFont:[UIFont fontWithName:@"Times New Roman" size:18]] ;
        [label setTextColor:[VeamUtil getColorFromArgbString:@"FFFFFFFF"]] ;
        [label setBackgroundColor:[VeamUtil getNewVideosTextColor]] ;
        [label setLineBreakMode:NSLineBreakByWordWrapping] ;
        [label setNumberOfLines:0];
        [label setTextAlignment:NSTextAlignmentCenter] ;
        [label setText:[VeamUtil getSellSectionPaymentButtonText]] ;
        [VeamUtil registerTapAction:label target:self selector:@selector(purchaseButtonTapped)] ;
        [scrollView addSubview:label] ;
        
        currentY += label.frame.size.height + margin ;
    }
    
    CGFloat contentsHeight = currentY+[VeamUtil getTabBarHeight] ;
    if(contentsHeight < [VeamUtil getScreenHeight]){
        contentsHeight = [VeamUtil getScreenHeight] ;
    }
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], contentsHeight)] ;
    
    
    purchaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [purchaseView setBackgroundColor:[VeamUtil getColorFromArgbString:@"44000000"]] ;
    [self.view addSubview:purchaseView] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
    CGRect frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [purchaseView addSubview:indicator] ;
    
    [purchaseView setAlpha:0.0] ;
    
    thankyouView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [thankyouView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77FFFFFF"]] ;
    UIImage *image = [VeamUtil imageNamed:@"thankyou.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    UIImageView *thankyouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, ([VeamUtil getScreenHeight]-imageHeight-[VeamUtil getStatusBarHeight])/2, imageWidth, imageHeight)] ;
    [thankyouImageView setImage:image] ;
    [thankyouView addSubview:thankyouImageView] ;
    [thankyouView setAlpha:0.0] ;
    [self.view addSubview:thankyouView] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
    
    [self setViewName:@"AboutSellVideo/"] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)purchaseButtonTapped
{
    [self startPurchase] ;
    if([VeamUtil isVeamConsole]){
        [self showTestPurchase] ;
    } else {
        if(inAppPurchaseManager == nil){
            inAppPurchaseManager = [[InAppPurchaseManager alloc] init] ;
        }
        inAppPurchaseManager.delegate = self ;
        //NSLog(@"purchaseProductWithID : %@",sellVideo.productId) ;
        [inAppPurchaseManager purchaseProductWithID:[VeamUtil getSellSectionProductId]] ;
    }
    
}

- (void)showTestPurchase
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test Purchase" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if(buttonIndex == 0){
        [self unSuccesfullPurchase:@"Cancel" isCanceled:YES] ;
    } else if(buttonIndex == 1){
        // 1388502000 <- 2014/01/01 00:00:00
        // 1403103600 <- 2014/06/19 00:00:00
        // 1403190000 <- 2014/06/20 00:00:00
        // 1577804400 <- 2020/01/01 00:00:00
        [VeamUtil verifySellSectionReceipt:[NSString stringWithFormat:@"TEST_TOKEN_%@",[VeamUtil getSellSectionProductId]] clearIfExpired:YES forced:YES] ;
        [self providePurchasedContent:[VeamUtil getSubscriptionProductId:[VeamUtil getSubscriptionIndex]]] ;
    }
}


- (void)startPurchase
{
    [indicator startAnimating] ;
    [purchaseView setAlpha:1.0] ;
    [VeamUtil setIsPurchasing:YES] ;
}

- (void)endPurchase
{
    [purchaseView setAlpha:0.0] ;
    [indicator stopAnimating] ;
    [VeamUtil setIsPurchasing:NO] ;
    inAppPurchaseManager.delegate = nil ;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if(inAppPurchaseManager != nil){
        inAppPurchaseManager.delegate = nil;
    }
}


#pragma mark - InAppPurchase Delegate Methods
-(void) providePurchasedContent:(NSString *)productID
{
    //NSLog(@"providePurchasedContent %@",productID) ;
    isBought = YES ;
    [VeamUtil setSellVideoPurchased:YES] ;
    
    [indicator stopAnimating] ;
    [indicator setHidden:YES] ;
    
    [thankyouView setAlpha:1.0] ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:3.0] ;
    [UIView setAnimationDelegate:self] ;
    [UIView setAnimationDidStopSelector:@selector(endView)] ;
    [thankyouView setAlpha:0.0] ;
    [UIView commitAnimations] ;
}

-(void)endView
{
    [self endPurchase] ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

-(void) unSuccesfullPurchase:(NSString *)reason isCanceled:(BOOL)isCanceled
{
    //NSLog(@"unSuccesfullPurchase Reason:%@",reason) ;
    [self endPurchase] ;
    if(!isCanceled){
        [VeamUtil dispError:@"Failed to make purchase"] ;
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    SKProduct *product= [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (product)
    {
        NSLog(@"Product title: %@" , product.localizedTitle);
        NSLog(@"Product description: %@" , product.localizedDescription);
        NSLog(@"Product price: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

@end
