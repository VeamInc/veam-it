//
//  ConsoleEditSellPdfViewController.m
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleEditSellPdfViewController.h"
#import "ConsoleDropboxViewController.h"
#import "VeamUtil.h"

#define CONSOLE_VIEW_PDF_ID             1
#define CONSOLE_VIEW_TITLE              2
#define CONSOLE_VIEW_SOURCE_URL         3
#define CONSOLE_VIEW_THUMBNAIL_IMAGE    4
#define CONSOLE_VIEW_DESCRIPTION        5
#define CONSOLE_VIEW_PRICE              6

@interface ConsoleEditSellPdfViewController ()

@end

@implementation ConsoleEditSellPdfViewController

@synthesize pdfCategory ;
@synthesize pdfSubCategory ;
@synthesize pdf ;
@synthesize sellPdf ;
@synthesize isSellSection ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_CLOSE|VEAM_CONSOLE_HEADER_STYLE_RIGHT_TEXT] ;
        [self setHeaderRightText:NSLocalizedString(@"confirm",nil)] ;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ConsoleContents *contents = [ConsoleUtil getConsoleContents] ;
    NSString *priceKey = @"subscription_prices" ;
    if([ConsoleUtil isLocaleJapanese]){
        priceKey = @"subscription_prices_ja" ;
    }
    prices = [[contents getValueForKey:priceKey] componentsSeparatedByString:@"|"] ;
    
    CGFloat currentY = [self addMainScrollView] ;
    currentY = [self addContents:currentY] ;
    [self setScrollHeight:currentY] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)addContents:(CGFloat)y
{
    CGFloat currentY = y ;
    
    currentY += [self addSectionHeader:NSLocalizedString(@"upload_pdf_to_veam_cloud",nil) y:currentY] ;
    
    titleInputBarView = [self addTextInputBar:NSLocalizedString(@"title",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_TITLE] ;
    [titleInputBarView setDelegate:self] ;
    currentY += titleInputBarView.frame.size.height ;
    
    sourceUrlInputBarView = [self addDropboxInputBar:NSLocalizedString(@"pdf_data_url",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_SOURCE_URL extensions:DROPBOX_PDF_EXTENSIONS] ;
    [sourceUrlInputBarView setDelegate:self] ;
    currentY += sourceUrlInputBarView.frame.size.height ;
    
    imageUrlInputBarView = [self addDropboxInputBar:NSLocalizedString(@"image_data_url",nil) y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_THUMBNAIL_IMAGE extensions:DROPBOX_IMAGE_EXTENSIONS] ;
    [imageUrlInputBarView setDelegate:self] ;
    currentY += imageUrlInputBarView.frame.size.height ;
    
    if(!isSellSection){
        priceSelectBarView = [self addTextSelectBar:NSLocalizedString(@"ppc_price",nil) selections:prices selectionValues:prices y:currentY fullBottomLine:NO selector:nil tag:CONSOLE_VIEW_PRICE ] ;
        [priceSelectBarView setDelegate:self] ;
        currentY += priceSelectBarView.frame.size.height ;
        
        descriptionInputBarView = [self addLongTextInputBar:NSLocalizedString(@"description",nil) y:currentY height:130 fullBottomLine:YES selector:nil tag:CONSOLE_VIEW_DESCRIPTION] ;
        [descriptionInputBarView setDelegate:self] ;
        currentY += descriptionInputBarView.frame.size.height ;
    }
    
    [self reloadValues] ;
    
    return currentY ;
}

- (void)didTapTitle
{
    
}

- (void)reloadValues
{
    NSString *pdfId = @"" ;
    NSString *title = @"" ;
    NSString *sourceUrl = @"" ;
    NSString *imageUrl = @"" ;
    NSString *description = @"" ;
    NSString *price = @"" ;
    if(pdf != nil){
        pdfId = pdf.pdfId ;
        title = pdf.title ;
        sourceUrl = pdf.sourceUrl ;
        imageUrl = pdf.imageUrl ;
    }
    
    if(sellPdf != nil){
        description = sellPdf.description ;
        price = sellPdf.price ;
    }
    
    //NSLog(@"image url %@",imageUrl) ;
    
    [titleInputBarView setInputValue:title] ;
    [sourceUrlInputBarView setInputValue:sourceUrl] ;
    [imageUrlInputBarView setInputValue:imageUrl] ;
    
    if(!isSellSection){
        [descriptionInputBarView setInputValue:description] ;
        [priceSelectBarView setInputValue:price] ;
    }
}

- (void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(reloadValues) withObject:nil waitUntilDone:NO] ;
}

- (void)didChangeTextInputValue:(ConsoleTextInputBarView *)view value:(NSString *)value
{
    switch (view.tag) {
        case CONSOLE_VIEW_TITLE:
            break;
            
        default:
            break;
    }
}

- (void)didChangeLongTextInputValue:(ConsoleLongTextInputBarView *)view value:(NSString *)value
{
    //NSLog(@"%@::didChangeLongTextInputValue %@",NSStringFromClass([self class]),value) ;
}


- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value
{
    //NSLog(@"%@::didChangeImageInputValue",NSStringFromClass([self class])) ;
    switch (view.tag) {
        case CONSOLE_VIEW_THUMBNAIL_IMAGE:
            //NSLog(@"CONSOLE_VIEW_THUMBNAIL_IMAGE") ;
            thumbnailImage = value ;
            break;
        default:
            break;
    }
}

- (void)didChangeTextSelectValue:(ConsoleTextSelectBarView *)view inputValue:(NSString *)inputValue selectionValue:(NSString *)selectionValue
{
}


- (void)showDropboxViewController:(ConsoleDropboxInputBarView *)view
{
    ConsoleDropboxViewController *dropboxViewController = [[ConsoleDropboxViewController alloc] init] ;
    [dropboxViewController setDelegate:view] ;
    [dropboxViewController setReturnViewController:self] ;
    [dropboxViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
    [dropboxViewController setShowFooter:NO] ;
    [dropboxViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
    [dropboxViewController setDropboxPath:@"/"] ;
    [dropboxViewController setHeaderTitle:@"Dropbox"] ;
    [dropboxViewController setExtensions:view.extensions] ;
    [self pushViewController:dropboxViewController] ;
}









- (BOOL)isValueChanged
{
    BOOL retValue = NO ;
    if((pdf == nil) || (sellPdf == nil)){
        //NSLog(@"new") ;
        retValue = YES ;
    } else {
        NSString *title = [titleInputBarView getInputValue] ;
        NSString *sourceUrl = [sourceUrlInputBarView getInputValue] ;
        NSString *imageUrl = [imageUrlInputBarView getInputValue] ;
        NSString *description = [imageUrlInputBarView getInputValue] ;
        NSString *price = [priceSelectBarView getInputValue] ;
        if(isSellSection){
            if(
               ![title isEqualToString:pdf.title] ||
               ![sourceUrl isEqualToString:pdf.sourceUrl] ||
               ![imageUrl isEqualToString:pdf.imageUrl]
               ){
                //NSLog(@"modified") ;
                retValue = YES ;
            }
        } else {
            if(
               ![title isEqualToString:pdf.title] ||
               ![sourceUrl isEqualToString:pdf.sourceUrl] ||
               ![imageUrl isEqualToString:pdf.imageUrl] ||
               ![description isEqualToString:sellPdf.description] ||
               ![price isEqualToString:sellPdf.price]
               ){
                //NSLog(@"modified") ;
                retValue = YES ;
            }
        }
    }
    
    return retValue ;
}

- (void)didTapRightText
{
    //NSLog(@"%@::didTapRightText",NSStringFromClass([self class])) ;
    if([self isValueChanged]){
        [self saveValues] ;
    } else {
        //NSLog(@"not modified") ;
        [super didTapClose] ;
    }
}

- (void)didTapClose
{
    //NSLog(@"%@::didTapClose",NSStringFromClass([self class])) ;
    
    if([self isValueChanged]){
        [self.view endEditing:YES] ;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init] ;
        actionSheet.delegate = self ;
        actionSheet.title = nil ;
        [actionSheet addButtonWithTitle:@"Save"] ;
        [actionSheet addButtonWithTitle:@"Discard"] ;
        [actionSheet addButtonWithTitle:@"Cancel"] ;
        actionSheet.cancelButtonIndex = 2 ;
        actionSheet.destructiveButtonIndex = 0 ;
        [actionSheet showInView:self.view] ;
    } else {
        //NSLog(@"not modified") ;
        [super didTapClose] ;
    }
}

- (BOOL)saveValues
{
    //NSLog(@"%@::saveValues",NSStringFromClass([self class])) ;
    NSString *title = [titleInputBarView getInputValue] ;
    NSString *sourceUrl = [sourceUrlInputBarView getInputValue] ;
    NSString *imageUrl = [imageUrlInputBarView getInputValue] ;
    NSString *description = [descriptionInputBarView getInputValue] ;
    NSString *price = [priceSelectBarView getInputValue] ;
    
    if(isSellSection){
        description = @"" ;
        price = @"" ;
    }
    
    if([VeamUtil isEmpty:title]){
        [VeamUtil dispError:@"Please input title"] ;
        return NO ;
    }
    if([VeamUtil isEmpty:sourceUrl]){
        [VeamUtil dispError:@"Please input pdf data url"] ;
        return NO ;
    }
    
    if([VeamUtil isEmpty:imageUrl]){
        [VeamUtil dispError:@"Please select image data url"] ;
        return NO ;
    }
    
    if(!isSellSection){
        if([VeamUtil isEmpty:description]){
            [VeamUtil dispError:@"Please input description"] ;
            return NO ;
        }
        
        if([VeamUtil isEmpty:price]){
            [VeamUtil dispError:@"Please input price"] ;
            return NO ;
        }
    }
    
    
    if(pdf == nil){
        //NSLog(@"new pdf c=%@",pdfCategory.pdfCategoryId) ;
        pdf = [[Pdf alloc] init] ;
        if(pdfCategory == nil){
            pdf.pdfCategoryId = @"0" ;
        } else {
            pdf.pdfCategoryId = pdfCategory.pdfCategoryId ;
        }
        
        if(pdfSubCategory == nil){
            pdf.pdfSubCategoryId = @"0" ;
        } else {
            pdf.pdfSubCategoryId = pdfSubCategory.pdfSubCategoryId ;
        }
    }
    
    [pdf setTitle:title] ;
    [pdf setSourceUrl:sourceUrl] ;
    [pdf setImageUrl:imageUrl] ;
    
    if(sellPdf == nil){
        sellPdf = [[SellPdf alloc] init] ;
    }
    [sellPdf setDescription:description] ;
    [sellPdf setPrice:price] ;
    
    [self performSelectorInBackground:@selector(doUpdate) withObject:nil] ;
    
    return YES ;
}

- (void)doUpdate
{
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO] ;
    [[ConsoleUtil getConsoleContents] setSellPdf:sellPdf pdfCategoryId:pdfCategory.pdfCategoryId pdfTitle:pdf.title pdfSourceUrl:pdf.sourceUrl pdfImageUrl:pdf.imageUrl] ;
    [ConsoleUtil updateConsoleContents] ;
    [self performSelectorOnMainThread:@selector(hideProgress) withObject:nil waitUntilDone:NO] ;
    [self performSelectorOnMainThread:@selector(didTapCloseAtSuper) withObject:nil waitUntilDone:NO] ;
}

- (void)didTapCloseAtSuper
{
    [super didTapClose] ;
}

- (void)showProgress
{
    //NSLog(@"%@::showProgress",NSStringFromClass([self class])) ;
    [self showMask:YES] ;
}

- (void)hideProgress
{
    //NSLog(@"%@::hideProgress",NSStringFromClass([self class])) ;
    [self showMask:NO] ;
}



-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Save
            //NSLog(@"save") ;
            [self saveValues] ;
            break ;
        case 1:
            // Discard
            [super didTapClose] ;
            break;
        case 2:
            // Cancel
            //NSLog(@"cancel") ;
            break;
    }
}




@end
