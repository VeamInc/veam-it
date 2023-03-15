//
//  ImageViewerViewController.m
//  veam31000000
//
//  Created by veam on 8/5/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "ImageViewerViewController.h"
#import "VeamUtil.h"

@interface ImageViewerViewController ()

@end

@implementation ImageViewerViewController

@synthesize url ;

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
    
    CGRect scrollFrame = CGRectMake(0, [VeamUtil getTopBarHeight], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight] - [VeamUtil getTopBarHeight] - [VeamUtil getTabBarHeight]) ;
    scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [scrollView setShowsHorizontalScrollIndicator:NO] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setMinimumZoomScale:1.0] ;
    [scrollView setMaximumZoomScale:4.0] ;
    [scrollView setDelegate:self] ;
    [self.view addSubview:scrollView] ;
    
    baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollFrame.size.width+1, scrollFrame.size.height+1)] ;
    [baseView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:baseView] ;
    [scrollView setContentSize:CGSizeMake(scrollFrame.size.width+1, scrollFrame.size.height+1)] ;

    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, [VeamUtil getScreenWidth],1)] ;
    UIImage *image = [VeamUtil getCachedImage:url downloadIfNot:NO] ;
    if(image == nil){
        // download in background
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = nil ;
        imageDownloader.imageIndex = 0 ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloader startDownload] ;
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
        CGRect indicatorFrame = indicator.frame ;
        indicatorFrame.origin.x = ([VeamUtil getScreenWidth] - indicatorFrame.size.width) / 2 ;
        indicatorFrame.origin.y = [VeamUtil getTopBarHeight] + ([VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTopBarHeight]-[VeamUtil getTabBarHeight]-indicatorFrame.size.height) / 2 ;
        [indicator setFrame:indicatorFrame] ;
        [indicator startAnimating] ;
        [self.view addSubview:indicator] ;
    } else {
        [self setImage:image] ;
    }
    
    imageView.userInteractionEnabled = YES ;
    /*
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageDoubleTap)];
    doubleTapGesture.numberOfTouchesRequired = 2 ;
     */
    
    //シングルタップ時に"singleTapAction"メソッドを実行する
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageSingleTap)];
    singleTapGesture.numberOfTouchesRequired = 1;
    
    //ダブルタップ時に"singleTapAction"メソッドを実行する
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    //ダブルタップをした時にシングルタップを無効にする
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    [imageView addGestureRecognizer:singleTapGesture];
    [imageView addGestureRecognizer:doubleTapGesture];

    [baseView addSubview:imageView] ;
    [scrollView setScrollEnabled:YES] ;
    
    [self addTopBar:YES showSettingsButton:NO] ;
}

- (void)setImage:(UIImage *)image
{
    CGFloat margin = 15.0 ;
    CGRect scrollFrame = scrollView.frame ;
    CGFloat maxHeight = scrollFrame.size.height - margin * 2 ;
    CGFloat screenWidth = [VeamUtil getScreenWidth] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    
    
    CGFloat newWidth = screenWidth - margin * 2 ;
    CGFloat newHeight = newWidth / imageWidth * imageHeight ;

    //NSLog(@"maxheight=%f iamgeWidth=%f imageHeight=%f newWidth=%f newHeight=%f",maxHeight,imageWidth,imageHeight,newWidth,newHeight) ;
    
    if(maxHeight < newHeight){
        newHeight = maxHeight ;
        newWidth = newHeight / imageHeight * imageWidth ;
    }
    
    CGRect frame = imageView.frame ;
    frame.origin.x = (scrollFrame.size.width - newWidth) / 2 ;
    frame.origin.y = (scrollFrame.size.height - newHeight) / 2 ;
    frame.size.width = newWidth ;
    frame.size.height = newHeight ;
    [imageView setFrame:frame] ;
    [imageView setImage:image] ;
    
    /*
    CGFloat scrollHeight = newHeight ;
    if(scrollHeight <= scrollFrame.size.height){
        scrollHeight = scrollFrame.size.height + 1 ;
    }
    
    //NSLog(@"set size %f %f",scrollFrame.size.height,scrollHeight) ;
    [scrollView setContentSize:CGSizeMake(scrollFrame.size.width+1, scrollHeight)] ;
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //NSLog(@"content size = %f,%f",scrollView.contentSize.width,scrollView.contentSize.height) ;
    
    return baseView ;
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    [indicator setHidden:YES] ;
    [indicator stopAnimating] ;
    
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        [self setImage:imageDownloader.pictureImage] ;
        imageDownloader = nil ;
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

- (CGRect)zoomRectWithScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale ;
    zoomRect.size.width  = scrollView.frame.size.width  / scale ;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0) ;
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0) ;
    
    return zoomRect ;
}

- (void)onImageSingleTap
{
    //NSLog(@"onImageSingleTap") ;
}

- (void)onImageDoubleTap:(UITapGestureRecognizer *)doubleTapGesture
{
    //NSLog(@"onImageDoubleTap") ;
    CGRect zoomRect ;
    if(scrollView.zoomScale > 1.0){
        zoomRect = scrollView.bounds ;
    } else {
        zoomRect = [self zoomRectWithScale:4.0 withCenter:[doubleTapGesture locationInView:scrollView]] ;
    }
    [scrollView zoomToRect:zoomRect animated:YES] ;
}


@end
