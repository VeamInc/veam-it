//
//  ImageDownloader.h
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate ;

@interface ImageDownloader : NSObject
{
    UIImage *pictureImage ;
    NSString *pictureUrl ;
    NSIndexPath *indexPathInTableView ;
    id <ImageDownloaderDelegate> delegate ;
    NSMutableData *activeDownload ;
    NSURLConnection *imageConnection ;
    NSInteger imageIndex ;
}

@property (nonatomic, retain) UIImage *pictureImage ;
@property (nonatomic, retain) NSString *pictureUrl ;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, retain) id <ImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic, assign) NSInteger imageIndex ;

- (void)startDownload ;
- (void)cancelDownload ;

@end

@protocol ImageDownloaderDelegate
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex ;
@end
