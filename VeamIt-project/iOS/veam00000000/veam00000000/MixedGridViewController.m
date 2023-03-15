//
//  MixedGridViewController.m
//  veam00000000
//
//  Created by veam on 7/7/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "MixedGridViewController.h"
#import "VeamUtil.h"
#import "MixedGridCell.h"
#import "SubscriptionPurchaseViewController.h"

#define ALERT_VIEW_TAG_DOWNLOAD     1
#define ALERT_VIEW_TAG_REMOVE       2

@interface MixedGridViewController ()

@end

@implementation MixedGridViewController

@synthesize gridView ;

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
    
    [self setViewName:[NSString stringWithFormat:@"MixedGrid"]] ;
    
    isBought = NO ;
    CGFloat deviceHeight = [VeamUtil getScreenHeight] ;
    
    //mixeds = [VeamUtil getMixedsForCategory:@"0"] ;

    imageDownloadsInProgressForSmallImage = [NSMutableDictionary dictionary] ;
    
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, deviceHeight)] ;
    [gradientView setBackgroundColor:[UIColor clearColor]] ;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gradientView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.6f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    gradientView.layer.mask = gradientLayer;
    [self.view addSubview:gradientView] ;
    
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], 320, deviceHeight-[VeamUtil getStatusBarHeight])] ;
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
	self.gridView.autoresizesSubviews = YES ;
	self.gridView.delegate = self ;
	self.gridView.dataSource = self ;
    self.gridView.separatorStyle = AQGridViewCellSeparatorStyleNone;
    self.gridView.showsVerticalScrollIndicator = NO ;
    self.gridView.resizesCellWidthToFit = NO;
    self.gridView.separatorColor = nil;
    
    if([VeamUtil isSubscriptionFree]){
        
//#ifdef DO_NOT_USE_ADMOB
#define ADMOB_BANNER_HEIGHT 1.0
        bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
        [bannerCell setBackgroundColor:[UIColor clearColor]] ;
/*
#else
#define ADMOB_BANNER_HEIGHT 50.0
        bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner] ;
        bannerView.adUnitID = VEAM_ADMOB_UNIT_ID_EXCLUSIVE ;
        bannerView.rootViewController = self ;
        bannerView.delegate = self ;
        [bannerView loadRequest:[VeamUtil getAdRequest]] ;
        bannerCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], ADMOB_BANNER_HEIGHT)] ;
        [bannerCell setBackgroundColor:[UIColor clearColor]] ;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, 300, 1)] ;
        [lineView setBackgroundColor:[UIColor lightGrayColor]] ;
        [bannerCell addSubview:lineView] ;
        [bannerCell addSubview:bannerView] ;
#endif
*/
        
        [self.gridView setGridHeaderView:bannerCell] ;
    }
    
    UIEdgeInsets contentInset = self.gridView.contentInset ;
    contentInset.top = [VeamUtil getTopBarHeight] ;
    contentInset.bottom = [VeamUtil getTabBarHeight] ;
    self.gridView.contentInset = contentInset ;
    
    [gradientView addSubview:self.gridView] ;
    
    [self addTopBar:NO showSettingsButton:YES] ;
    
    
    NSString *skipInitial = [VeamUtil getSkipInitial] ;
    if(![VeamUtil isEmpty:skipInitial] && [skipInitial isEqual:@"1"]){
        poweredView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
        [poweredView setBackgroundColor:[VeamUtil getColorFromArgbString:@"55000000"]] ;
        [self.view addSubview:poweredView] ;
        
        [dummyView = [UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)] ;
        [dummyView setBackgroundColor:[UIColor clearColor]] ;
        [dummyView setCenter:poweredView.center] ;
        [poweredView addSubview:dummyView] ;
        
        /*
        UIImage *poweredImage = [VeamUtil imageNamed:@"mcn_logo.png"] ;
        UIImageView *poweredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, poweredImage.size.width/2, poweredImage.size.height/2)] ;
        [poweredImageView setImage:poweredImage] ;
        [poweredImageView setCenter:poweredView.center] ;
        [poweredView addSubview:poweredImageView] ;
         */
        
        //[poweredView setAlpha:0.0] ;
        shouldShowPowered = YES ;
    }
    
    [self.gridView reloadData] ;
    //[self performSelectorInBackground:@selector(updatePrograms) withObject:nil] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Grid View Data Source

#define GRID_CELL_WIDTH     75.0
#define GRID_CELL_HEIGHT    88.0
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    //NSLog(@"numberOfItemsInGridView") ;
    NSUInteger retInt = 0 ;
    isBought = [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]] ;
    if(isBought){
        //NSLog(@"isBought") ;
        mixeds = [VeamUtil getMixedsForSubscription:YES] ;
        if(mixeds != nil){
            retInt = [mixeds count] ;
            if(retInt < 24){
                retInt = 24 ;
            }
        }
    } else {
        //NSLog(@"not Bought") ;
        mixeds = nil ;
        retInt = 24 ;
    }
    return retInt ;
}

#define GRID_CELL_IDENTIFIER    @"GridCellIdentifier"
- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    AQGridViewCell * cell = nil ;
    MixedGridCell * filledCell = (MixedGridCell *)[aGridView dequeueReusableCellWithIdentifier:GRID_CELL_IDENTIFIER] ;
    if (filledCell == nil){
        filledCell = [[MixedGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, GRID_CELL_WIDTH, GRID_CELL_HEIGHT) reuseIdentifier:GRID_CELL_IDENTIFIER] ;
        filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray ;
    }
    
    int count = 0 ;
    
    Mixed *mixed = nil ;
    if(mixeds != nil){
        count = [mixeds count] ;
        if(index < count){
            mixed = [mixeds objectAtIndex:index] ;
        }
    }
    
    filledCell.image = nil ;
    filledCell.title = @"" ;
    filledCell.year = @"" ;
    
    //NSLog(@"cellForItemAtIndex:%d",index) ;
    
    if(mixed != nil){
        if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_YEAR]){
            filledCell.image = [VeamUtil imageNamed:@"grid_year.png"] ;
            filledCell.year = [mixed title] ;
        } else {
            NSString *smallImageUrl = [mixed thumbnailUrl] ;
            if([VeamUtil isEmpty:smallImageUrl]){
                if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ||
                   [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO]){
                    filledCell.image = [UIImage imageNamed:@"grid_video.png"] ;
                } else if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO] ||
                          [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO]){
                    //NSLog(@"grid_audio.png") ;
                    filledCell.image = [UIImage imageNamed:@"grid_audio.png"] ;
                } else {
                    filledCell.image = [UIImage imageNamed:@"grid_audio.png"] ;
                }
            } else {
                //NSLog(@"image url=%@",smallImageUrl) ;
                UIImage *smallImage = [VeamUtil getCachedImage:smallImageUrl downloadIfNot:NO] ;
                if(smallImage == nil){
                    filledCell.image = [UIImage imageNamed:@"grid_back.png"] ;
                    [self startImageDownload:smallImageUrl forIndexPath:[NSIndexPath indexPathForRow:index inSection:0] imageIndex:0] ;
                } else {
                    filledCell.image = smallImage ;
                }
            }
            //NSLog(@"mixed createdAt = %@",[mixed createdAt]) ;
            if(![VeamUtil isEmpty:mixed.displayType] && [mixed.displayType isEqualToString:@"1"]){
                filledCell.title = mixed.displayName ;
            } else {
                filledCell.title = [VeamUtil getDateString:[NSNumber numberWithInteger:[[mixed createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY] ;
            }
        }
    } else {
        filledCell.image = [UIImage imageNamed:@"grid_back1.png"] ;
        /*
        if((index % 8) == 6){
            //NSLog(@"grid_back2") ;
            filledCell.image = [UIImage imageNamed:@"grid_back2.png"] ;
        } else {
            //NSLog(@"grid_back1") ;
            filledCell.image = [UIImage imageNamed:@"grid_back1.png"] ;
        }
         */
    }
    
    if(count == 0){
        if(index < 24){
            if(index == 0){
                filledCell.image = [VeamUtil imageNamed:@"grid_year.png"] ;
                filledCell.year = @"2017" ;
                filledCell.title = @"" ;
            } else {
                filledCell.image = [VeamUtil imageNamed:[NSString stringWithFormat:@"default_grid_%d.png",index]] ;
                filledCell.year = @"" ;
                filledCell.title = @"----" ;
            }
        }
    }
    
    
    cell = filledCell;
    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(GRID_CELL_WIDTH, GRID_CELL_HEIGHT) );
}

- (void) gridView: (AQGridView *)gridView didSelectItemAtIndex: (NSUInteger) index
{
    //NSLog(@"selected item %d",index) ;
    
    [gridView deselectItemAtIndex:index animated:NO] ;
    
    if(![VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
        [self onInfoButtonTap] ;
        return ;
    }
    
    if(mixeds != nil){
        if(index < [mixeds count]){
            Mixed *mixed = [mixeds objectAtIndex:index] ;
            if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ||
               [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO]){
                //NSLog(@"video") ;
                Video *video = [VeamUtil getVideoForId:mixed.contentId] ;
                if(video != nil){
                    if([VeamUtil videoExists:video]){
                        NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[video createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
                        [VeamUtil playVideo:video title:titleName] ;
                        contentShown = YES ;
                    } else {
                        // confirm download
                        currentVideo = video ;
                        //NSLog(@"video url = %@",[currentVideo dataUrl]) ;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"download_this_video",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
                        [alert setTag:ALERT_VIEW_TAG_DOWNLOAD] ;
                        [alert show];
                    }
                }
            } else if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO] ||
                      [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO]){
                //NSLog(@"audio") ;
                Audio *audio = [VeamUtil getAudioForId:mixed.contentId] ;
                if(audio != nil){
                    NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[audio createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
                    [VeamUtil playAudio:audio title:titleName] ;
                    contentShown = YES ;
                }
            }
        }
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if([alertView tag] == ALERT_VIEW_TAG_DOWNLOAD){
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
            {
                // OK
                // start downloading
                //NSLog(@"video url = %@",[currentVideo dataUrl]) ;
                Video *downloadableVideo = [[Video alloc] init] ;
                [downloadableVideo setVideoId:[currentVideo videoId]] ;
                [downloadableVideo setDataUrl:[currentVideo dataUrl]] ;
                [downloadableVideo setDataSize:[currentVideo dataSize]] ;
                
                previewDownloader = [[PreviewDownloader alloc]
                                     initWithDownloadableVideo:downloadableVideo
                                     dialogTitle:NSLocalizedString(@"PreviewDownloadTitie", nil)
                                     dialogDescription:NSLocalizedString(@"PreviewDownloadDescription",nil)
                                     dialogCancelText:NSLocalizedString(@"cancel",nil)
                                     ] ;
                
                previewDownloader.delegate = self ;
            }
                break;
        }
    }
}

-(void) previewDownloadCompleted:(Video *)downloadableVideo
{
    NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[currentVideo createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
    [VeamUtil playVideo:currentVideo title:titleName] ;
    contentShown = YES ;
}

-(void) previewDownloadCancelled:(Video *)downloadableVideo
{
    
}



- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload") ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 0:
            imageDownloadsInProgress = imageDownloadsInProgressForSmallImage ;
            break;
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

- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 0:
            imageDownloadsInProgress = imageDownloadsInProgressForSmallImage ;
            break;
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath] ;
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        
        //NSLog(@"%d width %f",indexPath.row,pictureDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 0){
            MixedGridCell *cell = (MixedGridCell *)[self.gridView cellForItemAtIndex:indexPath.row] ;
            cell.image = imageDownloader.pictureImage ;
        }
    } else {
        //NSLog(@"imageDownloader is nil") ;
    }
    
    return ;
}

- (void)onInfoButtonTap
{
    //NSLog(@"MessageViewController::onInfoButtonTap") ;
    SubscriptionPurchaseViewController *subscriptionPurchaseViewController = [[SubscriptionPurchaseViewController alloc] initWithNibName:@"SubscriptionPurchaseViewController" bundle:nil] ;
    [subscriptionPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
    [subscriptionPurchaseViewController setTitle:@"About Subscription"] ;
    [self.navigationController pushViewController:subscriptionPurchaseViewController animated:YES] ;
    
}

- (void)updateList
{
    //NSLog(@"%@::updateList",NSStringFromClass([self class])) ;
    [gridView reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"%@::viewDidAppear",NSStringFromClass([self class])) ;
    if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
        if(!isBought){
            isBought = YES ;
            [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
        }
    }
    
    if(shouldShowPowered){
        shouldShowPowered = NO ;
        [UIView beginAnimations:nil context:NULL] ;
        [UIView setAnimationDuration:0.5] ;
        [UIView setAnimationDelegate:self] ;
        [UIView setAnimationDidStopSelector:@selector(hidePowered)] ;
        [dummyView setAlpha:0.0] ;
        [UIView commitAnimations] ;
    }
    
    if(contentShown){
        contentShown = NO ;
        if([VeamUtil isSubscriptionFree]){
            //[VeamUtil kickKiip:@"ViewExclusiveContent"] ;
        }
    }
}

- (void)hidePowered
{
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:2.0] ;
    [poweredView setAlpha:0.0] ;
    [UIView commitAnimations] ;
}


@end
