//
//  SubscriptionPurchaseViewController.m
//  veam31000000
//
//  Created by veam on 2/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "SubscriptionPurchaseViewController.h"
#import "WebViewController.h"
#import "VeamUtil.h"

@interface SubscriptionPurchaseViewController ()

@end

@implementation SubscriptionPurchaseViewController

@synthesize inAppPurchaseManager ;

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
    // Do any additional setup after loading the view from its nib.
    
    [self setViewName:[NSString stringWithFormat:@"SubscriptionPurchase"]] ;

    inAppPurchaseManager = nil ;
    
    isBought = NO ;
    NSString *storeReceipt = [VeamUtil getStoreReceipt:[VeamUtil getSubscriptionIndex]] ;
    if((storeReceipt != nil) && ![storeReceipt isEqualToString:@""]){
        isBought = YES ;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    //[scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:scrollView] ;
    
    
    NSString *description = [VeamUtil getConfigurationString:[NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_DESCRIPTION_FORMAT,[VeamUtil getSubscriptionIndex]] default:@""] ;
    NSString *note = [VeamUtil getConfigurationString:[NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_NOTE_FORMAT,[VeamUtil getSubscriptionIndex]] default:@""] ;
    link = [VeamUtil getConfigurationString:[NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_LINK_FORMAT,[VeamUtil getSubscriptionIndex]] default:@""] ;

    margin = 10 ;
    CGFloat currentY = [VeamUtil getTopBarHeight] ;
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,currentY+margin , [VeamUtil getScreenWidth]-margin*2, 1)] ;
    [descriptionLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]] ;
    [descriptionLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [descriptionLabel setBackgroundColor:[UIColor clearColor]] ;
    [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setText:description] ;
    [descriptionLabel sizeToFit] ;
    [scrollView addSubview:descriptionLabel] ;
    
    currentY += descriptionLabel.frame.size.height + margin ;

    noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,currentY+margin , [VeamUtil getScreenWidth]-margin*2, 1)] ;
    [noteLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]] ;
    [noteLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [noteLabel setBackgroundColor:[UIColor clearColor]] ;
    [noteLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [noteLabel setNumberOfLines:0];
    [noteLabel setText:note] ;
    [noteLabel sizeToFit] ;
    [scrollView addSubview:noteLabel] ;
    
    currentY += noteLabel.frame.size.height ;
    
    linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,currentY+margin , [VeamUtil getScreenWidth]-margin*2, 1)] ;
    [linkLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]] ;
    [linkLabel setTextColor:[UIColor blueColor]] ;
    [linkLabel setBackgroundColor:[UIColor clearColor]] ;
    [linkLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [linkLabel setNumberOfLines:0];
    [linkLabel setText:link] ;
    [linkLabel sizeToFit] ;
    [VeamUtil registerTapAction:linkLabel target:self selector:@selector(linkTapped)] ;
    [scrollView addSubview:linkLabel] ;
    
    currentY += linkLabel.frame.size.height + margin * 4 ;
    
    if(!isBought){
        buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,currentY , [VeamUtil getScreenWidth]-margin*2, 40)] ;
        [buttonLabel setFont:[UIFont fontWithName:@"Times New Roman" size:18]] ;
        [buttonLabel setTextColor:[VeamUtil getTopBarTitleColor]] ;
        [buttonLabel setBackgroundColor:[VeamUtil getTopBarColor]] ;
        [buttonLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
        [buttonLabel setNumberOfLines:0];
        [buttonLabel setTextAlignment:NSTextAlignmentCenter] ;
        [buttonLabel setText:[VeamUtil getConfigurationString:[NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_BUTTON_TEXT_FORMAT,[VeamUtil getSubscriptionIndex]] default:@"Tap to subscribe"]] ;
        [VeamUtil registerTapAction:buttonLabel target:self selector:@selector(purchaseButtonTapped)] ;
        [scrollView addSubview:buttonLabel] ;
        
        currentY += buttonLabel.frame.size.height + margin ;
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
    [thankyouView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    UIImage *image = [VeamUtil imageNamed:@"thankyou.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    UIImageView *thankyouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, ([VeamUtil getScreenHeight]-imageHeight-[VeamUtil getStatusBarHeight])/2, imageWidth, imageHeight)] ;
    [thankyouImageView setImage:image] ;
    [thankyouView addSubview:thankyouImageView] ;
    [thankyouView setAlpha:0.0] ;
    [self.view addSubview:thankyouView] ;
    
    [self addTopBar:YES showSettingsButton:YES] ;
    
    [self setViewName:@"AboutSubscription/"] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)linkTapped
{
    WebViewController *webViewController = [[WebViewController alloc] init] ;
    [webViewController setUrl:link] ;
    [webViewController setShowBackButton:YES] ;
    [self.navigationController pushViewController:webViewController animated:YES];
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
        [inAppPurchaseManager purchaseProductWithID:[VeamUtil getSubscriptionProductId:[VeamUtil getSubscriptionIndex]]] ;
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
        [VeamUtil verifySubscriptionReceipt:@"TEST_TOKEN_0_1403190000_1577804400" clearIfExpired:YES forced:YES] ;
        //[VeamUtil verifySubscriptionReceipt:@"TEST_TOKEN_0_1577800400_1577804400" clearIfExpired:YES forced:YES] ;
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
    //buyButton.enabled = YES;
    NSLog(@"unSuccesfullPurchase Reason:%@",reason) ;
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

- (void)updateList
{
    NSString *description = [VeamUtil getConfigurationString:[NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_DESCRIPTION_FORMAT,[VeamUtil getSubscriptionIndex]] default:@""] ;
    //NSLog(@"%@::updateList description=%@",NSStringFromClass([self class]),description) ;
    
    margin = 10 ;
    CGFloat currentY = [VeamUtil getTopBarHeight] ;
    [descriptionLabel setNumberOfLines:0] ;
    [descriptionLabel setText:description] ;
    [descriptionLabel sizeToFit] ;
    
    currentY += descriptionLabel.frame.size.height + margin ;
    
    if(!isBought){
        [buttonLabel setFrame:CGRectMake(margin,currentY , [VeamUtil getScreenWidth]-margin*2, 40)] ;
        [buttonLabel setNumberOfLines:0] ;
        [buttonLabel setText:[VeamUtil getConfigurationString:[NSString stringWithFormat:VEAM_CONFIG_SUBSCRIPTION_BUTTON_TEXT_FORMAT,[VeamUtil getSubscriptionIndex]] default:@"Tap to subscribe"]] ;
        [VeamUtil registerTapAction:buttonLabel target:self selector:@selector(purchaseButtonTapped)] ;
        
        currentY += buttonLabel.frame.size.height + margin ;
    }
    
    CGFloat contentsHeight = currentY+[VeamUtil getTabBarHeight] ;
    if(contentsHeight < [VeamUtil getScreenHeight]){
        contentsHeight = [VeamUtil getScreenHeight] ;
    }
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], contentsHeight)] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


@end
