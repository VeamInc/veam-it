//
//  SellVideoViewController.m
//  veam31000015
//
//  Created by veam on 4/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellVideoViewController.h"
#import "VeamUtil.h"
#import "SellVideoCellViewController.h"
#import "ImageDownloader.h"
#import "YoutubePlayViewController.h"
#import "WebViewController.h"
#import "ImageViewerViewController.h"
#import "SellVideoPurchaseViewController.h"
#import "SellVideo.h"
#import <QuartzCore/QuartzCore.h>

@interface SellVideoViewController ()

@end

@implementation SellVideoViewController

@synthesize categoryId ;
@synthesize subCategoryId ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"YoutubeViewController::viewDidLoad %@ %@",categoryId,subCategoryId) ;
    
    [self setViewName:[NSString stringWithFormat:@"SellVideoList/"]] ;
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary] ;
    
    sellListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [sellListTableView setDelegate:self] ;
    [sellListTableView setDataSource:self] ;
    [sellListTableView setBackgroundColor:[UIColor clearColor]] ;
    [sellListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [sellListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:sellListTableView] ;
    
    
    
    
    
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
             case 2:
             imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
             break;
             */
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if(imageDownloader == nil){
        //NSLog(@"new imageDownloader") ;
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.imageIndex = imageIndex ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload] ;
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
             case 2:
             imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
             break;
             */
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        SellVideoCell *cell = (SellVideoCell *)[sellListTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.thumbnailImageView.image = imageDownloader.pictureImage ;
            /*
             } else if(imageIndex == 2){
             cell.pictureImageView.image = imageDownloader.pictureImage ;
             */
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    indexOffset = 1 ;
    sellVideos = [VeamUtil getSellVideosForCategory:categoryId] ;
    lastIndex = indexOffset + [sellVideos count] ;
    NSInteger retInt = lastIndex + 1 ;
    return retInt ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.row == 0){
        retValue = [VeamUtil getTopBarHeight] ;
    } else if(indexPath.row == lastIndex){
        retValue = [VeamUtil getTabBarHeight] ;
    } else {
        retValue = 88.0 ; // youtube cell height
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if((indexPath.row == 0) || (indexPath.row == lastIndex)){
        // spacer
        cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
        }
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else {
        NSInteger index = indexPath.row - indexOffset ;
        SellVideo *sellVideo = [sellVideos objectAtIndex:index] ;
        Video *video = [VeamUtil getVideoForId:[sellVideo videoId]] ;
        SellVideoCell *sellVideoCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (sellVideoCell == nil) {
            SellVideoCellViewController *controller = [[SellVideoCellViewController alloc] initWithNibName:@"SellVideoCell" bundle:nil] ;
            sellVideoCell = (SellVideoCell *)controller.view ;
        }
        NSString *title = [video title] ;
        [[sellVideoCell titleLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[sellVideoCell titleLabel] setNumberOfLines:0];
        CGRect frame = [[sellVideoCell titleLabel] frame] ;
        CGFloat orgWidth = frame.size.width ;
        
        [[sellVideoCell titleLabel] setText:@"Title"] ;
        [[sellVideoCell titleLabel] sizeToFit] ;
        frame = [[sellVideoCell titleLabel] frame] ;
        CGFloat lineHeight = frame.size.height ;
        //NSLog(@"line height=%f",lineHeight) ;
        frame.size.width = orgWidth ;
        [[sellVideoCell titleLabel] setFrame:frame] ;
        
        [[sellVideoCell titleLabel] setText:title] ;
        [[sellVideoCell titleLabel] sizeToFit] ;
        
        frame = [[sellVideoCell titleLabel] frame] ;
        if(frame.size.height > lineHeight){
            frame.size.height = lineHeight*2 ;
            [[sellVideoCell titleLabel] setFrame:frame] ;
            [[sellVideoCell titleLabel] setLineBreakMode:UILineBreakModeTailTruncation];
            [[sellVideoCell titleLabel] setNumberOfLines:2];
        } else {
            frame.origin.y += 12 ;
            [[sellVideoCell titleLabel] setFrame:frame] ;
        }
        
        CGRect durationFrame = [[sellVideoCell durationLabel] frame] ;
        durationFrame.origin.y = frame.origin.y + frame.size.height ;
        [[sellVideoCell durationLabel] setFrame:durationFrame] ;
        
        //NSLog(@"height=%f %@",[[sellVideoCell titleLabel] frame].size.height,[youtubeVideo title]) ;
        NSString *durationString = [video duration] ;
        //NSLog(@"duration:%@",durationString) ;
        if((durationString != nil) && ![durationString isEqualToString:@""] && ![durationString isEqualToString:@"0"]){
            [[sellVideoCell durationLabel] setText:[VeamUtil getDurationString:[video duration]]] ;
        } else {
            [[sellVideoCell durationLabel] setAlpha:0.0] ;
        }
        
        if([sellVideo isBought]){
            [sellVideoCell.priceLabel setHidden:YES] ;
            [sellVideoCell.statusLabel setHidden:NO] ;
            [sellVideoCell.statusLabel setText:NSLocalizedString(@"purchased",nil)] ;
            [sellVideoCell.statusLabel setTextColor:[VeamUtil getNewVideosTextColor]] ;
            CGRect statusFrame = sellVideoCell.statusLabel.frame ;
            statusFrame.origin.y = durationFrame.origin.y - 1 ;
            [sellVideoCell.statusLabel setFrame:statusFrame] ;
            if([sellVideo isDownloaded]){
                [sellVideoCell.maskView setHidden:YES] ;
            } else {
                [sellVideoCell.maskView setHidden:NO] ;
                UIImage *priceImage = [VeamUtil imageNamed:@"exclusive_download.png"] ;
                CGFloat imageWidth = priceImage.size.width / 2 ;
                CGFloat imageHeight = priceImage.size.height / 2 ;
                CGRect maskFrame = sellVideoCell.maskView.frame ;
                CGRect statusImageFrame = CGRectMake(maskFrame.origin.x + (maskFrame.size.width - imageWidth) / 2, maskFrame.origin.y + (maskFrame.size.height - imageHeight) / 2, imageWidth, imageHeight) ;
                [sellVideoCell.statusImageView setFrame:statusImageFrame] ;
                [sellVideoCell.statusImageView setImage:priceImage] ;
                [sellVideoCell.statusImageView setHidden:NO] ;
            }
        } else {
            [sellVideoCell.statusLabel setHidden:YES] ;
            [sellVideoCell.maskView setHidden:NO] ;
            NSString *priceText = sellVideo.priceText ;
            if(![VeamUtil isEmpty:priceText]){
                [sellVideoCell.priceLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
                [sellVideoCell.priceLabel setHidden:NO] ;
                [sellVideoCell.priceLabel setText:priceText] ;
                [sellVideoCell.priceLabel setBackgroundColor:[VeamUtil getNewVideosTextColor]] ;
                [[sellVideoCell.priceLabel layer] setCornerRadius:10.0] ;
                sellVideoCell.priceLabel.clipsToBounds = true ;
                CGRect frame = sellVideoCell.priceLabel.frame ;
                CGFloat orgWitdh = frame.size.width ;
                CGSize expectedLabelSize = [priceText sizeWithFont:sellVideoCell.priceLabel.font
                                             constrainedToSize:CGSizeMake(frame.size.width, frame.size.height)
                                                 lineBreakMode:sellVideoCell.priceLabel.lineBreakMode] ;
                //NSLog(@"orgwidth=%f newwidth=%f",frame.size.width,expectedLabelSize.width) ;
                CGFloat margin = 20 ;
                if(orgWitdh > (expectedLabelSize.width+margin)){
                    frame.size.width = expectedLabelSize.width + margin ;
                    frame.origin.x += (orgWitdh - frame.size.width) / 2 ;
                }
                [sellVideoCell.priceLabel setFrame:frame];

            } else {
                [sellVideoCell.priceLabel setHidden:YES] ;
            }
            
            /*
            UIImage *priceImage = [VeamUtil imageNamed:@"exclusive_99c.png"] ;
            CGFloat imageWidth = priceImage.size.width / 2 ;
            CGFloat imageHeight = priceImage.size.height / 2 ;
            CGRect maskFrame = sellVideoCell.maskView.frame ;
            CGRect statusImageFrame = CGRectMake(maskFrame.origin.x + (maskFrame.size.width - imageWidth) / 2, maskFrame.origin.y + (maskFrame.size.height - imageHeight) / 2, imageWidth, imageHeight) ;
            [sellVideoCell.statusImageView setFrame:statusImageFrame] ;
            [sellVideoCell.statusImageView setImage:priceImage] ;
            [sellVideoCell.statusImageView setHidden:NO] ;
             */
        }
        
        NSString *thumbnailUrl = [video imageUrl] ;
        [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
        cell = sellVideoCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    }
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    NSInteger index = indexPath.row - indexOffset ;
    if(index >= 0){
        SellVideo *sellVideo = [sellVideos objectAtIndex:index] ;
        if(sellVideo != nil){
            //NSLog(@"sellVideo tapped : %@ %@",[sellVideo sellVideoId],[sellVideo videoId]) ;
            if([sellVideo isBought]){
                Video *video = [VeamUtil getVideoForId:sellVideo.videoId] ;
                if([sellVideo isDownloaded]){
                    // play
                    [self playVideo:video] ;
                } else {
                    // download
                    // start downloading
                    previewDownloader = [[PreviewDownloader alloc]
                                         initWithDownloadableVideo:video
                                         dialogTitle:NSLocalizedString(@"PreviewDownloadTitie", nil)
                                         dialogDescription:NSLocalizedString(@"PreviewDownloadDescription",nil)
                                         dialogCancelText:NSLocalizedString(@"cancel",nil)
                                         ] ;
                    
                    previewDownloader.delegate = self ;
                }
            } else {
                // purchase
                SellVideoPurchaseViewController *sellVideoPurchaseViewController = [[SellVideoPurchaseViewController alloc] init] ;
                [sellVideoPurchaseViewController setTitleName:NSLocalizedString(@"about_video", nil)] ;
                [sellVideoPurchaseViewController setSellVideo:sellVideo] ;
                [self.navigationController pushViewController:sellVideoPurchaseViewController animated:YES] ;

                //[self purchaseButtonTapped:sellVideo.productId] ;
            }
        }
    }
}

- (void)playVideo:(Video *)video
{
    [VeamUtil playVideo:video title:NSLocalizedString(@"exclusive_video",nil)] ;
    //[VeamUtil playVideo:video] ;
}

-(void) previewDownloadCompleted:(Video *)video
{
    //NSLog(@"download completed. play movie") ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
    [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:NO] ;
    [self playVideo:video] ;
}

-(void) previewDownloadCancelled:(Video *)video
{
    //NSLog(@"download cancelled.") ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
}


/*
-(void)purchaseButtonTapped:(NSString *)productId
{
    [self startPurchase] ;
    if(inAppPurchaseManager == nil){
        inAppPurchaseManager = [[InAppPurchaseManager alloc] init] ;
    }
    inAppPurchaseManager.delegate = self ;
    //[inAppPurchaseManager purchaseProductWithID:VEAM_PRODUCT_ID_BEGINNERS_CALENDAR] ;
    [inAppPurchaseManager purchaseProductWithID:productId] ;
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
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    /*
    if(inAppPurchaseManager != nil){
        inAppPurchaseManager.delegate = nil;
    }
     */
}

/*
#pragma mark - InAppPurchase Delegate Methods
-(void) providePurchasedContent:(NSString *)productID
{
    //NSLog(@"providePurchasedContent %@",productID) ;
    [indicator stopAnimating] ;
    [indicator setHidden:YES] ;
    
    [thankyouView setAlpha:1.0] ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:3.0] ;
    [UIView setAnimationDelegate:self] ;
    [thankyouView setAlpha:0.0] ;
    [UIView commitAnimations] ;
    
    [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:NO] ;
}
*/

-(void)reloadList
{
    //[self endPurchase] ;
    [sellListTableView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:NO] ;
}


- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"viewDidAppear") ;
    [super viewDidAppear:animated] ;
    if([VeamUtil getSellVideoPurchased]){
        [VeamUtil setSellVideoPurchased:NO] ;
        [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:NO] ;
    }
}


/*
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
*/



@end
