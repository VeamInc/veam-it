//
//  ConsoleSellPdfViewController.m
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleSellPdfViewController.h"

#import "VeamUtil.h"
#import "ConsoleSellPdfTableViewCell.h"
#import "ImageDownloader.h"
#import "ConsoleTutorialViewController.h"
#import "AppDelegate.h"
#import "ConsoleEditSellPdfViewController.h"
#import "ConsoleEditAudioViewController.h"
#import "ConsoleEditSubscriptionDescriptionViewController.h"
#import "ConsoleAddTableViewCell.h"

#define ACTION_SHEET_SELECT_CONTENT_KIND    1
#define ACTION_SHEET_SELECT_PRICE           2

@interface ConsoleSellPdfViewController ()

@end

@implementation ConsoleSellPdfViewController

@synthesize pdfCategory ;
@synthesize pdfSubCategory ;
@synthesize showCustomizeFirst ;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.shouldShowFloatingMenu = YES ;
    }
    return self;
}

- (void)showFloatingMenu
{
    //NSLog(@"%@::showFloatingMenu",NSStringFromClass([self class])) ;
    
    //NSInteger numberOfWaitingMixeds = [[ConsoleUtil getConsoleContents] getNumberOfWaitingMixedForCategory:@"0"] ;
    NSString *badgeString = @"" ;
    /*
     if(numberOfWaitingMixeds > 0){
     badgeString = [NSString stringWithFormat:@"%d",numberOfWaitingMixeds] ;
     }
     */
    
    NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Preview",@"TITLE", @"NO",@"SELECTED",nil] ;
    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Mode",@"TITLE", @"YES",@"SELECTED",badgeString,@"BADGE",nil] ;
    NSArray *elements = [NSArray arrayWithObjects:dictionary1,dictionary2, nil] ;
    [VeamUtil showFloatingMenu:elements delegate:self] ;
    
}

- (void)didTapFloatingMenu:(NSInteger)index
{
    //NSLog(@"%@::didTapFloatingMenu index=%d",NSStringFromClass([self class]),index) ;
    if(index == 0){
        [self handleSwipeRightGesture:nil] ;
    } else if(index == 2){
        [self handleSwipeLeftGesture:nil] ;
    }
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
    
    /*
     prices = [NSArray arrayWithObjects:
     @"$0.99",
     @"$1.99",
     @"$2.99",
     @"$3.99",
     @"$4.99",
     @"$5.99",
     @"$6.99",
     @"$7.99",
     @"$8.99",
     @"$9.99",
     nil] ;
     */
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    /*
     NSString *priceKey = @"subscription_prices" ;
     if([ConsoleUtil isLocaleJapanese]){
     priceKey = @"subscription_prices_ja" ;
     }
     prices = [[contents getValueForKey:priceKey] componentsSeparatedByString:@"|"] ;
     */
    
    needTimer = YES ;
    
    isAppReleased = NO ;
    isSellSection = NO ;
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary] ;
    
    CGFloat currentY = [self addNormalTableView] ;
    [normalTableView setDelegate:self] ;
    [normalTableView setDataSource:self] ;
    [normalTableView setContentInset:UIEdgeInsetsMake(44, 0, 100, 0)] ;
    
    if(showCustomizeFirst){
        [self handleSwipeLeftGesture:nil] ;
    }
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

- (SellPdf *)getSellPdfAt:(NSInteger)index
{
    SellPdf *retValue = nil ;
    retValue = [[ConsoleUtil getConsoleContents] getSellPdfForPdfCategory:pdfCategory.pdfCategoryId at:index order:NSOrderedAscending] ;
    return retValue ;
}

- (void)removeSellPdfAt:(NSInteger)index
{
    [[ConsoleUtil getConsoleContents] removeSellPdfForPdfCategory:pdfCategory.pdfCategoryId at:index] ;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // this will not be called because of HPReorderTableView
    //NSLog(@"numberOfSectionsInTableView") ;
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 0 ;
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *appStatus = contents.appInfo.status ;
    //NSLog(@"appStatus=%@",appStatus) ;
    if([appStatus isEqualToString:VEAM_APP_INFO_STATUS_RELEASED]){
        isAppReleased = YES ;
    }
    
    isSellSection = [contents isCategoryInSellSection:pdfCategory.pdfCategoryId categoryKind:VEAM_SELL_SECTION_CATEGORY_KIND_PDF] ;

    if(section == 0){
        numberOfSellPdfs = [[ConsoleUtil getConsoleContents] getNumberOfSellPdfsForPdfCategory:pdfCategory.pdfCategoryId] ;
        retValue = numberOfSellPdfs + 1 ;
    }
    
    //NSLog(@"numberOfRowsInSection section=%d number=%d",section,retValue) ;
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
    CGFloat retValue = 0 ;
    if(indexPath.row < numberOfSellPdfs){
        retValue = [ConsoleSellPdfTableViewCell getCellHeight] ;
    } else {
        retValue = 44 ; // TODO addCell getCellHeight
    }
    
    return retValue ;
}

- (SellPdf *)getSellPdfFor:(NSIndexPath *)indexPath
{
    SellPdf *retValue = nil ;
    retValue = [self getSellPdfAt:indexPath.row] ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@::cellForRowAtIndexPath section=%d row=%d",NSStringFromClass([self class]),indexPath.section,indexPath.row) ;
    
    UITableViewCell *cell = nil ;
    if(indexPath.row < numberOfSellPdfs){
        BOOL isLast = (indexPath.row == (numberOfSellPdfs-1)) ;
        SellPdf *sellPdf = [self getSellPdfFor:indexPath] ;
        //NSLog(@"sellPdf pdfId=%@ description=%@ status=%@ button=%@",sellPdf.pdfId,sellPdf.description,sellPdf.status,sellPdf.buttonText) ;
        ConsoleSellPdfTableViewCell *sellPdfCell = [[ConsoleSellPdfTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" sellPdf:sellPdf isLast:isLast] ;
        [VeamUtil registerTapAction:sellPdfCell.deleteTapView target:self selector:@selector(didDeleteButtonTap:)] ;
        sellPdfCell.deleteTapView.tag = indexPath.row ;
        
        NSString *thumbnailUrl = [[ConsoleUtil getConsoleContents] getPdfForId:sellPdf.pdfId].imageUrl ;
        //NSLog(@"sellPdf thumbnailUrl=%@",sellPdf.thumbnailUrl) ;
        if(![VeamUtil isEmpty:thumbnailUrl]){
            UIImage *image = [VeamUtil getCachedImage:thumbnailUrl downloadIfNot:NO] ;
            if(image == nil){
                [self startImageDownload:thumbnailUrl forIndexPath:indexPath imageIndex:1] ;
            } else {
                [[sellPdfCell thumbnailImageView] setImage:image] ;
            }
        }
        
        [sellPdfCell setSelectionStyle:UITableViewCellEditingStyleNone] ;
        cell = sellPdfCell ;
    } else {
        ConsoleAddTableViewCell *addCell = [[ConsoleAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" title:NSLocalizedString(@"add_new_pdf",nil) isLast:YES] ;
        cell = addCell ;
    }
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnknownCell"] ;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
        [cell.textLabel setText:@""] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }
    
    return cell;
}

- (void)didDeleteButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger index = singleTapGesture.view.tag ;
    //NSLog(@"delete %d",index) ;
    indexToBeDeleted = index ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] ;
    //[alert setTag:ALERT_VIEW_TAG_REMOVE] ;
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    switch (buttonIndex) {
        case 0:
            // cancel
            break;
        case 1:
            // OK
            [self removeSellPdfAt:indexToBeDeleted] ;
            break;
    }
}

- (BOOL)isAppReleased
{
    return [[ConsoleUtil getConsoleContents] isAppReleased] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath") ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(indexPath.section == 0){
        //NSLog(@"row=%d",indexPath.row) ;
        if(indexPath.row < numberOfSellPdfs){
            // edit
            currentSellPdf = [self getSellPdfFor:indexPath] ;
        } else {
            // new
            ConsoleEditSellPdfViewController *editSellPdfViewController = [[ConsoleEditSellPdfViewController alloc] init] ;
            [editSellPdfViewController setPdfCategory:pdfCategory] ;
            [editSellPdfViewController setTransitionType:VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL] ;
            [editSellPdfViewController setIsSellSection:isSellSection] ;
            [self pushViewController:editSellPdfViewController] ;
        }
    }
}

- (void)reloadValues
{
    [normalTableView reloadData] ;
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload %@",url) ;
    if(![VeamUtil isEmpty:url]){
        NSMutableDictionary *imageDownloadsInProgress ;
        switch (imageIndex) {
            case 1:
                imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
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
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        ConsoleSellPdfTableViewCell *cell = (ConsoleSellPdfTableViewCell *)[normalTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView] ;
        
        
        //NSLog(@"%d width %f",indexPath.row,imageDownloader.pictureImage.size.width) ;
        // Display the newly loaded image
        if(imageIndex == 1){
            cell.thumbnailImageView.image = imageDownloader.pictureImage ;
        }
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"%@::handleSwipeLeftGesture",NSStringFromClass([self class])) ;
    /*
    ConsoleTutorialViewController *viewController = [[ConsoleTutorialViewController alloc] init] ;
    
    if([[ConsoleUtil getConsoleContents].appInfo.status isEqualToString:VEAM_APP_INFO_STATUS_RELEASED]){
        [viewController setTutorialKind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED] ;
    } else {
        [viewController setTutorialKind:VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE] ;
    }
    [viewController setHideHeaderBottomLine:NO] ;
    [viewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK] ;
    [viewController setHeaderTitle:NSLocalizedString(@"exclusive_tutorial", nil)] ;
    [viewController setNumberOfHeaderDots:3] ;
    [viewController setSelectedHeaderDot:2] ;
    [viewController setShowFooter:NO] ;
    [viewController setContentMode:VEAM_CONSOLE_SETTING_MODE] ;
    
    [self pushViewController:viewController] ;
    */
}

- (void)unsetUpdateTimer
{
    if(updateTimer != nil){
        //NSLog(@"updateTimer invalidate") ;
        [updateTimer invalidate] ;
        updateTimer = nil ;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@::viewWillAppear",NSStringFromClass([self class])) ;
    [super viewWillAppear:animated] ;
    
    [[ConsoleUtil getConsoleContents] updatePreparingSellPdfStatus:pdfCategory.pdfCategoryId] ;
    
    [self unsetUpdateTimer] ;
    if(needTimer){
        //NSLog(@"updateTimer scheduledTimerWithTimeInterval") ;
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(handleUpdateTimer:) userInfo:nil repeats:YES] ;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"%@::viewWillDisappear",NSStringFromClass([self class])) ;
    [super viewWillDisappear:animated] ;
    [self unsetUpdateTimer] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"%@::viewDidDisappear",NSStringFromClass([self class])) ;
    [super viewDidDisappear:animated] ;
    [self unsetUpdateTimer] ;
}

-(void)handleUpdateTimer:(NSTimer*)timer
{
    //NSLog(@"%@::handleUpdateTimer",NSStringFromClass([self class])) ;
    if([[AppDelegate sharedInstance] isShowingPreview]){
        [self unsetUpdateTimer] ;
    } else {
        [[ConsoleUtil getConsoleContents] updatePreparingSellPdfStatus:pdfCategory.pdfCategoryId] ;
    }
}

- (void)didTapBack
{
    needTimer = NO ;
    [self unsetUpdateTimer] ;
    [super didTapBack] ;
}

-(void)dealloc
{
    //NSLog(@"%@::dealloc",NSStringFromClass([self class])) ;
}


@end
