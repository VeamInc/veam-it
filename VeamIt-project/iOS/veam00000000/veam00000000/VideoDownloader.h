//
//  VideoDownloader.h
//  veam31000000
//
//  Created by veam on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"

@protocol VideoDownloaderDelegate <NSObject>
-(void) videoDownloadCompleted:(Video *)video indexPath:(NSIndexPath *)indexPath ;
-(void) videoDownloadProgress:(Video *)video progress:(float)progress indexPath:(NSIndexPath *)indexPath ;
-(void) videoDownloadCancelled:(Video *)video indexPath:(NSIndexPath *)indexPath ;
@end

@interface VideoDownloader : NSObject<UIAlertViewDelegate>{
    
    id<VideoDownloaderDelegate> delegate;

    NSTimer* timer_ ;
    Video *video ;
    NSIndexPath *indexPath ;
    NSManagedObjectContext *mManagedObjectContext ;
    UIAlertView *mProgressAlertView ;
    UIProgressView* mProgressView ;
    
    NSURLConnection *downloadConnection ;
    NSInteger downloadSize ;
    NSFileHandle *downloadFile ;
    float downloadTotalBytes ;
    float downloadedBytes ;
    float downloadOffset ;
    float progress ;
    
}

-(void)onCancel ;
-(VideoDownloader *)initWithVideo:(Video *)targetVideo indexPath:(NSIndexPath *)indexPath delegate:(id<VideoDownloaderDelegate>)targetDelegate ;
- (float)getProgress ;

@property(nonatomic, retain) id<VideoDownloaderDelegate> delegate;


@end
