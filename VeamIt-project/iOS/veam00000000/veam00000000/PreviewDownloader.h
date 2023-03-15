//
//  PreviewDownloader.h
//  veam31000000
//
//  Created by veam on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DownloadableVideo.h"
#import "Video.h"
#import "CustomIOS7AlertView.h"

@protocol PreviewDownloaderDelegate <NSObject>
-(void) previewDownloadCompleted:(Video *)downloadableVideo ;
-(void) previewDownloadCancelled:(Video *)downloadableVideo ;
@end

@interface PreviewDownloader : NSObject<UIAlertViewDelegate,CustomIOS7AlertViewDelegate>{
    
    id<PreviewDownloaderDelegate> delegate;

    NSTimer* timer_ ;
    //DownloadableVideo *downloadableVideo ;
    Video *downloadableVideo ;
    NSManagedObjectContext *mManagedObjectContext ;
    //UIAlertView *mProgressAlertView ;
    CustomIOS7AlertView *mProgressAlertView ;
    UIProgressView* mProgressView ;
    
    NSURLConnection *downloadConnection ;
    NSInteger downloadSize ;
    NSFileHandle *downloadFile ;
    float downloadTotalBytes ;
    float downloadedBytes ;
    float downloadOffset ;
    
}

-(void)onCancel ;
-(PreviewDownloader *)initWithDownloadableVideo:(Video *)targetDownloadableVideo dialogTitle:(NSString *)title dialogDescription:(NSString *)description dialogCancelText:(NSString *)cancel ;


@property(nonatomic, retain) id<PreviewDownloaderDelegate> delegate;


@end
