//
//  SellAudioViewController.m
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "SellAudioViewController.h"
#import "VeamUtil.h"
#import "SellVideoCellViewController.h"
#import "ImageDownloader.h"
#import "YoutubePlayViewController.h"
#import "ImageViewerViewController.h"
#import "SellAudioPurchaseViewController.h"
#import "SellAudio.h"
#import <QuartzCore/QuartzCore.h>

@interface SellAudioViewController ()

@end

@implementation SellAudioViewController

@synthesize categoryId ;
@synthesize subCategoryId ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"YoutubeViewController::viewDidLoad %@ %@",categoryId,subCategoryId) ;
    
    [self setViewName:[NSString stringWithFormat:@"SellAudioList/"]] ;
    
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
        //NSLog(@"imageDownloader is nil") ;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    indexOffset = 1 ;
    sellAudios = [VeamUtil getSellAudiosForCategory:categoryId] ;
    //NSLog(@"numberOfSellAudios=%d categoryId=%@",[sellAudios count],categoryId) ;
    lastIndex = indexOffset + [sellAudios count] ;
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
        SellAudio *sellAudio = [sellAudios objectAtIndex:index] ;
        Audio *audio = [VeamUtil getAudioForId:[sellAudio audioId]] ;
        SellVideoCell *sellVideoCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
        if (sellVideoCell == nil) {
            SellVideoCellViewController *controller = [[SellVideoCellViewController alloc] initWithNibName:@"SellVideoCell" bundle:nil] ;
            sellVideoCell = (SellVideoCell *)controller.view ;
        }
        NSString *title = [audio title] ;
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
        NSString *durationString = [audio duration] ;
        //NSLog(@"duration:%@",durationString) ;
        if((durationString != nil) && ![durationString isEqualToString:@""] && ![durationString isEqualToString:@"0"]){
            [[sellVideoCell durationLabel] setText:[VeamUtil getDurationString:[audio duration]]] ;
        } else {
            [[sellVideoCell durationLabel] setAlpha:0.0] ;
        }

        
        if([sellAudio isBought]){
            [sellVideoCell.priceLabel setHidden:YES] ;
            [sellVideoCell.statusLabel setHidden:NO] ;
            [sellVideoCell.statusLabel setText:NSLocalizedString(@"purchased",nil)] ;
            [sellVideoCell.statusLabel setTextColor:[VeamUtil getNewVideosTextColor]] ;
            CGRect statusFrame = sellVideoCell.statusLabel.frame ;
            statusFrame.origin.y = durationFrame.origin.y - 1 ;
            [sellVideoCell.statusLabel setFrame:statusFrame] ;
            [sellVideoCell.maskView setHidden:YES] ;
        } else {
            [sellVideoCell.statusLabel setHidden:YES] ;
            [sellVideoCell.maskView setHidden:NO] ;
            NSString *priceText = sellAudio.priceText ;
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
        
        NSString *thumbnailUrl = [audio rectangleImageUrl] ;
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
        SellAudio *sellAudio = [sellAudios objectAtIndex:index] ;
        if(sellAudio != nil){
            //NSLog(@"sellAudio tapped : %@ %@",[sellAudio sellAudioId],[sellAudio audioId]) ;
            if([sellAudio isBought]){
                Audio *audio = [VeamUtil getAudioForId:sellAudio.audioId] ;
                // play
                [self playAudio:audio] ;
            } else {
                // purchase
                SellAudioPurchaseViewController *sellAudioPurchaseViewController = [[SellAudioPurchaseViewController alloc] init] ;
                [sellAudioPurchaseViewController setTitleName:NSLocalizedString(@"about_audio", nil)] ;
                [sellAudioPurchaseViewController setSellAudio:sellAudio] ;
                [self.navigationController pushViewController:sellAudioPurchaseViewController animated:YES] ;
                
                //[self purchaseButtonTapped:sellAudio.productId] ;
            }
        }
    }
}

- (void)playAudio:(Audio *)audio
{
    NSString *audioUrl = [VeamUtil getAudioUrl:audio.audioId] ;
    //NSLog(@"audioUrl=%@",audioUrl) ;
    if(![VeamUtil isEmpty:audioUrl]){
        [VeamUtil playAudio:audio title:audio.title] ;
        /*
        SellAudioWebViewController *webViewController = [[SellAudioWebViewController alloc] init];
        [webViewController setTitleName:audio.title] ;
        [webViewController setTitle:audio.title] ;
        [webViewController setUrl:audioUrl] ;
        [webViewController setAudio:audio] ;
        [webViewController setShowBackButton:YES] ;
        [self.navigationController pushViewController:webViewController animated:YES] ;
         */
    }
}

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
    if([VeamUtil getSellAudioPurchased]){
        [VeamUtil setSellAudioPurchased:NO] ;
        [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:NO] ;
    }
}


@end
