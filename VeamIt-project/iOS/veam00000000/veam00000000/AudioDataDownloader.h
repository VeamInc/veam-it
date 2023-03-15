//
//  AudioDataDownloader.h
//  veam31000014
//
//  Created by veam on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Audio.h"

@protocol AudioDataDownloaderDelegate <NSObject>
-(void) audioDataDownloadProgress:(CGFloat)percentage ;
-(void) audioDataDownloadCompleted:(NSString *)contentId ;
-(void) audioDataDownloadCancelled:(NSString *)contentId ;
@end

@interface AudioDataDownloader : NSObject {
    
    id<AudioDataDownloaderDelegate> delegate;

    NSTimer* timer_;
    Audio *audio ;
    
    NSURLConnection *downloadConnection ;
    NSInteger downloadSize ;
    NSFileHandle *downloadFile ;
    float downloadTotalBytes ;
    float downloadedBytes ;
    float downloadOffset ;
    float progressValue ;
}

-(void)onCancel ;
-(AudioDataDownloader *)initWithAudio:(Audio *)targetAudio delegate:(id<AudioDataDownloaderDelegate>)targetDelegate ;

@property(nonatomic, retain) id<AudioDataDownloaderDelegate> delegate;

@end
