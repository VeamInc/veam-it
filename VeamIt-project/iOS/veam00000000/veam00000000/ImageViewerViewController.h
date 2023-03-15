//
//  ImageViewerViewController.h
//  veam31000000
//
//  Created by veam on 8/5/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "ImageDownloader.h"

@interface ImageViewerViewController : VeamViewController<UIScrollViewDelegate,ImageDownloaderDelegate>
{
    UIScrollView *scrollView ;
    UIView *baseView ;
    UIImageView *imageView ;
    ImageDownloader *imageDownloader ;
    UIActivityIndicatorView *indicator ;
}

@property (nonatomic, retain) NSString *url ;

@end
